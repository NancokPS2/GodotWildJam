extends Resource
class_name ArchivoGuardado


@export var nombre:String
@export var datosJugador:Dictionary


var dir := Directory.new()
var dirPathActivo:String



func prepare_folders():
	var dirActivo = Const.Directorios.PartidasGuardadas + nombre + "/"
	dir.make_dir_recursive(dirActivo + Const.Directorios.PartesGeneradas)
	dir.make_dir_recursive(dirActivo + Const.Directorios.ArmasGeneradas)
	dir.make_dir_recursive(dirActivo + Const.Directorios.BlueprintsArmas)
	
