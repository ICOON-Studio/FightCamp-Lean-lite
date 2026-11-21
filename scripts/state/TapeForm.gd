extends RefCounted
## S535 OFFERTAPE1 (owner C449: "maybe add streak/latest results?"): the form the tale of the tape reads, for our corner
## and the booked opponent. Our boxer's last five are the club's own results (Career.results, newest first) and, behind
## those, the bouts brought to the club (PriorBouts: the History tab's list, so the tape and the record book agree).
## An amateur opponent's are the rival's kept record (RivalPast, r["bouts"]) as it stands today. A pro opponent carries
## the "form" list the ladder writes (Matchmaking.apply_result). Nothing is made up here: TapeRows shows "?" for a
## record with nothing on tape.
##   fill(c, f)   sets f["form"] and, for a booked amateur bout, f["bout"]["opp"]["form"]

const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const PriorBouts := preload("res://scripts/rules/PriorBouts.gd")


static func fill(c: Career, f: Dictionary) -> void:
	if c == null or f.is_empty():
		return
	var id := str(f.get("id", ""))
	var mine: Array = c.results.filter(func(r): return str(r.get("fid", id)) == id)
	var form: Array = TapeRows.marks(mine.slice(0, TapeRows.FORM_KEEP))
	if form.size() < TapeRows.FORM_KEEP:
		var am: Array = mine.filter(func(r): return not bool(r.get("pro", false)))
		var before_w := int(f.get("w", 0)) - am.filter(func(r): return _outcome(r) == "win").size()
		var before_l := int(f.get("l", 0)) - am.filter(func(r): return _outcome(r) == "loss").size()
		var prior: Array = PriorBouts.list(f, before_w, before_l, int(f.get("joined", 0)))   # oldest first
		prior.reverse()
		form.append_array(TapeRows.marks(prior.slice(0, TapeRows.FORM_KEEP - form.size())))
	f["form"] = form
	var bout: Dictionary = f.get("bout", {}) if f.get("bout") is Dictionary else {}
	if bout.get("opp") is Dictionary:
		fill_opp(c, bout["opp"])


## The booked opponent's copy was made on the day of the offer: an amateur's form is read from the rival's record today.
static func fill_opp(c: Career, opp: Dictionary) -> void:
	if opp.is_empty() or bool(opp.get("pro", false)):
		return
	var r := c.rival(str(opp.get("name", "")))
	if r.get("bouts") is Array and not (r["bouts"] as Array).is_empty():
		opp["form"] = TapeRows.marks((r["bouts"] as Array).slice(0, TapeRows.FORM_KEEP))


static func _outcome(r: Dictionary) -> String:
	return str(r.get("outcome", "win" if bool(r.get("win", false)) else "loss"))
