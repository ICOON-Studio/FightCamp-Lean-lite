extends RefCounted
## S517 (LADDERPROBE1: in 23 of 30 two-year runs a novice ended with no legal name left - every name on her sheet had
## boxed past 10 bouts at the region's own shows, so every offer was a mismatch and she never boxed again). Clubs keep
## signing novices; England Boxing's novice class refills every season. When a novice of ours has nobody legal on her
## division's sheet, a newcomer from a club already in that division joins it: 0-2 bouts, a little under the sheet's
## level. She boxes at the region's shows like any rival (Region pools c.rivals by division), so she in turn graduates
## and the next one arrives. At most MAX_A_DIV on a sheet; the oldest graduated one leaves the sheet when a new one comes.
## Pure enough: reads Data, writes c.rivals and a news line.

const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const Data := preload("res://scripts/state/Data.gd")
const NOVICE_MAX := 10   # AmateurBooking.NOVICE_MAX_BOUTS
const MAX_A_DIV := 3
const FIRST_F := ["Chloe", "Aisha", "Rosie", "Keira", "Tamsin", "Leah", "Imani", "Freya", "Zara", "Molly"]
const FIRST_M := ["Callum", "Tariq", "Rhys", "Kofi", "Liam", "Owen", "Jamal", "Ethan", "Kieran", "Dev"]
const LAST := ["Brennan", "Okafor", "Whitlow", "Achterberg", "Rafferty", "Lindqvist", "Mbeki", "Harcourt", "Delaney",
	"Szabo", "Pemberton", "Quayle"]
const STYLES := [
	["Pressure fighter", "Walks forward throwing", "Walks in straight"],
	["Out-boxer", "Jab and move", "Flat-footed when pressed"],
	["Counter-puncher", "Right hand over the jab", "Waits too long"],
	["Volume puncher", "Busy hands", "Arm punches, little power"],
]


## The names the matchmaker offers in turn: the division's sheet, then its newcomers.
static func sheet(c: Career, div: String) -> Array:
	var out: Array = (Data.DIVISIONS[div]["opponents"] as Array).duplicate()
	for r in c.rivals:
		if bool(r.get("newcomer", false)) and str(r.get("div", "")) == div and not bool(r.get("off_sheet", false)):
			out.append(str(r["name"]))
	return out


static func _bouts(r: Dictionary) -> int:
	return int(r.get("w", 0)) + int(r.get("l", 0))


## A novice of ours with nobody legal on the sheet: a newcomer joins it. Returns the newcomer, or {}.
static func arrive(c: Career, f: Dictionary) -> Dictionary:
	var div := str(f.get("div", ""))
	if not Data.DIVISIONS.has(div) or int(f.get("w", 0)) + int(f.get("l", 0)) > NOVICE_MAX:
		return {}
	var names := sheet(c, div)
	for n in names:
		var r := c.rival(str(n))
		if not r.is_empty() and _bouts(r) <= NOVICE_MAX:
			return {}
	var mine: Array = c.rivals.filter(func(x): return bool(x.get("newcomer", false)) and str(x.get("div", "")) == div)
	var on_sheet: Array = mine.filter(func(x): return not bool(x.get("off_sheet", false)))
	if on_sheet.size() >= MAX_A_DIV:
		(on_sheet[0] as Dictionary)["off_sheet"] = true   # graduated (nobody here is legal): she leaves the sheet, keeps her table row
	var rng := RandomNumberGenerator.new()
	rng.seed = hash([c.seed, div, mine.size()])
	var sex := str(Data.DIVISIONS[div].get("sex", "f"))
	var name := ""
	for k in 20:
		var first: String = (FIRST_F if sex == "f" else FIRST_M)[rng.randi_range(0, 9)]
		name = "%s %s" % [first, LAST[rng.randi_range(0, LAST.size() - 1)]]
		if c.rival(name).is_empty():
			break
	var clubs: Array = []
	var level := 0.0
	var count := 0
	for n in Data.DIVISIONS[div]["opponents"]:
		var r := c.rival(str(n))
		if not r.is_empty():
			clubs.append(str(r["club"]))
			level += float(r.get("rating", 60.0))
			count += 1
	var st: Array = STYLES[rng.randi_range(0, STYLES.size() - 1)]
	var w := rng.randi_range(0, 2)
	var l := rng.randi_range(0, 2 - w)
	var nc := {"div": div, "name": name, "first": name.get_slice(" ", 0), "club": clubs[rng.randi_range(0, clubs.size() - 1)] if not clubs.is_empty() else "Local ABC",
		"age": rng.randi_range(18, 23), "stance": "southpaw" if rng.randf() < 0.25 else "orthodox", "style": st[0],
		"w": w, "l": l, "rating": snappedf((level / maxi(count, 1)) - rng.randf_range(1.0, 3.0), 0.5),
		"threat": st[1], "weak": st[2], "newcomer": true, "joined": c.day}
	var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == div).map(func(o): return [o["name"], o["club"]])
	nc["bouts"] = RivalPast.seed(nc, others, c.seed, c.day)
	c.rivals.append(nc)
	c.add_news("New on the %s sheet: %s of %s, a novice with %d bouts - a legal match for %s." % [
		Data.DIVISIONS[div]["short"], name, nc["club"], w + l, f["first"]])
	return nc
