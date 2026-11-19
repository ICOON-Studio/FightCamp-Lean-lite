extends RefCounted
## FIGHTPLAYER2 phase 1 (S512, ops/research/FIGHTPLAYER2_SCOPE_S510.md 3c + phase 1): the clip census's rules, pure (no
## scene). tools/clip_census.gd measures every owned take raw on our body (as bought: own hip travel, no fight layer) and
## writes assets/data/clip_db.json; this module says which takes the fight PLAYS (read straight off BeatClips' own
## pickers, so a pool edit there shows up here), what family and form each take is, and which takes the census drops
## and why. tests/clip_db_test.gd holds the table to it; the choreographer (phase 2) reads the rows through it.
##
## Words: a ROW is one take's measures. contact_gap_m = the pelvis-to-pelvis distance at which the take's glove front is
## as deep as the other man's face (ribs for a body shot) while on his line - the distance the take is FOR (scope 3c:
## pick the take within FIT_M of the planned gap). miss_m = how far outside the head (the trunk) the glove is then.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")

const DB_PATH := "res://assets/data/clip_db.json"
## Scope 3c: a take fits a planned gap when its contact gap is within this (half of Undisputed's 0.30 m arm IK budget).
const FIT_M := 0.15

## Drop bars. A dropped take never plays in v2; it goes on the fix / buy list. Straights are finished by the arm IK
## (Undisputed: up to 0.30 m), so a straight is dropped only past that budget; a hook, an uppercut or a body shot lands
## where its clip puts it.
const STRAIGHTS := ["jab", "cross"]
const MISS_MAX_STRAIGHT_M := 0.30
const MISS_MAX_M := 0.15
## A hook, an uppercut or a body shot whose glove centre is further than this (half a glove) outside the zone still
## touches nothing: kept, but flagged "lands low / high / wide" - it needs a lower target or a lift (a phase 3 call).
const TOUCH_M := 0.06
## The target zones around the aim point (FightStage.target_point: the face point sits at eye height, 7 cm over the head
## bone; the rib point 14 cm under the chest bone). Head: from the chin to the brow, half a head wide. Trunk: belt to chest.
const HEAD_ZONE := {"down": 0.17, "up": 0.08, "side": 0.10}
const BODY_ZONE := {"down": 0.15, "up": 0.25, "side": 0.17}
## Posture flags (scope 3c). On a reaction, a block, a defence or an idle they DROP the take; on a punch they are kept as
## flags for the eye check (an uppercut lifts the chin and the hand by its nature) and for the choreographer's body rules.
const FACE_UP_MAX_DEG := 15.0     # face tipped up more than this from where the take starts (r14: "face to the lights")
const OVER_CROWN_M := 0.10        # a hand this far above the head bone ...
const OVER_CROWN_FRAMES := 3      # ... for this many 60 Hz frames or more = a glove over the crown
const BACK_TURN_DEG := 100.0      # the PELVIS turned this far from the other man = the back to him
const FIGHT_KINDS := ["punch", "reaction", "block", "defence", "idle"]
## A reaction's size by its head travel (scope 3d: jab 8-12 cm, cross 18-25, hook 20-30; above = the big shot's).
const LIGHT_MAX_M := 0.15
const MEDIUM_MAX_M := 0.30

## Punch families by the name's stem (Punch PRO pro_<stem>[form], Starter mc_<family>).
const STEMS := {
	"left_jab": "jab", "right_cross": "cross", "left_hook": "lead_hook", "right_hook": "rear_hook",
	"left_uppercut": "lead_uppercut", "right_uppercut": "rear_uppercut", "body_shot": "body_hook", "kidney_shot": "body_hook",
}
const MC_PUNCH := {"mc_jab": "jab", "mc_cross": "cross", "mc_lead_hook": "lead_hook", "mc_rear_hook": "rear_hook",
	"mc_lead_uppercut": "lead_uppercut", "mc_rear_uppercut": "rear_uppercut"}
## What a take is, by words in its name (first match wins, so reactions before punches).
const KINDS := [
	["reaction", ["hit_by", "mc_hit_", "react_"]],
	["knockdown", ["knockout", "countdown", "knock"]],
	["win", ["win"]],
	["block", ["block"]],
	["defence", ["dodge", "weave", "slip", "pull"]],
	["idle", ["idle", "fidget", "guard"]],
	["punch", ["jab", "cross", "hook", "uppercut", "body_shot", "kidney_shot", "combo"]],
	["step", ["step", "walk", "advance", "retreat", "strafe", "loc_"]],
]
## Every key a measured row carries (the test checks them; the choreographer reads them).
const ROW_KEYS := ["kind", "length_s", "hips_fwd_m", "hips_side_m", "hips_end_m", "hips_max_m", "head_max_m",
	"face_up_deg", "over_crown_frames", "turn_deg", "pelvis_turn_deg", "knee_deg", "drop", "flags", "played"]
const PUNCH_KEYS := ["family", "form", "hand", "contact_gap_m", "miss_m", "side_m", "up_m", "contact_s",
	"glove_y_m", "own_head_y_m", "hips_at_contact_m", "head_fwd_m", "start_s", "home_s"]
const REACT_KEYS := ["head_peak_m", "head_peak_s", "head_dir", "head_rel_m", "head_rel_s", "back_s", "size"]


static func kind(clip: String) -> String:
	for k in KINDS:
		for w in k[1]:
			if clip.contains(str(w)):
				return str(k[0])
	return "other"


## [family, form] of a punch take ("" family for a combination or a non-punch). form: "plain" / "a" / "b" / "c" / "v2" /
## "ft" (a stepping take) / "hard" / "hard_ft" / "special" / "miss" / "hurt" / "hurt_ft".
static func family(clip: String) -> Array:
	if MC_PUNCH.has(clip):
		return [MC_PUNCH[clip], "plain"]
	if not clip.begins_with("pro_") or clip.contains("hit_by"):
		return ["", ""]
	var rest := clip.trim_prefix("pro_")
	for stem in STEMS:
		if rest == stem or rest.begins_with(str(stem) + "_"):
			var form := rest.trim_prefix(str(stem)).trim_prefix("_")
			return [STEMS[stem], "plain" if form == "" else form]
	return ["", ""]


## Every take the shipped fight can play, read off BeatClips' own pickers with `has` (clip -> bool, the library).
static func played(has: Callable) -> Array:
	var out := {}
	var rolls := []
	for i in 17:
		rolls.append(i / 16.0)
	var ctxs := [{}, {"step": true}, {"big": true}, {"big": true, "step": true}, {"miss": true}, {"tired": true},
		{"tired": true, "step": true}]
	for move in BeatClips.PUNCH:
		for roll in rolls:
			for c in ctxs:
				var ctx: Dictionary = (c as Dictionary).duplicate()
				ctx["roll"] = roll
				out[BeatClips.punch(str(move), ctx, has)] = true
			for hurt in [false, true]:
				for big in [false, true]:
					out[BeatClips.react(str(move), hurt, has, roll, big)] = true
		for k in ["slip", "weave", "pull", "block"]:
			for from_left in [false, true]:
				for south in [false, true]:
					out[BeatClips.defence(k, str(move), from_left, south, has)] = true
	for pool in [BeatClips.TIRED, BeatClips.WIN, BeatClips.DOWN, BeatClips.OUT]:
		for roll in rolls:
			out[BeatClips.pick(pool, has, roll)] = true
	out[BeatClips.first(BeatClips.GUARD, has)] = true
	for f in GuardLife.FIDGETS:
		if has.call(str(f)):
			out[str(f)] = true
	var names: Array = []
	for n in out:
		if str(n) != "" and has.call(str(n)):
			names.append(str(n))
	names.sort()
	return names


## How far outside the target zone a glove front `side` m to the side of and `up` m above the aim point is (0 = on it).
static func zone_miss(side: float, up: float, body: bool) -> float:
	var z: Dictionary = BODY_ZONE if body else HEAD_ZONE
	var dx := maxf(0.0, absf(side) - float(z["side"]))
	var dy := maxf(0.0, maxf(-up - float(z["down"]), up - float(z["up"])))
	return Vector2(dx, dy).length()


## Whole centimetres of `m` metres, worded the same before and after a JSON round trip (28.4999 and 28.5 both read 29).
static func _cm(m: float) -> int:
	return int(floor(100.0 * m + 0.5 + 1e-6))


static func react_size(head_m: float) -> String:
	return "light" if head_m <= LIGHT_MAX_M else ("medium" if head_m <= MEDIUM_MAX_M else "heavy")


## The posture flags of a measured row (any kind).
static func flags(row: Dictionary) -> Array:
	var out: Array = []
	if not str(row.get("kind", "")) in FIGHT_KINDS:
		return out   # a man going down or celebrating has no guard to judge
	if float(row.get("face_up_deg", 0.0)) > FACE_UP_MAX_DEG:
		out.append("face tips up %d deg" % _cm(float(row["face_up_deg"]) / 100.0))
	if int(row.get("over_crown_frames", 0)) >= OVER_CROWN_FRAMES:
		out.append("glove over the crown %d frames" % int(row["over_crown_frames"]))
	if float(row.get("pelvis_turn_deg", 0.0)) > BACK_TURN_DEG:
		out.append("back to the other man (pelvis %d deg)" % _cm(float(row["pelvis_turn_deg"]) / 100.0))
	var fam := str(row.get("family", ""))
	if fam != "" and not fam in STRAIGHTS and float(row.get("miss_m", 0.0)) > TOUCH_M:
		var up := float(row.get("up_m", 0.0))
		out.append("lands %s: %d cm outside the %s" % ["low" if up < -0.05 else ("high" if up > 0.05 else "wide"),
			_cm(float(row["miss_m"])), "trunk" if fam == "body_hook" else "head"])
	return out


## Why the census drops a measured row (empty = the take may play in v2).
static func drop_reasons(clip: String, row: Dictionary) -> Array:
	var why: Array = []
	if clip in BeatClips.OFF_TAKES:
		why.append("off on score (BeatClips.OFF_TAKES)")
	var k := str(row.get("kind", ""))
	var fam := str(row.get("family", ""))
	if k == "punch" and fam != "":
		var bar := MISS_MAX_STRAIGHT_M if fam in STRAIGHTS else MISS_MAX_M
		if float(row.get("miss_m", 0.0)) > bar:
			why.append("cannot land: the glove passes %d cm outside the %s (%d cm %s the aim point)" % [_cm(float(row["miss_m"])),
				"trunk" if fam == "body_hook" else "head", _cm(absf(float(row.get("up_m", 0.0)))), "under" if float(row.get("up_m", 0.0)) < 0.0 else "over"])
	if k in FIGHT_KINDS and k != "punch":
		why.append_array(flags(row))
	return why


## The census rows of one punch family that may play, nearest contact gap to `gap` first. [] when the db has none.
static func takes_for(db: Dictionary, fam: String, gap: float) -> Array:
	var rows: Dictionary = db.get("rows", {})
	var got: Array = []
	for n in rows:
		var r: Dictionary = rows[n]
		if str(r.get("family", "")) == fam and (r.get("drop", []) as Array).is_empty():
			got.append(str(n))
	got.sort_custom(func(a, b): return absf(float(rows[a]["contact_gap_m"]) - gap) < absf(float(rows[b]["contact_gap_m"]) - gap))
	return got
