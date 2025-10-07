extends CharacterBody2D


var speed = 400
var direction:Vector2 = Vector2.ZERO
var rng = RandomNumberGenerator.new()

func _ready():
	speed = speed + (20 * GameManager.level)
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
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

func _process(delta):
	if GameManager.lives == 0:
		queue_free()

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
