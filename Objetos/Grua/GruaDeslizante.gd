extends Entidad
class_name GruaDeslizante

export (float) var velocidad = 35

func _ready() -> void:
	controlando = true

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left"):
		$Core.move_and_slide(Vector2.LEFT * velocidad)
		
	elif Input.is_action_pressed("move_right"):
		$Core.move_and_slide(Vector2.RIGHT * velocidad)
		
	elif Input.is_action_pressed("move_down"):
		$Core/Brazo.move_and_slide(Vector2.UP * velocidad)
		
	elif Input.is_action_pressed("move_up"):
		$Core/Brazo.move_and_slide(Vector2.DOWN * velocidad)


	
