extends Node2D
class_name ArmaMarco

signal PRE_ATTACK
signal ATTACK
signal POST_ATTACK

@export var identificador:String
@export var nombre:String = "Arma Sin Nombre"

var estadisticas:Dictionary
var type:int
var cooldown:float = 0

@onready var animationPlayer:AnimationPlayer

var cooldownTimer:Timer = Timer.new()

var active:bool

var estadisticasPartes:Array

#@export var partesGuardadas:Array[Dictionary]

func _init() -> void:
	equipping(false)

const conexionesEjemplo = []
func get_save_dict()->Dictionary:
	var dictReturn:Dictionary = {
		"identificador":identificador,
		"nombre":nombre,
		"conexiones":conexiones,
		"script":get_script().resource_path
	}
	return dictReturn
	
static func generate_from_dict(saveDict:Dictionary)->ArmaMarco:
	var nuevaArma:ArmaMarco = ArmaMarco.new()
	nuevaArma.set_script( load(saveDict.script) )
	
	for key in saveDict:
		if key != "script":
			nuevaArma.set(key,saveDict[key])
		assert(nuevaArma is ArmaMarco)
	
	return nuevaArma.duplicate()

func _ready() -> void:
	cooldownTimer.one_shot = true
	cooldownTimer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cooldownTimer.stop()
	add_child(cooldownTimer)
	
	refresh_partes_from_conexiones()
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
	
	if not nodosPartes.is_empty():
		for partePath in nodosPartes:
			if partePath is NodePath:
				get_node(partePath).incoming_input(event)#Delega cualquier input dirigido al arma a todas sus partes
			else:
				partePath.incoming_input(event)
		
	if event.is_action_pressed("attack"):
		attack( {} )
		
		
static func report_weapon_status(arma:ArmaMarco):#Revisa el estado del arma y avisa de algun fallo
	assert(arma.animationPlayer)
	assert(not arma.piezasConectadas.is_empty())
	
	
	if arma.animationPlayer == null:
		push_error("Missing an animation set!")




	
#----------------------------------------------
#CONNECTION SECTION
#----------------------------------------------

#Formate encastresRegistrados = {}
var conexiones:Dictionary = {
	#Vector3.ZERO:{}#Key=posicion, value=diccionario del arma
}#Registro de todas las conexiones con armas

var encastresDePartes:Array:
	get: 
		var disponibles:Array
		for parte in conexiones.values():
			disponibles.append(parte["encastres"])
					
#					if encastre["usado"] == false:
#						disponibles.append(encastre)
		return disponibles

var nodosPartes:Array

#SETUP
			
func get_stat_boosts_from_partes() -> Dictionary:
	var dictRetorno:Dictionary
	for parte in nodosPartes:
		for stat in parte.statBoosts:
			if dictRetorno.has(stat):
				dictRetorno[stat] += parte.statBoosts[stat]
			else:
				dictRetorno[stat] = parte.statBoosts[stat]
	return dictRetorno
			
#CONNECTIONS		

func refresh_partes_from_conexiones():
	while not nodosPartes.is_empty():
		nodosPartes.pop_back().queue_free()
		
	for posicionEncastre in conexiones:
		var parteNueva:ArmaParte = ArmaParte.generate_from_dict(conexiones[posicionEncastre])
		nodosPartes.append(parteNueva)
		parteNueva.set("arma", self)
		parteNueva.set( "position", Vector2(posicionEncastre.x, posicionEncastre.y) )

		add_child(parteNueva)
		parteNueva.connection_setup()
	
	refresh_animations()
		
func add_conexion(parte:Dictionary,encastre:Dictionary,forzar:bool = false):
	if encastre["piezasCompatibles"] && parte["tipoDePieza"] or forzar:
		conexiones[encastre["posicion"]] = parte
	else:
		push_error("Se intento encastrar 2 piezas incompatibles")
		
func remove_conexion(posicionEncastre:Vector2):
	conexiones.erase(posicionEncastre)

	for nodo in get_children():#Encontrar la parte en esa posicion y borrarlo
		if nodo.get("position") == Vector2(posicionEncastre.x, posicionEncastre.y):
			nodo.queue_free()
			return
			

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
			animationPlayer = pieza.animationPlayer
			add_child(animationPlayer)
			animationPlayer.root_node = animationPlayer.get_path_to(self)#Conectar el AnimationPlayer a esta arma
			break
				


	
