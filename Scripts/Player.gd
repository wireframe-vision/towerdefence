extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 6.5
const SENSITIVITY = 0.005
const ACCEL = 50.0

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

var mouse_mov : = Vector2.ZERO
var sway_lerp = 5

@export var sway_normal : = Vector3.ZERO

@onready var Head = $Head
@onready var camera = $Head/Camera3D
@onready var Hand = $Head/Camera3D/Hand

@onready var footStepsAudio: AudioStreamPlayer3D = $PlayerAudio/FootStep

var gravity = 9.8

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _process(delta):
	
	if mouse_mov != null:
		var rot : = Vector3(
			clamp(sway_normal.x + mouse_mov.y * 5, -3, 3),
			clamp(sway_normal.y + mouse_mov.x * 5, -10, 10),
			sway_normal.z
		)
		Hand.rotation_degrees = Hand.rotation_degrees.lerp(rot, delta * sway_lerp)
		mouse_mov = Vector2.ZERO
	

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
		velocity.z = move_toward(velocity.z, 0, ACCEL * delta)
	
	if direction != Vector3() :
		if is_on_floor():
			_play_FootStep_Audio()
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _play_FootStep_Audio() -> void:
	if not footStepsAudio.playing:
		footStepsAudio.pitch_scale = randf_range(0.8, 1.2)
		footStepsAudio.play()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
