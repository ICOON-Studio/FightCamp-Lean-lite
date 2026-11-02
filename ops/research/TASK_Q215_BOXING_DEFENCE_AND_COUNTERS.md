# TASK_Q215 - Boxing defensive pieces, then the seven counters as sequences (C223 slice)

Owner: **qwen** (qwen3-coder, medium, `--yolo`). Model: qwen3-coder medium - fixed at assignment.
Milestone: PLAYABLE WITH A BOXER, stage B "the fight is WATCHABLE" - its gate "all 36 boxing moves play their own
C223-gated clip". Boxing is 11/36. Claude does the 5 single punches (shovel hook, up-jab, cross_body, inside uppercut,
overhand); THIS task is the counters group, split off so the two run in parallel (operator S121: "assign qwen to fix
animation too").

## Why
Seven boxing counters play a borrowed or partial clip today (`FightClipBinding.gd` provenance "near"):
`boxing_slip_counter` (slip clip only, no counter), `boxing_pull_counter`, `boxing_catch_counter`,
`boxing_counter_over_jab`, `boxing_check_hook`, `boxing_check_hook_pivot`, `boxing_counter_combination`.
Rows in `research/SHOT_LIST_STRIKING.md` (lines ~40-47) say what each must read as. A counter is a DEFENSIVE
piece followed by a punch that is ALREADY CERTIFIED - the roadmap rule (`now.next_action`): "counters as SEQUENCE
entries of certified parts".

## What would a human do?
A game animator does not capture "slip counter" as one take and hand-key it; they capture the defensive moves once
(slip left/right, pull back, catch/parry, pivot) and chain them into the punches with a transition window - UFC/Fight
Night use the start/ready/success structure (`SHOT_LIST_GROUND.md` names it). A boxing coach teaches the same way:
the slip, then the counter off the slipped position; the catch, then the return jab/cross. So: certify each defensive
piece as its own clip, then author each counter as a `"sequence"` of certified parts.

## Prior research (primary studies - read the relevant section)
- `research/J50_HOW_A_DEFENDER_DEFENDS.md` - the defensive options, which are real counters and their timing.
- `research/Q71_BOXING_EVASION.md` - which catalogue nodes slip, and what the tests derive.
- `research/R128_BOXING_KICKBOXING_TREES.md` - catch/parry/slip nodes in the boxing tree.
- `research/topics/defence.md` - canonical page (pointer only; read the studies above).
- `research/C223_DIGEST.md` - the gate rows and how moves were certified (runs 7-10, S120 pose layers).
- searched: slip counter pull catch parry pivot (`python Tools/prior_research.py`).

## Prefab check
Sources are ALREADY OWNED - do not buy or generate anything:
- slip: `res://assets/anim/audition/ramsterz_h2h/H2H_SlipLeft.FBX` / `H2H_SlipRight.FBX` (RamsterZ, owned; the
  operator prefers the RamsterZ look).
- pull back: `H2H_FadeBack.FBX` (RamsterZ); fallback Mixamo `D:/FightCamp/sources/mixamo/boxing/Boxing_Dodge_Retreat.fbx`.
- catch: `H2H_BlockStart.FBX` (RamsterZ) + a pose layer that puts the REAR glove at the own face; fallback Mixamo
  `D:/FightCamp/sources/mixamo/combat/High_Right_Block.fbx`.
- pivot: Mixamo `D:/FightCamp/sources/mixamo/combat/High_Left_Boxing_Pivot.fbx` (and Right).
Mixamo licence: free for use in games (Adobe terms); RamsterZ: purchased pack. Retarget the SAME way the certified
moves are bound (`"retarget": true, "reference": ...T_pose.fbx`, `plant_skin_floor`, `phase_matched_guard`) - copy an
existing certified entry's keys, e.g. `boxing_lead_hook` / `boxing_jab`.

## Build (in this order; push the branch after each piece)
1. **Four defensive pieces**, each its own binding entry and certified by the C223 gate on the four generated legal rows:
   `boxing_slip`, `boxing_pull` (fade back), `boxing_catch` (rear glove catches at
   the face), `boxing_pivot_out` (lead-ball pivot, rear foot swings ~90 deg). These four ids exist in the catalogue. Check the catalogue ids that exist
   (`grep -n '"id": "boxing_' Godot/assets/data/technique_catalog.json`); use the existing id when there is one, and do
   NOT add catalogue nodes (the smoke pin counts them).
   The gate: `tools/c223_production_gate.gd` (read its header for args) - skate, pops, floor, played whole, join to
   guard, both rigs; for a defensive piece "reach" is replaced by the SHOT_LIST row (head off the centre line for a slip
   / pull; rear glove at the own face for a catch; rear foot rotates for a pivot) - print that measure beside wanted.
   If a source fails a row, fix it with the S120 method: additive `pose_layer` (FightClipPoseLayer.gd) solved by number
   with `tools/s120_layer_solve.gd` before rendering (it now also prints elbow and forearm shape), and `strike_warp`
   for timing. Axis probe: `tools/s120_axis_probe.gd`.
2. **The seven counters as `"sequence"` entries** of certified parts (see `boxing_one_two`, FightClipBinding.gd:950):
   slip_counter = slip + cross (or lead hook); pull_counter = pull + cross on the return; catch_counter = catch + jab
   or cross; counter_over_jab = slip + cross over the top (use the certified cross; if the arm-over line cannot be
   shown by sequencing, STOP and report it - do not fake it); check_hook = pivot + lead_hook; check_hook_pivot = lead_hook
   + pivot (full turn); counter_combination = slip + jab + cross (+ lead hook). Each counter then passes the same gate
   as a whole played sequence (joins between parts included), `provenance: "exact"` only when it does.
3. Six stills per move at the game camera into `previews/c223/q215_<move>_<rig>.png` for Claude's eye -
   STILLS ONLY, NO VIDEO (operator ruling D3).

## Gate - a move counts only when
every C223 row passes on the four generated legal rows, mid-band (not edge-tuned), stills match its SHOT_LIST row,
provenance exact. Write the gate as a ceiling: certify as many as pass; list each that does not with the failing row.
Never test identical fighters; both fighters legal boxers.

## Tests (tier: script/data edited)
Parse gate on every touched `.gd`: `python Godot/tools/check_scripts.py <files>`. Then
`python Godot/tools/run_tests.py --jobs 1 --only clip,binding,fight_stage,boxing`. NEVER the full suite (nightly).
PC watchdog before each heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`
(exit 1 = do not start). ANY windowed Godot run through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Owned files
- `Godot/scripts/FightClipBinding.gd` (3,024 lines - NEVER open whole; `grep -n` then `sed -n 'A,Bp'`. Anchors:
  `boxing_one_two` :950, `boxing_pull_counter` :965, `boxing_slip_counter` :1014, `"slip"` :397). ONLY the entries of
  the eleven moves above - Claude edits the five single-punch entries in the same file at the same time; do not touch,
  reorder or reformat any other entry.
- `Godot/assets/data/clip_phases.json` - only your moves' keys.
- `Godot/tools/c223_layers/q215_*.json`, `Godot/tools/q215_*.gd` (new, yours).
- `previews/c223/q215_*`, `research/Q215_DIGEST.md`.
Small enough to read whole: `FightClipPoseLayer.gd`, `tools/s120_layer_solve.gd`, `tools/s120_axis_probe.gd`.

## Deliver
Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q215`, branch `qwen/q215-boxing-counters` from origin/master.
Commit and push the BRANCH after each certified piece (never master). `Q215_DIGEST.md` first line:
`boxing counters: pieces certified N/4, counters certified M/7`, then a table per move and rig: every gate row achieved
beside wanted. One `python Tools/agent_comms.py send --from qwen --to claude --topic Q215 "<one line>"`. Do NOT edit
HANDOFF.md, roadmap.json or roster.json. Do not read HANDOFF.md / CURRENT_STATUS.md / HANDOFF_ARCHIVE.md; all research
is open (`RESEARCH_INDEX.md`).

**Trap:** a sequence of two certified parts is NOT automatically certified - the JOIN between the defensive piece and
the punch is where pops and skate appear (C223 runs 8-9 failed on joins). Gate the whole played sequence, and print the
hand/root step at each internal join, not only at the join back to guard.
