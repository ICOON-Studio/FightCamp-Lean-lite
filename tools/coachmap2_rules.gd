extends RefCounted
## COACHMAP2 (S551, ops/research/TASK_COACHMAP2.md; rules written before any run in ops/research/DESIGN_COACHMAP2.md).
## Probe only; nothing under scripts/ reads this. Change 1 (the corner coach wired) on CORNERBASE1's real bout
## (tools/cornerbase1_probe.gd bout(), copied here with four hooks), the roster draws of change 3, the limit of change 2.
## Off = CORNERBASE1's reader_nr / file arms bout for bout (the control).
const T := preload("res://tools/tellplay1_rules.gd")
const R := preload("res://tools/cornercmd2_rules.gd")
const C := preload("res://tools/cornerbase1_rules.gd")
const D9 := preload("res://tools/coachdeep9_rules.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

## ---- change 1 (design s2) ----
const CLUE_A := 0.4          ## clue right = 0.4 + 0.03 x tactics (20 -> 1.0)
const CLUE_B := 0.03
const LISTEN := 0.4          ## heard x (1 + 0.4 x chemistry)
const WARN_HEAR := 0.15      ## a warned boxer hears 15% less
const COACHES := ["YOU", "REID", "L", "M", "S", "F", "K"]
const CHEM := {"": 0.0, "b": 0.5, "x": -0.5, "w": 0.0}

static func clue_q(tac: float, s: float) -> float:
	return 1.0 - s * (1.0 - clampf(CLUE_A + CLUE_B * tac, 0.0, 1.0))

static func rec_points(cut: float, s: float) -> int:
	var n := 1 if cut < 8.0 else (2 if cut < 14.0 else 3)
	return int(floor(float(n) * s))

## The arm's coach context. arm: reader | file | live:<C>[:b|:x|:w] | liveh:<C>[...] | sim:<C> | simh:<C>
static func ctx_of(arm: String) -> Dictionary:
	var p := arm.split(":")
	var kind := str(p[0])
	if kind in ["reader", "file"]:
		return {"kind": kind, "s": 0.0}
	var cid := str(p[1])
	var tag := str(p[2]) if p.size() > 2 else ""
	var c := D9.coach(cid)
	var s := 0.5 if kind.ends_with("h") else 1.0
	return {"kind": kind.trim_suffix("h"), "s": s, "cid": cid, "tac": float(c["tactics"]), "cut": float(c["cutman"]),
		"cond": float(c["conditioning"]), "chem": float(CHEM[tag]), "warned": tag == "w", "clash": D9.word(float(CHEM[tag])) == "clash"}

## The heard multiplier of change 1 (b) (without the clash round).
static func hear_mult(cx: Dictionary) -> float:
	var s := float(cx["s"])
	return (1.0 + s * LISTEN * float(cx["chem"])) * ((1.0 - s * WARN_HEAR) if bool(cx["warned"]) else 1.0)

## A wrong clue: another game of the opponent's style by STYLE_MODES weights (CORNERBASE1's misread).
static func wrong_mode(style: String, true_mode: String, u: float) -> String:
	var mix: Dictionary = Exchanges.STYLE_MODES.get(style, Exchanges.STYLE_MODES["Boxer-puncher"])
	var tot := 0.0
	for x in mix:
		if str(x) != true_mode: tot += float(mix[x])
	var roll := u * tot
	var out := true_mode
	for x in mix:
		if str(x) == true_mode: continue
		out = str(x)
		roll -= float(mix[x])
		if roll <= 0.0: break
	return out

## The corner string's recover points (design s2 (c)): head first if hurt at the bell, the rest on water.
static func rec_job(cx: Dictionary, m: Dictionary) -> String:
	if not (str(cx.get("kind", "")) in ["live", "sim"]): return ""
	var n := rec_points(float(cx["cut"]), float(cx["s"]))
	if n <= 0: return ""
	var rounds: Array = m.get("rounds", [])
	var hurt := bool((rounds[-1] as Dictionary).get("hurt_at_bell", false)) if not rounds.is_empty() else false
	return "|rec=head:1,water:%d" % (n - 1) if hurt else "|rec=water:%d" % n

## The simmed coach's call (design s2 (d)): FILE, the two jobs done with chance by rating.
static func sim_corner(cs: Dictionary, cx: Dictionary, f: Dictionary, m: Dictionary, rng: RandomNumberGenerator) -> String:
	var s := float(cx["s"])
	var rounds: Array = m.get("rounds", [])
	var last: Dictionary = rounds[-1] if not rounds.is_empty() else {}
	cs["corners"] = int(cs["corners"]) + 1
	var u1 := rng.randf(); var u2 := rng.randf()
	if C.hurt_in(last) and u1 < 1.0 - s * (1.0 - float(cx["cut"]) / 20.0):
		cs["hands"] = int(cs["hands"]) + 1
		return str(R.CMD["hands"]["call"])
	if float((last.get("energy", {}) as Dictionary).get("a_end", 100.0)) < C.WIND_LINE and u2 < 1.0 - s * (1.0 - float(cx["cond"]) / 20.0):
		cs["rests"] = int(cs["rests"]) + 1
		return str(R.CMD["reset"]["call"])
	return str(cs["open"])

## CORNERBASE1's population (its _initialize, copied): [types, ours, coach].
static func population() -> Array:
	var built := T.build_types(4)
	var types: Array = built[0]
	var coach := float(built[1])
	var ours: Array = []
	for i in types.size():
		if str(types[i]["sex"]) != "f": continue
		if ours.is_empty() or (ours.size() == 1 and str(types[i]["style"]) != str(types[ours[0]]["style"])): ours.append(i)
	var best_i := -1; var best_d := -1
	var g0 := [R.trained_cmd(types[ours[0]]["f"]), R.trained_cmd(types[ours[1]]["f"])]
	for i in types.size():
		if str(types[i]["sex"]) != "f" or ours.has(i): continue
		var gi := R.trained_cmd(types[i]["f"])
		var dd := 0
		if str(R.new_state("plan", 3, coach, types[i]["f"])["own"]) != str(R.new_state("plan", 3, coach, types[ours[0]]["f"])["own"]): dd += 20
		if not [str(types[ours[0]]["style"]), str(types[ours[1]]["style"])].has(str(types[i]["style"])): dd += 10
		for k in gi: dd += (1 if gi[k] != g0[0][k] else 0) + (1 if gi[k] != g0[1][k] else 0)
		if dd > best_d:
			best_d = dd; best_i = i
	if best_i >= 0: ours.append(best_i)
	C.DRAWS = 300
	C.PICK = [49, 1249]
	var taken: Array = ours.map(func(i): return str(types[i]["name"]))
	for t in C.build_extra(taken, 80):
		types.append(t); ours.append(types.size() - 1)
	return [types, ours, coach]

static func opp_of(types: Array, ti: int, cl: Dictionary) -> Dictionary:
	var f: Dictionary = types[ti]["f"]
	var opp := DebutOpp.make(f, 0.0, 0, "cc1")
	opp.merge({"name": "Opp %s" % str(cl["id"]), "first": "Opp", "style": str(cl["style"]), "threat": str(cl["threat"]), "weak": str(cl["weak"]),
		"rating": snappedf(float(types[ti]["night0"]) + float(cl.get("off", 0.0)), 0.01), "stance": str(cl.get("stance", "orthodox"))}, true)
	return opp

## One real bout: CORNERBASE1's bout() with change 1's hooks (clue, heard, clash round, recover points, the simmed coach).
static func bout(types: Array, ti: int, cl: Dictionary, L: int, k: int, arm: String, coach: float) -> Dictionary:
	var cx := ctx_of(arm)
	var pol := "reader_nr" if str(cx["kind"]) in ["reader", "live"] else ("file" if str(cx["kind"]) == "file" else "skill%d" % int(100.0 - float(cx["s"]) * (100.0 - float(cx["tac"]) * 5.0)))
	var sc := Career.new()
	sc.day = 70000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": coach}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = false; sf["camp"] = {"protocol": 2}; sf["arrows"] = []
	var opp := opp_of(types, ti, cl)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": L, "pro": false, "stale": 0.0}
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	var st := R.new_state(pol, L, coach, sf)
	var cs: Dictionary = C.coach_new(pol, opp, L, str(cl["id"]), str(types[ti]["name"]), k) if C.is_coach(pol) else {}
	st["cs"] = cs
	var rng := RandomNumberGenerator.new()
	rng.seed = hash([str(types[ti]["name"]), str(cl["id"]), L, k, "coachmap2"])
	var h0 := float(st["heard"])
	var hm := hear_mult(cx) if str(cx["kind"]) == "live" else 1.0
	var ev := {"clue_wrong": 0, "ex": 0, "rec": 0, "ignored": 0, "hm": hm}
	m["step"] = "round"; m["round"] = 0; m["rounds"] = []
	BoutNight._peak(sc, sf)
	ProReadWire.open(sf)
	m["lab_from"] = sf.duplicate(true)
	BoutNight._open(sc, sf, m, C.open_call(cs, sf))
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			var ctx := R.seen(sf, m, lv)
			if str(cx["kind"]) == "live":
				ev["ex"] = int(ev["ex"]) + 1
				var u := rng.randf(); var u2 := rng.randf()
				var seen := str(ctx["sit_seen"])
				if Exchanges.MODES.has(seen) and not (seen in ["she_tired", "she_hurt"]) and u >= clue_q(float(cx["tac"]), float(cx["s"])):
					ctx["sit_seen"] = wrong_mode(str(opp.get("style", "")), seen, u2)
					ev["clue_wrong"] = int(ev["clue_wrong"]) + 1
				var ign := bool(cx["clash"]) and int(m["round"]) == 2
				st["heard"] = h0 * hm * ((1.0 - float(cx["s"])) if ign else 1.0)
				if ign: ev["ignored"] = int(ev["ignored"]) + 1
			var d := R.decide(st, ctx, sf)
			var add := R.before(st, ctx, d, sf, m, lv)
			var nx := (lv["ex"] as Array).size()
			Bouts.fight_step(sc, sf, m, "shout:" + str(d.get("shout", "")))
			R.after(st, ctx, d, sf, m, add, nx)
		var rn := int(m["round"])
		R.bell(st, sf, m)
		if rn >= L or Bouts.stopped(m) != "" or TowelWire.coach_pull(sc, sf, m): break
		if int(cl.get("switch", 0)) > 0 and rn + 1 >= int(cl["switch"]):
			opp["stance"] = "southpaw" if str(opp["stance"]) == "orthodox" else "orthodox"
		var cc: String
		if str(cx["kind"]) == "sim": cc = sim_corner(cs, cx, sf, m, rng)
		elif C.is_coach(pol): cc = C.corner(cs, sf, m)
		else: cc = R.corner_call(st, sf, m)
		var rj := rec_job(cx, m)
		if rj != "": ev["rec"] = int(ev["rec"]) + 1
		Bouts.fight_step(sc, sf, m, "corner:" + cc + rj)
		R.after_open(st, m, cc)
		if LiveRound.live(m).is_empty() and Bouts.stopped(m) != "": break
	var r := R.finish_state(st, sf, m, BoutNight.outcome_of(sf, m))
	r["ev"] = ev
	r["cs"] = cs
	return r

## ---- change 3 (design s4): a roster's five traits redrawn +-25 around the TEST CLUB (roster 0 = unchanged) ----
const TRAITS := ["temper", "heart", "discipline", "confidence", "coachability"]
static func redraw(fs: Array, r: int) -> Array:
	if r == 0: return fs
	var out: Array = []
	for f in fs:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		var rng := RandomNumberGenerator.new()
		rng.seed = hash(["coachmap2_roster", r, str(g.get("first", ""))])
		var p: Dictionary = g.get("personality", {})
		for t in TRAITS: p[t] = clampf(float(p.get(t, 50.0)) + rng.randf_range(-25.0, 25.0), 5.0, 95.0)
		g["personality"] = p
		out.append(g)
	return out

## ---- change 2 (design s3) ----
static func limit_of(c: Dictionary) -> int:
	return 3 if int(c["teaching"]) >= 15 else 2

## ---- change 1 in the season (design s2 (e)): wins in 100 from the bout probe's table -> a chance added ----
static func season_add(dt: Dictionary, cid: String, chem: float, warned: bool, pro: bool, s: float) -> float:
	var t: Dictionary = dt.get("L6" if pro else "L3", {})
	if t.is_empty() or not t.has("REID"): return 0.0
	var reid := float(t["REID"])
	var d := float(t.get(cid, reid)) - reid
	if chem > 0.0: d += (float(t.get("REID:b", reid)) - reid) * chem / 0.5
	elif chem < 0.0: d += (reid - float(t.get("REID:x", reid))) * chem / 0.5
	if warned: d += float(t.get("REID:w", reid)) - reid
	return s * d / 100.0
