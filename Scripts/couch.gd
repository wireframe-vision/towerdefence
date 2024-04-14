extends Node3D

var Health = 100
@onready var bread = $Bread
@onready var healthLabel = $CanvasLayer/Label

func _process(delta: float) -> void:
	healthLabel.text = "BREAD: %s HP" % Health

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	body.foundBread = true
