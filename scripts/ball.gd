extends CharacterBody2D


@export var Paddle:CharacterBody2D
@export var Brick:RigidBody2D
@export var ui:CanvasLayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var bounce = $Bounce

var speed = 400
var direction:Vector2 = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var last_collider_id


func _ready():
	ui.set_lives(GameManager.lives)
	speed = speed + (20 * GameManager.level)
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		bounce.play()
		var collider:Object = collision.get_collider()
		if handle_velocity_after_collision(collider):
			#audio_player_2d.play_audio(bounce_paddle)
			return
			
		velocity = velocity.bounce(collision.get_normal())
		
		
#		var collider_id = collision.get_collider_id()
#		if collider is Brick:
#			if last_collider_id == collider.get_rid():
#				velocity = velocity.bounce(collision.get_normal())
#			else: 
#				velocity = velocity.bounce(collision.get_normal())
#				last_collider_id = collider.get_rid()
		
		# if the velocity was not handled after collision, just bounce
		#velocity = velocity.bounce(collision.get_normal())
		
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
			GameManager.hits += 1


func serve():
	direction = Vector2(rng.randf_range(-1, 1), -1)
	velocity = direction.normalized()

func handle_velocity_after_collision(object:Object) -> bool:
	# then check if the velocity should be handled
	if object.has_method('ball_velocity_after_bounce'):
		velocity = object.ball_velocity_after_bounce(velocity, position)
		return true
	
	# returning false means that the velocity was not handled
	return false


func gameOver():
	GameManager.lives -= 1
	if GameManager.lives == 0:
		ui.gameOver()
		get_tree().paused = true
		if GameManager.score > SaveLoad.score:
			SaveLoad.score = GameManager.score
			SaveLoad.save_number()
		if GameManager.level > SaveLoad.level:
			SaveLoad.level = GameManager.level
			SaveLoad.save_number()
	else:
		await get_tree().create_timer(1)
		Paddle.lock_ball_to_paddle()
		#get_tree().reload_current_scene()
	ui.set_lives(GameManager.lives)




func _on_deathzone_body_entered(body):
	gameOver()
