extends EfectoEstado
class_name EfectoEstadoSangrado

func _proc():
	entidadAfectada.hurt(stacks)
