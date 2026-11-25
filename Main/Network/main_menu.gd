extends CanvasLayer


@onready var joinbtn: Button = %Joinbtn
@onready var quitbtn: Button = %Quitbtn


const WORLD = preload("uid://dlohngny8l11b")

const PLAYER = preload("uid://1d4sek6u7vv7")



func on_join():
	print("Joining world !!")
	var new_player = PLAYER.instantiate()
	get_tree().current_scene.add_child(new_player)
	#add_world()
	hide()
	

func add_world():
	print("adding World")
	var new_world = WORLD.instantiate()
	get_tree().current_scene.add_child(new_world)
	


func _on_joinbtn_pressed() -> void:
	on_join()


func _on_quitbtn_pressed() -> void:
	pass # Replace with function body.
