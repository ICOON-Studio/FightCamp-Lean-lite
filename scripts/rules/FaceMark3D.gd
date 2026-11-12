extends RefCounted
## FACE3D1: pure stepped face-mark descriptions for later 3D presentation.

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BandWords := preload("res://scripts/rules/BandWords.gd")   # DEFECTS1: the result page's words, one table

const SPOTS: Dictionary = {
	"brow_l": "boxer's left brow",
	"brow_r": "boxer's right brow",
	"eye_l": "boxer's left eye",
	"eye_r": "boxer's right eye",
	"nose_bridge": "nose bridge",
	"nose_tip": "nose tip",
}

const EYE_PLACES: Array = ["right_eye", "left_eye"]
const EYE_STEPS: Array = [0.0, 0.45, 0.75, 1.0]
const EYE_SIZES: Array = [0.0, 0.030, 0.036, 0.042]
const NOSE_SIZES: Array = [0.0, 0.024, 0.028, 0.032]


static func steps(v: float) -> int:
	if v > BodyMap.HURT:
		return 0
	if v > BodyMap.CRITICAL:
		return 1
	if v > BodyMap.DOCTOR:
		return 2
	return 3


static func specs(vals: Dictionary, side: Dictionary) -> Array:
	var out: Array = []
	var cuts: Dictionary = side.get("cuts", {})
	var closed: Dictionary = side.get("closed", {})
	for place_value in EYE_PLACES:
		var place: String = str(place_value)
		var v: float = float(vals.get(place, 100.0))
		var eye_spot: String = "eye_l" if place == "left_eye" else "eye_r"
		if bool(closed.get(place, false)):
			out.append(
				{
					"kind": "shut",
					"place": place,
					"spot": eye_spot,
					"step": 3,
					"k": 1.0,
					"size_m": 0.042
				}
			)
		elif steps(v) > 0:
			var step: int = steps(v)
			out.append(
				{
					"kind": "swell",
					"place": place,
					"spot": eye_spot,
					"step": step,
					"k": float(EYE_STEPS[step]),
					"size_m": float(EYE_SIZES[step])
				}
			)
		if bool(cuts.get(place, false)):
			# The game has no "treated cut" state yet, so every represented cut is bleeding.
			var brow: String = "brow_l" if place == "left_eye" else "brow_r"
			out.append(
				{
					"kind": "cut",
					"place": place,
					"spot": brow,
					"step": 3,
					"k": 1.0,
					"size_m": 0.022,
					"bleeding": true
				}
			)
	var nose_value: float = float(vals.get("nose", 100.0))
	var nose_step: int = steps(nose_value)
	if nose_step > 0:
		out.append(
			{
				"kind": "nose",
				"place": "nose",
				"spot": "nose_bridge",
				"step": nose_step,
				"k": float(EYE_STEPS[nose_step]),
				"size_m": float(NOSE_SIZES[nose_step])
			}
		)
	if bool(cuts.get("nose", false)):
		# The game has no "treated cut" state yet, so every represented cut is bleeding.
		out.append(
			{
				"kind": "cut",
				"place": "nose",
				"spot": "nose_bridge",
				"step": 3,
				"k": 1.0,
				"size_m": 0.022,
				"bleeding": true
			}
		)
	return out


static func lids(vals: Dictionary, side: Dictionary) -> Dictionary:
	var closed: Dictionary = side.get("closed", {})
	var result: Dictionary = {}
	for place_value in EYE_PLACES:
		var place: String = str(place_value)
		var side_name: String = "left" if place == "left_eye" else "right"
		var v: float = float(vals.get(place, 100.0))
		var amount: float = float([0.0, 0.25, 0.50, 0.70][steps(v)])
		if bool(closed.get(place, false)):
			amount = 1.0
		result[side_name] = amount
	return result


static func changed(before: Array, after: Array) -> Array:
	var out: Array = []
	for after_value in after:
		var current: Dictionary = after_value
		var kind: String = str(current.get("kind", ""))
		var family: String = "eye" if kind == "swell" or kind == "shut" else kind
		var place: String = str(current.get("place", ""))
		var found: bool = false
		for before_value in before:
			var old: Dictionary = before_value
			var old_kind: String = str(old.get("kind", ""))
			var old_family: String = (
				"eye" if old_kind == "swell" or old_kind == "shut" else old_kind
			)
			if str(old.get("place", "")) == place and old_family == family:
				found = true
				if old_kind != kind or int(old.get("step", 0)) != int(current.get("step", 0)):
					out.append(current)
				break
		if not found:
			out.append(current)
	return out


static func summary(vals: Dictionary, side: Dictionary) -> String:
	var entries: Array = []
	var cuts: Dictionary = side.get("cuts", {})
	var closed: Dictionary = side.get("closed", {})
	for place_value in ["left_eye", "right_eye", "nose"]:
		var place: String = str(place_value)
		var v: float = float(vals.get(place, 100.0))
		var step: int = steps(v)
		var location: String = (
			"left eye" if place == "left_eye" else "right eye" if place == "right_eye" else "nose"
		)
		if place == "nose":
			if step > 0:
				entries.append({"priority": step, "text": "nose " + BandWords.word(v)})
		else:
			if bool(closed.get(place, false)):
				entries.append({"priority": 4, "text": location + " shut"})
			elif step > 0:
				entries.append({"priority": step, "text": location + " " + BandWords.word(v)})
		if bool(cuts.get(place, false)):
			var cut_text: String = (
				"cut over the " + location if place != "nose" else "cut on the nose"
			)
			entries.append({"priority": 3, "text": cut_text})
	# Stable descending severity sort keeps boxer-left before boxer-right when levels tie.
	for i in range(entries.size()):
		for j in range(i + 1, entries.size()):
			var first: Dictionary = entries[i]
			var second: Dictionary = entries[j]
			if int(second["priority"]) > int(first["priority"]):
				entries[i] = second
				entries[j] = first
	var words: Array = []
	for item in entries:
		var entry: Dictionary = item
		words.append(str(entry["text"]))
	if words.is_empty():
		return ""
	var result: String = ", ".join(words)
	return result.substr(0, 1).to_upper() + result.substr(1)


## DEFECTS1: the corner card's line under her figure - what her face shows, in the result page's words. A pro corner's
## cutman has nothing to do when this runs (no cut, no eye at HURT), so he waits; an amateur corner has no cutman at all
## and states the marks only.
static func corner_line(vals: Dictionary, side: Dictionary, pro: bool) -> String:
	var said := summary(vals, side)
	if said == "":
		said = "No cut, no swollen eye"
	return said + (": the cutman waits." if pro else ".")
