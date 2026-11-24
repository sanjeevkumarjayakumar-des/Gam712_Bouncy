extends Control


func _on_serverbtn_pressed() -> void:
	HighLevelNetworkHandler.start_server()


func _on_clientbtn_pressed() -> void:
	HighLevelNetworkHandler.start_client()
