extends SceneTree
## S397 rank 4, rule 2's bot test (docs/STRUCTURE_DESIGN_S395.md 5.3a): a new pro on a WORLD1 men's lightweight table, two
## game years, CAREERS seeds per bot. Bots:
##   easy   always the softest offer, never asks, never scouts
##   hard   always asks for the highest place the promoter allows, else the hardest offer
##   smart  the highest place it reads as a fair chance (SMART_AT), scouting the fight it is about to take (two looks a pick)
##   blind  smart without scouting: prices the unknown; scouting must buy more top-10 finishes and fewer stoppages
## Matchmaking passes when the bot that thinks beats both plain ones: a better median end place than easy by EASY_MARGIN places
## and than hard by HARD_MARGIN, and more rating gained than easy. Prints MATCHMAKING_BOTS failures=<n>.

const WG := preload("res://scripts/world/WorldGen.gd")
const WS := preload("res://scripts/world/WorldSim.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")

const CAREERS := 120
const MONTHS := 24
const DIV := "m_lw"
const START_RATING := 64.0
const SMART_AT := 0.55
const SCOUTS_PER_PICK := 2   # smart scouts the fight it is about to take (at most two looks a pick)
const EASY_MARGIN := 3.0
const HARD_MARGIN := 1.0
const UNRANKED_PLACE := 25
const SCOUT_TOP10 := 5

var failures := 0


func _initialize() -> void:
	var res := {}
	for bot in ["easy", "hard", "smart", "blind"]:
		res[bot] = _run(bot)
		var r: Dictionary = res[bot]
		print("%-5s end place median %4.1f  top-10 %2d/%d  rating +%.1f  gym money $%d  record %.1f-%.1f  stopped %.2f  belts %d" % [
			bot, r["place"], r["top10"], CAREERS, r["grow"], r["money"], r["w"], r["l"], r["stopped"], r["belts"]])
	_bar("smart's median place beats easy's by >= %.0f" % EASY_MARGIN,
		float(res["easy"]["place"]) - float(res["smart"]["place"]) >= EASY_MARGIN)
	_bar("smart's median place beats hard's by >= %.0f" % HARD_MARGIN,
		float(res["hard"]["place"]) - float(res["smart"]["place"]) >= HARD_MARGIN)
	_bar("smart gains more rating than easy", float(res["smart"]["grow"]) > float(res["easy"]["grow"]))
	print("the unknown: scouting %+d top-10 finishes, %+.2f stoppage losses, %+d gym money against the same bot blind" % [
		int(res["smart"]["top10"]) - int(res["blind"]["top10"]), float(res["smart"]["stopped"]) - float(res["blind"]["stopped"]),
		int(res["smart"]["money"]) - int(res["blind"]["money"])])
	_bar("scouting is worth it: >= %d more top-10 finishes than blind" % SCOUT_TOP10,
		int(res["smart"]["top10"]) - int(res["blind"]["top10"]) >= SCOUT_TOP10)
	_bar("scouting is worth it: fewer stoppage losses than blind", float(res["smart"]["stopped"]) < float(res["blind"]["stopped"]))
	print("MATCHMAKING_BOTS failures=%d" % failures)
	quit(failures)


func _bar(what: String, ok: bool) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _run(bot: String) -> Dictionary:
	var places: Array = []
	var top10 := 0
	var grow := 0.0
	var money := 0
	var w := 0
	var l := 0
	var stopped := 0
	var belts := 0
	for c in CAREERS:
		var rng := RandomNumberGenerator.new()
		rng.seed = 7000 + c
		var world := WG.generate(7000 + c)
		var divs: Dictionary = world["divisions"]
		var boxers: Array = divs[DIV]["boxers"]
		var p := MM.join(boxers, "You", START_RATING, 22, 7000 + c)
		var start := float(p["rating"])
		var since := MM.NEXT_WEEKS
		for m in MONTHS:
			WS.simulate_month(divs, rng)
			since += 4   # weeks in a month, near enough
			if since >= int(p["next_weeks"]):
				var opp := _pick(bot, p, boxers, rng)
				if not opp.is_empty():
					MM.fight(p, opp, boxers, rng)
					since = 0
			if m % 12 == 11:
				WS.year_end(divs, rng)
		var place := int(p["rank"]) if int(p["rank"]) > 0 else UNRANKED_PLACE
		places.append(place)
		top10 += int(place <= 10)
		grow += float(p["rating"]) - start
		money += int(p["money"])
		w += int(p["w"])
		l += int(p["l"])
		stopped += int(p["damage_ledger"].get("stoppage_losses", 0))
		belts += int(str(p.get("belt", "")) != "")
	places.sort()
	var n := float(CAREERS)
	return {"place": (float(places[CAREERS / 2 - 1]) + float(places[CAREERS / 2])) / 2.0, "top10": top10, "grow": grow / n,
		"money": int(money / CAREERS), "w": w / n, "l": l / n, "stopped": stopped / n, "belts": belts}


func _pick(bot: String, p: Dictionary, boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
	var offered := MM.offers(p, boxers, rng)
	if offered.is_empty():
		return {}
	match bot:
		"easy":
			offered.sort_custom(func(a, b): return float(a["hi"]) < float(b["hi"]))
			MM.note_choice(p, offered[0]["opp"], offered)
			return offered[0]["opp"]
		"hard":
			var target := _best_ask(p, boxers)
			if not target.is_empty():
				MM.note_choice(p, target, offered)
				return target
			offered.sort_custom(func(a, b): return float(a["lo"]) > float(b["lo"]))
			MM.note_choice(p, offered[0]["opp"], offered)
			return offered[0]["opp"]
	return _smart(p, boxers, offered, rng, bot != "blind")


## The highest place the promoter will give right now.
func _best_ask(p: Dictionary, boxers: Array) -> Dictionary:
	var ranked := boxers.filter(func(b): return int(b.get("rank", 0)) > 0 and not b.get("player", false) and not b.get("retired", false))
	ranked.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	for b in ranked:
		if MM.ask(p, b)["ok"]:
			return b
	return {}


func _smart(p: Dictionary, boxers: Array, offered: Array, rng: RandomNumberGenerator, scouts: bool) -> Dictionary:
	var options: Array = offered.duplicate()
	var ranked := boxers.filter(func(b): return int(b.get("rank", 0)) > 0 and not b.get("player", false) and not b.get("retired", false))
	ranked.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	for b in ranked:
		if (int(p["rank"]) == 0 or int(b["rank"]) < int(p["rank"])) and MM.ask(p, b)["ok"]:
			var g := MM.guess(b, rng)
			g["kind"] = "ask"
			options.append(g)
	options.sort_custom(func(a, b): return _place_of(a["opp"]) < _place_of(b["opp"]))
	var scouts_left := SCOUTS_PER_PICK if scouts else 0
	for g in options:
		var ch := MM.shown_chance(p, g)
		if float(ch["hi"]) < SMART_AT:
			continue
		if scouts_left > 0 and not g["scouted"] and int(p["money"]) >= MM.SCOUT_COST * 3:
			if MM.scout(p, g, rng):
				scouts_left -= 1
			ch = MM.shown_chance(p, g)
		if float(ch["mid"]) >= SMART_AT:
			MM.note_choice(p, g["opp"], offered)
			return g["opp"]
	var level := offered.filter(func(g): return str(g["kind"]) == "level")
	var pick: Dictionary = (level[0] if not level.is_empty() else offered[0])["opp"]
	MM.note_choice(p, pick, offered)
	return pick


func _place_of(b: Dictionary) -> int:
	return int(b["rank"]) if int(b.get("rank", 0)) > 0 else 99
