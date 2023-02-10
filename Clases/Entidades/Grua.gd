extends Entidad
class_name GruaDobleBrazo

@export  var velocidad:float = 70
@export var alcanze:float



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite:Sprite2D = Sprite2D.new()
	inmortal = true
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		$BrazoInferior.rotation -= deg_to_rad(velocidad) * delta
		
	elif Input.is_action_pressed("move_right"):
		$BrazoInferior.rotation += deg_to_rad(velocidad) * delta
		
	if Input.is_action_pressed("shoulder_left"):
		$BrazoInferior/BrazoSuperior.rotation -= deg_to_rad(velocidad) * delta
	
	elif Input.is_action_pressed("shoulder_right"):
		$BrazoInferior/BrazoSuperior.rotation += deg_to_rad(velocidad) * delta

	
	
	

