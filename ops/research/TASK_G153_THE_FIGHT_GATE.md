# TASK G153 - THE FIGHT GATE: one check every path into a bout passes (engine, Grok Build CLI)
Owner: Grok (Grok Build CLI). Worktree D:/FightCamp/wt/G153, branch grok/g153-fight-gate (from master).
Operator 2026-10-01, verbatim: "we also need the engine to gate everything that needs to be gated to fight".

## Why
The rules that must stop a bout exist but are SCATTERED in Godot/scripts/GameState.gd (17,655 lines - never read whole):
`_booking_blocked_reason` (line ~16411: already booked, weight move, strike, offer taken, contract walked away, exclusive
promo contract, fame), `_sanctioning_eligibility` (~7263: age by ruleset via CompetitionData.evaluate_athlete_eligibility),
`enforce_pre_fight_medicals` (~14339: licence + medicals on fight day), injury text (~4949 "INJURED - CANNOT BE BOOKED"),
weigh-in (`_weigh_in_now` ~2196, chip "missed_weight" ~17610), `book_fight` (~13239), `book_spar` (~5673).
Nobody can say today which rule is checked at which stage, or prove a bout cannot start when one is broken.

## Prior research
`python Tools/prior_research.py eligibility suspension medical licence weigh-in sanction`; `research/topics/rules_orgs.md`;
`J1_ORGANIZATION_RULES_AND_JUDGES.md`; `COMPETITION_RULESET_RESEARCH.md`. Dola runs D67 (the sourced rule list) in
parallel - do not wait for it; end your digest with a `## Rules for D67 to source` list for anything your census finds
missing or unsourced.

## What would a human do?
A commission inspector's checklist: one function, every rule a row with a reason string, called at each stage (offer
grading, booking, fight week, weigh-in, fight night/room entry). Same answer everywhere.

## Prefab check
None - these are our rules. Reuse the existing checks; do not re-implement them.

## Owned files
- NEW `Godot/scripts/FightGate.gd` (static funcs, no class_name, no autoload references):
  `check(athlete: Dictionary, opponent: Dictionary, offer: Dictionary, stage: String, ctx: Dictionary) -> Dictionary`
  returning `{"ok": bool, "reasons": [{"rule": <id>, "text": <UPPERCASE reason>}]}`. Stages: "offer", "book",
  "fight_week", "weigh_in", "fight_night". Rules, each its own id: same_sex (females never fight males), weight_class
  (booking matches the weight class), injured, medical_suspension (if the save records one), sanction/licence (existing),
  age (existing evaluate_athlete_eligibility), already_booked, weight_move, strike, contract, fame (existing),
  missed_weight (weigh_in / fight_night), ruleset_legal (the bout's ruleset exists for the discipline).
- `Godot/scripts/GameState.gd`: ONLY call sites. `_booking_blocked_reason` becomes a thin wrapper over FightGate that
  returns the SAME strings for the existing rules (screens must not change), plus ONE call at fight-week entry, weigh-in
  and fight-night room entry. Read with `sed -n` windows; name every line range you edit in the digest.
- NEW `Godot/tests/fight_gate_test.gd`: one fixture per rule that MUST refuse and names the rule id; one legal control that
  passes; one case that drives the REAL book_fight path with a broken rule and proves no bout is created. Two fighters
  in a fixture always DIFFER (stats, name, frame) - never identical.
- NEW `research/G153_DIGEST.md`: census table rule x stage - where it was checked before, where now.

## Tests
Parse: `python Godot/tools/check_scripts.py scripts/FightGate.gd scripts/GameState.gd tests/fight_gate_test.gd` (from Godot/).
Then the test alone, then `python Godot/tools/run_tests.py --jobs 2 --only fight_gate,booking,offer,weigh,medical,career,fight_week`.
Watchdog before each run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = wait).

## The one trap
`var x := <call>` fails on a Variant return in GDScript - type it (`var r: Dictionary = ...`). A parse error HANGS a
headless test: always the parse gate first. Do not change any refusal string the screens already show.

## Finish
git add by explicit path, commit, git push -u origin grok/g153-fight-gate. Do not stop at "written".
