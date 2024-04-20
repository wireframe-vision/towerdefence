extends CharacterBody3D

var SPEED
var ACCEL = 10
var DAMAGE

@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var breadEatTimer = $breadEatTimer
@export var target: Node
var foundBread = false
var eatingBread = false

func _physics_process(delta):
	
	if not foundBread:
		
		var direction = Vector3()
		
		nav.target_position = target.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		
		move_and_slide()
		
	elif not eatingBread:
		eatingBread = true
		breadEatTimer.start()
		

func _on_bread_eat_timer_timeout() -> void:
	target.Health -= DAMAGE
