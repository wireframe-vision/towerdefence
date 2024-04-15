extends Node3D

@export_category("Wave")
@export var wave_number: int
@export_range(1.0, 10.0) var squirrel_spawn_min: float
@export_range(1.0, 10.0) var squirrel_spawn_max: float
@export var wave_spawn_multi: float
@export var squirrel_per_wave: int
@export var squirrel_per_wave_multi: float
var currentWave: int = 1
var squirrelsEliminated: int = 0

@export_category("Squirrel")
@export var squirrel_speed: float
@export var squirrel_speed_multi: float
@export var squirrel_damage: int
var canSpawn = true

@onready var timer = $SquirrelSpawnTimer
@onready var spawnPoints = $SquirrelSpawnPoints
@onready var squirrel = preload("res://Scenes/squirrel.tscn")
@onready var couch = $NavigationRegion3D/Environment/Visuals/couch


func _ready() -> void:
	randomize()
	#start()
	endGame(true)

@onready var waveLabel = $CanvasLayer/HBoxContainer/WaveLabel
@onready var elimsLabel: Label = $CanvasLayer/HBoxContainer/ElimsLabel
@onready var reqElimsLabel: Label = $CanvasLayer/HBoxContainer/ReqElimsLabel

func _process(_delta: float) -> void:
	waveLabel.text = "WAVE: %s" % currentWave
	elimsLabel.text = "ELIMS: %s" % squirrelsEliminated
	reqElimsLabel.text = "NEEDED ELIMS: %s" % squirrel_per_wave

func start():
	timer.start(randi_range(squirrel_spawn_min, squirrel_spawn_max))
	
func spawnSquirrel() -> void:
	if not squirrelsEliminated == squirrel_per_wave and canSpawn:
		var newSquirrel = squirrel.instantiate()
		newSquirrel.name = str($Characters.get_child_count() + 1) + " squirrel"
		newSquirrel.global_position = getRandomSpawn()
		newSquirrel.target = couch
		newSquirrel.SPEED = squirrel_speed
		newSquirrel.DAMAGE = squirrel_damage
		$Characters.add_child(newSquirrel)
	
func getRandomSpawn():
	return spawnPoints.get_child(randi_range(0, spawnPoints.get_child_count() - 1)).global_position

func increaseWave():
	if not wave_number == currentWave:
		currentWave += 1
		squirrel_per_wave *= squirrel_per_wave_multi
		squirrel_spawn_min *= wave_spawn_multi
		squirrel_spawn_max *= wave_spawn_multi
		squirrelsEliminated = 0
		squirrel_speed *= squirrel_speed_multi
		canSpawn = false
		await get_tree().create_timer(2.0).timeout
		canSpawn = true
		
	else:
		endGame(true)

func squirrelEliminated():
	squirrelsEliminated += 1
	if squirrelsEliminated == squirrel_per_wave:
		increaseWave()

func _on_squirrel_spawn_timer_timeout() -> void:
	spawnSquirrel()

func endGame(won):
	$CanvasLayer/AnimationPlayer.play("fade")
	await $CanvasLayer/AnimationPlayer.animation_finished
	if won:
		get_tree().change_scene_to_file("res://Scenes/victory.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/loss.tscn")
