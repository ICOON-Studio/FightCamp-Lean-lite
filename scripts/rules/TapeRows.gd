extends RefCounted
## One tale of the tape. Every screen reads this list; none builds its own.
##   rows(f, opp, her_cm) -> [{label, left, right, better, why}]
## Order: Record, Age, Weight, Height, Reach (only when both numbers are known), Stance, Style.
## A fact missing for the opponent is "?" and why is the tooltip ("not on tape").
## better is "left", "right" or "". Record: more wins, then fewer losses. Height and reach: the longer one.
## her_cm is the drawn body when the club boxer has no measured height. Reach follows that height until measured.
## Pure. No preloads.

const ORDER := ["Record", "Age", "Weight", "Height", "Reach", "Stance", "Style"]
const MISSING := "?"
const WHY := "not on tape"


static func rows(f: Dictionary, opp: Dictionary, her_cm: float = 0.0) -> Array:
	var h_a := _own(f, "height", her_cm)
	var h_b := _theirs(opp, "height")
	var r_a := _own(f, "reach", h_a)
	var r_b := _theirs(opp, "reach")
	var out: Array = [_record(f, opp), _age(f, opp), _weight(f, opp), _span("Height", h_a, h_b)]
	if r_a > 0.0 and r_b > 0.0:
		out.append(_span("Reach", r_a, r_b))
	out.append(_named("Stance", str(f.get("stance", "")), str(opp.get("stance", "")), true))
	out.append(_named("Style", str(f.get("style", "")), str(opp.get("style", "")), false))
	return out


static func _own(f: Dictionary, key: String, fallback: float) -> float:
	var n := float(f.get(key, 0.0))
	return n if n > 0.0 else fallback


static func _theirs(opp: Dictionary, key: String) -> float:
	if not opp.has(key):
		return 0.0
	return float(opp[key])


static func _record(f: Dictionary, opp: Dictionary) -> Dictionary:
	var lw := int(f.get("w", 0))
	var ll := int(f.get("l", 0))
	var known := opp.has("w") or opp.has("l")
	var rw := int(opp.get("w", 0))
	var rl := int(opp.get("l", 0))
	return {"label": "Record", "left": "%d-%d" % [lw, ll], "right": ("%d-%d" % [rw, rl]) if known else MISSING,
		"better": _record_better(lw, ll, rw, rl) if known else "", "why": "" if known else WHY}


## More wins, then fewer losses. Equal records have no better side.
static func _record_better(lw: int, ll: int, rw: int, rl: int) -> String:
	if lw == rw and ll == rl:
		return ""
	if lw > rw or (lw == rw and ll < rl):
		return "left"
	return "right"


static func _age(f: Dictionary, opp: Dictionary) -> Dictionary:
	var known := opp.has("age") and int(opp["age"]) > 0
	return {"label": "Age", "left": str(int(f.get("age", 0))), "right": str(int(opp["age"])) if known else MISSING,
		"better": "", "why": "" if known else WHY}


static func _weight(f: Dictionary, opp: Dictionary) -> Dictionary:
	var w := opp_weight(opp, float(f.get("limit", 0.0)))
	var known := w > 0.0
	return {"label": "Weight", "left": "%.1f kg" % float(f.get("weight", 0.0)),
		"right": ("%.1f kg" % w) if known else MISSING, "better": "", "why": "" if known else WHY}


## S420 operator ("reach is not shown ... i meant weight"): the opponent's weight. Her own number when the table has one;
## otherwise she makes weight like an amateur does, 0.2 to 0.8 kg under the class limit, the same every time (her name).
## 0 when neither is known.
static func opp_weight(opp: Dictionary, limit: float) -> float:
	if opp.has("weight") and float(opp["weight"]) > 0.0:
		return float(opp["weight"])
	if limit <= 0.0:
		return 0.0
	var under := 0.2 + float(absi(hash(str(opp.get("name", "")))) % 7) * 0.1
	return snappedf(limit - under, 0.1)


static func _span(label: String, a: float, b: float) -> Dictionary:
	var known := b > 0.0
	return {"label": label, "left": _cm(a), "right": _cm(b) if known else MISSING,
		"better": _longer(a, b), "why": "" if known else WHY}


static func _longer(a: float, b: float) -> String:
	if a <= 0.0 or b <= 0.0 or is_equal_approx(a, b):
		return ""
	return "left" if a > b else "right"


static func _named(label: String, left: String, right: String, cap: bool) -> Dictionary:
	var known := right.strip_edges() != ""
	return {"label": label, "left": _show(left, cap), "right": _show(right, cap) if known else MISSING,
		"better": "", "why": "" if known else WHY}


static func _show(s: String, cap: bool) -> String:
	var t := s.strip_edges()
	if t == "":
		return MISSING
	return t.capitalize() if cap else t


static func _cm(n: float) -> String:
	return "-" if n <= 0.0 else "%d cm" % int(round(n))
