package main

import "os"
import "encoding/json"
import "net"
import "fmt"

func check(err error) {
	if err != nil {
		panic(err)
	}
}

type Config struct {
	Playlist 	[]Playlist	`json:"playlist"`
	Playing		int		`json:"playing"`
}

type Playlist struct {
	Title		string		`json:"title"`	
	Link		string		`json:"link"`	
}

func loadConfig() Config {
	userHomeDir, err := os.UserHomeDir()
	check(err)

	configData, err := os.ReadFile(userHomeDir + "/.config/waybar/yt-radio/config")
	check(err)

	var config Config
	err = json.Unmarshal(configData, &config)
	check(err)

	return config
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
	command, err := json.Marshal(map[string][]string{"command": options})
	check(err)

	_, err = ipcConnection.Connection.Write([]byte(string(command) + "\n"))
	check(err)
}

func (ipcConnection *IpcConnection) getCommand(options []string) string {
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

	return responseJson["data"].(string)
}

func main() {
	if len(os.Args) == 0 {
		panic("No arguments passed")
	}
	arg := os.Args[1]
	
	var config 		Config 		= loadConfig()
	var ipcConnection	IpcConnection 	= getIpcConnection()
	
	defer ipcConnection.closeConnection()
	
	switch arg {
	case "play":
		ipcConnection.sendCommand([]string{"loadfile", config.Playlist[config.Playing].Link})
	case "stop":
		ipcConnection.sendCommand([]string{"stop"})
	case "title":
		response := ipcConnection.getCommand([]string{"get_property", "media-title"})
		if len(response) > 30 {
			response = response[:30]
		}
		response += "..."
		
		responseJson, err := json.Marshal(map[string]string{"text": response})
		check(err)
		fmt.Println(string(responseJson))
	}
}
