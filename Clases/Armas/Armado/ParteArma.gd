extends KinematicBody2D
class_name ArmaParte

export(Vector2) var origen
export(Const.piezas) var tipoDePieza
var encastres:Array#Todos los encastres en esta arma se guardan aqui
var arma #ArmaMarco, referencia a el arma del cual esta parte es parte, parte

func _ready() -> void:
	register_encastres()

func register_encastres():
	encastres.clear()
	for node in get_children():
		if node is ArmaEncastre:
			encastres.append(node)
	
func connection_setup():
	disconnect_signals()
	
func disconnection_setup():
	disconnect_signals()
	
func disconnect_signals():
	Utility.SignalManipulation.disconnect_all_signals(self)
		
export (String) var inputSeleccion
var seleccionado:bool
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(inputSeleccion):
		seleccionado = !seleccionado
		
	if Const.debugMode and seleccionado:
		position = get_global_mouse_position()

