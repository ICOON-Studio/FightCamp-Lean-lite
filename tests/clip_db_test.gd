extends SceneTree
## FIGHTPLAYER2 phase 1 (S512): the clip census table holds. assets/data/clip_db.json (tools/clip_census.gd) against the
## rules in scripts/fight3d/v2/ClipCensus.gd and against the disk: every Punch PRO take on disk has a row, every take
## the shipped fight can play has a row (read off BeatClips' own pickers, so a pool edit without a re-run goes red),
## every row carries its measures in sane ranges, the drop and flag lists are the rules' (a bar edit without a re-run
## goes red), every punch the fight throws keeps at least one take that may play, and the jab keeps its bought tail.
## Pure: no scene, no body. Prints CLIP_DB failures=<n>.

const Census := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

var failures := 0


func _initialize() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(Census.DB_PATH))
	_check(parsed is Dictionary, "the table reads (%s)" % Census.DB_PATH)
	if not parsed is Dictionary:
		_done()
		return
	var db: Dictionary = parsed
	var rows: Dictionary = db.get("rows", {})
	var names: Array = db.get("names", [])
	var has := func(n): return names.has(str(n))
	_check(bool((db.get("meta", {}) as Dictionary).get("as_bought", false)), "measured as bought (own hip travel, no retime)")
	# 1. Every Punch PRO take on disk has a row.
	var stems: Array = FightClips.pro_stems()
	_check(stems.size() >= 140, "the Punch PRO bakes are on disk (%d)" % stems.size())
	for stem in stems:
		_check(rows.has(FightClips.pro_name(str(stem))), "a row for %s" % FightClips.pro_name(str(stem)))
	# 2. Every take the fight plays has a row, and the table's played list is today's pools'.
	var played: Array = Census.played(has)
	_check(played.size() >= 60, "the fight plays a library (%d takes)" % played.size())
	for n in played:
		_check(rows.has(n), "a row for the played take %s" % n)
	_check(played == db.get("played", []), "the played list is BeatClips' pools as they are now (re-run tools/clip_census.gd)")
	# 3. Each row's measures, and the rules' drop / flag lists.
	var may_play := {}
	for n in rows:
		var r: Dictionary = rows[n]
		for k in Census.ROW_KEYS:
			_check(r.has(k), "%s has %s" % [n, k])
		var length := float(r.get("length_s", 0.0))
		_check(length > 0.1 and length < 40.0, "%s length %.2f s" % [n, length])
		_check(float(r.get("hips_max_m", -1.0)) >= 0.0 and float(r.get("hips_max_m", 9.0)) < 2.5, "%s hips travel in range" % n)
		_check(str(r.get("kind", "")) == Census.kind(str(n)), "%s is a %s" % [n, Census.kind(str(n))])
		_check(r.get("drop", null) == Census.drop_reasons(str(n), r), "%s drop list is the rules' (re-run the census)" % n)
		_check(r.get("flags", null) == Census.flags(r), "%s flags are the rules'" % n)
		_check(bool(r.get("played", false)) == played.has(n), "%s played flag" % n)
		if str(r.get("kind", "")) == "punch":
			for k in Census.PUNCH_KEYS:
				_check(r.has(k), "%s (punch) has %s" % [n, k])
			var gap := float(r.get("contact_gap_m", 0.0))
			_check(gap > 0.30 and gap < 1.60, "%s contact gap %.2f m in 0.30-1.60" % [n, gap])
			_check(float(r.get("contact_s", -1.0)) > 0.0 and float(r.get("contact_s", 99.0)) < length, "%s contact inside the take" % n)
			_check(absf(float(r.get("miss_m", 0.0)) - Census.zone_miss(float(r.get("side_m", 0.0)), float(r.get("up_m", 0.0)),
				str(r.get("family", "")) == "body_hook" or str(n).contains("body") or str(n).contains("kidney"))) < 0.002, "%s miss is its zone miss" % n)
			if str(r.get("family", "")) != "" and (r.get("drop", []) as Array).is_empty():
				may_play[str(r["family"])] = int(may_play.get(str(r["family"]), 0)) + 1
		elif str(r.get("kind", "")) in ["reaction", "defence", "block"]:
			for k in Census.REACT_KEYS:
				_check(r.has(k), "%s (%s) has %s" % [n, r["kind"], k])
			_check(str(r.get("size", "")) == Census.react_size(float(r.get("head_peak_m", 0.0))), "%s size class" % n)
	# 4. Every punch the fight throws keeps a take that may play, and takes_for hands them nearest-gap first.
	for move in BeatClips.PUNCH:
		var fam := str(move)
		_check(int(may_play.get(fam, 0)) >= 1, "%s keeps a take that may play (%d)" % [fam, int(may_play.get(fam, 0))])
	var jabs: Array = Census.takes_for(db, "jab", 0.90)
	_check(jabs.size() >= 3, "the jab has takes to choose from (%d)" % jabs.size())
	for i in range(1, jabs.size()):
		_check(absf(float(rows[jabs[i]]["contact_gap_m"]) - 0.90) >= absf(float(rows[jabs[i - 1]]["contact_gap_m"]) - 0.90) - 1e-6,
			"takes_for sorts by distance to the gap (%s before %s)" % [jabs[i - 1], jabs[i]])
	# 5. As bought: the jab keeps its tail (the fixed/ retime is 0.84 s; the bought take 1.07 s) and its own step.
	if rows.has("pro_left_jab"):
		_check(float(rows["pro_left_jab"]["length_s"]) >= 1.0, "the jab is the bought 1.07 s take (%.2f)" % float(rows["pro_left_jab"]["length_s"]))
		_check(float(rows["pro_left_jab"]["hips_max_m"]) >= 0.08, "the jab keeps its own hip travel (%.2f m)" % float(rows["pro_left_jab"]["hips_max_m"]))
	if rows.has("pro_hit_by_gutshot_v2"):
		_check(float(rows["pro_hit_by_gutshot_v2"]["hips_max_m"]) >= 0.35, "the gut-shot stagger keeps its travel (%.2f m)" % float(rows["pro_hit_by_gutshot_v2"]["hips_max_m"]))
	# 6. The rules can read worse (mutants).
	_check(Census.zone_miss(0.0, -0.10, false) == 0.0 and Census.zone_miss(0.0, -0.40, false) > 0.2, "a glove 40 cm under the eyes is off the head")
	_check(not Census.drop_reasons("pro_x_hook", {"kind": "punch", "family": "lead_hook", "miss_m": 0.30, "up_m": -0.47}).is_empty(), "a hook 30 cm off the head is dropped")
	_check(Census.drop_reasons("pro_x_jab", {"kind": "punch", "family": "jab", "miss_m": 0.20, "up_m": -0.37}).is_empty(), "a straight 20 cm off is the arm IK's to finish")
	_check(not Census.drop_reasons("pro_hit_by_x", {"kind": "reaction", "face_up_deg": 30.0}).is_empty(), "a reaction with the face to the lights is dropped")
	_check(Census.family("pro_left_jab_hard_ft") == ["jab", "hard_ft"] and Census.family("pro_kidney_shot") == ["body_hook", "plain"]
		and Census.family("pro_hit_by_jab_v1") == ["", ""], "families and forms by name")
	_done()


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("CLIP_DB failures=%d" % failures)
	quit(1 if failures > 0 else 0)
