extends Entidad
class_name MarcoPuzzle

var encastres:Array

func activacion(valor:bool):
	for encastre in encastres:
		encastre.activacion(valor)

func _ready() -> void:
	for node in get_children():
		if node is EncastrePuzzle:
			node.frame = true
			encastres.append(node)
			var area2D = Area2D.new()
			var colision = CollisionShape2D.new()
			var forma = CircleShape2D.new()
			
			forma.radius = Const.tamanoEncastres
			colision.shape = forma
			node.add_child(area2D)
			area2D.set_meta("encastre",true)
			area2D.set_meta("padre",self)
			area2D.add_child(colision)
			
			area2D.connect("area_entered",self,"zone_detected")

func zone_detected(zona):
	var padre = zona.get_meta("padre",null)
	if zona.get_meta("encastre",false) and zona.get_meta("padre",null) != self:#Es parte de un encastre
		var pieza = zona.get_meta("padre",null)
		place_piece(pieza)
		pass
	
func place_piece(pieza):
	var info = compare_piece(pieza)
	if info == null:
		print("Pieza incompatible")
		
	pieza.get_parent().remove_child(pieza)
	
	pieza.position = info["mio"].position - info["ajeno"].position
	info["ajeno"].activacion(false)
	
	activacion(false)#Desactivar
	
	pieza.activacion(false)#Apagar su deteccion
	
	add_child(pieza)#Spawnear la pieza
	
	activacion(true)#Re encender la nuestra
	pieza.seleccionado = false
	seleccionado = false
	

func compare_piece(pieza):
	var infoEncastracion:Dictionary
	
	for encastreAjeno in pieza.encastres:
		for encastreMio in encastres:
			
			if encastreAjeno.encastre == encastreMio.encastre:
				infoEncastracion["ajeno"] = encastreAjeno
				infoEncastracion["mio"] = encastreMio
				return infoEncastracion
			
	return null
		
		
export (String) var inputSeleccion
var seleccionado:bool
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(inputSeleccion):
		seleccionado = !seleccionado
		
	if Const.debugMode and seleccionado:
		position = get_global_mouse_position()
