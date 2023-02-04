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
	
	camara.current = true
	camara.zoom *= 0.3
	
	if piezas.empty():
		piezas = valoresDefault.piezas
	if arma == null:
		arma = valoresDefault.arma.instance()
		
	setup_new_arma()
	fill_lista()
	add_parte($Viewport/UI/ListaPiezas.get_child(0).referenciaParte, null)

func reset_view():
	arma.position = get_rect().size / 2
	camara.position = get_rect().size / 2

func setup_new_arma(armaMarco:ArmaMarco = ArmaMarco.new()):
	viewport.add_child(armaMarco)
	arma = armaMarco
	reset_view()
	
func add_parte(parte:ArmaParte,encastre:ArmaEncastre):
	if encastre == null:
		arma.add_initial_piece(parte)
	else:
		arma.add_piece(parte,encastre)
		
	reset_view()
	
	
	
func fill_lista():
	for parte in piezas:
		var representacion:RepresentacionParte = RepresentacionParte.new(parte, buttonGroup)
		listaPiezas.add_child(representacion)
		representacion.connect("SELECTED_WEAPON",self,"select_pieza")


func select_pieza(representacion:RepresentacionParte):
	piezaSeleccionada = representacion.referenciaParte
	
#func display_piezas():
#	for parte in arma.piezasConectadas:
		
func refresh_visual_encastres():
	for encastre in arma.encastresLibres:
		print("Arma " + arma.get_name() + " con encastres libres: " + encastre.piezasCompatibles)
	

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
		
		
		
