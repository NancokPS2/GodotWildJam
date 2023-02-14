extends SubViewportContainer
class_name ArmaCreador

@onready var valoresDefault:Dictionary = {
	"partes":[ ],
	"arma":[ ]
}

@export var autoConversion:bool

var arma:ArmaMarco
var camara:Camera2D
var buttonGroup:ButtonGroup = ButtonGroup.new()
@onready var viewport = $Viewport
@onready var listaPiezas = $Viewport/UI/ScrollContainer/ListaPiezas

var partes:Array

var parteSeleccionada:Dictionary

func _ready():
	#TEMP
#	arma = load("res://Objetos/Armas/Guardadas/EspadaSimple.tscn").instantiate()
	if autoConversion:#Convierte escenas de partes a diccionarios
		for parteFile in Utility.FileManipulation.get_file_paths_in_folder("res://Objetos/Armas/Partes/"):
			var parteScene:PackedScene = load(parteFile)
			var parte:ArmaParte = parteScene.instantiate()
			var config:=ConfigFile.new()
			config.set_value("Main","Main",parte.get_save_dict())
			print ( str(config.save(Const.Directorios.PartesGeneradas+parte.nombre+".cfg") ) )
			
		
	
	listaPiezas.anchor_right = 0.2
	listaPiezas.anchor_bottom = 1.0
	
	camara = Utility.ControllableCamera2D.new()
	viewport.add_child(camara)
	
	$Viewport/UI/FileDialog.file_selected.connect(load_arma)
	$Viewport/UI/Abrir.pressed.connect( Callable($Viewport/UI/FileDialog, "popup") )
	$Viewport/UI/Guardar.pressed.connect(save_arma)
	$Viewport/UI/LineEdit.text_submitted.connect(rename_arma)
	
	if Engine.is_editor_hint():
		$Viewport/UI/FileDialog.file_mode = FileDialog.ACCESS_RESOURCES
	else:
		$Viewport/UI/FileDialog.file_mode = FileDialog.ACCESS_USERDATA
#	camara.current = true
#	camara.zoom *= 0.3
	
	if partes.is_empty():
		partes = valoresDefault.partes
		
		for partePath in Utility.FileManipulation.get_file_paths_in_folder(Const.Directorios.PartesGeneradas):
			var armaAUsar:=ConfigFile.new()
			armaAUsar.load(partePath)
			var armaDict:Dictionary = armaAUsar.get_value("Main","Main")
			partes.append(armaDict.duplicate())
			
		for partePathUser in Utility.FileManipulation.get_file_paths_in_folder(Const.DirectoriosUser.PartesGeneradas):
			var armaAUsar:=ConfigFile.new()
			armaAUsar.load(partePathUser)
			var armaDict:Dictionary = armaAUsar.get_value("Main","Main")
			partes.append(armaDict.duplicate())
			
	if arma == null:
		arma = ArmaMarco.new()
		
	setup_new_arma()
	fill_lista()

func reset_view():
	arma.position = get_rect().size / 2
	camara.position = get_rect().size / 2

func setup_new_arma(armaDict:Dictionary = ArmaMarco.new().get_save_dict()  ):
	if arma:
		arma.queue_free()
		await get_tree().process_frame
	
	var nuevaArma:ArmaMarco = ArmaMarco.generate_from_dict(armaDict)
	var thing = 1
	viewport.add_child( nuevaArma )
	
	arma = nuevaArma
	
	arma.refresh_partes_from_slots()
	reset_view()
	
	refresh_visual_encastres()
	
func select_pieza(representacion:RepresentacionParte):
	parteSeleccionada = representacion.parteDict
	if arma.get("nodosPartes").is_empty():#Si no hay piezas aun, añadir la seleccionada
		add_parte(arma.SlotDefault, parteSeleccionada, true )
		
	
func add_parte(slot:Vector3,parte:Dictionary=parteSeleccionada,forzar=false):
	var valido:bool
	arma.add_conexion(parte,slot,forzar)#TEMP true
	arma.refresh_partes_from_slots()
	
	refresh_visual_encastres()
	reset_view()
	
func fill_lista():
	for parte in partes:
		var representacion:RepresentacionParte = RepresentacionParte.new(parte)
		listaPiezas.add_child(representacion)
		representacion.SELECTED_WEAPON.connect(select_pieza)



	
#func display_piezas():
#	for parte in arma.piezasConectadas:
var listaBotones:Dictionary
func refresh_visual_encastres():

	var testSlots = arma.slots
	for slot in arma.slots:
		if arma.slots[slot] == null:
			var posicion = Vector2(slot.x,slot.y)
			var button:Button = Button.new()
			add_child(button)
			
			button.position = Vector2(posicion.x, posicion.y) + arma.position
			button.offset_right = 0
			button.offset_bottom = 0
			button.size = Vector2(8,8)
			button.pivot_offset = size / 2
			button.modulate = Color(1,0,0,0.5)
			button.icon = load("res://icon.png")
			
			button.pressed.connect(add_parte.bind(slot))
		else:
			print(str(slot) + " ya esta en uso.")
			

		

func load_arma(armaFile:String):
#	var armaAUsar:= ConfigFile.new()
#	armaAUsar.load(armaFile)
#	var armaDict:Dictionary = armaAUsar.get_value("Main","Main")
#	setup_new_arma( armaDict ) 
	var armaAUsar:ArmaGuardada = load(armaFile)
	var armaDict:Dictionary = armaAUsar.datos
	setup_new_arma( armaDict.duplicate() ) 

func rename_arma(nombreNuevo:String):
	if arma:
		arma.nombre = nombreNuevo
	$Viewport/UI/LineEdit.text = ""
	

func save_arma():
	var dir:Directory = Directory.new()
	dir.make_dir_recursive(Const.Directorios.ArmasGeneradas)
	
#	var armaFile:ConfigFile = ConfigFile.new()
#	armaFile.set_value( "Main","Main",arma.get_save_dict() )
#	print( "Creado archivo con codigo de error: " + str(armaFile.save(Const.Directorios.ArmasGeneradas + arma.nombre + ".ini")) )
	var armaFile:=ArmaGuardada.new()
	var armaDict = arma.get_save_dict()
	armaFile.datos = arma.get_save_dict().duplicate()
	print( "Creado archivo (res) con codigo de error: " + str(ResourceSaver.save(armaFile, Const.DirectoriosUser.ArmasGeneradas + arma.nombre + ".tres")) )
	print( "Creado archivo (user) con codigo de error: " + str(ResourceSaver.save(armaFile, Const.Directorios.ArmasGeneradas + arma.nombre + ".tres")) )
	

	
	
#	var logrado = ResourceSaver.save(armaFile, "user://ArmasGuardadas/" + arma.nombre + ".tscn", 2)
#	if logrado != OK:
#		push_error( "No se pudo guardar! Codigo de error: " + str(logrado) )
	

class RepresentacionParte extends Button:
	
	signal SELECTED_WEAPON
	
	var parteDict:Dictionary

	func _init(dictArma):
		parteDict = dictArma

	func _ready() -> void:
		toggle_mode = true
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
#		size_flags_vertical = Control.SIZE_EXPAND_FILL
		custom_minimum_size = Vector2(64,128)
		anchor_right = 1.0
		anchor_bottom = 1.0
		icon = load( parteDict["texturaSprite"] )
		

	func _toggled(presionado):
		if presionado:
			emit_signal("SELECTED_WEAPON",self)
		
		
		
