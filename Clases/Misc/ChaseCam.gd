extends Camera2D
class_name ChaseCam

export(Rect2) var areaLimite:Rect2 = Rect2( Vector2(limit_left,limit_top), Vector2(limit_right,limit_bottom)*2 )

func _ready() -> void:
	limit_left = areaLimite.position.x
	limit_top = areaLimite.position.y
	limit_right = areaLimite.end.x
	limit_bottom = areaLimite.end.y
	

func _physics_process(delta: float) -> void:
	if Ref.jugador and not Ref.jefes.empty():
		var posicionJugador:Vector2 = Ref.jugador.position
		var posicionJefes:Vector2 = get_average_position(Ref.jefes)
#		var distancia:Vector2 = Vector2(posicionJugador.x - posicionJefes.x,posicionJugador.y)
		position = (posicionJugador + posicionJefes) / 2

		
		
		var porcentajeZoom = clamp( posicionJugador.distance_to(posicionJefes) / 1024, 0.25, 1.5 )
		zoom = Vector2(porcentajeZoom, porcentajeZoom) + Vector2(0.1,0.1) 

func get_average_position(nodos:Array):
	var average:Vector2
	for nodo in nodos:
		assert( nodo != null and nodo.get("position") != null )
		average += nodo.position
		
	average /= nodos.size()
	if nodos.empty():
		return Vector2.ZERO
	else:
		return average
		
