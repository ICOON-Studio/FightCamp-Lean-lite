extends SceneTree
## S412 the versus screen's poses: never the same pose on both sides, the same pair every time for one bout.

const FighterPose := preload("res://scripts/rules/FighterPose.gd")

var failures := 0


func _initialize() -> void:
	var stems: Array = []
	for n in range(1, 24):
		stems.append("mh_boxer_%02d" % n)
	print("Population: %d stems, %d pool poses" % [stems.size(), FighterPose.POOL.size()])
	var same := 0
	var moved := 0
	for a in stems:
		var mine: Array = FighterPose.of(a)
		_check(mine.size() == FighterPose.PER_BOXER and mine[0] != mine[1] and mine[1] != mine[2] and mine[0] != mine[2], "%s has three different poses" % a)
		for b in stems:
			if a == b:
				continue
			for key in ["offer_1", "offer_2", "offer_77"]:
				var p: Array = FighterPose.pair(a, b, key)
				_check(p == FighterPose.pair(a, b, key), "the same bout shows the same pictures")
				if FighterPose.of(a)[p[0]] == FighterPose.of(b)[p[1]]:
					same += 1
			if FighterPose.pair(a, b, "offer_1") != FighterPose.pair(a, b, "offer_2"):
				moved += 1
	_check(same == 0, "no bout has the same pose on both sides (%d did)" % same)
	_check(moved > 200, "another bout usually means other pictures (%d pairs moved)" % moved)
	_check(FighterPose.picture("mh_boxer_10_alt", 0) == "mh_boxer_10_alt" and FighterPose.picture("mh_boxer_10", 2) == "mh_boxer_10_p2", "picture names")
	print("FIGHTER_POSE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: " + label)
