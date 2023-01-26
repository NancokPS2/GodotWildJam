extends KinematicBody2D
class_name Entidad


var controlando:bool = false setget set_controlando #Solo deberia aceptar input si esto es true
var motion = Vector2.ZERO
var temperatura:int 

export (bool) var inmortal = false
export (float) var salud = 50
export (float) var gravedad = 0

export (Dictionary) var multiplicadorElemental = {
	Const.elementos.NINGUNO:1.0,
	Const.elementos.FUEGO:1.0,
	Const.elementos.TIERRA:1.0,
	Const.elementos.AGUA:1.0,
	Const.elementos.AIRE:1.0
}

var temperaturaFusion = 50

func check_temperatura(delta):
	if temperatura > temperaturaFusion:
		hurt( (temperaturaFusion - temperatura) * delta )
		modulate = Color()

func set_controlando(valor):
	controlando = valor
	set_process_unhandled_input(valor)

func _physics_process(delta: float) -> void:
	check_temperatura(delta)
#	if gravedad != 0:
#		motion += Vector2.DOWN * 10 * gravedad * delta

func hurt(cantidad:int,elemento:int=0):
	
	var cantidadFinal = cantidad * multiplicadorElemental[elemento]#Aplicar elemento
	if not inmortal:
		
		salud -= cantidadFinal
		
	if salud <= 0:
		die()
		
func die():
	queue_free()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
