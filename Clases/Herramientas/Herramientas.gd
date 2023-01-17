extends Node2D
class_name Herramienta


func _ready() -> void:
	enable(false)

func follow_mouse():
	look_at(get_global_mouse_position())

func equip(user:Node):
	enable(true)

func _input(event: InputEvent) -> void:
	follow_mouse()
	
func enable(activado):#Usado para detener/resumir la funcionalidad de las herramientas
	set_process_unhandled_input(activado)
#	set_process(activado)
	set_process_input(activado)
