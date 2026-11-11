extends RefCounted
## S436 (ANIM_AUDIT_S435, D0 step 1): one way for the punch rulers to stand two boxers and KNOW the distance held.
## Why: head_aim compared the hips gap (about 0.78 m in the guard) with stage.gap_m (root to root, about 0.92 m), so a
## row was read only when the bodies had drifted; block_meet used a fixed 0.80 to 1.10 m band the stepping route's guard
## never stands in. Both waited 3 frames after moving the bodies back, while the shown place eases over ~0.3 s
## (ShownRoot) and the feet rig steps after it: the "gap" they read was the last punch's leftover.
## Here: the bodies are put back, the feet and the guard's fidgets are held still, and the ruler waits until the hips
## gap stops moving. The stage's OWN standing gap is read after setup (`open`); every later row must stand inside
## BAND_M of it (`held`), else the row is VOID and the caller counts a failure.
##   const Stand := preload("res://tests/ruler_stand.gd")
##   if not await Stand.open(stage, self): failures += 1   after the stage is built: stands twice, marks the gap
##   var gap := await Stand.stand(stage, self)             before each row; Stand.held(stage, gap) or the row is void

const STAND_S := 30.0        # no rhythm step or fidget starts mid-read
const SETTLE_MIN := 45       # frames: ShownRoot's ease is gone and the feet have stepped under her (a fresh pair
                             # sat 6 still frames at 0.78 m, then walked out to 0.87 m)
const SETTLE_MAX := 150      # frames: give up and return what stands (the caller's band decides)
const STILL_M := 0.003       # the hips gap moves less than this a frame ...
const STILL_FRAMES := 10     # ... for this many frames in a row
const BAND_M := 0.04         # a row stands within this of the stage's own standing gap


static func hips_gap(stg: Node3D) -> float:
	var a: Vector3 = _hips(stg.boxers[0]["skel"])
	var b: Vector3 = _hips(stg.boxers[1]["skel"])
	return Vector2(a.x - b.x, a.z - b.z).length()


static func _hips(skel: Skeleton3D) -> Vector3:
	var i: int = skel.find_bone("Hips")
	if i < 0:
		return Vector3.ZERO
	return skel.global_transform * skel.get_bone_global_pose(i).origin


## Both back on their marks in the guard, held still; returns the hips gap once it has stopped moving.
static func stand(stg: Node3D, tree: SceneTree) -> float:
	stg.boxers[0]["pos"] = Vector3(0, 0, -stg.gap_m * 0.5)
	stg.boxers[1]["pos"] = Vector3(0, 0, stg.gap_m * 0.5)
	stg.guard(0)
	stg.guard(1)
	stg.feet._pause = [STAND_S, STAND_S]
	stg.life._quiet = [STAND_S, STAND_S]
	var prev: float = -1.0
	var still: int = 0
	var frames: int = 0
	while frames < SETTLE_MAX:
		await tree.process_frame
		frames += 1
		var g: float = hips_gap(stg)
		still = still + 1 if prev >= 0.0 and absf(g - prev) <= STILL_M else 0
		prev = g
		if frames >= SETTLE_MIN and still >= STILL_FRAMES:
			break
	stg.set_meta("stand_frames", frames)
	return prev


## After setup: stand twice and mark the stage's own gap. False = the two stands disagree (no gap to hold rows to).
static func open(stg: Node3D, tree: SceneTree) -> bool:
	var a: float = await stand(stg, tree)
	var b: float = await stand(stg, tree)
	stg.set_meta("stand_gap", b)
	return absf(a - b) <= BAND_M * 0.5


static func ref(stg: Node3D) -> float:
	return float(stg.get_meta("stand_gap", -1.0))


static func held(stg: Node3D, gap: float) -> bool:
	return ref(stg) > 0.0 and absf(gap - ref(stg)) <= BAND_M
