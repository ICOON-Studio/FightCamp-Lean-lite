extends SceneTree
## S312 instrument for the Begin-fight freeze (Ziva review: "Clicking Begin freezes the last frame for 3.4-5.5 s").
## Plays the build to the tape card (TestJump "fight"), times the parts the 3D fight builds on Begin on a cold start -
## one MetaHuman body parsed from its .glb (MHRig.load_fighter), one boxer's clip library (FightClips.load_into) - then
## clicks Begin and times the longest frame that follows. Run on the never-shown desktop (3D needs a picture):
##   python tools/hidden_desktop.py run --timeout=300 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --script res://tools/begin_probe.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var main: Node


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("BEGIN_PROBE reached the tape: ", TestJump.run(main, "fight"))
	await _wait(4)
	var t := Time.get_ticks_usec()
	var body := MH.load_fighter(str(FightCast.BODIES[0]))
	print("BEGIN_PROBE one boxer body parsed from its glb: %.0f ms" % ((Time.get_ticks_usec() - t) / 1000.0))
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	t = Time.get_ticks_usec()
	var n := FightClips.load_into(ap, skel).size()
	print("BEGIN_PROBE one boxer's clips (%d) cold: %.0f ms" % [n, (Time.get_ticks_usec() - t) / 1000.0])
	var body2 := MH.load_fighter(str(FightCast.BODIES[0]))
	var ap2 := body2.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	t = Time.get_ticks_usec()
	FightClips.load_into(ap2, body2.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D)
	print("BEGIN_PROBE the same clips again (files cached): %.0f ms" % ((Time.get_ticks_usec() - t) / 1000.0))
	body.free()
	body2.free()
	await _wait(2)
	# The 3D view's own build, part by part (FightView.setup's calls), on a scratch viewport - then thrown away.
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(main.modal["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var vp := SubViewport.new()
	vp.own_world_3d = true
	root.add_child(vp)
	var stage: Node3D = (load("res://scripts/fight3d/FightStage.gd") as GDScript).new()
	vp.add_child(stage)
	var picks := FightCast.bodies_for(float(f.get("limit", 61.2)))
	var sc := FightCast.body_scales(float(f.get("limit", 61.2)), float(f.get("height", 0.0)), float(opp.get("height", 0.0)))
	t = Time.get_ticks_usec()
	stage.setup({"glb": picks[0], "corner": "red", "scale": sc[0], "stance": str(f.get("stance", "orthodox"))},
		{"glb": picks[1], "corner": "blue", "scale": sc[1], "stance": str(opp.get("stance", "orthodox"))})
	print("BEGIN_PROBE scratch stage.setup (ring + two boxers): %.0f ms" % ((Time.get_ticks_usec() - t) / 1000.0))
	t = Time.get_ticks_usec()
	FightCast.crew(stage, false)
	print("BEGIN_PROBE scratch corner crew: %.0f ms" % ((Time.get_ticks_usec() - t) / 1000.0))
	t = Time.get_ticks_usec()
	await process_frame
	print("BEGIN_PROBE scratch first frame: %.0f ms" % ((Time.get_ticks_usec() - t) / 1000.0))
	vp.queue_free()
	await _wait(3)
	# The real click, its three calls timed (BoutActs "fightstep").
	t = Time.get_ticks_usec()
	Bouts.fight_step(c, f, main.modal, "start")
	var step_ms := (Time.get_ticks_usec() - t) / 1000.0
	t = Time.get_ticks_usec()
	main.redraw_modal()
	var modal_ms := (Time.get_ticks_usec() - t) / 1000.0
	t = Time.get_ticks_usec()
	main.render()
	var render_ms := (Time.get_ticks_usec() - t) / 1000.0
	print("BEGIN_PROBE real click: fight_step %.0f ms, redraw_modal (builds the 3D view) %.0f ms, render %.0f ms" % [
		step_ms, modal_ms, render_ms])
	var act_ms := step_ms + modal_ms + render_ms
	var worst := 0.0
	for k in 30:
		var f0 := Time.get_ticks_usec()
		await process_frame
		worst = maxf(worst, (Time.get_ticks_usec() - f0) / 1000.0)
	print("BEGIN_PROBE Begin click: act() %.0f ms, worst frame after it %.0f ms, click + 30 frames %.0f ms" % [
		act_ms, worst, (Time.get_ticks_usec() - t) / 1000.0])
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
