extends SceneTree
## S342 MOVEPLAYER1 stills: saves images of moves for visual review.
## Windowed run (needs display): xvfb-run -a -s "-screen 0 1920x1080x24" $GODOT_EXE --path . --windowed \
##     --resolution 1280x720 --audio-driver Dummy --fixed-fps 30 --script res://tools/moveplayer_still.gd -- <out_dir> fastdraw

const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const W := 840
const H := 600
const OUT_DIR := "docs/playtest/moveplayer"

var out_dir := OUT_DIR
var player: Node


func _initialize() -> void:
	FastDraw.begin()
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).begins_with("--"):
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	player = MovePlayer.new()
	root.add_child(player)
	await player.ready
	# Wait for bodies to load
	for i in 10:
		await process_frame
	# Stills of 1-2-3 at each punch's contact
	await _still_move("1-2-3", "1-2-3")
	# Stills of pivot_out mid-move
	await _still_move("pivot_out", "pivot_out_mid")
	print("MOVESTILL done")
	quit(0)


## S345: a still at each punch's contact (BeatClips.contact - the frame the fight lands it); a move with no punch is
## shot mid-move. The S342 version shot after every clip had played, so "contact" showed her back in guard.
func _still_move(move_id: String, name: String) -> void:
	player.show_move(move_id)
	var clips: Array = MoveClips.clips(move_id)
	var wait_s: float = clips.size() * 1.5 + 1.0
	var seen := {}
	var shots := 0
	var elapsed := 0.0
	while elapsed < wait_s:
		await process_frame
		elapsed += 1.0 / 30.0
		var idx := int(player.get("_clip_idx"))
		if idx < clips.size() and not seen.has(idx) and player._is_punch_clip(str(clips[idx])) 				and float(player.get("_clip_start_t")) >= BeatClips.contact(str(clips[idx]), 8.0 / 30.0):
			seen[idx] = true
			shots += 1
			await _save("%s_c%d_%s" % [name, shots, str(clips[idx])])
		elif shots == 0 and seen.is_empty() and elapsed >= wait_s * 0.4 and not clips.any(func(c): return player._is_punch_clip(str(c))):
			seen[-1] = true
			await _save(name)


func _save(name: String) -> void:
	print("MOVESTILL %s %s" % [name, "bodies 2 in frame" if player.bodies_in_frame() else "FAIL framing"])
	var img := await FastDraw.shot(self)
	var path := out_dir.path_join(name + ".png")
	img.save_png(path)
	print("wrote ", path)
