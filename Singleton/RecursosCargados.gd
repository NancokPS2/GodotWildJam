extends Node

const Directorios:Dictionary = {
	"Armas":"res://Objetos/Armas/Guardadas/",
	"ArmasGeneradas":"user://ArmasGuardadas/",
	
	"Partes":"res://Objetos/Armas/Partes/",
	"PartesGeneradas":"user://PartesGeneradas"
}

var armas:Array[Dictionary]
var partes:Array[Dictionary]

func _init() -> void:
	load_res()

func load_res():
	var dir:=Directory.new()#Preparar todas las carpetas si no existen
	for directorio in Directorios:
		dir.make_dir_recursive(Directorios[directorio])
		
	armas.append_array( Utility.FileManipulation.get_files_in_folder(Directorios.Armas) )
	partes.append_array( Utility.FileManipulation.get_files_in_folder(Directorios.Partes) )


func get_arma(identif:String,generada:bool):
	var armaEncontrada:Dictionary = {}
	for arma in armas:
		if arma.get("identificador") == identif:
			armaEncontrada = arma.duplicate()
			break
	
	if generada and 1!=1:#TEMP
		return ArmaMarco.generate_from_dict(armaEncontrada)
	else:
		return armaEncontrada
	
	if armaEncontrada == {}:
		push_error("No se encontro un arma con el identificador: " + identif)
		return {}
		
	
	pass
	
func get_parte(identif:String,generada:bool):
	var parteEncontrada:Dictionary = {}
	for parte in partes:
		if parte.get("identificador") == identif:
			parteEncontrada = parte
			break
	
	if parteEncontrada == {}:
		push_error("No se encontro una parte con el identificador: " + identif)
		return {}
	
	if generada:
		return ArmaParte.generate_from_dict(parteEncontrada)
	else:
		return parteEncontrada
		
	
	
