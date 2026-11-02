# TASK ANIMBUS1 - the animation INTENT BUS as a pure module (step 1 of the approved animation plan)

Model: Arena (cloud, pure module + test). Approved: operator board Q-S203-2 / Q-S204-1 ("build it all with your corrections").
Design source: Ludo round 38 section 1 (`research/LUDO_ROUND38_S204_reply1.txt` chars 917-8163) + Claude's verdict
`research/LUDO_ROUND38_VERDICT_S204.md`. This task builds ONLY the data + rules; wiring it into the fight is a later task.

## What it is
One record per exchange, from the fight simulation to the animation layer: which clip, where its phases sit, how far the punch
is meant to miss, how hard it lands, clinch timing, slip/pivot sizes, composure. The animation layer asks the bus "which phase am I
in at clip time t?" and "am I inside the protected contact window?". If the record is missing or invalid, the answer is always
"no intent" so today's animation plays unchanged.

## Spec - `Godot/scripts/animation/IntentBus.gd` (new), `extends RefCounted`, `class_name IntentBus`, static functions only
PURE: no preload/load, no GameState, no Node/scene/filesystem, no randomness; never mutate an argument; every result is a new value.
Phases enum as String constants: "none", "anticipation", "acceleration", "contact", "retraction".
1. `static func make_intent(fields: Dictionary, clip_phase: Dictionary = {}) -> Dictionary` - returns a full intent dict with these
   keys and defaults: exchange_id (-1), fighter_id (""), clip_name (""), anticipation_end_norm, acceleration_end_norm,
   contact_point_norm, retraction_end_norm, contact_window_half_width_s (0.045), intended_miss_offset_cm (Vector3.ZERO),
   damage_band (0..4, default 1), raw_damage (0.0), is_clinch (false), clinch_hold_s (0.0), clinch_break_s (0.0),
   ref_break (false), slip_vector (Vector2.ZERO), pivot_angle_deg (0.0), com_shift_m (Vector2.ZERO),
   composure ("composed"|"pressured"|"rattled"|"panicked", default "composed"), suppress_pad_chains (false), clip_length_s.
   PHASE DEFAULTS COME FROM OUR CLIP DATA when `clip_phase` is given - it is one entry of `Godot/assets/data/clip_phases.json`
   ({"start_s","contact_s","recover_s","length_s",...}): clip_length_s = length_s; anticipation_end_norm = start_s/length_s;
   contact_point_norm = contact_s/length_s; retraction_end_norm = recover_s/length_s; acceleration_end_norm = midpoint of
   start and contact. Without clip_phase: Ludo's 0.15 / 0.40 / 0.45 / 0.85 and clip_length_s 1.0. Explicit `fields` win.
   Clamp every *_norm to 0..1; damage_band to 0..4; contact_window_half_width_s to 0.0..0.25.
2. `static func is_valid(intent: Dictionary) -> bool` - exchange_id >= 0, clip_name non-empty, clip_length_s > 0, and the norms
   strictly ordered anticipation_end < acceleration_end <= contact_point < retraction_end.
3. `static func phase_at(intent: Dictionary, t_s: float) -> String` - "none" if not valid. norm = clamp(t/clip_length,0,1):
   < anticipation_end -> "anticipation"; < acceleration_end -> "acceleration"; inside the contact window -> "contact";
   before the contact point (and outside the window) -> "acceleration"; AFTER the contact point and outside the window ->
   "retraction" (FIX of Ludo's draft, which fell back to "acceleration" after contact); >= retraction_end -> "retraction".
4. `static func in_contact_window(intent: Dictionary, t_s: float) -> bool` - |t - contact_point_norm*clip_length| <=
   contact_window_half_width_s; false if not valid. THIS IS THE PROTECTED WINDOW: later layers must not move root or feet in it.
5. `static func sequence(intents: Array) -> Array` - valid intents only, sorted by exchange_id ascending, duplicates of the same
   (exchange_id, fighter_id) keep the LAST one given; returns new dicts.
6. `static func phase_events(intent: Dictionary, prev_t_s: float, t_s: float) -> Array` - the phase changes crossed between two
   frame times as [{"phase": String, "at_s": float}] in order, plus {"phase":"contact_enter"} / {"phase":"contact_exit"} markers
   when the window boundary is crossed; [] when invalid or t_s <= prev_t_s.

## Test - `Godot/tests/intent_bus_test.gd` (new, extends SceneTree, prints PASS/FAIL lines and `INTENT_BUS total=N fails=M`,
quit(1) on any fail). Written from THIS contract (blind), not from the implementation. At least:
- defaults with and without a clip_phase entry; use TWO DIFFERENT real entries copied as literals from clip_phases.json
  (e.g. boxing_cross: start_s 0.016667, contact_s 0.3, recover_s 0.65, length_s 0.833333; and boxing_body_hook - copy its numbers);
- is_valid false for each broken field (one at a time); clamping; explicit fields override clip data;
- phase_at walk over the whole clip in 1 ms steps: phases only ever go forward, "contact" appears exactly once as one run,
  and the run's length equals 2*half_width (+-1 ms) when the window is inside the clip;
- the RETRACTION fix: t just after the window end -> "retraction", never "acceleration";
- in_contact_window edges inclusive; invalid intent -> false everywhere;
- sequence: order, invalid dropped, last duplicate wins, inputs not mutated (deep compare before/after);
- phase_events across a frame that jumps over the whole window still reports contact_enter then contact_exit;
- a mutant guard: a copy of the rule with `<=` turned into `<` at the window edge must fail one of your checks (encode the
  mutant inline in the test as a lambda/second function).
- a source scan: IntentBus.gd contains no "preload", "load(", "GameState", "randf", "randi", "RandomNumberGenerator".

## Owned files
Godot/scripts/animation/IntentBus.gd (new), Godot/tests/intent_bus_test.gd (new). Nothing else.

## Gate
Parse: `python Godot/tools/check_scripts.py Godot/scripts/animation/IntentBus.gd Godot/tests/intent_bus_test.gd`
Run: `godot --headless --path Godot --script tests/intent_bus_test.gd` -> `INTENT_BUS total=N fails=0`. CI on your PR must be green.
Work ONLY on your own arena/* branch and open the PR yourself; never merge, never touch master, never delete or shrink a test.

## Prior research
Ludo r38 s1 (the contract above is his, corrected), LUDO_ROUND38_VERDICT_S204.md (our rules above Ludo's code: OFF = identical,
nothing moves root/feet inside a certified contact window, two different fighters), clip_phases.json (our measured phase times).

## What would a human do?
Make the message format and its time rules a small tested library first, so every later animation layer reads one truth.

## Prefab check
None - a 200-line pure GDScript module; no library covers our clip_phases format.

## The one trap
Godot `Dictionary.duplicate()` is shallow - Vector2/Vector3 are values (fine), but copy Arrays/Dictionaries deeply
(`duplicate(true)`) or the no-mutation check fails.
