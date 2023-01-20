extends StaticBody2D
class_name Estructura

export (int) var salud = 10
export (bool) var inmortal = true
export (int) var temperatura

func hurt(cantidad:int,incomingDirection:Vector2=Vector2.ZERO):
	if not inmortal:
		salud -= cantidad
		
	if salud <= 0:
		die()
		
func die():
	queue_free()
