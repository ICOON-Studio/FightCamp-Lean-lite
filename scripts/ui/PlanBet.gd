extends RefCounted
## S538 PLANFLOW2 (owner Q-S294-301: "yes add those"): the plan's MAIN BET and each line's USES in the last bout.
## - MAIN BET: the player marks ONE line as the thing the plan stands on. The fighter keeps which (f["plan_bet"] =
##   "place|when"); stamp() writes it onto that arrow ("bet": true) every time the plan is saved, so the bout's own copy
##   of the plan (each round's "plan") carries it to the result page with no second record.
## - USES: the last bout's count for a line (fired, won) from the record the bout already keeps (Career.results
##   "plan_rec", PlanRecord.summary) - nothing is counted again here. The chart's "In bouts" chip stays the all-bouts sum.
##   mark(gp, row, place, when)   said(gp, v, mid)   last_bout(gp, row, mid, all)   stamp(arrows, f)   verdict(arrows, uses)

const UI := preload("res://scripts/ui/UI.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")

const KEY := "plan_bet"
const TIP_OFF := "Marks this line as the one the plan stands on. After the bout the result page says whether it fired and whether it won its exchanges. A plan has one bet: marking another line moves it."
const TIP_ON := "The plan stands on this line: the result page will judge it first. Click to take the bet off."
const TIP_NEVER := "This line was on the plan and was never thrown: its moment did not come, or it was not sharp enough to get off. A line that never fires is a line wasted."
const TIP_FIRED := "The exchanges this line was thrown in during the last bout, and how many of them your boxer won. The other count adds up every bout."


## The line an arrow sits on, as the bet names it.
static func key_of(arrow: Dictionary) -> String:
	return str(SM.move(str(arrow.get("move", ""))).get("from", "")) + "|" + str(arrow.get("when", ""))


## Writes the fighter's bet onto the plan: the one arrow on that line gets "bet", every other loses it. A bet whose line
## is no longer on the plan is forgotten. Returns the same array.
static func stamp(arrows: Array, f: Dictionary) -> Array:
	var want := str(f.get(KEY, ""))
	var hit := false
	for a in arrows:
		var d: Dictionary = a
		if want != "" and not hit and key_of(d) == want:
			d["bet"] = true
			hit = true
		else:
			d.erase("bet")
	if not hit:
		f.erase(KEY)
	return arrows


## A row whose chips wrap onto a second line (an answer box is narrow: fit, uses, bet, rounds, grade).
static func flow() -> HFlowContainer:
	var h := HFlowContainer.new()
	h.add_theme_constant_override("h_separation", 6)
	h.add_theme_constant_override("v_separation", 4)
	return h


## The bet button on a line of the chart (only a written line can carry it).
static func mark(gp, row: Control, place: String, when: String) -> void:
	if PlanLines.find(gp.arrows, place, when) < 0:
		return
	var k := place + "|" + when
	var on := str(gp.f.get(KEY, "")) == k
	var b := UI.button("MAIN BET" if on else "Bet on it", "PillOn" if on else "Pill", func():
		if on:
			gp.f.erase(KEY)
		else:
			gp.f[KEY] = k
		gp._write(gp.arrows)
		gp._refresh())
	b.name = "Bet_%s_%s" % [place, when]
	b.tooltip_text = TIP_ON if on else TIP_OFF
	row.add_child(b)


## Under a bell row: how the range's line has done (the last bout, then every bout); nothing when it has no record.
static func said(gp, v: Control, mid: String) -> void:
	var h := UI.hbox(6)
	gp._in_bouts(h, mid)
	if h.get_child_count() > 0:
		v.add_child(h)


## The fighter's newest result's plan record ({} = no bout yet, or a bout from before the record was kept).
static func last_rec(gp) -> Dictionary:
	if gp.main == null or gp.main.get("career") == null:
		return {}
	for r in gp.main.career.results:
		if str((r as Dictionary).get("fid", "")) == str(gp.f.get("id", "")):
			return (r as Dictionary).get("plan_rec", {})
	return {}


## The last bout's uses of a line: "fired 4, won 3", or "never fired" for a line that was on the plan and never thrown.
## `all` is the line's all-bouts row (PlanRecord.rates): with one bout on record that chip already says the same count.
static func last_bout(gp, row: Control, mid: String, all: Dictionary) -> void:
	var rec := last_rec(gp)
	if rec.is_empty() or not (rec.get("plan", []) as Array).has(mid):
		return
	var per: Array = (rec.get("lines", {}) as Dictionary).get(mid, [0, 0])
	var used := int(per[1])
	if used > 0 and int(all.get("bouts", 0)) <= 1:
		return
	var chip := UI.chip("Last bout: never fired" if used == 0 else "Last bout: fired %d, won %d" % [used, int(per[0])], "amber" if used == 0 else "")
	chip.name = "LastBout_" + mid.replace("@", "_").replace(" ", "_")
	chip.mouse_filter = Control.MOUSE_FILTER_PASS
	chip.tooltip_text = TIP_NEVER if used == 0 else TIP_FIRED
	row.add_child(chip)


## The result page's word on the bet. `arrows` = the plan the bout was fought on, `uses` = {move id: [won, won, lost..]}
## as the Plan tab already counts them. {} = no bet was marked.
##   -> {i, move, fired, won, word: "paid" | "even" | "lost" | "never", text}
static func verdict(arrows: Array, uses: Dictionary) -> Dictionary:
	for i in arrows.size():
		var a: Dictionary = arrows[i]
		if not bool(a.get("bet", false)):
			continue
		var u: Array = uses.get(str(a["move"]), [])
		var fired := u.size()
		var won := u.filter(func(w): return bool(w)).size()
		var word := "never"
		var text := "The bet never fired: its moment did not come, or it was not sharp enough to get off."
		if fired > 0 and won * 2 > fired:
			word = "paid"
			text = "The bet paid: fired %d, won %d." % [fired, won]
		elif fired > 0 and won * 2 == fired:
			word = "even"
			text = "The bet broke even: fired %d, won %d." % [fired, won]
		elif fired > 0:
			word = "lost"
			text = "The bet lost: fired %d, won %d." % [fired, won]
		return {"i": i, "move": str(a["move"]), "fired": fired, "won": won, "word": word, "text": text}
	return {}
