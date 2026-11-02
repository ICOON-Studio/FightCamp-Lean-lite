extends RefCounted
## Who appears in the 3D ring (split from FightView.gd S307, 500-line rule): the two boxers' bodies and sizes, the corner
## teams (CornerCrew), and the corner minute between rounds (CornerMinute, docs/FIGHT_NIGHT_SCRIPT.md v2).
##   bodies_for(f, opp)  body_scales(f, opp)  crew(stage, pro)  intro(view) -> bool  corner(view) -> bool

const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const Referee := preload("res://scripts/fight3d/Referee.gd")
const CornerMinute := preload("res://scripts/fight3d/CornerMinute.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const TaleOfTape := preload("res://scripts/rules/TaleOfTape.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const CallEvidence := preload("res://scripts/rules/CallEvidence.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"

const Faces := preload("res://scripts/rules/Faces.gd")


## S332: each boxer's own body (Faces; was one of 3 by weight class, so every opponent wore one face).
static func bodies_for(f: Dictionary, opp: Dictionary) -> Array:
	var p := Faces.pair(f, opp)
	return [Faces.glb(p[0]), Faces.glb(p[1])]


## S300 (operator: "the one fighter look enormous" - a lightweight drawn on the 178 cm middleweight body): each body is
## scaled to her height (her own, else her body's), a uniform scale also scales the build (178 cm / 70 kg at 165 cm
## reads ~57 kg). Kept within 0.88-1.12 so no body is stretched past believable.
static func body_scales(f: Dictionary, opp: Dictionary) -> Array:
	var p := Faces.pair(f, opp)
	var out := []
	for i in 2:
		var cm := float(([f, opp][i] as Dictionary).get("height", 0.0))
		out.append(clampf((cm if cm > 0.0 else Faces.cm(p[i])) / Faces.cm(p[i]), 0.88, 1.12))
	return out


## The corner teams, hidden until the first bell (built with the fight, so the bell never waits on loading).
static func crew(stage: Node3D, pro: bool) -> Node3D:
	var c := CornerCrew.new()
	stage.add_child(c)
	c.build(stage, pro)
	Referee.build(stage)   # S313: the third man in the ring (parts the clinches)
	return c


## After a round that does not end the bout: the corner minute plays and the view's corner_done(pick) starts the next
## round. False when there is no corner (the last round, a stoppage, no crew).
static func corner(view: Node) -> bool:
	if view.crew == null or str(view._stop) != "" or int(view.round_n) >= int(view.total):
		return false
	var m: Dictionary = view.main.modal
	var r: Dictionary = (m["rounds"] as Array)[int(view.round_n) - 1]
	var f: Dictionary = view.main.career.fighter_by_id(str(view.fid))
	var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
	var en: Dictionary = r.get("energy", {})
	var card := CornerCard.card(r.get("card", CornerCard.summarize([])), float(en.get("a_end", 100.0)), names)
	# S308: the coach's call reads the round's exchanges (the game the opponent ended it on).
	if r.has("exchanges"):
		card.merge(Exchanges.read(r["exchanges"], names), true)
	var vals := LiveRound.values(f)
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = Exchanges.grade(str(k), vals)["word"]
	card["grades"] = grades
	card["fixes"] = LiveRound.fixes(f, r)   # S309: one habit the corner can fix
	card["fixed"] = HabitFix.result(LiveRound.habit_name(str(r["fix"])) if str(r.get("fix", "")) != "" else "",
		int(r.get("fix_came", 0)), float(r.get("fix_hold", 0.0)), names[0])   # S320: what last round's fix did
	card["jobs_menu"] = CornerJobsRow.menu(f, r)   # S310: recover, set-up, talk
	# S354 C205 ("player needs to see some stats to take decisions"): the round in numbers at the top of the card.
	var done: Array = (m["rounds"] as Array).slice(0, int(view.round_n))
	var won_a := done.filter(func(x): return bool((x as Dictionary).get("won", false))).size()
	card["stats"] = {"round": int(view.round_n), "won": bool(r.get("won", false)), "score": [won_a, done.size() - won_a],
		"counts": int(r.get("counts", 0)), "tally": BodyMap.tally(view._round_beats),
		"energy": {"a": float(en.get("a_end", 100.0)), "b": float(en.get("b_end", 100.0))}}
	# S318 the body map on the card (plan Q-S294-29): her figure + the cutman's job, and the number behind each call.
	var bl: Node = view.get("body")
	if bl != null:
		card["body_map"] = bl.map
		card["body_glb"] = str(view.bodies[0])   # S320 her own body on the card (C146)
		card["stats"]["map"] = bl.map
		# S323 playtest: the pit stop shows the tyres - her body track on the card.
		if view.get("burn") != null:
			card["body_track"] = view.burn.track(0)
		var fires := []
		for b in view._round_beats:
			if (b as Dictionary).has("habit"):
				fires.append({"who": str(b["who"]), "habit": str(b["habit"]), "t": float(b["t"])})
		card["evidence"] = CallEvidence.lines(bl.map, BodyMap.tally(view._round_beats), fires,
			{"a": float(en.get("a_end", 100.0)), "b": float(en.get("b_end", 100.0))}, names, _habit_words())
	view.hide_hud()
	Engine.time_scale = view.pace()
	var cm := CornerMinute.new()
	view.add_child(cm)
	cm.done.connect(view.corner_done)
	cm.run(view, view.stage, view.crew, {"round": int(view.round_n), "card": card, "won": bool(r.get("won", false)),
		"pro": (view.crew.actors as Dictionary).has("cutman"), "names": names})
	return true


## Kalli's habit names (fight_habits.json), lower case, for "Maria drops the right after the jab: 2 times".
static func _habit_words() -> Dictionary:
	var out := {}
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH)) if FileAccess.file_exists(HABITS_PATH) else null
	for row in (data as Dictionary).get("habits", []) if data is Dictionary else []:
		out[str(row.get("id", ""))] = str(row.get("name", "")).to_lower()
	return out


## Before round 1, once a fight: the intro (FightIntro). True while it plays; at its bell round 1 runs.
static func intro(view: Node) -> bool:
	if view.crew == null or view.has_meta("intro_seen"):
		return false
	view.set_meta("intro_seen", true)
	var c: Career = view.main.career
	var f: Dictionary = c.fighter_by_id(str(view.fid))
	var opp: Dictionary = f["bout"]["opp"]
	var intros := ["In the red corner, from %s, %d and %d: %s" % [c.gym_name, int(f["w"]), int(f["l"]), str(f["name"]).to_upper()],
		"In the blue corner, from %s, %d and %d: %s" % [str(opp["club"]), int(opp["w"]), int(opp["l"]), str(opp["name"]).to_upper()]]
	view.hide_hud()
	var fi := FightIntro.new()
	view.add_child(fi)
	fi.done.connect(_intro_over.bind(view))
	# S310 the tale of the tape: her height is the body the ring draws her with until she has her own.
	var tape := TaleOfTape.rows(f, opp, c.gym_name, Faces.cm(Faces.stem(f)))
	fi.run(view, view.stage, view.crew, {"intros": intros, "tape": tape, "names": [str(f["name"]), str(opp["name"])]})
	return true


static func _intro_over(view: Node) -> void:
	view.playing = true
	view.t = 0.0
	# S308: round 1 opened on the intro's last (wide) shot; hand the ring back to the broadcast camera.
	view.stage.broadcast(true)
	Engine.time_scale = view.pace()
	view._bug_box.visible = true
	view._banner.text = "ROUND 1"
	view._draw_buttons()
	view._hud()
