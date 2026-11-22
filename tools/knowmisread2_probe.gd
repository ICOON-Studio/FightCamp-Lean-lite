extends SceneTree
## KNOWMISREAD2 (S538): size Knowledge.SHARED_MISREAD on a PAIRED ruler.
## KNOWBOTS6's worlds and signers, but the blind signer and the signer who knows the truth play the SAME world and the
## per-world difference is kept, so the result carries its own spread (95% interval, bootstrap over worlds).
## Shares 0.5 / 0.65 / 0.8. The shown rating is built exactly as Knowledge.range_of builds it; the control arm checks
## that at the built share it equals the game's own number (Pool.shown_centre) for every prospect offered.
## Population: every 18-22 unranked m_lw prospect of each world (6 offered a signing, 4 signings), all different.
## Bars, fixed before the run: worth (top-10 boxers) in 9..14% AND the interval's low end >= 7%.
## Args: sets=7000,8000,9000 n=60 rows=<file for per-world rows; a rerun resumes from it>
## Last line: KNOWMISREAD2 done.

const K := preload("res://scripts/rules/Knowledge.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Pool := preload("res://tools/knowbots4_pool.gd")
const WG := preload("res://scripts/world/WorldGen.gd")
const WS := preload("res://scripts/world/WorldSim.gd")

const SHARES: Array = [0.5, 0.65, 0.8]
const BAR_LO := 9.0
const BAR_HI := 14.0
const BAR_FLOOR := 7.0
const BOOT := 4000
const MEASURES: Array = ["top10", "wins", "cash", "pick"]
const ATTRS: Array = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility",
	"accuracy", "timing", "defence", "footwork", "inside", "fight_iq", "durability", "composure"]

var sets: Array = [7000, 8000, 9000]
var per_set := 60
var rows_path := ""
var rows: Dictionary = {}  # seed -> row


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("sets="):
			sets = []
			for part in s.substr(5).split(","):
				sets.append(int(part))
		elif s.begins_with("n="):
			per_set = int(s.substr(2))
		elif s.begins_with("rows="):
			rows_path = s.substr(5)
	print("=== KNOWMISREAD2 PROBE: sets %s x %d worlds, shares %s, built share %.2f ===" % [
		str(sets), per_set, str(SHARES), K.SHARED_MISREAD])
	print("BARS (fixed before the run): worth %.0f..%.0f%% and interval low end >= %.0f%%" % [BAR_LO, BAR_HI, BAR_FLOOR])
	_load_rows()
	var t0 := Time.get_ticks_msec()
	var done := 0
	for bs in sets:
		for w in per_set:
			var seed_val: int = int(bs) + int(w)
			if rows.has(seed_val):
				continue
			var row := {"seed": seed_val, "o": _run_world(seed_val, -1.0), "b": []}
			for sh in SHARES:
				(row["b"] as Array).append(_run_world(seed_val, float(sh)))
			rows[seed_val] = row
			_append_row(row)
			done += 1
			if done % 10 == 0:
				print("  %d new worlds, %.1f s a world" % [done, float(Time.get_ticks_msec() - t0) / 1000.0 / float(done)])
	_report()
	print("KNOWMISREAD2 done")
	quit(0)


func _load_rows() -> void:
	if rows_path == "" or not FileAccess.file_exists(rows_path):
		return
	var f := FileAccess.open(rows_path, FileAccess.READ)
	while not f.eof_reached():
		var line := f.get_line()
		if line.strip_edges() == "":
			continue
		var d = JSON.parse_string(line)
		if d is Dictionary:
			rows[int(d["seed"])] = d
	f.close()
	print("resumed %d worlds from %s" % [rows.size(), rows_path])


func _append_row(row: Dictionary) -> void:
	if rows_path == "":
		return
	var f: FileAccess
	if FileAccess.file_exists(rows_path):
		f = FileAccess.open(rows_path, FileAccess.READ_WRITE)
		f.seek_end()
	else:
		f = FileAccess.open(rows_path, FileAccess.WRITE)
	f.store_line(JSON.stringify(row))
	f.close()


## The shown overall rating at a given share: Knowledge.range_of's centre, with the share as the only free number.
func _centre(p: Dictionary, share: float, hype: float) -> float:
	var k: Dictionary = p["k"]
	var seed: int = int(k.get("seed", 0))
	var shared: float = K._hash_offset(hash([seed, "shared_k6"]))
	var attrs: Dictionary = p["attrs"]
	var sum := 0.0
	for a in ATTRS:
		var truth := float(attrs[a])
		var w: float = K._attr_width(k, str(a))
		if w <= 0.0:
			sum += truth
			continue
		var offset: float = share * shared + (1.0 - share) * K._hash_offset(hash([seed, str(a)]))
		var lifted: float = minf(offset + clampf(hype, 0.0, 1.0) * K.HYPE_MAX_LIFT, K.HYPE_CEIL)
		sum += truth + lifted * w
	return sum / float(ATTRS.size())


## One world, one signer. share < 0: the signer who knows the truth (highest true rating). Else: the blind signer,
## who takes the highest SHOWN rating at that share. The loop is KNOWBOTS6's _run_world_k6, unchanged.
func _run_world(seed_val: int, share: float) -> Dictionary:
	var knows := share < 0.0
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var world := WG.generate(seed_val)
	var divs: Dictionary = world["divisions"]
	var boxers: Array = divs["m_lw"]["boxers"]
	var club := {"cash": 25000, "fighters": [], "signed_ids": {}}
	var out := {"top10": 0, "wins": 0, "bouts": 0, "cash": 0, "pick": 0.0, "signed": 0, "flop": 0}
	if knows:
		out.merge({"flops": [0, 0, 0], "err0": [0.0, 0.0, 0.0], "errh": [0.0, 0.0, 0.0], "n": 0, "mismatch": 0})
	for m in 48:
		var mi: int = int(m)
		if mi % 12 == 0:
			var year: int = mi / 12
			var prospects := Pool.get_prospects(world, seed_val, year, club)
			if not prospects.is_empty():
				var p: Dictionary = _choose(prospects, share, out)
				out["pick"] = float(out["pick"]) + float(p["true_rating"])
				out["signed"] = int(out["signed"]) + 1
				var f := Pool.MM.join(boxers, str(p["name"]), float(p["true_rating"]), int(p["age"]), int(p["seed"]))
				f["id"] = 90000 + (seed_val % 1000) * 10 + year
				f["pot"] = int(p["pot"])
				f["k"] = p["k"]
				f["since"] = Pool.MM.NEXT_WEEKS
				f["peak_rank"] = 99
				club["fighters"].append(f)
				club["signed_ids"][int(p["world_id"])] = true
		WS.simulate_month(divs, rng)
		for f in club["fighters"]:
			if f.get("retired", false):
				continue
			var headroom: float = clampf((float(f["pot"]) - float(f["rating"])) / 25.0, 0.10, 1.25)
			f["rating"] = minf(float(f["pot"]), float(f["rating"]) + 0.35 * headroom)
			K.expose(f["k"], "body", 2.0, "session")
			K.expose(f["k"], "skills", 2.0, "session")
			f["since"] = int(f.get("since", 0)) + 4
			if int(f["since"]) >= int(f.get("next_weeks", Pool.MM.NEXT_WEEKS)):
				var opp := Pool.pick_bout(f, boxers, rng)
				if not opp.is_empty():
					var line := Pool.MM.fight(f, opp, boxers, rng)
					f["since"] = 0
					out["bouts"] = int(out["bouts"]) + 1
					club["cash"] = int(club["cash"]) + int(round(float(int(line["purse"]) + int(line["tickets"])) * Pool.MM.GYM_SHARE))
					if bool(line["won"]):
						out["wins"] = int(out["wins"]) + 1
						K.expose(f["k"], "fire", 4.0, "bout")
					if bool(line["stop"]) and not bool(line["won"]):
						K.stale(f["k"], "knockout")
			var rk := int(f.get("rank", 0))
			if rk > 0:
				f["peak_rank"] = mini(int(f.get("peak_rank", 99)), rk)
		if mi % 12 == 11:
			WS.year_end(divs, rng)
	for f in club["fighters"]:
		if int(f.get("peak_rank", 99)) <= 10:
			out["top10"] = int(out["top10"]) + 1
	out["cash"] = int(club["cash"])
	return out


func _choose(prospects: Array, share: float, out: Dictionary) -> Dictionary:
	if share < 0.0:
		var best: Dictionary = prospects[0]
		for p in prospects:
			if float(p["true_rating"]) > float(best["true_rating"]):
				best = p
			# the ruler's own readings, on the pool the knowing signer is offered (the same for every share)
			out["n"] = int(out["n"]) + 1
			for i in SHARES.size():
				var sh := float(SHARES[i])
				out["err0"][i] = float(out["err0"][i]) + absf(_centre(p, sh, 0.0) - float(p["true_mean"]))
				out["errh"][i] = float(out["errh"][i]) + absf(_centre(p, sh, float(p["hype"])) - float(p["true_mean"]))
			if absf(_centre(p, K.SHARED_MISREAD, float(p["hype"])) - Pool.shown_centre(p, p["k"])) > 0.000001:
				out["mismatch"] = int(out["mismatch"]) + 1
		for i in SHARES.size():
			if _centre(best, float(SHARES[i]), float(best["hype"])) - float(best["true_mean"]) >= Pool.FLOP_THRESHOLD:
				out["flops"][i] = int(out["flops"][i]) + 1
		return best
	var pick: Dictionary = prospects[0]
	var top := -1000.0
	for p in prospects:
		var c := _centre(p, share, float(p["hype"]))
		if c > top:
			top = c
			pick = p
	if top - float(pick["true_mean"]) >= Pool.FLOP_THRESHOLD:
		out["flop"] = int(out["flop"]) + 1
	return pick


## --- Report ---

func _report() -> void:
	var seeds: Array = []
	for bs in sets:
		for w in per_set:
			if rows.has(int(bs) + int(w)):
				seeds.append(int(bs) + int(w))
	var n := seeds.size()
	var mismatch := 0
	var offered := 0
	for s in seeds:
		mismatch += int(rows[s]["o"]["mismatch"])
		offered += int(rows[s]["o"]["n"])
	print("\nWORLDS %d, prospects offered %d" % [n, offered])
	print("CONTROL: probe rating at the built share %.2f against the game's own shown rating: %d mismatches of %d" % [
		K.SHARED_MISREAD, mismatch, offered])
	for i in SHARES.size():
		var e0 := 0.0
		var eh := 0.0
		var fb := 0
		var fo := 0
		for s in seeds:
			e0 += float(rows[s]["o"]["err0"][i])
			eh += float(rows[s]["o"]["errh"][i])
			fo += int(rows[s]["o"]["flops"][i])
			fb += int(rows[s]["b"][i]["flop"])
		print("\n--- SHARE %.2f ---" % float(SHARES[i]))
		print("mean |shown - true| = %.3f (no hype; %.3f with the pool's hype) | flops blind %d / knows %d" % [
			e0 / float(offered), eh / float(offered), fb, fo])
		for bs in sets:
			var b := 0
			var o := 0
			for w in per_set:
				var sd: int = int(bs) + int(w)
				if rows.has(sd):
					b += int(rows[sd]["b"][i]["top10"])
					o += int(rows[sd]["o"]["top10"])
			print("  set %d: top-10 blind %d, knows %d, worth %+.1f%%" % [int(bs), b, o, _pct(float(o), float(b))])
		for m in MEASURES:
			var st := _paired(seeds, i, str(m))
			print("  %-6s blind %.1f knows %.1f | worth %+.2f%% [95%% %+.2f .. %+.2f] | per world %+.3f +/- %.3f" % [
				str(m), st["b"], st["o"], st["worth"], st["lo"], st["hi"], st["mean_d"], st["half"]])
			if str(m) == "top10":
				var ok: bool = st["worth"] >= BAR_LO and st["worth"] <= BAR_HI and st["lo"] >= BAR_FLOOR
				print("  VERDICT share %.2f: %s (worth %+.2f%%, low end %+.2f%%)" % [
					float(SHARES[i]), "CLEARS" if ok else "DOES NOT CLEAR", st["worth"], st["lo"]])


func _pct(o: float, b: float) -> float:
	return (o - b) / maxf(b, 0.0001) * 100.0


## Worth = (sum knows - sum blind) / sum blind over the same worlds; interval = percentile bootstrap over worlds.
func _paired(seeds: Array, i: int, m: String) -> Dictionary:
	var bs: Array[float] = []
	var os: Array[float] = []
	var sb := 0.0
	var so := 0.0
	var sd := 0.0
	var sdd := 0.0
	for s in seeds:
		var b := float(rows[s]["b"][i][m])
		var o := float(rows[s]["o"][m])
		bs.append(b)
		os.append(o)
		sb += b
		so += o
		sd += o - b
		sdd += (o - b) * (o - b)
	var n := float(seeds.size())
	var mean_d := sd / n
	var var_d := maxf(0.0, (sdd - n * mean_d * mean_d) / maxf(n - 1.0, 1.0))
	var rng := RandomNumberGenerator.new()
	rng.seed = 538  # the same resamples for every share
	var boots: Array[float] = []
	for r in BOOT:
		var tb := 0.0
		var to := 0.0
		for j in seeds.size():
			var pick := rng.randi_range(0, seeds.size() - 1)
			tb += bs[pick]
			to += os[pick]
		boots.append(_pct(to, tb))
	boots.sort()
	return {"b": sb, "o": so, "worth": _pct(so, sb), "lo": boots[int(BOOT * 0.025)], "hi": boots[int(BOOT * 0.975) - 1],
		"mean_d": mean_d, "half": 1.96 * sqrt(var_d / n)}
