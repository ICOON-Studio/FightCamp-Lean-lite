extends SceneTree
## DEBUTPICK1 (S533, owner Q-286 "Pick to each boxer"), cut to v17 by S543 TURNPROBUILD17: the two houses' aims, the
## matchmaker's seeded misjudgement, the house's words and hover card, the softer-opponent ask and the played debuts
## against each house's aim were deleted with the houses (map DESIGN_TURNPRO1_V17.md section 6; the result page lists
## each). What stays is the search the matchmaker uses (DebutPick.search, now ProPair's): for six different boxers the
## found opponent's read sits next to the wanted chance, the same inputs find the same gap, a stronger boxer gets a
## stronger opponent; and the offer's morale line says why turning pro moves morale.
## Population: the six the game can sign as they walk in (Data.lucy + Data.PROSPECTS: four women, two men, five styles,
## both stances). CONTROL ARM: the same six against ONE fixed opponent read far apart; the search closes that spread.

const Data := preload("res://scripts/state/Data.gd")
const DebutPick := preload("res://scripts/rules/DebutPick.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const ProPair := preload("res://scripts/state/ProPair.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")

const READ_TOL := 0.012     ## one 0.1 step of gap is about half a point of read
const COACH := 58.0
const WANT := 0.82
var failures := 0


func _initialize() -> void:
	_search()
	_morale_line()
	print("DEBUT_PICK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS %s" % label)
	else:
		failures += 1
		print("FAIL %s" % label)


func _people() -> Array:
	var out: Array = []
	for p in [Data.lucy()] + Data.PROSPECTS:
		out.append(Data.fighter_state(p, 1))
	return out


func _search() -> void:
	var near := true
	var again := true
	var gaps: Array = []
	var nights: Array = []
	var fixed: Array = []
	for f in _people():
		var read_of := func(gp: float) -> float: return ProPair.read(f, ProPair.opp_for(f, 1, "safe", gp), COACH, 0.0)
		var p := DebutPick.search(read_of, WANT)
		near = near and absf(float(p["read"]) - WANT) <= READ_TOL
		again = again and is_equal_approx(float(DebutPick.search(read_of, WANT)["gap"]), float(p["gap"]))
		gaps.append(float(p["gap"]))
		nights.append(DebutOpp.night(f["stats"]))
		fixed.append(float(read_of.call(DebutOpp.night(f["stats"]) - 45.0)))   # the control: one opponent rated 45 for all
	_check(near, "the found opponent reads within %.3f of the wanted %.2f for each of six boxers (gaps %s)" % [READ_TOL, WANT, str(gaps)])
	_check(again, "the same inputs find the same gap")
	_check(fixed.max() - fixed.min() > 0.05, "control arm: one fixed opponent reads %.3f to %.3f across the six (the search closes it)" % [fixed.min(), fixed.max()])
	var hi := nights.find(nights.max())
	var lo := nights.find(nights.min())
	_check(float(nights[hi]) - float(gaps[hi]) > float(nights[lo]) - float(gaps[lo]), "the strongest boxer gets a stronger opponent than the weakest (%.1f against %.1f)" % [float(nights[hi]) - float(gaps[hi]), float(nights[lo]) - float(gaps[lo])])


func _morale_line() -> void:
	var goal := {"w": 9, "l": 1, "pot": 80}   # S534 owner C442: the morale drop says why
	var why := ProOfferWire.morale_line(goal, true)
	_check(why.contains("a regional title") and why.contains("morale -5"), "a title-minded boxer's offer says why turning pro costs morale: %s" % why)
	_check(ProOfferWire.morale_line(goal, false) == "" and ProOfferWire.morale_line({"w": 0, "l": 0}, true) == "", "no morale line when turning pro moves nothing")
