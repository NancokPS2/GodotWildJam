extends Node2D
class_name ArmaMarco

signal PRE_ATTACK
signal ATTACK
signal POST_ATTACK


var estadisticas:Dictionary
var type:int
var cooldown:float = 0

onready var animationPlayer:AnimationPlayer

var cooldownTimer:Timer = Timer.new()

var active:bool



export (Resource) var blueprint = null

func _ready() -> void:
	cooldownTimer.one_shot = true
	cooldownTimer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cooldownTimer.stop()
	add_child(cooldownTimer)
	
	register_nodes()
	refresh_animations()
	
	
	
func equipping(equip:bool):
	set_process_unhandled_input(equip)
	active = equip


func attack(params:Dictionary):
	emit_signal("PRE_ATTACK")
	cooldownTimer.start(cooldown)
		
	assert(animationPlayer)
	
	if animationPlayer != null and cooldownTimer.time_left != 0.0:
		for pieza in piezasConectadas:
			get_node(pieza).attack(params)
			
		animationPlayer.play("attack")
		emit_signal("ATTACK")
		push_error("This weapon does not know how to attack!")
		
	emit_signal("POST_ATTACK")
		
func target_hit(objetivo):
	if objetivo is Entidad:
		objetivo.hurt(estadisticas.poder)
	pass
		


func _unhandled_input(event: InputEvent) -> void:
#	assert(active,"El input se disparo a pesar de estar inactiva!!!")
	
	if not piezasConectadas.empty():
		for piezaPath in piezasConectadas:
			if piezaPath is NodePath:
				get_node(piezaPath).incoming_input(event)#Delega cualquier input dirigido al arma a todas sus partes
			else:
				piezaPath.incoming_input(event)
		
	if event.is_action_pressed("attack"):
		attack( {} )
		
		
static func report_weapon_status(arma:ArmaMarco):#Revisa el estado del arma y avisa de algun fallo
	assert(arma.animationPlayer)
	assert(not arma.piezasConectadas.empty())
	
	
	if arma.animationPlayer == null:
		push_error("Missing an animation set!")
	
	
#----------------------------------------------
#CONNECTION SECTION
#----------------------------------------------


var encastres:Array
var encastresLibres:Array
export (Array,NodePath) var piezasConectadas:Array

export (Dictionary) var encastresEnUso:Dictionary = {
	
}

#SETUP
func apply_part_attributes():
	for node in get_children():
		if node is ArmaParte:
			node.apply_attributes(self)
			
			
#CONNECTIONS
func register_nodes():
	encastres.clear()
	encastresLibres.clear()
	
	for node in get_children():#Guardar todos los encastres
		if node is ArmaParte:
			encastres += node.encastres
			
	for encastre in encastres:#Guardar los sin usar por separado
		if encastre.usado:
			encastresLibres.append(encastre)
			
	for pieza in piezasConectadas:#Transformar todos los NodePaths a referencias directas
		if pieza is NodePath:
			pieza = get_node(pieza)

func add_initial_piece(pieza:ArmaParte):#Usado cuando no hay encastres, para empezar con el arma
	Utility.NodeManipulation.safe_unparent(pieza)
	pieza.position -= pieza.origen
	pieza.arma = self
	add_child(pieza)
	piezasConectadas.append(pieza)
	pieza.connection_setup()
	register_nodes()
	refresh_animations()

func add_piece(piezaAEncastrar:ArmaParte,encastre:ArmaEncastre):#Añade una pieza a un encastre
	Utility.NodeManipulation.safe_unparent(piezaAEncastrar)
	add_child(piezaAEncastrar)
	if encastre.piezasCompatibles && piezaAEncastrar.tipoDePieza and not encastre.usado:
		Utility.NodeManipulation.safe_unparent(piezaAEncastrar)
		add_child(piezaAEncastrar)
		piezaAEncastrar.position = encastre.position - piezaAEncastrar.origen
		piezaAEncastrar.arma = self#Añadir referencia al arma de la cual forma parte
		
		encastre.usado = true
		encastresEnUso[piezaAEncastrar] = encastre#Añadir encastre a la lista
		
		piezasConectadas.append(piezaAEncastrar)
		piezaAEncastrar.connection_setup()
	else:
		remove_child(piezaAEncastrar)
		push_error("Could not join parts!")
		
	register_nodes()
	refresh_animations()
		
		
func remove_piece(pieza:ArmaParte):
	pieza.arma = null#Quitar la referencia
	encastresEnUso[pieza].usado = false#Reactivar el encastre que estaba usando
	encastresEnUso.erase(pieza)#Remover la pieza del registro de encastres
	pieza.disconnection_setup()#Desconectar todas las señales
	remove_child(pieza)#Remover la pieza
	
	piezasConectadas.erase(pieza)#Remover la pieza de la lista
	register_nodes()#Actualizar encastres
	refresh_animations()
	
func refresh_animations():#Obtiene un nodo de animacion de la primera pieza que contenga uno
	if animationPlayer:
		remove_child(animationPlayer)
		animationPlayer.queue_free()#Borrar las animaciones actuales
	
	for pieza in piezasConectadas:
		if pieza is NodePath and get_node(pieza).get("animationPlayer") != null:
			animationPlayer = get_node(pieza).animationPlayer.instance()
			add_child(animationPlayer)
			animationPlayer.root_node = animationPlayer.get_path_to(self)#Conectar el AnimationPlayer a esta arma
			break
			
		elif pieza.get("animationPlayer") != null:
			animationPlayer = pieza.animationPlayer.instance()
			add_child(animationPlayer)
			animationPlayer.root_node = animationPlayer.get_path_to(self)#Conectar el AnimationPlayer a esta arma
			break
				

static func save_to_blueprint(arma:ArmaMarco) -> ArmaBlueprint:
	var blueprint = ArmaBlueprint.new()
	return blueprint
	

static func build_from_blueprint(blueprint:ArmaBlueprint):
	var piezas = blueprint.piezasACargar
	pass
