extends RefCounted
## MOVEPICS1 r2 (S381 art review: 27 BJJ cards unreadable at 256 px or showing the wrong move) - what each reworked card
## shows: which GrappleMap film, who Ana is in it (the one DOING the move), the key contact the camera must keep in view
## and the limb whose path the arrow follows. tools/move_pic_bjj.gd draws a card listed here the r2 way (low camera, the
## keyframe and side that separate the two bodies best, tight on the contact, a 40+ px arrow); any other card keeps r1.
##   film:    {title, keys} - a GrappleMap sequence (titles as GrappleMapDB reads them); absent = BjjFilm's own film
##   ana:     "top" / "bottom" - Ana is the man higher / lower at the film's first keyframe; "p0" / "p1" - the film's own
##            first / second man
##   contact: [[body, joint], ...] - body 0 = Ana, 1 = her partner
##   arrow:   [[body, joint], ...] - the limb(s) the arrow may follow; the longest path on the card wins
##   key / az / el: the shot, pinned after a look-dev run (out=) - each pin is one of the four best by the r2 score,
##            picked side by side by eye (the review's "use your eyes"); all_keys: the early keyframes compete too;
##            keys: [k, ...] only these keyframes compete
##   pending: true - no GrappleMap film or position makes this move: an ink name card, never a wrong move
## Pure data + the pending card.

const NoGi := preload("res://scripts/rules/NoGi.gd")
const SPS := preload("res://tools/session_pic_style.gd")
const SPC := preload("res://tools/session_pic_card.gd")

const HANDS := [[0, "LeftHand"], [0, "RightHand"]]
const FEET := [[0, "LeftAnkle"], [0, "RightAnkle"]]
const KNEES := [[0, "LeftKnee"], [0, "RightKnee"]]

const CARDS := {
	"anaconda": {"film": {"title": "anaconda"}, "ana": "top", "contact": [[0, "LeftElbow"], [0, "RightElbow"], [1, "Head"]],
		"arrow": [[0, "Head"], [0, "Core"]] + HANDS, "key": 1, "az": 90, "el": 18},
	"armbar_guard": {"ana": "bottom", "contact": [[0, "Core"], [1, "LeftElbow"], [1, "RightElbow"]], "arrow": FEET + KNEES,
		"key": 5, "az": 330, "el": 18},     # S383: from 210 Ana was hidden under him; from 330 her legs swing over his arm
	"berimbolo": {"film": {"title": "berimbolo", "keys": 8}, "ana": "bottom", "contact": [[0, "Core"], [1, "Core"]],
		"arrow": [[0, "Core"], [0, "Head"]] + FEET, "key": 5, "az": 300, "el": 18},
	# S383: GrappleMap's "calf crank" is the move, but its truck position is a pile of four legs from every side (12 sides x
	# 7 keyframes looked at side by side): no shot reads at 256 px.
	"calf_slicer": {"pending": true},
	"rear_naked_choke": {"film": {"title": "rear naked choke", "keys": 5}, "ana": "top",
		"contact": [[0, "RightElbow"], [0, "LeftElbow"], [1, "Neck"]], "arrow": HANDS, "key": 2, "az": 270, "el": 18},
	# Ana's back taken (straight back, seatbelt): she escapes to the safe haven - GrappleMap #915, one of ten "escape"s.
	"seatbelt_escape": {"film": {"title": "escape", "keys": 6, "at": 915}, "ana": "bottom", "key": 2, "az": 270, "el": 18,
		"contact": [[0, "Head"], [1, "LeftHand"], [1, "RightHand"]], "arrow": [[0, "Head"], [0, "Core"]]},
	"shrimp_bridge": {"film": {"title": "shrimp escape", "keys": 4}, "ana": "bottom", "contact": HANDS + [[0, "Core"]],
		"arrow": [[0, "Core"]] + KNEES, "key": 3, "az": 210, "el": 18},
	"wrestle_up": {"film": {"title": "stand up escape"}, "ana": "bottom", "contact": [[0, "Head"], [1, "Core"]] + HANDS,
		"arrow": [[0, "Head"], [0, "Core"]], "key": 4, "az": 150, "el": 18},
	# S383: the triangler is the film's second man (his ankles rise to 0.83 m); "bottom" had put Ana in the kneeling man.
	"triangle": {"film": {"title": "top bases bottom triangles"}, "ana": "p1", "contact": KNEES + [[1, "Head"]],
		"arrow": FEET + KNEES, "key": 3, "az": 150, "el": 10},
	# r1 drew the guard triangle three times; the mounted one is the end of GrappleMap's "slow triangle".
	"mounted_triangle": {"film": {"title": "slow triangle"}, "ana": "top", "contact": KNEES + [[1, "Head"]], "arrow": FEET + KNEES,
		"key": 5, "az": 300, "el": 10},
	"back_triangle": {"pending": true},
	# r1's "backward arm drag" rolled the pair into a pile; GrappleMap #1063 "arm drag" from seated - the drag itself.
	"arm_drag_back": {"film": {"title": "arm drag", "keys": 4, "at": 1063}, "ana": "bottom", "keys": [2, 3],
		"contact": HANDS + [[1, "LeftElbow"], [1, "RightElbow"]], "arrow": HANDS + [[0, "Core"]]},
	"butterfly_sweep": {"ana": "bottom", "contact": FEET + [[1, "LeftKnee"], [1, "RightKnee"]], "arrow": FEET + KNEES,
		"key": 2, "az": 240, "el": 18},
	"counter_pass": {"film": {"title": "frame", "keys": 2}, "ana": "bottom", "contact": HANDS + [[1, "Neck"], [1, "Core"]],
		"arrow": HANDS + KNEES, "key": 1, "az": 300, "el": 18},
	"posture_closed_guard": {"film": {"title": "posture up"}, "ana": "top", "contact": [[0, "Head"]] + HANDS + [[1, "Core"]],
		"arrow": [[0, "Head"], [0, "Neck"]], "key": 3, "az": 210, "el": 10},
	"leg_drag": {"film": {"title": "top pummels to leg drag"}, "ana": "top", "contact": HANDS + [[1, "LeftKnee"], [1, "RightKnee"]],
		"arrow": HANDS + [[1, "LeftKnee"], [1, "RightKnee"]], "key": 2, "az": 210, "el": 18},
	"straight_ankle_lock": {"film": {"title": "top goes for ankle"}, "ana": "top", "key": 5, "az": 210, "el": 18,
		"contact": [[1, "LeftAnkle"], [1, "RightAnkle"], [0, "LeftShoulder"], [0, "RightShoulder"]], "arrow": [[0, "Core"], [0, "Head"]]},
	# r1's "pick up and crucify" stopped short of it: "crucify" ends on GrappleMap's crucifix position.
	"crucifix": {"film": {"title": "crucify", "keys": 5}, "ana": "top", "contact": KNEES + [[1, "LeftElbow"], [1, "Head"]],
		"arrow": FEET + KNEES, "key": 4, "az": 180, "el": 18},     # S383: from 210 Ana was buried in the pile
	"de_la_riva": {"film": {"title": "dlr sweep"}, "ana": "bottom", "contact": FEET + [[1, "LeftKnee"], [1, "RightKnee"]],
		"arrow": FEET + KNEES, "key": 3, "az": 330, "el": 18},
	"deep_half": {"film": {"title": "enter deep half", "keys": 7}, "ana": "bottom", "key": 2, "az": 240, "el": 18,
		"contact": [[0, "Head"]] + HANDS + [[1, "LeftKnee"], [1, "RightKnee"]], "arrow": [[0, "Head"], [0, "Core"]]},
	"double_leg": {"ana": "low_end", "contact": [[0, "Head"]] + HANDS + [[1, "LeftKnee"], [1, "RightKnee"]],
		"arrow": [[0, "Head"], [0, "Core"]], "key": 2, "az": 0, "el": 10},
	# Unfilmed in r1 (a stand-in position): GrappleMap's "top drops for over/under" ends on the over/under pass.
	"over_under_pass": {"film": {"title": "top drops for over/under"}, "ana": "top", "key": 1, "az": 240, "el": 10,
		"contact": [[0, "Head"]] + HANDS + [[1, "LeftKnee"], [1, "RightKnee"]], "arrow": [[0, "Head"], [0, "Core"]] + HANDS},
	# Unfilmed in r1: GrappleMap's "sweep" out of the waiter sweep start (deep half, the leg lifted like a tray).
	"waiter_sweep": {"film": {"title": "sweep todo: wip", "keys": 7}, "ana": "bottom", "key": 6, "az": 30, "el": 18,
		"contact": HANDS + [[1, "LeftAnkle"], [1, "RightAnkle"]], "arrow": [[1, "LeftAnkle"], [1, "RightAnkle"]] + HANDS},
	"americana": {"pending": true},
	"scissor_sweep": {"pending": true},
	"clock_choke": {"pending": true},
	"k_guard": {"pending": true},
}


static func has(id: String) -> bool:
	return CARDS.has(id)


static func card(id: String) -> Dictionary:
	return CARDS.get(id, {})


## The film this card names (the first sequence of two keyframes or more whose title holds it, with that many keys;
## "at" = the sequence's index in GrappleMap.txt where several share one title, checked against the title).
static func film(db: Array, f: Dictionary) -> int:
	if f.has("at"):
		var j := int(f["at"])
		return j if j < db.size() and str(db[j]["title"]).to_lower().contains(str(f["title"])) else -1
	for i in db.size():
		var s: Dictionary = db[i]
		if (s["frames"] as Array).size() < 2:
			continue
		if f.has("keys") and (s["frames"] as Array).size() != int(f["keys"]):
			continue
		if str(s["title"]).to_lower().replace("\n", " ").contains(str(f["title"])):
			return i
	return -1


## A move no GrappleMap film or position makes: its name in ink on the tile, and "card pending" under it - an honest
## blank rather than a wrong move (S381 review: americana / scissor sweep / clock choke / K-guard showed other moves).
static func pending_card(t, id: String) -> Image:
	var vp := SubViewport.new()
	vp.size = Vector2i(SPS.PX, SPS.PX)
	vp.transparent_bg = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var box := VBoxContainer.new()
	box.size = Vector2(SPS.PX, SPS.PX)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	vp.add_child(box)
	for line in [[NoGi.move_name(id).to_upper(), 26, SPS.GREY_LIGHT], ["card pending", 15, SPS.GOLD]]:
		var l := Label.new()
		l.text = str(line[0])
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.autowrap_mode = TextServer.AUTOWRAP_WORD
		l.custom_minimum_size = Vector2(SPS.PX - 40, 0)
		l.add_theme_font_size_override("font_size", int(line[1]))
		l.add_theme_color_override("font_color", line[2])
		l.add_theme_color_override("font_outline_color", SPS.INK)
		l.add_theme_constant_override("outline_size", 6)
		box.add_child(l)
	t.root.add_child(vp)
	for i in 3:
		await t.process_frame
	await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	img.convert(Image.FORMAT_RGBA8)
	vp.queue_free()
	var data := SPC.bg_data().duplicate()
	SPC._over(data, img.get_data(), 1.0)
	return Image.create_from_data(SPS.PX, SPS.PX, false, Image.FORMAT_RGBA8, data)
