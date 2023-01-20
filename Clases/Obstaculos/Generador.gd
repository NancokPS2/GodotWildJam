extends Estructura
class_name Generador

var ticker:Timer = Timer.new()

var contenidos:Dictionary 


func _ready() -> void:
	add_child(ticker)
	ticker.connect("timeout",self,"tick")
	ticker.start(1.0)
	
	$AreaRecoleccion1.connect("body_entered",self,"intake")

func tick():
	temperatura += 1
	pass
	
func intake(objeto:Colectible):
	if objeto is Colectible:
		contenidos[objeto.tipoMaterial] = objeto
	
func pause():
	ticker.paused = true
