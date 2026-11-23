extends RefCounted
## StepValue: what a step is worth learning, against each opponent style, for the learn card.
## Owner, board Q-S294-230: "Yes, build it after the fight week". (S473: "Yes, design it".)
## Map: ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md - section 5 (the targets and the caps),
##      section 4.1 (mastery tiers, worth against Sharp), section 10 piece 6 ("the section 5 targets read by the learn card").
## Every number ESTIMATE until probes 2-7 pass (map section 9).
## Pure static: a table, a multiply and a sort. No state, no UI, no preload, no class_name.
## tier(mastery) -> "new", "usable", "sharp" or "signature" (map 4.1).
## worth(step, style, mastery, grade_word) -> wins in 100 the step is worth against that style.
## stack(steps, style, grades) -> all of a boxer's steps together against one style, positives capped at STACK_CAP.
## best_style(step) -> the style the step answers best (its target).
## wrong_style(step) -> the style the step walks into.
## learn_line(step, style, mastery, grade_word) -> the learn card's one line, in game words.
## pick_for(styles_seen, my_grades) -> all ten steps, the one to learn first at the top.

const STYLES: Array = [
	"Pressure fighter", "Slugger", "Out-boxer", "Counter-puncher", "Volume puncher", "Boxer-puncher",
]

## The steps in the order StepMastery.NODES uses; pick_for keeps this order on a tie.
const STEPS: Array = [
	"step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off",
]

## Ten steps x six styles = 60 numbers, at Sharp and OK grade (map section 5).
## Each row: the step's BEST style (its target), its WRONG style (negative), every other style the
## "against other styles" value, taken at the HIGH end of the map's range.
## S528 STEPS_SCOPE phase 3 (STEPTUNE2 s2): each wrong style is one whose main game lists the step WRONG in
## PlanFight.ANSWERS (the fight's own grading) - six rows said otherwise; feint / tie_up / push_off have no style that
## punishes them in the fight, so no negative cell. Estimates still, until TREEVALUE5 measures the cells.
const TARGET: Dictionary = {
	"step_back": {
		"Boxer-puncher": 1.0,
		"Counter-puncher": 1.0,
		"Out-boxer": -1.5,
		"Pressure fighter": 3.5,
		"Slugger": 1.0,
		"Volume puncher": 1.0,
	},
	"step_out": {
		"Boxer-puncher": 1.0,
		"Counter-puncher": 1.0,
		"Out-boxer": -1.0,
		"Pressure fighter": 1.0,
		"Slugger": 2.5,
		"Volume puncher": 1.0,
	},
	"pivot_out": {
		"Boxer-puncher": 0.0,
		"Counter-puncher": 0.0,
		"Out-boxer": -0.5,
		"Pressure fighter": 2.5,
		"Slugger": 0.0,
		"Volume puncher": 0.0,
	},
	"step_in": {
		"Boxer-puncher": 0.5,
		"Counter-puncher": 0.5,
		"Out-boxer": 3.0,
		"Pressure fighter": -2.5,
		"Slugger": 0.5,
		"Volume puncher": 0.5,
	},
	"cut_off": {
		"Boxer-puncher": 0.0,
		"Counter-puncher": 0.0,
		"Out-boxer": 3.5,
		"Pressure fighter": -1.5,
		"Slugger": 0.0,
		"Volume puncher": 0.0,
	},
	"herd": {
		"Boxer-puncher": 1.0,
		"Counter-puncher": 1.0,
		"Out-boxer": 1.0,
		"Pressure fighter": -1.5,
		"Slugger": 1.0,
		"Volume puncher": 2.0,
	},
	"feint": {
		"Boxer-puncher": 0.5,
		"Counter-puncher": 4.0,
		"Out-boxer": 0.5,
		"Pressure fighter": 0.5,
		"Slugger": 0.5,
		"Volume puncher": 0.5,
	},
	"tie_up": {
		"Boxer-puncher": 0.0,
		"Counter-puncher": 0.0,
		"Out-boxer": 0.0,
		"Pressure fighter": 0.0,
		"Slugger": 3.0,
		"Volume puncher": 0.0,
	},
	"roll_out": {
		"Boxer-puncher": 1.0,
		"Counter-puncher": 1.0,
		"Out-boxer": 1.0,
		"Pressure fighter": 1.0,
		"Slugger": 3.0,
		"Volume puncher": 1.0,
	},
	"push_off": {
		"Boxer-puncher": 0.0,
		"Counter-puncher": 0.0,
		"Out-boxer": 0.0,
		"Pressure fighter": 1.5,
		"Slugger": 0.0,
		"Volume puncher": 0.0,
	},
}

## Map 4.1: what a step at each mastery tier is worth against Sharp (1.0).
const TIER_WORTH: Dictionary = {"new": 0.0, "usable": 2.0 / 3.0, "sharp": 1.0, "signature": 4.0 / 3.0}

## Mastery bar -> tier, highest first (30 usable, 60 sharp, 85 signature).
const TIER_FROM: Array = [[85.0, "signature"], [60.0, "sharp"], [30.0, "usable"], [0.0, "new"]]

## The map's targets are AT OK grade, and StepEffect scales OK by 0.85 already, so these are relative to OK:
## good 1.2/0.85, ok 1.0, poor 0.35/0.85 (Q-211: x1.2 / 0.85 / 0.35).
const GRADE_MULT: Dictionary = {"good": 1.2 / 0.85, "ok": 1.0, "poor": 0.35 / 0.85}

## All of a boxer's steps together, against one style, never more than +5 in 100 (map section 5, FOOTWORK1's "never more").
const STACK_CAP: float = 5.0


## Mastery bar -> tier word: under 30 "new", 30-59 "usable", 60-84 "sharp", 85+ "signature".
static func tier(mastery: float) -> String:
	for i in TIER_FROM.size():
		var at: float = float(TIER_FROM[i][0])
		if mastery >= at:
			return str(TIER_FROM[i][1])
	return "new"


## Wins in 100 for one step against one style: target x tier worth x grade.
## A NEGATIVE target is not scaled by grade - walking into it hurts the same however well it is done.
## Unknown step, unknown style or an unknown grade (read as "ok") -> 0.0 for the first two, ok for the third.
static func worth(step: String, style: String, mastery: float, grade_word: String) -> float:
	if not TARGET.has(step):
		return 0.0
	var row: Dictionary = TARGET[step]
	if not row.has(style):
		return 0.0
	var base: float = float(row[style])
	var scale: float = float(TIER_WORTH.get(tier(mastery), 0.0))
	if base < 0.0:
		return base * scale
	return base * scale * _grade_mult(grade_word)


## All of a boxer's steps together against one style: the sum of worth, with the positive part capped at
## STACK_CAP and the negatives added after the cap. steps = {step id: mastery}; grades = {step id: grade word}.
static func stack(steps: Dictionary, style: String, grades: Dictionary) -> float:
	var plus: float = 0.0
	var minus: float = 0.0
	for key in steps:
		var step: String = str(key)
		var mastery: float = float(steps[step])
		var w: float = worth(step, style, mastery, _grade_word(grades, step))
		if w >= 0.0:
			plus += w
		else:
			minus += w
	return minf(plus, STACK_CAP) + minus


## The style the step answers best (highest target), "" for an unknown step.
static func best_style(step: String) -> String:
	return _style_at(step, true)


## The style the step walks into (lowest target), "" for an unknown step - and "" when no style punishes it (S528: feint,
## tie_up, push_off have no negative cell once TARGET follows the fight's ANSWERS).
static func wrong_style(step: String) -> String:
	var s := _style_at(step, false)
	return s if s != "" and float((TARGET[step] as Dictionary)[s]) < 0.0 else ""


## The learn card's one line. Game words, never jargon, no names.
## When the step is still "new", the number is what learning it to 30 buys, and the line says so.
static func learn_line(step: String, style: String, mastery: float, grade_word: String) -> String:
	if not TARGET.has(step):
		return ""
	var row: Dictionary = TARGET[step]
	if not row.has(style):
		return ""
	var use_mastery: float = mastery
	var once: String = ""
	if tier(mastery) == "new":
		use_mastery = 30.0
		once = " (once usable)"
	var w: float = worth(step, style, use_mastery, grade_word)
	var low: String = style.to_lower()
	if w > 0.05:
		return "Worth about +%.1f in 100 against a %s%s" % [w, low, once]
	if w < -0.05:
		return "A bad answer against a %s: about %.1f in 100%s" % [low, w, once]
	return "Little use against a %s%s" % [low, once]


## The ten steps for a boxer who will meet these styles: styles_seen = {style: how many of the next
## opponents / the region bring it}, my_grades = {step id: grade word}. Weighted at mastery 60 (Sharp),
## highest first; ties keep STEPS order.
static func pick_for(styles_seen: Dictionary, my_grades: Dictionary) -> Array:
	var scores: Dictionary = {}
	for i in STEPS.size():
		var step: String = str(STEPS[i])
		var grade: String = _grade_word(my_grades, step)
		var score: float = 0.0
		for key in styles_seen:
			var style: String = str(key)
			var count: float = float(styles_seen[style])
			score += worth(step, style, 60.0, grade) * count
		scores[step] = score
	# Highest score first. Only a strict gain takes a place, so a tie keeps STEPS order.
	# Sorted by hand over indices, with no sort_custom and no copy of the const: ten rows, and nothing
	# here can trip a headless run.
	var out: Array = []
	var taken: Dictionary = {}
	for _place in STEPS.size():
		var top: int = -1
		for i in STEPS.size():
			if taken.has(i):
				continue
			if top < 0:
				top = i
				continue
			var here: float = float(scores[str(STEPS[i])])
			var best: float = float(scores[str(STEPS[top])])
			if here > best + 0.000001:
				top = i
		taken[top] = true
		out.append(str(STEPS[top]))
	return out


static func _style_at(step: String, highest: bool) -> String:
	if not TARGET.has(step):
		return ""
	var row: Dictionary = TARGET[step]
	var pick: String = ""
	var pick_val: float = 0.0
	var first: bool = true
	for style in STYLES:
		var s: String = str(style)
		if not row.has(s):
			continue
		var v: float = float(row[s])
		if first:
			pick = s
			pick_val = v
			first = false
			continue
		if highest and v > pick_val:
			pick = s
			pick_val = v
		elif not highest and v < pick_val:
			pick = s
			pick_val = v
	return pick


static func _grade_word(grades: Dictionary, step: String) -> String:
	return str(grades.get(step, "ok"))


static func _grade_mult(grade_word: String) -> float:
	if GRADE_MULT.has(grade_word):
		return float(GRADE_MULT[grade_word])
	return float(GRADE_MULT["ok"])
