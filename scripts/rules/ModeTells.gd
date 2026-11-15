extends RefCounted
## MODETELLS1 the opponent's mode as a tell: how often film shows her in one mode (share bands), the mode her style
## word already gives away (free mode), and the order tape opens tells (tape order). Owner's ruling: Q-240 "Yes, build it"
## (the Game plan is a chart); map section DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI.md 4.1 (build row P2).
## Pure static; no preload, no class_name. The chart page (PlanChart.gd) will read these words.
##   band(films, shown) -> String        how often film shows the opponent in one mode: "often", "some", "rare", ""
##   free_mode(style) -> String          the mode the style word gives away (known with no film)
##   tape_order(style, shown, films, habits) -> Array   the order film opens tells, as ids
##   order(free, shown, habits) -> Array   the same order for a free mode already known (OppFile: the style's main game)
##   shown(mix, films) -> {mode: films it shows in}   S483: a mode with ALL_FILMS_SHARE+ of the exchanges shows in every
##       film, less in proportion (Exchanges.STYLE_MODES mix); films(bouts) = the films a coach can watch (MAX_FILMS)

const OFTEN_FILMS := 3
const OFTEN_SHARE := 0.75
const SOME_SHARE := 1.0 / 3.0
const MODES := ["press", "range", "counter", "loadup", "tiring", "hurt"]
const ALL_FILMS_SHARE := 0.4
const MAX_FILMS := 4

const FREE_MODES := {"Pressure fighter": "press", "Out-boxer": "range", "Counter-puncher": "counter",
	"Volume puncher": "press", "Boxer-puncher": ""}


## How often film shows the opponent in one mode. "" when not found (films or shown <= 0).
## "often" when 3+ films and shown in at least 3/4; "some" when shown in at least 1/3 (or films < 3, capped);
## "rare" otherwise (shown at least once). shown is clamped to [0, films].
static func band(films: int, shown: int) -> String:
	if films <= 0 or shown <= 0:
		return ""
	var s := mini(maxi(shown, 0), films)
	if films >= OFTEN_FILMS and float(s) / float(films) >= OFTEN_SHARE:
		return "often"
	if float(s) / float(films) >= SOME_SHARE:
		return "some"
	if films < OFTEN_FILMS:
		return "some"
	return "rare"


## The mode the style word gives away (known with no film). "" for a style the table does not know or Boxer-puncher.
static func free_mode(style: String) -> String:
	return str(FREE_MODES.get(style, ""))


## The order film opens tells, as ids: "weapon", then "mode:<top unfree mode>", every "habit:<id>" in the order given,
## then "mode:<second unfree mode>", then "weakness". Unfree modes = MODES minus free_mode(style); ranked by shown[mode]
## (missing = 0) high to low, a tie broken by the order of the six ids in MODES. Exactly 2 mode ids, never the free one.
static func tape_order(style: String, shown: Dictionary, films: int, habits: Array) -> Array:
	return order(free_mode(style), shown, habits)


## tape_order for a free mode the caller already knows ("" = none).
static func order(free: String, shown: Dictionary, habits: Array) -> Array:
	var unfree: Array = []
	for m in MODES:
		if m != free:
			unfree.append(m)
	var ranked := unfree.duplicate()
	ranked.sort_custom(func(a: String, b: String) -> bool:
		var sa: int = int(shown.get(a, 0))
		var sb: int = int(shown.get(b, 0))
		if sa != sb:
			return sa > sb
		return MODES.find(a) < MODES.find(b))
	var out: Array = ["weapon"]
	if ranked.size() >= 1:
		out.append("mode:" + str(ranked[0]))
	for h in habits:
		out.append("habit:" + str(h))
	if ranked.size() >= 2:
		out.append("mode:" + str(ranked[1]))
	out.append("weakness")
	return out


## How many of `films` each mode shows in, from the share of exchanges it takes (mix: mode -> share).
static func shown(mix: Dictionary, films: int) -> Dictionary:
	var out := {}
	for m in MODES:
		# A half rounds down (0.15 of 0.4 on 4 films = 1.5 -> 1), so float noise never flips a tie.
		out[m] = maxi(0, roundi(float(maxi(films, 0)) * clampf(float(mix.get(m, 0.0)) / ALL_FILMS_SHARE, 0.0, 1.0) - 0.001))
	return out


## The films a coach can watch of an opponent with `bouts` on record (at most MAX_FILMS).
static func films(bouts: int) -> int:
	return clampi(bouts, 0, MAX_FILMS)
