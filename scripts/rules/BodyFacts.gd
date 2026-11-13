extends RefCounted
## The body facts of a fighter: height (cm) and reach (cm). The opponents carry their own (Data.OPPONENTS, NationalField);
## our fighters get theirs here, from the same generator (AttrGen.body) the opponents use. Seeded by name so the same
## fighter always measures the same.

const AttrGen := preload("res://scripts/rules/AttrGen.gd")


## When the fighter has no height (or no reach), generate both from AttrGen.body with an rng seeded by the fighter's name.
## A fighter that already has the keys is never changed.
static func fill(f: Dictionary) -> void:
	if f.has("height") and f.has("reach"):
		return
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(str(f.get("name", "")))
	var sex := str(f.get("sex", "f"))
	var attr_sex := "men" if sex == "m" else sex
	var limit := float(f.get("limit", 60.0))
	var body: Dictionary = AttrGen.body(rng, attr_sex, limit)
	if not f.has("height"):
		f["height"] = body["height"]
	if not f.has("reach"):
		f["reach"] = body["reach"]
