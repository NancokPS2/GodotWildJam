extends Area2D
class_name Hitbox

signal TARGET_HIT

enum TiposObjetivos { ESTRUCTURA=1<<1,JUGADOR=1<<2,ENEMIGO=1<<3,ENTIDAD=1<<4}

var immunes:Array[Node]
@export var activa:bool = true
@export var poder:int = 1
@export var objetivoValido:TiposObjetivos
@export var autoActivar:bool = true

@export var cooldown:float = 1

@onready var temporizador:Timer = Timer.new()



func _ready() -> void:
	body_entered.connect(trigger)
	
func _physics_process(delta: float) -> void:
	if autoActivar:
		pass
		
	
func force_trigger():
	for body in get_overlapping_bodies():
		trigger(body)

func trigger(target:Node):
	if not activa or immunes.has(target):#Si no esta activa, terminar aqui
		return 
	var tiempoExtra:float = 0.0
	var lastimar:bool = false
	if target.is_in_group("JUGADOR") and objetivoValido && TiposObjetivos.JUGADOR:#Si es un jugador y tiene permitido dañarlo
		lastimar = true
	
	elif target.is_in_group("ENEMIGO") and objetivoValido && TiposObjetivos.ENEMIGO:
		lastimar = true
		
	elif target is Entidad and objetivoValido && TiposObjetivos.ENTIDAD:
		lastimar = true
		
	elif target is Estructura and objetivoValido && TiposObjetivos.ESTRUCTURA:
		lastimar = true
	
	
	while lastimar and get_overlapping_bodies().has(target) and target:#Chekear si el objetivo sigue ahi y es valido
		target.hurt(poder)#Dañar quien sea que entro
		emit_signal("TARGET_HIT",target)
		if cooldown == 0:#Si no hay cooldown, terminar aqui
			return
		else:#Sino, ejecutar
			temporizador.start(cooldown)#Empezar el temporizador
			await temporizador.timeout#Esperar a que termine
			
			var timerInvul = target.get("timerInvul")#Adquirir el temporizador de imunidad del objetivo
			if timerInvul is Timer and not timerInvul.is_stoped():#Si este existe y no se a detenido
				await timerInvul.timeout#Esperar por el
				
		#Una vez termine el temporizador, siempre y cuando el objetivo sigua en su zona, continua dañandolo

