extends CanvasLayer
@onready var score: Label = $Control/PanelContainer/HBoxContainer/Score


func _process(_delta: float) -> void:
	
	if multiplayer.is_server():
		score.text = str(GameStateGlobal.hunter_score)
