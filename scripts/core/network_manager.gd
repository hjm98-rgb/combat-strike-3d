extends Node
## NetworkManager - Real online multiplayer via ENet

signal connected_to_server
signal connection_failed(reason: String)
signal player_joined(player_id: int)
signal player_left(player_id: int)

var peer: ENetMultiplayerPeer
var is_host: bool = false
var my_id: int = 0
var connected: bool = false
var host_port: int = 24200
var max_players: int = 15
var connected_players: Dictionary = {}

func host_game(port: int = 24200) -> bool:
	host_port = port
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_server(host_port, max_players)
	if err != OK:
		connection_failed.emit("无法创建服务器: %d" % err)
		return false
	multiplayer.multiplayer_peer = peer
	is_host = true
	my_id = 1
	connected = true
	connected_players[my_id] = GameManager.player_name
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconnected)
	connected_to_server.emit()
	return true

func join_server(ip: String, port: int = 24200) -> bool:
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(ip, port)
	if err != OK:
		connection_failed.emit("无法连接到服务器: %d" % err)
		return false
	multiplayer.multiplayer_peer = peer
	is_host = false
	connected = true
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconnected)
	connected_to_server.emit()
	return true

func _on_peer_connected(id: int) -> void:
	connected_players[id] = "Player_%d" % id
	player_joined.emit(id)
	if is_host:
		rpc_id(id, "sync_player_list", connected_players)
		rpc("player_joined_notify", id, connected_players[id])

func _on_peer_disconnected(id: int) -> void:
	connected_players.erase(id)
	player_left.emit(id)
	if is_host:
		rpc("player_left_notify", id)

@rpc("any_peer", "call_remote", "reliable")
func player_joined_notify(id: int, name: String) -> void:
	connected_players[id] = name
	player_joined.emit(id)

@rpc("any_peer", "call_remote", "reliable")
func player_left_notify(id: int) -> void:
	connected_players.erase(id)
	player_left.emit(id)

@rpc("any_peer", "call_remote", "reliable")
func sync_player_list(players: Dictionary) -> void:
	connected_players = players

@rpc("authority", "call_remote", "unreliable")
func send_position(pos: Vector3, rot: Vector3) -> void:
	if is_host:
		rpc("receive_position", my_id, pos, rot)

@rpc("any_peer", "call_remote", "unreliable")
func receive_position(player_id: int, pos: Vector3, rot: Vector3) -> void:
	pass

@rpc("authority", "call_remote", "reliable")
func send_shot(origin: Vector3, direction: Vector3) -> void:
	rpc("receive_shot", my_id, origin, direction)

@rpc("any_peer", "call_remote", "reliable")
func receive_shot(shooter_id: int, origin: Vector3, direction: Vector3) -> void:
	pass

func disconnect_network() -> void:
	if peer:
		peer.close()
		multiplayer.multiplayer_peer = null
	connected = false
	is_host = false
	connected_players.clear()
