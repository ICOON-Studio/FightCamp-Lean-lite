extends RefCounted
## S310 (operator: "add the tale of the tape when the fighters stand on their starting corners for a while"). The
## broadcast card before round 1: the two boxers side by side, row by row. Pure static; zero preloads.
##   rows(f, opp, gym, her_cm) -> [[label, red, blue], ...]
## Our fighter has no measured height: her_cm is the body the 3D draws her with (FightCast.BODY_CM by class), and her
## reach is taken as her height (arm span ~ height, the human average) until she has her own.


static func rows(f: Dictionary, opp: Dictionary, gym: String, her_cm: float) -> Array:
	var h_a := float(f.get("height", her_cm))
	var h_b := float(opp.get("height", 0.0))
	return [
		["AGE", str(int(f.get("age", 0))), str(int(opp.get("age", 0)))],
		["HEIGHT", _cm(h_a), _cm(h_b)],
		["REACH", _cm(float(f.get("reach", h_a))), _cm(float(opp.get("reach", h_b)))],
		["WEIGHT", "%.1f kg" % float(f.get("weight", 0.0)), "made weight"],
		["RECORD", "%d-%d" % [int(f.get("w", 0)), int(f.get("l", 0))], "%d-%d" % [int(opp.get("w", 0)), int(opp.get("l", 0))]],
		["STANCE", str(f.get("stance", "orthodox")).capitalize(), str(opp.get("stance", "orthodox")).capitalize()],
		["STYLE", str(f.get("style", "")), str(opp.get("style", ""))],
		["CLUB", gym, str(opp.get("club", ""))],
	]


static func _cm(cm: float) -> String:
	return "-" if cm <= 0.0 else "%d cm" % int(round(cm))
