extends Entidad
class_name EntidadJefe

onready var jugador = Ref.jugador
export (float) var velocidad = 50

enum Estados {IDLE,CHASE,ATTACK}
var estadoActual:int

func decide_state():
	if position.distance_to(jugador.position) > 200:
		estadoActual = Estados.CHASE
	elif position.distance_to(jugador) <= 200:
		estadoActual = Estados.ATTACK
		

		
		
func _physics_process(delta: float) -> void:
	match estadoActual:
		Estados.CHASE:
			walk(position.direction_to(jugador.position))
		Estados.ATTACK:
			pass
	
func action():
	match estadoActual:
		Estados.ATTACK:
			
	
func walk(direction:Vector2): 
	move_and_slide(direction * velocidad)
	
	
	
		
	
