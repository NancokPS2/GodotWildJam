extends Entidad
class_name Jugador


func _ready() -> void:
#	assert(anim is AnimationPlayer, "anim no se inicio correctamente!")
#	assert(spritePlayer is Sprite or spritePlayer is AnimatedSprite, "spritePlayer no se inicio correctamente!")
	add_child(herramientaEquipada)
	Ref.jugador = self#Crear una referencia a si mismo
	initial_count  = count
	isAttacking = false
	controlando = true


# Movimiento
var dash_velocity = 2000
var dash_cooldown = 0
var speed:float = 200
var jump_force:float = 340
var gravity = 9.8
var acceleration = 0.25
var friction = 0.25
var Motion = Vector2.ZERO
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
	._physics_process(delta)
	
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

		#TEMPORAL
		if Input.is_action_pressed("usar") and herramientaEquipada.has_method("use"):
			var parametro:Dictionary = { "delta":delta }
			herramientaEquipada.use( parametro )
	
	Motion.y += gravity
	Motion = move_and_slide(Motion, Vector2.UP)
	$Debug.text = str(Motion)
	pass

func side_movement():
	var direccionHorizontal = Input.get_axis("move_left","move_right")#Toma ambos botons como si fueran lados opuestos de una palanca
	#direccionHorizontal resulta en -1 si es hacia la izquierda o 1 si a la derecha
	if direccionHorizontal != 0 and !isAttacking:
		Motion.x = lerp(Motion.x, direccionHorizontal * speed , acceleration)
	else:
		Motion.x = lerp(Motion.x, 0, friction)
		
func _jump():
	if Input.is_action_just_pressed("jump"):
		# If the player is on the ground, perform a jump
		if is_on_floor():
			Motion = move_and_slide(Vector2(0, -jump_velocity))
			is_jumping = true#Se inicio un salto
			
		# If the player is in the air and the double jump is available, perform a double jump
		elif is_in_air and count > 0 and double_jump_cooldown == 0:
			double_jump_cooldown = 0.15
			is_jumping = true
			count -=1
			Motion = move_and_slide(Vector2(0, -jump_velocity))
			
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
		
	if Motion.x > 3:#Yendo a la derecha
		anim.play("correr")
		spritePlayer.flip_h = false
		
	elif Motion.x < -3:#Izquierda
		anim.play("correr")
		spritePlayer.flip_h = true
		
	else:#Si ninguna otra animacion califica
		anim.play("idle")

func attack():
	$HitboxMele


#Jugabilidad
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		herramientaEquipada.follow_mouse()
		
	elif event.is_action_pressed("ataque"):
		attack()
		
	elif event.is_action_released("herramienta1"):
		cambiar_arma(1)
		
	elif event.is_action_released("herramienta2"):
		cambiar_arma(2)
		
	elif event.is_action_released("herramienta3"):
		cambiar_arma(3)
		

#	elif event.is_action_pressed("usar") and herramientaEquipada.has_method("use"):
#		herramientaEquipada.use()
	


var herramientaEquipada:Herramienta = Herramienta.new()

var herramientas:Dictionary = {
	1:HerramientaTaladro.new()
}
func cambiar_arma(slot:int):
	
	if herramientas.has(slot):#Asegurarse que el slot seleccionado tengo una herramienta
		remove_child(herramientaEquipada)#Remover la herramienta actualmente equipada de la escena
		herramientaEquipada = herramientas[slot]#Cambiar la herramienta equipada
		
		assert(herramientaEquipada is Herramienta)#Asegurarse que aun existe una en la variable
		
		add_child(herramientaEquipada)#Añadira la nueva herramienta
		
		herramientaEquipada.equip(self)#Ajustes varios
	



