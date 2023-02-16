extends Entidad
class_name JefeSamurai

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var jugador:Jugador = Ref.jugador

#Usar timerDecision.start(tiempoHastaLaSiguienteDecision) para retrasar la siguiente accion del jefe
@onready var timerDecision := Timer.new()
@onready var timerDuele := Timer.new()
@export var velocidad:float = 50

enum Estados {IDLE,CHASE,ATTACK_DOUBLESLASH,SHIELD_STARTUP,SHIELD_HOLD}
var estadoActual:int

var subEstAtacando := false
var	subEstDuele := false



func _ready() -> void:
	super._ready()
	
	add_child(timerDecision)
	add_child(timerDuele)
	
	collision_layer = Const.CollisionLayers.ENEMIGO
	collision_mask = Const.CollisionMasks.ENEMIGO
	
#	animationPlayer.animation_finished.connect(animation_ended)
	add_to_group("ENEMIGO",true)
	Ref.jefes.append(self)
	jugador = Ref.jugador
	
	$Hitbox.immunes.append(self)
	
	timerDecision.timeout.connect(decide_state)
#	timerDuele.timeout.connect( set.bind("subEstDuele",false) )#Cuando este temporizador final
	decide_state()
#	VIDA_CAMBIO.connect( set.bind("subEstDuele",true) )#Recordar que sufrio daño
	VIDA_CAMBIO.connect( Callable(timerDuele,"start").bind(2.5) )#Automaticamente olvidarse del daño luego de un tiempo


func decide_on_animation_end(offset:float=0.0):
	var timeLeft:float = animationPlayer.current_animation_length - animationPlayer.current_animation_position
	timerDecision.start(timeLeft+offset)
#func animation_ended(nombreAnimacion:String):
#	decide_state()
#	pass


var chaseDistance:float = 50
func decide_state():

	if not is_instance_valid(jugador):
		estadoActual = Estados.IDLE
		
	elif subEstDuele:
		estadoActual = Estados.SHIELD_STARTUP
	
	elif position.distance_to(jugador.position) > chaseDistance:
		estadoActual = Estados.CHASE
		
	elif position.distance_to(jugador.position) <= chaseDistance:
		estadoActual = Estados.ATTACK_DOUBLESLASH
		
	
	entered_state()
		

func stun(tiempo:float):
	timerDecision.wait_time += tiempo
		
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	match estadoActual:
		Estados.CHASE:
			velocity = position.direction_to(jugador.position) * velocidad
			
			if velocity.x > 0 and scale != Vector2(1,1):
				scale = Vector2(1,1)
				rotation = 0

			elif velocity.x < 0 and scale == Vector2(1,1):
				scale = Vector2(-1,1)
				
			animationPlayer.play("chase")
			decide_state()
		Estados.ATTACK_DOUBLESLASH:
			pass
			
		Estados.SHIELD_HOLD:
			if timerDuele.is_stopped():#Si termino el temporizador, cambiar de estado
				decide_state()
			
		Estados.IDLE:
			animationPlayer.play("idle")
			jugador = Ref.jugador
			if jugador:
				decide_state()
				
		
			
	move_and_slide()

	
func entered_state():#Llamado UNA vez cuando se cambia de estado
	match estadoActual:
		Estados.ATTACK_DOUBLESLASH:
			animationPlayer.play("attack_doubleslash")
			decide_on_animation_end()
			
		Estados.SHIELD_STARTUP:
			animationPlayer.play("attack_shield_startup")
			animationPlayer.animation_finished.connect(set.bind("estadoActual",Estados.SHIELD_HOLD) )
			
			

	
	
	
		
	
