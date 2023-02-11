extends SubViewportContainer
class_name ArmaCreador

@onready var valoresDefault:Dictionary = {
	"piezas":[ load("res://Objetos/Armas/Partes/BasicHilt.tscn").duplicate(), load("res://Objetos/Armas/Partes/Blade.tscn").duplicate() ],
	"arma":load("res://Objetos/Armas/Guardadas/EspadaSimple.tscn")
}

var arma:ArmaMarco
var camara:Camera2D
var buttonGroup:ButtonGroup = ButtonGroup.new()
@onready var viewport = $Viewport
@onready var listaPiezas = $Viewport/UI/ListaPiezas

var piezas:Array

var parteSeleccionada:Node

func _ready():
	#TEMP
#	arma = load("res://Objetos/Armas/Guardadas/EspadaSimple.tscn").instantiate()
	
	
	listaPiezas.anchor_right = 0.2
	listaPiezas.anchor_bottom = 1.0
	
	camara = Utility.ControllableCamera2D.new()
	viewport.add_child(camara)
	
	$Viewport/UI/FileDialog.file_selected.connect(load_arma)
	$Viewport/UI/Abrir.pressed.connect( Callable($Viewport/UI/FileDialog, "popup") )
	$Viewport/UI/Guardar.pressed.connect(save_arma)
	$Viewport/UI/LineEdit.text_submitted.connect(rename_arma)
#	camara.current = true
#	camara.zoom *= 0.3
	
	if piezas.is_empty():
		piezas = valoresDefault.piezas
	if arma == null:
		arma = valoresDefault.arma.instantiate()
		
	setup_new_arma()
	fill_lista()

func reset_view():
	arma.position = get_rect().size / 2
	camara.position = get_rect().size / 2

func setup_new_arma(armaDict:Dictionary = ArmaMarco.new().get_save_dict()  ):
	if arma:
		arma.queue_free()
		await get_tree().process_frame
	
	var nuevaArma:ArmaMarco = ArmaMarco.new()
	nuevaArma = nuevaArma.generate_from_dict(armaDict)
	viewport.add_child( nuevaArma )
	arma = nuevaArma
	
	refresh_visual_encastres()
	reset_view()
	
func select_pieza(representacion:RepresentacionParte):
	parteSeleccionada = representacion.referenciaParte
	if arma.get("nodosPartes").is_empty():#Si no hay piezas aun, añadir la seleccionada
		add_parte( parteSeleccionada.get_save_dict(), ArmaParte.EncastreFormato, true )
		
	
func add_parte(parte:Dictionary,encastre:Dictionary,forzar=false):
	var valido:bool
	arma.add_conexion(parte,encastre,forzar)#TEMP true
	arma.refresh_partes_from_conexiones()
	
	refresh_visual_encastres()
	reset_view()
	
func fill_lista():
	for parte in piezas:
		var representacion:RepresentacionParte = RepresentacionParte.new(parte)
		listaPiezas.add_child(representacion)
		representacion.SELECTED_WEAPON.connect(select_pieza)



	
#func display_piezas():
#	for parte in arma.piezasConectadas:
var listaBotones:Dictionary
func refresh_visual_encastres():
	var encastres = arma.get("encastresDePartes")
	for encastre in encastres:
		if not encastre.is_empty() and not encastre["usado"]:
			var posicion = encastre["posicion"]
			var button:Button = Button.new()
			add_child(button)
			
			button.position = Vector2(posicion.x, posicion.y)
			button.offset_right = 0
			button.offset_bottom = 0
			button.size = Vector2(8,8)
			button.pivot_offset = size / 2
			button.pressed.connect(add_parte.bind(parteSeleccionada,posicion))
		else:
			print(str(encastre) + " ya esta en uso.")
			

		

func load_arma(armaCargada:PackedScene):
	var armaAUsar = armaCargada.instantiate()
	if armaAUsar is ArmaMarco:
		setup_new_arma(armaAUsar.instantiate())

func rename_arma(nombreNuevo:String):
	if arma:
		arma.nombre = nombreNuevo
	$Viewport/UI/LineEdit.text = ""
	

func save_arma():
	var dir:Directory = Directory.new()
	if not dir.dir_exists("user://ArmasGuardadas"):
		dir.make_dir("user://ArmasGuardadas")
	
	var armaAGuardar:PackedScene = PackedScene.new()
	armaAGuardar.pack(arma.duplicate())
	
	var logrado = ResourceSaver.save(armaAGuardar, "user://ArmasGuardadas/" + arma.nombre + ".tscn", 2)
	if logrado != OK:
		push_error( "No se pudo guardar! Codigo de error: " + str(logrado) )
	

class RepresentacionParte extends Button:
	
	signal SELECTED_WEAPON
	
	var referenciaParte:ArmaParte

	func _init(referencia):
		referenciaParte = referencia.instantiate().duplicate()

	func _ready() -> void:
		toggle_mode = true
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
#		size_flags_vertical = Control.SIZE_EXPAND_FILL
		custom_minimum_size = Vector2(64,128)
		anchor_right = 1.0
		anchor_bottom = 1.0
		
		add_child(referenciaParte)
		resized.connect(center_part)
		
	func center_part():
		referenciaParte.position = get_rect().size / 2

	func _toggled(presionado):
		if presionado:
			emit_signal("SELECTED_WEAPON",self)
		
		
		
