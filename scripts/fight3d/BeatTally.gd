extends RefCounted
## S435 (ANIM_AUDIT_S435 A8): what each punch beat really got, counted where the fight fires it (BeatFire._punch).
## Before this nothing said how often a punch fell back to its plain take, was armed at a guessed contact time, was
## refused, or flew with no aim. A brief's before / after reads line(); a seat's change must keep `started` near main's.
##   asked            punch beats that reached BeatFire
##   take_plain       no special take was wanted (a plain punch) and a plain take played
##   take_context     a big / miss / tired / stepping take was wanted and played
##   take_fallback    one was wanted and the plain take played instead (switched off, or not on disk)
##   take_native      an old native clip or the bare move name played (should be 0)
##   contact_guess    the clip has no measured contact time: the hit timer runs on a guess
##   started / refused   the clip really started / the boxer was locked in a reaction and nothing showed
##   aim_land / aim_block / aim_height / aim_none   which aim the started punch got
## Static and cumulative: reset() at the start of a measurement, line() at its end.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const KEYS: Array[String] = ["asked", "take_plain", "take_context", "take_fallback", "take_native", "contact_guess",
	"started", "refused", "aim_land", "aim_block", "aim_height", "aim_none"]

static var n: Dictionary = {}
static var fallbacks: Dictionary = {}   # "move>clip" -> count, for take_fallback and take_native only


static func reset() -> void:
	n = {}
	fallbacks = {}


static func add(key: String) -> void:
	n[key] = int(n.get(key, 0)) + 1


static func count(key: String) -> int:
	return int(n.get(key, 0))


## Which kind of take `clip` is for beat `move` thrown in `ctx` (BeatClips.punch's ctx): plain / context / fallback / native.
static func kind(move: String, ctx: Dictionary, clip: String) -> String:
	if not BeatClips.PUNCH.has(move) or not (clip.begins_with("pro_") or clip.begins_with("rk_")):
		return "native"
	if clip.begins_with("rk_"):   # the captured take is the wanted one for a plain or stepping jab / cross
		return "plain"
	var stem := "pro_" + str(BeatClips.PUNCH[move][0])
	var plain_names: Array = [stem]
	for suffix in (BeatClips.PUNCH[move][1] as Array):
		plain_names.append(stem + str(suffix))
	var wanted := bool(ctx.get("big", false)) or bool(ctx.get("miss", false)) or bool(ctx.get("tired", false)) or bool(ctx.get("step", false))
	var is_plain := plain_names.has(clip)
	if not wanted:
		return "plain" if is_plain else "context"
	return "fallback" if is_plain else "context"


## Counts one punch beat's take and contact data. Called once per punch beat, before it starts.
static func take(move: String, ctx: Dictionary, clip: String) -> void:
	add("asked")
	var k := kind(move, ctx, clip)
	add("take_" + k)
	if k == "fallback" or k == "native":
		var key := "%s>%s" % [move, clip]
		fallbacks[key] = int(fallbacks.get(key, 0)) + 1
	if BeatClips.contact(clip, -1.0) < 0.0:
		add("contact_guess")


static func line() -> String:
	var parts: Array = []
	for k in KEYS:
		parts.append("%s=%d" % [k, count(k)])
	return "BEAT_TALLY " + " ".join(parts)


## The fallbacks by move and clip, most frequent first: "cross>pro_cross_v2 x12, ...".
static func fallback_line() -> String:
	var keys: Array = fallbacks.keys()
	keys.sort_custom(func(a, b): return int(fallbacks[a]) > int(fallbacks[b]))
	var parts: Array = []
	for k in keys:
		parts.append("%s x%d" % [k, int(fallbacks[k])])
	return "BEAT_FALLBACKS " + (", ".join(parts) if not parts.is_empty() else "none")
