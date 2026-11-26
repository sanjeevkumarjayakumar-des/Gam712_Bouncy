extends CanvasLayer

@onready var score_a: Label = $Control/PanelContainer/MarginContainer/hbox/HBoxContainer/ScoreA

@onready var score_b: Label = $Control/PanelContainer/MarginContainer/hbox/HBoxContainer2/ScoreB

func _process(_delta: float) -> void:

		score_a.text = str(GameStateGlobal.A_score)
		score_b.text = str(GameStateGlobal.B_score)
