extends RefCounted
## S519 club week v11 3.7: the next 4 weeks of coach time at a glance (the Training screen's forecast strip) and the clash
## line a bout offer shows before Accept. Pads stay full (his Q-S294-260), so what runs short is the coach's FILM nights
## (FilmSeats.owned: 2 sessional / 3 full time, first come first served across the bouts of one week): a week with more
## fight weeks than film nights sends a boxer to watch alone (half a read, OppFile.half_tape).
##   weeks(c, n) -> [{monday, fights, film, alone, classes, words, risk}]   clash(c, f, bout_day) -> String ("" = none)

const FilmSeats := preload("res://scripts/rules/FilmSeats.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const Clock := preload("res://scripts/state/Clock.gd")


static func coach_kind(c: Career) -> String:
	return "full_time" if bool(c.coach.get("full_time", false)) else "sessional"


## Booked bouts (not fought) whose day falls in the week starting `monday`, other than `skip_id`'s.
static func fights_in(c: Career, monday: int, skip_id := "") -> int:
	var n := 0
	for f in c.fighters:
		var b: Dictionary = f.get("bout", {})
		if str(f.get("id", "")) == skip_id or b.is_empty() or bool(b.get("done", false)):
			continue
		var d := int(b.get("day", -999))
		if d >= monday and d < monday + 7:
			n += 1
	return n


static func weeks(c: Career, n := 4) -> Array:
	var out: Array = []
	var mon0 := c.day - posmod(c.day, 7)
	var owned := FilmSeats.owned(coach_kind(c)) if not c.coach.is_empty() else 0
	var classes := ClubClasses.nights(c.coach).size()
	for k in n:
		var mon := mon0 + 7 * k
		var fights := fights_in(c, mon)
		var alone := maxi(0, fights - owned)
		var words := "quiet" if fights == 0 else "%d fight week%s" % [fights, "" if fights == 1 else "s"]
		if fights > 0:
			words += " · film %d/%d" % [mini(fights, owned), owned]
		out.append({"monday": mon, "date": Clock.fmt(mon), "fights": fights, "film": owned, "alone": alone,
			"classes": classes, "words": words, "risk": alone > 0})
	return out


## Before Accept: what a bout on `bout_day` for f does to that week's coach time. "" when nothing runs short.
static func clash(c: Career, f: Dictionary, bout_day: int) -> String:
	if c.coach.is_empty():
		return ""
	var mon := bout_day - posmod(bout_day, 7)
	var others := fights_in(c, mon, str(f.get("id", "")))
	var owned := FilmSeats.owned(coach_kind(c))
	if others + 1 <= owned:
		return ""
	return "%d other boxer%s already fight%s that week: film %d of %d - one watches the tape alone (half a read). A later date, or a full-time coach (3 film nights)." % [
		others, "" if others == 1 else "s", "s" if others == 1 else "", others + 1, owned]
