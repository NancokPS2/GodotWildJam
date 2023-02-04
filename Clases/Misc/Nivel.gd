extends TileMap
class_name Nivel

export (PackedScene) var escenaJefe:PackedScene
export (PackedScene) var escenaEstructura:PackedScene

export (Vector2) var spawnJefe:Vector2
export (Vector2) var spawnJugador:Vector2

onready var jefe:EntidadJefe = escenaJefe.instance()

func _ready() -> void:
	jefe.position = spawnJefe
	add_child(jefe)
	
	Ref.jugador.position = spawnJugador
	add_child(Ref.jugador)
