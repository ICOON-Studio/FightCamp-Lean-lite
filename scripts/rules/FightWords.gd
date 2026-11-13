extends RefCounted
## Fighter-model flavour for the watched bout. The old bank still supplies the close, while the first two lines come
## from this fighter's own profile and what actually happened in the round, so two boxers do not receive the same story.

const Legacy := preload("res://scripts/state/FightWords.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Duels := preload("res://scripts/rules/Duels.gd")


static func round_lines(style: String, won: bool, corner: String, subs: Dictionary, seed_value: int,
		fighter: Dictionary = {}, exchanges: Array = []) -> Array:
	var out := _caps(Legacy.round_lines(style, won, corner, subs, seed_value))
	if fighter.is_empty():
		return out
	var a := Attrs.of(fighter)
	var identity := Attrs.signature(a)
	var kind := AttrGen.style_word({"attrs": a, "pace": a.get("pace", 55.0), "forward": a.get("forward", 50.0)})
	var first := "%s boxes as a %s" % [str(subs.get("her", "The fighter")), kind.to_lower()]
	if identity != "":
		first += ": " + identity.to_lower()
	first += "."
	if out.is_empty():
		out.append(first)
	else:
		out[0] = first
	if exchanges.is_empty():
		return out
	var places := [0, 0, 0]
	var tools := {}
	for x in exchanges:
		var p := clampi(int(x.get("place", Duels.POCKET)), Duels.LONG, Duels.INSIDE)
		places[p] += 1
		var tool := str(x.get("a_best", ""))
		if tool != "":
			tools[tool] = int(tools.get(tool, 0)) + 1
	var place := 0
	for p in 3:
		if int(places[p]) > int(places[place]):
			place = p
	var best := ""
	for tool in tools:
		if best == "" or int(tools[tool]) > int(tools[best]):
			best = str(tool)
	var moment := "%s worked %s" % [str(subs.get("her", "The fighter")), Duels.PLACE_WORD[place]]
	if best != "":
		var attack := str(Duels.TOOL_WORD.get(best, best))
		if best == "right":
			attack = "straight left" if str(fighter.get("stance", "orthodox")).to_lower() == "southpaw" else "right hand"
		moment += ", leaning on the %s" % attack
	moment += "."
	if out.size() < 2:
		out.append(moment)
	else:
		out[1] = moment
	return _caps(out)


## S448 operator ("names are only mentioned on the header"): BoutNight fills {her} / {opp} with "your boxer" / "the
## opponent"; a role that opens a sentence is capitalised here.
static func _caps(lines: Array) -> Array:
	var re := RegEx.create_from_string("(^|[.!?]\\s+)(your boxer|the opponent)")
	var out: Array = []
	for l in lines:
		var t := str(l)
		var m := re.search(t)
		while m != null:
			var w := m.get_string(2)
			t = t.substr(0, m.get_start(2)) + w.left(1).to_upper() + w.substr(1) + t.substr(m.get_end(2))
			m = re.search(t, m.get_end(2))
		out.append(t)
	return out
