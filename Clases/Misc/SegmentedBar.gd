extends HBoxContainer

export (Texture) var texturaSegmento
export (Dictionary) var margenes = {
	"left":0,
	"top":0,
	"right":0,
	"bottom":0
}

var refSegmentos:Array
var listoParaUsar:bool

export (int) var value:int = 0 setget set_value 
export (int) var max_value:int

func _ready() -> void:
	
	listoParaUsar = true
	
	refresh_segments()


func set_value(valor):
	value = clamp(valor,0,max_value)
	if listoParaUsar:
		refresh_segments()
	
	
func refresh_segments():
	while refSegmentos.size() != value:
		
		if refSegmentos.size() < value:
			var nuevoSegmento = Segmento.new()
			nuevoSegmento.margin_top = margenes.top
			nuevoSegmento.margin_left = margenes.left
			nuevoSegmento.margin_right = margenes.right
			nuevoSegmento.margin_bottom = margenes.bottom
			nuevoSegmento.texture = texturaSegmento
			
			refSegmentos.append(nuevoSegmento)
			add_child(nuevoSegmento)
		
		elif refSegmentos.size() > value:#Si hay mas de los necesarios
			var segmentoABorrar:NinePatchRect = refSegmentos.pop_back()#Remover uno del array
			segmentoABorrar.queue_free()
			
#	for segmento in refSegmentos:#Revisar todos los segmentos
#		if segmento.get_parent() != self:#Si no es hijo de esta barra
#			add_child(segmento)#Añadirlo

class Segmento extends NinePatchRect:
	func _ready() -> void:
		size_flags_horizontal = SIZE_EXPAND_FILL
		size_flags_vertical = SIZE_EXPAND_FILL
		
		
