extends CharacterBody2D
class_name ArmaParte

const EncastreIndices = {
	"piezasCompatibles":0,
	"usado":1
}

enum Tipos {MANGO = 1<<1,HOJA_ESPADA = 1<<2,HOJA_LANZA = 1<<3}
	
const EncastreFormato = {"posicion":Vector2(0.0,0.0), "piezasCompatibles":Tipos.HOJA_ESPADA, "usado":false}

@export_category("Custom")
@export var nombre:String

@export var origen:Vector2
@export var tipoDePieza:Tipos
@export var animationPlayerPath:String
@export var texturaSprite:Texture
@export var encastres:Array = [ EncastreFormato ]
@export var colisiones:PackedVector2Array
@export var statBoosts:Dictionary = {
	"poder":5,
	"critico":15,
}
@export var miscValues:Dictionary


func get_save_dict()->Dictionary:
	var dictReturn:Dictionary = {
		"nombre":nombre,
		"origen":origen,
		"tipoDePieza":tipoDePieza,
		"animationPlayerPath":animationPlayerPath,
		"texturaSprite":texturaSprite,
		"encastres":encastres,
		"statBoosts":statBoosts,
		"colisiones":colisiones,
		"miscValues":miscValues,
		"script":get_script().resource_path
	}
	return dictReturn

var sprite:Sprite2D
#var encastres:Array#Todos los encastres en esta arma se guardan aqui
var hitbox:Area2D
var arma #ArmaMarco, referencia a el arma del cual esta parte es parte, parte

func _ready() -> void:
	register_children()
	assert(hitbox != null, "Esta parte no tiene forma de tocar otros objetos.")


func register_children():
	encastres.clear()
	for node in get_children():
#		if node is ArmaEncastre:
#			encastres.append(node)
			
		if node is Area2D:
			hitbox = node
			
		elif node is Sprite2D:
			sprite = node
			
	

func pre_attack(params:Dictionary):
	pass
	
func attack(params:Dictionary):
	pass
	
func post_attack(params:Dictionary):
	pass

func connection_setup():
	disconnect_signals()
	hitbox.body_entered.connect( Callable(arma,"target_hit") )
	
func disconnection_setup():
	disconnect_signals()
	
func disconnect_signals():
	Utility.SignalManipulation.disconnect_all_signals(self)
		
func incoming_input(event):
	pass
		
