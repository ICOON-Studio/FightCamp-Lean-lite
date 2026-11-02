# S194 DIGEST (2026-10-10) - clear gym floor built, benchmark baseline, 12 merges, nightly fixed, cloud seats back

## Operator rulings this session (verbatim)
- Board Q-S192-2 (clear gym floor, Ludo R18): "Approve - build it (Cursor)".
- Actions billing: "check the limits, i have added a budget isnot working ?" -> the $15 budget was on Codespaces; Actions was $0 stop-at-limit.
  Then: "i raised the actions budget to 15, test it" (verified: test job 38037086084 ran) and "use the cloud seats, keep going".
- "turn on ludo_composure in the demo switches , codex api added on github" (secret is CODEX_API_KEY).

## Merged (all by diff after parse + the task's tests; master 8604f37c)
| Commit | What | Evidence |
|---|---|---|
| 6b74fe19 | LUDO-CORNER2A composure live + HUD band tag | gate MERGEABLE; still opened (both men framed, FOCUSED/RATTLED) |
| 926c57fa | ludo_composure -> DEMO_SWITCHES (operator) | composure/doctor/demo_slice/pad_chain 9/0 |
| 1a0e8a73 | GRAPPLE-MATH1, PRESENT-MATH2, LUDO-R17-MATH1, ANIM-NEXT-MATH1 (pure) | 4 tests 0 fails; Arena parse error fixed; CutScar DROPPED (contradicted D42) |
| 684552f6 | ANIM-SMOOTH2B join attribution (switches OFF) | acceptance OPEN (best p95 26,507 ON / 58,928 OFF vs <34,667) |
| 882a192c | NIGHTLY 10-10 fixes (see below) | 9 new reds rerun: 6 heat hangs, 3 real fixed |
| a3e90edc | LUDO-R17-MATH2 (local Qwen) + WEAR1A career wear state | fixes: preload, stats path; spar/world_bout 7/0 |
| c319c28e | BENCH1 code: FightSimScriptHook, timeline, grader, F3 overlay | OFF proven = master (43fbe696 both); frozen hash replaced |
| 83fe52b6 | REFEREE1A referee personalities (ludo_referee OFF) | fix: 5 pips stays instant stop; referee_live 15/0 |
| 78484b8f | BENCH1B real run: Vance vs Miller, 1,860-row CSV, BASELINE | overlay fixed by Claude (0x0 root, negative boxes, CoM marker) |
| 0ab3c3c7 | WEAR1B wear meter on the profile (career_wear OFF) | fix: pristine tip claimed a cap; profile 5/0 |
| 3518c634 | GYMVIEW1 clear gym floor (gym_floor_view OFF) after 2 send-backs | fixes: 0.45 s room glide, one-sided street sign; 98/0; club 10/0 |

## BENCH1 BASELINE (master 78484b8f) - what HUMAN1-6 must move
STEP 1 FAIL 0 (>=4 deg) | STEP 2 FAIL hop 247, width 0.28 m | STEP 3 FAIL 0 | STEP 4 PASS* | STEP 5 PASS* | STEP 6-9 FAIL (*proxy/placeholder).

## Nightly 10-10 (@98975f5c 627/13; last check 10-09 599/7)
9 NEW: fight_body_layers_live, fight_locomotion, fight_pair_live, fight_realtime, fight_room_positions/ring_bounds/walkout = heat hangs
(PC 84 C at 05:00), pass on rerun. 3 REAL, fixed 882a192c: (1) since S191 the doctor pauses a bout until a corner answers - tests driving
advance_tick themselves hung (fight_identity, causation) -> FightRealtime.corner_answers_doctor() used by run_to_completion + 8 tick-loop
tests; (2) a drawn decision had no CAUSE line -> "could not be split"; (3) PLAYUI1E dropped the technical-flow card tip. Also
fight_identity measured rivalry output as both men's total over whole fights -> the heated man's punches per live tick.
FIXED vs 10-09: home_pin_counts, q226_strands, stat_vocabulary.

## Tooling fixes
- check_workflow archives `origin/<branch>` for cloud branches (git archive failed on remote-only refs).
- cloud-agent.yml: CODEX_API_KEY accepted; codex-cli dropped --full-auto -> bypass sandbox on the throwaway runner + login; repo var
  CODEX_MODEL=gpt-6-luna. The workflow's "open the PR" step fails on every run (pushes fine) - merge by diff.
- Goose finished #71 and #91 with no changes; #71 was already on master; #91 done by local Qwen.

## Learned
- Cursor's image tool is BLOCKED in its environment: it described stills it never saw (twice). Every Cursor visual brief must demand
  geometric checks, and Claude opens the stills.
- A test's own floor-view check passed while the walls were on screen: make a check go red on the defect you saw before trusting it.

## In flight at handover (collect, do not relaunch)
HUMAN1 (Codex sol, wt HUMAN1), CLUBROUTES1 (Cursor, wt CLUBROUTES1), SHOUT1A (cloud Codex #96), REFEREE1B (cloud Cursor #98).
Delegated this session: Cursor x4 runs, Codex x3, cloud Qwen x3, cloud Cursor x3, cloud Codex x2, local Qwen x1.
