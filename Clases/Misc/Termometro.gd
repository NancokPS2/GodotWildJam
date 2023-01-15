extends ProgressBar
class_name Termometro


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("changed",self,"thermometer_visuals")
	
	var timer = Timer.new()
	timer.wait_time = float(1)
	timer.start()
	timer.connect("timeout",self,"crazy_vals")


func crazy_vals():
	value = rand_range(0,100)

func thermometer_visuals():
	if value / max_value < 0.25:
		modulate = Const.colores[0]
		
	elif value / max_value < 0.50:
		modulate = Const.colores[0]
		
	elif value / max_value < 0.75:
		modulate = Const.colores[0]
		
	elif value / max_value < 1:
		modulate = Const.colores[0]
