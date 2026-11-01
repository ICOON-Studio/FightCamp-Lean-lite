extends SceneTree
## S345 FIGHTHUD2 FightMeters: the six bars a boxer (head, body, legs, stamina, guard, heart) and the round edge, read off
## the ring's own state. Population: three different source boxers built here (fresh, a beaten-up southpaw-side face, a
## tired body-worked one) and three real opponents' files (Maria Ortega pressure fighter, Priya Nair counter-puncher,
## Dana Whitfield the mismatch with no habit on file) from Data.

const Data := preload("res://scripts/state/Data.gd")
const FM := preload("res://scripts/rules/FightMeters.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")

var failures := 0


func _initialize() -> void:
	# 1. A fresh boxer: every bar full, nothing grey, all known.
	var fresh := FM.bars({})
	_check(fresh.keys() == FM.ORDER, "six bars in the HUD's order (%s)" % str(fresh.keys()))
	_check(FM.ORDER.all(func(k): return float(fresh[k]["fill"]) == 1.0 and float(fresh[k]["keep"]) == 1.0 and bool(fresh[k]["known"])),
		"fresh: every bar full and known")

	# 2. Head = her worst head place (a swollen eye drags it), body = her worse side of the ribs; that damage stays.
	var hit := FM.bars({"places": {"head": 80.0, "left_eye": 42.0, "right_eye": 90.0, "nose": 70.0, "left_ribs": 95.0, "right_ribs": 61.0}})
	_check(is_equal_approx(float(hit["head"]["fill"]), 0.42) and is_equal_approx(float(hit["head"]["keep"]), 0.42), "head: the swollen eye (42) is the bar, all of it gone for good")
	_check(is_equal_approx(float(hit["body"]["fill"]), 0.61), "body: the worse rib side (61)")

	# 3. Stamina: the bar is her energy; every body shot greys a slice off its end for the fight.
	var tired := FM.bars({"energy": 55.0, "energy_start": 90.0, "body_taken": 4})
	var worked := FM.bars({"energy": 55.0, "energy_start": 90.0, "body_taken": 20})
	_check(is_equal_approx(float(tired["stamina"]["fill"]), 0.55) and is_equal_approx(float(tired["stamina"]["keep"]), 0.9),
		"stamina: fill 0.55, the round's start (90) caps what comes back (%.2f)" % float(tired["stamina"]["keep"]))
	_check(float(worked["stamina"]["keep"]) < float(tired["stamina"]["keep"]) and float(worked["stamina"]["keep"]) >= 0.55,
		"20 body shots grey more of the tank than 4 (%.2f < %.2f), never past what she has now" % [float(worked["stamina"]["keep"]), float(tired["stamina"]["keep"])])
	var empty := FM.bars({"energy": 30.0, "energy_start": 40.0, "body_taken": 60})
	_check(is_equal_approx(float(empty["stamina"]["keep"]), 0.3), "the grey never eats what she has (keep = fill 0.30)")

	# 4. Legs and guard from the body's Burn: tiring shoulders sink the guard before the 3D drops a glove; a dropped glove
	# takes the rest.
	var arms := FM.bars({"burn": {"lead_shoulder": 60.0, "rear_shoulder": 40.0, "legs": 70.0}})
	_check(is_equal_approx(float(arms["guard"]["fill"]), 1.0 - 0.5 * FM.TIRE_SHOW), "guard: shoulders at 50 -> %.2f" % float(arms["guard"]["fill"]))
	_check(is_equal_approx(float(arms["legs"]["fill"]), 0.3), "legs: burn 70 -> 0.30")
	var dropped := FM.bars({"burn": {"lead_shoulder": 60.0, "rear_shoulder": 40.0}, "drop": {"lead": 0.9, "rear": 0.7}})
	_check(is_equal_approx(float(dropped["guard"]["fill"]), 0.2), "guard: gloves down 0.8 -> 0.20")

	# 5. Heart: counts cost far more than hurt moments; a big heart holds on longer; the 4th count leaves a heart-55 boxer
	# near empty (the referee stops it at four).
	_check(FM.heart(55.0, 0, 0) == 1.0, "heart: untouched = full")
	_check(FM.heart(55.0, 4, 0) < 0.2, "heart 55, four counts: near empty (%.2f)" % FM.heart(55.0, 4, 0))
	_check(FM.heart(85.0, 2, 1) > FM.heart(30.0, 2, 1), "a big heart holds on longer (%.2f > %.2f)" % [FM.heart(85.0, 2, 1), FM.heart(30.0, 2, 1)])
	_check(FM.heart(55.0, 0, 1) > FM.heart(55.0, 1, 0), "a hurt moment costs less than a standing count")
	var src_heart := FM.bars({"heart_attr": 70.0, "counts": 1, "hurts": 2})
	_check(is_equal_approx(float(src_heart["heart"]["fill"]), FM.heart(70.0, 1, 2)), "bars() heart = heart(attr, counts, hurts)")

	# 6. Round edge: red's margins push it up, blue's down, capped at EDGE_FULL clear exchanges.
	_check(FM.edge([]) == 0.0, "edge: no exchange yet = level")
	_check(FM.edge([{"margin": 30.0}, {"margin": 45.0}, {"margin": 30.0}]) == 1.0, "edge: three clear red exchanges fill it")
	var close := FM.edge([{"margin": 10.0}, {"margin": -5.0}])
	_check(close > 0.0 and close < 0.2, "edge: a close round leans a little (%.2f)" % close)
	_check(FM.edge([{"margin": -30.0}, {"margin": -12.0}]) < -0.4, "edge: blue's round goes the other way")
	# The round's own rule: two small wins beat one big loss (Exchanges.round_of), so the meter leans her way too.
	var two_small := [{"won": true, "margin": 3.0}, {"won": true, "margin": 4.0}, {"won": false, "margin": -40.0}]
	_check(FM.edge(two_small) > 0.0, "edge: 2 small wins + 1 big loss still leans red, as the round is scored (%.2f)" % FM.edge(two_small))

	# 7. Hurt moments: the exchanges that left that side hurt.
	var xs := [{"after": {"hurt": [false, true]}}, {"after": {"hurt": [true, true]}}, {"after": {}}]
	_check(FM.hurt_moments(xs, 0) == 1 and FM.hurt_moments(xs, 1) == 2, "hurt moments: hers 1, the opponent's 2")

	# 8. Scouting: her guard shows once a habit is on file, her heart once her weakness is; unknown bars carry known false.
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	_check(not FM.guard_known(maria) and not FM.heart_known(maria), "Maria unscouted: guard and heart '?'")
	OppFile.open(maria, "weapon")
	_check(not FM.guard_known(maria), "Maria: her weapon alone does not show her guard (she has habits to find)")
	OppFile.open(maria, "habit:fades_late")
	_check(FM.guard_known(maria) and not FM.heart_known(maria), "Maria: a habit found -> guard shows, heart still '?'")
	OppFile.open(maria, "weakness")
	_check(FM.heart_known(maria), "Maria: weakness found -> heart shows")
	var priya: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	OppFile.open_all(priya)
	_check(FM.guard_known(priya) and FM.heart_known(priya), "Priya, file open: both show")
	var dana: Dictionary = (Data.MISMATCH as Dictionary).duplicate(true)
	_check(RoundStyle.opponent_habits(dana).is_empty(), "Dana has no habit on file (the no-habit case)")
	_check(not FM.guard_known(dana), "Dana unscouted: guard '?'")
	OppFile.open(dana, "weapon")
	_check(FM.guard_known(dana), "Dana: no habit to find, her weapon shows her guard")
	var hidden := FM.bars({"guard_known": false, "heart_known": false})
	_check(not bool(hidden["guard"]["known"]) and not bool(hidden["heart"]["known"]) and bool(hidden["head"]["known"]), "bars(): '?' only on guard and heart")

	print("FIGHT_METERS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
