---
name: project-session-s118-2026-09-28
description: S118 - boxing 2/36 (cross); feints stop eating punches; C223 hook/uppercut timing bands were a K32 misread; body skin follows the portrait; judge fixture de-identicalised
metadata:
  node_type: memory
  type: project
  originSessionId: 71d193c3-2b90-4949-9883-710667684dc1
  modified: 2026-09-28T09:11:59.160Z
---

S118 (2026-09-28), stage B, milestone PLAYABLE WITH A BOXER. Digest `research/S118_DIGEST.md`.

- C223 run 7 (Codex) merged as a diff `10223311`: boxing 2/36 (jab + cross = owned RamsterZ H2H_StraightPunchInPlace).
  Run 8 launched (TASK_C223 "RUN 8"): re-gate hooks/uppercuts, then fix the shared JOIN failure.
- The C223 worktree's rebase onto master conflicts because master merges runs AS DIFFS; a force-push reset was
  refused by the permission classifier. What works: `git merge origin/master` into the branch, take master's side
  on add/add conflicts. Untracked .import/.uid files that master tracks block checkout - delete only those.
- Gate defect: C223 TIMING_MS for hooks/uppercuts misread K32 (uppercut 606-627 = two study MEANS; hook floor 477 =
  Piorkowski ACTION clock). Fixed to K32's fist-onset..Stanley bracket (`d6372beb`). Lesson: a band two means wide is
  not a tolerance - read the +- column.
- Feints bank the throw decision under boxing_output (`d9e71be5`): ~49 punches/round, feints 9.2/min.
- Body skin now follows the displayed portrait (12 male faces tagged in TaleOfTape.PORTRAIT_ANCESTRY) `f723113d`;
  tape same-face step was a 3-face rule -> silhouettes (`52a714c3`).
- judge_panel fixture was near-identical fighters (mma_5 literally 60 v 60) -> outboxer vs pressure pair in both the
  test and `tools/find_r101_seeds.gd` (now takes `panel <lo> <hi>`).
- Godot console exe spawns the real Godot as a CHILD: set priority on the child, and Idle starves it (20% of a core).
- U195 boxing census: prior log (pre-S117) showed the feint switch alone cut boxing finishes 36.7% -> 9.2%.

Related: [[project-session-S117-2026-09-28]], [[feedback-never-test-identical-fighters]]
