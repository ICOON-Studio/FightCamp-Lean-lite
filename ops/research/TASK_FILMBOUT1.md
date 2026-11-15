# TASK FILMBOUT1 - an opponent's past bout rebuilt punch by punch for a film night (rule module + test)

Status: OPEN (S495, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
The owner approved the fight analysis page (board Q-S294-256, "Yes, build it"). Map: ops/research/FIGHTFILM1_MAP_V3_S495.md,
section 1 row "The opponent's past bouts" and section 7 row "scripts/rules/FilmBout.gd". A film night shows one of the
opponent's past bouts; the game keeps each only as one row `{d, vs, vs_club, win, how}` (scripts/rules/RivalPast.gd).
This module rebuilds the whole bout, the same every time, from the opponent's real profile, so the page can list every
punch and the film game can count patterns in it.

## What to build: scripts/rules/FilmBout.gd (no class_name; static funcs; under 450 lines)
May preload: res://scripts/rules/RoundScript.gd, res://scripts/rules/HabitBeats.gd, res://scripts/rules/Exchanges.gd.
READ THEM FIRST (RoundScript.build at line ~56, HabitBeats.apply at ~25, Exchanges.STYLE_MODES at ~156 and MODE_I).

`static func build(opp: Dictionary, row: Dictionary, rounds: int = 3) -> Dictionary` returns
`{exchanges: Array, rounds: int, won: bool, how: String}` where `exchanges` holds 6 records a round (30 s each,
Exchanges.EX_SECONDS) in the SAME shape the live fight stores (scripts/state/LiveRound.gd ~line 332), the keys FightLog
reads: `{i, round, at, mode, place, pinned, won, landed: [a, b], beats}`. Corner "b" is the OPPONENT (the boxer on film),
"a" is the man they met.
1. Seed: `hash(str(opp.get("id", "")) + ":" + str(row.get("d", 0)))` - same opponent + same bout day = the same bout,
   punch for punch. One RandomNumberGenerator for the whole bout.
2. Rounds won: the row's result decides. win true -> "b" wins the majority of rounds (2 of 3); "how" not "points" ->
   the bout ends early: the last round has fewer exchanges (stop after exchange 2-5 of round 2 or 3, drawn).
3. Each exchange: `mode` drawn from Exchanges.STYLE_MODES[opp.style] (the opponent's game; fall back to an even mix of the
   modes when the style is missing); `place` 0-2 (press/loadup lean inside 2, range leans long 0, counter pocket 1);
   `pinned` 1 in 8 when "b"'s mode is press; `won` for "a" decided so round wins match step 2; beats from
   RoundScript.build({won: <a won>, mine/theirs from the margin}, <a style>, <b style>, 30.0, <a seed from the rng>,
   profiles) then HabitBeats.apply with the opponent's habits (side "b": `opp.habits` - read how HabitBeats expects them)
   so habits fire ONLY on their real triggers; `landed` counted from the beats (result "lands" per side).
4. The opponent's best weapon (`opp.threat`, a punch id such as "cross"): when "b" lands with that punch, mark it
   `big: true` 1 in 2 (it lands clean most) - other punches 1 in 6.
5. AFTER facts on every "b" punch beat: `after` drawn from base rates (ESTIMATES, Claude re-tunes them from the probe):
   guard_up 0.45, threw_on 0.15, right_low 0.12, left_low 0.10, stood 0.10, lunged 0.08. Habits raise their fact after
   their trigger only: drops_right_after_jab -> right_low after a "b" jab +0.30; lunges_with_jab -> lunged after a "b" jab
   +0.30; admires_her_work -> stood after the second of two "b" punches landing within 1.5 s +0.45 (take the raise out of
   guard_up so the rates still sum to 1). `seen`: true 2 in 3 (the ringside camera).
6. Late-round slowdown: in the last 60 s of each round drop 1 in 10 punch beats of BOTH corners (the map's 0.9); a
   "fades_late" habit drops a further 3 in 10 of "b"'s there; "slow_starter" drops 3 in 10 of "b"'s in round 1.
7. `static func clean_counts(bout: Dictionary, who: String) -> Dictionary` - {punch move: landed with big} for one corner.
8. `static func mode_counts(bout: Dictionary) -> Dictionary` - {mode: exchanges}.

## The test: tests/film_bout_test.gd (extends SceneTree; preload FilmBout.gd)
Fixture opponents that DIFFER (never identical fighters): one "Pressure fighter" with drops_right_after_jab, threat cross;
one "Counter-puncher" with no habits, threat lead_hook; one with fades_late and slow_starter. Assert:
- same opponent + same row -> identical exchanges (compare every beat's t, who, move, result, after); a different day -> differ;
- a win row -> "b" wins 2 of 3 rounds; a loss row -> 1 of 3 or fewer; a stoppage row -> fewer than 18 exchanges;
- every exchange has the keys above, 6 a round, `at` = 30 x i;
- over 200 bouts of the habit opponent, right_low after a "b" jab is at least 0.30 higher than after other "b" punches;
  for the no-habit opponent the gap is under 0.06 (habits fire only on their trigger);
- the threat punch has the most clean landings for "b" in at least 150 of 200 bouts;
- the fades_late opponent throws at least 20% fewer punches a minute in the last minute than the rest of the round,
  over 200 bouts; the counter-puncher under 15%;
- mode_counts follows the style mix (the top mode has the most exchanges over 200 bouts).
Print `FILM_BOUT failures=<n>` and quit(1 if n > 0 else 0).

GDSCRIPT TRAPS (each cost an earlier PR a fix): never `var x := <an Array or Dictionary element>` (untyped Variant ->
parse error: write `var x: int = int(d["k"])`); Array has no join(); no `sort_custom` with a static Callable in a script
without class_name; a ternary is `a if cond else b`; `hash()` of a String is stable in one Godot build - fine here.

## Contract
OWNS: scripts/rules/FilmBout.gd, tests/film_bout_test.gd
RED_TEST: tests/film_bout_test.gd -> FILM_BOUT failures=0
REGRESSION: round_script_test, habit_beats_test, rival_past
VISUAL: no
NOT YOURS: every other file (do not wire it; Claude wires it). Under 500 lines each. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --path . --script res://tests/film_bout_test.gd` (Godot 4.7.2).
PR body: `RESULT: tests/film_bout_test.gd -> FILM_BOUT failures=0`.

## Prior research
ops/research/FIGHTFILM1_MAP_V3_S495.md (sections 1, 3.3, 3.4, 3.6, 7); RoundScript.gd, HabitBeats.gd, Exchanges.gd,
RivalPast.gd, FighterProfile.gd HABITS, OppFile.gd (threat, weak).

## What would a human do?
A scout's tape of a past fight shows the same fighter: their usual game, their habits on their triggers, their best punch
landing most. Rebuild exactly that from the profile the game already keeps, never a random fighter.

## Prefab check
None: our own fight records.
