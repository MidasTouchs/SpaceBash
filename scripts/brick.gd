extends RigidBody2D


class_name Brick

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var cpu_particles_2d = $CPUParticles2D

@onready var red = preload("res://assets/bricks and ball/red.PNG")
@onready var yellow = preload("res://assets/bricks and ball/yellow.PNG")
@onready var blue = preload("res://assets/bricks and ball/blue.PNG")
@onready var power = preload("res://scenes/power_ups.tscn")

@onready var mul = preload("res://assets/powerups/multiple power-up.png")
@onready var shoot = preload("res://assets/powerups/shoot power-up.png")
@onready var size = preload("res://assets/powerups/size power-up.png")
@onready var speed = preload("res://assets/powerups/speed power-up.png")
@onready var fire_hit = preload("res://assets/powerups/fire.PNG")
@onready var ice_hit = preload("res://assets/powerups/ice.PNG")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_size():
	return collision_shape_2d.shape.get_rect().size

func get_width():
	return get_size().x

func hit():
	if sprite_2d.texture == blue:
		sprite_2d.texture = yellow
	elif sprite_2d.texture == yellow:
		sprite_2d.texture = red
	else:
		GameManager.addPoints(1)
		showPow()
		showHit()
		cpu_particles_2d.emitting = true
		sprite_2d.visible = false
		collision_shape_2d.disabled = true
	
	#get_parent().get_node('Camera2D').zoom = Vector2(1.01,1.01)
	#await get_tree().create_timer(0.2).timeout
	#get_parent().get_node('Camera2D').zoom = Vector2(1,1)
	
		var bricksLeft = get_tree().get_nodes_in_group('Brick')
		
		if bricksLeft.size() == 1 and GameManager.lives != 0:
			get_parent().get_node('Ball').velocity = Vector2.ZERO
			
			await get_tree().create_timer(1).timeout
			GameManager.level += 1
			get_tree().reload_current_scene()
		else:
			await get_tree().create_timer(1).timeout
			queue_free()


func showPow():
	var skins = getSkin()
	skins.shuffle()
	
	#var bricksLeft = get_tree().get_nodes_in_group('Brick')
	if GameManager.hits % 7 == 0:
		var newUp = power.instantiate()
		get_parent().add_child(newUp)
		newUp.position = Vector2(position.x, position.y)
		
		var sprite = newUp.get_node('Sprite2D')
		sprite.texture = skins[1]
		return

func showHit():
	var danger = getHit()
	danger.shuffle()
	
	#var bricksLeft = get_tree().get_nodes_in_group('Brick')
	if GameManager.hits % 4 == 0:
		var newUp = power.instantiate()
		get_parent().add_child(newUp)
		newUp.position = Vector2(position.x, position.y)
		
		var sprite = newUp.get_node('Sprite2D')
		sprite.texture = danger[0]
		return

func getSkin():
	var skins = [
		mul,
		shoot,
		size,
		speed
	]
	return skins

func getHit():
	var danger = [
		fire_hit,
		ice_hit
	]
	return danger
