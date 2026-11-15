# TASK LOYAL3 - bot clubs answer a rival club's approach: does any one answer always win? (pure probe, prints shares)

Status: OPEN (S486, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
R58 "a fighter leaves" (map ops/research/R58_MAP_S439.md, section 4 M4 "THE HAND MODEL" - read it whole) prices five
answers to an approach: MATCH IT (cash), HALF EACH (a split, only if a team-mate holds the stipend and the talk did not
fail), MOVE THE STIPEND (a team-mate pays), PROMISE: OUR SHOW (a booked night, the fighter at stake), LET THEM GO. The
design holds only if each answer is the best one for SOME clubs and none is best for almost all. The map tested that with
a Python sketch; this probe replaces it with the game's own rule module: scripts/rules/Approach.gd (on main now - read it:
`answers(v)` returns the five columns {id, available, cash, loyalty_end, holder_end, train, holder_train, ...}).

## What to build: tests/loyal3_probe.gd (the map calls it the LOYAL1 probe; the id LOYAL1 was taken in S461) (extends SceneTree; preload Approach.gd only; under 500 lines)
A seeded RandomNumberGenerator (seed 4861). For each of three cash bands - tight $1,500-6,000, drawn $6,000-15,000,
rich $15,000-40,000 - draw 6,000 bot clubs. Each club draws (uniform unless said):
- cash in its band; weekly net -$450 to +$150;
- the approached fighter: loyalty 25-34, coachability 0-100, worth to the club $2,000-8,000 (what losing them costs);
- holder: a team-mate holds the stipend 7 in 10 (loyalty 50-80), else {};
- the team-mate's chance of two wins (their pro road) 0.15-0.70, their pro share worth $1,500 over two years;
- can_book (a show bookable) 6 in 10; the show night's net -$800 to +$2,500;
- ticks 3, ticks_after_show 2, holder_ticks 3 (the map's week), group "keep".
Value of an outcome to a bot (the map's model):
- a dollar counts `w = clamp(8000 / cash, 0.2, 1.5)`;
- the fighter's chance of leaving in the next half year by loyalty_end: 50+ 2%, 45-49 10%, 40-44 20%, 35-39 35%,
  30-34 55%, under 30 70% (let_go: 100%); expected loss = chance x worth;
- the holder (when there is one): the same table on holder_end x $1,000 (a team-mate's worth to the club, flat); MOVE
  also costs the holder's pro road: (1 - holder_train) x their two-win chance x $1,500;
- a training multiplier under 1.0 costs (1 - train) x $1,200 for the fighter and (1 - holder_train) x $1,200 for the holder;
- PROMISE: + the show night's net, and the fighter is unfit on the night 1 in 20 (then leaving chance 100%);
- value = w x cash (negative = paid) - expected losses.
The talk: a bot talks first when the expected best value after a talk (chance from Approach.talk_chance: landed -> the
"landed" view, failed -> loyalty - 4 and the "failed" view) beats the best value without one. Then it takes the best
available answer.
Print, per band and over all: each answer's share (%), the talk rate (%), one line each:
`LOYAL3 band=<tight|drawn|rich|all> match=<x> half=<x> move=<x> promise=<x> let_go=<x> talked=<x>`
Then the gates and one summary line:
- gate 1: each answer is the best in at least one band at 5% or more;
- gate 2: no answer over 60% in any band;
`LOYAL3 pass=<0|1> gate1=<0|1> gate2=<0|1>` then quit(0) (a probe reports; it does not fail the run).

## Notes
- Read Approach.gd's real field names before writing (`answers()` keys, `talk_chance()`); never re-implement its numbers.
- If an answer can never be the best by construction (say so in a comment with the arithmetic), print it - do not tune.
  Claude tunes Approach's constants from this probe's output.

GDSCRIPT TRAPS (each cost an earlier Arena PR a fix): never `var x := <an Array or Dictionary element>` (untyped
Variant -> parse error: write `var x: int = int(d["k"])`); Array has no join(); no `sort_custom` with a static Callable
in a script without class_name; a ternary is `a if cond else b`; `%` with one value needs no array but a literal `%%`.

## Contract
OWNS: tools/loyal3_probe.gd
RED_TEST: tools/loyal3_probe.gd -> LOYAL3 pass=1 (S490: a probe belongs in tools/; red on main: the file does not exist)
REGRESSION: tests/approach_test.gd
VISUAL: no
NOT YOURS: every other file. Under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/loyal3_probe.gd` (Godot 4.7.2).
You have no Godot: parse with gdtoolkit and check the arithmetic by hand on one club. Work on your own branch, open a PR
into main, never merge. PR body: `RESULT: tests/loyal3_probe.gd -> LOYAL3 pass=<what you expect and why>`.

## Prior research
ops/research/R58_MAP_S439.md section 4 M4 (the hand model and its table: tight HALF 50 / MOVE 27; drawn PROMISE 33 /
HALF 36; rich MATCH 54); scripts/rules/Approach.gd and tests/approach_test.gd.

## What would a human do?
Before shipping a choice with five answers, a designer asks a hundred different clubs what they would pick - if they all
pick the same thing, four answers are decoration.

## Prefab check
None: our own rules.
