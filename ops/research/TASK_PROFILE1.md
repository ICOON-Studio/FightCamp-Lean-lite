# TASK PROFILE1 - QWEN - the fighter profile and stored morale (Lean repo, fight model step 1)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_PROFILE1 (branch qwen/profile1). Commit there; do not push to main.

## Why
The agreed fight model (Lean `docs/FIGHT_MODEL.md`, read it first, 78 lines) gives every fighter footwork, four style dials,
six personality traits, two habits and one stored morale. Today none of that exists, and `FighterGoal.outcome()` returns a
`morale_delta` that nothing stores (the defect). You write ONE pure rule module that owns those numbers; Claude wires it
into Data/Bouts/SaveGame after you land.

## Owned files (create both; touch nothing else)
- `scripts/rules/FighterProfile.gd` (new, under 250 lines, `extends RefCounted`, static functions only, no preloads
  except `res://scripts/rules/FighterGoal.gd` for its two MORALE constants)
- `tests/fighter_profile_test.gd` (new, `extends SceneTree`, same shape as `tests/round_script_test.gd`: a `failures`
  counter, `_check(cond, label)`, print `FIGHTER_PROFILE failures=<n>` at the end, `quit(1 if failures else 0)`)

## The module (exact API)
```
const TRAITS: Array[String] = ["heart", "temper", "confidence", "discipline", "coachability", "loyalty"]
const HABITS: Array[String] = ["drops_right_after_jab", "slow_starter", "digs_body_when_hurt", "freezes_on_ropes",
    "switches_stance_under_pressure", "talks_when_ahead", "loads_up_when_hurt", "covers_up_when_hurt"]
const MORALE_START := 60
## One morale event table. goal_met / goal_missed MUST be FighterGoal.SUCCESS_MORALE_DELTA / FAILURE_MORALE_DELTA.
const MORALE_EVENTS := {"win": 8, "loss": -12, "draw": 0, "goal_met": <FighterGoal +10>, "goal_missed": <FighterGoal -20>,
    "rest_week": 4, "month_no_fight": -6, "booked": 5}
## Mood words, by morale 0..100: >=75 "Fired up", >=50 "Steady", >=30 "Flat", else "Low".
static func mood(morale: float) -> String

## A new profile for fighter f (a Data.gd fighter dict with "stats" and "style"), deterministic in seed_value.
## Returns {"footwork": float, "style_dials": {"pressure","work_rate","body_share","counter"}, "personality": {6 traits},
##          "habits": [2 distinct ids from HABITS], "morale": MORALE_START, "mood_reason": ""}
## footwork = mean(stats.speed, stats.defense) + a seeded spread in [-4, +4], 1 decimal.
## style_dials 0..100 from f["style"]: "Out-boxer" pressure 25, "Pressure fighter" 75, "Slugger" 85, other 50; each +/- seeded 8.
##   work_rate 40..80 seeded; body_share 20..50 seeded (Pressure fighter / Slugger +10); counter = 100 - pressure +/- 8.
## personality: each trait 30..85 seeded (independent per trait). Use RandomNumberGenerator with rng.seed = seed_value.
static func make(f: Dictionary, seed_value: int) -> Dictionary

## Old saves and new signings: add every missing profile key to f IN PLACE (seed from hash(f["id"])), never overwrite a key
## that is already there. Returns f.
static func ensure(f: Dictionary) -> Dictionary

## Apply one morale event to f in place. kind is a MORALE_EVENTS key. Personality scales it:
##   a negative delta is multiplied by lerp(1.3, 0.7, heart / 100.0);
##   "goal_missed" is additionally multiplied by lerp(0.9, 1.25, confidence / 100.0) (confidence takes it personally);
##   a positive delta is multiplied by lerp(0.9, 1.1, confidence / 100.0).
## f["morale"] = clamp(old + scaled, 0, 100) rounded to 1 decimal; f["mood_reason"] = reason.
## Returns {"morale": new, "mood": mood(new), "delta": scaled, "reason": reason}. Unknown kind: no change, delta 0.
static func apply_morale(f: Dictionary, kind: String, reason: String) -> Dictionary
```

## Tests (all must pass; print `FIGHTER_PROFILE failures=0`)
1. `make` with the same fighter and seed twice gives equal profiles; two DIFFERENT fighters (use two dicts shaped like
   Data.lucy(): different stats and style, e.g. an Out-boxer and a Slugger) give different footwork and different dials.
2. Every dial and trait is inside 0..100; the two habits are distinct and in HABITS; morale starts at MORALE_START.
3. Out-boxer pressure < Pressure fighter pressure (over seeds 1..20, every seed).
4. `ensure` on a dict that already has `"morale": 33.0` and `"footwork": 70.0` keeps both and adds the rest; `ensure` twice
   changes nothing the second time.
5. mood bands: 80 -> "Fired up", 60 -> "Steady", 40 -> "Flat", 10 -> "Low", 75 -> "Fired up", 50 -> "Steady".
6. A "loss" costs a heart-90 fighter LESS morale than a heart-10 fighter (same start morale).
7. "goal_missed" costs a confidence-90 fighter MORE than a confidence-10 fighter (same heart).
8. MORALE_EVENTS goal_met / goal_missed equal FighterGoal.SUCCESS_MORALE_DELTA / FAILURE_MORALE_DELTA.
9. Clamp: morale 5 + loss stays >= 0; morale 98 + goal_met stays <= 100.
10. Unknown kind returns delta 0 and leaves morale unchanged.
Make test 1 or 6 fail first on purpose (write the test before the module), then make it green.

## Parse gate + the one test command (run from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/fighter_profile_test.gd
```
NEVER the `_console.exe`. The exit code alone is not a pass: the output must show `FIGHTER_PROFILE failures=0` and no
`SCRIPT ERROR`. Also run `tests/fighter_goal_test.gd` the same way (it must stay green). Nothing else.

## Contract
OWNS: scripts/rules/FighterProfile.gd, tests/fighter_profile_test.gd   (Lean repo)
RED_TEST: tests/fighter_profile_test.gd -> FIGHTER_PROFILE failures=0
REGRESSION: fighter_goal_test
VISUAL: no

## The one trap
GDScript `:=` on a Variant (a value read out of a Dictionary) is a parse error: write `var x: float = float(d["k"])`.
`Array[String]` constants cannot take `.has()` on a Variant without a cast. A parse error HANGS a headless run: if a test
run produces no output in 60 s, kill it and read the script for a parse error.

## Prior research
Lean docs/FIGHT_MODEL.md (S299, operator-approved); old repo PERSONALITY_RESEARCH.md + J_STRESS_S206.md (Football Manager
morale = current mood + reasons). Prior notes: `python Tools/prior_research.py personality morale` (run in E:\FightCamp\Game).

## What would a human do?
Football Manager: a hidden personality (determination, temperament, professionalism, loyalty...) that the player learns
through the coach's reports, and a visible morale word with its reason. Same here.

## Prefab check
Nothing to buy: a pure data module. `rules/FighterGoal.gd` already owns the goal deltas; reuse its constants.

## When done
Commit both files on branch qwen/profile1 with a message ending
`RESULT: tests/fighter_profile_test.gd -> FIGHTER_PROFILE failures=0`, and paste the last 15 lines of both test runs in
your final answer.
