extends CanvasLayer

var jugador:Jugador
var jefes:Array

func _ready() -> void:

	get_tree().node_added.connect(track_entity_health)
	await get_tree().create_timer(1).timeout
	track_entity_health(Ref.jugador)
	track_entity_health(Ref.jefes[0])


func track_entity_health(entidad:Node):
	if Ref.jefes.has(entidad):
		jefes.append(entidad)
		if jefes.size() > 1:#Si ya hay un jefe
			add_child( $Control/VidaJefe.duplicate() ) #Añadir otra barra de vida
			entidad.VIDA_CAMBIO.connect(update_boss_health)
		update_boss_health(entidad)
		
	elif Ref.jugador == entidad:
		jugador = entidad
		entidad.VIDA_CAMBIO.connect(update_player_health)
		update_player_health(jugador)
		

		
		
var tweenJugador
func update_player_health(quien:Entidad):#El quien es proveido por la señal
#	$Control/Vida.value = quien.estadisticas.salud
#	$Control/Vida.max_value = quien.estadisticas.saludMaxima
	$Control/VidaJugador.frame = clamp( (quien.estadisticas["salud"]-1) ,0,9)
	if quien.estadisticas.salud <= 1:
		tweenJugador = get_tree().create_tween()
		tweenJugador.bind_node($Control/VidaJugador).set_loops()
		tweenJugador.tween_property($Control/VidaJugador,"modulate",Color(1,0.4,0.4,1),0.9) 
		tweenJugador.chain().tween_property($Control/VidaJugador,"modulate",Color(1,1,1,1),0.9) 
		tweenJugador.play()
	elif tweenJugador:
		$Control/VidaJugador.modulate = Color(1.0,1.0,1.0,1.0)
		tweenJugador.kill()
			


func update_boss_health(quien:Entidad):
	$Control/VidaJefe.value = quien.estadisticas.salud
	$Control/VidaJefe.max_value = quien.estadisticas.saludMaxima
