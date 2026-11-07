extends SceneTree
## S397 rank 5, P12: the four head coaches and the three starts (HeadCoach, ClubStart; ops/research/RANK5_FIRST_HOUR_S397.md).
##   1. every card has an edge, a past, a result line, the moment it is first felt and a photo that exists; one is marked first
##   2. each edge reads only for its own card, and each is the number the card says
##   3. the strength coach pays for the engines with the craft (critic S397: no card dominates); the edge reaches the week's sums
##   4. the old hand's cut runs deeper in the week's sums (WeekPlan.day) and in the weigh-in forecast
##   5. the starts: cash, members, rent, loan, the walk-in; the quick start is the fresh start with card 1
##   6. a career made from the create screen's picks carries them; an old save ({} head, "" start) reads as no edge, fresh

const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _initialize() -> void:
	# 1. The cards.
	_check(HeadCoach.ids() == ["oldhand", "expro", "amateur", "strength"], "four cards in order: %s" % str(HeadCoach.ids()))
	var firsts := 0
	for id in HeadCoach.ids():
		var cd := HeadCoach.card(id)
		for k in ["title", "past", "edge", "plain", "felt"]:
			_check(str(cd.get(k, "")).length() > 3, "%s has its %s" % [id, k])
		_check(ResourceLoader.exists("res://assets/models/metahuman/%s.glb" % cd["photo"]), "%s's photo is a real corner body (%s)" % [id, cd["photo"]])
		firsts += 1 if bool(cd["first"]) else 0
	_check(firsts == 1 and bool(HeadCoach.card("oldhand")["first"]), "exactly one card is marked for a first career: the old hand")
	_check(HeadCoach.make("  ", "nope") == {"name": HeadCoach.DEFAULT_NAME, "bg": "oldhand"}, "a blank name and unknown card fall back")

	# 2. Each edge for its own card only.
	var heads := {}
	for id in HeadCoach.ids():
		heads[id] = HeadCoach.make("Sam", id)
	_check(HeadCoach.free_tells(heads["expro"]) == 1 and HeadCoach.free_tells(heads["oldhand"]) == 0 and HeadCoach.free_tells({}) == 0,
		"the ex-pro, and only the ex-pro, opens one tell on booking")
	_check(HeadCoach.sees_potential(heads["amateur"]) and not HeadCoach.sees_potential(heads["expro"]), "only the amateur coach sees potential exactly")
	_check(HeadCoach.cut_kcal(heads["oldhand"]) == 120.0 and HeadCoach.cut_kcal(heads["strength"]) == 0.0, "only the old hand cuts deeper (120 kcal)")

	# 3. Strength: engines up 10%, craft down 10%, the rest the same; the edge reaches WeekPlan.day.
	var s: Dictionary = heads["strength"]
	_check(HeadCoach.gain_mult(s, "conditioning") == 1.1 and HeadCoach.gain_mult(s, "power") == 1.1 and HeadCoach.gain_mult(s, "speed") == 1.1,
		"strength: conditioning, power, speed +10%")
	_check(HeadCoach.gain_mult(s, "technique") == 0.9 and HeadCoach.gain_mult(s, "defense") == 0.9 and HeadCoach.gain_mult(s, "chin") == 1.0,
		"strength: technique and defence -10%, chin untouched")
	var lucy := Data.lucy()
	var ctx := {"stats": lucy["stats"], "pot": 84, "coach": 58.0, "weight": 61.4, "diet": "hold"}
	var plain := WeekPlan.day("roadwork", "normal", ctx, 20.0)
	var strong := WeekPlan.day("roadwork", "normal", ctx.merged(HeadCoach.ctx(s)), 20.0)
	_check(absf(float(strong["gain"]) / float(plain["gain"]) - 1.1) < 0.001, "a strength coach's roadwork gains 10%% more (%.4f vs %.4f)" % [strong["gain"], plain["gain"]])
	var shadow := WeekPlan.day("shadow", "normal", ctx.merged(HeadCoach.ctx(s)), 20.0)
	var shadow0 := WeekPlan.day("shadow", "normal", ctx, 20.0)
	_check(float(shadow0["gain"]) <= 0.0 or float(shadow["gain"]) < float(shadow0["gain"]), "and a craft morning gains less")

	# 4. Old hand: the cut runs deeper.
	var cut := ctx.merged({"diet": "cut"}, true)
	var kg0 := float(WeekPlan.day("roadwork", "normal", cut, 20.0)["kg"])
	var kg1 := float(WeekPlan.day("roadwork", "normal", cut.merged(HeadCoach.ctx(heads["oldhand"])), 20.0)["kg"])
	_check(absf((kg0 - kg1) - 120.0 / WeekPlan.KCAL_PER_KG) < 0.0001, "the old hand's cut day loses 120 kcal more (%.4f vs %.4f kg)" % [kg1, kg0])
	var hold0 := float(WeekPlan.day("roadwork", "normal", ctx, 20.0)["kg"])
	var hold1 := float(WeekPlan.day("roadwork", "normal", ctx.merged(HeadCoach.ctx(heads["oldhand"])), 20.0)["kg"])
	_check(hold0 == hold1, "but not while holding weight")
	var a := Career.quick_start("A", "London", "fresh", heads["expro"])
	var b := Career.quick_start("B", "London", "fresh", heads["oldhand"])
	for c in [a, b]:
		c.seed = 1
		Sim.sign(c, ["habit"])
		Sim.hire(c, "reid")
	var fa := Sim.weigh_forecast(a, a.fighter(), 19)
	var fb := Sim.weigh_forecast(b, b.fighter(), 19)
	_check(float(fb["day"]) < float(fa["day"]) - 0.1, "the old hand's walk-in weighs less on the show's morning (%.2f vs %.2f)" % [fb["day"], fa["day"]])

	# 5. The starts.
	_check(ClubStart.ids() == ["fresh", "debt", "backed"], "three starts")
	_check(Career.start_cash("fresh") == 14600, "fresh: the S324 three months, $14,600 (got %d)" % Career.start_cash("fresh"))
	_check(Career.start_cash("debt") < Career.start_cash("fresh") / 2, "debt: about one month (%d)" % Career.start_cash("debt"))
	_check(Career.start_cash("backed") > Career.start_cash("fresh") * 2, "backed: about six months at the bigger rent (%d)" % Career.start_cash("backed"))
	var d := Career.quick_start("D", "London", "debt")
	_check(d.members == 24 and d.loan_weeks == 26 and int(d.applicant["pot"]) == 90, "debt: 24 members, a 26-week loan, a potential-90 walk-in")
	_check(absf(float(d.applicant["weight"]) - 62.2) < 0.01 and float(d.applicant["stats"]["power"]) == 62.4, "debt: the walk-in is 2.2 kg over and +4 on every stat")
	_check(int(Sim.weekly_costs(d)["loan"]) == 180, "the loan is a weekly cost: $180")
	var bk := Career.quick_start("K", "London", "backed")
	var fr := Career.quick_start("F", "London")
	_check(bk.members == 40 and int(Sim.weekly_costs(bk)["rent"]) > int(Sim.weekly_costs(fr)["rent"]) * 1.4, "backed: 40 members, rent x1.5")
	_check(fr.start == "fresh" and fr.members == 30 and fr.loan_weeks == 0 and int(Sim.weekly_costs(fr)["loan"]) == 0, "the quick start is the fresh start")

	# 6. From the create screen; an old save.
	var made := Career.from_create({"name": "Pat Quinn", "coach": "amateur", "start": "backed"}, "Iron Rose", "Dublin")
	_check(made.head == {"name": "Pat Quinn", "bg": "amateur"} and made.start == "backed" and made.city == "Dublin", "the create screen's picks reach the career")
	var quick := Career.from_create({}, "Anvil Street Gym", "London")
	_check(HeadCoach.of(quick.head) == "oldhand" and quick.start == "fresh", "Quick start: card 1 and the fresh start")
	var old := Career.new()
	_check(HeadCoach.of(old.head) == "" and ClubStart.valid(old.start) == "fresh" and HeadCoach.ctx(old.head)["head_cut"] == 0.0,
		"an old save has no edge and reads as the fresh start")
	print("HEAD_COACH failures=%d" % failures)
	quit(1 if failures > 0 else 0)
