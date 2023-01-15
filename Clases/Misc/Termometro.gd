extends ProgressBar
class_name Termometro


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("value_changed",self,"thermometer_visuals")
	
	var FG = StyleBoxFlat.new()
	FG.bg_color = Color(255,255,255)
	var BG = StyleBoxEmpty.new()
	
	add_stylebox_override("fg",FG)
	add_stylebox_override("bg",BG)
	
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = float(1)
	timer.start()
	timer.connect("timeout",self,"crazy_vals")


func crazy_vals():
	value = rand_range(0,100)

func thermometer_visuals(ass):
	if value / max_value < 0.25:
		modulate = Const.colores[0]
		
	elif value / max_value < 0.50:
		modulate = Const.colores[0]
		
	elif value / max_value < 0.75:
		modulate = Const.colores[0]
		
	elif value / max_value < 1:
		modulate = Const.colores[0]
