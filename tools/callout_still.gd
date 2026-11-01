extends SceneTree
## S348 the body view's close-ups (BodyCallouts) on the GPU without a fight: both corners' panels as the HUD builds them,
## a few places hurt, one just hit. Hidden desktop:
##   python tools/hidden_desktop.py run --timeout=120 <godot.exe> --path . --windowed --resolution 900x520 \
##       --audio-driver Dummy --script res://tools/callout_still.gd -- <out.png>

const BF := preload("res://scripts/ui/BodyFigure.gd")
const BodyTurn := preload("res://scripts/ui/BodyTurn.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const Faces := preload("res://scripts/rules/Faces.gd")


func _initialize() -> void:
	var out := "user://callouts.png"
	if not OS.get_cmdline_user_args().is_empty():
		out = OS.get_cmdline_user_args()[0]
	root.size = Vector2i(900, 520)
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.07, 0.07)
	bg.size = Vector2(900, 520)
	root.add_child(bg)
	var figs := []
	for side in 2:
		var glb := Faces.glb(["mh_boxer_11", "mh_boxer_13"][side])
		var corner: String = ["red", "blue"][side]
		var fig: Control = BF.new()
		fig.custom_minimum_size = Vector2(340, 420)
		fig.size = Vector2(340, 420)
		fig.position = Vector2(30 + side * 500, 40)
		root.add_child(fig)
		BodyTurn.attach(fig, glb, corner)
		fig.set_values({"nose": 50.0, "right_ribs": 40.0} if side == 1 else {"head": 80.0})
		BodyCallouts.attach(fig, BF.portrait_for(glb, corner), -1.0 if side == 0 else 1.0, func(p: String) -> String: return BodyTip.text(p, 50.0, {}))
		figs.append(fig)
	for i in 20:
		await process_frame
	figs[1].hit("right_ribs", "body hook")
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out)
	print("CALLOUT_STILL wrote ", out)
	quit(0)
