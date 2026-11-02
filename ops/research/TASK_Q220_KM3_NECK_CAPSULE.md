# TASK Q220 (roadmap KM3) - the neck of the shipped MPFB men is buried by the chest capsule (Qwen, S133)

Model: qwen3-coder (launcher default). Worktree `D:/FightCamp/wt/Q219` re-branched `qwen/q220-km3-neck` from master.

## Why
`tests/fighter_reachability_contract_test.gd` is red every night (nightly 2026-09-30: `ERROR: mpfb_m_178 neck 0.15 has
no usable approach`). The diagnosis is on record (KM2 run, kept): the Chest->Neck thorax capsule's END-CAP buries the
neck (0/128 approaches usable at 0.15 and 0.50) on the MPFB men, the shipped male bodies (S117 D5). A red test everyone
walks past hides the next failure. Read `TASK_KM2_REACHABILITY_RED.md` (same test, same owned files) for method and gates.

## Prior research
`C158_DIGEST.md` (the witness, read whole), `S48_THE_TORSO_AND_THE_HOLD.md`, `J43_WHERE_THE_RIB_CAGE_ENDS.md`,
`C211_DIGEST.md` (neck reach), S55 (split_inlet collapsed the G73 upper-chest skin hold 47% -> 5% - the trap below).

## What would a human do?
Shorten or taper the thorax capsule's top so it stops at the base of the neck on THIS rig (measure where the MPFB neck
bone starts versus the capsule end), keep the chest volume, and prove both sides with numbers.

## Prefab check
None - our own capsule code.

## Owned files
`Godot/scripts/FighterCapsules.gd` (1,148 lines - grep -n, read windows), `Godot/tests/fighter_reachability_contract_test.gd`
(read whole; restate ONLY with quoted evidence that the design changed), NEW `research/Q220_DIGEST.md`.
NOT FightWorldLiveScreen.gd, FightStagePlayer.gd, FightRealtime.gd.

## Gate
- `fighter_reachability_contract_test` passes on the shipped MPFB men, with DIFFERENT fighters (never one body twice -
  KM2 was rejected for exactly that).
- A/B: the G73 skin-hold share on the upper chest does not collapse (report before/after; S55's 47% -> 5% is the failure).
- Subset: `python Godot/tools/run_tests.py --jobs 2 --only fighter_capsule,fight_pose_solver,fight_body_overlap,capsule,fighter_physique,fighter_reachability`
  (report every red and whether master had it red too).
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FighterCapsules.gd`. One test:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fighter_reachability_contract_test.gd`

## Deliver
Commit, `git push -u origin qwen/q220-km3-neck` (explicit `git add` by path), 10-line digest with before/after.

## The one trap
Never loosen a threshold or reuse one body for both fighters to go green. Fix the geometry.
