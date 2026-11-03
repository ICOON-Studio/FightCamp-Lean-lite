extends RefCounted
## S371 GOALTESTS1 phase 2 (operator Q-S294-92 "Yes, build it"; the five seats' goal ideas, research/GOALIDEAS_*_S370.md):
## a boxer who never competes still sees the body change on three real tests, measured on the Sunday check-in, and her
## personal bests go on the gym's records wall - the old number chalked through when one is beaten (Grok: "a chalk line
## goes through the old number"; Gemini: "that same 9.0 written in chalk on the gym wall feels like a trophy"). Never a
## dice roll (Ludo's trap): a test reads the stat, so the same week gives the same number.
##   ENGINE = the bleep test (SkillAwards.bleep); SPEED = punches in 10 s; POWER = the rear hand's peak force in newtons.
## Women's values (John J_TESTS2): elite women 52 punches in 10 s (MEASURED); beginners 35-42, intermediate 45-50
## (ESTIMATE); rear-hand force beginner ~490 N, club ~770 N, elite ~990 N (ESTIMATE, one study's ratios). Men's (S372,
## J_TESTS3): the bleep test and punches in 10 s; no force test yet (POWER_MEN_AT).
##   known(sex)  measure(f) -> {engine, speed, power}  record(f, day) -> [beaten rows]  wall(f) -> [rows]

const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")

## CALIBRATION (Claude S371, for Kalli's review): the stat that reads as each level, linear between the anchors.
## [stat, value] pairs: 40 = a beginner, 60 = a club boxer, 85 = elite.
const SPEED_AT := [[40.0, 38.5], [60.0, 47.5], [85.0, 52.0]]
const POWER_AT := [[40.0, 490.0], [60.0, 770.0], [85.0, 990.0]]
## S372 men (John J_TESTS3 Q4): elite men 163 punches in 30 s on the bag, 28.6 in the first 5 s - about 57 in 10 s
## (ESTIMATE); no novice or club count exists, so those two are the women's scaled by the elite ratio 57/52 (ESTIMATE).
const SPEED_MEN_AT := [[40.0, 42.0], [60.0, 52.0], [85.0, 57.0]]
## Men's force (Smith 2000: rear hand 2,381 N novice to 4,800 N elite) was read on another device than the women's numbers
## above, so mixed in a man would read five times her force. Empty = a man takes no force test until a same-study
## men-to-women ratio lands (John J_TESTS4).
const POWER_MEN_AT := []
const TESTS: Array[Dictionary] = [
	{"id": "engine", "name": "Bleep test", "unit": "level", "fmt": "%.1f"},
	{"id": "speed", "name": "Punches in 10 s", "unit": "punches", "fmt": "%.0f"},
	{"id": "power", "name": "Rear-hand force", "unit": "N", "fmt": "%.0f"},
]


static func known(sex: String) -> bool:
	return SkillAwards.bleep_known(sex)


## Piecewise linear through the anchors, held flat past the ends' slope by a third (no cliff, no runaway).
static func _curve(x: float, at: Array) -> float:
	if x <= float(at[0][0]):
		var s0 := (float(at[1][1]) - float(at[0][1])) / (float(at[1][0]) - float(at[0][0]))
		return float(at[0][1]) - (float(at[0][0]) - x) * s0
	for i in range(1, at.size()):
		if x <= float(at[i][0]):
			var t := (x - float(at[i - 1][0])) / (float(at[i][0]) - float(at[i - 1][0]))
			return lerpf(float(at[i - 1][1]), float(at[i][1]), t)
	var n := at.size() - 1
	var s := (float(at[n][1]) - float(at[n - 1][1])) / (float(at[n][0]) - float(at[n - 1][0]))
	return float(at[n][1]) + (x - float(at[n][0])) * s / 3.0


## Today's three numbers from the stats, on that sex's norms (-1 = a test with no norms for that sex).
static func measure(f: Dictionary) -> Dictionary:
	var st: Dictionary = f.get("stats", {})
	var sex := str(f.get("sex", "f"))
	var power_at: Array = POWER_MEN_AT if sex == "m" else POWER_AT
	return {"engine": SkillAwards.bleep(float(st.get("conditioning", 50.0)), sex),
		"speed": roundf(_curve(float(st.get("speed", 50.0)), SPEED_MEN_AT if sex == "m" else SPEED_AT)),
		"power": snappedf(_curve(float(st.get("power", 50.0)), power_at), 5.0) if not power_at.is_empty() else -1.0}


## The Sunday check-in: measure, keep each new best (the old one stays as "prev" for the chalk line) and return the tests
## she beat: [{id, name, old, new, unit, fmt}]. The first check-in sets the wall and beats nothing.
static func record(f: Dictionary, day: int) -> Array:
	if not known(str(f.get("sex", "f"))):
		return []
	var now := measure(f)
	var bests: Dictionary = f.get_or_add("bests", {})
	var beaten: Array = []
	for t in TESTS:
		var id := str(t["id"])
		var v := float(now[id])
		if v < 0.0:
			continue
		if not bests.has(id):
			bests[id] = {"v": v, "d": day, "prev": -1.0, "first": v, "first_d": day}
		elif v > float(bests[id]["v"]):
			var old: Dictionary = bests[id]
			beaten.append(t.merged({"old": float(old["v"]), "new": v}))
			bests[id] = {"v": v, "d": day, "prev": float(old["v"]), "first": float(old.get("first", old["v"])),
				"first_d": int(old.get("first_d", old["d"]))}
	return beaten


## The records wall: one row per test, [{id, name, unit, fmt, best, prev, d, first, first_d}] (prev -1 = never beaten yet;
## first = the Day 1 mark, S372 GOALTESTS1 phase 2 "Day 1 vs today").
static func wall(f: Dictionary) -> Array:
	var bests: Dictionary = f.get("bests", {})
	var rows: Array = []
	for t in TESTS:
		var b: Dictionary = bests.get(str(t["id"]), {})
		if not b.is_empty():
			rows.append(t.merged({"best": float(b["v"]), "prev": float(b.get("prev", -1.0)), "d": int(b["d"]),
				"first": float(b.get("first", b["v"])), "first_d": int(b.get("first_d", b["d"]))}))
	return rows


## "7.4 level", "48 punches", "805 N".
static func text(row: Dictionary, key: String = "best") -> String:
	return (str(row["fmt"]) % float(row[key])) + " " + str(row["unit"])
