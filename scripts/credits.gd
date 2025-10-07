extends Control



func _ready():
	GameManager.score_label.hide()
	GameManager.level_label.hide()



func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
