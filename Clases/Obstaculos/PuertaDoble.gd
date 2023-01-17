extends Estructura
class_name CompuertaDobleEstructura

const ColMaskDefault:int = 130

onready var parteSup = $Superior
onready var parteInf = $Inferior

var posicionCerradaSup:Vector2 = Vector2.ZERO
var posicionCerradaInf:Vector2 = Vector2.ZERO

export (Vector2) var posicionAbiertaSup:Vector2 = Vector2(0,-32)
export (Vector2) var posicionAbiertaInf:Vector2 = Vector2(0,32)

export (float) var duracion = 0.5


var estado:int 
enum Estados {ABRIR,CERRAR}

func _ready() -> void:
	collision_mask = ColMaskDefault #Este objeto no colisionara con otros, solo con puertas
	parteInf.collision_mask = ColMaskDefault
	parteSup.collision_mask = ColMaskDefault
	
	posicionCerradaInf = parteInf.position
	posicionCerradaSup = parteSup.position

#func _physics_process(delta: float) -> void:
#	match estado:
#		Estados.ABRIR:
#			if areaPasable.get_overlapping_bodies().has(parteSup) or areaPasable.get_overlapping_bodies().has(parteInf):			
#				parteSup.position += Vector2.UP * velocidad * delta
#				parteInf.position += Vector2.DOWN * velocidad * delta
#
#
#		Estados.CERRAR:
#			if parteSup.position > posicionOriginalSup:
#				parteSup.position += Vector2.DOWN * velocidad * delta
#
#			if parteInf.position < posicionOriginalInf:
#				parteInf.position += Vector2.UP * velocidad * delta
#			pass
signal matar_tweens
func open():
	emit_signal("matar_tweens")
	var tweenPuertas:SceneTreeTween = get_tree().create_tween().bind_node(self).set_parallel(true).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	connect("matar_tweens",tweenPuertas,"kill")
	
	tweenPuertas.tween_property(parteSup, "position", posicionAbiertaSup, duracion)
	tweenPuertas.tween_property(parteInf, "position", posicionAbiertaInf, duracion)
	tweenPuertas.play()
	
func close():
	emit_signal("matar_tweens")
	var tweenPuertas:SceneTreeTween = get_tree().create_tween().bind_node(self).set_parallel(true).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	connect("matar_tweens",tweenPuertas,"kill")
	
	tweenPuertas.tween_property(parteSup, "position", posicionCerradaSup, duracion)
	tweenPuertas.tween_property(parteInf, "position", posicionCerradaInf, duracion)
	tweenPuertas.play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("herramienta1"):
		open()
		
	if event.is_action_released("herramienta2"):
		close()
