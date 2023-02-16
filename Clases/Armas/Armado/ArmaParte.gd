extends CharacterBody2D
class_name ArmaParte

enum Tipos {MANGO = 1<<1,HOJA_ESPADA = 1<<2,HOJA_LANZA = 1<<3}
	
const SlotDefault:= Vector3(0.0, 0.0,Tipos.MANGO)

@export_category("Encastre Builder")
@export var slots:Array[Vector3] = [ SlotDefault ]

@export_category("Main")
@export var nombre:String = "Unnamed"
@export var identificador:String

@export var origen:Vector2
@export var tipoDePieza:Tipos = 1
@export_file("") var animationPlayerPath:String = "res://Objetos/Armas/Animaciones/SwordSwing.tscn"
@export_file("") var texturaSprite:String = "res://icon.png"

@export var colisiones:Array
@export var statBoosts:Dictionary = {
	"poder":1,
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
		"slots":slots,
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
var hitbox:=Hitbox.new()
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
	hitbox.poder = statBoosts["poder"]
	hitbox.collision_layer = 7#Existe en todas las capas
	hitbox.collision_mask = 4#Solo detecta enemigos
	hitbox.objetivoValido = Hitbox.TiposObjetivos.ENEMIGO + Hitbox.TiposObjetivos.ENTIDAD
		
	assert(hitbox != null, "Esta parte no tiene forma de tocar otros objetos.")

			
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
		
