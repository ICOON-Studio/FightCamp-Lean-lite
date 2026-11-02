# TASK_Q169 - TRAPS slice 1: the isolated arm from mount (Qwen, engine build)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S67, 2026-09-24. Engine lane (agents build, Claude integrates).

## Why
The operator, 2026-09-24, verbatim: "I think we should use the word trap to resolve critical moments in the fight. Be a
factor in the submission event should be associated How other events like grappling maybe maybe we should do it proper
study and find ways to deepen the decision making of the fighter the logic Transition of moves".
Grok's design landed: `research/G72_TRAPS.md` - READ §0, §4 and §5 WHOLE, they are the spec. Your own Q168
(`research/Q168_SUBMISSION_BASELINE.md`) is the control arm: today mount opens 52 of 62 attempts (Pop A, current arm)
while real UFC finishes come 44.6% from the back and 5.0% from mount (G72 §2). A submission opens from "held mount N ticks"
with no setup and no defender choice. This slice makes ONE trap real and measures it.

## PART 0 FIRST - three reds your own Q164 and Q166 left when they met on master (S67 integration)
S67 merged Q164 (`6cc84e11`) and Q166 r4 + Q168 together; the full suite went 380/10 -> 384/13, and the control arms say
exactly whose each red is (run in the main checkout, one file reverted at a time):
- `fight_pace_anchor_test` - **D1 combined significant landed 8.31/min against J20's 6.0-8.0.** Reverting ONLY
  `FightRealtime.gd` + `GrappleResolve.gd` to `e37f6b9a` (pre-Q166) -> 20 checks, 0 failures. Q166 r4 made the fight
  more standing, so more strikes. Fix the MECHANISM (why did standing time rise?), never by throttling strike volume.
- `result_screen_why_test` - its fixture bout now scores 2 rounds, not 3 ("three scored rounds (2 / 2)", READ totals
  18-19). Same control arm -> 0 failures. If the engine is right, re-pin the fixture to a seed that still goes three
  scored rounds, found by a sweep and named in the test; do not weaken the assertion.
- `judge_panel_test` - **your two branches both re-pinned it and collided.** T4/T8R (the nine seeded bouts) needs one
  re-pin against the COMBINED engine; T11 ("boxing seed 109 a MAJORITY" now `unanimous_draw`) comes from Q164's boxing
  damage gate. Re-find T11's split and majority seeds with the S62 sweep on the combined tree, as the test says - never
  tune the engine back to an old seed.
Gate for Part 0: each of the three green alone, then `--only fight_realtime`, `--only judge`, `--only result_screen`,
`--only grapple` (one per run). Commit Part 0 as its OWN commit before any trap code, and say in the mail which of the
three were engine fixes and which were re-pins, with the numbers.

## Build (G72 §5 "Slice 1", nothing more)
1. **One trap: `isolated_arm`, seat `mount`, owner top.** A trap edge on GroundGraph (`kind: "trap"`, `to_seat == from_seat`,
   plus `limb: "arm"`) chosen by the EXISTING `GroundGraph.choose` and resolved by the EXISTING roll (`_success_probability`
   x edge `p_mod`, the four-draw contract - NO fifth draw). `p_mod` inside the graph's existing 0.70-1.30 band; say which
   value you used and that it is AUTHORED. `reward` 0 (the seat does not change). Winning it sets
   `g["trap"] = {id, kind, limb, seat, owner, held_ticks}` on the grapple state.
2. **The gate moves.** From mount, `sub_open` requires a live `isolated_arm` trap (FightRealtime.gd:4768 today:
   `(seat == "mount" or seat == "back") and held >= SUBMISSION_OPEN_TICKS and gates < SUBMISSION_OPEN_P`). BACK IS
   UNCHANGED in this slice (that is slice 2, `seatbelt_hooks`). While the trap is live the attempt is an ARM technique
   (Q74 target_region arm: kimura / americana / armbar / juji-gatame / ude-garami - pick from the man's known techniques
   with the existing `_grapple_technique_for`, filtered to arm). Progress ticks only while the trap is live.
3. **The defender's three answers** (G72 §4.5 row `isolated_arm`): `clasp_and_hide` (slows progress, trap stays),
   `turn_into` (may kill the trap; on a failed roll the seat becomes `back` for the top man), `explode_trapped_side`
   (upa-class reversal chance, else armbar becomes the only legal finish). Edges with actor = bottom, same chooser, same
   roll. No numeric weights beyond the existing score terms.
4. **Expiry** (G72 §4.6): a successful defender edge, a seat change, a stand-up/stall-referee, or the top man choosing
   advance/scramble kills it. Trap `held_ticks` is its own clock, not the seat's.
5. **The log line.** Every trap won, answer chosen and finish logs `trap.id`, `trap.limb`, the defender edge id, the
   technique - so a result screen can say "trapped the arm from mount, turned into it, took the kimura".
6. **Behind a switch, default OFF**, beside `ground_arm` (`trap_arm`). OFF must be byte-identical to today: prove it with
   the same-seed determinism rerun (the ONE legitimate same-seed use).

## Measure (extend YOUR `tools/q168_submission_baseline.gd` with a third arm `trap`)
Same two populations (R133 grappler 82 vs striker 34; brawler 55 vs kicker 28 - NEVER identical fighters; name them in the
output), 40 MMA bouts each, arms `current` / `graph` / `trap`. Pass if (G72 §5): (a) mount-originated finishes DROP,
(b) attempts per fighter-fight stay inside J20 D6 0.5-1.0, (c) finishes/attempt moves toward ~0.20 (FightMetric book), not
0.40, (d) the KO/TKO share does not move vs the `graph` arm, (e) the log carries a limb and a defender choice on every
trap-born finish. **Fail if bout-sub share is forced onto J20 D4 (17.2%) by a new constant.** Print the anchors beside the
numbers. Report honestly if (a)-(d) do not all hold - an informative failure is a result.

## Owned files
`Godot/scripts/GroundGraph.gd` (334 lines, read it whole), `Godot/scripts/GrappleResolve.gd` (251 lines, read whole),
`Godot/scripts/FightRealtime.gd` (**5,166 lines - never open it whole**; grep, then `sed -n 'A,Bp'` windows at the ground
branch `:4700-4830`, the constants near `:479`, and `_grapple_technique_for`), `Godot/tools/q168_submission_baseline.gd`,
`Godot/tests/ground_graph_contract_test.gd`, a NEW `Godot/tests/ground_trap_test.gd`, and for PART 0 only `Godot/tests/fight_pace_anchor_test.gd` (read-only unless its fixture is the defect), `Godot/tests/result_screen_why_test.gd`, `Godot/tests/judge_panel_test.gd`, `Godot/assets/data/combat_rulesets.json`, `research/Q169_DIGEST.md`.

## Gate (tier: scripts edited)
1. `python Godot/tools/check_scripts.py <every touched .gd>` before ANY test.
2. The new `ground_trap_test.gd`: trap won -> sub opens from mount; no trap -> no mount sub; each defender answer does what
   §3 says; expiry on seat change; OFF byte-identical. Break it 4 ways (mutants) and say each is caught.
3. Focused: `python Godot/tools/run_tests.py --only ground_graph`, then `--only grapple_resolve`, then `--only fight_realtime`
   (ONE `--only` per run - they do not stack; read `total=` each time). Ceiling: no new reds vs master.
4. No full suite - it is Claude's at integration.
Branch `qwen/q169-traps-slice-one` from `origin/master`. Commit with explicit paths, `git show --stat HEAD`, push,
`python Tools/agent_comms.py send --from qwen --to claude --topic Q169 --body "<numbers: 3 arms x 2 pops, att/fight, fin/att, mount share, KO share; test checks; mutants>"`.
Do NOT edit HANDOFF.md.

## The one trap specific to this task
A counter that cannot move reads as "no change": grep the engine for the exact `kind` strings you filter on before you
count (`submission_attempt`, not `submission_open`; a seat lives in `to_seat`, "ground" lives in `to_stance`). And the
trap arm must actually be ON in the `trap` rows - print the switch state in the output and one full trap-born attempt row
before trusting any table.

## ROUND 4 (S69, 2026-09-24) - the trap slice itself, behind its switch. Model: qwen3-coder, medium, `--yolo`.
**Round 3 was reviewed and collected IN PART.** Taken onto master: the `result_screen_why_test` re-pin to seed 92043
(verified green on master). **REJECTED, not merged:** the four GroundGraph edges (`isolated_arm`, `clasp_and_hide`,
`turn_into`, `explode_trapped_side`) as committed in fb456e90 - `GroundGraph.edges_from` does not filter by `kind`, so the
moment they are on master every mount exchange can pick them with NO switch, which breaks Build rule 6 (OFF
byte-identical). Also rejected: `judge_panel_test` boxing_219 - it is a majority only WITH those edges; on master it is
`unanimous_draw`. T11 stays red until a sweep ON MASTER finds a boxing majority. FINISH_P STAYS 1/60. Leave
`fight_pace_anchor_test` alone (8.31/min is recorded as an informative failure).

Do in this order:
1. Reset your branch: `git fetch origin && git checkout -B qwen/q169-traps-slice-one origin/master && git cherry-pick fb456e90`.
2. Make the edges INERT unless `trap_arm` is on: `edges_from(from_seat, actor, held_ticks, include_traps := false)` skips
   `kind` "trap" and "trap_defense" unless `include_traps`; the two callers in FightRealtime.gd (`_choose_ground_edge`
   ~:5096, `_choose_ground_edge_for_actor` ~:5142) pass `bool(state.get("trap_arm", false))`. Add `trap_arm` to the
   options read beside `ground_arm` (~:859) and to the state dict (~:967). Defender edges are candidates only while a trap
   is LIVE (`g.has("trap")`), never as free mount escapes.
3. Prove OFF: the same-seed determinism rerun, master vs your branch with trap_arm OFF, byte-identical logs. Print it.
   Then re-check YOUR local-only commit 724ab634's T11 seeds (boxing 677 majority, kickboxing 727 split): they were
   found with the edges live, so run `judge_panel_test` with them on THIS branch with trap_arm OFF. Keep them only if
   T11 is green there; otherwise sweep again on this branch (OFF) and say which seeds you used.
4. Then Build steps 1-5 and Measure above, exactly as written. The digest carries the 3 arms x 2 populations table.
Gate as above. Push, mail `--topic Q169`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or any digest but Q166/Q168/Q169's.
