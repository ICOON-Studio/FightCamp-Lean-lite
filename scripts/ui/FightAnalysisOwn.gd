extends "res://scripts/ui/FightAnalysis.gd"
## S511 FIGHTFILM1 (map ops/research/FIGHTFILM1_MAP_V3_S495.md 2.1 "Your bout", section 5): the FIGHT ANALYSIS page on one
## of your boxer's own bouts - the result page's PUNCH BY PUNCH tab and History's Analysis. The bout's stored tape
## (AfterFight m["tape"] / the results row, BoutTape) is the one film: the opponent is side b ("The opponent", blue),
## your boxer side a ("You", red). No checks, no filing: MARK A PATTERN gives way to WHAT DECIDED IT (FightWhy's three
## lines, kept as "why3") and WHAT THE OTHER CORNER WILL SEE - your boxer's own AFTER facts that stand out on this film
## (FilmCount over the tape with the corners swapped, the coach's pass bar), each with Fix it on the pads when it is one of
## your boxer's habits (Recruit's habit fix, f["habit_fix"], gone in Recruit.HABIT_WEEKS weeks; Sim.end_week settles it).
## For a pro, ProReadWire's "their corner will wait for ..." line too. The old Tape Room's films live here now.
##   FightAnalysisOwn.open(main, f, rec) -> the page added to main, or null when the bout kept no tape
##   rec = the result modal m or a c.results row: {tape, why3, d, opp, win, outcome, cards}

const FilmCount := preload("res://scripts/rules/FilmCount.gd")
const FilmMoments := preload("res://scripts/rules/FilmMoments.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const Clock := preload("res://scripts/state/Clock.gd")

const SIDE_WORDS := ["The opponent", "You"]
const MAX_FACTS := 3

var fighter: Dictionary = {}
var rec: Dictionary = {}
var day := 0
var _see_box: VBoxContainer


## The page on a bout, added to main (null when the bout has no tape: "no tape kept").
static func open(main: Node, f: Dictionary, r: Dictionary) -> Control:
	var film := film_of(r)
	if film.is_empty():
		return null
	var page := new()
	page.fighter = f
	page.rec = r
	page.day = int((main.career as Career).day) if main != null and main.get("career") != null else 0
	page.for_tape({"name": str(r.get("opp", "")), "sex": str(f.get("sex", "f"))}, [film], {"checks_left": 0, "opp_checks_left": 0},
		Callable(), Callable(), Callable())
	main.add_child(page)
	return page


## The bout as a film: {exchanges, rounds, row}; {} without a tape.
static func film_of(r: Dictionary) -> Dictionary:
	var tape: Array = r.get("tape", [])
	if tape.is_empty():
		return {}
	var n := 1
	for ex in tape:
		n = maxi(n, int((ex as Dictionary).get("round", 1)))
	return {"exchanges": tape, "rounds": n, "row": {"d": int(r.get("d", r.get("day", 0))), "vs": str(r.get("opp", "")),
		"win": bool(r.get("win", str(r.get("outcome", "")) == "win"))}}


func _ready() -> void:
	super._ready()
	next_film_btn.get_parent().visible = false   # one film, no checks: your own bout
	_pips.get_parent().visible = false
	(header.find_child("Done", true, false) as Button).text = "Close"
	for k in ["b", "a"]:
		((report.get("_tabs") as Dictionary)[k] as Button).text = str(SIDE_WORDS[0 if k == "b" else 1])
	UI.clear(_strip)
	_strip.add_child(ReportPanel.rounds_strip(films[0], _rounds(), SIDE_WORDS))


func _fill_header() -> void:
	var names: HBoxContainer = header.find_child("Names", true, false)
	UI.clear(names)
	names.add_child(_dot(Palette.RED_CORNER))
	names.add_child(_lab(str(fighter.get("name", "")), 28, Palette.TEXT, "bold"))
	names.add_child(_lab("vs", 22, Palette.MUTED, "bold"))
	names.add_child(_dot(Palette.BLUE_CORNER))
	names.add_child(_lab(str(rec.get("opp", "")), 28, Palette.TEXT, "bold"))
	names.add_child(_lab("  " + bout_words(), 18, Palette.MUTED, "semi"))
	_fill_checks()


## "Mar 2026 - won on points, 3 x 3 min" (the cards when kept).
func bout_words() -> String:
	var out := str(rec.get("outcome", "win" if bool(rec.get("win", false)) else "loss"))
	var cards := str(rec.get("cards", ""))
	var how := ("stopped in round " + cards.get_slice("round", 1).strip_edges()) if cards.contains("round") else "on points"
	var word := str({"win": "won", "loss": "lost", "draw": "drew"}.get(out, out))
	return "%s - %s %s, %d rounds" % [Clock.fmt(int(rec.get("d", rec.get("day", 0)))), word, "" if out == "draw" else how, _rounds()]


func _coach_idle() -> void:
	pass


func _fill_marked() -> void:
	pass


func _pattern_panel() -> Control:
	var c: Array = _card("WHAT DECIDED IT", "", 760)
	var p: PanelContainer = c[0]
	p.name = "OwnBout"
	p.size_flags_vertical = Control.SIZE_SHRINK_END
	var v: VBoxContainer = c[1]
	for line in rec.get("why3", []):
		if str(line) != "":
			v.add_child(UI.label(str(line), TXT, Palette.TEXT, "semi", true))
	v.add_child(UI.label("WHAT THE OTHER CORNER WILL SEE", 21, Palette.HEADER, "bold"))
	_see_box = UI.vbox(6)
	_see_box.name = "OtherCornerSees"
	v.add_child(_see_box)
	_fill_see()
	return p


## Your boxer's own AFTER facts on this film that pass the coach's bar, strongest first (at most MAX_FACTS).
static func stand_out(film: Dictionary) -> Array:
	var pre := FilmMoments.precompute(swapped(film))
	var out: Array = []
	for r in FilmCount.check_all_pre(pre, FilmPattern.claims()):
		var res: Dictionary = r["result"]
		if str(res.get("word", "")) == "pass":
			out.append({"claim": r["claim"], "k": int(res.get("k", 0)), "n": int(res.get("n", 0)), "z": float(res.get("z", 0.0))})
	out.sort_custom(func(a, b): return float(a["z"]) > float(b["z"]))
	return out.slice(0, MAX_FACTS)


## The film with the corners swapped (FilmCount reads side b, "them"): your boxer's punches become b's.
static func swapped(film: Dictionary) -> Dictionary:
	var exs: Array = []
	for ex in film.get("exchanges", []):
		var e: Dictionary = (ex as Dictionary).duplicate(true)
		e["won"] = not bool(e.get("won", false))
		var l: Array = e.get("landed", [0, 0])
		e["landed"] = [l[1], l[0]] if l.size() == 2 else l
		for b in e.get("beats", []):
			(b as Dictionary)["who"] = "b" if str((b as Dictionary).get("who", "")) == "a" else "a"
		exs.append(e)
	var out := film.duplicate()
	out["exchanges"] = exs
	return out


## The habit a fact is, when your boxer has it ("" otherwise): Fix it on the pads trains it out.
func habit_of(claim: Dictionary) -> String:
	var t := FilmPattern.matches(fighter.get("habits", []), "", claim)
	return t.trim_prefix("habit:") if t.begins_with("habit:") else ""


## Fix it on the pads: the pads work the habit out (Recruit's habit fix), one habit at a time.
func fix_on_pads(habit: String) -> bool:
	if habit == "" or fighter.has("habit_fix"):
		return false
	fighter["habit_fix"] = {"id": habit, "until": day + Recruit.HABIT_WEEKS * 7}
	_fill_see()
	return true


func _fill_see() -> void:
	UI.clear(_see_box)
	var facts := stand_out(films[0])
	if facts.is_empty():
		_see_box.add_child(UI.label("Nothing stands out on this film: their corner would have to guess.", TXT, Palette.MUTED, "semi", true))
	var fix: Dictionary = fighter.get("habit_fix", {})
	for x in facts:
		var cl: Dictionary = x["claim"]
		var row := UI.hbox(10)
		row.name = "Sees"
		var words := str(cl["words"]).replace("their ", "your boxer's ").replace("they are", "your boxer is").replace(" on them", " on your boxer")
		var l := UI.label("%s: %d of %d" % [words.substr(0, 1).to_upper() + words.substr(1), int(x["k"]), int(x["n"])], TXT, Palette.TEXT, "bold", true)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(l)
		var h := habit_of(cl)
		if h != "":
			var on := str(fix.get("id", "")) == h
			var b := UI.button("On the pads: gone by %s" % Clock.fmt(int(fix["until"])) if on else "Fix it on the pads", "Btn", fix_on_pads.bind(h))
			b.name = "FixOnPads"
			b.disabled = not fix.is_empty()
			b.tooltip_text = "The pads work this habit out over %d weeks; one habit at a time." % Recruit.HABIT_WEEKS
			row.add_child(b)
		_see_box.add_child(row)
	if bool(fighter.get("pro", false)):
		var pr := ProReadWire.words(fighter)
		if pr != "":
			_see_box.add_child(UI.label(pr, TXT, Palette.WARN, "semi", true))
