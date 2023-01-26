extends Entidad
class_name Jugador

var afterimageTimer:Timer = Timer.new()
func _ready() -> void:
#	assert(anim is AnimationPlayer, "anim no se inicio correctamente!")
#	assert(spritePlayer is Sprite or spritePlayer is AnimatedSprite, "spritePlayer no se inicio correctamente!")

	add_child(equipado)
	Ref.jugador = self#Crear una referencia a si mismo
	initial_count  = count
	isAttacking = false
	controlando = true
	
	gravedad = Const.gravedad
	
	add_child(afterimageTimer)
	afterimageTimer.connect("timeout",self,"afterimage")
	afterimageTimer.start(0.1)
	
	add_to_group("JUGADOR",true)
	
	
var inventario:Dictionary
var armaEquipada

# Movimiento
var dash_velocity = 2000
var dash_cooldown = 0
var speed:float = 200
var jump_force:float = 340
var gravity = 9.8
var acceleration = 0.25
var friction = 0.25

var dash_count = 2
var is_jumping = false
# Whether the player is currently in the air
var is_in_air = false
export var count = 2
var initial_count
# The upward velocity to apply for the jump
var jump_velocity = 340
onready var anim = $Anims
onready var spritePlayer = $Sprite
export var  isAttacking = false
# The time remaining before the double jump can be used again (in seconds)
var double_jump_cooldown = 0

	
func _physics_process(delta):
	._physics_process(delta)#Proceso base de Entidad
	
	_on_floor_body_entered()#Checkear el estado actual antes de proseguir
	if controlando:
		# Decrement the dash cooldown
		dash_cooldown = max(0, dash_cooldown - delta)
		# Decrement the Double jump cooldown
		double_jump_cooldown = max(0, double_jump_cooldown - delta)
		side_movement()
		_jump()
		Animations()
#		Attack()

	motion += Vector2.DOWN * gravedad * delta
	motion = move_and_slide(motion, Vector2.UP)
	$Debug.text = str(motion)
	pass

func side_movement():
	var direccionHorizontal = Input.get_axis("move_left","move_right")#Toma ambos botons como si fueran lados opuestos de una palanca
	#direccionHorizontal resulta en -1 si es hacia la izquierda o 1 si a la derecha
	if direccionHorizontal != 0 and !isAttacking:
		motion.x = lerp(motion.x, direccionHorizontal * speed , acceleration)
	else:
		motion.x = lerp(motion.x, 0, friction)
		
func _jump():
	if Input.is_action_just_pressed("jump"):
		# If the player is on the ground, perform a jump
		if is_on_floor():
			motion = move_and_slide(Vector2(0, -jump_velocity))
			is_jumping = true#Se inicio un salto
			
		# If the player is in the air and the double jump is available, perform a double jump
		elif is_in_air and count > 0 and double_jump_cooldown == 0:
			double_jump_cooldown = 0.15
			is_jumping = true
			count -=1
			motion = move_and_slide(Vector2(0, -jump_velocity))
			
func _on_floor_body_entered():
	if is_on_floor():
		is_in_air = false
		count = initial_count
		is_jumping = false
	else:
		is_in_air = true
		
	if is_on_wall():
		count = 1
		is_jumping = false
#This script will allow the player to 


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
		spritePlayer.flip_h = false
		
	elif motion.x < -3:#Izquierda
		anim.play("correr")
		spritePlayer.flip_h = true
		
	else:#Si ninguna otra animacion califica
		anim.play("idle")

func attack():
	$HitboxMele


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
		equipado.pre_attack( {} )
		
	elif event.is_action_released("herramienta1"):
		cambiar_arma(1)
		
	elif event.is_action_released("herramienta2"):
		cambiar_arma(2)
		
	elif event.is_action_released("herramienta3"):
		cambiar_arma(3)
		

#	elif event.is_action_pressed("usar") and herramientaEquipada.has_method("use"):
#		herramientaEquipada.use()
	


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
		
	



