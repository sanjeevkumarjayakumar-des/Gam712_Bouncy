extends MultiplayerSpawner

@export var network_player: PackedScene
@export var spawn_origin: Vector2 = Vector2.ZERO
@export var spawn_spacing: float = 150.0

var _spawn_count: int = 0

func _ready() -> void:
	# Must be set on ALL peers
	spawn_function = _spawn_custom
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)

func _add_player(id: int) -> void:
	if not multiplayer.is_server():
		return

	var make_hunter: bool = GameStateGlobal.can_be_hunter
	GameStateGlobal.can_be_hunter = false

	var pos: Vector2 = spawn_origin + Vector2(spawn_spacing * _spawn_count, 0)
	_spawn_count += 1

	spawn({"id": id, "is_hunter": make_hunter, "pos": pos})

# Runs on every peer, with the same data
func _spawn_custom(data: Dictionary) -> Node:
	var player: Node = network_player.instantiate()
	player.name = str(data.id)
	player.is_hunter = data.is_hunter
	player.position = data.pos
	return player

func _remove_player(id: int) -> void:
	if not multiplayer.is_server():
		return

	var node: Node = get_node(spawn_path).get_node_or_null(str(id))
	if node:
		node.queue_free()
