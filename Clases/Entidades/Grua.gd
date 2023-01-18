extends Entidad
class_name GruaDobleBrazo

export (float) var velocidad = 70
export (float) var alcanze



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite:Sprite = Sprite.new()
	inmortal = true
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		$BrazoInferior.rotation -= deg2rad(velocidad) * delta
		
	elif Input.is_action_pressed("move_right"):
		$BrazoInferior.rotation += deg2rad(velocidad) * delta
		
	if Input.is_action_pressed("shoulder_left"):
		$BrazoInferior/BrazoSuperior.rotation -= deg2rad(velocidad) * delta
	
	elif Input.is_action_pressed("shoulder_right"):
		$BrazoInferior/BrazoSuperior.rotation += deg2rad(velocidad) * delta

	
	
	

