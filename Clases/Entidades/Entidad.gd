extends KinematicBody2D
class_name Entidad

var temperatura:int 
var inmortal:bool = false
export (float) var salud

var temperaturaFusion = 50

func check_temperatura(delta):
	if temperatura > temperaturaFusion:
		hurt( (temperaturaFusion - temperatura) * delta )

func _physics_process(delta: float) -> void:
	check_temperatura(delta)

func hurt(cantidad):
	if not inmortal:
		salud -= cantidad

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
