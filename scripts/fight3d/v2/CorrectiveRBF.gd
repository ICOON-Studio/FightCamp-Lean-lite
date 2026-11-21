extends RefCounted
## MHCORR2 (S535; the old project's S262 MHRBF1 + S263 MHRBF2 module, trimmed to what the body tables use): RigLogic's
## RBF pose-driver weights, as Unreal evaluates a MetaHuman body's corrective solvers (OpenRigLogic, MIT:
## src/riglogic/rbf/cpu/RBFSolver.cpp, InterpolativeRBFSolver.cpp). PURE: no preloads, no files, no nodes.
##   prepare(solver)   one table solver (assets/data/mh_correctives_<body>.json "solvers"[i]) read once: its target
##                     rotations, kernel, radius, and the inverse of the target-to-target kernel matrix
##   weights(prep, q)  one weight per target for the driver's rest-relative rotation q
## THE MATH (d and r in radians): kernel gaussian exp(-d / r^2) (RigLogic does NOT square d), exponential exp(-2d / r),
## linear / cubic / quintic max(0, 1 - (d/r)^n). Interpolative: w = clamp(A^-1 * phi(q), 0, 1), A[i][j] =
## kernel(dist(t_i, t_j)) - so the arm put exactly in an authored pose gets that pose back, weight 1. A singular A falls
## back to the plain kernel weights. Then normalise (always, or only above 1), scale, and cut at the weight threshold.
## Distances: swing = the angle between the two rotations' images of the twist axis (a pure twist is 0 away);
## twist = the difference of the twist angles about it; quat = the shortest angle between the two rotations.


static func distance(q_a: Quaternion, q_b: Quaternion, method: String = "quat", twist_axis: Vector3 = Vector3.RIGHT) -> float:
	var a := q_a.normalized()
	var b := q_b.normalized()
	match method:
		"swing":
			return (a * twist_axis).angle_to(b * twist_axis)
		"twist":
			var ta := 2.0 * atan2(Vector3(a.x, a.y, a.z).dot(twist_axis), a.w)
			var tb := 2.0 * atan2(Vector3(b.x, b.y, b.z).dot(twist_axis), b.w)
			return absf(wrapf(ta - tb, -PI, PI))
		_:
			return 2.0 * acos(clampf(absf(a.dot(b)), 0.0, 1.0))


static func ue_kernel(d: float, r: float, function: String) -> float:
	if r <= 0.0:
		return 1.0 if d <= 0.0 else 0.0
	var u: float = absf(d) / r
	match function.to_lower():
		"linear": return maxf(0.0, 1.0 - u)
		"cubic": return maxf(0.0, 1.0 - pow(u, 3.0))
		"quintic": return maxf(0.0, 1.0 - pow(u, 5.0))
		"exponential": return exp(-2.0 * u)
		_: return exp(-absf(d) / (r * r))


## A table solver, read once. "inv" is empty when the solver is additive or its matrix is singular ("singular").
static func prepare(solver: Dictionary) -> Dictionary:
	var axis_a: Array = solver.get("twist_axis", [1.0, 0.0, 0.0])
	var axis := Vector3(float(axis_a[0]), float(axis_a[1]), float(axis_a[2]))
	var p := {"targets": [], "scales": [], "base": 0, "inv": [], "singular": false,
		"axis": axis.normalized() if axis.length_squared() > 1e-12 else Vector3.RIGHT,
		"method": str(solver.get("distance", "quat")), "function": str(solver.get("function", "gaussian")),
		"radius": deg_to_rad(float(solver.get("radius_deg", 0.0))),
		"always": str(solver.get("normalize", "above_one")) == "always",
		"threshold": float(solver.get("weight_threshold", 0.0))}
	var samples: Array = solver.get("samples", [])
	for i in samples.size():
		var s: Dictionary = samples[i]
		var dq: Array = s.get("driver_q", [0.0, 0.0, 0.0, 1.0])
		(p["targets"] as Array).append(Quaternion(float(dq[0]), float(dq[1]), float(dq[2]), float(dq[3])).normalized())
		(p["scales"] as Array).append(float(s.get("scale", 1.0)))
		if str(s.get("pose", "")) == "default":
			p["base"] = i
	if str(solver.get("solver_type", "")) == "interpolative":
		var solved := solve_matrix(p)
		p["inv"] = solved["inv"]
		p["singular"] = solved["singular"]
	return p


## The inverse of the target kernel matrix (Gauss-Jordan, partial pivoting); {"inv": [], "singular": true} when it has none.
static func solve_matrix(p: Dictionary) -> Dictionary:
	var t: Array = p["targets"]
	var n: int = t.size()
	var rows: Array = []
	var inv: Array = []
	for i in n:
		var row := PackedFloat64Array()
		var identity := PackedFloat64Array()
		row.resize(n)
		identity.resize(n)
		for j in n:
			row[j] = ue_kernel(distance(t[i], t[j], p["method"], p["axis"]), p["radius"], p["function"])
			identity[j] = 1.0 if i == j else 0.0
		rows.append(row)
		inv.append(identity)
	for col in n:
		var pivot := col
		for k in range(col + 1, n):
			if absf(rows[k][col]) > absf(rows[pivot][col]):
				pivot = k
		if absf(rows[pivot][col]) < 1e-9:
			return {"inv": [], "singular": true}
		var tmp: PackedFloat64Array = rows[col]
		rows[col] = rows[pivot]
		rows[pivot] = tmp
		tmp = inv[col]
		inv[col] = inv[pivot]
		inv[pivot] = tmp
		var divisor: float = rows[col][col]
		for j in n:
			rows[col][j] /= divisor
			inv[col][j] /= divisor
		for k in n:
			if k == col:
				continue
			var factor: float = rows[k][col]
			if factor == 0.0:
				continue
			for j in n:
				rows[k][j] -= factor * rows[col][j]
				inv[k][j] -= factor * inv[col][j]
	return {"inv": inv, "singular": false}


## One weight per target. What the threshold cut or a far query left short of 1 goes to the "default" pose (the rest),
## so a far arm rests instead of collapsing.
static func weights(p: Dictionary, q: Quaternion) -> PackedFloat64Array:
	var t: Array = p["targets"]
	var n: int = t.size()
	var phi := PackedFloat64Array()
	phi.resize(n)
	for i in n:
		phi[i] = ue_kernel(distance(q, t[i], p["method"], p["axis"]), p["radius"], p["function"])
	var out := phi
	var inverse: Array = p["inv"]
	if not inverse.is_empty():
		out = PackedFloat64Array()
		out.resize(n)
		for i in n:
			var row: PackedFloat64Array = inverse[i]
			var solved := 0.0
			for j in n:
				solved += row[j] * phi[j]
			out[i] = clampf(solved, 0.0, 1.0)
	var total := 0.0
	for i in n:
		total += out[i]
	var ratio := 1.0
	if total > 1e-12 and (total > 1.0 or bool(p["always"])):
		ratio = 1.0 / total
	total = 0.0
	for i in n:
		out[i] *= ratio * float(p["scales"][i])
		if out[i] <= float(p["threshold"]):
			out[i] = 0.0
		total += out[i]
	if total < 1.0 and n > 0:
		out[int(p["base"])] += 1.0 - total
	return out
