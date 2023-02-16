extends Entidad
class_name Jugador


func _ready() -> void:
	super._ready()
#	assert(anim is AnimationPlayer, "anim no se inicio correctamente!")
#	assert(spritePlayer is Sprite or spritePlayer is AnimatedSprite, "spritePlayer no se inicio correctamente!")
	collision_layer = Const.CollisionLayers.JUGADOR
	collision_mask = Const.CollisionMasks.JUGADOR

	add_child(equipado)
	Ref.jugador = self#Crear una referencia a si mismo
	estadoAtaque = false
	controlando = true
	
	gravedad = Const.gravedad
	
	add_child(afterimageTimer)
	afterimageTimer.timeout.connect(afterimage)
	afterimageTimer.start(0.1)
	
	add_to_group("JUGADOR",true)
	
	estadisticas["salud"] = 10
	estadisticas["saludMaxima"] = 10
	
var inventario:Dictionary
var armaEquipada

# Movimiento
var dashCooldownCurrent:float


var speed:float = 200
var gravity = 9.8
var acceleration = 0.25
var friction = 0.25
var airTime:float

var estadoSalto:bool = false
var estadoAire:bool = false
# The upward velocity to apply for the jump
var jump_velocity = 340
var saltoRestantes:int
var saltoCooldown:float

@onready var anim:AnimationPlayer = $Anims
@onready var spritePlayer = $Sprite
@onready var colision = $Colision

@export var  estadoAtaque = false
# The time remaining before the double jump can be used again (in seconds)

	
func _physics_process(delta):
	super._physics_process(delta)#Proceso base de Entidad
	
	surface_procs()#Checkear el estado actual antes de proseguir
	add_to_group("JUGADOR",true)
	assert(self.is_in_group("JUGADOR"))
	
	if controlando:
		
		# Decrement the dash cooldown
		dashCooldownCurrent -= delta
		# Decrement the Double jump cooldown
		saltoCooldown -= delta
		
		dash()
		side_movement()
		_jump()
		Animations()
#		Attack()
	

	move_and_slide()
	
	
	#Pañuelo
	var globalPlayerPosVec3 = Vector3(global_position.x,global_position.y,0)
	$PlayerPoint/Camera.position.x = globalPlayerPosVec3.x / get_viewport_rect().size.x
	$PlayerPoint/Camera.position.y = globalPlayerPosVec3.y / get_viewport_rect().size.y
	$PlayerPoint/Camera.position.z = 2.0
	
	$PlayerPoint.velocity = Vector3(velocity.x, velocity.y, 0) * 0.05
	$PlayerPoint.move_and_slide()
	
#	$Debug.text = str(velocity)
#	$Debug.text = str(global_position / get_viewport_rect().size)
	$Debug.text = str(airTime)
	

func dash():
	if Input.is_action_just_pressed("dash") and dashCooldownCurrent <= 0:
		var direccion:float = Input.get_axis("move_left","move_right")
#

		var originalVel = velocity
		velocity += Vector2(direccion * estadisticas["dashDistance"],0)
		move_and_slide()
		velocity = originalVel
		
		dashCooldownCurrent = estadisticas.dashCooldown


func side_movement():
	var direccionHorizontal = Input.get_axis("move_left","move_right")#Toma ambos botons como si fueran lados opuestos de una palanca
	#direccionHorizontal resulta en -1 si es hacia la izquierda o 1 si a la derecha

	if direccionHorizontal != 0 and !estadoAtaque:
		velocity.x = lerp(velocity.x, direccionHorizontal * speed , acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	if velocity.x > 0 and scale != Vector2(1,1) and not estadoAtaque:
		scale = Vector2(1,1)
		rotation = 0

	elif velocity.x < 0 and scale == Vector2(1,1) and not estadoAtaque:
		scale = Vector2(-1,1)
		
		
	

func _jump():
	if Input.is_action_just_pressed("jump"):
		# If the player is on the ground, perform a jump
		if is_on_floor():
			velocity += Vector2.UP * jump_velocity
			estadoSalto = true#Se inicio un salto
			
		# If the player is in the air and the double jump is available, perform a double jump
		elif estadoAire and saltoRestantes > 0 and saltoCooldown <= 0:
			saltoCooldown = 0.15
			estadoSalto = true
			saltoRestantes -= 1
			velocity += Vector2.UP * jump_velocity
			
func surface_procs():
	if is_on_floor():
		estadoAire = false
		saltoRestantes = 1
		estadoSalto = false
	else:
		estadoAire = true
		
	if is_on_wall():
		saltoRestantes = 1
		estadoSalto = false


#func Attack():
#	if(Input.is_action_just_pressed("Attack1")):
#
#		anim.play("Attack1")
#
#	if(Input.is_action_just_pressed("Attack2")):
#
#		anim.play("Attack2")
#
#	if(Input.is_action_just_pressed("Attack3")):
#
#		anim.play("Attack3")

func Animations():
		
	if not is_on_floor():
		airTime += get_process_delta_time() * 1
		if airTime < 0.012:
			anim.play("air")
		else:
			anim.play("air_hold")
			
	else:#If on the floot
		airTime = 0.0
		
		if velocity.x > 3:#Yendo a la derecha
			anim.play("run")
	#		spritePlayer.flip_h = false
			
		elif velocity.x < -3:#Izquierda
			anim.play("run")
	#		spritePlayer.flip_h = true
			
		else:#Si ninguna otra animacion califica
			anim.play("idle")



var afterimageTimer:Timer = Timer.new()
func afterimage(duration:float = 0.15):
	var afterimage:AnimatedSprite2D = $Sprite.duplicate()
	
	await get_tree().create_timer(0.07).timeout#Esperar un poco para crear la siguiente
	
	var timer:SceneTreeTimer = get_tree().create_timer(duration)
	timer.timeout.connect( Callable(afterimage,"queue_free") )#Borrar la imagen luego de 0.3 segundos
	
	afterimage.top_level = true#Colocar donde esta el personaje pero desconectado de el
	afterimage.position = position
	afterimage.z_index = spritePlayer.z_index - 1
#	afterimage.rotation = rotation
#	afterimage.scale = scale
	
	afterimage.modulate = Color(1,1,1,0.7)
	var tween:Tween = get_tree().create_tween().bind_node(afterimage)#Hacer transparente
	tween.tween_property(afterimage,"modulate",Color(1,1,1,0), duration)
	
	
	add_child(afterimage)#Añadir a la escena
	var ass = 1

#Jugabilidad
func _unhandled_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("ataque") and equipado is ArmaMarco:
		equipado.attack( {} )
		
	elif event.is_action_released("herramienta1"):
		cambiar_arma(0)
		
	elif event.is_action_released("herramienta2"):
		cambiar_arma(1)
		
	elif event.is_action_released("herramienta3"):
		cambiar_arma(2)
	
	elif event.is_action_released("debug1"):
		hurt(1)
	
		

#	elif event.is_action_pressed("usar") and herramientaEquipada.has_method("use"):
#		herramientaEquipada.use()


func update_stats(diccionario:Dictionary, resetearAntes:bool=false):
	
	if resetearAntes:
		estadisticas = estadisticasBase.duplicate()
	
	for stat in diccionario:
		if estadisticas.has(stat):
			estadisticas[stat] += diccionario[stat]
		else:
			estadisticas[stat] = diccionario[stat]


var equipado:ArmaMarco
@onready var armas:Array = [ArmaMarco.generate_from_tres( load("res://SaveData/GeneratedWeap/ArmaDefault.tres") )]


func cambiar_arma(slot:int):
	
	if armas.size() > slot:#Asegurarse que el slot seleccionado tengo una herramienta
		remove_child(equipado)#Remover la herramienta actualmente equipada de la escena
		equipado = armas[slot]#Cambiar la herramienta equipada
		
		equipado.position = $PosicionArma.position
		
		add_child(equipado)#Añadira la nueva herramienta
		
		equipado.equipping(true)
		
		var boosts:Dictionary = equipado.get_stat_boosts_from_partes()#Aplicar los boosts de las partes combinadas
		update_stats(boosts,true)
	else:
		print("No hay arma en ese slot.")
		
	



