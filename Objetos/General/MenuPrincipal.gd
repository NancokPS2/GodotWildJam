extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Play.pressed.connect(toggle_level_menu)
	$WeapMaker.pressed.connect(goto_weapon_maker)
	$Panel/GridContainer/Samurai.pressed.connect(play_level)
	
	Ref.jugador = load("res://Objetos/Jugador/Jugador.tscn").instantiate()#TEMP
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_level_menu():
	$Panel.visible = !$Panel.visible
	if $Panel.visible:
		$Panel.mouse_filter = MOUSE_FILTER_PASS
	else:
		$Panel.mouse_filter = MOUSE_FILTER_IGNORE

func play_level( nivelPath:String = "res://Objetos/General/NivelSamurai.tscn" ):
	get_tree().change_scene_to_packed( load(nivelPath) )
	
func goto_weapon_maker():
	get_tree().change_scene_to_file("res://Clases/Armas/Armado/ArmaCreador.tscn")
