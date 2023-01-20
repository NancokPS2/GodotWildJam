extends Entidad
class_name Colectible


export (Const.materiales) var tipoMaterial 

export (Texture) var textura
var nombre:String
var sprite = Sprite.new()
var area = Area2D.new()

func _ready():
	area.connect("mouse_entered",self,"set",[true])
	area.connect("mouse_exited",self,"set",[false])
	sprite.texture = textura
	sprite.centered = true
	add_child(sprite)
	
	var colision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	
	shape.radius = 5
	colision.shape = shape
	
	add_child(area)
	area.add_child(colision)
	 
var mouseEncima:bool
