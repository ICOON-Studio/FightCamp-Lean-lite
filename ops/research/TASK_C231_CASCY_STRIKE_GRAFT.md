# TASK C231 - single strikes authored in Cascadeur reach the game whole; finish the inside uppercut (animation, Codex)
Model: gpt-6-astra, medium (operator: "use astra model for 3d"). Owner: Codex. Worktree D:/FightCamp/wt/C231,
branch codex/c231-cascy-strike-graft (from master). Operator 2026-10-01: "cascadeur for those two moves, go ahead".

## Why
Your C229 (research/C229_DIGEST.md, on master) found the blocker: `FightStagePlayer._graft_retargeted` maps a
single strike through UE4_TO_OURS only, so a Cascy-skeleton export lost its Spine track; the carrier renamed Cascy joints
to UE4 labels as a workaround. The PAIRED route already understands Cascy. The inside uppercut came closest: attempt 2
cleared g147_pass on all four rigs and kept 1.00-1.20 cm head/torso overlap + one rear-arm pin pop on three rigs.

## Prior research
C229_DIGEST.md (all of it), S31_THE_AUTHORED_CLINCH.md (the paired Cascy route), Tools/cascadeur/README.md,
`grep -n "UE4_TO_OURS\|CASCY\|Cascy" Godot/scripts/FightStagePlayer.gd Godot/scripts/FightClipRetarget.gd` (FightStagePlayer is
~4,300 lines - sed windows only). Cascadeur server: `python Tools/cascadeur/csend.py -c "print(app.current_scene().name())"`
(start it with `python Tools/cascadeur/ensure_server.py` if down).

## What would a human do?
Fix the pipe once, the way the paired route already does it (a Cascy bone map chosen by the source skeleton), prove it
with a control (a UE4 source grafts byte-identically before/after), then re-run the closest move. Keep each change small.

## Owned files
- `Godot/scripts/FightStagePlayer.gd` / `Godot/scripts/FightClipRetarget.gd`: ONLY the single-strike graft's bone map
  selection (Cascy-aware like the paired route). Name every edited line range. A UE4/Mixamo/RamsterZ source must graft
  byte-identically (control: `python Godot/tools/run_tests.py --jobs 2 --only fight_clip,fight_stage_presenter,certified`
  green, and one certified move's C223 row unchanged).
- Re-export the inside uppercut WITHOUT the UE4-rename carrier; iterate it (lean, rear arm, lead knee) in Cascadeur until
  the gate passes on 4 rigs: `python Tools/c223_parallel.py production --jobs 2 -- plant phase live_contact bound clips=v_inside_uppercut report=c231_inside_uppercut.json`
  PASS = every row mechanical_failures [], g147_pass true, speed/onset in band, 0 pin pops. Then OPEN the side/game stills:
  rear glove at the chin, no turned back. Only then bind it (FightClipBinding `boxing_inside_uppercut` entry only) and
  add it to certified_moves.json with its certificate; flip its manifest pack (cascadeur_c229) to approved in the same commit.
- If time remains: the shovel hook through the same fixed pipe (its C229 failure was a turned back - fix the pose, not the gate).
- NEW `research/C231_DIGEST.md`; certificates `previews/c223/c231_*.json`; stills `previews/c231/`.
- Do NOT commit .casc scenes (4 MB each) - keep them in the worktree; commit scripts, JSON, compact game GLBs.

## Tests
Parse gate first; watchdog before every heavy run (`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`);
`python Godot/tools/run_tests.py --jobs 2 --only certified_palette,clip_binding,asset_manifest,fight_clip,fight_stage_presenter`.

## The one trap
A parse error HANGS a headless test. And the gate's printed TAKES label is the old source name even when the binding
points at the new file (C229 found this) - check the binding path, not the label.

## Finish
git add by explicit path, commit, git push -u origin codex/c231-cascy-strike-graft. Do not stop at "written".
