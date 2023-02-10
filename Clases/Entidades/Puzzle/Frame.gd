extends CharacterBody2D
class_name MarcoPuzzle

var puedeEncastrar:bool = true
var encastres:Array
var piezasUnidas:Array

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
	var pieza = zona.get_meta("padre",null)
	if zona.get_meta("encastre",false) and pieza != self and not piezasUnidas.has(pieza) and pieza.puedeEncastrar:#Es parte de un encastre
		place_piece(pieza)

	
func place_piece(pieza):
	var info = compare_piece(pieza)
	if info == null:
		print("Pieza incompatible")
		
	pieza.get_parent().remove_child(pieza)
	

#	info["ajeno"].activacion(false)

	piezasUnidas.append(pieza)
	pieza.puedeEncastrar = false
	add_child(pieza)#Spawnear la pieza
	
	pieza.position = info["mio"].position - info["ajeno"].position
	
	info["ajeno"].call_deferred("activacion",false)
	pieza.puedeEncastrar = true
	
	pieza.seleccionado = false
	seleccionado = false
	

func compare_piece(pieza):
	var infoEncastracion:Dictionary
	
	for encastreAjeno in pieza.encastres:
		for encastreMio in encastres:
			
			if encastreAjeno.IDEncastre == encastreMio.IDEncastre:
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
