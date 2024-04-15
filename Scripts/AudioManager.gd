extends Node

func play_sound(stream: AudioStream, volume: int):
	var instance = AudioStreamPlayer.new()
	instance.volume_db = volume
	instance.stream = stream
	add_child(instance)
	instance.play()
