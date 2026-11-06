extends RefCounted
## S388 the hook made visible (docs/PLAYER_PATH.md section 8, step 10): why the fight went the way it did, in plain lines. The grade comes
## from arrow_fit, the boxing reading of each planned move against what the opponent was doing (PlanFight.ANSWERS). It does not depend on
## the dice, so a good plan reads as good even in a loss. plan_swing (the same dice without the plan's edge) stays as a true count.
## read(rounds, first, opp) -> {"grade", "plan", "against", "next", "worth", "best", "wrong", "used", "all", "for", "cost"}.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

const GRADES := {"good": "GOOD PLAN", "mixed": "MIXED PLAN", "wrong": "WRONG PLAN", "none": "NO PLAN"}
## The grade is the plan against no plan at all: the mean edge per exchange. Below zero it did worse than improvising.
const GOOD_AT := 1.5
const WRONG_AT := 0.0
## Chance of winning the bout per point of mean plan edge. Measured S388, tools/plan_effect_probe.gd: +2.96 edge = +14 points.
const WORTH_PER_EDGE := 4.7
const MIN_HABIT := 3
const SIT_WORDS := {"press": "pressure", "range": "a boxer at range", "counter": "a counter-puncher", "counter_late": "a counter-puncher",
	"loadup": "big loaded shots", "tiring": "a tiring opponent", "hurt": "a hurt opponent", "hurt_danger": "a hurt opponent who hits back",
	"she_tired": "%s tiring", "she_hurt": "%s being hurt"}


static func read(rounds: Array, first: String, opp: String) -> Dictionary:
	var best := {}
	var wrong := {}
	var habits := {}
	var sits := {}
	var t := {"best": 0, "wrong": 0, "used": 0, "all": 0, "for": 0, "cost": 0, "edge": 0.0, "mine": 0, "theirs": 0}
	for r in rounds:
		for x in r.get("exchanges", []):
			t["all"] += 1
			var landed: Array = x.get("landed", [0, 0])
			t["mine"] += int(landed[0])
			t["theirs"] += int(landed[1])
			var sit := str(x.get("psit", ""))
			if sit != "":
				sits[sit] = int(sits.get(sit, 0)) + 1
			var swing := int(x.get("plan_swing", 0))
			t["for"] += maxi(0, swing)
			t["cost"] += maxi(0, -swing)
			t["edge"] += float(x.get("plan_edge", 0.0))
			if bool(x.get("planned", false)):
				t["used"] += 1
				var pair := "%s|%s" % [x["arrow"], x.get("psit", "")]
				match str(x.get("arrow_fit", "")):
					"best":
						t["best"] += 1
						best[pair] = int(best.get(pair, 0)) + 1
					"wrong":
						t["wrong"] += 1
						wrong[pair] = int(wrong.get(pair, 0)) + 1
			var habit := str(x.get("habit", ""))
			if habit != "" and habit != str(x.get("fix", "")) and not bool(x["won"]):
				habits[habit] = int(habits.get(habit, 0)) + 1
	var grade := _grade(t)
	var top_best := _top(best)
	var top_wrong := _top(wrong)
	var worth := int(round(float(t["edge"]) / maxf(1.0, float(t["all"])) * WORTH_PER_EDGE / 5.0)) * 5   # to the nearest 5: it is an estimate
	var out := t.duplicate()
	out["grade"] = grade
	out["worth"] = worth
	out["plan"] = _plan_line(grade, t, first, worth)
	var won := _won(rounds)
	out["against"] = _against_line(grade, top_wrong, wrong, habits, first, opp, won, t, rounds)
	out["next"] = _next_line(grade, top_best, top_wrong, first, opp, won, _top(sits))
	return out


static func _grade(t: Dictionary) -> String:
	if int(t["used"]) == 0:
		return "none"
	var mean := float(t["edge"]) / maxf(1.0, float(t["all"]))
	return "good" if mean >= GOOD_AT else ("wrong" if mean < WRONG_AT else "mixed")


static func _plan_line(grade: String, t: Dictionary, first: String, worth: int) -> String:
	var counts := "%s, %s, %d neutral" % [_n(int(t["best"]), "right answer"), _n(int(t["wrong"]), "wrong one"), int(t["used"]) - int(t["best"]) - int(t["wrong"])]
	var value := "Worth about %+d%% on the chance of winning." % worth if worth != 0 else "No real change to the chance of winning."
	match grade:
		"none":
			return "%s improvised all %d exchanges." % [first, int(t["all"])]
		"good":
			return "It read this opponent well: %s. %s" % [counts, value]
		"wrong":
			if worth == 0:
				return "It fought the wrong fight: %s. No better than having no plan." % counts
			return "It fought the wrong fight: %s. Worse than having no plan, about %+d%% on the chance of winning." % [counts, worth]
	return "It helped a little: %s. %s" % [counts, value]


static func _against_line(grade: String, top_wrong: String, wrong: Dictionary, habits: Dictionary, first: String, opp: String, won: bool, t: Dictionary, rounds: Array) -> String:
	if top_wrong != "" and grade != "good":
		var p := top_wrong.split("|")
		return "%s was the wrong answer to %s, %s." % [name_of(p[0]), sit_word(p[1], first), _n(int(wrong[top_wrong]), "time")]
	var habit := _top(habits)
	if habit != "" and int(habits[habit]) >= MIN_HABIT:
		return "%s's habit cost exchanges: %s, %s." % [first, LiveRound.habit_name(habit).to_lower(), _n(int(habits[habit]), "time")]
	if won:
		return "Nothing went badly wrong."
	return "%s landed %d to %s's %d, and took %s." % [opp, int(t["theirs"]), first, int(t["mine"]), _lost(rounds)]


static func _next_line(grade: String, top_best: String, top_wrong: String, first: String, opp: String, won: bool, top_sit: String) -> String:
	if grade == "none":
		if top_sit != "" and best_answer(top_sit) != "":
			return "Write a plan in the Playbook. The main problem was %s: %s answers that." % [sit_word(top_sit, first), best_answer(top_sit)]
		return "Write a plan in the Playbook before the next fight."
	if grade == "good" and not won:
		return "Keep the plan: it was right. The gap was elsewhere, so check the camp and %s's condition." % first
	if top_wrong != "" and grade != "good":
		var p := top_wrong.split("|")
		var better := best_answer(p[1])
		if better != "":
			return "Against %s, replace %s. Try %s." % [sit_word(p[1], first), name_of(p[0]), better]
		return "Replace %s in the plan." % name_of(p[0])
	if top_best != "":
		var q := top_best.split("|")
		return "Keep it: %s answers %s." % [name_of(q[0]), sit_word(q[1], first)]
	return "Keep the plan."


static func _n(n: int, word: String) -> String:
	return "%d %s%s" % [n, word, "" if n == 1 else "s"]


static func name_of(move_id: String) -> String:
	return str(StrikeMap.move(move_id).get("name", move_id))


static func sit_word(sit: String, first: String) -> String:
	var w := str(SIT_WORDS.get(sit, "that"))
	return w % first if w.contains("%s") else w


## The first best answer to a situation, by name.
static func best_answer(sit: String) -> String:
	var row: Array = (PlanFight.ANSWERS.get(sit, {}) as Dictionary).get("best", [])
	return name_of(str(row[0])) if not row.is_empty() else ""


## "round 2" or "rounds 1 and 3": the rounds the boxer lost.
static func _lost(rounds: Array) -> String:
	var lost: Array = []
	for i in rounds.size():
		if not bool(rounds[i].get("won", false)):
			lost.append(str(i + 1))
	if lost.size() < 2:
		return "round %s" % (lost[0] if not lost.is_empty() else "1")
	return "rounds %s and %s" % [", ".join(PackedStringArray(lost.slice(0, -1))), lost[-1]]


static func _won(rounds: Array) -> bool:
	return rounds.filter(func(r): return bool(r.get("won", false))).size() * 2 > rounds.size()


static func _top(counts: Dictionary) -> String:
	var out := ""
	var top := 0
	for id in counts:
		if int(counts[id]) > top:
			top = int(counts[id])
			out = str(id)
	return out
