extends CanvasLayer


@onready var start = preload("res://scenes/start_menu.tscn")
@onready var label = %Label
@onready var center_container = $CenterContainer
@onready var glow = $Glow
var live:String

func _process(delta):
	label.text = live

func set_lives(lives: int):
	live = str(lives)


func gameOver():
	center_container.show()
	glow.show()

func _on_restart_btn_pressed():
	GameManager.score = 0
	GameManager.level = 1
	GameManager.lives = 3
	get_tree().reload_current_scene()


func _on_pause_btn_pressed():
	$PauseContainer.show()
	get_tree().paused = true


func _on_continue_btn_pressed():
	$PauseContainer.hide()
	get_tree().paused = false


func _on_continue_btn_focus_entered():
	$PauseContainer.hide()
	get_tree().paused = false


func _on_quit_btn_focus_entered():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	get_tree().paused = false
	GameManager.score = 0
	GameManager.lives = GameManager.lives


func _on_restart_btn_focus_entered():
	GameManager.score = 0
	GameManager.level = 1
	GameManager.lives = 3
	get_tree().reload_current_scene()
	get_tree().paused = false
