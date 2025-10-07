extends Control



@onready var timer = $Timer
@onready var container = $CanvasLayer/Container
@onready var background_1 = $CanvasLayer/Background1
@onready var back = preload("res://assets/bg/bash cover 2.jpg")
@onready var quit_btn = $CanvasLayer/Container/QuitBtn



# Called when the node enters the scene tree for the first time.
func _ready():
	SaveLoad.load_number()
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_score_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/high.tscn")


func _on_info_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/info.tscn")


func _on_cred_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
	print('yess')



func _on_timer_timeout():
	container.show()
	background_1.texture = back
