extends Node2D
class_name Herramienta

export (Texture) var textura = load("res://icon.png")


	

func enable(activado):#Usado para detener la funcionalidad de las herramientas
	set_process_unhandled_input(activado)
#	set_process(activado)
	set_process_input(activado)