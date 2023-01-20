extends Node2D
class_name SpawnerEntidades

var timer:Timer = Timer.new()
var entidadesCargadas:Array
var entidadesSpawneadas:Array

export (float) var tiempoDefault = 5.0
export (Array,String) var entidades = []
export (int) var limiteDeEntidades = 10
export (Vector2) var areaDeSpawn



func _ready() -> void:
	for entidad in entidades:
		var objeto = load(entidad)
		assert(objeto)
		entidadesCargadas.append(objeto)
	
	timer.start(tiempoDefault)
	timer.connect("timeout",self,"tick")
	
	
	
func tick():
	if check_entidades():
		
		var index = randi() % entidadesCargadas.size()
		
		spawn_entidad(entidadesCargadas[index])
		
	
func spawn_entidad(entidad:Node):
	var posicionX = randf() % areaDeSpawn.x
	var posicionY = randf() % areaDeSpawn.y
	var posicionFinal = Vector2(posicionX,posicionY)
	
	entidad.position = position + posicionFinal#Posicion de este nodo mas lo agregado
	Ref.nivel.add_child(entidad)
	
	
	
func check_entidades():
	while entidadesSpawneadas.has(null):#Limpiar
		entidadesSpawneadas.erase(null)
		
	if entidadesSpawneadas.size() > limiteDeEntidades:
		return false
	else:
		return true
