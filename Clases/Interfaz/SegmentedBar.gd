extends HBoxContainer
class_name BarraSegmentada

export (Texture) var texturaSegmento
export (Dictionary) var margenes = {
	"left":0,
	"top":0,
	"right":0,
	"bottom":0
}

var refSegmentos:Array
var listoParaUsar:bool

export (int) var max_value:int
export (int) var value:int setget set_value 


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
			nuevoSegmento.rect_min_size = Vector2(get_rect().size.x / max_value, 0)
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
			

class Segmento extends NinePatchRect:
	func _ready() -> void:
#		size_flags_horizontal = SIZE_EXPAND_FILL
		size_flags_vertical = SIZE_EXPAND_FILL
		
		
