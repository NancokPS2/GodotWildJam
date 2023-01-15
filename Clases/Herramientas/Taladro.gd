extends Herramienta
class_name HerramientaTaladro

export (float) var alcanze = 1
export (int) var poder = 1


var rayCast = RayCast2D.new()
var sprite = Sprite.new()

var seguirMouse:bool = false


func _ready() -> void:
	rayCast.cast_to = Vector2(alcanze,0)#Darle forma
	add_child(rayCast)#Añadirlo
	
	sprite.centered = true#Centrarlo
	sprite.texture = textura#Darle la imagen
	add_child(sprite)
	
func use():#Cuando el usuario usa el boton de ataque/usar esto deberia ser llamado
	rayCast.force_raycast_update()
	var objeto = rayCast.get_collider()
	if objeto:#Primero confirma que no es null
		if objeto is ParedDestruible:#Revisa su clase
			objeto.damage(poder)#Dañar la pared
		elif objeto is Entidad:#Dañar la entidad
			objeto.hurt(poder)

func enable(activado):
	.enable(activado) #Usar el enable() definido en Herramienta antes de seguir
