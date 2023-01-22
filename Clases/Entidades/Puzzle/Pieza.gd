extends Entidad
class_name PiezaPuzzle

var puedeEncastrar:bool = true
var encastres:Array

signal ACTIVAR_ENCASTRES

var test = Vector2(0,4).tangent()

func activacion(valor:bool):
	for encastre in encastres:
		encastre.activacion(valor)

func _ready() -> void:

	for node in get_children():
		if node is EncastrePuzzle:

			encastres.append(node)
			var area2D = Area2D.new()
			var colision = CollisionShape2D.new()
			var forma = CircleShape2D.new()
			
			forma.radius = Const.tamanoEncastres
			colision.shape = forma
			node.add_child(area2D)
			area2D.set_meta("encastre",true)
			area2D.set_meta("padre",self)
			area2D.monitorable = false
			area2D.monitoring = false

			area2D.add_child(colision)
			
			if not get_parent() is MarcoPuzzle:
				node.activacion(true)
			


export (String) var inputSeleccion
var seleccionado:bool
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(inputSeleccion):
		seleccionado = !seleccionado
		
	if Const.debugMode and seleccionado:
		position = get_global_mouse_position()

