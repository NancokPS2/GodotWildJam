extends KinematicBody2D
class_name Entidad

var inmortal:bool = false
export (int) var salud

func hurt(cantidad):
	if not inmortal:
		salud -= cantidad

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
