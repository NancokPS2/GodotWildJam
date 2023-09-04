extends Node2D
class_name WeaponFrame

signal reloading
signal attacking
signal attacking_pre
signal attacking_post

enum WeaponTypes {GUN}

enum Stats {DAMAGE, RELOAD_SPEED, COOLDOWN, PROJECTILE_SPEED}
#const WeaponSignals:Array[String] = ["reloading", "attacking", "attacking_pre", "atacking_post"]

@export var nombre:String = "Arma Sin Nombre"
@export var weaponBaseSlotsExported:Array[WeaponSlot]:
	set(val):
		var newSlots:Array[WeaponFrameSlot]
		for slot in val:
			var newSlot:WeaponFrameSlot = WeaponFrameSlot.convert_from_weaponSlot(slot)
			newSlots.append(newSlot)
			
		weaponBaseSlots = newSlots

var weaponBaseSlots:Array[WeaponFrameSlot]
var weaponPartSlots:Array[WeaponFrameSlot]
@export var weaponType:WeaponTypes
var stats:Dictionary = {
	Stats.DAMAGE : 5,
	Stats.RELOAD_SPEED : 0.5,
	Stats.COOLDOWN : 0.2,
	Stats.PROJECTILE_SPEED : 20
}


@onready var animationPlayer:AnimationPlayer

var cooldownTimer:Timer = Timer.new()

var active:bool

func _ready() -> void:
	update_nodes()

func set_stat(stat:Stats, value:float):
	stats[stat] = value
	
func get_stat(stat:Stats):
	return stats.get(stat,1)

func add_part_to_slot(slot:WeaponFrameSlot, part:WeaponPart):
	assert(slot in get_all_slots())
	
	slot.set_part(part)
	
	#Add the slots
	for partSlot in part.slots:
		var frameSlot:WeaponFrameSlot = WeaponFrameSlot.convert_from_weaponSlot(partSlot)
		frameSlot.fromPart = part
		weaponPartSlots.append(frameSlot)
	

func remove_part_from_slot(slot:WeaponFrameSlot):
	var part:WeaponPart = slot.partHere
	if not part is WeaponPart: push_warning("No weapon attached to this slot, cannot remove."); return
	
	slot.set_part(null)
	
	#Remove the slots
	for partSlot in get_all_slots_from_part(part):
		assert(partSlot in weaponPartSlots)
		weaponPartSlots.erase(partSlot)
		
	
	
func update_nodes():
	clear_part_nodes()
	for part in get_all_parts():
		var partNode:Node2D = part.get_node()
		add_child(partNode)

func clear_part_nodes():
	for child in get_children(): child.queue_free()

func get_all_slots()->Array[WeaponFrameSlot]:
	return weaponPartSlots + weaponBaseSlots

func get_all_slots_from_part(part:WeaponPart)->Array[WeaponFrameSlot]:
	var slots:Array[WeaponFrameSlot] = get_all_slots()
	slots = slots.filter(func(slot:WeaponFrameSlot): return slot.partHere == part)
	return slots

func get_all_parts()->Array[WeaponPart]:
	var parts:Array[WeaponPart]
	for slot in get_all_slots():
		if slot.has_part(): parts.append(slot.partHere)
#	parts.assign(
#		get_all_slots().map(func(slot:WeaponSlot):
#		return slot.partHere
#		)
#	)
	return parts



#class WeaponFramePart extends Node2D:
#

class WeaponFrameSlot extends Node2D:
	var fromPart:WeaponPart
	var compatibleParts:Array[WeaponPart.PartTypes]
	var partHere:WeaponPart
	
	func set_part(part:WeaponPart):
		partHere = part
		
	func has_part()->bool:
		return partHere is WeaponPart
	
	static func convert_from_weaponSlot(slot:WeaponSlot)->WeaponFrameSlot:
		var newSlot:WeaponFrameSlot = WeaponFrameSlot.new()
		
		newSlot.position = slot.position
		newSlot.compatibleParts = slot.compatibleParts
		newSlot.partHere = slot.partHere
		return newSlot
		
	pass
