extends SceneTree
## FIGHTERLOOK1 (rules/FighterLook.gd): every boxer's look comes from her own data, the same fighter always looks the same,
## two fighters of the region never look alike, the stance follows her style, scars follow her record, the eyes blink at a
## human rate with a resting lid (no wide stare), and the skin's shine sits under real skin's (the ring-light glare).

const FighterLook := preload("res://scripts/rules/FighterLook.gd")
const Data := preload("res://scripts/state/Data.gd")
const ArtStyleScript := preload("res://scripts/fight3d/ArtStyle.gd")

var failures := 0


func _initialize() -> void:
	var cast: Array = [Data.lucy()]
	cast.append_array(Data.OPPONENTS)
	cast.append(Data.MISMATCH)
	cast.append_array(Data.RIVALS)
	# The same fighter, twice: the same look (a hash of her own data, never random).
	var a := FighterLook.look(cast[0])
	var b := FighterLook.look(cast[0].duplicate(true))
	_check(var_to_str(a) == var_to_str(b), "the same fighter always gets the same look")
	# Two fighters never share the whole look (stance, hair, boots, skin shade, lids).
	var sigs := {}
	var clash := []
	var postures := {}
	for f in cast:
		var l := FighterLook.look(f)
		postures[str(l["posture"])] = true
		var sk: Color = l["skin"]["tint"]
		var sig := "%s|%s|%s|%.2f|%.2f" % [l["posture"], l["hair"], l["boots"], sk.v, float(l["eyes"]["lid"])]
		if sigs.has(sig):
			clash.append("%s = %s" % [f["name"], sigs[sig]])
		sigs[sig] = str(f["name"])
	_check(clash.is_empty() and sigs.size() == cast.size(), "%d fighters, %d different looks %s" % [cast.size(), sigs.size(), clash])
	_check(postures.size() >= 3, "the region's fighters stand %d different ways: %s" % [postures.size(), postures.keys()])
	# Stance by style.
	_check(FighterLook.posture("Pressure fighter") == "forward" and FighterLook.posture("Counter-puncher") == "upright" \
		and FighterLook.posture("Volume puncher") == "loose" and FighterLook.posture("Boxer-puncher") == "guarded" \
		and FighterLook.posture("") == "guarded", "a pressure fighter leans in, a counter-puncher stands tall, unknown = guarded")
	var fwd := FighterLook.look({"name": "X", "style": "Pressure fighter"})
	var up := FighterLook.look({"name": "X", "style": "Out-boxer"})
	_check(float(fwd["pose"]["lean"]) > float(up["pose"]["lean"]) + 2.0, "the pressure fighter's trunk is further over her feet (%.1f vs %.1f deg)" % [fwd["pose"]["lean"], up["pose"]["lean"]])
	# Scars from her record.
	_check((FighterLook.look({"name": "N", "w": 1, "l": 1})["scars"] as Array).is_empty(), "a novice (2 bouts) has no scars")
	_check((FighterLook.look({"name": "N", "w": 5, "l": 2})["scars"] as Array).size() == 1, "7 bouts: one mark")
	_check((FighterLook.look({"name": "N", "w": 14, "l": 2})["scars"] as Array).size() == 2, "16 bouts: two marks")
	# Eyes and skin within human bounds; the glare cut.
	var eyes_ok := true
	var skin_ok := true
	for f in cast:
		var l := FighterLook.look(f)
		var e: Dictionary = l["eyes"]
		if float(e["blinks"]) < 16.0 or float(e["blinks"]) > 30.0 or float(e["lid"]) < 0.15 or float(e["lid"]) > 0.35:
			eyes_ok = false
			print("  eyes of %s: %s" % [f["name"], e])
		var s: Dictionary = l["skin"]
		if float(s["specular"]) > 0.42 or float(s["roughness"]) < 0.45 or (s["tint"] as Color).v < 0.85:
			skin_ok = false
			print("  skin of %s: %s" % [f["name"], s])
	_check(eyes_ok, "every fighter blinks 16-30 times a minute and rests her upper lid 15-35% over the eye")
	_check(skin_ok, "every fighter's skin shines under real skin's (specular <= 0.42, roughness >= 0.45)")
	# A dict with nothing but a name still gets a full look (the opponent rows, a walk-in).
	var bare := FighterLook.look({"name": "Jade Morris"})
	_check(bare.has("pose") and bare.has("eyes") and bare.has("skin") and str(bare["posture"]) == "guarded", "a name alone gives a full look")
	# The 3D side loads (a parse error here hangs the fight scene): face, life layer, art switch, the boxer build.
	for path in ["res://scripts/fight3d/FighterFace.gd", "res://scripts/fight3d/FighterLife.gd", "res://scripts/fight3d/ArtStyle.gd", "res://scripts/fight3d/FaceFill.gd",
			"res://scripts/fight3d/BoxerBuild.gd", "res://scripts/fight3d/FightStage.gd"]:
		var sc := load(path) as GDScript
		_check(sc != null and sc.can_instantiate(), "%s loads" % path.get_file())
	for path in ["res://assets/shaders/mh_eye.gdshader", "res://assets/shaders/toon.gdshader", "res://assets/shaders/toon_2side.gdshader",
			"res://assets/shaders/toon_outline.gdshader"]:
		var sh := load(path) as Shader
		_check(sh != null and not sh.get_shader_uniform_list().is_empty(), "%s loads with its uniforms" % path.get_file())
	_check(ArtStyleScript.mode() == "real" or OS.get_cmdline_user_args().has("art=toon"), "the art style is real unless asked")
	print("FIGHTER_LOOK_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("OK  " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
