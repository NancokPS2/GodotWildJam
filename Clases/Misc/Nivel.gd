extends Node2D
class_name Nivel

@export var escenaJefe:PackedScene
@export var escenaEstructura:PackedScene

@export var spawnJefe:Vector2
@export var spawnJugador:Vector2

var camera := ChaseCam.new()

@onready var jefe:Entidad = escenaJefe.instantiate()

func _ready() -> void:
	
	jefe.position = spawnJefe
	add_child(jefe)
	
	Ref.jugador.position = spawnJugador
	add_child(Ref.jugador)
	
	add_child(escenaEstructura.instantiate())
	
	add_child(camera)
	camera.current = true
	
	add_child(load("res://Objetos/General/Interfaz.tscn").instantiate())
	
