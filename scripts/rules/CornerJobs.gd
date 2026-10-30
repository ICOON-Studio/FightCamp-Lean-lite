extends RefCounted
## S310 the corner minute's four jobs (operator: "the player needs a lot more to select during the corner time [...] maybe
## add a mechanism to unlock a combo the fighter to knock the opponent"; plan approved Q-S294-20 "Yes, build it",
## Game Godot/research/S310_CORNER_MINUTE_PLAN.md). Besides the plan (Exchanges.CALLS) and the habit fix (HabitFix):
##   RECOVER - the second's 3 points: water (energy, more when she is tired), ice on the ribs (body hits back), clear her
##             head (only when she is hurt at the bell; else she starts the round hurt).
##   SET-UP  - one of HER combinations (learned on the pads: no combination, no set-up) aimed at a gap - a game the
##             opponent plays. When an exchange shows that game the shout bar offers "NOW!"; fired into the gap it is a
##             big edge and head damage (the knockdown roll reads it); fired into the wrong game it costs her.
##   TALK    - calm her / fire her up / tell her the truth, read off her personality.
## Numbers are game-design values tuned by tools/exchange_balance.gd, not measurements. Pure static; zero preloads.

const RECOVER_POINTS := 3
## Energy a water point gives back; more when she comes back tired (under Combos.WEARY_AT).
const WATER_FRESH := 3.0
const WATER_TIRED := 6.0
const WEARY_AT := 40.0
## Body hits taken back per ice point (each is Exchanges.BODY_COST energy for the rest of the fight).
const ICE_HITS := 3
## A set-up fired into its gap: this edge x (0.5 + mastery / 200), x0.6 when she is weary; fired into another game it
## costs SETUP_MISS. A set-up that wins its exchange adds SETUP_DAMAGE to the opponent's head damage (Knockdowns).
const SETUP_EDGE := 14.0
const SETUP_MISS := -9.0
const SETUP_DAMAGE := 30.0
## Gaps the corner can wait for: the opponent's two main games (her style) and her tiring.
const GAP_WORDS := {"press": "when she presses", "range": "when she boxes at range", "counter": "when she waits to counter",
	"loadup": "when she loads up", "tiring": "when she tires"}

const TALKS := {
	"calm": {"label": "Calm her down", "line": "Breathe. Your fight, your pace."},
	"fire": {"label": "Fire her up", "line": "You want this more than she does. Go take it!"},
	"truth": {"label": "Tell her the truth", "line": "You're losing the exchanges. Do what I tell you or this is gone."},
}


## The recover menu for the bell: [{id, label, line, max}] - "head" only when she is hurt.
static func recover_options(energy: float, body_taken: int, hurt: bool) -> Array:
	var out: Array = [
		{"id": "water", "label": "Water and breathing", "line": "+%d energy a point" % int(WATER_TIRED if energy < WEARY_AT else WATER_FRESH), "max": RECOVER_POINTS},
		{"id": "ice", "label": "Ice on the ribs", "line": "-%d body hits a point" % ICE_HITS, "max": mini(RECOVER_POINTS, int(ceil(body_taken / float(ICE_HITS))))},
	]
	if hurt:
		out.append({"id": "head", "label": "Clear her head", "line": "She starts the round not hurt (1 point)", "max": 1})
	return out


## What the points do. points = {water, ice, head}; more than RECOVER_POINTS in all are cut, head first kept.
## Returns {energy (+), body (hits taken back), hurt (still hurt at the next bell), used}.
static func recover(points: Dictionary, energy: float, body_taken: int, hurt: bool) -> Dictionary:
	var left := RECOVER_POINTS
	var head := mini(1, int(points.get("head", 0))) if hurt else 0
	left -= head
	var ice := clampi(int(points.get("ice", 0)), 0, left)
	left -= ice
	var water := clampi(int(points.get("water", 0)), 0, left)
	var per := WATER_TIRED if energy < WEARY_AT else WATER_FRESH
	return {"energy": water * per, "body": mini(body_taken, ice * ICE_HITS), "hurt": hurt and head == 0, "used": head + ice + water}


## The gaps the corner can set a combination up for, against an opponent of this style (Exchanges.STYLE_MODES weights).
static func gaps(style_weights: Dictionary) -> Array:
	var keys: Array = style_weights.keys()
	keys.sort_custom(func(a, b): return float(style_weights[a]) > float(style_weights[b]))
	var out: Array = keys.slice(0, 2)
	if not out.has("tiring"):
		out.append("tiring")
	return out


## Her combinations a set-up can use: {id: mastery} from f["combos"] at or above learn_at.
static func setups(combos: Dictionary, learn_at: float) -> Array:
	var out: Array = []
	for k in combos.keys():
		if float(combos[k]) >= learn_at:
			out.append(str(k))
	out.sort_custom(func(a, b): return float(combos[a]) > float(combos[b]))
	return out


## S313 (Ziva: the coach's plan left the opponent hurt, so the set-up armed for "when she presses" never got its NOW):
## a hurt opponent is every set-up's gap - the drilled combination is what a corner shouts NOW for when she is hurt.
static func fits(gap: String, sit: String) -> bool:
	return sit == gap or sit == "hurt"


## The edge of firing the set-up. fits = the exchange's real game is the gap; mastery 0..100; energy hers now.
static func setup_edge(fits: bool, mastery: float, energy: float) -> float:
	if not fits:
		return SETUP_MISS
	return SETUP_EDGE * (0.5 + clampf(mastery, 0.0, 100.0) / 200.0) * (0.6 if energy < WEARY_AT else 1.0)


## The talk for the next round, read off her personality (FighterProfile.TRAITS, 0..100). Returns {edge (power points
## an exchange), cost (energy an exchange), hurt (x her chance of being hurt), line}.
static func talk(kind: String, p: Dictionary) -> Dictionary:
	var temper := float(p.get("temper", 50.0))
	var confidence := float(p.get("confidence", 50.0))
	var discipline := float(p.get("discipline", 50.0))
	match kind:
		"calm":
			# A hothead needed it; a calm one just slows down.
			return {"edge": 1.0 if temper >= 65.0 else 0.0, "cost": -0.4, "hurt": 0.6, "line": TALKS["calm"]["line"]}
		"fire":
			# A flat, unsure fighter lifts most; a hothead gets wild.
			var e := 2.0 if confidence < 50.0 else 1.5
			return {"edge": e - (2.0 if temper >= 65.0 else 0.0), "cost": 0.8, "hurt": 1.6 if temper >= 65.0 else 1.3, "line": TALKS["fire"]["line"]}
		"truth":
			# A disciplined fighter uses it; a fragile one sinks.
			var t := 1.2 if discipline >= 60.0 else 0.3
			return {"edge": t - (2.0 if confidence < 45.0 else 0.0), "cost": 0.0, "hurt": 1.0, "line": TALKS["truth"]["line"]}
	return {"edge": 0.0, "cost": 0.0, "hurt": 1.0, "line": ""}
