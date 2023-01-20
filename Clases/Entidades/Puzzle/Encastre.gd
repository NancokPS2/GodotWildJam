extends Position2D
class_name EncastrePuzzle

func activacion(valor:bool):
	var node = get_child(0)
	node.monitorable = valor
	node.monitoring = valor
	var ass = 1
	

#const Direcciones = {
#	"IZQUIERDA":1<<0,
#	"DERECHA":1<<1,
#	"ARRIBA":1<<2,
#	"ABAJO":1<<3}
#export (Direcciones) var direccion

const Encastres = {
	"DOS":1<<4,
	"UPLANA":1<<5,
	"MONTANA":1<<6,
	"SEMIL":1<<7}
	
export (Encastres) var encastre


var frame:bool
