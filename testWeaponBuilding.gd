extends Node2D

var marco = ArmaMarco.new()
var parteMango = load("res://Objetos/Armas/Partes/BasicHilt.tscn").instantiate()
var parteHoja = load("res://Objetos/Armas/Partes/Blade.tscn").instantiate()

func _ready() -> void:
	add_child(marco)
	add_child(parteHoja)
	add_child(parteMango)
	marco.add_initial_piece(parteMango)
	marco.add_piece(parteHoja,parteMango.get_node("EncastreArma"))
	pass
