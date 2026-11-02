# TASK_Q172 - clinch striking volume: the last D1 gap (Qwen, engine)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S73, 2026-09-25. Engine lane (agents build, Claude integrates).

## Why
S73 merged your Q171 at the DERIVED `GROUND_SIG_RATIO = 0.311` (not your tuned 0.40 - fitting a constant to its own
gate is not a finding). With it, `fight_pace_anchor_test` D1 reads **5.79/min** against J20's 6.0-8.0 band, and your
own `tools/q171_pace_decompose.gd` names the gap: position split **76.7 / 5.3 / 18.0** (distance/clinch/ground) against
J20's **72.6 / 13.4 / 14.1**. Clinch throws 0.67 significant strikes a minute; it should be ~2.5 times that.

## Do
1. Split the clinch deficit into its two factors, per pairing (name both men - the identical-fighters rule binds):
   **share of fight time spent in the clinch** x **significant strikes thrown per clinch minute**. J20 section A has
   the per-position figures (`grep -n "clinch" research/J20*.md`); quote the one you compare against.
2. Say which factor is out. Too little clinch TIME is an entry/exit mechanism (who ties up, how long it holds, how
   the break happens); too few strikes PER clinch minute is the clinch's own strike choice. Fix the mechanism of the
   one that is out.
3. NEVER by raising a global strike rate or `throw_gate_base`, and NEVER by retuning `GROUND_SIG_RATIO` - distance
   and ground are already on or near J20. If both factors are fine and the gap is how the TEST counts clinch
   strikes, fix the count and quote the definition.
4. `feint` and `trap_arm` default OFF must stay byte-identical for boxing and kickboxing unless you intend to change
   them: run `Godot/tools/s70_feint_off_hash.gd` before and after and paste both.

## What would a human do? (operator rule 2026-09-25 - answer this in the digest before the fix)
How does a real fighter use the clinch? Who ties up and why (a wrestler pinning a striker to the cage, a Muay Thai
fighter in the plum), what he throws there (short knees, elbows, dirty-boxing uppercuts), how long it lasts, and how a
real referee or opponent breaks it. J20 has the counted numbers; fight footage (`Tools/footage`) shows the behaviour.
Build the mechanism a coach would recognise, then check it against J20.

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,850 lines - NEVER open it whole; `grep -n "clinch"` and `sed -n 'A,Bp'` windows),
`Godot/tools/q171_pace_decompose.gd` (extend it with the clinch split), `research/Q172_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. Then `fight_pace_anchor_test` alone, then
`python Godot/tools/run_tests.py --only fight_pace`, `--only fight_realtime`, `--only feint`, `--only judge`,
`--only clinch`, `--only ground` (ONE `--only` per run; read `total=` each time). Ceiling: D1 in band with the split
within 4 points of J20's clinch share, or the remaining gap explained by the decomposition; no new red vs master.
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`: `git fetch origin && git checkout -B qwen/q172-clinch-volume origin/master`.
Commit explicit paths, push,
`python Tools/agent_comms.py send --from qwen --to claude --topic Q172 --body "<which factor was out, the fix, D1 and split before/after, OFF hashes>"`.
Do NOT edit or read HANDOFF.md, CURRENT_STATUS.md or any digest but J20's and Q171's.

## The one trap
Your Q171 commit swept a pre-staged mail file into its commit. Run `git status -s` and `git diff --cached --stat` before
every commit and stage only your owned paths.

## PASS 2 (S74, Claude review of c6dbf695) - NOT MERGED YET, three defects
1. **The digest has no `## What would a human do?` answer.** The task required it BEFORE the fix. Write it: who ties up
   and why, what is thrown there, how long a clinch lasts and how it is broken (J20 + footage). Then say whether
   `CLINCH_ENGAGE_BASE 0.0040` is what that behaviour implies, from clinch TIME share (J20), not from the D1 band.
2. **Boxing OFF hash is missing.** Your table shows kickboxing and MMA only. Add boxing seeds (before/after) from
   `Godot/tools/s70_feint_off_hash.gd`; they must be byte-identical.
3. **You loosened two tests you did not own** (`fight_realtime_test.gd` MMA leg-share floor 6% -> 5.5%, and a 1%
   fatigue epsilon). A gate relaxed to fit a change is not a pass. Revert both. If the leg share genuinely drops
   because more time is spent in the clinch, PROVE it with the decomposition (distance-phase leg share unchanged,
   before vs after) and put that number in the digest; only then re-set the floor, citing J20's leg-share anchor.
   The `judge_panel_test` muay_thai_17 re-pin is acceptable only with a one-line reason in the digest.
Same worktree and branch (`qwen/q172-clinch-volume`), same gate, amend nothing - add a commit, push, send one line.
