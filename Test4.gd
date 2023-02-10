extends Node2D


func _init():
	self.ready.connect(_ready)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(get_signal_connection_list("ready"))
	pass # Replace with function body.

