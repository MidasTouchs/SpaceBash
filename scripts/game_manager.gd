extends Node



@onready var level_label = $CanvasLayer/LevelLabel
@onready var score_label = $CanvasLayer/ScoreLabel


var score = 0
var level = 1
var lives = 3
var hits = 1

func addPoints(points):
	score += points

func _process(delta):
	score_label.text = str(score)
	level_label.text = "Level: " + str(level)
