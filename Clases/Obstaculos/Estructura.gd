extends StaticBody2D
class_name Estructura

@export var salud:int = 10
@export var inmortal:bool = true
@export var temperatura:int

func hurt(cantidad:int,incomingDirection:Vector2=Vector2.ZERO):
	if not inmortal:
		salud -= cantidad
		
	if salud <= 0:
		die()
		
func die():
	queue_free()
