extends RigidBody2D




#func _enter_tree() -> void:
#	set_multiplayer_authority(name.to_int())



func _physics_process(_delta: float) -> void:
	
	
#	if !is_multiplayer_authority():
#		return
	
	
	if Input.is_action_just_pressed("LeftPush"):
		#apply_impulse(Vector2(-300,5),Vector2(10,0))
		pass
		
	elif Input.is_action_just_pressed("RightPush"):
		#apply_impulse(Vector2(300,5),Vector2(-10,0))
		pass
		
	elif Input.is_action_just_pressed("UpPush"):
		apply_impulse(Vector2(5,-300),Vector2(0,10))
		


		
	
