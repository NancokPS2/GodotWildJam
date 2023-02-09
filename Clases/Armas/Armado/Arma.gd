extends Node2D
class_name ArmaMarco

signal PRE_ATTACK
signal ATTACK
signal POST_ATTACK

export (String) var nombre = "Arma Sin Nombre"

var estadisticas:Dictionary
var type:int
var cooldown:float = 0

onready var animationPlayer:AnimationPlayer

var cooldownTimer:Timer = Timer.new()

var active:bool

var estadisticasPartes:Array

export (Array,Dictionary) var partesGuardadas
export (Array,Dictionary) var conexiones = [
	{
		"proveedor":0,
		"encastre":{},
		"encastrada":1
	}
]


export (Resource) var blueprint = null

func _init() -> void:
	equipping(false)

func save_dict()->Dictionary:
	var dictReturn:Dictionary = {
		"nombre":nombre,
		"partesGuardadas":partesGuardadas,
		"conexiones":conexiones
	}
	return dictReturn
	

func _ready() -> void:
	cooldownTimer.one_shot = true
	cooldownTimer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cooldownTimer.stop()
	add_child(cooldownTimer)
	
	add_saved_partes()
	refresh_animations()
	
	
	
func equipping(equip:bool):
	set_process_unhandled_input(equip)
	active = equip


func attack(params:Dictionary):
	emit_signal("PRE_ATTACK")
	cooldownTimer.start(cooldown)
		
	assert(animationPlayer)
	
	if animationPlayer != null and cooldownTimer.time_left != 0.0:
		for parte in nodosPartes:
			parte.attack(params)
			
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
	
	if not nodosPartes.empty():
		for partePath in nodosPartes:
			if partePath is NodePath:
				get_node(partePath).incoming_input(event)#Delega cualquier input dirigido al arma a todas sus partes
			else:
				partePath.incoming_input(event)
		
	if event.is_action_pressed("attack"):
		attack( {} )
		
		
static func report_weapon_status(arma:ArmaMarco):#Revisa el estado del arma y avisa de algun fallo
	assert(arma.animationPlayer)
	assert(not arma.piezasConectadas.empty())
	
	
	if arma.animationPlayer == null:
		push_error("Missing an animation set!")



static func generate_parte_from_dict(saveDict:Dictionary)->ArmaParte:
	var parte := ArmaParte.new()
	parte.set_script(saveDict.script)
	
	for key in saveDict:
		parte.set(key,saveDict[key])
		
	parte.sprite = Sprite.new()
	parte.hitbox = Area2D.new()
	
	parte.sprite.texture = parte.spriteTexture
	
	var colision = CollisionPolygon2D.new()
	colision.polygon = parte.colisiones
	parte.hitbox.add_child(colision)
	
	return parte
	
#----------------------------------------------
#CONNECTION SECTION
#----------------------------------------------


var encastres:Dictionary
var nodosPartes:Array

export (Dictionary) var encastresEnUso:Dictionary = {
	
}

#SETUP
#func apply_part_attributes():
#	for node in get_children():
#		if node is ArmaParte:
#			node.apply_attributes(self)
			
func get_stat_boosts_from_partes() -> Dictionary:
	var dictRetorno:Dictionary
	for parte in nodosPartes:
		for stat in parte.statBoosts:
			if dictRetorno.has(stat):
				dictRetorno[stat] += parte.statBoosts[stat]
			else:
				dictRetorno[stat] = parte.statBoosts[stat]
	return dictRetorno
			
#func get_free_encastres():
#	var encastresRetornables:Array
#	for encastre in encastres:#Guardar los sin usar por separado
#		if not encastre.usado:
#			encastresRetornables.append(encastre)
#	print(encastresRetornables)
#	return encastresRetornables

#CONNECTIONS

func add_saved_partes():
	while not nodosPartes.empty():
		nodosPartes.pop_back().queue_free()
		
	for parteDict in partesGuardadas:
		var parteNueva:ArmaParte = generate_parte_from_dict(parteDict)
		nodosPartes.append(parteNueva)
		parteNueva.arma = self

		add_child(parteNueva)
		parteNueva.connection_setup()
	
	for conexion in conexiones:
		var IDEncastrada = nodosPartes[conexion.encastrada]
		var IDProveedora
		var encastreProveedora
		connect_parte(IDEncastrada,IDProveedora,encastreProveedora)
		pass
		
	refresh_animations()
		
func connect_parte(parteConectada:ArmaParte,parteProveedora:ArmaParte,encastre:int):
	var encastreEnUso:Dictionary = parteProveedora.encastres[encastre]
	if encastreEnUso.piezasCompatibles && parteConectada.tipoDePieza:
		parteConectada.position = encastreEnUso.posicion - parteProveedora.origen
	else:
		push_error("Se intento encastrar 2 piezas incompatibles")

#func add_initial_piece(pieza:ArmaParte):#Usado cuando no hay encastres, para empezar con el arma
#	pieza.position -= pieza.origen
#	pieza.arma = self
#	add_child(pieza.duplicate())
#	nodosPartes.append(pieza)
#	pieza.connection_setup()
#	add_saved_partes()
#	refresh_animations()
#
#
#
#func add_piece(piezaAEncastrar:ArmaParte,encastre:Vector3) -> bool:#Añade una pieza a un encastre
#	var seLogro:bool
#	var encastreActual = piezaAEncastrar.encastres[encastre]
#	if encastreActual.piezasCompatibles && piezaAEncastrar.tipoDePieza != -1 and not encastreActual.usado:
#		add_child(piezaAEncastrar.duplicate())
#		piezaAEncastrar.position = encastreActual.posicion - piezaAEncastrar.origen
#		piezaAEncastrar.arma = self#Añadir referencia al arma de la cual forma parte
#
#		encastreActual.usado = true
#		encastresEnUso[piezaAEncastrar] = encastre#Añadir encastre a la lista
#
#		nodosPartes.append(piezaAEncastrar)
#		piezaAEncastrar.connection_setup()
#		seLogro = true
#	else:
#		remove_child(piezaAEncastrar)
#		push_error("Could not join parts!")
#		seLogro = false
#
#	refresh_animations()
#	return seLogro
		
		
#func remove_piece(pieza:ArmaParte):
#	pieza.arma = null#Quitar la referencia
#	encastresEnUso[pieza].usado = false#Reactivar el encastre que estaba usando
#	encastresEnUso.erase(pieza)#Remover la pieza del registro de encastres
#	pieza.disconnection_setup()#Desconectar todas las señales
#	remove_child(pieza)#Remover la pieza
#
#	nodosPartes.erase(pieza)#Remover la pieza de la lista
#	refresh_animations()
	
func refresh_animations():#Obtiene un nodo de animacion de la primera pieza que contenga uno
	if animationPlayer:
		remove_child(animationPlayer)
#		animationPlayer.queue_free()#Borrar las animaciones actuales
	
	for pieza in nodosPartes:
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
				


	
