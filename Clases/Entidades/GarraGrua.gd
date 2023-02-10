extends Entidad
class_name GarraGrua

@onready var dedoDer = $LadoDer
@onready var dedoIzq = $LadoIzq

@onready var tipDer = $LadoDer/Tip
@onready var tipIzq = $LadoIzq/Tip

const maxRotDer = deg_to_rad(-55.0)
const maxRotIzq = deg_to_rad(55.0)

var areaDeAgarre:Area2D = Area2D.new()

var estado:int
enum Estados {IDLE,ABRIR,CERRAR}

var objetoAgarrado:Node2D

@export var velocidad:float = 2.0

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
				if not fingers_colliding():
					close()
				
					
		if objetoAgarrado != null and still_in_range(objetoAgarrado):
			objetoAgarrado.position = $AreaAgarre.global_position




func fingers_colliding()->bool:
		var colisionIzq:KinematicCollision2D = $LadoIzq.move_and_collide(Vector2.ZERO, true, true, true)
		var colisionDer:KinematicCollision2D = $LadoDer.move_and_collide(Vector2.ZERO, true, true, true)
#		assert(colisionDer is KinematicCollision2D)
			
		if colisionDer is KinematicCollision2D or colisionIzq is KinematicCollision2D:#Si colisiono con algo, revertir el movimiento
			return true
		else:
			return false

func grab():
	if not $AreaAgarre.get_overlapping_bodies().is_empty():
		objetoAgarrado = $AreaAgarre.get_overlapping_bodies()[0]

func still_in_range(body) -> bool:
	if $AreaAgarre.get_overlapping_bodies().has(body):
		return true
	else: 
		return false

func open():
	var delta = get_physics_process_delta_time()

	if dedoDer.rotation >= maxRotDer:
		dedoDer.rotate(-velocidad * delta)
	
	if dedoIzq.rotation <= maxRotIzq:
		dedoIzq.rotate(velocidad * delta)
	
func close():
	var delta = get_physics_process_delta_time()
	
	var originalRotDer:float = dedoDer.rotation
	var originalRotIzq:float = $LadoIzq.rotation
	
	if dedoDer.rotation <= 0:
		dedoDer.rotate(velocidad * delta)
		
	if dedoIzq.rotation >= 0:
		dedoIzq.rotate(-velocidad * delta)
		
	tipDer.force_raycast_update()
	var colDer = tipDer.get_collider()
	
	tipIzq.force_raycast_update()
	var colIzq = tipIzq.get_collider()
	

	if colDer is Entidad or colDer is Rigido:#Si esta tocando algo
		dedoDer.rotation = originalRotDer#Revertir la rotacion

	if colIzq is Entidad or colIzq is Rigido:#Si esta tocando algo
		dedoIzq.rotation = originalRotIzq#Revertir la rotacion

	
		
	
func _unhandled_input(event: InputEvent) -> void:
		
	if Input.is_action_pressed("usar"):
		estado = Estados.ABRIR
	elif Input.is_action_pressed("usar2"):
		grab()
		estado = Estados.CERRAR

		
		
