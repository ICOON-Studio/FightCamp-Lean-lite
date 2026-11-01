extends SceneTree
## S352 CORNERFIG1 (operator S350: the corner card shows "a pale mannequin"): the corner card's body figure, as
## RoundGraphics.body builds it, for a red and a blue corner with a few places hurt - her kit clay (1) beside her own kit (0),
## so the hurt spots can be judged on a red vest. Hidden desktop:
##   python tools/hidden_desktop.py run --timeout=120 <godot.exe> --path . --windowed --resolution 1000x300 \
##       --audio-driver Dummy --script res://tools/corner_fig_still.gd -- <out.png>
const BF := preload("res://scripts/ui/BodyFigure.gd")
const Faces := preload("res://scripts/rules/Faces.gd")


func _initialize() -> void:
	var out := "user://corner_figs.png"
	if not OS.get_cmdline_user_args().is_empty():
		out = OS.get_cmdline_user_args()[0]
	root.size = Vector2i(1000, 300)
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.07, 0.07)
	bg.size = Vector2(1000, 300)
	root.add_child(bg)
	# fine / hurt / critical / doctor: the ribs carry the worst, on the vest.
	var vals := {"head": 70.0, "left_eye": 48.0, "right_eye": 90.0, "nose": 80.0, "left_ribs": 44.0, "right_ribs": 22.0}
	var arms := [["mh_boxer_10", "red", 1.0], ["mh_boxer_10", "red", 0.0], ["mh_boxer_11", "blue", 1.0], ["mh_boxer_11", "blue", 0.0]]
	for i in arms.size():
		var fig: Control = BF.new()
		fig.custom_minimum_size = Vector2(168, 235)
		fig.size = Vector2(168, 235)
		fig.position = Vector2(30 + i * 240, 30)
		fig.clay = float(arms[i][2])
		root.add_child(fig)
		fig.set_portrait(BF.portrait_for(Faces.glb(str(arms[i][0])), str(arms[i][1])))
		fig.set_values(vals)
		var cap := Label.new()
		cap.text = "%s clay %d" % [arms[i][1], int(arms[i][2])]
		cap.position = Vector2(30 + i * 240, 270)
		root.add_child(cap)
	for k in 90:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out)
	print("CORNER_FIG wrote ", out)
	quit(0)
