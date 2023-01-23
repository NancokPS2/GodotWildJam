extends Node
const colores = {
	0:Color(0,0,255),
	1:Color(0,255,0),
	2:Color(1, 0.843137, 0, 1),
	3:Color(255,0,0)
}

const gravedad = 800

#enum materiales  { ROCA, ACERO, TECNICITA }

enum tipoArma {ESPADA,LANZA,MAZO,HACHA,RANGO}

const piezas = {
	"MANGO":0<<1,
	"HOJA_ESPADA":0<<2,
	"HOJA_LANZA":0<<3,
	"HOJA":0<<4
	}

const tamanoEncastres = 1.0

var debugMode = true

enum elementos {NINGUNO,FUEGO,TIERRA,AGUA,AIRE}
