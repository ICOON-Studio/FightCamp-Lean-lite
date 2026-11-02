# TASK_Q157 - the grappling clip gap: bind the ~189 grappling techniques to the holds we OWN, by family (Qwen)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S62, 2026-09-24, on the operator's
direct ask: "Coverage: 158 of the 534 techniques that need motion have a clip (29.6%). Grappling
is the biggest gap: most of the ~189 grappling techniques have no motion of their own yet."

## Why
`Godot/tools/q133_clip_coverage.gd` reads `assets/data/technique_catalog.json` and classifies every
technique that needs motion as EXACT (its own binding), NEAR (an alias in
`FightBeatAdapter.TECHNIQUE_CLIP_ALIASES` to a bound key) or NONE. Last count: EXACT 26, NEAR 132,
NONE 376, covered 158/534. The grappling branch is where NONE lives. We cannot author 189 clips,
but we OWN 21 paired holds already (`FightClipBinding.PAIRED_BINDINGS`, line ~1837): grapple_sweep,
grapple_takedown, grapple_throw, grapple_submission_attempt, grapple_submission_finish,
grapple_escape, grapple_clinch_break, grapple_control, grapple_stand_up, bjj_north_south,
bjj_front_headlock, bjj_guard, bjj_5050, bjj_open_guard, bjj_turtle, bjj_mount, mma_guard_gnp,
bjj_back_control, bjj_half_guard, bjj_side_control, mma_dirty_boxing. A technique performed FROM
side control, or a sweep FROM guard, has a hold we own that shows the right two bodies in the
right seat. Binding each grappling technique to its FAMILY hold is the whole task.

**THE TRAP THIS PROJECT ALREADY PAID FOR (read before you map anything):** coverage once went
19.3% -> 83.4% "on a list matched by NAME and not one clip was opened" - `boxing_double_jab` was a
single jab, `muay_thai_horizontal_elbow` was a spinning elbow aimed behind him. So a family
binding is a THIRD class, `FAMILY`, reported on its own line and NEVER added into
"Covered (EXACT+NEAR)". And every mapping carries a one-word reason (the seat or the action
family) so a later reader can tell a judgement from a name match.

## Owned files
- `Godot/scripts/FightClipBinding.gd` - 2,509 lines, NEVER open it whole. Windows only:
  `sed -n '1753,1840p'` (the rung-2 header and the start of `PAIRED_BINDINGS`), `sed -n
  '1837,1965p'` (the 21 keys). Add ONE new const after `PAIRED_STRIKE_BINDINGS` (line ~1962):
  `PAIRED_FAMILY_BINDINGS := { "<technique_id>": {"pair": "<one of the 21 keys>", "why": "<seat or family word>"} }`
  and ONE static resolver `family_pair_for(tid: String) -> String` ("" when unmapped).
- `Godot/scripts/FightBeatAdapter.gd` - ONE seam only: `grep -n "_clip_role_for\|has_clip" ` and
  make the paired lookup fall through to `Binding.family_pair_for(tid)` AFTER the raw id and the
  alias table have both missed, so a mapped grappling beat grafts the family hold instead of
  nothing. Do not touch any other function.
- `Godot/tools/q133_clip_coverage.gd` (228 lines, read whole): add the `FAMILY` class in
  `_classify` (after NEAR, before NONE) and print it on its own line plus a per-branch column.
- `research/Q157_DIGEST.md` (new).

## Do
1. Run `q133_clip_coverage.gd` on the UNCHANGED tree first; paste its output into the digest as
   the BEFORE (grep the grappling branch rows - the tool prints a per-branch table).
2. List every NONE technique in the grappling branches (the catalogue's `branch`/`discipline`
   fields - find the key names with `python -c` over the JSON, do not read 26,785 lines). For
   EACH, choose the family hold from the 21 keys by the technique's SEAT (mount / side / back /
   guard / half / turtle / north-south / front headlock / 50-50) or, when it is an ACTION rather
   than a position, by the action family (sweep / takedown / throw / submission attempt /
   submission finish / escape / stand-up / clinch break / control / dirty boxing). A technique
   that fits NO key stays unmapped and is listed in the digest under "no family hold owned" with
   its seat - that list is the next purchase/authoring order and is worth as much as the mapping.
3. Wire the seam in `FightBeatAdapter` and the `FAMILY` class in the tool. Run the tool again:
   the AFTER. Print EXACT, NEAR, FAMILY, NONE separately; "Covered" stays EXACT+NEAR.
4. OPEN FIVE: for five mapped techniques of different seats, run
   `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q133_clip_coverage.gd -- verify`
   (the tool's verify mode loads bindings and prints track counts) and record what loaded.
   A mapping whose hold fails to load is removed, not left in.
5. Digest: BEFORE and AFTER tables verbatim; the mapping table (id, pair, why); the unmapped
   list with seats; the per-branch grappling row before/after.

## Gate
Tier: scripts edited - parse gate, focused tests, then the tests of the systems touched:
`python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/scripts/FightBeatAdapter.gd Godot/tools/q133_clip_coverage.gd`
then `python Godot/tools/run_tests.py --only fight_hold_binding,paired_clip_mount,fight_clip_alias,fight_beat,grapple_adapter,fight_clinch_binding`
- all green or the ones that were already red named with their reason (fight_pair_live is
PARKED by the operator and stays red). No full suite. Branch `qwen/q157-grappling-family`, one
`python Tools/agent_comms.py send --from qwen --to claude --topic Q157 --body "<EXACT/NEAR/FAMILY/NONE before -> after, grappling row, unmapped count>"`.
Do NOT edit HANDOFF.md.
Traps: this checkout is a WORKTREE - `git fetch origin && git checkout -B qwen/q157-grappling-family origin/master` first.
`Paired_FullMount_AttackBlock_Vic` carries "Att" mid-name - never test a half by substring.
`var x := <Variant call>` is a parse error - write the type.
