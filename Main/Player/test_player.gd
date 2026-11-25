extends RigidBody2D

@onready var statlabel: Label = $Sprite2D/statlabel

var is_hunter: bool = true
var can_be_tagged: bool = not is_hunter

func _ready() -> void:
	if is_hunter:
		statlabel.text = "Hunter"
	else:
		statlabel.text = "Player"
		

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())



func _physics_process(_delta: float) -> void:
	
	
	if !is_multiplayer_authority():
		return
	
	
	if Input.is_action_just_pressed("LeftPush"):
		apply_impulse(Vector2(-150,5),Vector2(10,0))
		#pass
		
	elif Input.is_action_just_pressed("RightPush"):
		apply_impulse(Vector2(150,5),Vector2(-10,0))
		#pass
		
	elif Input.is_action_just_pressed("UpPush"):
		apply_impulse(Vector2(5,-300),Vector2(0,10))
		


		


func _on_tag_area_player_body_entered(body: Node2D) -> void:
	if is_hunter:
		if body.has_method("check_if_taggable"):
			body.call("check_if_taggable")



func check_if_taggable():
	if can_be_tagged:
		print("you got Tagged by another player !!")
		get_tree().call_deferred("reload_current_scene")
		#queue_free()
	


		
