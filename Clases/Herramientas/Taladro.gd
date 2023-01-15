extends Herramienta
class_name HerramientaTaladro

export (float) var alcanze = 50
export (int) var poder = 1


var rayCast = RayCast2D.new()
var sprite = Sprite.new()



func _ready() -> void:
	rayCast.cast_to = Vector2(alcanze,0)#Darle forma
	add_child(rayCast)#Añadirlo
	
	sprite.centered = true#Centrarlo
	sprite.texture = textura#Darle la imagen
	add_child(sprite)
	
func equip(user:Node):
	rayCast.add_exception(user)
	pass
	
func use(parametro):#Cuando el usuario usa el boton de ataque/usar esto deberia ser llamado
	#parametro puede ser cualquier cosa, en este caso es un diccionario
	rayCast.force_raycast_update()
	var objeto = rayCast.get_collider()
	if objeto:#Primero condfirma que no es null
		if objeto is ParedDestruible:#Revisa su clase
			objeto.damage(poder * parametro["delta"])#Dañar la pared
		elif objeto is Entidad:#Dañar la entidad
			objeto.hurt(poder * parametro["delta"])

#func enable(activado):
#	.enable(activado) #Usar el enable() definido en Herramienta antes de seguir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:#Si es un movimiento de mouse
		follow_mouse()
		
