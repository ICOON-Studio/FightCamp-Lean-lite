extends RefCounted
## Real amateur bouts throw punches in bursts of 2-5, then a quiet spell (S310 fix 6, J28, BoxMind).
## Re-times one exchange's beats (in place, kept sorted) into bursts and returns [[beat indices], ...].
## Never adds, deletes or reorders beats; never changes any key except "t".

# Burst of 1, 2, 3, 4, 5 punches. S313 (Claude, collecting): Qwen's [0.02, 0.03, 0.45, 0.25, 0.25] made 84 % of attacks
# 3-5 punches; real single jabs and one-twos are common. Measured with these: singles + pairs back, 21 punches an
# exchange (both, the real ~20 a minute each) in ~6.5 bursts, 3-5 still the bulk.
const SIZE_W: Array = [0.10, 0.20, 0.32, 0.22, 0.16]
const IN_GAP_S := Vector2(0.28, 0.45)
const GAP_S := 0.35
const QUIET_S := Vector2(1.6, 6.5)
const START_S := 0.8
const END_S := 27.0
const PUNCHES: Array = ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]


static func is_punch(move: String) -> bool:
	return move in PUNCHES


## Split punch indices into hard groups (same combo_id, adjacent combo flags, habit beats).
static func _hard_groups(beats: Array, p_idx: Array) -> Array:
	if p_idx.is_empty():
		return []
	var out: Array = []
	var cur: Array = [p_idx[0]]
	var first_b: Dictionary = beats[p_idx[0]]
	var cur_combo: String = str(first_b.get("combo_id", ""))
	var prev_cf: bool = bool(first_b.get("combo", false))
	for i in range(1, p_idx.size()):
		var b: Dictionary = beats[p_idx[i]]
		var cid: String = str(b.get("combo_id", ""))
		var cf: bool = bool(b.get("combo", false))
		var hab: bool = b.has("habit") and str(b["habit"]) != ""
		var extend: bool = false
		if cid != "" and cid == cur_combo:
			extend = true
		elif cf and prev_cf:
			extend = true
		elif hab:
			extend = true
		if extend:
			cur.append(p_idx[i])
		else:
			out.append(cur)
			cur = [p_idx[i]]
		if cid != "":
			cur_combo = cid
		elif not extend:
			cur_combo = ""
		prev_cf = cf
	out.append(cur)
	return out


## Draw burst sizes from SIZE_W; remainder is split into ≤ 5 chunks.
static func _assign_sizes(n_p: int, rng: RandomNumberGenerator) -> Array:
	if n_p <= 0:
		return []
	var sizes: Array = []
	var remaining: int = n_p
	while remaining > 0:
		var r: float = rng.randf()
		var cum: float = 0.0
		var pick: int = 1
		for i in SIZE_W.size():
			cum += float(SIZE_W[i])
			if r < cum:
				pick = i + 1
				break
		pick = mini(pick, remaining)
		pick = mini(pick, 5)
		sizes.append(pick)
		remaining -= pick
	return sizes


## Partition punches into bursts: merge hard groups to match target sizes.
static func _partition(beats: Array, p_idx: Array, rng: RandomNumberGenerator) -> Array:
	var hgroups: Array = _hard_groups(beats, p_idx)
	if hgroups.is_empty():
		return []
	var targets: Array = _assign_sizes(p_idx.size(), rng)
	var bursts: Array = []
	var gi: int = 0
	for ti in targets.size():
		var target: int = targets[ti]
		var cur: Array = []
		var cur_sz: int = 0
		while gi < hgroups.size() and cur_sz < target:
			for idx in hgroups[gi]:
				cur.append(idx)
			cur_sz += hgroups[gi].size()
			gi += 1
		if gi < hgroups.size() and ti == targets.size() - 1:
			while gi < hgroups.size():
				for idx in hgroups[gi]:
					cur.append(idx)
				gi += 1
		if cur.size() > 0:
			bursts.append(cur)
	while gi < hgroups.size():
		if bursts.is_empty():
			bursts.append([])
		for idx in hgroups[gi]:
			bursts[bursts.size() - 1].append(idx)
		gi += 1
	return bursts


static func _draw_range(v: Vector2, rng: RandomNumberGenerator) -> float:
	return rng.randf_range(v.x, v.y)


## Re-times one exchange's beats (in place, kept sorted) and returns the bursts as [[beat indices], ...].
static func apply(beats: Array, rng: RandomNumberGenerator) -> Array:
	var p_idx: Array = []
	for i in beats.size():
		if is_punch(str(beats[i]["move"])):
			p_idx.append(i)
	if p_idx.is_empty():
		var step: float = (END_S - START_S) / maxf(1.0, float(beats.size() - 1)) if beats.size() > 1 else 0.0
		for i in beats.size():
			beats[i]["t"] = snappedf(START_S + step * float(i), 0.01)
		return []
	var n_p: int = p_idx.size()
	var bursts: Array = _partition(beats, p_idx, rng)
	var n_b: int = bursts.size()
	var inner: Array = []
	for burst in bursts:
		var times: Array = [0.0]
		for j in range(1, burst.size()):
			times.append(times[j - 1] + GAP_S)
		inner.append(times)
	var burst_t: float = 0.0
	for d in inner:
		var arr: Array = d
		burst_t += arr[arr.size() - 1]
	var raw_q: Array = []
	for i in (n_b - 1):
		raw_q.append(_draw_range(QUIET_S, rng))
	var raw_sum: float = 0.0
	for v in raw_q:
		raw_sum += v
	var avail: float = (END_S - START_S) - burst_t
	var scale: float = 1.0
	if raw_sum > 0.001:
		scale = clampf(avail / maxf(0.001, raw_sum), 0.6, 1.6)
	var quiet: Array = []
	for v in raw_q:
		quiet.append(v * scale)
	var q_sum: float = 0.0
	for v in quiet:
		q_sum += v
	var need: float = avail - q_sum
	if absf(need) > 0.001 and n_b > 1:
		var total_q: float = 0.0
		for v in quiet:
			total_q += v
		if total_q > 0.001:
			var f: float = avail / total_q
			for i in (n_b - 1):
				quiet[i] = maxf(1.1, quiet[i] * f)
	var b_start: Array = [START_S]
	for i in (n_b - 1):
		var i_arr: Array = inner[i]
		b_start.append(b_start[i] + i_arr[i_arr.size() - 1] + quiet[i])
	var punch_times: Array = []
	for bi in n_b:
		var burst: Array = bursts[bi]
		var times: Array = inner[bi]
		for j in burst.size():
			punch_times.append(b_start[bi] + times[j])
	var new_t: Array = []
	new_t.resize(beats.size())
	var pi_cur: int = 0
	for pi in n_p:
		new_t[p_idx[pi]] = punch_times[pi]
	pi_cur = 0
	var trail_n: int = 0
	for i in beats.size():
		if pi_cur < n_p and p_idx[pi_cur] == i:
			pi_cur += 1
			continue
		if pi_cur < n_p:
			var next_p_t: float = punch_times[pi_cur]
			var orig_off: float = float(beats[p_idx[pi_cur]]["t"]) - float(beats[i]["t"])
			var off: float = clampf(orig_off, 0.2, 1.2)
			var t: float = next_p_t - off
			if pi_cur > 0:
				t = maxf(t, punch_times[pi_cur - 1] + 0.15)
			if i > 0:
				t = maxf(t, new_t[i - 1] + 0.05)
			new_t[i] = snappedf(t, 0.01)
		else:
			var prev_t: float = punch_times[n_p - 1]
			if i > 0:
				prev_t = maxf(prev_t, float(new_t[i - 1]))
			trail_n += 1
			var m: String = str(beats[i]["move"])
			if m == "count":
				new_t[i] = snappedf(prev_t + 0.6, 0.01)
			else:
				new_t[i] = snappedf(prev_t + 0.6 * float(trail_n), 0.01)
	if beats.size() > 0 and float(new_t[beats.size() - 1]) > END_S:
		var last_p_t: float = punch_times[n_p - 1]
		var trail_count: int = 0
		for i in range(beats.size() - 1, -1, -1):
			if is_punch(str(beats[i]["move"])):
				break
			trail_count += 1
		if trail_count > 0:
			var trail_avail: float = END_S - last_p_t
			var step: float = trail_avail / float(trail_count + 1)
			step = maxf(step, 0.05)
			for k in trail_count:
				var idx: int = beats.size() - trail_count + k
				new_t[idx] = snappedf(last_p_t + step * float(k + 1), 0.01)
	for i in beats.size():
		new_t[i] = clampf(float(new_t[i]), START_S, END_S)
	for i in range(1, beats.size()):
		if float(new_t[i]) < float(new_t[i - 1]) + 0.01:
			new_t[i] = minf(END_S, float(new_t[i - 1]) + 0.01)
	for i in beats.size():
		beats[i]["t"] = new_t[i]
	return bursts
