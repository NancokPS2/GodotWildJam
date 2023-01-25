extends KinematicBody2D
class_name ArmaParte

export(Vector2) var origen
export(Const.piezas,FLAGS) var tipoDePieza
export (PackedScene) var animationPlayer

var encastres:Array#Todos los encastres en esta arma se guardan aqui
var hitbox:Area2D
var arma #ArmaMarco, referencia a el arma del cual esta parte es parte, parte

func _ready() -> void:
	register_children()
	assert(hitbox != null, "Esta parte no tiene forma de tocar otros objetos.")


func register_children():
	encastres.clear()
	for node in get_children():
		if node is ArmaEncastre:
			encastres.append(node)
			
		if node is Area2D:
			hitbox = node
			
	

func pre_attack(params:Dictionary):
	pass
	
func attack(params:Dictionary):
	pass
	
func post_attack(params:Dictionary):
	pass

func connection_setup():
	disconnect_signals()
	hitbox.connect("body_entered",arma,"target_hit")
	
func disconnection_setup():
	disconnect_signals()
	
func disconnect_signals():
	Utility.SignalManipulation.disconnect_all_signals(self)
		
func incoming_input(event):
	pass
		
export (String) var inputSeleccion
var seleccionado:bool
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(inputSeleccion):
		seleccionado = !seleccionado
		
	if Const.debugMode and seleccionado:
		position = get_global_mouse_position()

