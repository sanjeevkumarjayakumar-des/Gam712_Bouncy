extends Control

func _on_serverbtn_pressed() -> void:
	if HighLevelNetworkHandler.start_server():
		hide()

func _on_clientbtn_pressed() -> void:
	if HighLevelNetworkHandler.start_client():
		hide()
