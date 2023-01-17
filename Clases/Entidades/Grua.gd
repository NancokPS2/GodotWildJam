extends Entidad
class_name Grua

const spriteCuerpo:Texture = preload("res://Assets/Layer 7.png")

export (float) var alcanze

var sujetando:bool

var objeto:PhysicsBody2D#A Sujetar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite:Sprite = Sprite.new()
	inmortal = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("usar"):
		pass
	
	
func _physics_process(delta: float) -> void:

	objeto.move_and_slide()

	
	

