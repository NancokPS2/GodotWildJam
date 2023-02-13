extends Resource
class_name ArchivoGuardado


@export var nombreArchivo:String
@export var armasAdquiridas:Array[String]
@export var armasEquipadas:Array[String]

@export var partesAdquiridas:Array[String]


var dir := Directory.new()
var dirPathActivo:String



func prepare_folders():
	for directorio in Const.DirectoriosUser:
		dir.make_dir_recursive(directorio)
		
		
func save_self():
	ResourceSaver.save(self, Const.DirectoriosUser.PartidasGuardadas + nombreArchivo + ".tres")
	

