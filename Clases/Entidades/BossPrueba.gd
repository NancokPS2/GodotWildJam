extends Entidad
class_name EntidadJefe

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var jugador:Jugador = Ref.jugador
@export var velocidad:float = 50

enum Estados {IDLE,CHASE,ATTACK}
var estadoActual:int

var subEstados = {
	"atacando":false
}



func _ready() -> void:
	animationPlayer.animation_finished.connect(animation_ended)
	add_to_group("ENEMIGO",true)
	Ref.jefes.append(self)

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
		

		
		
func _physics_process(delta: float) -> void:
	match estadoActual:
		Estados.CHASE:
			velocity = position.direction_to(jugador.position) * velocidad
			animationPlayer.play("chase")
		Estados.ATTACK:
			pass
		Estados.IDLE:
			animationPlayer.play("idle")
			if jugador:
				decide_state()
			
	move_and_slide()

	
func entered_state():#Llamado UNA vez cuando se cambia de estado
	match estadoActual:
		Estados.ATTACK:
			animationPlayer.play("attack")
			
			

	
	
	
		
	
