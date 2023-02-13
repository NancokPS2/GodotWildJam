extends EfectoEstado
class_name EfectoEstadoVeneno

var metadata:Dictionary = {
	"progreso":0.0,
	"activacion":100.0,
	"intensidad":1
}

func _proc():
	metadata.progreso += stacks
	
	if metadata.progreso > metadata.activacion:
		entidadAfectada.hurt(stacks * metadata.intensidad)
		metadata.intensidad += 1
