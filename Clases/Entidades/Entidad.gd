extends KinematicBody2D
class_name Entidad

signal VIDA_CAMBIO

var controlando:bool = false setget set_controlando #Solo deberia aceptar input si esto es true
var motion = Vector2.ZERO
var temperatura:int 

export (bool) var inmortal = false
export (float) var gravedad = 0
export (float) var tiempoInvul = 0
var timerInvul:Timer = Timer.new()


var estadisticasBase:Dictionary
export (Dictionary) var estadisticas = {
	"salud":10,
	"saludMaxima":10,
	"energia":10,
	"energiaMaxima":10,
	"fuerza":10,
	"agilidad":10,
	"resistencia":10,
	"dashCooldown":0.4,
	"dashDistance":2500
}

func _init() -> void:
	estadisticasBase = estadisticas.duplicate()

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
	
	if not inmortal and timerInvul.is_stopped():	
		estadisticas.salud = min(estadisticas.salud - cantidadFinal, estadisticas.saludMaxima)
		timerInvul.start(tiempoInvul)
		emit_signal("VIDA_CAMBIO",self)
		
	if estadisticas.salud <= 0:
		die()
		
func die():
	queue_free()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
