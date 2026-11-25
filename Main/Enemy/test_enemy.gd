extends RigidBody2D



var is_hunter:bool = true

var can_be_tagged: bool = not is_hunter



func check_if_taggable():
	if can_be_tagged:
		print("you Tagged another player !!")
		get_tree().reload_current_scene()
		#queue_free()
	


func _on_tag_area_enemy_body_entered(body: Node2D) -> void:
	if is_hunter:
		if body.has_method("check_if_taggable"):
			body.call("check_if_taggable")
