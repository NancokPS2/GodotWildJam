extends TileMap
class_name Nivel

@export var escenaJefe:PackedScene
@export var escenaEstructura:PackedScene

@export var spawnJefe:Vector2
@export var spawnJugador:Vector2

@onready var jefe:EntidadJefe = escenaJefe.instantiate()

func _ready() -> void:
	jefe.position = spawnJefe
	add_child(jefe)
	
	Ref.jugador.position = spawnJugador
	add_child(Ref.jugador)
