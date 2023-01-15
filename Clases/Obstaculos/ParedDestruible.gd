extends Pared
class_name ParedDestruible

export (int) var salud = 10

func damage(cantidad:int,incomingDirection:Vector2=Vector2.ZERO):
	salud -= cantidad
	
