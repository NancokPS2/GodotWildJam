extends Node2D
class_name Entidad

export (int) var salud

func hurt(cantidad):
	salud -= cantidad
