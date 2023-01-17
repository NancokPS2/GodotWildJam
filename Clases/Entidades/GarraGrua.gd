extends Entidad
class_name GarraGrua

onready var dedoDer = $LadoDer
onready var dedoIzq = $LadoIzq

const maxDer = -55.0
const maxIzq = 55.0

var areaDeAgarre:Area2D = Area2D.new()

var estado:int
enum Estados {IDLE,ABRIR,CERRAR}

var objetoAgarrado:Node2D


func _physics_process(delta: float) -> void:
	if dedoDer and dedoIzq:#Si ambos dedos son validos...
		var rotaOriginalIzq:float = $LadoDer.rotation
		var rotaOriginalDer:float = $LadoIzq.rotation
			
		match estado:
			Estados.ABRIR:
				open()
				objetoAgarrado = null
#				print("Izq: " + str($LadoIzq.rotation) + " | Der: " + str($LadoDer.rotation) )
			
			Estados.CERRAR:
				close()
				if test_collision():
					open()
					
		if objetoAgarrado != null:
			objetoAgarrado.position = $Area2D.position

			
#		var colisionIzq = $LadoIzq.test_move($LadoIzq.get_transform(), Vector2.RIGHT * 0.1)
#		var colisionDer = $LadoDer.test_move($LadoDer.get_transform(), Vector2.LEFT * 0.1)
		
				
			
#		$LadoDer.rotation = clamp( rotation, deg2rad(maxDer), deg2rad(0) )
#		$LadoIzq.rotation = clamp( rotation, deg2rad(0), deg2rad(maxIzq) )



func test_collision()->bool:
		var colisionIzq:KinematicCollision2D = $LadoIzq.move_and_collide(Vector2.ZERO, true, true, true)
		var colisionDer:KinematicCollision2D = $LadoDer.move_and_collide(Vector2.ZERO, true, true, true)
#		assert(colisionDer is KinematicCollision2D)
		if colisionIzq.collider == colisionDer.collider:#Si ambos dedos tocan el mismo objeto, agarrarlo
			objetoAgarrado = colisionIzq.collider
			
		if colisionDer is KinematicCollision2D or colisionIzq is KinematicCollision2D:#Si colisiono con algo, revertir el movimiento
			return true
		else:
			return false
	

func open():
	var delta = get_physics_process_delta_time()
	$LadoDer.rotate(-2 * delta)
	$LadoIzq.rotate(2 * delta)
	
func close():
	var delta = get_physics_process_delta_time()
	$LadoDer.rotate(2 * delta)
	$LadoIzq.rotate(-2 * delta)
	
	
		
	
func _unhandled_input(event: InputEvent) -> void:
		
	if Input.is_action_pressed("usar"):
		estado = Estados.ABRIR
	elif Input.is_action_pressed("usar2"):
		estado = Estados.CERRAR
	else:
		estado = Estados.IDLE
		
		
