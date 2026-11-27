extends Node

const PORT: int = 40001
const MAX_CLIENTS: int = 4

var ip_address: String = "localhost" # change to the host's IP to play across machines
var peer: ENetMultiplayerPeer

func _ready() -> void:
	multiplayer.peer_connected.connect(func(id): print("Peer joined: ", id))
	multiplayer.peer_disconnected.connect(func(id): print("Peer left: ", id))
	multiplayer.connection_failed.connect(func(): print("Connection failed"))
	multiplayer.server_disconnected.connect(func(): print("Server went away"))

func start_server() -> bool:
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_server(PORT, MAX_CLIENTS)
	if err != OK:
		push_error("Server failed: %s" % error_string(err))
		return false
	multiplayer.multiplayer_peer = peer
	return true

func start_client() -> bool:
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(ip_address, PORT)
	if err != OK:
		push_error("Client failed: %s" % error_string(err))
		return false
	multiplayer.multiplayer_peer = peer
	return true
