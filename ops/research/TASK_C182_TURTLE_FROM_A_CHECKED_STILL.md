# TASK_C182 - re-author Turtle from a checked still; then re-probe closed guard on the S63 tree (Codex, full branch)

Model: `gpt-6-astra`, medium (3D animation design - operator ruling 2026-09-21). Launch with
`CODEX_MODEL=gpt-6-astra CODEX_EFFORT=medium`. Owner: codex. Assigned S63, 2026-09-24.

## Why
OPERATOR VERDICT 2026-09-24 on your C171 `Cascy_Turtle` render: **"its bad"**. The bottom man lies
FLAT on the mat instead of turtled, so it reads as a sprawl over a flattened man. REJECTED. The
lesson the operator gave with it is IMAGE FIRST: fix the picture of the position before posing to it.

## Part 1 - the still (image first)
Generate a reference still of a real BJJ turtle ride with `Tools/higgsfield/loop.py` (your C181
loop; `gpt_image_2_5`, 0.25 credit a still; **hard ceiling 3 credits for this part**, every job
logged to `HIGGSFIELD_PROMPT_LOG.md`). The still must show, and you check each in writing:
bottom man on **knees AND elbows**, spine visibly **flexed (rounded)**, head tucked, hips over knees;
top man **draped across his back/hips** (chest on his back, or seat-belt from the side), knees on
the mat. Commit the accepted still to `previews/c182_turtle_reference.png` and send one
line; Claude shows it to the operator. **Do not wait for the reply - pose to it** (a rejection
means one more pass, not a stall).

## Part 2 - author, export, bind, render
Your C171 loop (TASK_C171_THE_HOLDS_UNTIL_DONE.md, "THE LOOP"): declare the turtle contacts in
`Godot/tools/s31_contact_probe.gd` FIRST (bottom knees + elbows on the mat, top chest to bottom
upper back, top hands at the waist/seat-belt), author in Cascadeur to them, export
`Cascy_Turtle_Att.glb` / `_Vic.glb` over the rejected pair, render with
`tools/render_paired_hold.gd -- Cascy_Turtle` through `Tools\godot_hidden.ps1`, and **open the
sheet yourself**: if the bottom man is flat, it is not done. Gate: worst contact <= 30% (a CEILING;
report lower), sheet side-by-side with the Part 1 still in the digest.

## Part 3 - closed guard on the S63 tree
S63 (Claude, this session) wires `FightPoseSolver` into the live room for paired holds behind
`contact_solve` (ON). Once it is on master (`git fetch && git rebase origin/master`), re-run your
REJECTED C170 candidate (`C:/Users/user/AppData/Local/Temp/c170-authoring/`) through the probe with
the solve ON and OFF and print both columns. If the wrist grip now holds <= 30%, admit the GLBs and
the binding; if the same-body ankle lock still drifts, say by how much - that one the hand solve
cannot fix, and it is a finding.

## Owned files
`Godot/assets/anim/audition/cascadeur/Cascy_Turtle_*.glb`, `Cascy_ClosedGuard_*.glb` (Part 3 only),
`Godot/tools/s31_contact_probe.gd` (turtle + closed-guard rows only), `Tools/cascadeur/build_turtle*.py`,
`previews/c182_*.png`, `research/C182_DIGEST.md`, `research/HIGGSFIELD_PROMPT_LOG.md`
(append). Never edit FightPoseSolver, FightClipRetarget, PairedStagePlayer or FightWorldLiveScreen.

## Gate (tier: assets + a tool)
Parse gate on any .gd; `python Godot/tools/run_tests.py --only paired_clip_mount,fight_hold_binding,technique_id_reference`.
No suite. Branch `codex/c182-turtle`, fresh worktree off `origin/master`; on a "TitleHonours" parse
error run `--headless --import` once. One `agent_comms.py send` per part. Do NOT edit HANDOFF.md.
Trap: a populated 24-tile sheet is not acceptance - C170 passed RENDER and SHEET with the grip 19 cm off.
