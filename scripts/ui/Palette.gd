extends RefCounted
## S493 ONE PALETTE (operator Q-251: "i have no idea , do it and i will judge"; the S490 census in
## ops/AgentComms/board_attach/Q-S294-251_2_README.md). Every screen colour comes from here: 19 colours picked from the main
## gym screen (his S430 rule: the gym is the master look), named by JOB, plus 3 shade rules, the button-state multipliers,
## the band table and the move-tier table. Wood, slate, planks and buttons stay WoodKit textures, never a colour.
## No other menu or HUD script writes a colour value: tests/palette_guard_test.gd counts them and only lets the count fall.

# --- surfaces -------------------------------------------------------------------------------------------------------
const PAGE := Color("#1a1512")      # 1 page, top bar, sunk slot; every empty bar track and pip slot
const CARD := Color("#242728")      # 2 a card's slate
const TILE := Color("#353635")      # 3 a tile or row inside a card
const HOVER := Color("#2b241d")     # 4 a hover card or a message
const WOOD := Color("#4c362a")      # 5 the wood frame's base (on screen the frame is the texture)
const LINE := Color("#4c4b45")      # 6 tile edges and the rim of a track - decoration only

# --- words ----------------------------------------------------------------------------------------------------------
const TEXT := Color("#eee2ce")      # 7 words and numbers
const MUTED := Color("#b1a084")     # 8 quieter words
const HEADER := Color("#e6bd55")    # 9 card titles, money, the 0-100 ring - words only, never a fill
const ACCENT := Color("#6fa0e6")    # 10 your side and your edits - never selection
const GOOD := Color("#2cb56f")      # 11 gained / good, as WORDS (always with + or a rising mark)
const BAD := Color("#ff7a66")       # 12 lost / bad, as WORDS (always with - or a falling mark)
const WARN := Color("#cf9245")      # 14 needs you / a limit is close (always with the warning mark); dark text on it

# --- buttons and choice ---------------------------------------------------------------------------------------------
const ACTION := Color("#991d1c")    # 13 the one button a card wants pressed (Hire, Sign, Book, CONTINUE)
const SECOND := Color("#442f24")    # 15 a second button (dark wood)
const CHOSEN := Color("#c8a585")    # 16 what you are on: a tan tab, or a 3 px tan edge plus a tick corner

# --- fills ----------------------------------------------------------------------------------------------------------
const GOOD_FILL := Color("#239058") # 17 a good bar or fill
const BAD_FILL := Color("#df4639")  # 18 a bad bar or fill
const ELITE := Color("#b08eea")     # 19 the top band

## Nothing: a see-through black (Color.TRANSPARENT is see-through WHITE, which fringes when tweened or blended).
const CLEAR := Color(0, 0, 0, 0)

## Words drawn ON a light fill (the amber warning, the tan chosen tab).
const ON_LIGHT := PAGE

# --- the fight's two corners (one each, family J) --------------------------------------------------------------------
const RED_CORNER := BAD_FILL
const BLUE_CORNER := ACCENT

# --- shade rules (the only colours not in the list: each is made from a token) ---------------------------------------
const SHADOW_A := 0.6
const DIM_A := 0.5
const SINK_T := 0.4
## The gym photo darkened behind a dark page (a modulate multiplier, not a colour on screen).
const WALL_DARK := Color(0.30, 0.28, 0.27)
## Button states, WoodKit's own multipliers.
const HOVER_MUL := 1.18
const PRESS_MUL := 0.78
const DISABLED_A := 0.42


static func shadow() -> Color:
	return Color(PAGE, SHADOW_A)


static func dim() -> Color:
	return Color(PAGE, DIM_A)


## A token pressed in or recessed (the hatched "0 to +2" stripe, a pressed state).
static func sunk(c: Color) -> Color:
	return c.lerp(PAGE, SINK_T)


## A token at a given see-through (a glass plate, a faded line).
static func alpha(c: Color, a: float) -> Color:
	return Color(c, a)


## A see-through multiplier for modulate (a dimmed photo, a faded card): white at alpha a.
static func fade(a: float) -> Color:
	return Color(1.0, 1.0, 1.0, a)


## The button multipliers on a tint.
static func hovered(c: Color) -> Color:
	return Color(c.r * HOVER_MUL, c.g * HOVER_MUL, c.b * HOVER_MUL, c.a)


static func pressed(c: Color) -> Color:
	return Color(c.r * PRESS_MUL, c.g * PRESS_MUL, c.b * PRESS_MUL, c.a)


static func disabled(c: Color) -> Color:
	return Color(c, c.a * DISABLED_A)


# --- bands: the same values, low to high, everywhere (attributes, move tiers, body bands) ---------------------------
## [name, colour, pips lit]. Every lit pip has a 1 px PAGE outline; an empty pip is sunk PAGE with a LINE rim.
const BANDS := [["Weak", BAD_FILL, 1], ["Fair", WARN, 2], ["Solid", ACCENT, 3], ["Strong", GOOD_FILL, 4], ["Elite", ELITE, 5]]
## A move's tier on the same steps (Unlearned = no pips).
const TIERS := {"Raw": WARN, "Usable": ACCENT, "Sharp": GOOD_FILL, "Signature": ELITE}


## The band's colour by its index 0..4 (Weak..Elite).
static func band(i: int) -> Color:
	var row: Array = BANDS[clampi(i, 0, BANDS.size() - 1)]
	return row[1]


static func band_named(name: String) -> Color:
	for row in BANDS:
		if str(row[0]) == name:
			return row[1]
	return MUTED


static func tier(name: String) -> Color:
	return TIERS.get(name, MUTED)


## Gain or loss words by sign (zero reads muted).
static func signed(v: float) -> Color:
	return GOOD if v > 0.0 else (BAD if v < 0.0 else MUTED)


## The 19 by job, for the palette sheet and the guard's self-check.
static func all() -> Dictionary:
	return {"page": PAGE, "card": CARD, "tile": TILE, "hover": HOVER, "wood": WOOD, "line": LINE, "text": TEXT,
		"muted": MUTED, "header": HEADER, "accent": ACCENT, "good": GOOD, "bad": BAD, "action": ACTION, "warn": WARN,
		"second": SECOND, "chosen": CHOSEN, "good_fill": GOOD_FILL, "bad_fill": BAD_FILL, "elite": ELITE}
