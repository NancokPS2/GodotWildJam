extends Resource
class_name ArmaBlueprint

export (String) var nombreArma

export (Array,String) var piezasACargar
export (Dictionary) var conexiones

static func can_save():
	var dir:=Directory.new()
	if not Ref.partidaActual:
		push_error("La partida actual es nula.")
		return false
	
	elif Ref.partidaActual.get("name") == null:
#		push_error("La partida "+ str(Ref.partidaActual)  +" de nombre " + Ref.partidaActual.get("name") + " no es valida.")
		push_error("La partida actual no tiene nombre.")
		return false
		
	else:
		return true
		

func save_to_blueprint(arma:ArmaMarco) -> ArmaBlueprint:
	var blueprint = ArmaBlueprint.new()
	
	#Piezas
	var piezas:Array
	for pieza in arma.piezasConectadas:
		var piezaPath:String = pieza.filename
		if piezaPath == "":
			piezaPath = generate_pieza_scene( pieza.duplicate() )
			
		piezas.append(piezaPath)	
	blueprint.piezasACargar = piezas
	
	#Conexiones
	conexiones = arma.encastresEnUso
		
	return blueprint
	
func generate_pieza_scene(pieza:ArmaParte)->String:
	var escenaPieza:PackedScene = PackedScene.new()
	var dir:Directory = Directory.new()
	var dirArma:String = Const.Directorios.PartidasGuardadas + Const.Directorios.PiezasGeneradas + pieza.nombre + "/"
	
	dir.make_dir_recursive(dirArma)
	escenaPieza.pack(pieza)
	pieza.nombre = Utility.FileManipulation.ensure_unique_filename(dirArma,pieza.nombre,Utility.FileManipulation.FileNameFormats.NUMBERED)
	
	print( "Codigo de guardado: " + str( ResourceSaver.save(dirArma + pieza.nombre + ".tscn", escenaPieza) ) )
	
	return dirArma + pieza.nombre + ".tscn"

static func build_from_blueprint(blueprint:ArmaBlueprint):
	var piezasCargadas:Array
	var armaNueva:=ArmaMarco.new()
	for pieza in blueprint.piezasACargar:
		piezasCargadas.append(load(pieza).instance().duplicate())
		
	for conexion in blueprint.conexiones:#WIP
		armaNueva
		
	pass


