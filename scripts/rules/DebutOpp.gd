extends RefCounted
## TURNPRO6 (S533) the pro debut's opponent: ONE rule for the bout Roster.turn_pro books and for the chance the offer shows
## (DebutRead), so the screen cannot read a different boxer than the one who turns up. The rating is fixed at signing:
## the boxer's strength with no camp (BoutRules.fight_power, a professional's NO_CAMP_EDGE) less the deal's gap. A gap
## above 0 is a weaker debutant, below 0 a stronger one. Pure static; one preload.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## The debutants' names by the signing day (a man boxes a man: the women's list was the only one before S533).
const NAMES_F := ["Kayleigh Doran", "Stacey Mills", "Jodie Kerr", "Paige Whitlow"]
const NAMES_M := ["Callum Reyes", "Darren Platt", "Jamal Otieno", "Lewis Hardcastle"]


## What the debutant brings, as the offer's hover and the fight card say it.
const STYLE := "Boxer-puncher"
const THREAT := "Heavy right hand"
const WEAK := "Fades after round 3"


## promoter = the house's name: two houses calling on the same day put up two different debutants (S534, owner C442: one
## name on both offers read as one opponent).
static func name_for(f: Dictionary, day: int, promoter: String = "") -> String:
	var names: Array = NAMES_M if str(f.get("sex", "f")) == "m" else NAMES_F
	return str(names[posmod(day + promoter.length(), names.size())])


## The boxer's strength the gap is taken from: today's six fighting stats, a professional with no camp yet.
static func night(stats: Dictionary) -> float:
	return BoutRules.fight_power(stats, {}, 0, "", true)


static func rating(stats: Dictionary, gap: float) -> float:
	return snappedf(night(stats) - gap, 0.1)


## The opponent's dict as the bout carries it. promoter = the house's name (the opponent boxes out of its stable).
static func make(f: Dictionary, gap: float, day: int, promoter: String) -> Dictionary:
	var name := name_for(f, day, promoter)
	return {"name": name, "first": name.split(" ")[0], "club": "%s stable" % promoter, "age": 24,
		"stance": "orthodox", "style": STYLE, "w": 0, "l": 0, "rating": rating(f["stats"], gap),
		"threat": THREAT, "weak": WEAK, "div": f["div"], "pro": true, "sex": str(f.get("sex", "f"))}
