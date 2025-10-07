extends CharacterBody2D


class_name  Paddle

@export var ball:CharacterBody2D
@export var ui:CanvasLayer

@onready var y_position:float = self.position.y
@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D


@onready var mul = preload("res://assets/powerups/multiple power-up.png")
@onready var shoot = preload("res://assets/powerups/shoot power-up.png")
@onready var size = preload("res://assets/powerups/size power-up.png")
@onready var speed = preload("res://assets/powerups/speed power-up.png")
@onready var extras = preload("res://scenes/extras.tscn")
@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var fire_hit = preload("res://assets/powerups/fire.PNG")
@onready var ice_hit = preload("res://assets/powerups/ice.PNG")
@onready var sounding = $Sounding


var SPEED = 300.0
var input_pos:Vector2 = self.position
var lock_ball = true
var width = 713
var rng = RandomNumberGenerator.new()
var direction:Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('serve'):
			serve_ball()

func _physics_process(delta):
	#print(collision_shape_2d.shape.get_rect().size.x)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	input_pos = get_viewport().get_mouse_position()
	# lock the y-position
	input_pos.y = y_position
	velocity = (input_pos - position) * SPEED * delta
	

	move_and_slide()
	
	if lock_ball:
		lock_ball_to_paddle()



func lock_ball_to_paddle() -> void:
	if ball:
		ball.position = Vector2(position.x, position.y - 30)

func serve_ball() -> void:
	if ball and lock_ball:
		lock_ball = false
		ball.serve()

func ball_velocity_after_bounce(ball_velocity:Vector2, ball_position:Vector2) -> Vector2:
	# new y should be:
	# - negative if the ball on impact is from the top of the paddle
	# - positive if the ball on impact is from the bottom of the paddle
	var new_y:float = -abs(ball_velocity.y) if ball_position.y <= position.y else abs(ball_velocity.y)
	# how far from the center in x-axis was the hit?
	var from_center:float = ball_position.x - position.x
	# new x is calculated by normalizing from_center (ex. 20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: width / 2)
	var new_x:float = from_center / ((width * scale.x) / 2)
	# clamp new_x so it doesn't shoot straight left or right
	new_x = clampf(new_x, -0.9, 0.9)
	return Vector2(new_x, new_y).normalized()

#func get_width():
	var rwidth = collision_shape_2d.shape.get_rect().size.x
	return rwidth


func _on_area_2d_body_entered(body):
	body.disappear()
	sounding.play()
	if body.sprite_2d.texture == size:
		animated_sprite_2d.play("big")
		collision_shape_2d.scale.x = 1.3
	elif body.sprite_2d.texture == speed:
		animated_sprite_2d.play("speed")
		animated_sprite_2d.modulate = Color.WHITE
		collision_shape_2d.scale.x = 1
		SPEED = 700
	elif body.sprite_2d.texture == mul:
		for r in range(1,5):
			var newBall = extras.instantiate()
			get_parent().add_child(newBall)
			newBall.position = Vector2(position.x, position.y - 50)
			newBall.serve()
			await get_tree().create_timer(1).timeout
	elif body.sprite_2d.texture == shoot:
		animated_sprite_2d.play("shooter")
		animated_sprite_2d.modulate = Color.WHITE
		collision_shape_2d.scale.x = 1
		for r in range(1,8):
			var newBull = bullet.instantiate()
			get_parent().add_child(newBull)
			newBull.position = Vector2(position.x, position.y - 20)
			newBull.serve()
			await get_tree().create_timer(1).timeout
			var bricksLeft = get_tree().get_nodes_in_group('Brick')
	
			if bricksLeft.size() == 0 and GameManager.lives != 0:
				velocity = Vector2.ZERO
			
				await get_tree().create_timer(1).timeout
				GameManager.level += 1
				get_tree().reload_current_scene()
	elif body.sprite_2d.texture == ice_hit:
		animated_sprite_2d.modulate = Color.hex(0x00e9ff)
		SPEED = 100
	elif body.sprite_2d.texture == fire_hit:
		if GameManager.lives != 0:
			GameManager.lives -= 1
		ui.set_lives(GameManager.lives)
		if GameManager.lives == 0:
			ball.queue_free()
			ui.gameOver()
			get_tree().paused = true
		
	await get_tree().create_timer(7).timeout
	animated_sprite_2d.play("default")
	collision_shape_2d.scale.x = 1
	animated_sprite_2d.modulate = Color.hex(0x00e9ffee) 
	SPEED = 300
	var bricksLeft = get_tree().get_nodes_in_group('Brick')
	if bricksLeft.size() == 0 and GameManager.lives != 0:
				velocity = Vector2.ZERO
			
				await get_tree().create_timer(1).timeout
				GameManager.level += 1
				get_tree().reload_current_scene()
