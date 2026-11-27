extends RigidBody2D

@onready var statlabel: Label = $Sprite2D/statlabel

var on_air: bool


var is_hunter: bool = false:
	set(value):
		is_hunter = value
		if is_node_ready():
			_update_label()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	_update_label()
	if not is_multiplayer_authority():
		freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
		freeze = true

func switch_hunter() -> void:
	if GameStateGlobal.curr_hunter == "A":
		GameStateGlobal.curr_hunter = "B"
	else:
		GameStateGlobal.curr_hunter = "A"

func _update_label() -> void:
	if is_hunter:
		statlabel.text = "Hunter"
		$Sprite2D.self_modulate = Color(0.672, 0.0, 0.0, 1.0)
	else:
		statlabel.text = "Player"
		$Sprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func can_be_tagged() -> bool:
	return not is_hunter

# Runs on every peer. Only the server is allowed to trigger it.
@rpc("any_peer", "call_local", "reliable")
func set_hunter(value: bool) -> void:
	if multiplayer.get_remote_sender_id() not in [0, 1]:
		return
	is_hunter = value  # the setter updates the label and color

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return

	if Input.is_action_just_pressed("RightPush"):
		apply_impulse(Vector2(-300, 5), Vector2(10, 0))
	elif Input.is_action_just_pressed("LeftPush"):
		apply_impulse(Vector2(300, 5), Vector2(-10, 0))
	elif Input.is_action_just_pressed("UpPush") :
			apply_impulse(Vector2(5, -600), Vector2(0, 10))
			#on_air = true

func _on_tag_area_player_body_entered(body: Node2D) -> void:
	if not multiplayer.is_server() or not is_hunter:
		return
	if body != self and body.has_method("can_be_tagged") and body.can_be_tagged():
		print("Player ", body.name, " was tagged by ", name)
		switch_hunter()
		body.set_hunter.rpc(true)
		set_hunter.rpc(false)
