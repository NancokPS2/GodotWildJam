extends Node
class_name AreaRecoleccion

var area = Area2D.new()
var colision = CollisionShape2D.new()

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = 15
	colision.shape = shape
	
	add_child(area)
	area.add_child(colision)
	
	area.connect("body_entered",self,"send_to_reactor")
	
func send_to_reactor():
	pass
