extends Node

var can_be_hunter: bool = true
var curr_hunter: String = "A"
var A_score: int = 0
var B_score: int = 0

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)

# Late joiners get the current scores
func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		sync_scores.rpc_id(id, A_score, B_score)

func update_Score(value: String) -> void:
	if not multiplayer.is_server():
		return
	match value:
		"A":
			A_score += 1
		"B":
			B_score += 1
	sync_scores.rpc(A_score, B_score)

@rpc("authority", "call_local", "reliable")
func sync_scores(a: int, b: int) -> void:
	A_score = a
	B_score = b
