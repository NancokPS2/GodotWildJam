extends Entidad
class_name EntidadJefe

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var jugador = Ref.jugador
export (float) var velocidad = 50

enum Estados {IDLE,CHASE,ATTACK}
var estadoActual:int

var subEstados = {
	"atacando":false
}



func _ready() -> void:
	animationPlayer.connect("animation_finished",self,"animation_ended")
	add_to_group("ENEMIGO",true)
	Ref.jefes.append(self)

func animation_ended(nombreAnimacion:String):
	decide_state()
	pass


var chaseDistance:float = 50
func decide_state():
	
	if jugador == null:
		estadoActual = Estados.IDLE
	
	if position.distance_to(jugador.position) > chaseDistance:
		estadoActual = Estados.CHASE
		
	elif position.distance_to(jugador.position) <= chaseDistance:
		estadoActual = Estados.ATTACK
		
	
	entered_state()
		

		
		
func _physics_process(delta: float) -> void:
	match estadoActual:
		Estados.CHASE:
			walk(position.direction_to(jugador.position))
			animationPlayer.play("chase")
		Estados.ATTACK:
			pass
		Estados.IDLE:
			animationPlayer.play("idle")
			if jugador:
				decide_state()
			
		

	
func entered_state():#Llamado UNA vez cuando se cambia de estado
	match estadoActual:
		Estados.ATTACK:
			animationPlayer.play("attack")
			
			
	
func walk(direccion:Vector2): 
	move_and_slide(direccion * velocidad)
	
	
	
		
	
