extends Resource
class_name WeaponSlot

@export var position:Vector2
@export var compatibleParts:Array[WeaponPart.PartTypes]
@export var partHere:WeaponPart:
	set = set_part

func has_part()->bool:
	return partHere is WeaponPart

func set_part(part:WeaponPart):
	partHere = part
