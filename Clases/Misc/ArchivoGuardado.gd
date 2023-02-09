extends Resource
class_name ArchivoGuardado


export (String) var nombre
export (Dictionary) var datosJugador


var dir := Directory.new()
var dirPathActivo:String



func prepare_folders():
	var dirActivo = Const.Directorios.PartidasGuardadas + nombre + "/"
	dir.make_dir_recursive(dirActivo + Const.Directorios.PiezasGeneradas)
	dir.make_dir_recursive(dirActivo + Const.Directorios.BlueprintsArmas)
	
