extends RefCounted
## Fight model step 5: rewrites a built round's beats so the fighters' habits show in the 3D ring.
## Pure static module, ZERO preloads. Never changes who lands how many (the simulation decided that),
## never moves t out of order, never touches the round's last beat or a "count".

const MAX_FIRES := 2

static func _is_punch(move: String) -> bool:
	return move != "step_in" and move != "step_out" and move != "tired" and move != "count"

static func _new_beat(who: String, move: String, result: String) -> Dictionary:
	return {"t": 0.0, "who": who, "move": move, "result": result, "caption": "",
		"big": false, "knockback": false, "def": ""}

static func _insert_after(beats: Array, idx: int, beat: Dictionary, offset: float) -> void:
	var t_new: float = float(beats[idx]["t"]) + offset
	if idx + 1 < beats.size():
		var t_next: float = float(beats[idx + 1]["t"])
		if t_new >= t_next:
			t_new = (float(beats[idx]["t"]) + t_next) * 0.5
	beat["t"] = t_new
	beats.insert(idx + 1, beat)

## Rewrites script["beats"] in place for both sides' habits and returns the list of fires [{"who","habit","t"}].
static func apply(script: Dictionary, habits: Dictionary, ctx: Dictionary, rng: RandomNumberGenerator) -> Array:
	var fires: Array = []
	var beats: Array = script["beats"]
	var n: int = int(script.get("n", 1))
	var seconds: float = float(script.get("seconds", 40.0))
	for side in ["a", "b"]:
		var other: String = "b" if side == "a" else "a"
		var sh = habits.get(side, [])
		if not (sh is Array):
			continue
		for hid in sh:
			var habit: String = str(hid)
			var fc: int = 0
			match habit:
				"drops_right_after_jab":
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != side or str(b["move"]) != "jab":
							continue
						for j in range(i + 1, beats.size() - 1):
							var nb: Dictionary = beats[j]
							if float(nb["t"]) - float(b["t"]) > 1.5:
								break
							if str(nb["who"]) == other and _is_punch(str(nb["move"])):
								nb["move"] = "lead_hook"
								nb["habit"] = habit
								fires.append({"who": side, "habit": habit, "t": float(b["t"])})
								fc += 1
								break
				"digs_body_when_hurt":
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != other or str(b["result"]) != "lands":
							continue
						for j in range(i + 1, beats.size() - 1):
							var nb: Dictionary = beats[j]
							if str(nb["who"]) == side and _is_punch(str(nb["move"])):
								nb["move"] = "body_hook"
								nb["habit"] = habit
								fires.append({"who": side, "habit": habit, "t": float(b["t"])})
								fc += 1
								break
				"loads_up_when_hurt":
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != other or str(b["result"]) != "lands":
							continue
						for j in range(i + 1, beats.size() - 1):
							var nb: Dictionary = beats[j]
							if str(nb["who"]) == side and _is_punch(str(nb["move"])):
								nb["move"] = "lead_hook"
								if str(nb["result"]) != "lands":
									nb["result"] = "misses"
									nb["def"] = ""
								nb["habit"] = habit
								fires.append({"who": side, "habit": habit, "t": float(b["t"])})
								fc += 1
								break
				"covers_up_when_hurt":
					var inserts: Array = []
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != other or str(b["result"]) != "lands":
							continue
						var nb2: Dictionary = _new_beat(side, "step_out", "none")
						nb2["habit"] = habit
						inserts.append({"after": i, "beat": nb2})
						fires.append({"who": side, "habit": habit, "t": float(b["t"])})
						fc += 1
					for k in range(inserts.size() - 1, -1, -1):
						_insert_after(beats, int(inserts[k]["after"]), inserts[k]["beat"], 0.3)
				"wide_hook_tell":
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != side or str(b["move"]) != "lead_hook" or str(b["result"]) == "lands":
							continue
						b["result"] = "blocked"
						b["def"] = "block"
						b["habit"] = habit
						fires.append({"who": side, "habit": habit, "t": float(b["t"])})
						fc += 1
				"slow_starter":
					if n != 1:
						continue
					var fq: float = seconds * 0.25
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != side or not _is_punch(str(b["move"])) or str(b["result"]) == "lands":
							continue
						if float(b["t"]) > fq:
							continue
						b["move"] = "step_out"
						b["result"] = "none"
						b["habit"] = habit
						fires.append({"who": side, "habit": habit, "t": float(b["t"])})
						fc += 1
				"fades_late":
					if n < 3:
						continue
					var lt: float = seconds * 2.0 / 3.0
					var has_t: bool = false
					for b in beats:
						if str(b["who"]) == side and str(b["move"]) == "tired" and float(b["t"]) >= lt:
							has_t = true
							break
					if has_t:
						continue
					var ia: int = -1
					for i in range(beats.size() - 1):
						if float(beats[i]["t"]) < lt:
							ia = i
					if ia < 0:
						ia = 0
					var nb3: Dictionary = _new_beat(side, "tired", "none")
					nb3["habit"] = habit
					var t_prev: float = float(beats[ia]["t"])
					var t_next: float = seconds - 0.5
					if ia + 1 < beats.size():
						t_next = float(beats[ia + 1]["t"])
					var t_new: float = lt + 0.2
					if t_new <= t_prev:
						t_new = t_prev + 0.1
					if t_new >= t_next:
						t_new = (maxf(t_prev, lt) + t_next) * 0.5
					nb3["t"] = t_new
					beats.insert(ia + 1, nb3)
					fires.append({"who": side, "habit": habit, "t": float(nb3["t"])})
					fc += 1
				"admires_her_work":
					var inserts: Array = []
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != side or str(b["move"]) != "cross" or str(b["result"]) != "lands":
							continue
						var nb4: Dictionary = _new_beat(side, "step_out", "none")
						nb4["habit"] = habit
						inserts.append({"after": i, "beat": nb4})
						fires.append({"who": side, "habit": habit, "t": float(b["t"])})
						fc += 1
					for k in range(inserts.size() - 1, -1, -1):
						_insert_after(beats, int(inserts[k]["after"]), inserts[k]["beat"], 0.3)
				"one_and_done":
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != side or not _is_punch(str(b["move"])) or str(b["result"]) != "lands":
							continue
						for j in range(i + 1, beats.size() - 1):
							var nb: Dictionary = beats[j]
							if float(nb["t"]) - float(b["t"]) > 0.5:
								break
							if str(nb["who"]) == side and _is_punch(str(nb["move"])) and str(nb["result"]) != "lands":
								nb["move"] = "step_out"
								nb["result"] = "none"
								nb["habit"] = habit
								fires.append({"who": side, "habit": habit, "t": float(b["t"])})
								fc += 1
								break
				"talks_when_ahead":
					var wl: Dictionary = ctx.get("won_last", {})
					if not bool(wl.get(side, false)):
						continue
					var nb5: Dictionary = _new_beat(side, "step_out", "none")
					nb5["habit"] = habit
					_insert_after(beats, 0, nb5, 0.3)
					fires.append({"who": side, "habit": habit, "t": float(nb5["t"])})
					fc += 1
				"lunges_with_jab":
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != side or str(b["move"]) != "jab" or str(b["result"]) == "lands":
							continue
						b["result"] = "misses"
						b["def"] = ""
						b["habit"] = habit
						fires.append({"who": side, "habit": habit, "t": float(b["t"])})
						fc += 1
				"retreats_straight_back":
					var inserts: Array = []
					for i in range(beats.size() - 1):
						if fc >= MAX_FIRES:
							break
						var b: Dictionary = beats[i]
						if str(b["who"]) != other or str(b["move"]) != "step_in":
							continue
						var nb6: Dictionary = _new_beat(side, "step_out", "none")
						nb6["habit"] = habit
						inserts.append({"after": i, "beat": nb6})
						fires.append({"who": side, "habit": habit, "t": float(b["t"])})
						fc += 1
					for k in range(inserts.size() - 1, -1, -1):
						_insert_after(beats, int(inserts[k]["after"]), inserts[k]["beat"], 0.1)
				_:
					pass
	return fires
