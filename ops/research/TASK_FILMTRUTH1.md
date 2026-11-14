# TASK FILMTRUTH1 - film nights: how sure a seen tell is, look again or next group, cleared as false, debutant lock (pure module + test)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The operator said "Yes, build it" (S473) to the amateur fight week (map ops/research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md
section 5 "The film evening"). A film night opens a group of the opponent's tells; a SEEN tell is true only 70 in 100;
a second night either looks again (that group to 90) or opens the next group; the fight confirms or clears each tell; an
opponent with no bouts has no tape. This module is the rule alone; Claude wires it into OppFile and the Tape room.

## What to build: scripts/rules/FilmTruth.gd (new, under 200 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Dice come in as floats in [0, 1).
Constants: SEEN_TRUE := 0.70, LOOKED_TRUE := 0.90, NIGHT_COST_PADS := 1.
A tell is a Dictionary {"id": String, "group": int, "mode": String (the opponent's mode it shows in, e.g. "pressing"),
"state": "hidden"|"seen"|"confirmed"|"false", "sure": float (0 when hidden), "fade": bool (a fade or slow start)}.

Functions:
1. `locked(opp_bouts: int) -> String` - "no tape on a debutant" when opp_bouts == 0, else "" (the film magnet greys with it).
2. `open_group(tells: Array, group: int) -> int` - every hidden tell of that group becomes "seen" with sure 0.70;
   returns how many it opened.
3. `next_group(tells: Array) -> int` - the lowest group number that still has a hidden tell, -1 when none.
4. `look_again(tells: Array, group: int) -> int` - every "seen" tell of that group goes to sure 0.90; returns how many.
5. `second_night_options(tells: Array) -> Array` - [{"id": "look_again", "group": g, "ok": bool, "why": String},
   {"id": "next_group", "group": n, "ok": bool, "why": String}]: look_again is for the group with the most seen tells at
   0.70 (ok false, why "nothing seen to look at again" when none); next_group ok false with why "every group is open" when
   next_group() is -1.
6. `truth(tell: Dictionary, roll: float) -> bool` - whether a seen tell is really true: roll < sure. (The bout rolls it
   once, before the fight; the caller keeps the answer hidden from the player.)
7. `check_minute(tell: Dictionary, true_tell: bool, mode_came_up: bool, round_no: int) -> String` - what the corner minute
   shows for one seen tell: a fade or slow start is checked only at the round-2 minute (round_no == 2), others at the first
   minute where its mode came up. Returns "confirmed" when the mode came up and the tell is true, "false" when the mode
   came up and it is not, "" when not checked yet (its moment never came: it stays seen). Amateur bouts have minutes only
   after rounds 1 and 2: round_no 3 or more returns "".
8. `apply(tell: Dictionary, result: String) -> void` - sets tell.state to the result ("confirmed" sure 1.0, "false" sure 0.0);
   "" changes nothing.
9. `best_second_night(tells: Array, lines_on: Dictionary) -> String` - lines_on maps tell id -> how many plan lines rely on
   it. "look_again" when some seen tell has 2+ lines relying on it, else "next_group" when a group is still hidden, else
   "look_again". (The map: the choice is right one way or the other by how many lines rely on one tell.)

## The test: tests/film_truth_test.gd (new)
Same shape as tests/amateur_booking_test.gd (extends SceneTree, `_check`, prints `FILM_TRUTH checks=<n> failures=<n>`,
quit(1) on any failure). At least 30 checks with a fixture of SIX different tells across three groups (one a fade): locked
at 0 and 3 bouts; open_group counts and sets 0.70; next_group order and -1; look_again to 0.90 only for seen tells; both
second-night options and their whys; truth at roll 0.69 / 0.71 for sure 0.70 and 0.89 / 0.91 for 0.90; check_minute for a
normal tell in round 1, a fade in round 1 (not yet) and round 2, round 3 (none), mode not come up (stays seen); apply;
best_second_night three cases; a seeded run (RandomNumberGenerator seed 474, 2 000 seen tells at 0.70) true 66-74 %.

## Pass lines
RESULT: tests/film_truth_test.gd -> FILM_TRUTH checks=<n> failures=0

## Contract
OWNS: scripts/rules/FilmTruth.gd, tests/film_truth_test.gd
RED_TEST: tests/film_truth_test.gd -> FILM_TRUTH failures=0 (red on main: the file does not exist)
REGRESSION: tests/opp_file_test.gd (OPP_FILE, unchanged) - nothing else is edited
VISUAL: no
NOT YOURS: every other file. Do not wire it into OppFile.gd or TapeRoom.gd (Claude does that).
Run only through `python ops/Tools/godot_slot.py run --who filmtruth1 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/film_truth_test.gd`
(in the cloud: `godot --headless --audio-driver Dummy --path . --script res://tests/film_truth_test.gd`). Never the
_console exe, never a window, never wrapped in `timeout`. Read ops/research/GDSCRIPT_TRAPS.md first.

## Prior research
Map section 5 (every rule above); scripts/rules/OppFile.gd (today's tells: how they are stored and found);
scripts/ui/TapeRoom.gd header (the film screen).
## What would a human do?
A coach watches a phone video of the opponent, notes "she drops her right when she presses", and only trusts it once she
sees it in the ring.
## Prefab check
None: our own rule.
