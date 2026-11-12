extends RefCounted
## S439 DAMAGESHOW1 (operator Q-S294-192: "Stop, show damage"; C295: "the fighter after the bout with the fight's marks
## leads"; S437: "use the hook line and the pointer out of the body"): a boxer's figure on the RESULT page with the marks
## this bout left. The muscles tinted by band as before (RoundGraphics.body), and every sore or cut place's close-up
## pinned beside the body on a hooked line with its name, number and word: her own face with the cut, the swollen or
## shut eye, the red nose (FaceMarks); the liver; the ribs. A boxer with no mark shows the clean figure.
##   figure(map, side "a"|"b", glb, corner "red"|"blue", track) -> Control or null     line(map, side, spot) -> String

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const RoundGraphics := preload("res://scripts/ui/RoundGraphics.gd")

const SIZE := Vector2(330, 320)   # the body in the middle, a strip each side for the close-ups
const HEAD_R := 46.0
const PLACE := {"head": "HEAD", "left_eye": "LEFT EYE", "right_eye": "RIGHT EYE", "nose": "NOSE", "left_ribs": "LEFT RIBS",
	"right_ribs": "LIVER"}
const WORD := {"fine": "fine", "hurt": "sore", "critical": "badly hurt", "doctor": "badly hurt"}


static func figure(map: Dictionary, side: String, glb: String, corner: String, track: Dictionary = {}) -> Control:
	var fig: Control = RoundGraphics.body(map, side, glb, corner, track)
	if fig == null:
		return null
	var co: Control = BodyCallouts.attach(fig, BodyFigure.portrait_for(glb, corner), -1.0 if side == "a" else 1.0,
		func(p: String) -> String: return str(fig.call("tip_of", p)))
	if co == null:
		return fig
	co.set("marks", map.get(side, {}))
	co.set("line_fn", func(s: Dictionary) -> String: return line(map, side, s))
	co.call("pin", HEAD_R)
	fig.set_meta("result_size", SIZE)
	return fig


## The words under a close-up: its worst place, what is left of it, the band's word, an open cut.
static func line(map: Dictionary, side: String, s: Dictionary) -> String:
	var worst := str(s["places"][0])
	var cut := false
	for p in s["places"]:
		if BodyMap.value(map, side, str(p)) < BodyMap.value(map, side, worst):
			worst = str(p)
		cut = cut or bool(((map.get(side, {}) as Dictionary).get("cuts", {}) as Dictionary).get(p, false))
	var v := BodyMap.value(map, side, worst)
	return "%s %d - %s%s" % [PLACE[worst], int(round(v)), WORD[BodyMap.band(v)], ", cut" if cut else ""]
