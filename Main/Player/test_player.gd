extends RigidBody2D

@onready var statlabel: Label = $Sprite2D/statlabel


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

func _update_label() -> void:
	statlabel.text = "Hunter" if is_hunter else "Player"

func can_be_tagged() -> bool:
	return not is_hunter

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return

	if Input.is_action_just_pressed("LeftPush"):
		apply_impulse(Vector2(-150, 5), Vector2(10, 0))
	elif Input.is_action_just_pressed("RightPush"):
		apply_impulse(Vector2(150, 5), Vector2(-10, 0))
	elif Input.is_action_just_pressed("UpPush"):
		apply_impulse(Vector2(5, -300), Vector2(0, 10))

func _on_tag_area_player_body_entered(body: Node2D) -> void:
	if not multiplayer.is_server() or not is_hunter:
		return
	if body != self and body.has_method("can_be_tagged") and body.can_be_tagged():
		print("Player ", body.name, " was tagged by ", name)
		GameStateGlobal.hunter_score+= 1
		print(GameStateGlobal.hunter_score)
		
		
