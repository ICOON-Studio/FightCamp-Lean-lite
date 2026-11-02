# TASK_GROUND3 - the ground fight on paper: positions, moves and odds (Qwen)

Model: Qwen (qwen3-coder, qwen_task.cmd). Discipline: MMA ground, paper rules only - NOT in the career (operator Q-S294-70
"After boxing, as the MMA update"; S347 chat "we can work on bjj at the same time as boxing"). Boxing stays the demo.
Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_GROUND3, branch `qwen/ground3`). Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
The ground film (GrappleMap on our two women) plays moves but nothing decides them. In this game the 3D never decides a
fight: a rule module settles each exchange on paper, the 3D shows it (boxing: `scripts/rules/Exchanges.gd`). This is
step 1 of `E:\FightCamp\Game\research\GROUND_INTO_GAME_S347.md`: the ground fight's paper rules, so the later MMA
update only wires it in.

## Spec - NEW `scripts/rules/GroundRules.gd` (extends RefCounted, static functions only, NO preloads)
A fighter is a Dictionary `{"name", "wrestling", "bjj", "strength", "cardio"}`, each 0-100.
- `const POSITIONS` (exactly these ids): `standing, clinch, front_headlock, turtle, guard, half_guard, side_control, mount,
  back`. A state is `{"pos": id, "top": "a"|"b"|""}` ("" when standing or in the clinch; in `back`, "top" = the one behind).
- `const MOVES`: an Array of `{"id", "from", "to", "by": "top"|"bottom"|"either", "kind": "takedown"|"pass"|"sweep"|
  "escape"|"advance"|"sub", "attr": "wrestling"|"bjj"|"strength", "base": chance per attempt 0..1}`. At least: double leg,
  single leg, body-lock trip from the clinch, snapdown to front headlock, front headlock to back take, stand-up from turtle,
  guard pass to half and to side, half to side, side to mount, mount to back, sweep from guard and from half (the bottom
  woman ends on top: "top" flips), shrimp/escape from side to guard and from mount to half, get up to standing from guard,
  and one sub each from guard (armbar/triangle), side (kimura), mount (armbar) and back (rear naked choke). A failed sub
  can lose position (mount armbar fails -> guard, she is on the bottom). A takedown that fails stays standing (G141:
  stuffed shots go to front headlock 15-25 % / turtle 10-15 % - use that split for the defender's counter).
- `static func chance(move, attacker, defender) -> float`: base moved by the attribute gap (attacker's `attr` minus the
  defender's same attribute), clamped 0.02..0.95. Use G144's skill-gap shape (no single number from your head).
- `static func step(state, fa, fb, roll: float, roll2: float) -> Dictionary`: one decision. Who acts and which move are
  picked from roll (deterministic: the same rolls give the same result); roll2 decides success. Returns
  `{"state": new_state, "move": id, "who": "a"|"b", "ok": bool, "finish": bool}`.
- `static func simulate(fa, fb, seconds: float, seed: int) -> Dictionary`: one decision every `TICK_S` (10.0) seconds from
  standing (most standing ticks are striking: a takedown is tried only on a share of standing ticks set so the attempt
  rate below holds). Uses RandomNumberGenerator with `seed`. Returns `{"ground_s", "control_s": {"a", "b"},
  "td_att": {"a", "b"}, "td_ok": {"a", "b"}, "sub_att": {"a", "b"}, "finish": "" | "a" | "b", "log": [...]}`.

## Real numbers (read these, use them, cite them in the test's comments)
All in `E:\FightCamp\Game\research\` (read-only reference):
- `topics/ground.md` "Real anchors": UFC lightweight ~17 % of fight time is one fighter's ground control; 15-25 % ground
  time; 2.5-3.0 takedown attempts per 15 min; submission ATTEMPTS 0.5-1.0 per fighter per fight (`G92_SUB_ATTEMPTS_BY_STYLE.md`:
  the 1.65 figure was per BOUT).
- `G143_TOP_POSITIONS.md` (guard/half/side/mount hazards per position), `G142_BACK_CONTROL.md` (back control),
  `G144_GROUND_SKILL_GAPS.md` (skill-gap and style multipliers; the 55 % seat-mass cap), `G141_FRONT_HEADLOCK_AND_TURTLE.md`,
  `G75_THE_MAN_UNDERNEATH.md` (no published destination shares: those tables are coach judgement, keep them as given).

## The test - NEW `tests/ground_rules_test.gd` (extends SceneTree; prints `GROUND_RULES failures=<n>`)
Three pairings of DIFFERENT women (never identical fighters), 400 fights each of 3 x 5 min (900 s), seeds 1..400:
- wrestler `{wrestling 85, bjj 50, strength 70, cardio 65}` vs striker `{wrestling 35, bjj 30, strength 55, cardio 70}`
- BJJ black belt `{wrestling 45, bjj 90, strength 50, cardio 60}` vs wrestler (above)
- two all-rounders `{60, 55, 60, 60}` and `{55, 60, 55, 65}`
Bounds (bounds, never an exact count):
1. Structure: every move's from/to is a position; every position is reachable from standing; every sweep flips "top";
   the same seed gives the same fight twice.
2. All-rounders: ground time 10-30 % of the fight; takedown attempts 1.5-4.5 per fighter per 15 min; submission attempts
   0.3-1.3 per fighter per fight.
3. Wrestler vs striker: the wrestler's control time is at least 3x the striker's; the striker still stands up in some fights.
4. BJJ vs wrestler: the BJJ woman tries more submissions than the wrestler; the wrestler lands more takedowns.
5. Finishes: under 35 % of all fights end by submission in every pairing.
Print each pairing's averages in one line so Claude can read them.

## Contract
OWNS: Lean/scripts/rules/GroundRules.gd, Lean/tests/ground_rules_test.gd
RED_TEST: tests/ground_rules_test.gd -> GROUND_RULES failures=0
REGRESSION: grapple_graph_test, strike_map_test
VISUAL: no

## How to run (exact)
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/ground_rules_test.gd`
Write the test first and run it once to see it fail, then the module. Never the `_console.exe`.

## The trap
Do not pick odds that make the bounds pass by luck of one seed: the bounds are over 400 seeds. If a bound cannot hold with
the research's numbers, say which and why in your answer - do not move the bound.

## Prior research
`python Tools/prior_research.py ground takedown submission` -> topics/ground.md (canonical), G141-G144, G92, G75, Q165,
GROUND_INTO_GAME_S347.md (the plan), GrappleMap (positions/moves already on our women, `scripts/grapple/`).

## What would a human do?
A BJJ coach thinks in positions and the moves between them (the "position hierarchy": back > mount > side > half > guard);
a fight analyst counts takedown attempts, control time and submission attempts per fight. The module is that hierarchy
with odds, and the test is that analyst's sheet.

## Prefab check
GrappleMap (public domain) gives positions and moves but no odds or outcomes. Fight-sim libraries with ground rules (e.g.
old MMA management sims) are closed. The old project's `GroundGraph.gd` is 21k-line GameState-bound: not reused, its
research is.
