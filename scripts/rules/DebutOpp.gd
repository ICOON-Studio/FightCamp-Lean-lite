extends RefCounted
## TURNPRO6 (S533) the pro debut's opponent: ONE rule for the bout Roster.turn_pro books and for the chance the offer shows
## (DebutRead), so the screen cannot read a different boxer than the one who turns up. The rating is fixed at signing:
## the boxer's strength with no camp (BoutRules.fight_power, a professional's NO_CAMP_EDGE) less the deal's gap. A gap
## above 0 is a weaker debutant, below 0 a stronger one. Pure static; one preload.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The debutants' names by the signing day (a man boxes a man: the women's list was the only one before S533).
const NAMES_F := ["Kayleigh Doran", "Stacey Mills", "Jodie Kerr", "Paige Whitlow"]
const NAMES_M := ["Callum Reyes", "Darren Platt", "Jamal Otieno", "Lewis Hardcastle"]


static func name_for(f: Dictionary, day: int) -> String:
	var names: Array = NAMES_M if str(f.get("sex", "f")) == "m" else NAMES_F
	return str(names[posmod(day, names.size())])


## The boxer's strength the gap is taken from: today's six fighting stats, a professional with no camp yet.
static func night(stats: Dictionary) -> float:
	return BoutRules.fight_power(stats, {}, 0, "", true)


static func rating(stats: Dictionary, gap: float) -> float:
	return snappedf(night(stats) - gap, 0.1)


## The opponent's dict as the bout carries it. promoter = the house's name (the opponent boxes out of its stable).
static func make(f: Dictionary, gap: float, day: int, promoter: String) -> Dictionary:
	var name := name_for(f, day)
	return {"name": name, "first": name.split(" ")[0], "club": "%s stable" % promoter, "age": 24,
		"stance": "orthodox", "style": "Boxer-puncher", "w": 0, "l": 0, "rating": rating(f["stats"], gap),
		"threat": "Heavy right hand", "weak": "Fades after round 3", "div": f["div"], "pro": true, "sex": str(f.get("sex", "f"))}
