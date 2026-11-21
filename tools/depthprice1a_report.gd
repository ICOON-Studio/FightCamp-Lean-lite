extends RefCounted
## DEPTHPRICE1A (S534): the report of tools/depthprice1a_probe.gd. agg = "arm|cell|option" -> {out: one byte a bout (2 win,
## 1 draw, 0 loss), x: a sum the row prints}. Two bars (DEPTH_SCOPE_S534): an informed pick beats the laziest option by 3+
## wins in 100, and no option is best in more than 6 of 10 cells. "Informed" is CROSS-CHECKED: the best option of a cell is
## picked on one half of the bouts and scored on the other half, so the dice cannot pick their own winner (the uncorrected
## figure, best minus laziest on the same bouts, is printed beside it and is always the bigger one). Pure static.


static func pts(o: int) -> float:
	return 1.0 if o == 2 else (0.5 if o == 1 else 0.0)


## Win points x100 of a key over the bouts whose block (per bouts a block) has index % 2 == half (half -1 = all).
static func rate(agg: Dictionary, key: String, per: int, half: int = -1) -> float:
	var ob: PackedByteArray = agg[key]["out"]
	var s := 0.0
	var k := 0
	for j in ob.size():
		if half < 0 or (j / per) % 2 == half:
			s += pts(ob[j])
			k += 1
	return 100.0 * s / maxf(1.0, k)


## Paired difference a - b (points x100): [mean, 95 % half-width].
static func paired(agg: Dictionary, ka: String, kb: String) -> Array:
	var oa: PackedByteArray = agg[ka]["out"]
	var ob: PackedByteArray = agg[kb]["out"]
	var s := 0.0
	var s2 := 0.0
	var k := mini(oa.size(), ob.size())
	for j in k:
		var d := 100.0 * (pts(oa[j]) - pts(ob[j]))
		s += d
		s2 += d * d
	var mean := s / maxf(1.0, k)
	return [mean, 1.96 * sqrt(maxf(0.0, (s2 - k * mean * mean) / maxf(1.0, k - 1.0))) / sqrt(maxf(1.0, k))]


static func report(agg: Dictionary, row: String, arm: String, pols: Array, lazy: String, what: String, per: int) -> void:
	var ids: Array = []
	for key in agg:
		var parts := str(key).split("|")
		if parts[0] == arm and not ids.has(parts[1]):
			ids.append(parts[1])
	print("\nDP1A == row=%s arm=%s (%s) == win %% by cell; laziest = %s" % [row, arm, what, lazy])
	print("DP1A HEAD cell | " + " | ".join(PackedStringArray(pols)) + " | best")
	var best_n := {}
	var mean := {}
	var informed := 0.0
	var upper := 0.0
	var stable := 0
	for cid in ids:
		var line := PackedStringArray()
		var top := ""
		var tops := ["", ""]
		for pol in pols:
			var key := "%s|%s|%s" % [arm, cid, pol]
			var r := rate(agg, key, per)
			mean[pol] = float(mean.get(pol, 0.0)) + r / ids.size()
			line.append("%.1f" % r)
			if top == "" or r > rate(agg, "%s|%s|%s" % [arm, cid, top], per):
				top = pol
			for h in 2:
				if str(tops[h]) == "" or rate(agg, key, per, h) > rate(agg, "%s|%s|%s" % [arm, cid, tops[h]], per, h):
					tops[h] = pol
		best_n[top] = int(best_n.get(top, 0)) + 1
		stable += 1 if str(tops[0]) == str(tops[1]) else 0
		var kl := "%s|%s|%s" % [arm, cid, lazy]
		var kt := "%s|%s|%s" % [arm, cid, top]
		for h in 2:
			informed += (rate(agg, "%s|%s|%s" % [arm, cid, tops[h]], per, 1 - h) - rate(agg, kl, per, 1 - h)) / (2.0 * ids.size())
		upper += (rate(agg, kt, per) - rate(agg, kl, per)) / ids.size()
		var pd := paired(agg, kt, kl)
		print("DP1A ROW %s | %s | %s (%+.1f+-%.1f over the laziest; x %.1f)" % [cid, " | ".join(line), top, float(pd[0]), float(pd[1]),
			float(agg[kt]["x"]) / maxf(1.0, (agg[kt]["out"] as PackedByteArray).size())])
	var ml := PackedStringArray()
	var hab := ""
	for pol in pols:
		ml.append("%s %.1f" % [pol, float(mean[pol])])
		if hab == "" or float(mean[pol]) > float(mean[hab]):
			hab = str(pol)
	var most := ""
	for h in best_n:
		if most == "" or int(best_n[h]) > int(best_n[most]):
			most = str(h)
	print("DP1A MEAN %s: %s" % [arm, ", ".join(ml)])
	print("DP1A BEST %s: %s | most: %s in %d of %d cells (bar: at most 6 of 10: %s) | the same best on both halves of the bouts in %d of %d cells" % [arm,
		str(best_n), most, int(best_n[most]), ids.size(), "PASS" if int(best_n[most]) * 10 <= ids.size() * 6 else "FAIL", stable, ids.size()])
	print("DP1A MOVE %s: best single habit %s %+.1f over the laziest (%s); informed pick by cell %+.1f cross-checked (%+.1f uncorrected) (bar: 3+: %s)" % [arm,
		hab, float(mean[hab]) - float(mean[lazy]), lazy, informed, upper, "PASS" if informed >= 3.0 else "FAIL"])
