extends Node2D
class_name Arma

export (int) var damage = 1

export (float) var cooldown = 1.0

export (bool) var cooldownIncludesDuration = false
var cooldownTimer:Timer = Timer.new()

var active:bool
func equipping(equip:bool):
	set_process_unhandled_input(equip)
	
func _unhandled_input(event: InputEvent) -> void:
	assert(active,"El input se disparo a pesar de estar inactiva!!!")
	if event.is_action_pressed("attack"):
		attack()


func _ready() -> void:
	cooldownTimer.one_shot = true
	cooldownTimer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	cooldownTimer.stop()
	

func attack():
	if not cooldownTimer.is_stopped():
		if not cooldownIncludesDuration:
			cooldownTimer.start(cooldown)
		_attack()

func finish_attack():
	if cooldownIncludesDuration:
		cooldownTimer.start(cooldown)
		
func _attack():
	push_error("I don't know how to attack!!!")
	pass
