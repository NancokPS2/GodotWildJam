extends Node2D
#class_name WeaponFrame

signal PRE_ATTACK
signal ATTACK
signal POST_ATTACK

@export var identificador:String
@export var nombre:String = "Arma Sin Nombre"

var estadisticas:Dictionary = {
	"poder":1
}
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
		"slots":slots,
		"script":get_script().resource_path
	}
	return dictReturn
	
static func generate_from_tres(armaRes:WeaponPart)->ArmaMarco:
	var armaDict:Dictionary = armaRes.datos.duplicate()
	var armaNueva:WeaponPart = WeaponFrame.generate_from_dict(armaDict)
	return armaNueva
	
	
static func generate_from_dict(saveDict:Dictionary)->ArmaMarco:
	var nuevaArma:WeaponFrame = ArmaMarco.new()
	nuevaArma.set_script( load(saveDict.script) )
	
	for key in saveDict:
		if key != "script":
			nuevaArma.set(key,saveDict[key])
		assert(nuevaArma is WeaponFrame)
		
#	assert(not nuevaArma.slots.is_empty())
	
	return nuevaArma

func _ready() -> void:
	cooldownTimer.one_shot = true
	cooldownTimer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cooldownTimer.stop()
	add_child(cooldownTimer)
	
	refresh_partes_from_slots()
	refresh_animations()
	get_stat_boosts_from_partes()
	
	
	
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
		
		
static func report_weapon_status(arma:WeaponFrame):#Revisa el estado del arma y avisa de algun fallo
	assert(arma.animationPlayer)
	assert(not arma.piezasConectadas.is_empty())
	
	
	if arma.animationPlayer == null:
		push_error("Missing an animation set!")




	
#----------------------------------------------
#CONNECTION SECTION
#----------------------------------------------

const SlotDefault = Vector3(0.0,0.0,ArmaParte.Tipos.MANGO)
var slots:Dictionary

	#{}:{}#Key=slot, value=arma en formato Dict
#Registro de todas las conexiones con armas

var slotsLibres:Array[Vector3]



var encastresDePartes:Array
func refresh_slots(): 
	var newSlots:Dictionary
	newSlots[SlotDefault] = null
	
	for parte in slots.values():#Array de Dictionary
		for slot in parte.slots:#Array de Vector3
			newSlots[slot] = null
			
	for slot in slots:#Colocar las armas que ya estaban
		var parte:Dictionary = slots[slot]
		
		newSlots[slot] = parte
	slots = newSlots
			
	
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

func refresh_partes_from_slots():
	while not nodosPartes.is_empty():
		nodosPartes.pop_back().queue_free()
		
	await get_tree().process_frame
	
	for slot in slots:
		var parte = slots[slot]
		if parte == null:
			continue
			
		var parteNueva:ArmaParte = ArmaParte.generate_from_dict(parte)
		nodosPartes.append(parteNueva)
		parteNueva.set("arma", self)
		parteNueva.set( "position", Vector2(slot.x,slot.y) - parteNueva.origen )
		add_child(parteNueva)
		parteNueva.connection_setup()
	
	refresh_animations()
		
func add_conexion(parte:Dictionary,slot:Vector3,forzar:bool = false):
	if int(slot.z) && parte["tipoDePieza"] or forzar:
		slots[slot] = parte
		var a = 1
	else:
		push_error("Se intento encastrar 2 piezas incompatibles")
	refresh_slots()
		
#
#

		
	
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
				


	
