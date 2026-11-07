extends RefCounted
## FIGHTERLOOK1 (operator 2026-11-07 on the 3D fighters: "they do look dumb tbh, the poses the glare they all look the same
## they have the same look etc"). Measured on main before this: four women's bodies are near copies (portrait correlation
## 0.97-0.99: 15/17/18/22, 10/19), every boxer wears the same kit and plays the same guard and stool clips, the eyes have no
## joints (a fixed wide stare, no blinks), and the skin's specular 0.5 (F0 0.04) sits above real skin's 0.028 under five
## 3.0-3.6 spots - the glare.
## This module turns a fighter's OWN data into how her body is drawn and how she carries herself, so the same fighter always
## looks the same and two fighters never look alike: skin tone shift and shine, hair colour, the club trim and her boots,
## scars from her record, a stance by her style, and her eyes (how open, how often she blinks, how long she holds a look).
## Pure static, zero preloads; every number is from her dict or a hash of her name (never random).
##   look(f) -> Dictionary   posture(style) -> String

## The four ways a boxer stands at rest (FighterLife.gd plays each): by style, then her own numbers on top.
##   forward  - pressure fighters and sluggers: trunk over the lead leg, chin tucked, shoulders up
##   upright  - out-boxers and counter-punchers: tall, weight back, chin level, head still
##   loose    - volume punchers: bouncy, shoulders rolling, weight changing feet often
##   guarded  - boxer-punchers (and anyone unknown): compact, a little hunched, chin down, steady
const POSTURES := ["forward", "upright", "loose", "guarded"]
const STYLE_POSTURE := {"Pressure fighter": "forward", "Slugger": "forward", "Out-boxer": "upright",
	"Counter-puncher": "upright", "Volume puncher": "loose", "Boxer-puncher": "guarded"}
## Per posture: trunk lean (deg, + = forward), chin (deg, + = down), shoulder hunch (deg), hip sway (m), sway/breath rate.
const POSTURE_NUM := {
	"forward": {"lean": 7.0, "chin": 7.0, "hunch": 4.0, "sway_m": 0.010, "sway_hz": 0.22, "breath_hz": 0.30},
	"upright": {"lean": -1.5, "chin": 1.0, "hunch": 0.0, "sway_m": 0.014, "sway_hz": 0.16, "breath_hz": 0.24},
	"loose": {"lean": 2.5, "chin": 3.0, "hunch": 1.5, "sway_m": 0.020, "sway_hz": 0.30, "breath_hz": 0.34},
	"guarded": {"lean": 4.0, "chin": 5.0, "hunch": 3.0, "sway_m": 0.008, "sway_hz": 0.19, "breath_hz": 0.27},
}
## Hair colours as a multiplier on the groom texture (natural shades only).
const HAIR := [Color(1, 1, 1), Color(0.62, 0.55, 0.5), Color(1.0, 0.82, 0.66), Color(0.85, 0.62, 0.48), Color(0.45, 0.42, 0.42)]
## Club trim colours (the singlet's edge) and boot colours.
const TRIM := [Color(0.95, 0.95, 0.93), Color(0.95, 0.75, 0.2), Color(0.08, 0.08, 0.09), Color(0.75, 0.77, 0.8), Color(0.1, 0.45, 0.25)]
const BOOTS := [Color(0.06, 0.06, 0.07), Color(0.92, 0.92, 0.9), Color(0.55, 0.55, 0.58), Color(0.5, 0.05, 0.06), Color(0.08, 0.12, 0.35)]
## Real skin F0 ~0.028 -> Godot specular ~0.42; a little under that kills the ring-light glare without going chalky.
## Blind round 2: 0.30-0.36 / 0.54-0.64 read "matte and waxy" (one critic); main's 0.5 / 0.48 "oily vinyl" (the other). Between.
const SKIN_SPEC := Vector2(0.37, 0.42)
const SKIN_ROUGH := Vector2(0.47, 0.55)
## Scar marks by bouts boxed (w + l): none under 6, a brow nick from 6, a second mark from 12.
const SCAR_BOUTS := [6, 12]
const SCAR_SPOTS := ["brow_l", "brow_r", "cheek_l", "cheek_r", "nose"]


static func posture(style: String) -> String:
	return str(STYLE_POSTURE.get(style, "guarded"))


## A steady number in [0, 1) from her name and a salt (the same name always gives the same number).
static func _h(name: String, salt: int) -> float:
	var x: int = absi(hash(name + "#" + str(salt)))
	return float(x % 10007) / 10007.0


static func _stat(f: Dictionary, key: String, fallback: float) -> float:
	var s: Variant = f.get("stats", {})
	if s is Dictionary and (s as Dictionary).has(key):
		return float((s as Dictionary)[key])
	return fallback


static func look(f: Dictionary) -> Dictionary:
	var name := str(f.get("name", "boxer"))
	var style := str(f.get("style", ""))
	var p := posture(style)
	var num: Dictionary = (POSTURE_NUM[p] as Dictionary).duplicate()
	var rating := float(f.get("rating", 60.0))
	var power := _stat(f, "power", rating)
	var defense := _stat(f, "defense", rating)
	var iq := _stat(f, "fight_iq", rating)
	var bouts := int(f.get("w", 0)) + int(f.get("l", 0))
	var wins := int(f.get("w", 0))
	# Confidence from her record (win share, bouts boxed) - carries the chin up and the lids calm.
	var conf := clampf(0.35 + 0.5 * (float(wins) / maxf(1.0, float(bouts))) + 0.015 * float(bouts), 0.0, 1.0)
	# Her own numbers over the style's: each up to +-35% (so two pressure fighters still stand apart).
	for k in ["lean", "chin", "hunch", "sway_m"]:
		num[k] = float(num[k]) * lerpf(0.65, 1.35, _h(name, 11 + k.length()))
	num["chin"] = float(num["chin"]) - 3.0 * (conf - 0.5)
	num["sway_hz"] = float(num["sway_hz"]) * lerpf(0.85, 1.2, _h(name, 3))
	num["breath_hz"] = float(num["breath_hz"]) * lerpf(0.9, 1.15, _h(name, 4))
	num["tilt"] = lerpf(-4.0, 4.0, _h(name, 5))                 # head roll (deg) - her habit
	num["weight"] = lerpf(-0.6, 0.6, _h(name, 6))                # which foot she leans on more (-1 left .. 1 right)
	num["shoulders_m"] = lerpf(0.0, 0.016, clampf((power - 50.0) / 30.0, 0.0, 1.0))   # punchers carry wider shoulders
	var age := float(f.get("age", 24))
	var eyes := {
		# How far the upper lid sits over the eye at rest (0 = wide stare .. 0.5 = half shut): calm and confident = heavier.
		"lid": lerpf(0.16, 0.34, clampf(0.5 * conf + 0.5 * _h(name, 7), 0.0, 1.0)),
		# Blinks a minute: 17-28 - a boxer between rounds blinks often (sweat, effort); the blind critics (round 2) saw 4 s holds
		# with none. Nervous and young = more; a high fight IQ holds the look longer.
		"blinks": clampf(lerpf(19.0, 27.0, _h(name, 8)) - (iq - 60.0) * 0.12 - (age - 24.0) * 0.15, 16.0, 30.0),
		"hold_s": lerpf(0.8, 2.2, _h(name, 9)) * lerpf(0.85, 1.25, clampf((defense - 45.0) / 35.0, 0.0, 1.0)),
		"glance": lerpf(0.05, 0.22, 1.0 - conf),                 # share of looks that drop away (down, aside)
	}
	var tone_v := lerpf(0.93, 1.07, _h(name, 21))
	var warm := lerpf(-0.035, 0.035, _h(name, 22))
	var skin := {
		"tint": Color(tone_v * (1.0 + warm), tone_v, tone_v * (1.0 - warm)),
		"specular": lerpf(SKIN_SPEC.x, SKIN_SPEC.y, _h(name, 23)),
		"roughness": lerpf(SKIN_ROUGH.x, SKIN_ROUGH.y, _h(name, 24)),
		"sss": lerpf(0.32, 0.48, _h(name, 25)),
		"micro": lerpf(0.12, 0.28, _h(name, 26)),
	}
	var scars: Array = []
	var first := int(_h(name, 31) * SCAR_SPOTS.size())
	for i in SCAR_BOUTS.size():
		if bouts >= int(SCAR_BOUTS[i]):
			scars.append(SCAR_SPOTS[(first + i * 2) % SCAR_SPOTS.size()])
	var club := str(f.get("club", name))
	return {
		"name": name,
		"posture": p,
		"pose": num,
		"eyes": eyes,
		"skin": skin,
		"hair": HAIR[int(_h(name, 41) * HAIR.size())],
		"trim": TRIM[int(_h(club, 42) * TRIM.size())],
		"boots": BOOTS[int(_h(name, 43) * BOOTS.size())],
		"scars": scars,
		"confidence": conf,
	}
