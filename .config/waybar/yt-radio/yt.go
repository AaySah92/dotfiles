package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"strings"
)

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func getUserHomeDir() string {
	userHomeDir, err := os.UserHomeDir()
	check(err)

	return userHomeDir
}

type Config struct {
	Playlist 	[]string	`json:"playlist"`
}

type Cache struct {
	Playing		int		`json:"playing"`
}

func readConfig() Config {
	configData, err := os.ReadFile(configDir)
	check(err)

	var config Config
	err = json.Unmarshal(configData, &config)
	check(err)

	return config
}

func readCache() Cache {
	cacheData, err := os.ReadFile(cacheDir)
	check(err)

	var cache Cache
	err = json.Unmarshal(cacheData, &cache)
	check(err)
	
	return cache
}

func writeCache(cache Cache) {
	cacheJson, err := json.Marshal(cache)
	check(err)

	os.WriteFile(cacheDir, []byte(cacheJson), 0644)
}

type IpcConnection struct {
	Connection	net.Conn
}

func getIpcConnection() IpcConnection {
	connection, err := net.Dial("unix", "/tmp/mpvsocket")
	check(err)
	return IpcConnection{Connection: connection}
}

func (ipcConnection *IpcConnection) closeConnection() {
	ipcConnection.Connection.Close()
}

func (ipcConnection *IpcConnection) sendCommand(options []string) {
	commandJson, err := json.Marshal(map[string][]string{"command": options})
	check(err)

	_, err = ipcConnection.Connection.Write([]byte(string(commandJson) + "\n"))
	check(err)
}

func (ipcConnection *IpcConnection) getCommand(options []string) interface{} {
	ipcConnection.sendCommand(options)
	response := make([]byte, 1024)
	n, err := ipcConnection.Connection.Read(response)
	check(err)

	var responseJson map[string]interface{}
	err = json.Unmarshal(response[:n], &responseJson)
	check(err)

	if responseJson["error"].(string) != "success" {
		panic(responseJson["error"].(string))
	}

	return responseJson["data"]
}

func play (cache Cache) {
	ipcConnection.sendCommand([]string{"loadfile", config.Playlist[cache.Playing]})
	writeCache(cache)
}

var configDir		string 		= getUserHomeDir() + "/.config/waybar/yt-radio/config.json"
var cacheDir		string 		= getUserHomeDir() + "/.cache/yt-radio/state.json"
var config		Config 		= readConfig()
var cache 		Cache 		= readCache()
var ipcConnection	IpcConnection	= getIpcConnection()

func main() {
	defer ipcConnection.closeConnection()

	if len(os.Args) == 0 {
		panic("No arguments passed")
	}
	arg := os.Args[1]

	playingFlag := !ipcConnection.getCommand([]string{"get_property", "idle-active"}).(bool)

	switch arg {
	case "toggle":
		if playingFlag {
			ipcConnection.sendCommand([]string{"stop"})
		} else {
			play(cache)
		}
	case "next":
		if playingFlag {
			cache.Playing++
			if cache.Playing >= len(config.Playlist) {
				cache.Playing = 0
			}
			play(cache)
		}
	case "previous":
		if playingFlag {
			cache.Playing--
			if cache.Playing < 0 {
				cache.Playing = len(config.Playlist) - 1
			}
			play(cache)
		}
	case "title":
		var mediaTitle string

		if playingFlag {
			mediaTitle = ipcConnection.getCommand([]string{"get_property", "media-title"}).(string)
			if strings.HasPrefix(mediaTitle, "watch") {
				mediaTitle = "Connecting"
			} else if len(mediaTitle) > 30 {
				mediaTitle = mediaTitle[:30]
			}
			mediaTitle += "..."
		}

		responseJson, err := json.Marshal(map[string]string{"text": mediaTitle})
		check(err)
		fmt.Println(string(responseJson))
	}
}
