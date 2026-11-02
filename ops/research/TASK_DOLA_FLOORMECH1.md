# TASK DOLA_FLOORMECH1 - two gym-floor mechanics as pure GDScript modules + tests (S234)

Operator S234 (verbatim): "ask dola to deliver big bunches of code". Ludo (lead designer) ranked these KEEP in round 97:
C2 Breakthrough Beat (Phase 2) and C9 Floor Event Deck incl. C3 Member Challenge (Phase 3). research/GYMFLOOR_MECHANICS_IDEAS_S234.md.
Model: Dola (Cici). Claude integrates, runs the tests, wires them on the floor.

## Prior research
- Ludo r96/r97 (research/ludo_rx/LUDO_R96_raw.txt, LUDO_R97_part1.txt): the floor is "a monitoring chore"; build decisions, not bars.
- Form Breakdown shipped S234 (scripts/rules/FormBreakdown.gd) - the STYLE to copy exactly.

## What would a human do?
A coach notices the moment a punch "clicks" and makes the call: drill it while it is fresh, or stop on a good note. A gym owner
deals with a snapped chain, a reporter at the door, a member who wants rounds - small calls with a cost either way.

## Prefab check
No asset needed; pure rules. Nothing to buy.

## Hard rules (every file)
- Godot 4 GDScript. `extends RefCounted`, STATIC functions only, ZERO preloads, NO class_name, NO autoload, NO randomness inside
  (every random roll comes in as an argument `pick: float` 0..1), deterministic.
- Typed: `var x: float = float(ctx.get("k", 0.0))` - never `var x := ctx.get(...)` (Variant inference fails). Never write `%%`.
- The engine owns the numbers: your functions RETURN multipliers, deltas and words; they never touch the game.
- Each test: `extends SceneTree`, `func _initialize() -> void:`, load the module with `load("res://scripts/rules/<Name>.gd")`,
  count failures, print `<NAME> failures=N`, then `quit(0 if failures == 0 else 1)`.

## FILE 1: scripts/rules/Breakthrough.gd (C2 "IT CLICKED")
Once a day at most, when a move card turns usable or a stat crosses a tier, the floor stops on a beat with two choices.
- `static func detect(before: Dictionary, after: Dictionary, ctx: Dictionary) -> Dictionary`
  before/after: {"gains": {stat: float}, "usable": [move_id...]}; stats: power, technique, speed, defense, conditioning, fight_iq.
  ctx: {"minute": int, "fired_today": bool, "tiers": [10.0, 25.0, 50.0] (stat gain tiers inside a day)}.
  Returns {} or {"kind": "move"|"stat", "id": move_id or stat, "title": "IT CLICKED", "line": short floor line, "quote": coach line (3+ variants, pick by a hash of id+minute)}.
  Never fires when fired_today is true; a move turning usable beats a stat tier.
- `static func choose(choice: String, beat: Dictionary, stamina: float) -> Dictionary` - choice "lock_in" | "bank_it".
  lock_in: {"extra_minutes": 20, "card_progress_mult": float, "stamina_cost": float, "gain_mult": float, "toast"}; refuse lock_in
  (return {"ok": false, "reason"}) under 30 stamina. bank_it: {"morale": int, "stamina_cost": 0.0, "toast"}. Justify your numbers in comments.
- Test `tests/breakthrough_test.gd`: no beat when nothing changed; move beats stat; fired_today blocks; each tier crossing fires once;
  lock_in costs stamina and is refused under 30; bank_it pays morale; quotes vary by id.

## FILE 2: scripts/rules/FloorEvents.gd (C9 deck, C3 member challenge is one card)
1-2 small two-choice events per day on the gym floor.
- `const CARDS := [...]` at least 10 cards, each {"id", "title", "text", "when": {"min_minute", "max_per_day", "needs": [...]},
  "a": {"label", "effects": {...}}, "b": {"label", "effects": {...}}}. Effect keys ONLY from: money (int dollars), morale (int),
  reputation (int), minutes_lost (int), member_mood (int), stamina (float), gains_mult (float, this block only), niggle_chance (float).
  Cards to include: bag chain snaps, journalist visits, rival gym's scout watches, music too loud, sponsor photo shoot,
  MEMBER CHALLENGE (a member asks your boxer for rounds: accept = morale + gains_mult + stamina cost + member_mood; decline = member_mood down),
  a kid asks for an autograph, the heating breaks, an old pro drops by with a tip, a member's payment bounces. Add your own.
  `needs` names world facts the caller passes in ctx (e.g. "members_on_floor", "booked_fight", "sponsor").
- `static func draw(ctx: Dictionary, pick: float) -> Dictionary` - ctx {"minute", "drawn_today": [ids], "facts": {name: bool}, "day_count": int (events so far today)};
  returns one eligible card (a copy) or {}; max 2 per day; never the same card twice in a day; respects min_minute and needs.
- `static func resolve(card: Dictionary, choice: String) -> Dictionary` - choice "a" | "b" -> {"ok": true, "effects", "toast"} or {"ok": false, "reason"}.
- `static func validate_deck() -> Array` - list of problems (unknown effect keys, missing labels, duplicate ids); empty = OK.
- Test `tests/floor_events_test.gd`: validate_deck() is empty; draw respects every rule (cap 2, no repeat, needs, min_minute);
  the member challenge only draws with members_on_floor; resolve both sides of every card; deterministic for the same pick.

## Deliver
Four files in full, each in its own code block headed by its path. No placeholders, no "...", no TODO.
