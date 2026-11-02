# TASK G158B - finish the 3 held-out switch tests (G158)

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/G158B, branch qwen/g158b from master. Push the branch; never master.
Never open a window, image viewer or browser. Headless only.

## Owned files
- `Godot/tests/switch_gate_angle_guard_test.gd` (restore from origin/arena/01a108de-fightcamp, ~165 lines, then fix)
- `Godot/tests/switch_gate_contact_push_on_line_test.gd` (restore from the same branch, ~13-line wrapper)
- `Godot/tests/switch_gate_hand_contact_sync_test.gd` (restore from the same branch, ~13-line wrapper)
- `research/G158B_FINDINGS.md` (NEW - your numbers)
Read-only: `Godot/tools/switch_gate_common.gd`, `Godot/tools/switch_gate_room.gd`, `research/G158_DIGEST.md`.
Do NOT edit FightRealtime.gd, the two tools/ libraries, or any threshold to make a test green.

## Prior research
`python Tools/prior_research.py hand_contact_sync contact_push_on_line angle_guard` -> G158_DIGEST.md (section "S162b local
verification") and S163_DIGEST.md. The three held tests and why:
1. angle_guard - `share ON 0.097 > OFF 0.097`: the OFF arm has c228_n=0, so it never measured the census metric; equal numbers are a
   coincidence. TEST BUG.
2. contact_push_on_line - lateral push ON 1.345 vs OFF 1.802 (wanted <= 0.7x). The switch helps ~25%, not 30%.
3. hand_contact_sync - hand pops ON 24 vs OFF 23 (wanted ON < OFF). Either the switch does not reduce pops (real defect in the CHOP3 fix,
   merged S134b as 8a2a0072) or the pop metric is blind to what it fixes.

## What would a human do?
Fix the test that measures nothing, then measure the two honest reds across more seeds before deciding anything - report, never loosen.

## Prefab check
N/A (our own test harness).

## Spec
1. `git checkout origin/arena/01a108de-fightcamp -- <the 3 test files>`.
2. angle_guard: make BOTH arms measure the same c228 angle-attack landed share (n > 0 in each arm, print n per arm). Then it must pass ON
   and FAIL under `G158_MUTANT=angle_guard`. Print the per-arm n and share.
3. contact_push_on_line and hand_contact_sync: run each on 6 seeds (the library's seed param, or the env var it reads - read
   switch_gate_room.gd). Record ON and OFF per seed in `G158B_FINDINGS.md` as a table + mean + paired diff. Do NOT change a threshold.
   For hand_contact_sync also write which frames the pops land on in each arm (the library's pop_count already walks frames; print the
   first 10 pop frames and the bone per arm) so Claude can check them on the game camera.
4. If after 6 seeds a test is still red with the switch ON, leave it red and say so in the findings - that is a correct result.

## Done = (tier: test files only - parse + each test)
`python Godot/tools/check_scripts.py Godot/tests/switch_gate_angle_guard_test.gd Godot/tests/switch_gate_contact_push_on_line_test.gd Godot/tests/switch_gate_hand_contact_sync_test.gd`
then each: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd`
(NEVER the _console exe). angle_guard: PASS ON, FAIL with `G158_MUTANT=angle_guard`. The other two: the findings table filled.
Final message: the three verdicts, the angle_guard mutant FAIL count, and the findings table. Commit + push qwen/g158b.

## The one trap
`--script` runs default every game switch OFF; the library sets each switch explicitly - print the EFFECTIVE value in each arm, or an
arm can silently be the same as the other (that is exactly the angle_guard bug).
