extends Entidad
class_name JefePrueba

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var jugador:Jugador = Ref.jugador

#Usar timerDecision.start(tiempoHastaLaSiguienteDecision) para retrasar la siguiente accion del jefe
@onready var timerDecision := Timer.new()
@export var velocidad:float = 50

enum Estados {IDLE,CHASE,ATTACK}
var estadoActual:int

var subEstados = {
	"atacando":false
}


func _ready() -> void:
	collision_layer = Const.CollisionLayers.ENEMIGO
	collision_mask = Const.CollisionMasks.ENEMIGO
	
	animationPlayer.animation_finished.connect(animation_ended)
	add_to_group("ENEMIGO",true)
	Ref.jefes.append(self)
	jugador = Ref.jugador
	
	$Hitbox.immunes.append(self)
	
	timerDecision.timeout.connect(decide_state)
	decide_state()

func animation_ended(nombreAnimacion:String):
	decide_state()
	pass


var chaseDistance:float = 50
func decide_state():

	if not is_instance_valid(jugador):
		estadoActual = Estados.IDLE
	
	elif position.distance_to(jugador.position) > chaseDistance:
		estadoActual = Estados.CHASE
		
	elif position.distance_to(jugador.position) <= chaseDistance:
		estadoActual = Estados.ATTACK
		
	
	entered_state()
		

func stun(tiempo:float):
	timerDecision.wait_time += tiempo
		
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	match estadoActual:
		Estados.CHASE:
			velocity = position.direction_to(jugador.position) * velocidad
			animationPlayer.play("chase")
		Estados.ATTACK:
			pass
		Estados.IDLE:
			animationPlayer.play("idle")
			jugador = Ref.jugador
			if jugador:
				decide_state()
			
	move_and_slide()

	
func entered_state():#Llamado UNA vez cuando se cambia de estado
	match estadoActual:
		Estados.ATTACK:
			animationPlayer.play("attack")
			
			

	
	
	
		
	
