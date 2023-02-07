extends Entidad
class_name Jugador


func _ready() -> void:
#	assert(anim is AnimationPlayer, "anim no se inicio correctamente!")
#	assert(spritePlayer is Sprite or spritePlayer is AnimatedSprite, "spritePlayer no se inicio correctamente!")

	add_child(equipado)
	Ref.jugador = self#Crear una referencia a si mismo
	estadoAtaque = false
	controlando = true
	
	gravedad = Const.gravedad
	
	add_child(afterimageTimer)
	afterimageTimer.connect("timeout",self,"afterimage")
	afterimageTimer.start(0.1)
	
	add_to_group("JUGADOR",true)
	
	
var inventario:Dictionary
var armaEquipada

# Movimiento
var dashCooldownCurrent:float


var speed:float = 200
var gravity = 9.8
var acceleration = 0.25
var friction = 0.25

var estadoSalto:bool = false
var estadoAire:bool = false
# The upward velocity to apply for the jump
var jump_velocity = 340
var saltoRestantes:int
var saltoCooldown:float

onready var anim = $Anims
onready var spritePlayer = $Sprite
onready var colision = $Colision

export var  estadoAtaque = false
# The time remaining before the double jump can be used again (in seconds)

	
func _physics_process(delta):
	._physics_process(delta)#Proceso base de Entidad
	
	surface_procs()#Checkear el estado actual antes de proseguir
	
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

	motion += Vector2.DOWN * gravedad * delta
	motion = move_and_slide(motion, Vector2.UP)
	
	
	#Pañuelo
	var globalPlayerPosVec3 = Vector3(global_position.x,global_position.y,0)
	$PlayerPoint/Camera.translation.x = globalPlayerPosVec3.x / get_viewport_rect().size.x
	$PlayerPoint/Camera.translation.y = globalPlayerPosVec3.y / get_viewport_rect().size.y
	$PlayerPoint/Camera.translation.z = 2.0
	$PlayerPoint.move_and_slide( Vector3(motion.x,motion.y,0) * 0.05 )
	
#	$Debug.text = str(motion)
	$Debug.text = str(global_position / get_viewport_rect().size)
	

func dash():
	if Input.is_action_just_pressed("dash") and dashCooldownCurrent <= 0:
		var direccion:float = Input.get_axis("move_left","move_right")
#	motion.x = direccion.x * dashDistance
		move_and_slide( Vector2(direccion * estadisticas.dashDistance, 0) )
		dashCooldownCurrent = estadisticas.dashCooldown


func side_movement():
	var direccionHorizontal = Input.get_axis("move_left","move_right")#Toma ambos botons como si fueran lados opuestos de una palanca
	#direccionHorizontal resulta en -1 si es hacia la izquierda o 1 si a la derecha

	if direccionHorizontal != 0 and !estadoAtaque:
		motion.x = lerp(motion.x, direccionHorizontal * speed , acceleration)
	else:
		motion.x = lerp(motion.x, 0, friction)
		
	if motion.x > 0 and scale != Vector2(1,1) and not estadoAtaque:
		scale = Vector2(1,1)
		rotation = 0

	elif motion.x < 0 and scale == Vector2(1,1) and not estadoAtaque:
		scale = Vector2(-1,1)
		
		
	

func _jump():
	if Input.is_action_just_pressed("jump"):
		# If the player is on the ground, perform a jump
		if is_on_floor():
			motion += move_and_slide(Vector2(0, -jump_velocity))
			estadoSalto = true#Se inicio un salto
			
		# If the player is in the air and the double jump is available, perform a double jump
		elif estadoAire and saltoRestantes > 0 and saltoCooldown <= 0:
			saltoCooldown = 0.15
			estadoSalto = true
			saltoRestantes -= 1
			motion += move_and_slide(Vector2(0, -jump_velocity))
			
func surface_procs():
	if is_on_floor():
		estadoAire = false
		saltoRestantes = 2
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
		anim.play("aire")
		
	if motion.x > 3:#Yendo a la derecha
		anim.play("correr")
#		spritePlayer.flip_h = false
		
	elif motion.x < -3:#Izquierda
		anim.play("correr")
#		spritePlayer.flip_h = true
		
	else:#Si ninguna otra animacion califica
		anim.play("idle")



var afterimageTimer:Timer = Timer.new()
func afterimage(duration:float = 0.15):
	var afterimage = $Sprite.duplicate()
	
	yield(get_tree().create_timer(0.07),"timeout")
	var timer = get_tree().create_timer(duration)
	timer.connect("timeout",afterimage,"queue_free")#Borrar la imagen luego de 0.3 segundos
	
	afterimage.set_as_toplevel(true)#Colocar donde esta el personaje
	afterimage.position = position
	
	afterimage.modulate = Color(1,1,1,0.7)
	var tween:SceneTreeTween = get_tree().create_tween().bind_node(afterimage)#Hacer transparente
	tween.tween_property(afterimage,"modulate",Color(1,1,1,0), duration)
	
	
	add_child(afterimage)#Añadir a la escena

#Jugabilidad
func _unhandled_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("ataque") and equipado is ArmaMarco:
		equipado.attack( {} )
		
	elif event.is_action_released("herramienta1"):
		cambiar_arma(1)
		
	elif event.is_action_released("herramienta2"):
		cambiar_arma(2)
		
	elif event.is_action_released("herramienta3"):
		cambiar_arma(3)
		

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

var armas:Dictionary = {
	1:load("res://Objetos/Armas/Guardadas/EspadaSimple.tscn").instance()
}
func cambiar_arma(slot:int):
	
	if armas.has(slot):#Asegurarse que el slot seleccionado tengo una herramienta
		remove_child(equipado)#Remover la herramienta actualmente equipada de la escena
		equipado = armas[slot]#Cambiar la herramienta equipada
		
		equipado.position = $PosicionArma.position
		
		add_child(equipado)#Añadira la nueva herramienta
		
		equipado.equipping(true)
		
		var boosts:Dictionary = equipado.get_stat_boosts_from_partes()#Aplicar los boosts de las partes combinadas
		update_stats(boosts,true)
		
	



