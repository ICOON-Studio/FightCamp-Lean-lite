extends RefCounted
## S524 TURNPRO1 map M11 (design v2 s2 + s6): the week review's turning-pro lines, from the real ledger.
## - The 4 weeks after signing, before the debut: "Amateur cut lost $300; stipend saved $1,000 (4 weeks since signing)."
## - The debut's week: "Debut ledger - gym: share $300, costs $1,245, net -$945." and one NEXT line naming the lever.
## Roster.turn_pro writes f["pro_signed"] {d, house, stipend, costs}; BoutFinish adds ["debut"] {d, gym}.
## Names only in the header (S448), no he / she (S412).

const UI := preload("res://scripts/ui/UI.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")

const AFTER_SIGNING_DAYS := 28   # the design's "4 weeks after signing"


## Pure: the lines for one boxer on `day` - [{"head": String, "t": String, "kind": "signed"|"ledger"|"next", "bad": bool}].
static func lines_for(f: Dictionary, day: int) -> Array:
	var s: Dictionary = f.get("pro_signed", {})
	if s.is_empty() or not bool(f.get("pro", false)):
		return []
	var head := "%s: TURNED PRO" % str(f.get("name", f.get("first", ""))).to_upper()
	var out: Array = []
	var deb: Dictionary = s.get("debut", {})
	if deb.is_empty():
		var since := day - int(s["d"])
		if since < 1 or since > AFTER_SIGNING_DAYS:
			return []
		var weeks := clampi(ceili(since / 7.0), 1, 4)
		var lost := ProCall.LOST_CUT_A_WEEK * weeks
		var saved := int(s.get("stipend", 0)) * weeks
		out.append({"head": head, "kind": "signed", "bad": lost > saved,
			"t": "Amateur cut lost %s; stipend saved %s (%d week%s since signing)." % [UI.money(lost), UI.money(saved), weeks,
				"" if weeks == 1 else "s"]})
		return out
	if day - int(deb["d"]) < 0 or day - int(deb["d"]) >= 7:
		return []
	var gym := int(deb["gym"])
	var costs := int(s.get("costs", 0))
	var net := gym - costs
	head = "%s: THE DEBUT" % str(f.get("name", f.get("first", ""))).to_upper()
	out.append({"head": head, "kind": "ledger", "bad": net < 0,
		"t": "Debut ledger - gym: share %s, costs %s, net %s." % [UI.money(gym), UI.money(costs), UI.signed(net)]})
	out.append({"head": head, "kind": "next", "bad": false, "t": next_line(f, net)})
	return out


## The one lever (design s2 "the NEXT line names the lever").
static func next_line(f: Dictionary, net: int) -> String:
	if net < 0:
		return "NEXT: more members sell more pro tickets - the gym's share grows with the gym, the costs were one-off."
	return "NEXT: each pro win adds %s to the purse (top %s); the gym keeps its share of every one." % [
		UI.money(int(f.get("purse_step", 500))), UI.money(int(f.get("purse_top", 3000)))]


## Every boxer's lines on the career's day.
static func lines(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		out.append_array(lines_for(f, c.day))
	return out


## The rows WeekReview lands: one header per boxer, then the lines.
static func rows(c: Career) -> Array:
	var out: Array = []
	var last_head := ""
	for l in lines(c):
		if str(l["head"]) != last_head:
			last_head = str(l["head"])
			var h := UI.caps(last_head)
			h.name = "ProHead_%d" % out.size()
			out.append(h)
		var row := UI.label(str(l["t"]), UI.SMALL, UI.AMBER if bool(l["bad"]) else (UI.GOLD if str(l["kind"]) == "next" else UI.FG),
			"body", true)
		row.name = "ProLine_" + str(l["kind"])
		out.append(row)
	return out
