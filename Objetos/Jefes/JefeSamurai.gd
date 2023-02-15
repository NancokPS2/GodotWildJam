extends Entidad
class_name JefeSamurai

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var jugador:Jugador = Ref.jugador

#Usar timerDecision.start(tiempoHastaLaSiguienteDecision) para retrasar la siguiente accion del jefe
@onready var timerDecision := Timer.new()
@export var velocidad:float = 50

enum Estados {IDLE,CHASE,ATTACK_DOUBLESLASH,SHIELD}
var estadoActual:int

var subEstados = {
	"atacando":false
}


func _ready() -> void:
	add_child(timerDecision)
	collision_layer = Const.CollisionLayers.ENEMIGO
	collision_mask = Const.CollisionMasks.ENEMIGO
	
#	animationPlayer.animation_finished.connect(animation_ended)
	add_to_group("ENEMIGO",true)
	Ref.jefes.append(self)
	jugador = Ref.jugador
	
	$Hitbox.immunes.append(self)
	
	timerDecision.timeout.connect(decide_state)
	decide_state()


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
			
			

	
	
	
		
	
