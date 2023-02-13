extends Node
class_name EfectoEstado

#Uso:
#var estado = EfectoEstadoSangrado.new()
#estado.add_instance($Jugador, 10)
var entidadAfectada:Entidad
var temporizador:Timer = Timer.new()

@export var colorizado:Color
@export var nombre:String = "Efecto de Estado"
@export var intervalo:float = 1.0
@export var stacks:int = 1

func _ready() -> void:
	temporizador.one_shot = false
	add_child(temporizador)
	temporizador.start(intervalo)
	temporizador.tiemout.connect(proc)
	
func add_instance(entidad:Entidad = entidadAfectada , cantidad:int = 1):
	entidadAfectada = entidad
	entidad.stacks = cantidad
	entidad.add_child(self.duplicate())
	
func add_medidor():
	var nuevoMedidor = Medidor.new()
	
	nuevoMedidor.modulate = colorizado
	
	entidadAfectada.add_child(nuevoMedidor)
	
func proc():
	if entidadAfectada != null:
		_proc()
	else:
		queue_free()#Si la entidad afectada ya no es valida, auto borrarse

func _proc():
	print("Esta habilidad no hace nada")
	
class Medidor extends TextureProgressBar:
	const texturaProgreso:Texture = preload("res://icon.png")
	const texturaOver:Texture = preload("res://icon.png")
	const texturaUnder:Texture = preload("res://icon.png")
	
	func _init() -> void:
		texture_progress = texturaProgreso
		texture_over = texturaOver
		texture_under = texturaUnder
		
