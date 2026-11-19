extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1): the choreographer plans one exchange of the 3D fight before it plays.
## Pure: no scene, no node. Reads clip_db.json through ClipCensus.
## The plan sees a whole 30-second exchange before it plays (scope 3b-3d, 8).

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
const React := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const Wait := preload("res://scripts/fight3d/v2/ChoreoWait.gd")
const Drift := preload("res://scripts/fight3d/v2/ChoreoDrift.gd")


## Plan one exchange. beats: time-ordered input (never mutated). db: parsed clip_db.json.
## opts: {t0, t1, gap0, seed, south: {a, b}, scale: {a, b} (each body's size against the census body, default 1)}.
static func plan(beats: Array, db: Dictionary, opts: Dictionary) -> Dictionary:
	var t0: float = float(opts.get("t0", 0.0))
	var t1: float = float(opts.get("t1", 30.0))
	var gap0: float = float(opts.get("gap0", R.REST_M))
	var south: Dictionary = opts.get("south", {"a": false, "b": false})
	var scale: Dictionary = opts.get("scale", {"a": 1.0, "b": 1.0})
	var rng := RandomNumberGenerator.new()
	rng.seed = int(opts.get("seed", 0))
	var rows: Dictionary = db.get("rows", {})
	var hfh: float = float(db.get("meta", {}).get("head_from_hips_m", 0.023))
	var out_beats: Array = []
	var ev := {"a": [], "b": []}
	var marks: Array = []
	var counts := {"a": {"thrown": 0, "landed": 0, "cut": 0}, "b": {"thrown": 0, "landed": 0, "cut": 0}}
	var log: Array = []
	var stun_until := {"a": -1.0, "b": -1.0}
	var ctrl_until := {"a": -1.0, "b": -1.0}
	var last_take := {"a": "", "b": ""}
	var last_hand := {"a": "", "b": ""}
	var prev_ct := -99.0
	var landed_at := {"a": -99.0, "b": -99.0}   # each man's own last contact as planned
	var prev_free := -99.0   # from when the feet are free to shift again: the last contact, or the end of the knock it gave
	var prev_gap := gap0
	# Punches are planned in the order they LAND (a slow body hook thrown first lands after a quick jab thrown later);
	# one boxer's own punches never overtake each other (R2). The output keeps the input's order.
	var own_ct := {"a": -99.0, "b": -99.0}
	var keys: Array = []
	for i in beats.size():
		var b0: Dictionary = beats[i]
		var k: float = float(b0.get("t", 0.0))
		if R.is_punch(str(b0.get("move", ""))):
			var w0 := str(b0.get("who", "a"))
			k = maxf(k + R.impact_s_for(str(b0.get("move", ""))), float(own_ct[w0]) + R.OWN_GAP_S)
			own_ct[w0] = k
		keys.append([k, i])
	keys.sort_custom(func(x, y): return float(x[0]) < float(y[0]) if float(x[0]) != float(y[0]) else int(x[1]) < int(y[1]))
	out_beats.resize(beats.size())
	for key in keys:
		var beat: Dictionary = beats[int(key[1])]
		var at_i: int = int(key[1])
		var who: String = str(beat.get("who", "a"))
		var other: String = "b" if who == "a" else "a"
		var move: String = str(beat.get("move", ""))
		var result: String = str(beat.get("result", ""))
		var def: String = str(beat.get("def", ""))
		var big: bool = bool(beat.get("big", false))
		var bt: float = float(beat.get("t", 0.0))
		var ob: Dictionary = beat.duplicate()
		if not R.is_punch(move):
			_non_punch(ob, move, bt, who, marks, ev[who], ctrl_until)
			out_beats[at_i] = ob
			continue
		counts[who]["thrown"] = int(counts[who]["thrown"]) + 1
		if result == "lands":
			counts[who]["landed"] = int(counts[who]["landed"]) + 1
		var base_ct: float = maxf(float(key[0]), float(landed_at[who]) + R.OWN_GAP_S)   # S531: a punch of his that slid later is still his earlier one
		var sc: float = float(scale.get(who, 1.0))
		# R3: the take. Inside a burst the pair can only shift so far before this contact; from rest any take is free
		# (the feet go to its distance, R5).
		var in_burst: bool = prev_ct > -90.0 and base_ct - prev_ct < R.BURST_GAP_S
		var room: float = R.GAP_SPEED_MPS * maxf(base_ct - Gap.LEAD_S - prev_free, 0.0) if in_burst else INF
		if base_ct - prev_ct >= Gap.POCKET_WAIT_S:
			room = INF   # the pair waited at the pocket: any take's distance is one step away
		var off: float = 0.0
		if result == "misses" and def == "":
			off = _rng_range(rng, 0.15, 0.30)   # planned SHORT: the glove stops in the air in front of him
		elif result == "blocked":
			off = _rng_range(rng, 0.10, 0.18)   # the glove meets the guard, not the face (S525: the bought guard holds the gloves a forearm out; at 0.05-0.10 a blocked uppercut put the heads 0.43 m apart)
		var pick := _pick(rows, _pool(db, rows, move, big), sc, off, prev_gap, room, str(last_take[who]), rng, move, result == "lands")
		var take_name: String = str(pick[0])
		var take_row: Dictionary = pick[1]
		var pgap: float = float(pick[2])
		var reach: float = float(pick[3])   # S525: planned this much past the take's own distance (the heads keep their floor)
		if take_name == "":
			log.append("misfit: %s %s no take" % [who, move])
			pgap = prev_gap if in_burst else R.CREEP_M
		# R9: heads apart at the contact
		var need: float = R.HEADS_APART_M + float(take_row.get("head_fwd_m", 0.0)) * sc + hfh
		need = maxf(need, R.MIN_GAP_M)
		if take_name != "" and pgap < need:
			log.append("heads: %s %s gap %.2f -> %.2f" % [who, move, pgap, need])
			pgap = need
		var dev: float = absf(pgap - (float(take_row.get("contact_gap_m", pgap)) * sc + off + reach))
		if dev > R.gap_fit_for(move) + 0.001:
			log.append("misfit: %s %s %s is %.2f m off its distance" % [who, move, take_name, dev])
		var contact_s: float = float(take_row.get("contact_s", R.impact_s_for(move)))
		var start_s: float = float(take_row.get("start_s", 0.0))
		var from_s: float = start_s
		var contact_t: float = base_ct
		# R7: a hit man does not punch
		if base_ct - (contact_s - from_s) < float(stun_until[who]):
			var min_ct: float = float(stun_until[who]) + (contact_s - from_s)
			var slide: float = min_ct - contact_t
			if slide <= R.SLIDE_MAX_S:
				contact_t = min_ct
				log.append("slide: %s %s +%.2f (stun)" % [who, move, slide])
			elif result != "lands":
				counts[who]["cut"] = int(counts[who]["cut"]) + 1
				counts[who]["thrown"] = int(counts[who]["thrown"]) - 1
				log.append("cut: %s %s (stun)" % [who, move])
				_fill_ob(ob, bt, "", 0.0, base_ct, prev_gap, 0.0, true, "", "", "", "cut:stun")
				out_beats[at_i] = ob
				continue
			else:
				contact_t = base_ct + R.SLIDE_MAX_S
				log.append("overlap: %s %s landed in stun" % [who, move])
		contact_t = clampf(contact_t, t0, t1)
		# R2: when the take starts; a combination's next punch starts part-way in while the last hand comes home
		var t_play: float = contact_t - (contact_s - from_s)
		if t_play < float(landed_at[who]) + R.CONTROL_S and take_name != "" and str(take_row.get("hand", "?")) == str(last_hand[who]):
			# S531 THE SAME HAND TWICE (film 7, def3 #13-#27, read as "a cross that hangs 14 frames": a double jab whose second
			# take was cut in 0.11 s deep while the arm was still out - one arm out for 0.4 s). The same hand again plays its
			# take from the START once the first has landed: the arm comes home in the join, and the punch lands that much later.
			contact_t = minf(maxf(contact_t, float(landed_at[who]) + R.CONTROL_S + R.SAME_HAND_S + (contact_s - start_s)), t1)
			t_play = contact_t - (contact_s - start_s)
			log.append("same hand: %s %s +%.2f (lands later, from its start)" % [who, move, contact_t - base_ct])
		elif t_play < float(ctrl_until[who]):
			from_s = clampf(from_s + (float(ctrl_until[who]) - t_play), start_s, maxf(start_s, contact_s - (R.WIND_MIN_S if R.is_straight(move) else clampf(contact_t - float(landed_at[who]) - 0.03, R.WIND_MIN_S, R.WIND_TURN_S))))   # never from before his own last punch has landed
			# S530 (the S529 bout: a hard cross second in a combination, started 0.26 s into its take, threw his own head
			# 16 cm in a picture): ... and never so deep that the join throws his head. He starts when his hand is back, as
			# before, from earlier in the take, and the punch lands that much later (CUT_SLIDE_S at most). The bar is
			# tighter than a reaction's: he comes out of his last punch, not out of the guard the curve is read from.
			var pcurve: Array = take_row.get("head_g", [])
			var phz: float = float((db.get("meta", {}) as Dictionary).get("curve_hz", 30.0))
			var slid := 0.0
			while not pcurve.is_empty() and from_s > start_s + 0.001 and slid < R.CUT_SLIDE_S and contact_t + 1.0 / 60.0 <= t1 and React.worst_step(pcurve, from_s, R.JOIN_WAY["punch"], phz, take_row.get("hips_g", [])) * sc > R.CUT_STEP_MAX_M:
				var back: float = minf(1.0 / 60.0, from_s - start_s)
				from_s -= back
				contact_t += back
				slid += back
			if slid > 0.0:
				log.append("ease: %s %s +%.2f (lands later, starts %.2f into the take)" % [who, move, slid, from_s])
			t_play = contact_t - (contact_s - from_s)
		var ik_m: float = minf((dev if R.is_straight(move) else 0.0) + (reach if result == "lands" else 0.0), R.IK_MAX_M)
		# S529: a landed cross, hook or uppercut moves the man it hit (ChoreoGap.HURT_OUT_M: HE takes the step back)
		marks.append({"t": contact_t, "gap": pgap, "who": who, "kind": "contact", "hurt": other if result == "lands" and not (move in ["jab", "body_hook"]) else ""})
		ev[who].append({"t": t_play, "clip": take_name, "kind": "punch", "part": "whole", "from_s": from_s,
			"join_s": R.join_for("punch"), "control_t": contact_t + R.CONTROL_S, "contact_t": contact_t, "move": move,
			"until_s": contact_s + R.arm_home_s(move) + 0.25,   # his hand is home (Player2 hands the take back to the guard): a wait thing may start
			"result": result, "big": big, "ik_m": ik_m})
		ctrl_until[who] = contact_t + R.CONTROL_S
		prev_ct = contact_t
		prev_free = contact_t
		landed_at[who] = contact_t
		prev_gap = pgap
		# R6 / R8: what the other man does with it. It CUTS what he was doing (a hit interrupts).
		var react_name := ""
		var react_part := ""
		var defence_name := ""
		if result == "lands":
			var ri := React.react(db, rows, move, big, R.is_left_hand(move), rng, hfh, log, float(scale.get(other, 1.0)))
			react_name = str(ri[0])
			var rrow: Dictionary = ri[1]
			# S525: every reaction plays with its take's own travel (a small one was pinned "upper": its feet stepped
			# under held hips, and the 4-9 cm the take gives never showed); only a big one moves the distance plan.
			var gives: bool = str(ri[2]) == "whole"
			react_part = "whole"
			var rt: float = contact_t
			# S526: a reaction starts so the head's FIRST peak against his own body (clip_db head_rel_s) is on the
			# blow. It used to start at the head's furthest point WITH the body's travel: on a gut shot that is the end
			# of the stagger, 0.5-0.8 s after the fold, so a man hit to the ribs stood tall (8.9 cm measured, the take
			# folds 27-35); on a combination take it is the third hit, and the first snap never played. A head
			# reaction hands back to the guard REACT_TAIL_S later (a combination take went on reacting to punches
			# nobody threw); a body shot's plays its stagger out.
			var r_peak: float = float(rrow.get("head_peak_s", 0.0))
			var r_at: float = minf(r_peak, float(rrow.get("head_rel_s", r_peak)))
			# S530: ... as late as keeps the head's step under the bar in every picture (ChoreoReact.start_s)
			var r_start: Array = React.start_s(rrow, move, float((db.get("meta", {}) as Dictionary).get("curve_hz", 30.0)), float(scale.get(other, 1.0)))
			var r_from: float = float(r_start[0])
			var r_until: float = minf(r_peak + 0.15, r_at + R.REACT_STAGGER_S) if move == "body_hook" else r_at + R.REACT_TAIL_S
			r_until = minf(r_until, float(rrow.get("length_s", r_until)))
			ev[other].append({"t": rt, "clip": react_name, "kind": "reaction", "part": "?", "from_s": r_from,
				"until_s": r_until, "soft": bool(r_start[1]),
				"join_s": R.join_for("reaction"), "control_t": rt + R.stun_for(str(ri[3])), "size": str(ri[3]), "move": move})
			ctrl_until[other] = maxf(float(ctrl_until[other]), rt + R.stun_for(str(ri[3])))
			stun_until[other] = maxf(float(stun_until[other]), contact_t + R.stun_for(str(ri[3])))
			# He gives ground whenever the next punch can follow him there (S525: was "only on the last punch of a
			# combination", so most reactions inside a burst were pinned and a cross moved nobody): a follow-up due
			# inside KNOCK_FREE_S keeps him on the spot only when the feet could not cover his travel in that time.
			var give_m: float = float(rrow.get("hips_max_m", 0.0)) * float(scale.get(other, 1.0))
			var give_s: float = maxf(maxf(0.18, give_m / 2.0), r_peak - maxf(r_at - R.react_peak_s(move), 0.0) - R.react_peak_s(move))   # how long the knock takes (Player2.LEAD_MPS; a gut shot's stagger takes its own time)
			var k_at: int = keys.find(key)
			for kk in range(k_at + 1, keys.size()):
				var nb: Dictionary = beats[int(keys[kk][1])]
				if R.is_punch(str(nb.get("move", ""))):
					var due: float = float(keys[kk][0]) - contact_t
					if gives and due < R.KNOCK_FREE_S and due - Gap.LEAD_S - give_s < 0.15:
						react_part = "upper"
					break
			(ev[other][-1] as Dictionary)["part"] = react_part
			if react_part == "whole" and gives and r_peak <= r_until + 0.05:   # the take's travel plays out before it hands back
				var travel: float = float(rrow.get("hips_max_m", 0.0)) * float(scale.get(other, 1.0))
				marks.append({"t": contact_t + give_s, "gap": pgap + travel, "who": other, "kind": "knock"})   # S525: he gives the ground on the blow (Player2 lead), was +0.3
				prev_gap = pgap + travel
				prev_free = contact_t + give_s
		elif result == "blocked":
			var bi := React.block(db, rows)
			defence_name = str(bi[0])
			ev[other].append({"t": contact_t, "clip": defence_name, "kind": "block", "part": "upper", "from_s": 0.0,
				"join_s": R.join_for("block"), "control_t": contact_t + minf(float((bi[1] as Dictionary).get("back_s", 0.4)), 0.4)})
			ctrl_until[other] = maxf(float(ctrl_until[other]), contact_t + 0.2)
		# S531 A MISS IS MADE BY THE OTHER MAN (film 7, the animator: "hits with no visible answer" - the ruler finds none
		# among the landed punches: what he saw are punches thrown short at a man who does not move). Most of the time the
		# man it was thrown at, when nothing holds him, pulls back from a straight or goes under a hook.
		# Never inside a combination: the next punch would be planned at a man who has just left (the first bout with it:
		# a cross cut in behind a pulled-from kidney shot was dragged 10 cm in a picture, its head 20).
		if result == "misses" and def == "" and at_i % 5 < 3 and contact_t - R.DEF_LEAD_S >= float(ctrl_until[other]) and contact_t >= float(stun_until[other]):
			var alone := true
			for kk in range(keys.find(key) + 1, keys.size()):
				if R.is_punch(str((beats[int(keys[kk][1])] as Dictionary).get("move", ""))):
					alone = float(keys[kk][0]) - contact_t > R.PULL_ALONE_S
					break
			if alone:
				def = "pull" if R.is_straight(move) else "weave"
		if result != "lands" and result != "blocked" and def != "" and def != "block":
			var di := React.defence(db, rows, def, move, R.is_left_hand(move), bool(south.get(other, false)))
			# S530: the quick weave moves late in its take (its head goes in the last 0.2 s before the peak): a man still
			# held by a take of his own would join it at that point - 18 cm of head in a picture. He takes the side weave.
			if str(di[0]) == R.WEAVE_STRAIGHT and contact_t - minf(float((di[1] as Dictionary).get("head_peak_s", 0.3)), R.DEF_LEAD_S) < float(ctrl_until[other]):
				di = React.defence(db, rows, def, move, R.is_left_hand(move), bool(south.get(other, false)), false)
			defence_name = str(di[0])
			if defence_name != "":
				var drow: Dictionary = di[1]
				var peak_s: float = float(drow.get("head_peak_s", 0.3))
				var lead_in: float = minf(peak_s, R.DEF_LEAD_S)
				var dt: float = contact_t - lead_in
				# S525: while a take of his own still has him (a punch planned earlier in the burst) the defence waits and
				# starts part-way in, so its head is still off the line on time (it used to start on schedule and be cut).
				var d_from := peak_s - lead_in
				if dt < float(ctrl_until[other]):
					d_from = clampf(d_from + float(ctrl_until[other]) - dt, 0.0, maxf(peak_s - 0.12, 0.0))
					dt = contact_t - (peak_s - d_from)
				else:
					# S530 (the S529 bout: a weave started 0.10 s into its take moved the head 13-14 cm in a picture, the take by
					# itself 6): where nothing holds him he starts the take earlier - up to DEF_EARLY_S sooner - until no picture's
					# head step is over the bar. He reads the punch a little sooner; the take is the bought one.
					var dcurve: Array = drow.get("head_g", [])
					var dhz: float = float((db.get("meta", {}) as Dictionary).get("curve_hz", 30.0))
					var early := 0.0
					while not dcurve.is_empty() and d_from > 0.0 and early < R.DEF_EARLY_S and dt - 1.0 / 60.0 >= float(ctrl_until[other]) and React.worst_step(dcurve, d_from, R.JOIN_WAY["defence"], dhz) * float(scale.get(other, 1.0)) > R.HEAD_STEP_MAX_M:
						var cut: float = minf(1.0 / 60.0, d_from)
						d_from -= cut
						dt -= cut
						early += cut
				ev[other].append({"t": dt, "clip": defence_name, "kind": "defence", "part": "whole", "from_s": d_from,
					"join_s": R.join_for("defence"), "control_t": contact_t + float(drow.get("back_s", 0.4))})
				if float(drow.get("hips_max_m", 0.0)) < R.WHOLE_BODY_HIPS_M:   # S530: one that does not step comes up at once (DEF_UP_S)
					(ev[other][-1] as Dictionary)["until_s"] = peak_s + R.DEF_UP_S
					(ev[other][-1] as Dictionary)["control_t"] = contact_t + minf(float(drow.get("back_s", 0.4)), R.DEF_UP_S + 0.25)
				ctrl_until[other] = maxf(float(ctrl_until[other]), contact_t + 0.15)
				# S525 (the worst head jump of three films, 25 cm in a frame: a jab thrown 0.07 s after the hook he had
				# weaved under, started 0.12 s before its own contact from the bottom of the weave): he comes up before
				# he counters. Like a stun: his next punch slides, or is cut when it was not going to land.
				stun_until[other] = maxf(float(stun_until[other]), contact_t + clampf(float(drow.get("back_s", peak_s + 0.2)) - peak_s, 0.12, 0.30))
		last_take[who] = take_name
		last_hand[who] = str(take_row.get("hand", ""))
		_fill_ob(ob, t_play, take_name, from_s, contact_t, pgap, ik_m, false, react_name, react_part, defence_name, _why(result, def, take_name))
		out_beats[at_i] = ob
	marks.sort_custom(func(x, y): return float(x["t"]) < float(y["t"]))
	var gap: Array = Gap.build(marks, t0, t1, gap0, log)
	var drng := RandomNumberGenerator.new()
	drng.seed = int(opts.get("seed", 0)) * 7919 + 13
	if bool(opts.get("waits", true)) and bool(opts.get("drift", true)) and bool(opts.get("inout", true)):
		gap = Drift.inout(gap, t0, t1, drng)   # S531: between exchanges a man steps in to the jab's edge and out again
	# R5: every stretch of ground a viewer can count is a step event of the man who covers it
	for s in Gap.steps(gap):
		for w in (["a", "b"] if str(s["who"]) == "both" else [str(s["who"])]):
			ev[w].append({"t": float(s["t"]), "clip": "", "kind": "step", "part": "legs", "from_s": 0.0, "join_s": 0.0,
				"control_t": float(s["t"]), "end_t": float(s["end_t"]), "m": float(s["m"]), "share": 0.5 if str(s["who"]) == "both" else 1.0})
	_add_pivots(ev["a"], ev["b"], gap, t0, t1, rng, ctrl_until)
	# S525 the waits, drawn last (the punches' own draws stay what they were): fidgets, paws and feints on each man's
	# own clock, and a distance at rest that is never a still line. `waits: false` = the plan without them.
	if bool(opts.get("waits", true)):
		# S528 ring steps (ChoreoDrift): between exchanges the pair moves, on its own draws (the punches' and the
		# waits' own stay what they were where no ring step is). `drift: false` = the plan without them.
		if bool(opts.get("drift", true)):
			counts["ring_steps"] = Drift.plan(ev, gap, db, t0, t1, drng)
		Wait.add(ev, db, t0, t1, marks.filter(func(m): return str(m.get("kind", "contact")) == "contact").map(func(m): return float(m["t"])), rng)
		gap = Wait.breathe(gap, rng)
	for w in ["a", "b"]:
		_order(ev[w])
	return {"beats": out_beats, "tracks": ev, "gap": gap, "counts": counts, "log": log}


# --- Helpers ---

## Time order; a later event takes control from the one before it (R10: a hit cuts a punch, a punch cuts a guard).
static func _order(evs: Array) -> void:
	var rank := {"step": 0, "pivot": 0, "fidget": 0, "feint": 0, "pass": 1, "punch": 2, "defence": 3, "block": 4, "reaction": 5}
	evs.sort_custom(func(x, y):
		if absf(float(x["t"]) - float(y["t"])) > 0.0005:
			return float(x["t"]) < float(y["t"])
		return int(rank.get(str(x["kind"]), 1)) < int(rank.get(str(y["kind"]), 1)))
	for i in range(1, evs.size()):
		if float(evs[i]["t"]) < float(evs[i - 1]["control_t"]):
			evs[i - 1]["control_t"] = float(evs[i]["t"])


static func _non_punch(ob: Dictionary, move: String, bt: float, who: String, marks: Array, evs: Array, ctrl_until: Dictionary) -> void:
	if move == "step_in" or move == "step_out":
		marks.append({"t": bt, "gap": R.CREEP_M if move == "step_in" else R.REST_M, "who": who, "kind": move})
	if move in R.PASS_MOVES:
		var pass_t: float = maxf(bt, float(ctrl_until[who]))
		evs.append({"t": pass_t, "clip": "", "kind": "pass", "part": "whole", "from_s": 0.0, "join_s": 0.0, "control_t": pass_t, "move": move})
		ctrl_until[who] = pass_t
	_fill_ob(ob, bt, "", 0.0, bt, 0.0, 0.0, false, "", "", "", move)


static func _fill_ob(ob: Dictionary, t_play: float, take: String, from_s: float, contact_t: float, gap: float, ik_m: float, cut: bool, react: String, react_part: String, defence: String, why: String) -> void:
	ob["t_play"] = t_play
	ob["take"] = take
	ob["from_s"] = from_s
	ob["contact_t"] = contact_t
	ob["gap"] = gap
	ob["ik_m"] = ik_m
	ob["cut"] = cut
	ob["react"] = react
	ob["react_part"] = react_part
	ob["defence"] = defence
	ob["why"] = why


static func _why(result: String, def: String, take: String) -> String:
	if result == "lands":
		return "lands %s" % take
	if result == "blocked":
		return "blocked %s" % take
	if def != "":
		return "%s %s" % [def, take]
	return "%s %s" % [result, take]


static func _rng_range(rng: RandomNumberGenerator, lo: float, hi: float) -> float:
	return lo + (hi - lo) * rng.randf()


## The takes a punch may use: its family, not dropped; the hard takes for a big shot; a hurt take only when nothing
## else is owned.
static func _pool(db: Dictionary, rows: Dictionary, move: String, big: bool) -> Array:
	var all: Array = ClipCensus.takes_for(db, move, 0.9)
	var pro: Array = all.filter(func(n): return str(n).begins_with("pro_"))   # one actor, one stance: the Punch PRO takes first
	if not pro.is_empty():
		all = pro
	var fresh: Array = all.filter(func(n): return not str(rows[n].get("form", "")).begins_with("hurt"))
	if not fresh.is_empty():
		all = fresh
	# S525 (third film, both critics: "blue spins in 1-3 frames and shows his back", ex5 = pro_left_hook_ft): a take the
	# census flags "back to the other man" (the pelvis turns 100 deg or more) plays only when its family owns no other.
	var front: Array = all.filter(func(n): return not (rows[n].get("flags", []) as Array).any(func(f): return str(f).begins_with("back to the other man")))
	if not front.is_empty():
		all = front
	if big:
		var hard: Array = all.filter(func(n): return str(rows[n].get("form", "")) in ["hard", "hard_ft", "special"])
		if not hard.is_empty():
			all = hard
	all.sort()
	return all


## [take, row, planned gap, reach]. The take's own distance (x the body's size, + `off` for a miss or a block, + the
## REACH that keeps the heads apart, S525) is where the plan goes when it can get there: within `room` of `prev_gap`
## (INF from rest). A SHORT take (the heads under their floor even at full reach) is passed over while the family owns
## a longer one. Among the takes that can be reached the one last thrown is passed over when another fits (variety,
## R3); among takes that cannot, the nearest.
static func _pick(rows: Dictionary, pool: Array, sc: float, off: float, prev_gap: float, room: float, last: String, rng: RandomNumberGenerator, move: String = "jab", lands: bool = false) -> Array:
	if pool.is_empty():
		return ["", {}, prev_gap, 0.0]
	if lands:
		var long: Array = pool.filter(func(n): return not R.is_short(move, float(rows[n].get("contact_gap_m", 0.9)) * sc, float(rows[n].get("head_fwd_m", 0.0)) * sc))
		if not long.is_empty():
			pool = long
	var fits: Array = []
	var best := ""
	var best_dev := INF
	var best_gap := prev_gap
	var best_reach := 0.0
	for n in pool:
		var own: float = float(rows[n].get("contact_gap_m", 0.9)) * sc + off
		var reach: float = R.head_extra(move, own, float(rows[n].get("head_fwd_m", 0.0)) * sc, lands)
		var want: float = own + reach
		var got: float = want if room == INF else clampf(want, prev_gap - room, prev_gap + room)
		var dev := absf(got - want)
		if dev <= 0.03:
			fits.append([n, got, reach])
		if dev < best_dev - 0.0001:
			best_dev = dev
			best = str(n)
			best_gap = got
			best_reach = reach
	if fits.is_empty():
		return [best, rows[best], best_gap, best_reach]
	var fresh: Array = fits.filter(func(f): return str(f[0]) != last)
	if not fresh.is_empty():
		fits = fresh
	var f: Array = fits[rng.randi() % fits.size()]
	return [str(f[0]), rows[str(f[0])], float(f[1]), float(f[2])]


static func _add_pivots(ev_a: Array, ev_b: Array, anc: Array, t0: float, t1: float, rng: RandomNumberGenerator, ctrl_until: Dictionary) -> void:
	# Find quiet spells and add pivot events
	var contacts: Array = []
	for a in anc:
		if str(a[2]) != "":
			contacts.append(float(a[0]))
	contacts.sort()
	var windows: Array = []
	if contacts.is_empty():
		windows.append([t0, t1])
	else:
		if float(contacts[0]) - t0 >= R.QUIET_MIN_S:
			windows.append([t0, float(contacts[0])])
		for i in range(1, contacts.size()):
			var dt: float = float(contacts[i]) - float(contacts[i - 1])
			if dt >= R.QUIET_MIN_S:
				windows.append([float(contacts[i - 1]), float(contacts[i])])
		if t1 - float(contacts[-1]) >= R.QUIET_MIN_S:
			windows.append([float(contacts[-1]), t1])
	# Add pivots every PIVOT_EVERY_S
	var need_pivot_at: float = t0 + R.PIVOT_EVERY_S
	for w in windows:
		var ws: float = float(w[0])
		var we: float = float(w[1])
		while need_pivot_at < we:
			if need_pivot_at > ws + 0.2:
				var who: String = "a" if rng.randf() < 0.5 else "b"
				var evs := ev_a if who == "a" else ev_b
				var pivot_t: float = maxf(need_pivot_at, float(ctrl_until[who]))
				evs.append({"t": pivot_t, "clip": "", "kind": "pivot", "part": "whole", "from_s": 0.0, "join_s": 0.0, "control_t": pivot_t + 0.5})
				ctrl_until[who] = pivot_t + 0.5
			need_pivot_at += R.PIVOT_EVERY_S
