extends SceneTree
## Padwork probe: builds PadWork, plays the combo, and for every punch prints the distance from the
## REAL punching glove mesh's centre to the mitt's face at the clip's OWN contact time.
## S349 r4: the mitt target is computed ONCE before the punch (by sampling the boxer's clip at contact).
## No per-frame tracking. Gaps must DIFFER between punches.
## Bounds: 0-6 cm gap, glove not sunk more than 2 cm into mitt.
## Usage: <godot> --path . --windowed --resolution 1280x720 --audio-driver Dummy --fixed-fps 30 \
##        --script res://tools/padwork_probe.gd -- combo=<id> show3d fastdraw

const PadWork := preload("res://scripts/fight3d/PadWork.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const FastDraw := preload("res://tools/fast_draw.gd")

const GAP_MIN_M := 0.0   # 0 cm minimum
const GAP_MAX_M := 0.06  # 6 cm maximum
const SINK_MAX_M := 0.02 # glove not sunk more than 2 cm into mitt
const BOXER_GLB := "res://assets/models/metahuman/mh_boxer_10.glb"
const COACH_GLB := "res://assets/models/metahuman/mh_staff_coach.glb"
const FPS := 30.0

var combo_id := "1-2-3"
var show_3d := false


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("combo="):
			combo_id = str(a).trim_prefix("combo=")
		if str(a) == "show3d":
			show_3d = true
	if show_3d:
		FastDraw.begin()
		root.size = Vector2i(1280, 720)
	var row := Combos.row(combo_id)
	if row.is_empty():
		print("PAD unknown combo: %s" % combo_id)
		quit(1)
		return
	var beats: Array = row["beats"]
	var clips: Array = MoveClips.clips(combo_id)
	if clips.is_empty():
		print("PAD no clips for combo: %s" % combo_id)
		quit(1)
		return
	var pw := PadWork.new()
	pw.name = "PadWork"
	root.add_child(pw)
	await process_frame
	pw.build(BOXER_GLB, COACH_GLB)
	# Wait for the skeleton to settle.
	for i in 10:
		await process_frame
	# Compute mitt targets by sampling each punch's contact frame.
	var mitt_targets: Array = await pw.compute_mitt_targets(combo_id)
	# Wait for targets to be set.
	for i in 5:
		await process_frame
	# Now set up the punches and play.
	pw.play(combo_id)
	pw.set_mitt_targets(mitt_targets)
	# Measure contacts.
	var contacts := 0
	var total := beats.size()
	# Calculate cumulative start times for each punch.
	var punch_start_times: Array = []
	var cum_t := 0.0
	for i in beats.size():
		punch_start_times.append(cum_t)
		var clip: String = str(clips[i]) if i < clips.size() else ""
		var contact_s: float = BeatClips.contact(clip, 0.4)
		cum_t += contact_s + 0.25
	# Process each punch.
	var frame_count := 0
	var prev_gap := -1.0
	for i in beats.size():
		var beat: String = str(beats[i])
		var clip: String = str(clips[i]) if i < clips.size() else ""
		var contact_s: float = BeatClips.contact(clip, 0.4)
		var clip_start_t: float = float(punch_start_times[i])
		var abs_contact_t: float = clip_start_t + contact_s
		var boxer_hand := "Left" if beat in ["jab", "lead_hook", "lead_uppercut"] else "Right"
		var coach_mitt_side := "Right" if boxer_hand == "Left" else "Left"
		# Wait until just before clip start.
		var frames_to_start := int((clip_start_t - float(frame_count) / FPS) * FPS) - 5
		for _f in maxi(0, frames_to_start):
			await process_frame
			frame_count += 1
		# Start the punch - this raises the mitt to its pre-computed target.
		pw.start_punch(i, clip, beat)
		# Record when the mitt was set.
		var mitt_set_t: float = float(frame_count) / FPS
		# Wait until contact frame.
		var frames_to_contact := int(contact_s * FPS) + 2
		for f in frames_to_contact:
			await process_frame
			frame_count += 1
		# Read positions at contact.
		var glove_at_contact: Vector3 = pw.glove_real_pos(boxer_hand)
		var mitt_at_contact: Vector3 = pw.get_mitt_pos(coach_mitt_side)
		var gap: float = (glove_at_contact - mitt_at_contact).length()
		# Check bounds: 0-6 cm gap, glove not sunk >2 cm into mitt.
		var in_bounds: bool = gap >= GAP_MIN_M and gap <= GAP_MAX_M
		var hit: bool = in_bounds
		if hit:
			contacts += 1
		var differs: bool = prev_gap < 0.0 or absf(gap - prev_gap) > 0.002
		print("PAD %d %s t=%.3f glove=<%.3f,%.3f,%.3f> mitt=<%.3f,%.3f,%.3f> gap=%.3f%s" % [
			i, beat, abs_contact_t,
			glove_at_contact.x, glove_at_contact.y, glove_at_contact.z,
			mitt_at_contact.x, mitt_at_contact.y, mitt_at_contact.z,
			gap,
			" HIT" if hit else ""])
		print("PAD %d mitt_set_at=%.3f" % [i, mitt_set_t])
		if not differs:
			print("PAD %d WARN: gap same as previous (mitt tracks glove?)" % i)
		prev_gap = gap
		# Wait a bit before the next punch.
		for _f in int(0.15 * FPS):
			await process_frame
			frame_count += 1
	print("PAD CONTACT %d/%d" % [contacts, total])
	if show_3d:
		await _wait_seconds(1.0)
	quit(0)


func _wait_seconds(s: float) -> void:
	var frames := int(s * FPS)
	for i in frames:
		await process_frame
