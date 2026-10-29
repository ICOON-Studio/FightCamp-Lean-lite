extends SceneTree
## S302 fight feel (operator on the S301 film: "still too slow, the punches feel like they have no power and target enemys
## hand rather than their head"), the pure parts:
##   1. a combo's follow-up starts part-way through its wind-up and lands COMBO_LAND_S behind the last punch, never with
##      less than MIN_WIND_S of throw; a lone punch starts at 0,
##   2. the landed-punch reach eases in before contact, holds through it and lets go after,
##   3. the head snap peaks fast and settles to nothing,
##   4. RoundScript: punches inside an exchange start COMBO_GAP_S apart (not stretched), follow-ups are marked "combo".

const FightView := preload("res://scripts/fight3d/FightView.gd")
const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")

var failures := 0


func _initialize() -> void:
	# 1. Combos. A jab lands 0.365 s after it starts (contact 0.467 s of clip at speed 1.28).
	_check(FightView.combo_skip(0.467, 1.28, -9.0, 5.0) == 0.0, "a punch with no recent punch before it starts at the top")
	var last := 5.0 + 0.365
	var now := 5.25
	var skip := FightView.combo_skip(0.6, 1.2, last, now)
	var lands := now + (0.6 - skip) / 1.2
	_check(absf(lands - (last + FightView.COMBO_LAND_S)) < 0.005, "a follow-up lands %.3f s behind the last (want %.3f)" % [lands - last, FightView.COMBO_LAND_S])
	var same := FightView.combo_skip(0.9, 1.2, last, now, true)
	_check(absf(now + (0.9 - same) / 1.2 - (last + FightView.COMBO_SAME_HAND_S)) < 0.005, "a same-hand follow-up lands %.2f s behind (Piorkowski 2011)" % FightView.COMBO_SAME_HAND_S)
	var late := FightView.combo_skip(0.6, 1.2, 5.0, 5.2)
	_check((0.6 - late) / 1.2 >= FightView.MIN_WIND_S - 0.001, "a follow-up keeps at least %.2f s of throw" % FightView.MIN_WIND_S)
	# 2. Reach weight on clip time around contact 0.5 s.
	_check(PunchReach.weight(0.2, 0.5) == 0.0, "no reach long before contact")
	_check(PunchReach.weight(0.5 - PunchReach.IN_S * 0.5, 0.5) > 0.3 and PunchReach.weight(0.5 - PunchReach.IN_S * 0.5, 0.5) < 0.7, "the reach eases in")
	_check(PunchReach.weight(0.5, 0.5) == 1.0 and PunchReach.weight(0.5 + PunchReach.HOLD_S, 0.5) == 1.0, "full reach through contact")
	_check(PunchReach.weight(0.5 + PunchReach.HOLD_S + PunchReach.OUT_S + 0.01, 0.5) == 0.0, "the reach lets go after contact")
	# 3. Snap envelope.
	_check(HitSnap.envelope(HitSnap.RISE_S) > 0.99, "the head snap peaks at %.3f s" % HitSnap.RISE_S)
	_check(HitSnap.envelope(0.25) < 0.25 and HitSnap.envelope(HitSnap.LIFE_S) == 0.0, "the head snap settles to nothing")
	# 4. RoundScript exchanges, across seeds and margins.
	var tight := true
	var combos := 0
	for seed in [1, 2, 3, 7, 42, 99]:
		for won in [true, false]:
			var r := {"n": 1, "won": won, "mine": 64.0, "theirs": 60.0, "corner": "", "lines": []}
			var beats: Array = RS.build(r, "Pressure fighter", "Out-boxer", 40.0, seed)["beats"]
			for i in range(1, beats.size()):
				if bool(beats[i].get("combo", false)):
					combos += 1
					var gap := float(beats[i]["t"]) - float(beats[i - 1]["t"])
					if absf(gap - RS.COMBO_GAP_S) > 0.011 or str(beats[i]["who"]) != str(beats[i - 1]["who"]):
						tight = false
	_check(combos > 0, "follow-ups are marked combo (%d over 12 rounds)" % combos)
	_check(tight, "every combo follow-up starts %.2f s after the punch before it, by the same boxer" % RS.COMBO_GAP_S)
	print("FIGHT_FEEL failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)
