extends RefCounted
## One tale of the tape. Every screen reads this list; none builds its own.
##   rows(f, opp, her_cm) -> [{label, left, right, better, why}]
## Order: Record, Last 5, Streak (S535: form, see the foot of this file), Age, Weight, Height, Reach (only when both
## numbers are known), Stance, Style.
## A fact missing for the opponent is "?" and why is the tooltip ("not on tape").
## better is "left", "right" or "". Record: more wins, then fewer losses. Height and reach: the longer one.
## her_cm is the drawn body when the club boxer has no measured height. Reach follows that height until measured.
## Pure. No preloads.

const ORDER := ["Record", "Last 5", "Streak", "Age", "Weight", "Height", "Reach", "Stance", "Style"]
const MISSING := "?"
const WHY := "not on tape"
const NONE := "-"
const NO_BOUTS := "no bouts yet"
const FORM_KEEP := 5


static func rows(f: Dictionary, opp: Dictionary, her_cm: float = 0.0) -> Array:
	var h_a := _own(f, "height", her_cm)
	var h_b := _theirs(opp, "height")
	var r_a := _own(f, "reach", h_a)
	var r_b := _theirs(opp, "reach")
	var out: Array = [_record(f, opp)]
	out.append_array(_form_rows(f, opp))
	out.append_array([_age(f, opp), _weight(f, opp), _span("Height", h_a, h_b)])
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


## --- S535 OFFERTAPE1: form (owner C449 on the tape: "maybe add streak/latest results?") ---------------------------------
## A boxer's last FORM_KEEP bouts, newest first, as marks: W, L, D; inside the distance W(KO) / L(KO).
##   x["form"]   the small list a pro's record writes (push_form: Matchmaking.apply_result, WorldSim, a ladder draw) and
##               the one TapeForm.fill sets for our boxer and a booked amateur opponent
##   x["bouts"]  an amateur rival's kept record (RivalPast rows), read when there is no form list
## A record with neither is not on tape: "?" with WHY, the record row only. No bouts at all is a dash.

## One bout as a mark.
static func mark(win: bool, stop: bool, draw: bool = false) -> String:
	if draw:
		return "D"
	return ("W" if win else "L") + ("(KO)" if stop else "")


## Marks for kept bout rows, in their order. Reads Career.results rows (win, outcome, cards), RivalPast rows (win, how)
## and PriorBouts rows (win, method): a stoppage names its round, a draw says so.
static func marks(rows: Array) -> Array:
	var out: Array = []
	for r in rows:
		var row: Dictionary = r
		var how := " %s %s %s " % [str(row.get("cards", "")), str(row.get("how", "")), str(row.get("method", ""))]
		var draw := str(row.get("outcome", "")) == "draw" or how.contains(" draw ")
		out.append(mark(bool(row.get("win", false)), how.contains(" round "), draw))
	return out


## Books one result on a boxer's form (newest first, FORM_KEEP kept). Called where a record that keeps no bout list moves.
static func push_form(who: Dictionary, win: bool, stop: bool, draw: bool = false) -> void:
	var form: Array = (who["form"] as Array).duplicate() if who.get("form") is Array else []
	form.push_front(mark(win, stop, draw))
	who["form"] = form.slice(0, FORM_KEEP)


## {known, marks}: what is on tape for this boxer. An old save's boxer (no list of either kind) is not known.
static func form_of(x: Dictionary) -> Dictionary:
	if x.get("form") is Array and not (x["form"] as Array).is_empty():
		return {"known": true, "marks": (x["form"] as Array).slice(0, FORM_KEEP)}
	if x.get("bouts") is Array and not (x["bouts"] as Array).is_empty():
		return {"known": true, "marks": marks((x["bouts"] as Array).slice(0, FORM_KEEP))}
	var n := 0
	for key in ["w", "l", "pro_w", "pro_l", "pro_d"]:
		n += int(x.get(key, 0))
	return {"known": n == 0, "marks": []}


## The run at the top of a form, in words: "3 wins in a row"; one bout says which way it went. "" for no bouts.
static func streak(form: Array) -> String:
	if form.is_empty():
		return ""
	var kind := str(form[0]).left(1)
	var n := 0
	for m in form:
		if str(m).left(1) != kind:
			break
		n += 1
	if n == 1:
		return str({"W": "won the last bout", "L": "lost the last bout"}.get(kind, "drew the last bout"))
	return "%d %s in a row" % [n, str({"W": "wins", "L": "losses"}.get(kind, "draws"))]


## "Last 5" always (a missing form says why); "Streak" when either corner has a bout on tape.
static func _form_rows(f: Dictionary, opp: Dictionary) -> Array:
	var a := form_of(f)
	var b := form_of(opp)
	var why := ""   # the opponent's side, as on every row (the tooltip sits on that cell)
	if not bool(b["known"]):
		why = WHY
	elif (b["marks"] as Array).is_empty():
		why = NO_BOUTS
	var out: Array = [{"label": "Last 5", "left": _form_text(a, false), "right": _form_text(b, false), "better": "", "why": why}]
	if not (a["marks"] as Array).is_empty() or not (b["marks"] as Array).is_empty():
		out.append({"label": "Streak", "left": _form_text(a, true), "right": _form_text(b, true), "better": "", "why": why})
	return out


static func _form_text(form: Dictionary, as_streak: bool) -> String:
	if not bool(form["known"]):
		return MISSING
	var m: Array = form["marks"]
	if m.is_empty():
		return NONE
	return streak(m) if as_streak else " ".join(PackedStringArray(m))
