extends Node2D
class_name ArmaMarco

signal PRE_ATTACK
signal ATTACK
signal POST_ATTACK


enum States {PRE_ATTACK,ATTACKING,POST_ATTACK}

var type:int
var damage:int = 0
var cooldown:float = 0

var cooldownTimer:Timer = Timer.new()

var active:bool
func equipping(equip:bool):
	set_process_unhandled_input(equip)
	
func _unhandled_input(event: InputEvent) -> void:
	assert(active,"El input se disparo a pesar de estar inactiva!!!")
	if event.is_action_pressed("attack"):
		pre_attack()


func _ready() -> void:
	cooldownTimer.one_shot = true
	cooldownTimer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cooldownTimer.stop()

func pre_attack():
	emit_signal("PRE_ATTACK")
	cooldownTimer.start(cooldown)
	attack()

func attack():
	emit_signal("ATTACK")
	push_error("This weapon does not know how to attack!")

func post_attack():
	emit_signal("POST_ATTACK")
	pass
		
func animation():
	pass
		
		
#----------------------------------------------
#CONNECTION SECTION
#----------------------------------------------

var encastres:Array
var encastresLibres:Array
var piezasConectadas:Array

var encastresEnUso:Dictionary = {
	
}

#SETUP
func apply_part_attributes():
	for node in get_children():
		if node is ArmaParte:
			node.apply_attributes(self)
			
			
#CONNECTIONS
func register_encastres():
	encastres.clear()
	encastresLibres.clear()
	
	for node in get_children():#Guardar todos los encastres
		if node is ArmaParte:
			encastres += node.encastres
			
	for encastre in encastres:#Guardar los sin usar por separado
		if encastre.usado:
			encastresLibres.append(encastre)
			

func add_piece(piezaAEncastrar:ArmaParte,encastre:ArmaEncastre):#Añade una pieza a un encastre
	if encastre.piezasCompatibles.has(piezaAEncastrar.tipoDePieza) and not encastre.usado:
		
		add_child(piezaAEncastrar)
		piezaAEncastrar.position = encastre.position - piezaAEncastrar.origen
		piezaAEncastrar.arma = self#Añadir referencia al arma de la cual forma parte
		
		encastre.usado = true
		encastresEnUso[piezaAEncastrar] = encastre#Añadir encastre a la lista
		
		piezasConectadas.append(piezaAEncastrar)
		piezaAEncastrar.connection_setup()
		
	register_encastres()
		
		
func remove_piece(pieza:ArmaParte):
	encastresEnUso[pieza].usado = false#Reactivar el encastre que estaba usando
	encastresEnUso.erase(pieza)#Remover la pieza del registro de encastres
	pieza.disconnection_setup()#Desconectar todas las señales
	remove_child(pieza)#Remover la pieza
	
	piezasConectadas.erase(pieza)#Remover la pieza de la lista
	register_encastres()#Actualizar encastres
	
