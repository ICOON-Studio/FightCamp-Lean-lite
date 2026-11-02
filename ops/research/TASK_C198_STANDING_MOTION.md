# TASK_C198 - STANDING: the fight must look like the RamsterZ reel (Codex, standing brief, full branch)

Model: gpt-6-astra, medium (3D animation - CODEX_MODEL=gpt-6-astra). Web search ON (CODEX_WEB=live). Owner: codex.
Assigned S72, 2026-09-25. **STANDING WORK: this does not finish in one pass.** Each pass ends with a video and a
list of what is still wrong; the next session reads it, re-cuts this brief and relaunches you.

Worktree `%TEMP%\FightCamp-C198`, branch `codex/c198-standing-motion`. Push the branch; never push master.


## PASS 3 (S73, 2026-09-25) - read this first; pass 2 delivered e78a4ed9 (framing 100% in frame, overlap 10.33% -> 8.94%)
**Why this lane matters most right now:** the plan (`research/S73_PRODUCT_AUDIT_AND_PLAN.pdf`) recommends v1 ships
STAND-UP sports first (boxing, kickboxing, Muay Thai); MMA/grappling follows. Standing motion IS the v1 product.
## What would a human do? (operator rule 2026-09-25)
A fight-game animator judges a standing exchange from the broadcast camera: do the fighters stay out of each other,
does a punch that lands look like it lands, and do hands and gloves meet what they hit. Watch first, then fix what you saw.
Pass 3, in order: (1) the two large HAND-CONTACT misses; (2) the 26.1 cm worst overlap; (3) cage/ropes obstruction of the
camera. Legal fighters only - boxers in boxing gloves under boxing rules, kickboxers/Muay Thai under theirs, never two
identical men. Same gates as pass 2: OFF byte-identical, defaults OFF, before/after MP4 md5 must differ; push the branch.
All research is open via root `RESEARCH_INDEX.md`.
## PASS 2 (S72, 2026-09-25) - read this first; pass 1 is merged-pending
Claude opened `c198_pass1.mp4`: in several frames the pair drifts to the edge of the shot or out of it at the fence
(the follow camera loses them) - your digest did not report this. PRIORITY 1 now: the pair stays framed every frame
of a 60 s bout (measure: both fighters' screen boxes fully inside the frame, % of frames; print it). Then continue
overlap (10.33% -> down) and the per-switch default decisions. You stay HEADLESS - do NOT use the live Blender MCP
this pass (C199 owns the operator's scene).

## The lane (operator 2026-09-24/25)
Agents own ENGINE and MOTION; Claude owns management and GUI. You are the 3D-animation agent. You do your OWN
research - web, the repo's research/ folder, the 38 min of paired mocap under `research/_captures/` - before you
build. You may NOT buy clips. Higgsfield credits: operator grant 2026-09-25 - up to 150 credits across ALL Codex tasks
without asking, ONLY through `Tools/higgsfield/loop.py` + `budget.py` (the ledger refuses past the ceiling; never edit it).

## The objective, in priority order
Operator, verbatim 2026-09-24: "We are not buying other clips unless I see the quality that I see on the YouTube
preview videos." We own the reel's Hand to Hand Set. The standing fight is where the eye goes first.

1. **ONE LOOK, ALL ON.** The take-four fixes are all behind default-OFF switches in `FightWorldLiveScreen.gd:686-707`:
   `strikes_play_whole` (C190), `reactions_play_whole` (U159), `contact_stop` (C191), `readable_onset` (U165),
   `human_speed_tempo` (U164). Record seed 92012 MMA with ALL of them ON (`tools/record_room.gd`), open it, and list the
   three worst things a viewer sees. Then decide, per switch, whether it is ready to default ON - a switch that makes
   anything WORSE on screen stays OFF and you say why. Flipping a default is YOUR call, stated with the before/after.
2. **Overlap.** C191 left 14.56% of frames with >3 cm body overlap and a 29.8 cm worst (low-kick window). Get it down;
   the instrument is `tools/c191_clip_census.gd` (read it whole, 146 lines). Never buy a lower number by stopping
   strikes from landing: landed punches must still end within ~1-2 cm of their target, as C191 measured.
3. **Strikes that land where they aim.** C190 status: nearest-clip target-height mismatches remain. Fix them by
   picking/warping, not by hiding the hand.

## Every pass ends with
- An MP4 (854x480, 30 fps is enough) committed under `research/_captures/watch_loop/c198_pass<N>.mp4`, and a
  BEFORE of the same seed if you changed anything visible. OPEN IT and look before you write the digest.
- `research/C198_DIGEST.md` (append a section per pass): what changed, the numbers, **WHAT IS STILL WRONG**.
- `python Tools/agent_comms.py send --from codex --to claude --task C198 --body "<one line>"`.

## Files
Owned: `Godot/scripts/FightStagePlayer.gd` (4,118 lines - NEVER read whole; `grep -n` then `sed -n 'A,Bp'`),
`Godot/scripts/FightWorldLiveScreen.gd` **only the switch block :680-710 and the strike/reaction/contact_stop paths**
(3,865 lines - windows only). Cursor U171 owns the GROUND/grip paths of the same file (`_enter_ground_hold` :1898,
`_play_grapple_film` :1830, `_release_grapple` :1983) and `FightPoseSolver.gd` - do not edit those.
Tools you may add: `Godot/tools/c198_*.gd`. Research: `research/C198_*`.

## Gate (tier: a script edited)
- Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>` - a parse error HANGS a headless test.
- Then `python Godot/tools/run_tests.py --only fight_strike,fight_reaction,fight_contact,fight_room,fight_separation`.
  No full suite - Claude runs it at integration.
- A switch you flip ON must leave `tools/s70_feint_off_hash.gd`-style OFF paths byte-identical: prove it.
- Any WINDOWED Godot run goes through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.

## Rules that bind you
- NEVER test identical fighters; the population is named in the output (seed 92012 is grappler 175 cm v striker 185 cm).
- Commit messages end with `Co-Authored-By: Codex <noreply@openai.com>`. Stage explicit paths only.
- Do NOT edit HANDOFF.md. Do not read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## The one trap
A metric that can only improve lies: cutting volume or hiding contact makes overlap fall and the fight look worse.
Every number you report sits beside the video that shows it.

## LIVE BLENDER (connected S72, 2026-09-25)
Codex now has the operator's open Blender 5.2.1 through MCP server `higgsfield_blender` (tools `bl_execute`,
`bl_screenshot`, `bl_get_scene_summary`, `bl_import_motion`, ...). Use it to build and SHOW work in the operator's scene;
name everything you create with your task id prefix and never delete what you did not create.
**CREDITS: `bl_generate_3d`, `bl_generate_image` and `bl_image_to_3d` spend Higgsfield credits DIRECTLY, outside the
ledger.** Before EVERY such call, reserve it: `python -c "from Tools.higgsfield import budget; print(budget.task_reserve('<task>', <estimate>, '<purpose>'))"`
- a refusal means the 150-credit grant is spent: stop and say so. Afterwards record the actual with `budget.task_update(<token>, status='done', actual=<credits>)`.

## PASS 4 (S74, Claude review of 48e310e9) - TOWARD A MERGE
Pass 3 verified here: before/after MP4s differ (md5 b5167ac9 vs 0c435d67 MMA, e0ced426 vs 243107df boxing); the two
large hand misses now reach. It is NOT merged because overlap FREQUENCY regressed while the worst depth improved.
1. Fix the frequency regression without giving back the reach: report worst overlap AND share of frames overlapping,
   before (master) / pass 3 / pass 4, on the SAME seed, population and camera. A change that moves only one of the
   two is not done.
2. The career now fights in the 3D arena (S74): record from a CAREER bout too - `Godot/tools/s64_career_walk.gd` with
   `research/s74/walk12.plan` reaches a live boxing bout - so the motion is judged where the player sees it.
3. Rebase on master (S74 moved career fights into FightWorldLive and added `set_player_view`, `career_mesh`).
Deliver: two MP4s (before/after, md5 both), the two numbers per arm, a merge-ready branch. Same worktree/branch.
