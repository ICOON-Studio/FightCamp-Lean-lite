extends RefCounted
## S397 rank 4 screens (P1): a pro's half of the Fights page, rebuilt after two blind rounds (4, then 5: "merge the offers
## and the asks into one comparison table above the fold, only what differs"):
##   a strip: who she is, her form, her place, her fans, and the shared rules said once
##   NEXT FIGHT: one table - the promoter's three offers, then the names she may ask for - each row: kind, opponent and
##               tape, the chance (about X%, a bar with its range), what a win gives, the pay, Scout / Take or Ask; a
##               scouted row says how the chance moved and shows the weakness found
##   THE ROAD: the champions and the places around her; refusals in one line each
## Rules: scripts/rules/Matchmaking.gd; state: scripts/state/ProLadder.gd; acts proscout / probook (BoutActs).

const UI := preload("res://scripts/ui/UI.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")

## S397 blind round 3 ("LEVEL ON PAPER sits on an 80% fight"): the tag says what the read says.
const KIND_WORD := {"tune": "TUNE-UP", "above": "STEP UP", "payday": "PAYDAY"}
const KIND_KEY := {"tune": "green", "above": "gold", "payday": "amber"}
const FAVOURITE_AT := 0.65
const UNDERDOG_AT := 0.4
const COL_KIND := 120
const COL_ODDS := 190
const COL_WIN := 200
const COL_LOSE := 170
const COL_PAY := 100
const COL_ACT := 170


static func section(main: Node, c: Career, f: Dictionary) -> Control:
	var page := UI.vbox(14)
	page.name = "ProFights_" + str(f["id"])
	page.add_child(_strip(c, f))
	var cols := UI.hbox(16)
	page.add_child(cols)
	var table := _table_card(main, c, f)
	table.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	table.size_flags_stretch_ratio = 3.2
	cols.add_child(table)
	var road := _road_card(c, f)
	road.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	road.size_flags_stretch_ratio = 1.3
	road.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	cols.add_child(road)
	return page


## One line on who the choice is for, and the rules every row shares (said once, not on every card).
static func _strip(c: Career, f: Dictionary) -> Control:
	var card := UI.card()
	var v: VBoxContainer = card[1]
	var fm := ProLadder.form(c, f)
	var e := ProLadder.entry(c, f)
	var place := "ranked #%d" % int(e["rank"]) if int(e.get("rank", 0)) > 0 else "unranked"
	var last := " ".join(fm["last"]) if not (fm["last"] as Array).is_empty() else "none yet"
	var fans := int(e.get("fans", 0))
	var fan_words := "%d fans" % fans if fans > 0 else ("no fans yet" if fans == 0 else "no fans: the crowd has turned")
	v.add_child(UI.label("%s: %s, last fights %s, %s, %s." % [f["name"], FighterCard.record(f), last, place, fan_words],
		UI.BODY + 1, UI.FG, "bold", true))
	var offers: Array = f.get("pro_offers", [])
	if (f["bout"] as Dictionary).is_empty() and not offers.is_empty():
		v.add_child(UI.label("Pick one fight by %s. Fight night is %s, after a six-week camp. Top-5 names need %d fans." % [
			Clock.fmt(int(offers[0]["until"])), Clock.fmt(ProLadder.fight_day(c)), MM.TOP_ASK_FANS], UI.BODY, UI.FG, "body", true))
	return card[0]


static func _rank_word(b: Dictionary) -> String:
	return "#%d" % int(b["rank"]) if int(b.get("rank", 0)) > 0 else "unranked"


static func _record(b: Dictionary) -> String:
	var d := int(b.get("d", 0))
	return "%d-%d%s" % [int(b.get("w", 0)), int(b.get("l", 0)), "-%d" % d if d > 0 else ""]


static func _odds_color(mid: float) -> Color:
	return UI.GREEN if mid >= 0.6 else (UI.RED if mid < 0.4 else UI.AMBER)


static func _fixed(w: int, child: Control) -> Control:
	child.custom_minimum_size.x = w
	child.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	return child


static func _head_row() -> Control:
	var h := UI.hbox(14)
	h.add_child(_fixed(COL_KIND, UI.caps("")))
	var o := UI.caps("OPPONENT")
	o.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(o)
	h.add_child(_fixed(COL_ODDS, UI.caps("YOUR CHANCE")))
	h.add_child(_fixed(COL_WIN, UI.caps("A WIN GIVES")))
	h.add_child(_fixed(COL_LOSE, UI.caps("A LOSS COSTS")))
	h.add_child(_fixed(COL_PAY, UI.caps("THE GYM GETS")))
	h.add_child(_fixed(COL_ACT, UI.caps("")))
	return h


static func _table_card(main: Node, c: Career, f: Dictionary) -> Control:
	var card := UI.card("NEXT FIGHT")
	var v: VBoxContainer = card[1]
	if not (f["bout"] as Dictionary).is_empty() and (f["bout"] as Dictionary).has("day"):   # S398: a dayless bout dict (main CI)
		v.add_child(UI.label("Booked: vs %s, %s. Set the camp on Fighters, then the Training tab." % [f["bout"]["opp"]["name"], Clock.fmt(int(f["bout"]["day"]))],
			UI.BODY, UI.GOLD, "bold", true))
		return card[0]
	var offers := ProLadder.offer_rows(c, f)
	if offers.is_empty():
		v.add_child(UI.label("The promoter calls on %s with three fights." % Clock.fmt(maxi(int(f.get("pro_next", c.day)), c.day + 1)),
			UI.BODY, UI.FG, "bold"))
		v.add_child(UI.label("Until then: set the training on Fighters, then the Training tab. %s" % ("After a loss the next pick is a rebuild fight: a win clears it." if
			bool(ProLadder.entry(c, f).get("rebuild", false)) else "The road is on the right."), UI.SMALL, UI.MUTED, "body", true))
		return card[0]
	v.add_child(_head_row())
	var offered: Array = offers.filter(func(x): return str(x["kind"]) == "above").map(func(x): return x["opp"])   # a duck passes the step up
	for r in offers:
		v.add_child(UI.sep())
		v.add_child(_row(main, c, f, r, offered, false))
	var offered_ids: Array = offers.map(func(x): return int(x["opp"]["id"]))
	var asks := ProLadder.ask_rows(c, f).filter(func(a): return bool(a["answer"]["ok"]) and not offered_ids.has(int(a["opp"]["id"])))
	var all_rows: Array = []
	for r in offers:
		all_rows.append({"rank": int(r["opp"].get("rank", 0)), "mid": float(r["chance"]["mid"])})
	for a in asks:
		all_rows.append({"rank": int(a["opp"].get("rank", 0)), "mid": float(a["chance"]["mid"])})
	var hidden := 0
	# S397 blind: a name beaten on place and chance by another row is noise - nobody would pick it
	asks = asks.filter(func(a):
		var rk := int(a["opp"]["rank"])
		var md := float(a["chance"]["mid"])
		var beaten := all_rows.any(func(x): return int(x["rank"]) > 0 and int(x["rank"]) < rk and float(x["mid"]) > md)
		return not beaten)
	hidden = ProLadder.ask_rows(c, f).filter(func(a): return bool(a["answer"]["ok"]) and not offered_ids.has(int(a["opp"]["id"]))).size() - asks.size()
	if not asks.is_empty():
		v.add_child(UI.sep())
		v.add_child(UI.caps("OR NAME YOUR OPPONENT: THE PROMOTER WILL MAKE ANY OF THESE"))
		if hidden > 0:
			v.add_child(UI.muted("%d more in your band are left out: a higher place is on offer at a better chance." % hidden, UI.SMALL))
		var e := ProLadder.entry(c, f)
		for a in asks:
			v.add_child(UI.sep())
			var file: Dictionary = a["file"]
			v.add_child(_row(main, c, f, {"opp": a["opp"], "chance": a["chance"], "kind": "ask", "offer": file,
				"pay": MM.pay_of(e, a["opp"]), "bout_opp": ProLadder.bout_opp(f, a["opp"], file.get("file_found", ProLadder.PUBLIC_TAPE))},
				offered, true))
	return card[0]


static func _row(main: Node, c: Career, f: Dictionary, r: Dictionary, offered: Array, ask: bool) -> Control:
	var opp: Dictionary = r["opp"]
	var o: Dictionary = r["offer"]
	var scouted := bool(o.get("scouted", false))
	var h := UI.hbox(14)
	var mid0 := float(r["chance"]["mid"])
	var kind := str(r.get("kind", ""))
	if KIND_WORD.has(kind):   # S397: the promoter's offers say what they are for
		h.add_child(_fixed(COL_KIND, UI.chip(KIND_WORD[kind], KIND_KEY[kind])))
	else:
		h.add_child(_fixed(COL_KIND, UI.chip("FAVOURITE" if mid0 >= FAVOURITE_AT else ("UNDERDOG" if mid0 < UNDERDOG_AT else "CLOSE"),
			"green" if mid0 >= FAVOURITE_AT else ("amber" if mid0 < UNDERDOG_AT else "gold"))))
	var who := UI.vbox(2)
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.add_child(UI.label(str(opp["name"]), UI.BODY + 1, UI.FG, "bold"))
	var belt := str(opp.get("belt", ""))
	who.add_child(UI.label("%s, %s, %s%s" % [_rank_word(opp), _record(opp), str(opp["style"]).to_lower(),
		", %s champion" % belt.split("_")[-1] if belt != "" else ""], UI.SMALL, UI.MUTED))
	var ko := int(opp.get("ko", 0))
	var wins := int(opp.get("w", 0))
	if wins > 0:
		var ko_share := float(ko) / float(wins)
		who.add_child(UI.label("Stopped %d of the %d beaten" % [ko, wins], UI.SMALL,
			UI.RED if ko_share >= 0.4 else (UI.AMBER if ko_share >= 0.2 else UI.MUTED), "bold" if ko_share >= 0.4 else "body"))
	for ln in _tape_lines(r["bout_opp"]):
		who.add_child(UI.label(str(ln[0]), UI.SMALL, ln[1], str(ln[2]), true))
	h.add_child(who)
	var ch: Dictionary = r["chance"]
	var mid := float(ch["mid"])
	var odds := UI.vbox(2)
	odds.add_child(UI.label("%d%%" % roundi(mid * 100.0), UI.BODY + 8, _odds_color(mid), "bold"))
	odds.add_child(UI.meter(mid, _odds_color(mid), [float(ch["lo"]), float(ch["hi"])], COL_ODDS - 20))
	if scouted and o.has("read_before"):
		var moved := roundi((mid - float(o["read_before"])) * 100.0)
		odds.add_child(UI.label("Scouted: %s%d from %d%%" % ["+" if moved >= 0 else "", moved, roundi(float(o["read_before"]) * 100.0)],
			UI.SMALL, UI.GREEN if moved >= 0 else UI.RED, "bold"))
	else:
		odds.add_child(UI.label("could be %d-%d%%" % [roundi(float(ch["lo"]) * 100.0), roundi(float(ch["hi"]) * 100.0)], UI.SMALL, UI.MUTED))
	h.add_child(_fixed(COL_ODDS, odds))
	var st := ProLadder.stakes(c, f, opp, [] if ask else offered)
	var duck := str(st["duck"]) != ""
	var win := UI.vbox(2)
	win.add_child(UI.label(_win_short(c, f, opp, duck), UI.BODY, UI.GREEN if int(opp.get("rank", 0)) > 0 else UI.FG, "bold", true))
	var gap := float(opp["rating"]) - float(ProLadder.entry(c, f)["rating"])
	var nw := MM.next_weeks(gap, false)
	win.add_child(UI.label("%s: next fight %d weeks on" % ["A quick night" if nw < MM.NEXT_WEEKS else
		("A hard night" if nw > MM.NEXT_WEEKS else "A normal night"), nw], UI.SMALL, UI.GREEN if nw < MM.NEXT_WEEKS else
		(UI.AMBER if nw > MM.NEXT_WEEKS else UI.MUTED), "body", true))
	if duck:
		win.add_child(UI.label("Ducks the step up (%d of %d)" % [int(ProLadder.entry(c, f).get("ducks", 0)) + 1, MM.DUCKS_BLOCK],
			UI.SMALL, UI.AMBER, "bold", true))
	h.add_child(_fixed(COL_WIN, win))
	var e := ProLadder.entry(c, f)
	var lf := mini(MM.loss_fans(float(opp["rating"]) - float(e["rating"])), maxi(0, int(e.get("fans", 0))))
	var lose := "%s; then a rebuild" % ("No fans lost" if lf == 0 else "-%d fan%s" % [lf, "" if lf == 1 else "s"])
	if str(st["lose"]).contains("drop a place"):
		lose += "; drops a place"
	var lv := UI.vbox(2)
	lv.add_child(UI.label(lose, UI.SMALL, UI.FG, "body", true))
	var sc := MM.stop_chance(float(r["chance"]["mid"]), opp)
	lv.add_child(UI.label("Stopped: %d%% chance; then out %d weeks, and damage" % [roundi(sc * 100.0), MM.next_weeks(gap, true)],
		UI.SMALL, UI.RED if sc >= 0.15 else (UI.AMBER if sc >= 0.07 else UI.MUTED), "bold" if sc >= 0.15 else "body", true))
	h.add_child(_fixed(COL_LOSE, lv))
	var pay: Dictionary = r["pay"]
	var total := int(pay["purse"]) + int(pay["tickets"])
	var pv := UI.vbox(2)
	pv.add_child(UI.label(GameMoney.text(int(round(total * MM.GYM_SHARE))), UI.BODY, UI.FG, "bold"))
	pv.add_child(UI.label("of a %s purse" % GameMoney.text(total), UI.SMALL, UI.MUTED))
	h.add_child(_fixed(COL_PAY, pv))
	var acts := UI.vbox(6)
	if ask:
		acts.add_child(UI.button("Book %s" % opp["first"], "BtnSolid", main.act.bind("probook", "%s:%d:a" % [f["id"], int(opp["id"])])))
	else:
		acts.add_child(UI.button("Take this fight", "BtnSolid", main.act.bind("probook", "%s:%d:o" % [f["id"], int(opp["id"])])))
	var why := "Already scouted" if scouted else ("Not enough cash" if c.cash < MM.SCOUT_COST else "")
	acts.add_child(UI.button("Scout (%s)" % GameMoney.text(MM.SCOUT_COST), "Btn",
		main.act.bind("proscout", "%s:%d" % [f["id"], int(opp["id"])]), why != "", why))
	h.add_child(_fixed(COL_ACT, acts))
	return h


static func _win_short(c: Career, f: Dictionary, opp: Dictionary, duck: bool = false) -> String:
	var e := ProLadder.entry(c, f)
	var you := int(e.get("rank", 0))
	var r := int(opp.get("rank", 0))
	var gap := float(opp["rating"]) - float(e["rating"])
	var fans := 1 + int(gap > 2.0) - int(gap <= -MM.SOFT_GAP)
	var place := "Takes #%d" % r if r > 0 and (you == 0 or r < you) else "No place moves"
	if str(opp.get("belt", "")) != "":
		place += " and the belt"
	var word := "+%d" % fans if fans > 0 else ("no" if fans == 0 else str(fans))
	return "%s, %s fan%s" % [place, word, "" if absi(fans) == 1 else "s"]


## The opponent's tape: the weapon is public (pros fight on television); the weakness takes a scout.
static func _tape_lines(bo: Dictionary) -> Array:
	var out: Array = []
	for t in OppFile.tells(bo):
		if str(t["id"]) == "weapon":
			out.append(["Weapon: %s." % str(t["value"]).trim_suffix("."), UI.FG, "body"])
		elif str(t["id"]) == "weakness":
			if OppFile.known(bo, "weakness"):
				out.append(["Weakness: %s. Use it in the game plan." % str(t["value"]).trim_suffix("."), UI.GREEN, "bold"])
	return out


static func _road_card(c: Career, f: Dictionary) -> Control:
	var road := ProLadder.road(c, f)
	var card := UI.card("THE ROAD: %s" % str(road["div"]).to_upper())
	var v: VBoxContainer = card[1]
	v.add_child(UI.label(str(road["next"]), UI.SMALL, UI.FG, "bold", true))
	var you := int(road["you"])
	var champs: Array = []
	for r in road["rows"]:
		if str(r["belt"]) != "":
			champs.append("%s %s champion" % [str(r["name"]).get_slice(" ", 1), str(str(r["belt"]).split("_")[-1])])
	if not champs.is_empty():
		v.add_child(UI.label("Champions: %s." % ", ".join(champs), UI.SMALL, UI.MUTED, "body", true))
	v.add_child(UI.sep())
	# S397 blind round 4: the slice that matters - the names she can fight and her own place
	var lo := maxi(1, you - MM.BAND_UP) if you > 0 else MM.UNRANKED_REACH - 2
	var hi := mini(20, you + 2) if you > 0 else 20
	for r in road["rows"]:
		var rank := int(r["rank"])
		if rank < lo or rank > hi:
			continue
		var mine := str(r["name"]) == str(road["name"])
		var h := UI.hbox(8)
		h.add_child(UI.label("#%d" % rank, UI.BODY, UI.GOLD if mine else UI.MUTED, "bold"))
		var n := UI.label(str(r["name"]), UI.BODY, UI.GOLD if mine else UI.FG, "bold" if mine else "body")
		n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(n)
		v.add_child(h)
	if you == 0:
		v.add_child(UI.label("%s: unranked, below #20" % f["first"], UI.BODY, UI.GOLD, "bold"))
	v.add_child(UI.sep())
	var held := {}
	for a in ProLadder.ask_rows(c, f):
		if not bool(a["answer"]["ok"]):
			var k := str(a["answer"]["reason"])
			held[k] = (held.get(k, []) as Array) + [int(a["opp"]["rank"])]
	for k in held:
		var ranks: Array = held[k]
		v.add_child(UI.label("%s: %s." % ["#%d" % ranks[0] if ranks.size() == 1 else "#%d-#%d" % [ranks[0], ranks[-1]],
			k.replace("Too high: you", "too high; you")], UI.SMALL, UI.FG, "body", true))
	if int(road["ducks"]) > 0:
		v.add_child(UI.label("Ducked %d step up%s in a row: take a harder fight to clear it." % [int(road["ducks"]),
			"" if int(road["ducks"]) == 1 else "s"], UI.SMALL, UI.AMBER, "bold", true))
	return card[0]
