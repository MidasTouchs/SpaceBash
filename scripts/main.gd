extends Node2D


@onready var brick = preload("res://scenes/brick.tscn")
@onready var red = preload("res://assets/bricks and ball/red.PNG")
@onready var yellow = preload("res://assets/bricks and ball/yellow.PNG")
@onready var blue = preload("res://assets/bricks and ball/blue.PNG")

var cols = 7
var rows = 4
var margin = 52

# Called when the node enters the scene tree for the first time.
func _ready():
	setupLevel()
	GameManager.score_label.show()
	GameManager.level_label.show()


func setupLevel():
	rows = 3 + GameManager.level
	
	if rows > 15:
		rows = 15
	
	for r in rows:
		for c in cols:
			
			var randomNum = randi_range(0,2)
			if randomNum > 0:
			
				var newBrick = brick.instantiate()
				add_child(newBrick)
				newBrick.position = Vector2(margin + (63 * c), 100 + (28 * r))
			
				var sprite = newBrick.get_node('Sprite2D')
				if r <= 3 :
					sprite.texture = red
				elif r <= 7:
					sprite.texture = yellow
				else:
					sprite.texture = blue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bricksLeft = get_tree().get_nodes_in_group('Brick')
	if bricksLeft.size() == 0 and GameManager.lives != 0:
				await get_tree().create_timer(1).timeout
				GameManager.level += 1
				get_tree().reload_current_scene()


func getSkin():
	var skins = [
		red,
		yellow,
		blue
	]


func _on_end_zone_body_entered(body):
	body.queue_free()
