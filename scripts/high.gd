extends Control


@onready var score = $Score

func _ready():
	score.text = "HIGHSCORE \n \n" + "Level: \n" + str(SaveLoad.level) + "\n" + "Score: \n" + str(SaveLoad.score)
	GameManager.score_label.hide()
	GameManager.level_label.hide()


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

