extends SceneTree
## S460 INTEGRATE1 #7: TraitLine reaches the fighter's attribute board. A trait's row carries what it does now (the lines the
## game plays) and the next line good work reaches; the hover adds the per-point effect. Lines the game does not play yet
## ("new" hooks) never show. Control arm: the same fighter on the other side of each line reads differently.

const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")

var failures := 0


func _row(p: Dictionary, key: String) -> Dictionary:
	for g in AttrBoard.rows({"personality": p, "stats": {}}):
		for r in g["rows"]:
			if str(r["key"]) == key:
				return r
	return {}


func _initialize() -> void:
	var hot := _row({"temper": 70.0}, "temper")
	var cool := _row({"temper": 50.0}, "temper")
	_check(str(hot["line"]).begins_with("Short fuse"), "temper 70: the row says Short fuse (%s)" % hot["line"])
	_check(not str(cool["line"]).contains("Short fuse"), "control, temper 50: no Short fuse (%s)" % cool["line"])
	_check(str(hot["why"]).contains("At 64") or str(hot["why"]).contains("At 65"), "temper 70: the next line is named on hover (%s)" % hot["why"])
	var fragile := _row({"confidence": 40.0}, "confidence")
	_check(str(fragile["line"]).begins_with("Fragile"), "confidence 40: Fragile on the row (%s)" % fragile["line"])
	var lax := _row({"discipline": 40.0}, "discipline")
	_check(not str(lax["why"]).contains("alone morning"), "discipline 40: the unbuilt 'skips a morning' line never shows")
	var coach := _row({"coachability": 60.0}, "coachability")
	_check(str(coach["why"]).contains("Each point: takes in"), "coachability: the per-point uptake on hover (%s)" % coach["why"])
	var heart := _row({"heart": 60.0}, "heart")
	_check(not str(heart["line"]).contains("/ 100"), "heart: no formula on the row (%s)" % heart["line"])
	print("TRAIT_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
