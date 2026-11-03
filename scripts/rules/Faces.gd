extends RefCounted
## S332 (every HOME look the operator was shown, Q-S294-52, puts the boxers' faces on the page): each woman in the region
## has her OWN MetaHuman body. Before, FightCast picked one of 3 bodies by weight class, so every lightweight opponent
## wore the same face. Pure static; zero preloads.
##   stem(f) -> "mh_boxer_NN"   pair(f, opp) -> [ours, theirs] (never the same body)   cm(stem) -> standing height
##   glb(stem) -> res:// path   partner(f) -> the Playbook's sparring partner, her own sex
## A fighter not in CAST (a new walk-in) gets a steady body by her name; the opponent never shares her corner's.
## S372 (operator "Yes, build them"): men box in men's bodies - MEN_CM, six of the nine male MetaHumans built S152/MH4
## (old repo Godot/assets/models/metahuman: the builds that make 57.5-75 kg; 04/09 are heavyweights, and 05 Mateo / 06 Aoi
## read as women in their headshots - left out). Bare-chested, trunks only (operator S372: "male boxers donot wear tops"). A fighter's sex is her "sex", else her division (m*).

const DIR := "res://assets/models/metahuman/"
## Standing height of each body (mh_boxer_NN.json height_cm).
const CM := {"mh_boxer_10": 162.0, "mh_boxer_11": 169.0, "mh_boxer_12": 178.0, "mh_boxer_13": 165.0,
	"mh_boxer_14": 170.0, "mh_boxer_15": 167.0, "mh_boxer_16": 169.0, "mh_boxer_17": 166.0, "mh_boxer_18": 168.0,
	"mh_boxer_19": 163.0, "mh_boxer_20": 170.0, "mh_boxer_21": 168.0, "mh_boxer_22": 171.0, "mh_boxer_23": 165.0}
## The men's bodies (mh_boxer_NN_mh4.json height): Victor 01, Isaiah 02, Kelvin 03, Mikel 07, Orlando 08.
const MEN_CM := {"mh_boxer_01": 183.0, "mh_boxer_02": 174.0, "mh_boxer_03": 179.0, "mh_boxer_07": 177.0,
	"mh_boxer_08": 186.0}
## The region's women's lightweights (Data.lucy, OPPONENTS, MISMATCH, RIVALS), one body each. S333: Erin, Dana and Sophie
## (a new 18) are blends of the best faces (Tools/metahuman face_blend; operator "make them all hotter").
## S334 (Q-S294-55 "make some younger too 16-18 yo"): the scouting prospects Kira (19) and Samira (20), both 18, on
## young base skins (Zuri, Asha) pulled toward Celeste.
## S339 (Q-S294-63 "Yes, all three"): Holly Price, Ellie Ward and Jade Cooper, three more of the region's lightweights.
const CAST := {"Lucy Jackson": "mh_boxer_11", "Maria Ortega": "mh_boxer_13", "Priya Nair": "mh_boxer_14",
	"Erin Doyle": "mh_boxer_15", "Dana Whitfield": "mh_boxer_16", "Chloe Bennett": "mh_boxer_17",
	"Aisha Rahman": "mh_boxer_10", "Megan Hughes": "mh_boxer_12", "Sophie Turner": "mh_boxer_18",
	"Kira Mensah": "mh_boxer_19", "Samira Khan": "mh_boxer_20", "Holly Price": "mh_boxer_21", "Ellie Ward": "mh_boxer_22",
	"Jade Cooper": "mh_boxer_23",
	"Danny Osei": "mh_boxer_02", "Josh Harper": "mh_boxer_01"}


## "m" / "f" when the dict tells (its own "sex", else a men's division id m*); "" when it cannot.
static func sex(f: Dictionary) -> String:
	var s := str(f.get("sex", ""))
	if s == "m" or s == "f":
		return s
	var div := str(f.get("div", ""))
	return "" if div.is_empty() else ("m" if div.begins_with("m") else "f")


static func _pool(s: String) -> Array:
	var pool: Array = (MEN_CM if s == "m" else CM).keys()
	pool.sort()
	return pool


## Her body; `fallback` is the sex to use when the dict cannot tell (a tape's name-only row takes its opponent's).
static func stem(f: Dictionary, fallback: String = "") -> String:
	var nm := str(f.get("name", ""))
	if CAST.has(nm):
		return str(CAST[nm])
	var s := sex(f)
	var pool := _pool(s if not s.is_empty() else fallback)
	return str(pool[absi(hash(nm)) % pool.size()])


static func pair(f: Dictionary, opp: Dictionary) -> Array:
	var a := stem(f, sex(opp))
	var b := stem(opp, sex(f))
	if a == b:
		var pool := _pool("m" if MEN_CM.has(b) else "f")
		b = str(pool[(pool.find(a) + 1) % pool.size()])
	return [a, b]


## The Playbook / combo builder's sparring partner: Maria for a woman, a club lightweight for a man.
static func partner(f: Dictionary) -> Dictionary:
	return {"name": "Tariq Hussain", "div": "mlw"} if sex(f) == "m" else {"name": "Maria Ortega"}


static func cm(s: String) -> float:
	return float(CM.get(s, MEN_CM.get(s, 169.0)))


static func glb(s: String) -> String:
	return DIR + s + ".glb"
