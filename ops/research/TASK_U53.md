# TASK U53 — CURSOR — THE BLIND CONTRACT TEST FOR THE MATERIAL LAYER

Model: Composer, medium effort. Owner: cursor.
Test tier: **NEW TEST FILE ONLY** — parse gate, then that ONE test. Nothing else.
A new test file cannot break another test; **do not run the full suite.**

## Owned files

- `Godot/tests/ui_material_test.gd` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit `Godot/scripts/UIKit.gd`, `Godot/scripts/UITokens.gd`,
`HANDOFF.md`, or any other test.

## THIS IS A BLIND TEST. READ THE CONTRACT BELOW AND NOTHING ELSE.

**DO NOT OPEN `Godot/scripts/UIKit.gd` OR `Godot/scripts/UITokens.gd`.** Write the
test from the contract in this file. A test written against an implementation
only ever agrees with it.

## Why this exists

Our interface kit built every surface from ONE recipe, so twelve cards on a
screen weighed exactly the same and no screen had a focal point. A material and
elevation layer has just landed centrally: five named tiers, a fill that lifts
toward white as a surface rises, a rim that catches light instead of a dark
outline, and a track that is genuinely cut INTO the panel.

It reaches all 28 kit screens through two functions with 140 call sites between
them. Nothing in the suite asserts any of it. The failure mode is silent and
ugly: a tier ladder that stops being monotonic, or a groove that starts casting
a shadow upward, and every screen in the game inherits it.

## THE CONTRACT

Both scripts are `RefCounted` with **static** functions. `load()` them and call
the statics off the loaded script — do not instantiate.

```gdscript
var T = load("res://scripts/UITokens.gd")
var K = load("res://scripts/UIKit.gd")
```

Note the GDScript trap this codebase hits every stage: a static called on a
`load()`ed script returns Variant, so `var x := K.something()` fails to infer.
Write the type: `var style: StyleBoxFlat = K.raised_style(...)`.

### `UITokens.gd` — the ladder

```gdscript
const SUNK := -1
const FLUSH := 0
const RESTING := 1
const LIFTED := 2
const HERO := 3

static func elevation(level: int) -> Dictionary
static func lift(base: Color, level: int) -> Color
static func rim_color(base: Color, level: int, tint: Color = Color(1, 1, 1, 1)) -> Color
```

`elevation(level)` returns a Dictionary with exactly these seven keys:
`lift` (float), `shadow` (int), `shadow_alpha` (float), `shadow_y` (int),
`rim` (float), `light` (float), `shade` (float).

### `UIKit.gd` — the primitives

```gdscript
static func raised_style(bg: Color, radius: int = 3, shadow: int = -1, edge: Color = T.EDGE, level: int = T.RESTING) -> StyleBoxFlat
static func light_overlay(size: Vector2, strength: float = 0.16, shade: float = -1.0) -> TextureRect
static func block(size: Vector2, bg: Color, radius: int = 3, light: float = -1.0, level: int = T.RESTING) -> Panel
static func surface(size: Vector2, bg: Color, level: int, radius: int = 3) -> Panel
static func track_style(radius: int = 2) -> StyleBoxFlat
static func track(size: Vector2, radius: int = 2) -> Panel
```

## WHAT TO ASSERT

**Assert ORDERING AND RELATIONSHIPS, never the exact numbers.** The figures are
being tuned against published elevation research; a test that pins `lift` at
0.045 will be stale within the week and someone will then be tempted to edit it.
`elevation(HERO).lift > elevation(RESTING).lift` stays true forever. This is the
single most important instruction in this file.

### 1. The tiers
- The five constants equal -1, 0, 1, 2, 3 and are strictly increasing.

### 2. `elevation()`
- For every level `SUNK..HERO`: the result has all seven keys, and each value is
  the declared type.
- `lift` is **strictly increasing** across FLUSH → RESTING → LIFTED → HERO.
- `elevation(SUNK).lift` is **negative**; `elevation(FLUSH).lift` is **exactly 0.0**.
- `shadow` is **0** at SUNK and at FLUSH. It is **non-decreasing** RESTING →
  LIFTED → HERO, and `elevation(HERO).shadow > elevation(RESTING).shadow`.
- `rim` and `light` are both **non-decreasing** FLUSH → RESTING → LIFTED → HERO.
- Out of range **clamps**: `elevation(-99) == elevation(SUNK)` and
  `elevation(99) == elevation(HERO)`.
- **It returns a COPY.** Fetch `elevation(HERO)`, write a junk value into it,
  fetch `elevation(HERO)` again, and assert the second call is unaffected. A
  shared Dictionary handed out here would let any caller corrupt the ladder for
  the whole process.

### 3. `lift()`
- `lift(c, FLUSH)` equals `c`.
- `lift(c, HERO)` is strictly LIGHTER than `c`, and `lift(c, LIFTED)` sits
  between them. Compare with `Color.get_luminance()`.
- `lift(c, SUNK)` is strictly DARKER than `c`.
- **Alpha is preserved.** Pass a colour with `a = 0.5` and assert the result's
  alpha is still 0.5 at every tier. Our glass panels depend on this.

### 4. `rim_color()`
- At a tier whose `rim` is 0 (SUNK), it returns `T.EDGE` — the dark outline.
- At HERO, the returned alpha equals `elevation(HERO).rim`, and the rgb is the
  `tint`'s rgb. Pass a distinctive tint (say pure red) and assert r/g/b came from
  the tint and not from `base`.

### 5. `raised_style()` — the defaults
- Returns a `StyleBoxFlat`.
- `bg_color == T.lift(bg, RESTING)`.
- `border_color == T.rim_color(bg, RESTING)`, and all four border widths are 1.
- `shadow_size == elevation(RESTING).shadow`, and `shadow_offset.y ==
  elevation(RESTING).shadow_y`.
- All four corner radii equal the `radius` passed.

### 6. `raised_style()` — the two escape hatches
- `raised_style(bg, 4, 9)` gives `shadow_size == 9`. An explicit non-negative
  shadow overrides the tier.
- `raised_style(bg, 4, -1, Color.RED)` gives `border_color == Color.RED`. An edge
  the caller chose is kept instead of the rim.
- `raised_style(bg, 4, -1, T.EDGE, T.HERO)` has a strictly lighter `bg_color` and
  a strictly larger `shadow_size` than the same call at `T.RESTING`.

### 7. `light_overlay()` — the material
- Returns a `TextureRect` whose `mouse_filter` is `Control.MOUSE_FILTER_IGNORE`.
  It must never eat a click.
- Its texture is a `GradientTexture2D` filling **vertically** (`fill_from.y` is 0
  and `fill_to.y` is 1, i.e. top to bottom, not left to right).
- The gradient's **first** colour is near-white with `a > 0`, and its **last**
  colour is near-black with `a > 0`. Sheen at the top, shade at the bottom: that
  pair is the whole effect, and a gradient that ran white-to-transparent (what it
  used to do) would pass a weaker test while looking flat.
- `light_overlay(size, 0.2, 0.0)` gives a last-colour alpha of **0.0** — an
  explicit `shade` of zero turns the bottom shade off.

### 8. `block()` and `surface()`
- `block(Vector2(80, 40), T.PANEL)` returns a `Panel` whose `size` and
  `custom_minimum_size` are both that size, and which HAS a child named `Light`.
- `block(Vector2(80, 40), T.PANEL, 3, 0.0)` has **no** `Light` child — an
  explicit zero still means "no sheen".
- `surface(size, bg, T.HERO)`'s stylebox `bg_color == T.lift(bg, T.HERO)`, and is
  strictly lighter than `surface(size, bg, T.RESTING)`'s.

### 9. `track()` — the groove
This is the one with a direction, and getting it backwards is invisible in code
and obvious on screen.
- Returns a `Panel` named `Track` with **no children at all** — the caller adds
  the fill as a child immediately afterwards, so anything the factory added would
  be buried under it.
- Its stylebox `bg_color` is strictly DARKER than `T.TRACK`.
- Its `shadow_color` is **light** (r, g, b all above 0.5) with `a > 0`, and its
  `shadow_offset.y` is **positive**. A channel cut into a surface throws a catch
  of light along its lower lip; it does not cast a dark shadow.
- `track_style(7)` gives all four corner radii equal to 7.

### 10. The compatibility invariant
The 140 existing call sites pass the old argument lists. Assert that
`raised_style(T.PANEL)`, `raised_style(T.PANEL, 4)`, `raised_style(T.PANEL, 4, 6)`,
`block(Vector2(10, 10), T.PANEL)` and `block(Vector2(10, 10), T.PANEL, 4, 0.16)`
all still return the right type without error.

## The gate

```
python Godot/tools/check_scripts.py Godot/tests/ui_material_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ui_material_test.gd
```

Print one final line: `UI_MATERIAL checks=N failures=M`. Print a line per
failure saying which assertion and what the two values were.

## Definition of done

- The test exists, runs headless, and reports `failures=0`.
- **A ceiling, not an exact count: `failures=0` is the target. If an assertion
  genuinely fails, do NOT edit the assertion to make it pass** — report it. You
  are the blind half of a two-part contract and a disagreement is the finding.
- Commit, push, and send one line:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U53-done --body "<sha> checks=N failures=M"`

## The trap specific to U53

**Do not assert a single exact figure from the ladder.** Not one. Every numeric
assertion in this file is a comparison between two tiers or a structural fact
(a key exists, an alpha is preserved, an offset is positive). The figures are
being tuned right now against MD3's published dark-theme surface values, and the
last stage in this repo burned a pass on five assertions that pinned a number
which was true on the day it was written. Write invariants.
