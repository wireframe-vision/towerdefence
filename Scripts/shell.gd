extends RigidBody3D

@onready var AudioPlayer: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_body_entered(_body):
	if not AudioPlayer.playing:
		AudioPlayer.play()
