extends RefCounted
## S397 money-bites measurement (career_harness.gd `money=1`): where a career's cash came from and where it went.
## Weekly lines are sampled from Sim.weekly_income / weekly_costs at each stop and weighted by the weeks closed since the
## last sample; one-offs come from the career's ledger, grouped by the words before the first ':'.
## Cash is also read at each quarter (weeks 13, 26, ...) and as months of running costs, the shape the design aims at.

const Sim := preload("res://scripts/state/Sim.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

var weekly := {}      # line -> dollars over the career (+ in, - out)
var one_offs := {}    # ledger group -> dollars
var quarters := {}    # week -> {"cash", "months"}
var _weeks_seen := 1
var _last_cost := 0


func sample(c: Career) -> void:
	var now := c.cash_history.size()
	var closed := now - _weeks_seen
	if closed <= 0:
		return
	_weeks_seen = now
	var inc: Dictionary = Sim.weekly_income(c)
	var cost: Dictionary = Sim.weekly_costs(c)
	_last_cost = int(cost["total"])
	for k in ["dues", "classes", "sponsors", "bjj", "fitness", "juniors"]:
		_add(weekly, "in " + k, int(inc.get(k, 0)) * closed)
	for k in ["rent", "fees", "staff", "fighters", "bjj", "power", "staff_roles", "kit", "upgrades", "juniors_coach"]:
		_add(weekly, "out " + k, -int(cost.get(k, 0)) * closed)
	var week := now - 1
	for q in range(13, week + 1, 13):
		if not quarters.has(q):
			quarters[q] = {"cash": c.cash, "months": snappedf(float(c.cash) / maxf(1.0, float(_last_cost) * GymBills.WEEKS_A_MONTH), 0.1)}


var owned := {}


func finish(c: Career) -> void:
	owned = {"upgrades": c.get("upgrades").size() if c.get("upgrades") != null else 0,
		"premises": int(c.get("premises")) if c.get("premises") != null else 0,
		"staff": c.get("staff_roles").size() if c.get("staff_roles") != null else 0}
	for e in c.ledger:
		var t := str(e["t"])
		var g := t.split(":")[0] if t.contains(":") else t
		_add(one_offs, g.strip_edges(), int(e["amount"]))


static func _add(d: Dictionary, k: String, v: int) -> void:
	if v != 0:
		d[k] = int(d.get(k, 0)) + v


## The population's money: mean dollars a career per line, and cash + months of costs by quarter (median).
static func report(policy: String, rows: Array) -> void:
	var lines := {}
	var q := {}
	for r in rows:
		var m: Dictionary = r["money"]
		for d in [m["weekly"], m["one_offs"]]:
			for k in d:
				lines[k] = int(lines.get(k, 0)) + int(d[k])
		for w in m["quarters"]:
			(q.get_or_add(w, []) as Array).append(m["quarters"][w])
	var keys: Array = lines.keys()
	keys.sort_custom(func(a, b): return absi(int(lines[a])) > absi(int(lines[b])))
	var parts: Array = []
	for k in keys:
		parts.append("%s %+d" % [k, int(round(float(lines[k]) / rows.size()))])
	print("MONEY %s a career (mean): %s" % [policy, " | ".join(parts)])
	var ws: Array = q.keys()
	ws.sort()
	var qp: Array = []
	for w in ws:
		var cs: Array = (q[w] as Array).map(func(x): return int(x["cash"]))
		var ms: Array = (q[w] as Array).map(func(x): return float(x["months"]))
		cs.sort()
		ms.sort()
		qp.append("w%d $%d (%.1f mo, n=%d)" % [w, cs[cs.size() / 2], ms[ms.size() / 2], cs.size()])
	print("MONEY %s cash by quarter (median of careers still open): %s" % [policy, " | ".join(qp)])
	var up := 0.0
	var pr := 0.0
	var sf := 0.0
	for r in rows:
		var o: Dictionary = r["money"].get("owned", {})
		up += float(o.get("upgrades", 0))
		pr += float(o.get("premises", 0))
		sf += float(o.get("staff", 0))
	print("MONEY %s owned at the end (mean): upgrades %.1f, premises tier %.1f, staff roles %.1f" % [policy, up / rows.size(), pr / rows.size(), sf / rows.size()])


func as_row() -> Dictionary:
	return {"weekly": weekly, "one_offs": one_offs, "quarters": quarters, "owned": owned}
