extends RigidBody2D
class_name Rigido
var controlando:bool = false setget set_controlando #Solo deberia aceptar input si esto es true

var temperatura:int 
var inmortal:bool = false
export (float) var salud = 50

var temperaturaFusion = 50

func check_temperatura(delta):
	if temperatura > temperaturaFusion:
		hurt( (temperaturaFusion - temperatura) * delta )

func set_controlando(valor):
	controlando = valor
	set_process_unhandled_input(valor)

func _physics_process(delta: float) -> void:
	check_temperatura(delta)

func hurt(cantidad):
	if not inmortal:
		salud -= cantidad
		
	if salud <= 0:
		die()
		
func die():
	queue_free()
