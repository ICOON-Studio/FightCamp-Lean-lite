extends RefCounted
## S387 MENUBOUT: what the bout page and the offers rows read off BoutRead. The fighter's seven stats against the opponent's
## estimated ranges (pips against a box), the win band, where a win or a loss moves the fighter, and the offer row's chips.
##   stats_card(f, opp, salt) -> card   read_card(c, f, opp, camp) -> card   offer_chips(c, f, o) -> [chips]

const Attrs := preload("res://scripts/rules/Attrs.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const RangeBar := preload("res://scripts/ui/RangeBar.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")

## The stat bars' scale: every number on a stat row sits on this one ruler.
const STAT_MIN := 35.0
const STAT_MAX := 95.0
const BAR_W := 260.0
const BAR_H := 12.0
const GROW_S := 0.5
## A mismatch number up to EVEN reads green, up to UNEVEN amber, past it red.
const EVEN := 3
const UNEVEN := 7


static func _bar(value: float, lo: float, hi: float, w: float, fill: Color) -> Control:
	var bar: Control = RangeBar.new()
	bar.segments = UI.METER_SEGMENTS
	bar.custom_minimum_size = Vector2(w, BAR_H)
	bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.fill = fill
	bar.lo = lo
	bar.hi = hi
	bar.frac = value
	bar.ready.connect(func():
		var t: Tween = bar.create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(bar, "frac", value, GROW_S).from(0.0)
		t.tween_property(bar, "open", 1.0, GROW_S).from(0.0))
	return bar


static func _on_scale(v: float) -> float:
	return clampf((v - STAT_MIN) / (STAT_MAX - STAT_MIN), 0.0, 1.0)


## Ahead of the whole range green, behind it red, inside it the ink colour: the range cannot call it.
static func _read_colour(value: float, lo: float, hi: float) -> Color:
	return UI.GREEN if value > hi else (UI.RED if value < lo else UI.FG)


static func _swatch(colour: Color, text: String) -> HBoxContainer:
	var h := UI.hbox(6)
	h.add_child(UI.dot(colour))
	h.add_child(UI.muted(text, UI.TINY))
	return h


## S398 six rows, the fighter model's keys (where each wins: long game, pocket, inside, power, durability, engine): the
## fighter's value against the opponent's estimate (BoutRead.key_ranges), so the tape shows the matchup, not one level.
static func stats_card(f: Dictionary, opp: Dictionary, salt: int) -> PanelContainer:
	var card := UI.card("TALE OF THE TAPE")
	card[0].name = "BoutStats"
	var v: VBoxContainer = card[1]
	var key := UI.hbox(16)
	key.add_child(_swatch(UI.GOLD, str(f["first"])))
	key.add_child(_swatch(UI.RED, "%s, estimate" % str(opp["first"])))
	v.add_child(key)
	var ranges := BoutRead.key_ranges(opp, salt)
	var mine_keys := Duels.keys(Attrs.of(f))
	for i in mine_keys.size():
		var k := str(mine_keys[i]["name"])
		var mine := float(mine_keys[i]["value"])
		var lo := float(ranges[i]["lo"])
		var hi := float(ranges[i]["hi"])
		var row := UI.hbox(12)
		row.name = "Key_" + k.replace(" ", "_")
		var l := UI.label(k, UI.SMALL)
		l.custom_minimum_size = Vector2(120, 0)
		row.add_child(l)
		row.add_child(_bar(_on_scale(mine), _on_scale(lo), _on_scale(hi), BAR_W, UI.GOLD))
		var n := UI.mono(str(int(floorf(mine))), UI.SMALL, _read_colour(mine, lo, hi))
		n.custom_minimum_size = Vector2(34, 0)
		n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		row.add_child(n)
		row.add_child(UI.mono("%d-%d" % [roundi(lo), roundi(hi)], UI.SMALL, UI.MUTED))
		v.add_child(row)
	var seen := RingDuel.AttrGen.attrs_of(BoutRead.public(opp))
	var sig := Attrs.signature(seen)
	if sig != "":
		v.add_child(UI.label("%s on tape: %s." % [str(opp["first"]), sig], UI.SMALL, UI.MUTED, "", true))
	# Dola (S398): where the opponent wins and where it breaks, against this fighter (the duels at each place, on the tape).
	var wb := RingDuel.wins_breaks(f, BoutRead.public(opp))
	v.add_child(UI.label("%s wins %s, breaks %s." % [str(opp["first"]), str(Duels.PLACE_WORD[int(wb[0])]), str(Duels.PLACE_WORD[int(wb[1])])],
		UI.SMALL, UI.FG, "", true))
	return card[0]


## "#4, up 2" / "#6, no change" / "Enters at #7" / "Unranked".
static func _move_words(now: int, after: int) -> String:
	if after == 0:
		return "Unranked"
	if now == 0:
		return "Enters at #%d" % after
	if after == now:
		return "#%d, no change" % after
	return "#%d, %s %d" % [after, "up" if after < now else "down", absi(after - now)]


## The win chance in the words both the full report and the versus card use.
static func win_read(c: Career, f: Dictionary, opp: Dictionary, camp: Dictionary) -> Dictionary:
	var b := BoutRead.band(f, opp, camp, c.seed, float(c.coach.get("rating", 0.0)))   # S397 rank 3: the coach's plan counts
	var lo := roundi(float(b["lo"]) * 100.0)
	var hi := roundi(float(b["hi"]) * 100.0)
	var s := BoutRead.stage(opp)
	var m := BoutRead.rank_move(Region.rankings(c, str(f["div"])), f, str(opp["name"]), Region.before, Region.RANK_MIN_WINS)
	return {"band": b, "lo": lo, "hi": hi, "mid": roundi((lo + hi) / 2.0), "found": int(s["found"]), "all": int(s["all"]),
		"win_word": "%d more to enter" % int(m["need"]) if int(m["win"]) == 0 else _move_words(int(m["now"]), int(m["win"])),
		"loss_word": _move_words(int(m["now"]), int(m["loss"])),
		"sure": "a rough guess" if hi - lo >= 30 else ("fairly sure" if hi - lo >= 12 else "sure")}


## WIN CHANCE: the band as a number and on a 0-100 ruler, how much of the file it rests on; then the ranks at stake.
static func read_card(c: Career, f: Dictionary, opp: Dictionary, camp: Dictionary) -> PanelContainer:
	var card := UI.card("WIN CHANCE")
	card[0].name = "BoutRead"
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card[0].size_flags_stretch_ratio = 2.0
	var v: VBoxContainer = card[1]
	var read := win_read(c, f, opp, camp)
	var b: Dictionary = read["band"]
	var lo := int(read["lo"])
	var hi := int(read["hi"])
	var big := UI.hbox(14)
	# S398 menus (first-hour critics: "Win chance 4-56%" reads as a bug): one number, how sure it is in words, the range
	# under it; scouting narrows the range.
	var mid := int(read["mid"])
	var num := UI.mono("%d%%" % mid, 38, UI.GREEN if lo >= 50 else (UI.RED if hi <= 50 else UI.FG))
	num.name = "WinBand"
	num.tooltip_text = "%d to %d%%" % [lo, hi]
	big.add_child(num)
	var s := BoutRead.stage(opp)
	var file := UI.vbox(2)
	file.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var sure := str(read["sure"])
	file.add_child(UI.label("%s: %d to %d%%" % [sure, lo, hi], UI.SMALL, UI.FG, "semi"))
	file.add_child(Icons.pips(int(s["found"]), int(s["all"]), "Tape study in camp finds these. Each one narrows the chance."))
	file.add_child(UI.muted("%d of %d found on the opponent's file" % [int(s["found"]), int(s["all"])], UI.TINY))
	big.add_child(file)
	v.add_child(big)
	var ruler := _bar(0.0, float(b["lo"]), float(b["hi"]), BAR_W, UI.GOLD)
	ruler.box = UI.GOLD
	ruler.marks = [0.5]
	v.add_child(Icons.tip(ruler, "0 to 100%. The tick is an even bout."))
	var camp_word := str(BoutRules.PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["name"]) + " camp" if not camp.is_empty() else "No camp"
	v.add_child(Icons.tip(UI.muted("%s, today's form" % camp_word, UI.SMALL), "The coach's own calls. Your plan and your shouts can beat it."))
	var rows := Region.rankings(c, str(f["div"]))
	var m := BoutRead.rank_move(rows, f, str(opp["name"]), Region.before, Region.RANK_MIN_WINS)
	var items: Array = [UI.kv("%s now" % str(f["first"]), "#%d" % int(m["now"]) if int(m["now"]) > 0 else "Unranked")]
	if int(m["win"]) == 0:
		items.append(UI.kv("A win", "%d more to enter" % int(m["need"]), UI.MUTED))
	else:
		items.append(UI.kv("A win", _move_words(int(m["now"]), int(m["win"])), UI.GREEN))
	items.append(UI.kv("A loss", _move_words(int(m["now"]), int(m["loss"])), UI.RED if int(m["loss"]) > int(m["now"]) and int(m["now"]) > 0 else UI.FG))
	var theirs := BoutRead.rank_of(rows, str(opp["name"]))
	items.append(UI.kv(str(opp["first"]), "#%d" % theirs if theirs > 0 else "Unranked"))
	UI.add_rows(v, items)
	return card[0]


## The offer row's chips: the mismatch number, the opponent's rank, the club's ticket cut.
static func offer_chips(c: Career, f: Dictionary, o: Dictionary) -> Array:
	var opp: Dictionary = o["opp"]
	var gap := roundi(BoutRead.mismatch(f, opp, BoutRead.camp_for(f, int(o["day"]) - c.day), c.seed))
	var size := absi(gap)
	var mis := UI.chip("Gap %s%d" % ["+" if gap > 0 else "", gap], "green" if size <= EVEN else ("amber" if size <= UNEVEN else "red"))
	mis.name = "Mismatch_" + str(o["id"])
	var theirs := BoutRead.rank_of(Region.rankings(c, str(f["div"])), str(opp["name"]))
	var rank := UI.chip("Rank #%d" % theirs if theirs > 0 else "Unranked", "")
	rank.name = "OppRank_" + str(o["id"])
	var cut := UI.chip("Cut %s" % UI.money(BoutRules.TICKET_CUT), "green")
	cut.name = "Cut_" + str(o["id"])
	return [Icons.tip(mis, "%s's strength against the estimate of %s. Minus: %s is the stronger." % [f["first"], opp["first"], opp["first"]]),
		Icons.tip(rank, "%s's place in the division." % opp["first"]), Icons.tip(cut, "The club's ticket cut for the bout.")]
