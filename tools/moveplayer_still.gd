extends SceneTree
## S342 MOVEPLAYER1 stills: saves images of moves for visual review.
## Windowed run (needs display): xvfb-run -a -s "-screen 0 1920x1080x24" $GODOT_EXE --path . --windowed \
##     --resolution 1280x720 --audio-driver Dummy --fixed-fps 30 --script res://tools/moveplayer_still.gd -- <out_dir> fastdraw

const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const FastDraw := preload("res://tools/fast_draw.gd")

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
	await _still_move("1-2-3", "1-2-3_contact")
	# Stills of pivot_out mid-move
	await _still_move("pivot_out", "pivot_out_mid")
	print("MOVESTILL done")
	quit(0)


func _still_move(move_id: String, name: String) -> void:
	player.show_move(move_id)
	# Wait for clips to play
	await _wait_for_clips(move_id)
	# Check if bodies are in frame
	var in_frame: bool = player.bodies_in_frame()
	if in_frame:
		print("MOVESTILL bodies 2 in frame")
	else:
		print("MOVESTILL FAIL")
	# Save the still
	for i in 3:
		await RenderingServer.frame_post_draw
	var img := await FastDraw.shot(self)
	var path := out_dir.path_join(name + ".png")
	img.save_png(path)
	print("wrote ", path)


func _wait_for_clips(move_id: String) -> void:
	const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
	var clips: Array = MoveClips.clips(move_id)
	# Wait enough time for all clips to play (estimate 1.5s per clip)
	var wait_s: float = clips.size() * 1.5 + 1.0
	var elapsed := 0.0
	var frame_t := 1.0 / 30.0  # assume 30 fps for windowed run
	while elapsed < wait_s:
		await process_frame
		elapsed += frame_t
