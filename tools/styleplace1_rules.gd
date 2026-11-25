extends RefCounted
## STYLEPLACE1 switches (S551, ops/research/TASK_STYLEPLACE1.md; every lever written BEFORE any run in
## ops/research/DESIGN_STYLEPLACE1.md with its real-bout reason). Probe only: nothing under scripts/ reads this file and no game
## file is edited. ZERO game preloads on purpose: patch() reloads PlanFight.gd IN MEMORY from its own source with GAME_CARD,
## LOST_CARD and ANSWERS as static vars and two hooks (where_next, fit), then reloads every script that reads those tables so
## none keeps a compiled-in copy. With L1 = L2 = 0 the tables hold today's values and no hook is set (the control).
##   L1  lever 1, a style owns a place: 0 off, 0.5 half (a seeded coin per exchange), 1 full.
##   L2  lever 2, press and load-up stop sharing answers: 0 / 0.5 / 1.
##   Lever 3 (the file says where she fights) changes no bout: main_place() + line() + the probe's film stage.

const PF_PATH := "res://scripts/rules/PlanFight.gd"
## Every script that reads PlanFight.GAME_CARD / LOST_CARD / ANSWERS (grep, S551), reloaded after the patch.
const READERS := ["res://scripts/rules/CoachPlan.gd", "res://scripts/rules/PlanChain.gd", "res://scripts/rules/PlanFile.gd",
	"res://scripts/rules/PlanLines.gd", "res://scripts/rules/TapeClips.gd", "res://scripts/rules/GuardNotes.gd",
	"res://scripts/rules/FightWhy.gd", "res://scripts/state/CoachReadWire.gd", "res://scripts/state/LiveRound.gd",
	"res://scripts/state/RingDuel.gd", "res://scripts/state/StepWire.gd", "res://scripts/rules/BoutRead.gd",
	"res://tools/planimpact1_rules.gd", "res://tools/planimpact2_rules.gd", "res://tools/tellplay1_rules.gd"]

const TODAY_GAME := {"press": "mid", "range": "long", "counter": "outside", "loadup": "mid", "tiring": "inside",
	"hurt": "opp_ropes", "she_tired": "inside", "she_hurt": "own_ropes"}
const TODAY_LOST := {"press": "own_ropes", "loadup": "own_ropes"}
## LEVER 1 (design s2): game -> where her game puts the fight; lost -> where losing to it leaves your boxer ("" = no LOST entry).
const PLACE := {
	"Pressure fighter": {"game": {"press": "own_ropes"}, "lost": {}},   # cuts the ring off at once (Foreman-Ali, Serrano-Taylor rd 5)
	"Slugger": {"game": {"loadup": "inside"}, "lost": {"loadup": "inside"}},   # loads up in the pocket (Tyson, Ruiz, Hatton)
	"Out-boxer": {"game": {"counter": "long", "loadup": "long"}, "lost": {"loadup": ""}},   # counters / loads up at range (Taylor, Wilder)
	"Boxer-puncher": {"game": {"loadup": "long"}, "lost": {"loadup": ""}},   # range + loadup, the Wilder shape
}
## LEVER 2 (design s2, REALPLANS_S341 s3 counts): the two rows that stop sharing their best answers.
const SPLIT := {
	"press": {"best": ["step_back", "pivot_out", "1-1"], "ok": ["slip 2-3", "roll_out", "tie_up", "push_off", "1-2", "3b-3", "1-2-3b"],
		"wrong": ["step_in", "1-2-3-2", "cut_off", "herd"]},
	"loadup": {"best": ["slip 2-3", "roll_out", "tie_up", "1-2"], "ok": ["step_back", "1-1", "pivot_out", "step_in"],
		"wrong": ["3b-3", "1-6-3", "1-2-3b"]},
}
const PLACE_WORDS := {"mid": "at hook range", "long": "at the end of her jab", "outside": "out of range, waiting",
	"inside": "chest to chest", "own_ropes": "with your boxer on the ropes", "opp_ropes": "off her own ropes"}
const GAME_WORDS := {"press": "walks you down", "range": "boxes at range", "counter": "waits to counter", "loadup": "loads up big shots"}

const HOOKS := """

## STYLEPLACE1 (probe, in memory only): hooks set by tools/styleplace1_rules.gd for the half-strength arms.
static var SP_WHERE: Callable = Callable()
static var SP_FIT: Callable = Callable()


static func sp_table(nm: String) -> Dictionary:
	match nm:
		"GAME_CARD": return GAME_CARD
		"LOST_CARD": return LOST_CARD
	return ANSWERS


static func where_next(move_id: String, won: bool, sit: String) -> String:
	if SP_WHERE.is_valid():
		return str(SP_WHERE.call(move_id, won, sit))
	return where_next0(move_id, won, sit)


static func fit(move_id: String, sit: String) -> String:
	if SP_FIT.is_valid():
		return str(SP_FIT.call(move_id, sit))
	return fit0(move_id, sit)
"""

static var L1 := 0.0
static var L2 := 0.0
static var STYLE := ""
static var KEY := 0
## The exchange index in this bout (the probe counts them); -1 = not in a bout (a read, a plan writer): full strength, no coin.
static var EX := -1
static var PF: GDScript = null
static var BASE_ANSWERS := {}


## "" when the patch took; else what failed.
static func patch() -> String:
	var s: GDScript = load(PF_PATH)
	var src := s.source_code
	for nm in ["GAME_CARD", "LOST_CARD", "ANSWERS"]:
		var a := "const %s :=" % nm
		if src.count(a) != 1:
			return "anchor " + a
		src = src.replace(a, "static var %s :=" % nm)
	for fn in ["where_next", "fit"]:
		var a := "static func %s(" % fn
		if src.count(a) != 1:
			return "anchor " + a
		src = src.replace(a, "static func %s0(" % fn)
	s.source_code = src + HOOKS
	var err := s.reload()
	if err != OK:
		return "reload PlanFight: %d" % err
	for p in READERS:   # a reader compiles PlanFight.GAME_CARD in as a constant (S551 check): it reads the live value instead
		var r: GDScript = load(p)
		var rs := r.source_code
		for nm in ["GAME_CARD", "LOST_CARD", "ANSWERS"]:
			rs = rs.replace("PlanFight.%s" % nm, "PlanFight.sp_table(\"%s\")" % nm)
		r.source_code = rs
		var e := r.reload()
		if e != OK:
			return "reload %s: %d" % [p, e]
	PF = s
	BASE_ANSWERS = (s.get("ANSWERS") as Dictionary).duplicate(true)
	return ""


static func cfg(name: String) -> void:
	var t: Dictionary = {"off": [0.0, 0.0], "L1": [1.0, 0.0], "L1h": [0.5, 0.0], "L2": [0.0, 1.0], "L2h": [0.0, 0.5], "L12": [1.0, 1.0]}
	L1 = float(t[name][0])
	L2 = float(t[name][1])


static func game_of(style: String) -> Dictionary:
	var g := TODAY_GAME.duplicate()
	if L1 > 0.0 and PLACE.has(style):
		g.merge(PLACE[style]["game"], true)
	return g


static func lost_of(style: String) -> Dictionary:
	var l := TODAY_LOST.duplicate()
	if L1 > 0.0 and PLACE.has(style):
		for k in PLACE[style]["lost"]:
			if str(PLACE[style]["lost"][k]) == "":
				l.erase(k)
			else:
				l[k] = PLACE[style]["lost"][k]
	return l


static func answers() -> Dictionary:
	var a := BASE_ANSWERS.duplicate(true)
	if L2 > 0.0:
		a.merge(SPLIT.duplicate(true), true)
	return a


## The tables for this opponent style, outside a bout (EX = -1): plan writers, the coach's cards, the read.
static func use(style: String) -> void:
	STYLE = style
	EX = -1
	PF.set("GAME_CARD", game_of(style))
	PF.set("LOST_CARD", lost_of(style))
	PF.set("ANSWERS", answers())
	PF.set("SP_WHERE", Callable(load("res://tools/styleplace1_rules.gd"), "where_hook") if L1 > 0.0 and L1 < 1.0 else Callable())
	PF.set("SP_FIT", Callable(load("res://tools/styleplace1_rules.gd"), "fit_hook") if L2 > 0.0 and L2 < 1.0 else Callable())


## A bout starts: its style and the seed of its coin.
static func begin(style: String, key: int) -> void:
	use(style)
	KEY = key
	EX = 0


static func coin(salt: int) -> bool:
	return (hash([KEY, EX, salt]) & 1) == 0


## Half-strength lever 1: her game takes the style's place on a seeded half of the exchanges, today's on the other half.
static func where_hook(move_id: String, won: bool, sit: String) -> String:
	if won and move_id != "":
		return str(PF.call("where_next0", move_id, won, sit))
	var full := EX < 0 or coin(1)
	var l: Dictionary = lost_of(STYLE) if full else TODAY_LOST
	if l.has(sit):
		return str(l[sit])
	return str((game_of(STYLE) if full else TODAY_GAME).get(sit, "long"))


## Half-strength lever 2: the split rows on a seeded half of the exchanges (a read: always split).
static func fit_hook(move_id: String, sit: String) -> String:
	if not SPLIT.has(sit) or not (EX < 0 or coin(2)):
		var row0: Dictionary = BASE_ANSWERS.get(sit, {})
		return _fit_in(row0, move_id)
	return _fit_in(SPLIT[sit], move_id)


static func _fit_in(row: Dictionary, move_id: String) -> String:
	var id := move_id.get_slice("@", 0)
	for k in ["best", "ok", "wrong"]:
		if (row.get(k, []) as Array).has(id):
			return k
	return "none"


## Lever 3: her main place (the top card of CoachPlan.cards under the current tables) from a mix of games.
static func place_of_mix(style: String, mix: Dictionary) -> String:
	var g := game_of(style)
	var l := lost_of(style)
	var per := {}
	for k in mix:
		var w := float(mix[k])
		per[str(g.get(k, "long"))] = float(per.get(str(g.get(k, "long")), 0.0)) + w
		if l.has(k):
			per[str(l[k])] = float(per.get(str(l[k]), 0.0)) + w * 0.5
	var top := ""
	for c in per:
		if top == "" or float(per[c]) > float(per[top]):
			top = str(c)
	return top


## The file's one plain line: "Slugger: loads up big shots - chest to chest".
static func line(style: String, game: String, place: String) -> String:
	return "%s: %s - %s" % [style, str(GAME_WORDS.get(game, "own way")), str(PLACE_WORDS.get(place, place))]
