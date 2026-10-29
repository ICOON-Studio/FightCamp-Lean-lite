extends RefCounted
## S263 LOOK A/B (Maria S262, research/ASK_LOOK_MARIA_S262_MARIA.md): MetaHuman skin presets per skin tone + the broadcast
## light pass, as four looks the operator picks between on stills from the fight camera.
##   A = today (mh_skin.gdshader defaults)       B = skin presets + roughness limiter, micro pores off
##   C = B + broadcast light pass (VenueRig)     D = C + late-round sweat 0.85
## Pure: every input passed in. DEFAULT_LOOK is what the game plays; `look=<A..D>` on a still tool's command line overrides
## it for the A/B sheet only. When the operator picks, DEFAULT_LOOK becomes his pick.

const DEFAULT_LOOK := "A"
const LOOKS := ["A", "B", "C", "D"]

## Godot: F0 = 0.16 * specular^2; real skin F0 ~0.028 -> specular 0.42 (the 0.5 default reads as plastic).
const SKIN_SPECULAR := 0.42


static func look_from(args: PackedStringArray, fallback: String = DEFAULT_LOOK) -> String:
	for arg in args:
		if str(arg).begins_with("look="):
			var v: String = str(arg).substr(5).to_upper()
			if v in LOOKS:
				return v
	return fallback


## Relative luminance of an sRGB skin colour (0 = black .. 1 = white): picks the tone band.
static func tone_luma(c: Color) -> float:
	var lin := c.srgb_to_linear()
	return 0.2126 * lin.r + 0.7152 * lin.g + 0.0722 * lin.b


## Light / medium / dark preset by luminance (Maria's tables; medium sits between): dark skin is shaped by its highlights
## (tighter roughness, less scatter, a bit more rim against the dark house), light skin by its soft falloff.
## Returns the mh_skin.gdshader uniforms. Look A returns {} (shader defaults = today's look).
static func skin_uniforms(look: String, luma: float, sweat: float = 0.0) -> Dictionary:
	if look == "A":
		return {}
	var t: float = clampf(inverse_lerp(0.05, 0.30, luma), 0.0, 1.0)  # 0 = dark band, 1 = light band
	var rough_dry: float = lerpf(0.48, 0.55, t)
	var rough_wet: float = lerpf(0.40, 0.45, t)
	var s: float = clampf(sweat, 0.0, 1.0)
	return {
		"specular_v": SKIN_SPECULAR,
		"roughness_v": lerpf(rough_dry, rough_wet, s),
		"sss_strength": lerpf(0.30, 0.45, t),
		"micro_strength": 0.0,
		"clearcoat_v": lerpf(lerpf(0.12, 0.10, t), 0.50, s),
		"clearcoat_rough_v": lerpf(0.35, 0.18, s),
		"rim_v": lerpf(0.20, 0.15, t),
		"rim_tint_v": lerpf(0.5, 0.6, t),
		"sheen": 0.0,
	}


static func sweat_for(look: String) -> float:
	return 0.85 if look == "D" else 0.0


static func broadcast_light(look: String) -> bool:
	return look == "C" or look == "D"


## Screen-space roughness limiter (Maria: the main fix for highlight shimmer on small distant shapes).
static func roughness_limiter(look: String) -> Dictionary:
	if look == "A":
		return {}
	return {"enabled": true, "amount": 0.25, "limit": 0.18}
