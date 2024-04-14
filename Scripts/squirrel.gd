extends CharacterBody3D

var SPEED = 2
var ACCEL = 10

@onready var nav : NavigationAgent3D = $NavigationAgent3D


func _physics_process(delta):
	
	var direction = Vector3()
	
	nav.target_position = $"../target".global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
	
	move_and_slide()
