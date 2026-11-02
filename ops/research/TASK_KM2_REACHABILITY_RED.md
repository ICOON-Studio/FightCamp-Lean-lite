# TASK KM2 - The reachability contract has been red every night: find out why, fix the right side

Owner: **Kimi** (Kimi Code CLI, model kimi-k2.7-code, pay-per-use). Assigned S122 (Claude), 2026-09-29.
Queued behind the KM1 review trial. Bounded, and checkable by a machine. How it is judged: the test result on master, the
evidence in your digest, and whether you stayed inside the owned files.

## Why
`Godot/tests/fighter_reachability_contract_test.gd` (C158, "directional reachability witness") fails in the
nightly suite every night since at least 2026-09-26 (AgentComms/nightly/latest.txt, 2026-09-28 at 6d2a4201):
`engine-error (8 lines: ERROR: f01_m_box_welter neck 0.15 has no usable approach)` - also "fewer than five usable
approaches" for neck 0.15 and neck 0.50. A red test that everyone walks past hides the next real failure.

## What would a human do?
A gameplay engineer reads the test header and the digest that introduced it (C158) to learn what "usable
approach" means and why five were required, runs the test alone, then finds the commit that turned it red
(`git log` on the files it loads: FighterCapsules.gd, FightPoseSolver.gd, FighterPhysique.gd, the rig .glb) and
checks the test at the commit before and after (`git stash` is FORBIDDEN in this project - use a second checkout
or `git show <rev>:<path>` into a temp file). Then decides: the GAME regressed (fix the code that broke it, with
the before/after numbers) or the TEST pins something the design has since changed on purpose (restate the test
and quote the change). Never loosen a threshold just to pass.

## Prior research (primary studies - read the relevant section)
- `research/C158_DIGEST.md` - the witness itself (read whole). `C157_DIGEST.md`, `C159_DIGEST.md` - its
  neighbours.
- `research/S48_THE_TORSO_AND_THE_HOLD.md` (torso capsule, penetration), `J43_WHERE_THE_RIB_CAGE_ENDS.md`,
  `C211_DIGEST.md` (neck reach, surface anchors vs skin).
- All research is open: root `RESEARCH_INDEX.md`.

## Prefab check
None: this is our own capsule/solver code and its test.

## Build
1. Run the test alone (command below). Record the exact failing lines.
2. Find the breaking commit. Decide GAME-IS-WRONG or TEST-IS-STALE with evidence.
3. Fix on the right side. Re-run: the test passes.
4. Run the subset below; nothing that passed before may fail.

## Gate
- `fighter_reachability_contract_test` passes, OR the digest proves exactly why it cannot (ceiling, not an exact
  count).
- Subset still green: `python Godot/tools/run_tests.py --only fighter_capsule,fight_pose_solver,fight_body_overlap,capsule,fighter_physique --jobs 2`
  (report every red with whether it was already red on origin/master - run it there too).

## Tests (tier: script edited)
Parse gate first: `python Godot/tools/check_scripts.py <every .gd you touched>`. One test:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fighter_reachability_contract_test.gd`
First run in a fresh checkout imports the project (slow, once). NEVER the full suite. Never kill Godot by image
name (other agents run it) - only processes you started.

## Owned files
`Godot/tests/fighter_reachability_contract_test.gd` (172 lines - read whole), `Godot/scripts/FighterCapsules.gd`
(1,148 lines - grep -n, then read windows), `Godot/scripts/FightPoseSolver.gd` (732 lines),
`Godot/scripts/FighterPhysique.gd` (280 lines). NOT FightWorldLiveScreen.gd / FightStagePlayer.gd (Cursor holds
them), NOT FightRealtime.gd.

## Deliver
You are in worktree `D:\FightCamp\wt\KM2` on branch `kimi/km2-reachability` (from origin/master). Commit per step
with a message that says what and why, push the branch (never master), write `research/KM2_DIGEST.md`
(the failing lines, the breaking commit, the decision with evidence, before/after, the subset result), then run
`python Tools/agent_comms.py send --from kimi --to claude --topic KM2 "<one line>"`. Do NOT edit HANDOFF.md,
CURRENT_STATUS.md or the roadmap.

**The trap:** "SKIP - rig absent" prints `checks=0 failures=0` and looks green. A skip is not a pass - if the rig
does not load, find out why (import cache, path) before you touch anything else.
