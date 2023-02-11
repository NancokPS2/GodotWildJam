extends CharacterBody2D
class_name ArmaParte

const EncastreIndices = {
	"piezasCompatibles":0,
	"usado":1
}

enum Tipos {MANGO = 1<<0,HOJA_ESPADA = 1<<1,HOJA_LANZA = 1<<2}
	
const EncastreFormato:Dictionary = {"posicion":Vector2(0.0,0.0), "piezasCompatibles":Tipos.MANGO, "usado":false}

@export_category("Encastre Builder")
@export var encastres:Array = [ {"posicion":Vector2(0.0,0.0), "piezasCompatibles":0, "usado":false} ]

@export_category("Main")
@export var nombre:String = "Unnamed"
@export var identificador:String = ""

@export var origen:Vector2 = Vector2.ZERO
@export var tipoDePieza:Tipos = 0
@export_file("") var animationPlayerPath:String = "res://Objetos/Armas/Animaciones/SwordSwing.tscn"
@export_file("") var texturaSprite:String = "res://icon.png"

@export var colisiones:PackedVector2Array
@export var statBoosts:Dictionary = {
	"poder":5,
	"critico":15,
}
var miscValues:Dictionary


func get_save_dict()->Dictionary:
	var dictReturn:Dictionary = {
		"identificador":identificador,
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

static func generate_from_dict(saveDict:Dictionary)->ArmaParte:
	var parte := ArmaParte.new()
	assert( saveDict.get("tipoDePieza",null) is int )
	
	parte.set_script( load(saveDict.script) )
	
	for key in saveDict:
		if key != "script":
			parte.set(key,saveDict[key])
		assert(parte is ArmaParte)

	
	var animacion = load(saveDict["animationPlayerPath"]).instantiate()
	if animacion:
		parte.set("animationPlayer",animacion)
	
	return parte

var sprite:=Sprite2D.new()
#var encastres:Array#Todos los encastres en esta arma se guardan aqui
var hitbox:=Area2D.new()
var colision:=CollisionPolygon2D.new()
var animationPlayer:AnimationPlayer
var arma:Node #ArmaMarco, referencia a el arma del cual esta parte es parte, parte

func _ready() -> void:
	
	var textura = load(texturaSprite)
	if textura:
		sprite.texture = textura
		add_child(sprite)
	
	add_child(hitbox)
	
	colision.polygon = colisiones
	hitbox.add_child(colision)
		
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
		
