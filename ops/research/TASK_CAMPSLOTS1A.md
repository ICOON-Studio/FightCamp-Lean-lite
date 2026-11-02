# TASK CAMPSLOTS1A - Camp slots pay off: mirror sparring banks exploit charges, film study unlocks opponent reads (pure module + test) (S200)
Seat: Arena (cloud). Repo ICOON-Studio/FightCamp. Work ONLY on your own new branch and open a PR to master; never merge, never push master.
Model: any. HEADERS2 item 5 (operator approved Q-S196-4). Source: `research/LUDO_ROUND33_S198.txt` lines 297-331.

## Owned files (both NEW; touch nothing else)
- `Godot/scripts/rules/CampSlots.gd`
- `Godot/tests/camp_slots_test.gd`

## Spec
`class_name CampSlots extends RefCounted`, pure static: no RNG, no autoload, no GameState, no preload/load, no Node, no files.
State Dictionary: `{"partner": {id, name, style_match} or {}, "sparring_rounds": int, "charges": int, "film_hours": float}`. Missing keys read as empty/0.

Slot 1 - style sparring with a mimic partner:
- `static func assign_partner(state, partner: Dictionary) -> Dictionary` -> partner needs `id` (non-empty) and `style_match` 0..1; else `{ok:false, reason}`.
  Assigning a DIFFERENT partner resets sparring_rounds to 0 (charges already banked stay). Returns `{ok:true, state}`.
- `static func log_sparring(state, rounds: int) -> Dictionary` -> refused with no partner (`reason "no sparring partner"`) or rounds <= 0.
  Only partners with style_match >= 0.60 bank charges ("a mirror"): every 4 completed rounds banks +1 charge, max 3 (`MAX_CHARGES`); leftover rounds carry over.
  Returns `{ok, state, charges_gained}`. A partner below 0.60 logs rounds but banks nothing (charges_gained 0, rounds still counted).
- `static func spend_charge(state) -> Dictionary` -> `{ok, state, evasion_bonus: 0.35}` (one charge, used in the corner on fight night); 0 charges -> refused.
Slot 2 - film study:
- `static func log_film(state, hours: float) -> Dictionary` -> hours <= 0 refused; film_hours += hours (cap 8.0). Returns `{ok, state, unlocked: Array}` = reads newly crossed this call.
- `static func film_reads(state) -> Array` -> `"opp_stamina_bar"` from 4.0 h, `"punch_telegraph"` from 8.0 h (in that order).
- `const TELEGRAPH_LEAD_S := 0.25`.
UI text helpers:
- `static func slot1_line(state) -> String`: no partner -> `"UNASSIGNED - Click to contract mimic partner ($150-$600/wk)"`;
  else `"SPARRING MIRROR - <NAME UPPERCASE> | Style match: <round(match*100)>% | Exploit bank: <charges>/3"`.
- `static func slot2_line(state) -> String`: `"FILM STUDY - <h with 1 decimal> / 8.0 hrs"` + `" | next unlock: STAMINA TELEMETRY at 4.0 hrs"` below 4,
  `" | next unlock: TELEGRAPH CUES at 8.0 hrs"` from 4 to under 8, `" | all reads unlocked"` at 8.
- `static func filled(state, slot: int) -> bool` -> slot 1 has a partner; slot 2 has film_hours > 0. (Filled slots render gold #D69E2E - the UI task uses this.)
- Inputs are NEVER mutated.

## Test `camp_slots_test.gd` (extends SceneTree; prints `CAMPSLOTS total=N fails=M`; `quit(1)` on any fail)
(a) assign: missing id refused, match 1.2 refused, partner change resets rounds and keeps charges; (b) 4 rounds -> 1 charge; 11 rounds -> 2 charges + 3 carried; 40 rounds caps at 3;
(c) partner at 0.59 banks nothing, at 0.60 banks; no partner refused; (d) spend: 0.35 bonus and charge -1; at 0 refused; (e) film: 3.9 h no reads, 4.0 -> stamina bar unlocked once,
8.0 -> telegraph, never reported twice, cap at 8.0; (f) both line strings exact in each state; (g) no input mutated.
Write it FROM THIS SPEC; name 3 real mutants you ran red in the PR body.

## Gates
`python Godot/tools/check_scripts.py Godot/scripts/rules/CampSlots.gd Godot/tests/camp_slots_test.gd`
`Godot --headless --path Godot --script tests/camp_slots_test.gd` -> exit 0, no "FAIL", no "SCRIPT ERROR". CI must be green.
GDScript: type every Variant; no reused local names in one function; `%%` for a literal percent in a format string.

## Prior research
LUDO_ROUND33_S198.txt Header 5 + section 2.5. Pattern: `Godot/scripts/rules/FilmIdle.gd`.
## What would a human do?
A coach hires a sparring partner who fights like the opponent and makes the fighter watch his tape; both pay off on fight night.
## Prefab check
None - our own rules.
## The one trap
No UI, no wiring into the fight - separate later tasks. Touch only the two owned files; never delete or weaken a test.
