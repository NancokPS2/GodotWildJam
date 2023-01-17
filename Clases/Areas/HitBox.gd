extends Area2D
class_name Hitbox

var activa:bool
var poder:int
var objetivoValido:int

var cooldown:float = 1

onready var temporizador:Timer = Timer.new()

const TiposObjetivos = {
	"ESTRUCTURA":1<<0,#Puertas, paredes, etc
	"DESTRUIBLES":1<<1,#Cajas, objetos varios
	"JUGADOR":1<<2#Solo el jugador
}

func _ready() -> void:
	connect("body_entered",self,"trigger")
	

func trigger(target):
	if not activa:#Si no esta activa, terminar aqui
		return 
		
	temporizador.start(cooldown)
	var lastimar:bool = false
	if target is Jugador and objetivoValido && TiposObjetivos.JUGADOR:#Si es un jugador y tiene permitido dañarlo
		lastimar = true
	
	elif target is Entidad and objetivoValido && TiposObjetivos.DESTRUIBLES:
		lastimar = true
		
	elif target is Estructura and objetivoValido && TiposObjetivos.ESTRUCTURA:
		lastimar = true
	
	
	while lastimar and get_overlapping_bodies().has(target) and target:#Chekear si el objetivo sigue ahi y es valido
		target.hurt(poder)#Dañar quien sea que entro
		temporizador.start()#Empezar el temporizador
		yield(temporizador,"timeout")#Esperar a que termine
		#Una vez termine el temporizador, siempre y cuando el objetivo sigua en su zona, continua dañandolo

