extends SceneTree
## S418 HEADAIM2B's picture: the Moves preview's own studio (MovePlayer, studio on, the hover card's camera) plays a move
## on the club's boxer against the partner, who slips or blocks every jab; every frame is saved so the glove's height at
## the partner's face can be judged by eye. `noaim` (FightStage.aim_height's control arm) plays the bought clip raw.
##   python ops/Tools/godot_slot.py run --who claude -- python tools/hidden_desktop.py run --timeout=240 <godot.exe> \
##       --path . --windowed --resolution 960x720 --audio-driver Dummy --fixed-fps 30 \
##       --script res://tools/head_aim_film.gd -- <out_dir> [move=jab] [frames=170] [noaim]
## Prints CONTACT frame=<n> clip=<clip> for every punch as its contact time passes, then HEAD_AIM_FILM frames=<n>.

const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

var main: Node


func _initialize() -> void:
	var out := "user://head_aim_film"
	var move := "jab"
	var frames := 170
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("move="):
			move = str(a).get_slice("=", 1)
		elif str(a).begins_with("frames="):
			frames = int(str(a).get_slice("=", 1))
		elif str(a) != "noaim":
			out = str(a)
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(960, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var f: Dictionary = main.career.fighters[0]
	main.visible = false
	var p: Control = MovePlayer.new()
	var stems: Array = Faces.pair(f, Faces.partner(f))
	p.bodies = [Faces.glb(str(stems[0])), Faces.glb(str(stems[1]))]
	p.studio = true
	p.yaw_deg = MoveTip.YAW_DEG
	p.size = Vector2(960, 720)
	root.add_child(p)
	for i in 6:
		await process_frame
	var d: Dictionary = MoveTip.info(move, f)
	if str(d.get("sm", "")) != "":
		p.show_move(str(d["sm"]))
	else:
		p.show_chain(d["clips"])
	var last_idx := -2
	var said := false
	for n in frames:
		await process_frame
		await RenderingServer.frame_post_draw
		var idx := int(p.get("_clip_idx"))
		var stage: Node3D = p.get("_stage")
		var ap: AnimationPlayer = stage.boxers[0]["ap"] if stage != null and not stage.boxers.is_empty() else null
		var clip := str(ap.current_animation) if ap != null else ""
		if idx != last_idx or (clip != "" and not p._is_punch_clip(clip)):
			last_idx = idx
			said = false
		if ap != null and not said and p._is_punch_clip(clip) and ap.current_animation_position >= BeatClips.contact(clip, 8.0 / 30.0):
			said = true
			print("CONTACT frame=%d clip=%s at=%.2f" % [n, clip, ap.current_animation_position])
		root.get_texture().get_image().save_jpg("%s/f_%03d.jpg" % [out, n], 0.9)
	print("HEAD_AIM_FILM frames=%d" % frames)
	quit(0)
