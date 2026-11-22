extends SceneTree
## AFRETARGET1 (S537): the bought FILE itself (Godot's FBX reader, none of the bake's code) beside ActionForge's
## retarget and our clips, picture by picture - which retarget kept the actor's take? Per clip, off the file (deg):
## thigh / shin direction, knee bend, foot direction, and the palm's turn about the forearm (tools/afretarget_lib.gd off()).
##   <godot> --headless --path . --script res://tools/afretarget_src.gd -- [fbx=<file>] [res=<a.res>,<b.res>] [all=1]
const MH := preload("res://scripts/fight3d/MHRig.gd")
const AF := preload("res://tools/afretarget_lib.gd")

func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var file := AF.file_frames(_arg("fbx", AF.CROSS_FBX))
	if file.is_empty():
		print("AFSRC FAIL the bought file did not load")
		quit(1)
		return
	var body := MH.load_fighter("res://assets/models/metahuman/mh_boxer_01.glb")
	root.add_child(body)
	var sk := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var clips: Array = [["ActionForge", AF.af_anim(), false]]
	for r in _arg("res", "res://assets/anim/baked/mc_Box1_M3_Right_Cross.res,res://assets/anim/af_retarget/mc_Box1_M3_Right_Cross.res").split(",", false):
		clips.append([str(r).get_base_dir().get_file() + "/" + str(r).get_file().get_basename(), load(str(r)) as Animation, true])
	var worst := {}
	var at := int(round(float(_arg("at", "0.30")) * 30.0))
	for fi in file.size():
		var line := "AFSRC %02d off the file:" % fi
		for c in clips:
			var an: Animation = c[1]
			var o := AF.off(file[fi], AF.our_joints(sk, AF.pose(sk, an, AF.tracks(an), minf(fi / 30.0, an.length), c[2])))
			line += " | %s leg %2.0f bend %2.0f foot %2.0f palm %3.0f" % [c[0], o["leg"], o["flex"], o["foot"], o["palm"]]
			var w: Dictionary = worst.get(c[0], {"leg": 0.0, "flex": 0.0, "foot": 0.0, "palm": 0.0})
			for k in o:
				w[k] = maxf(w[k], o[k])
			worst[c[0]] = w
		if fi == at or _arg("all", "0") == "1":
			print(line, "  <- contact" if fi == at else "")
	for c in worst:
		print("AFSRC WORST off the file over the take, %s: thigh/shin %.0f deg, knee bend %.0f, foot %.0f, palm %.0f" % [c, worst[c]["leg"], worst[c]["flex"], worst[c]["foot"], worst[c]["palm"]])
	quit(0)
