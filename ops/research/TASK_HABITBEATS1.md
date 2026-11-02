# TASK HABITBEATS1 - QWEN - a fighter's habits show in the 3D round (Lean, fight model step 5)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_HABITBEATS1 (branch qwen/habitbeats1). Commit there; do not push.

## Why
Every fighter carries 2 habits (`f["habits"]`, ids from `scripts/rules/FighterProfile.gd` HABITS). Kalli wrote what each
one looks like (`assets/data/fight_habits.json`: trigger, beat, effect, punish, notes). The ring does not play them yet.
RoundScript (`scripts/rules/RoundScript.gd`, read it) builds a round as beats; you write ONE pure module that rewrites a
built round so the habits show, WITHOUT changing who lands how many (the simulation decided that).

## The beat (RoundScript.build output, read `_beat` and `build`)
script = {"n", "winner": "a"|"b", "margin", "seconds", "end", "beats": [ {"t": float seconds, sorted ascending,
"who": "a"|"b", "move": "jab"|"cross"|"lead_hook"|"rear_hook"|"body_hook"|"lead_uppercut"|"rear_uppercut"|"step_in"|
"step_out"|"tired"|"count", "result": "lands"|"blocked"|"misses"|"none", "caption": "", "big": bool, "knockback": bool,
"def": ""|"block"|"slip"|"weave"|"pull"} ]}. Punch moves are everything except step_in/step_out/tired/count.

## Owned files (create both; touch nothing else)
- `scripts/rules/HabitBeats.gd` (new, under 250 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/habit_beats_test.gd` (new, `extends SceneTree`, same shape as `tests/round_style_test.gd`; print
  `HABIT_BEATS failures=<n>`; quit(1 if failures else 0))

## The module
```
const MAX_FIRES := 2   # a habit fires at most twice a round (Kalli)
## Rewrites script["beats"] in place for both sides' habits and returns the list of fires [{"who","habit","t"}].
## habits = {"a": [ids], "b": [ids]}; ctx = {"won_last": {"a": bool, "b": bool}} (who won the previous round).
## Every fired beat gets b["habit"] = id. Never change a beat's "who" or "result" == "lands" count per side; never
## move "t" out of order (inserted beats take t between their neighbours); never touch the round's LAST beat or a "count".
static func apply(script: Dictionary, habits: Dictionary, ctx: Dictionary, rng: RandomNumberGenerator) -> Array
```
The habits to play (the rest are ignored here - they need ropes, clinches or feints the ring does not have yet):
| id | trigger in the beats | rewrite |
|---|---|---|
| drops_right_after_jab | her "jab" | the OTHER boxer's next punch within 1.5 s becomes "lead_hook" |
| digs_body_when_hurt | the other lands on her | her next punch becomes "body_hook" |
| loads_up_when_hurt | the other lands on her | her next punch becomes "lead_hook" and, if it did not land, "misses" with def "" |
| covers_up_when_hurt | the other lands on her | insert her beat move "step_out" result "none" 0.3 s after (between neighbours) |
| wide_hook_tell | her "lead_hook" that did not land | result becomes "blocked", def "block" |
| slow_starter | round 1 (script n == 1), her punches in the first quarter of the round that did not land | move becomes "step_out", result "none" |
| fades_late | n >= 3 | insert one "tired" beat for her in the last third (if she has none there) |
| admires_her_work | her "cross" that lands | insert her "step_out" result "none" 0.3 s after |
| one_and_done | her punch that lands | her next beat, if it is a punch within 0.5 s and did not land, becomes "step_out" "none" |
| talks_when_ahead | ctx.won_last[her] | insert her "step_out" result "none" near the start (first third) |
| lunges_with_jab | her "jab" that did not land | becomes "misses", def "" |
| retreats_straight_back | the other's "step_in" | insert her "step_out" right after |

## Tests (all must pass; 200 seeds each; build scripts with RoundScript.build(round, "Out-boxer", "Pressure fighter",
40.0, seed) where round = {"n": 1..3, "won": bool, "mine": 60.0, "theirs": 61.0, "corner": "", "lines": ["A.", "B.", "C."]})
1. RoundScript.landed(script) is the same before and after apply, for every seed and every habit pair you test.
2. Beats stay sorted by "t"; the last beat is unchanged.
3. Each playable habit fires at least once over the 200 seeds and never more than MAX_FIRES in one round.
4. digs_body_when_hurt: her body_hook count after > before (over all seeds).
5. slow_starter: round 1 has fewer of her punches in its first quarter than without the habit; round 2 is unchanged.
6. fades_late: round 3 has a tired beat for her in its last third on every seed; round 1 never gets one from it.
7. Habits of "b" never rewrite "a"'s beats except drops_right_after_jab (which rewrites the OTHER boxer's punch).
8. Unknown habit ids are ignored (no error, no change).
Write test 1 first and see it fail (the module missing), then build the module.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/habit_beats_test.gd
```
NEVER the `_console.exe`. Output must show `HABIT_BEATS failures=0` and no `SCRIPT ERROR`. A script error in
`_initialize` HANGS the run (quit is never reached): if there is no output in 60 s, kill it and fix the error.
Also run `tests/round_script_test.gd` and `tests/round_style_test.gd` the same way (must stay green).

## Contract
OWNS: scripts/rules/HabitBeats.gd, tests/habit_beats_test.gd   (Lean repo)
RED_TEST: tests/habit_beats_test.gd -> HABIT_BEATS failures=0
REGRESSION: round_script_test, round_style_test
VISUAL: no (Claude wires it into FightView and checks a film)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: `var m: String = str(b["move"])`. Array.insert shifts
indices: walk the beats backwards when you insert, or collect inserts and apply them at the end.

## Prior research
Kalli K-HABITS1 (old repo research/K_HABITS1_KALLI.md = Lean assets/data/fight_habits.json); Lean docs/FIGHT_MODEL.md.

## What would a human do?
A coach watching film: "every time she jabs, the right hand drops" - the same beat, round after round.

## Prefab check
Nothing to buy: a pure rules module over our own beat format.

## When done
Commit both files on qwen/habitbeats1, message ending `RESULT: tests/habit_beats_test.gd -> HABIT_BEATS failures=0`,
and paste the last 20 lines of the three test runs in your final answer.
