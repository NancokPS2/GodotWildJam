extends CanvasLayer

var jugador:Jugador
var jefes:Array

func _ready() -> void:
	get_tree().connect("node_added",self,"track_entity_health")
	yield(get_tree().create_timer(1),"timeout")
	track_entity_health(Ref.jugador)
	track_entity_health(Ref.jefes[0])


func track_entity_health(entidad:Node):
	if Ref.jefes.has(entidad):
		jefes.append(entidad)
		if jefes.size() > 1:#Si ya hay un jefe
			add_child( $Control/VidaJefe.duplicate() ) #Añadir otra barra de vida
			entidad.connect("VIDA_CAMBIO",self,"update_boss_health")
		
	elif Ref.jugador == entidad:
		jugador = entidad
		entidad.connect("VIDA_CAMBIO",self,"update_player_health")
		


func update_player_health(quien):#El quien es proveido por la señal
	$Control/Vida.value = quien.estadisticas.salud
	$Control/Vida.max_value = quien.estadisticas.saludMaxima


func update_boss_health(quien):
	$Control/VidaJefe.value = quien.estadisticas.salud
	$Control/VidaJefe.max_value = quien.estadisticas.saludMaxima
