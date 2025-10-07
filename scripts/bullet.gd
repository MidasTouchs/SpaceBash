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
			
		velocity = velocity.bounce(collision.get_normal())
		
		
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
			GameManager.hits += 1
			queue_free()
			
		queue_free()


func serve():
	direction = Vector2(0, -1)
	velocity = direction.normalized()
