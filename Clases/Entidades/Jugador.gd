extends Entidad
class_name Jugador




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
onready var anim = $AnimationPlayer
onready var spritePlayer = $Player_Sprite
export var  isAttacking = false
# The time remaining before the double jump can be used again (in seconds)
var double_jump_cooldown = 0

#Misc
var activo:bool = true

func _ready() -> void:
	assert(anim is AnimationPlayer, "anim no se inicio correctamente!")
	assert(spritePlayer is Sprite or spritePlayer is AnimatedSprite, "spritePlayer no se inicio correctamente!")
	
	Ref.jugador = self#Crear una referencia a si mismo
	initial_count  = count
	anim.play("Idle")
	isAttacking = false



func _process(delta):
	_on_floor_body_entered()


	
func _physics_process(delta):
	if activo:
		# Decrement the dash cooldown
		dash_cooldown = max(0, dash_cooldown - delta)
		# Decrement the Double jump cooldown
		double_jump_cooldown = max(0, double_jump_cooldown - delta)
		get_direction()
		_jump()
		Dash()
		Animations()
		Attack()
	
	Motion.y += gravity
	Motion = move_and_slide(Motion, Vector2.UP)
	pass

func get_direction():
	var Direction = 0
	if(Input.is_action_pressed("move_left")) and !isAttacking:
		Direction -= 1
		anim.play("Run")
		spritePlayer.flip_h = true
	elif Input.is_action_pressed("move_right") and !isAttacking:
		Direction += 1
		anim.play("Run")
		spritePlayer.flip_h = false
	
	if Direction == 0:
		Motion.x = lerp(Motion.x, 0 , friction)
		if !isAttacking:
			anim.play("Idle")
	else:
		Motion.x = lerp(Motion.x, Direction * speed , acceleration)
func _jump():
	if Input.is_action_just_pressed("Jump"):
		# If the player is on the ground, perform a jump
		if is_on_floor():
			Motion = move_and_slide(Vector2(0, -jump_velocity))
			is_in_air = true
			is_jumping = true
		# If the player is in the air and the double jump is available, perform a double jump
		elif is_in_air  and count > 0 and double_jump_cooldown == 0:
			double_jump_cooldown = 0.15
			is_jumping = true
			count -=1
			Motion = move_and_slide(Vector2(0, -jump_velocity))
			
func _on_floor_body_entered():
	if is_on_floor():
		is_in_air = false
		count = initial_count
		is_jumping = false
	if is_on_wall():
		count = 1
		is_jumping = false
#This script will allow the player to 


func Dash():
	# Check for dash input
	if Input.is_action_pressed("dash") and dash_cooldown == 0 and dash_count > 0:
		# Determine the direction of the dash
		var direction = Vector2()
		if Input.is_action_pressed("move_right"):
			direction.x = 1
			
		elif Input.is_action_pressed("move_left"):
			direction.x = -1
			
		# Apply the dash velocity
		Motion = move_and_slide(direction * dash_velocity)
		dash_count -= 1
		# Start the dash cooldown
		dash_cooldown = 0.5
	#If the player is in the ground or a wall resets the dash count
	if(is_on_floor() or is_on_wall()):
		dash_count = 2
func Attack():
	if(Input.is_action_just_pressed("Attack1")):

		anim.play("Attack1")
		
	if(Input.is_action_just_pressed("Attack2")):
		
		anim.play("Attack2")
		
	if(Input.is_action_just_pressed("Attack3")):
		
		anim.play("Attack3")
		
func Animations():
	if(is_in_air and !is_jumping):
		anim.play("Fall")
	if(is_in_air and is_jumping and !isAttacking):
		anim.play("Jump")
