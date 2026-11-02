# TASK_WRESTLE1 - standing wrestling chains: six tie-ups, the opponent's reaction picks the answer (Qwen)

Model: Qwen (qwen3-coder). Discipline: MMA / wrestling prototype, operator-approved (Q-S294-62 "Yes, in that order", step 1).
Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_WRESTLE1, branch `qwen/wrestle1`). Lean rules: its CLAUDE.md, no
script over 500 lines, Godot headless only.

## Why
The ground browser (GrappleMap) starts after the takedown. Real wrestling is coached as chains from a tie-up: what the
opponent does decides the answer (WRESTLE_S336.md, Game research). This is the data + rules; a "Standing" tab in the
browser comes next (not this task).

## Spec - NEW `scripts/rules/WrestleChains.gd` (extends RefCounted, static only, preloads nothing)
`const TIES` (6, this order): collar_tie "Collar tie", underhook "Underhook", wrist_control "Wrist control", two_on_one
"2-on-1", russian_tie "Russian tie", front_headlock "Front headlock".
`const ANSWERS` - exactly these 30 rows `{"tie", "reaction", "technique", "finish", "points", "link", "clip"}` (`link` = a tie id the
answer leads into, "" if none; `points` = folkstyle takedown points, 0 when it only links; `clip` = keywords for its GrappleMap move):
| tie | when she (the opponent)... | technique | finish | points | link | clip |
|---|---|---|---|---|---|---|
| collar_tie | leans in on the tie | Snapdown | Front headlock | 0 | front_headlock | snapdown, snap |
| collar_tie | carries her head high | Duck under | Go-behind | 2 | | duck under |
| collar_tie | squares up | Slide by | Bodylock go-behind | 2 | | body lock, bodylock |
| collar_tie | steps back | Snatch single | Single leg | 2 | | single_leg_takedown, single leg |
| collar_tie | pushes hard | Arm drag | Go-behind | 2 | | arm drag |
| underhook | pressures into it | Throw-by | Go-behind | 2 | | arm drag |
| underhook | squares her hips | Bodylock | Throw | 2 | | throw, body lock |
| underhook | reaches for the far arm | Knee tap | Knee tap | 2 | | ankle pick, knee tap |
| underhook | drops her head | Front headlock | Front headlock | 0 | front_headlock | front headlock |
| underhook | stays heavy | Russian tie | Russian tie | 0 | russian_tie | 2-on-1, russian |
| wrist_control | pulls her wrist back | Snatch single | Single leg | 2 | | single_leg_takedown |
| wrist_control | posts a hand on the mat | Go-behind | Go-behind | 2 | | |
| wrist_control | straightens her arm | Elbow pass | Double leg | 2 | | double_leg_takedown, double leg |
| wrist_control | gives the arm | Two on one | 2-on-1 | 0 | two_on_one | 2-on-1 |
| two_on_one | pulls her arm free | Duck under | Go-behind | 2 | | duck under |
| two_on_one | turns in | Snatch single | Single leg | 2 | | single_leg_takedown |
| two_on_one | lifts her elbow | Underhook | Underhook | 0 | underhook | underhook |
| russian_tie | keeps her head on my side | Foot block | Foot block | 2 | | sweep |
| russian_tie | keeps her head on the far side | Fireman's carry | Fireman's carry | 2 | | fireman |
| russian_tie | pulls her arm away | Double leg | Double leg | 2 | | double_leg_takedown, double leg |
| russian_tie | posts on my head | Uchi-mata | Throw | 2 | | uchi, ouchi, throw |
| russian_tie | squares up | Attack the far leg | High crotch | 2 | | single_leg_takedown |
| russian_tie | stands tall | Keyhole lock | Throw | 2 | | throw |
| russian_tie | drops her head | Snapdown | Front headlock | 0 | front_headlock | snapdown |
| front_headlock | stays flat on the mat | Go-behind | Go-behind | 2 | | |
| front_headlock | rolls | Gator roll | Near fall | 2 | | gator |
| front_headlock | digs for a leg | Shuck | Go-behind | 2 | | |
| front_headlock | turtles | Cement job | Near side cradle | 2 | | cement, cradle |
| front_headlock | lifts her head | Guillotine | Front headlock | 0 | | guillotine |
| front_headlock | sprawls back | Snapdown again | Go-behind | 2 | | snapdown |

Functions (static): `tie(id) -> Dictionary`; `answers(tie_id) -> Array` (ANSWERS order); `answer_for(tie_id, reaction) -> Dictionary`
({} when none); `links(tie_id) -> Array` (tie ids reachable in one answer); `clip_for(row, transitions: Array) -> Array` - the
GrappleMap transitions (the dicts in `assets/grapplemap/graph.json` "transitions": `title`, `tags`) whose lower-case title contains
a keyword, or whose `tags` contain it exactly; [] when none.

## Contract
OWNS: Lean/scripts/rules/WrestleChains.gd, Lean/tests/wrestle_chains_test.gd
RED_TEST: tests/wrestle_chains_test.gd -> PASS wrestle_chains_test
REGRESSION: grapple_graph_test
VISUAL: no (data; the Standing tab is a later task)

## The test (write it FIRST; it fails before WrestleChains.gd exists)
`tests/wrestle_chains_test.gd` (extends SceneTree, `_check(ok, what)` style of tests/grapple_graph_test.gd):
1. 6 ties in order; 30 answers; every answer's tie and link (when set) is a tie id; points in {0, 2}; a link answer has 0 points.
2. Every tie has at least 3 answers; no tie has two answers for the same reaction.
3. From the two openings (collar_tie and wrist_control: a match starts in a collar tie or a hand fight) every tie is reachable
   by following links (breadth-first over links()); print the reach order.
4. answer_for("russian_tie", "pulls her arm away").technique == "Double leg"; an unknown reaction -> {}.
5. Clips: load `res://assets/grapplemap/graph.json` (JSON.parse_string of FileAccess.get_file_as_string), and for every answer with
   keywords count clip_for(). Print each technique with its clip count and the first title. At least 18 of the answers that have
   keywords find a clip. Print the ones that find none ("needs our own clip").
Ends `PASS wrestle_chains_test` / `FAIL <n>`, quit(0/1). A line starting SCRIPT ERROR is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/wrestle_chains_test.gd`
then grapple_graph_test the same way. The plain exe only.

## Final answer
`RESULT: tests/wrestle_chains_test.gd -> PASS wrestle_chains_test`, the clip table, the reach order, last lines of both runs.

## Prior research
WRESTLE_S336.md (the four sources the operator sent: 223 Wrestling chain charts, GrappleFlows, SportsReflector, WrestleAI);
takedowns_throws topic page; GrappleMap counts (single_leg_takedown 21, double_leg_takedown 20, throw 15, snapdown 4, duck under 2,
fireman 4, 2-on-1 4, arm drag 16, gator 1, cement job 1, cradle 1).

## What would a human do?
A wrestling coach teaches a tie-up with its "if she does this, you do that" answers and drills them as chains, so the athlete reads
the reaction and fires the right shot. That is this table.

## Prefab check
223 Wrestling's charts are the model (no licence stated - we wrote our own chains from coaching knowledge, nothing copied).
GrappleMap (public domain) supplies the clips. Licence of this data: ours.

## The trap
Keep the module pure: graph.json is read in the TEST and passed into clip_for, never loaded by the module.
