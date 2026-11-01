extends RefCounted
## S332 (every HOME look the operator was shown, Q-S294-52, puts the boxers' faces on the page): each woman in the region
## has her OWN MetaHuman body. Before, FightCast picked one of 3 bodies by weight class, so every lightweight opponent
## wore the same face. Pure static; zero preloads.
##   stem(f) -> "mh_boxer_NN"   pair(f, opp) -> [ours, theirs] (never the same body)   cm(stem) -> standing height
##   glb(stem) -> res:// path
## A fighter not in CAST (a new walk-in) gets a steady body by her name; the opponent never shares her corner's.

const DIR := "res://assets/models/metahuman/"
## Standing height of each body (mh_boxer_NN.json height_cm).
const CM := {"mh_boxer_10": 162.0, "mh_boxer_11": 169.0, "mh_boxer_12": 178.0, "mh_boxer_13": 165.0,
	"mh_boxer_14": 170.0, "mh_boxer_15": 167.0, "mh_boxer_16": 169.0, "mh_boxer_17": 166.0, "mh_boxer_18": 168.0,
	"mh_boxer_19": 163.0, "mh_boxer_20": 170.0}
## The region's women's lightweights (Data.lucy, OPPONENTS, MISMATCH, RIVALS), one body each. S333: Erin, Dana and Sophie
## (a new 18) are blends of the best faces (Tools/metahuman face_blend; operator "make them all hotter").
## S334 (Q-S294-55 "make some younger too 16-18 yo"): the scouting prospects Kira (19) and Samira (20), both 18, on
## young base skins (Zuri, Asha) pulled toward Celeste.
const CAST := {"Lucy Jackson": "mh_boxer_11", "Maria Ortega": "mh_boxer_13", "Priya Nair": "mh_boxer_14",
	"Erin Doyle": "mh_boxer_15", "Dana Whitfield": "mh_boxer_16", "Chloe Bennett": "mh_boxer_17",
	"Aisha Rahman": "mh_boxer_10", "Megan Hughes": "mh_boxer_12", "Sophie Turner": "mh_boxer_18",
	"Kira Mensah": "mh_boxer_19", "Samira Khan": "mh_boxer_20"}


static func stem(f: Dictionary) -> String:
	var nm := str(f.get("name", ""))
	if CAST.has(nm):
		return str(CAST[nm])
	var pool: Array = CM.keys()
	pool.sort()
	return str(pool[absi(hash(nm)) % pool.size()])


static func pair(f: Dictionary, opp: Dictionary) -> Array:
	var a := stem(f)
	var b := stem(opp)
	if a == b:
		var pool: Array = CM.keys()
		pool.sort()
		b = str(pool[(pool.find(a) + 1) % pool.size()])
	return [a, b]


static func cm(s: String) -> float:
	return float(CM.get(s, 169.0))


static func glb(s: String) -> String:
	return DIR + s + ".glb"
