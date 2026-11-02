# TASK U97 — CURSOR — TWO NEW REALISM RULES: R7 BODIES NEVER PASS THROUGH EACH OTHER, R8 THE FIST REACHES ITS TARGET

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u97-r7-r8` - Claude creates it from `master` before
launch. Push the BRANCH. Stage: S4a (the operator's "bodies overlap" and "punches look fake") - the gate the spacing
and strike-warp build is judged by.

**Test tier: A SCRIPT EDITED** (a test, a tool, a new module; no production script). Parse gate on every touched
`.gd`; then the runs below. No `run_tests.py` suite. `python research/U97_check.py` must exit 0 before you
commit - if it cannot, do not commit: send `--topic "U97 BLOCKED"` with its FAIL lines. ONE Godot at a time in your
worktree.

## Owned files

- `Godot/scripts/FightBodyCapsules.gd` - NEW. Your U95 capsule model MOVED here from the tool (see the contract).
- `Godot/tools/measure_body_overlap.gd` - uses the module; its own copies of the model go. Output unchanged.
- `Godot/tests/fight_stage_realism_test.gd` (1,403 lines - never open it whole) - R7 and R8, a `range=` arg, and the
  per-frame sampling they need. NOTHING in R1-R6 changes.
- `research/U97_overlap_room.json`, `U97_overlap_real.json`, `U97_realism_before.txt`, `U97_realism_after.txt`,
  `U97_realism_real.txt`, `U97_R7_R8.md` (30 lines at most) - NEW.

## Why this exists

The operator watched our 3D boxing match and named the worst things on screen: bodies overlap, punches look fake. Your
U95 measured the overlap (88% of frames) and Qwen's Q97 the punches (straights pass 0.3-0.4 m below the head at contact,
hooks 0.3 m wide); your U96 showed real spacing alone removes most of the overlap and makes every punch fall short. The
next build moves the men to real distance and warps each punch to its target. It is judged by the realism test
(`tests/fight_stage_realism_test.gd`), whose rules each print the real study they stand on - and it has no rule for
either complaint. This task adds them, measured through ONE capsule model shared with your instrument, so the gate and
the instrument cannot drift apart.

## The module contract (`FightBodyCapsules.gd`, `extends RefCounted`, no `class_name`, static functions)

Move, do not rewrite: `CAPSULE_DEFS`, `SPHERE_DEFS`, `CLASS_RANK`, `CLASS_PAIR_KEYS`, `THRESHOLD_M`, and the code behind
`_build_body_model`, `_collect_bone_vertices`, `_pose_parts`, `_pair_depth`, `_frame_overlap_skel`, `_class_pair_key`
and their helpers. Expose at least: `build_body_model(parent: Node, glb_path: String, kg: float) -> Dictionary` (mounts
into `parent`, frees what it mounted), `posed_parts(skel: Skeleton3D, body: Dictionary) -> Array` (world-space parts
with `name`, `class`, `a`, `b`, `radius`), `pair_depth(a: Dictionary, b: Dictionary) -> float`,
`class_pair_key(c1, c2, pa, pb) -> String`, and `frame_overlap(skel_a, skel_b, body_a, body_b) -> Dictionary` returning
what `_frame_overlap_skel` returns today PLUS `pairs`: every A-part/B-part pair deeper than `THRESHOLD_M`, each
`{"a_name", "a_class", "b_name", "b_class", "depth"}`. The tool then produces byte-for-byte the same numbers.

## R7 `bodies_never_pass_through` - GATED S4a

On every stepped frame, the pairs from `frame_overlap` for man A against man B. A pair is ALLOWED only when one of its
two parts is a GLOVE of a man in his CONTACT WINDOW and the pair is at most 0.13 m deep. A GLOVE is a `hand` sphere or
the `LowerArm-Hand` capsule on the same side (a boxing glove's cuff covers the wrist - INFERENCE). A man is in his
contact window on the frames within 3 frames either side of the frame his hand-strike take crosses its contact time
(`FightStagePlayer._contact_s[take]`: the first frame with `prev_pos <= contact_s <= pos`, exactly as Q97's
`measure_contact_miss.gd` finds it). Hand strikes are the roles `jab`, `jab_lead`, `cross`, `cross_lead`, `hook_lead`,
`hook_rear`, `uppercut`, `strike_head`, `strike_body` (the take name before `#`). Every other pair deeper than 0.02 m is
a VIOLATION. PASS iff there is no violating frame in the three bouts.
- study: `PHYSICS - two bodies cannot occupy the same space; U95 capsule instrument (2 cm threshold); a glove travels ~11 cm past first contact (Atha 1985 BMJ, via K50/K52)`
- real: `the men do not interpenetrate; at a landed blow the fist follows through ~0.11 m while the target yields`
- bound: `no pair deeper than 0.02 m except a glove in its owner's contact window (+-3 frames), and that at most 0.13 m (0.11 m follow-through + the 0.02 m threshold)`
- label: `PHYSICS / DOCUMENTED (Atha 1985, one punch) / INFERENCE (the window and the cuff)`
- measured: overlap and violating shares, violating frames by class pair (top 5, with frames), allowed-contact depth p95.
Then, one line per seed, exactly:
`    R7-SEED <seed> frames=<n> overlap_frames=<n> violating_frames=<n> allowed_contact_frames=<n>`
where `overlap_frames` counts frames with ANY pair deeper than 0.02 m (U95's definition) and
`violating_frames + allowed_contact_frames = overlap_frames`.

## R8 `the_fist_reaches_its_target` - GATED S4a

Every hand-strike take occurrence that crosses its contact frame (Q97's population). Its TARGET is the receiver's torso
capsules for `strike_body`, otherwise his head parts (`Head` sphere and `Neck-Head` capsule). It LANDED when the
receiver's take role is `react_head`, `react_body`, `react_leg` or `knockdown` on some frame in
`[contact_f, contact_f + 3]` and that receiver take started within 3 frames of `contact_f`. Its GAP is the smallest
surface distance (`-pair_depth`) between either of the striker's two `hand` spheres and any target part, over the
frames from the take's first frame to `contact_f + 2`. It REACHED when GAP <= 0.02 m. PASS iff every landed blow
reached.
- study: `PHYSICS - a blow that lands touches its target; Q97 (our straights pass 0.3-0.4 m low, hooks 0.3 m wide); K52: straights land on the jaw/lower face, hooks on the side of the jaw (Walilko 2005, Viano 2005, Cournoyer 2019)`
- real: `a landed blow puts the glove on the jaw or face (straight, uppercut), the side of the jaw or temple (hook), the trunk (body shot)`
- bound: `every landed hand strike's glove comes within 0.02 m (the U95 threshold) of its target part's surface by contact`
- label: `PHYSICS / DOCUMENTED (K52 impact points)`
- measured: landed, reached and share, gap p10/p50/p90 per role.
Then, one line per role with at least one contact, exactly:
`    R8-ROLE <role> total=<n> landed=<n> reach=<n> gap_p50=<m> fwd_p50=<m> lat_p50=<m> vert_p50=<m>`
where `total` is every contact of that role, and `fwd/lat/vert` are Q97's decomposition at the CONTACT FRAME over all
`total` contacts: `d = target_bone - far_hand` (target bone `Chest` for `strike_body`, else `Head`; far hand = the hand
farther forward along the striker skeleton's world `basis.z` from its origin), forward = that `basis.z` flattened and
normalised, right = `forward.cross(Vector3.UP)`, `fwd = d.dot(forward)`, `lat = d.dot(right)`, `vert = d.y`. Print
metres to 3 decimals.

## The `range=` arg

In `_run_bout`'s existing user-arg loop (the test's lines ~97-130): `range=<pocket>,<mid>,<long>` sets
`options["range_m"] = {"POCKET": p, "MID": m, "LONG": l}` - the room already reads it (U96).

## Anchors in the test

`_initialize` :64 (the rule calls; add `_rule_overlap(runs)` and `_rule_reach(runs)` after `_rule_ring`), `_run_bout`
:92 (arg loop :97-130, the stepping loop :145-156 - sample R7/R8 there, after `_sample`), `_side_context` :170,
`_sample` :215, `_rule_ring` :1266 (the shape to copy), `_rule` :1292 (use it; do not print RULE lines yourself), `_pct`
:1397. Build the two body models ONCE in `_initialize` (`FightWorldLiveScreen.FIGHTER_A` and its default
`FIGHTER_B`: f01 v f09) through the module.

## What to run, in this order

Godot runs go through `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py
C:/Users/user/AppData/Local/Temp/FightCamp-U80 <script> --timeout 3000 -- <args>` (never pipe the console Godot exe
into PowerShell - it deadlocks). A `SCRIPT ERROR` line means fix and rerun; rc=0 alone is not a pass.
1. BEFORE ANY EDIT: `tests/fight_stage_realism_test.gd` -> save its stdout as `research/U97_realism_before.txt`.
2. Write the module, refactor the tool, parse gate:
   `python Godot/tools/check_scripts.py Godot/scripts/FightBodyCapsules.gd Godot/tools/measure_body_overlap.gd Godot/tests/fight_stage_realism_test.gd`
3. `tools/measure_body_overlap.gd -- population=realism range=0.80,0.95,1.10 out=res://research/U97_overlap_room.json`
   and again with `range=1.07,1.23,1.39 out=res://research/U97_overlap_real.json`. Compare with
   `research/U96_real_spacing.json` `overlap.room` / `overlap.real` BEFORE touching the test: they must match.
4. Add R7, R8 and `range=`; parse gate; run the test -> `U97_realism_after.txt`; run it with `-- range=1.07,1.23,1.39`
   -> `U97_realism_real.txt`.
5. `U97_R7_R8.md`: `## DECISIONS` first - R7 and R8 at room and at real spacing (verdict, violating share, the top
   violating class pair; reached / landed per role), then one line on what the real spacing alone fixes.
6. `python research/U97_check.py` -> exit 0.

## Commit

`git status -s` first. Commit ONLY the owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u97-r7-r8`; `python Tools/agent_comms.py send --from cursor --to claude --topic U97-ready
--body <hash>`. Do not edit HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`,
`rebase` or `merge`.

## The trap

The tool running without `out=` writes `U95_body_overlap.json` over the committed U95 record - that happened in U96's
worktree. Always pass `out=`, and `git status -s` must not show `U95_*` or `U96_*` modified when you commit. And the
before-run is the only proof R1-R6 did not move: run it FIRST, on the unmodified test.
