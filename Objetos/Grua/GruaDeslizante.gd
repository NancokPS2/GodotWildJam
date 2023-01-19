extends Entidad
class_name GruaDeslizante

export (float) var velocidad = 70

func _ready() -> void:
	controlando = true

var miscMultiplier:float = 1

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left"):
		$Core.move_and_slide(Vector2.LEFT * velocidad)
		
	elif Input.is_action_pressed("move_right"):
		$Core.move_and_slide(Vector2.RIGHT * velocidad)
		
	if Input.is_action_pressed("move_down"):
		$Core/GarraGrua.move_and_slide(Vector2.UP * velocidad)
		
	elif Input.is_action_pressed("move_up"):
		$Core/GarraGrua.move_and_slide(Vector2.DOWN * velocidad)
		
	$Core/BrazoSprite.position.y = $Core/GarraGrua.position.y / 2
	$Core/BrazoSprite.scale.y = $Core/GarraGrua.position.y * miscMultiplier


	
