extends Node3D

@export var playerRay: RayCast3D
@onready var anim = $AnimationPlayer
var canFire = true
signal squirrelEliminated

var maxAmmo: int = 12
@onready var currentAmmo: int = maxAmmo

func _process(_delta: float) -> void:
	checkForInput()
	updateAmmoLabel()

func updateAmmoLabel():
	$CanvasLayer/Ammo.text = "AMMO: " + str(currentAmmo) + "  /  " + str(maxAmmo)

func checkForInput():
	fire()
	reload()
	
func fire():
	if Input.is_action_just_pressed("Fire") and canFire and not currentAmmo == 0:
		currentAmmo -= 1
		checkForTargetHit("squirrel")
		anim.play("fire")
		canFire = false
		canReload = false
		await anim.animation_finished
		canFire = true

var canReload = true
var reloading = false
func reload():
	if Input.is_action_just_pressed("Reload") and not currentAmmo == maxAmmo and canFire and not reloading:
		canFire = false
		canReload = true
		reloading = true
		anim.play("reload")
		await anim.animation_finished
		var shellsNeeded = maxAmmo - currentAmmo
		for i in range(shellsNeeded):
			if canReload:
				anim.play("load_shell")
				await anim.animation_finished
				currentAmmo += 1
			else:
				return
		
		anim.play("pump")
		await anim.animation_finished
		canFire = true
		reloading = false
			

func checkForTargetHit(group: String):
	if playerRay.is_colliding():
		var target = playerRay.get_collider()
		if target.is_in_group(group):
			owner.owner.squirrelEliminated()
			target.queue_free()
			

func play_sound(sound: AudioStream, volume: int):
	AudioManager.play_sound(sound, volume)
