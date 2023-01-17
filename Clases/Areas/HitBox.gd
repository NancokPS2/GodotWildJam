extends Area2D
class_name Hitbox

var activa:bool = false
var poder:int = 1
var objetivoValido:int = 0

var cooldown:float = 1

onready var temporizador:Timer = Timer.new()

const TiposObjetivos = {
	"ESTRUCTURA":1<<0,#Puertas, paredes, etc
	"RIGIDO":1<<1,#Cajas, objetos varios rigidos
	"JUGADOR":1<<2,#Solo el jugador
	"ENTIDAD":1<<3#Entidades excluyendo el jugador
}

func _ready() -> void:
	connect("body_entered",self,"trigger")
	
func force_trigger():
	for body in get_overlapping_bodies():
		trigger(body)

func trigger(target):
	if not activa:#Si no esta activa, terminar aqui
		return 
		
	temporizador.start(cooldown)
	var lastimar:bool = false
	if target is Jugador and objetivoValido && TiposObjetivos.JUGADOR:#Si es un jugador y tiene permitido dañarlo
		lastimar = true
	
	elif target is Entidad and objetivoValido && TiposObjetivos.ENTIDAD:
		lastimar = true
		
	elif target is Rigido and objetivoValido && TiposObjetivos.RIGIDO:
		lastimar = true
		
	elif target is Estructura and objetivoValido && TiposObjetivos.ESTRUCTURA:
		lastimar = true
	
	
	while lastimar and get_overlapping_bodies().has(target) and target:#Chekear si el objetivo sigue ahi y es valido
		target.hurt(poder)#Dañar quien sea que entro
		if cooldown == 0:#Si no hay cooldown, terminar aqui
			return
		else:#Sino, ejecutar
			temporizador.start()#Empezar el temporizador
			yield(temporizador,"timeout")#Esperar a que termine
		#Una vez termine el temporizador, siempre y cuando el objetivo sigua en su zona, continua dañandolo

