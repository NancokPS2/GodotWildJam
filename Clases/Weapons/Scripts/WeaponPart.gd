extends Resource
class_name WeaponPart

signal added_to_weapon
signal removed_from_weapon

enum PartTypes {GRIP, BARREL, BODY, ACCESSORY, STOCK}

const META_KEY_WEAPON_PART_LINK:String = "_WEAPON_PART_LINK_META"

const NODE_NAME:String = "PART"

@export_category("Encastre Builder")
@export var slots:Array[WeaponSlot]

@export_category("Main")
@export var partName:String = "Unnamed"
#@export var identificador:String

@export var origin:Vector2
@export var partType:PartTypes = PartTypes.ACCESSORY
@export var texture:Texture = load("res://icon.png")
@export var animationPlayerScene:PackedScene = load("res://Objetos/Armas/Animaciones/SwordSwing.tscn")

@export_category("Operation")
@export var animations:Dictionary

@export var statBoosts:Dictionary = {
	WeaponFrame.Stats.DAMAGE:1,
	WeaponFrame.Stats.COOLDOWN:15,
}

func get_node()->Node2D:
	var mainNode := Node2D.new()
	var sprite := Sprite2D.new()
	var animationPlayer:AnimationPlayer = animationPlayerScene.instantiate()
	
	sprite.texture = texture
	mainNode.set_name(NODE_NAME)
	mainNode.add_child(sprite)
	mainNode.add_child(animationPlayer)
	
	return mainNode

#func remove_node():
#	if nodeLink is Node2D and nodeLink.get_parent():
#		nodeLink.get_parent().remove_child(nodeLink)

func get_slots()->Array[WeaponSlot]:
	return slots
		
func attack_modifier():
	pass
#func pre_attack(params:Dictionary):
#	pass
#
#func attack(params:Dictionary):
#	pass
#
#func post_attack(params:Dictionary):
#	pass

		
func on_reload():
	pass

func on_attacking():
	pass
	
func on_attacking_post():
	pass

func on_attacking_pre():
	pass
