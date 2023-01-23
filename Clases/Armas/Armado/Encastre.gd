extends Position2D
class_name ArmaEncastre


#const Direcciones = {
#	"IZQUIERDA":1<<0,
#	"DERECHA":1<<1,
#	"ARRIBA":1<<2,
#	"ABAJO":1<<3}
#export (Direcciones) var direccion
var usado:bool
var piezaPadre:Node
var piezaConectada:Node
	
export (Array,Const.piezas) var piezasCompatibles

func _ready() -> void:
	piezaPadre = get_parent()

static func get_encastre_identifier(textura:Texture, colorEncastre:Color= Color(168,202,88)):
	var imagen:Image = textura.get_data()
	imagen.lock()#Debe estar en solo lectura para leer sus pixeles
	
	var pixelesVerdes:Image = imagen.duplicate() #Aqui se guardaran los pixeles verdes
	pixelesVerdes.lock()
	pixelesVerdes.fill(Color(0,0,0,0))#Borrar todos los pixeles 

	
	var marco:Rect2 = Rect2(Vector2.ZERO,imagen.get_size())#El marco es el area donde se buscara el color
	
	if textura is AtlasTexture:#Si es un Atlas, el marco deberia encuadrar solo la imagen recortada
		marco = textura.region
		
	for pixelX in range(marco.position.x, marco.end.x):
		for pixelY in range(marco.position.y, marco.end.y):

			var colorPixel:Color = imagen.get_pixel(pixelX,pixelY)
			
			if colorPixel == colorEncastre:
				pixelesVerdes.set_pixel(pixelX,pixelY, colorEncastre)
				
	marco = pixelesVerdes.get_used_rect()
	
	var imagenEncastre:Image = pixelesVerdes
	imagenEncastre.fill( Color(0,0,0,0) )
	imagenEncastre.resize(marco.size.x, marco.size.y)
	
	for pixelX in range(marco.position.x, marco.end.x):
		for pixelY in range(marco.position.y, marco.end.y):
			
			imagenEncastre.set_pixel(pixelX,pixelY,colorEncastre)
	
