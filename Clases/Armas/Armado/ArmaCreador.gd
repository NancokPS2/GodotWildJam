extends ViewportContainer
class_name ArmaCreador

onready var valoresDefault:Dictionary = {
	"piezas":[ load("res://Objetos/Armas/Partes/BasicHilt.tscn").duplicate(), load("res://Objetos/Armas/Partes/Blade.tscn").duplicate() ],
	"arma":load("res://Objetos/Armas/Guardadas/EspadaSimple.tscn")
}

var arma:ArmaMarco
var camara:Camera2D
var buttonGroup:ButtonGroup = ButtonGroup.new()
onready var viewport = $Viewport
onready var listaPiezas = $Viewport/UI/ListaPiezas

var piezas:Array

var piezaSeleccionada:Node

func _ready():
	#TEMP
#	arma = load("res://Objetos/Armas/Guardadas/EspadaSimple.tscn").instance()
	
	
	listaPiezas.margin_right = 0.2
	listaPiezas.margin_bottom = 1.0
	
	camara = Utility.ControllableCamera2D.new()
	viewport.add_child(camara)
	
	$Viewport/UI/FileDialog.connect("file_selected", self, "load_weapon")
	$Viewport/UI/Abrir.connect("pressed", $Viewport/UI/FileDialog, "popup")
	$Viewport/UI/Guardar.connect("pressed", self, "save_arma")
	$Viewport/UI/LineEdit.connect("text_entered", self, "rename_arma")
#	camara.current = true
#	camara.zoom *= 0.3
	
	if piezas.empty():
		piezas = valoresDefault.piezas
	if arma == null:
		arma = valoresDefault.arma.instance()
		
	setup_new_arma()
	fill_lista()

func reset_view():
	arma.position = get_rect().size / 2
	camara.position = get_rect().size / 2

func setup_new_arma(armaMarco:ArmaMarco = ArmaMarco.new()):
	if arma:
		arma.queue_free()
		yield(get_tree(),"idle_frame")
	
	viewport.add_child(armaMarco)
	arma = armaMarco
	
	refresh_visual_encastres()
	reset_view()
	
func add_parte(parte:ArmaParte,encastre:ArmaEncastre):
	var valido:bool
	if encastre == null:
		arma.add_initial_piece(parte)
	else:
		valido = arma.add_piece(parte.duplicate(),encastre)
	print( "Valido " + str(valido) )
	refresh_visual_encastres()
	reset_view()
	

	
func fill_lista():
	for parte in piezas:
		var representacion:RepresentacionParte = RepresentacionParte.new(parte, buttonGroup)
		listaPiezas.add_child(representacion)
		representacion.connect("SELECTED_WEAPON",self,"select_pieza")


func select_pieza(representacion:RepresentacionParte):
	piezaSeleccionada = representacion.referenciaParte
	if arma.piezasConectadas.empty():#Si no hay piezas aun, añadir la seleccionada
		add_parte( piezaSeleccionada, null )
	refresh_visual_encastres()
	
#func display_piezas():
#	for parte in arma.piezasConectadas:
		
func refresh_visual_encastres():
	for encastre in arma.encastresLibres:
		print( "Arma " + arma.get_name() + " con encastres libres: " + str(encastre.piezasCompatibles) )
		var button:Button = Button.new()
		encastre.add_child(button)
		
		button.margin_right = 0
		button.margin_bottom = 0
		button.rect_pivot_offset = rect_size / 2
		button.connect("pressed",self,"add_parte",[piezaSeleccionada,encastre])
		

func load_arma(armaCargada:PackedScene):
	var armaAUsar = armaCargada.instance()
	if armaAUsar is ArmaMarco:
		setup_new_arma(armaAUsar.instance())

func rename_arma(nombreNuevo:String):
	if arma:
		arma.nombre = nombreNuevo
	$Viewport/UI/LineEdit.text = ""
	

func save_arma():
	var dir:Directory = Directory.new()
	if not dir.dir_exists("user://ArmasGuardadas"):
		dir.make_dir("user://ArmasGuardadas")
	
	var armaAGuardar:PackedScene = PackedScene.new()
	armaAGuardar.pack(arma)
	
	var logrado:int = ResourceSaver.save("user://ArmasGuardadas/" + arma.nombre + ".tscn", armaAGuardar)
	if logrado != OK:
		push_error( "No se pudo guardar! Codigo de error: " + str(logrado) )
	

class RepresentacionParte extends Button:
	
	signal SELECTED_WEAPON
	
	var referenciaParte:ArmaParte

	func _init(referencia,buttonGroup:ButtonGroup):
		referenciaParte = referencia.instance().duplicate()
		group = buttonGroup

	func _ready() -> void:
		toggle_mode = true
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
#		size_flags_vertical = Control.SIZE_EXPAND_FILL
		rect_min_size = Vector2(64,128)
		margin_right = 1.0
		margin_bottom = 1.0
		
		add_child(referenciaParte)
		connect("resized",self,"center_part")
		
	func center_part():
		referenciaParte.position = get_rect().size / 2

	func _toggled(presionado):
		if presionado:
			emit_signal("SELECTED_WEAPON",self)
		
		
		
