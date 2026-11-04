# S383 - next session (written S382, 2026-11-04 evening)

START in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. The S382 prompt is in git history.
FIRST: `list_sessions` - S382 ("Agent communications startup", cwd E:\FightCamp\Game) may still be live with 2 workflows
running (DEFFLOW1 build, training round 2). Collect what they pushed; never redo it. Their scripts:
C:/Users/user/.claude/projects/E--FightCamp-Game/db767ba5-bbfa-4c95-809c-837d924ef757/workflows/scripts/ (s382-*.js).

MERGED S382 (main 7dee627e; full suite on main 146/146 after a headless --import of the camp2 southpaw PNGs):
- 143b63d0 camp2: C229 camp (club nights free, $160 southpaw partner, film = answered tells, halved edges) + five gym
  ideas (threshold bars, weeks strip, spar nights = Playbook tests, LEGS/SCALE/RISK gauges, hover ghosts).
- adc972ec holo-off: no holo panels/close-ups in live rounds; corner card holo tints THIS round's hits ('head 16').
- 7dee627e MOVETIP1: hover any move card -> one shared card plays the move live (own World3D per clip player, partner
  reacts, ink card until the clip loads, compact card without a clip). Operator: "nice presentation for a skill it plays
  the animation". Ink move art (assets/ui/moves) is NOT on main yet - waits on movepics1 round 2 (glyph fallback).
- Docs on main: PLAYBOOK_SPEC_S381.md (f246d325), TRAINING_SCREEN_S381.md (d1eb9791), DEFFLOW_STUDY_S382.md +
  DEFFLOW1_DESIGN_S382.md (99b94ca6, critic-fixed). Calm Playbook mockup E:/FightCamp/tmp/s382/gameplan/playbook_calm.png.

OPERATOR DECISIONS S382:
- "Training screen first" (before the Playbook one-page build).
- "Yes, add flow": DEFFLOW1 Part B FLOW streak approved (N clean defences -> IN FLOW window, one-word cue, slow-mo replay).
- Sent a Canelo-on-the-ropes short with "!!" -> matched defences per punch (memory project_defence_flow_s382).
- Showed a skill-tree hover card from a game he plays (recorded 2 min: E:/FightCamp/tmp/s382/rec/, notes NOTES.md).
- PENDING: combo film claude/boxmap1 - park after round 6? (refuted: trapezius seams, glove above brow, IK tests
  tautological, body shot a straight). Claude recommends PARK; harvest SeamWeld/ShoulderCorrective into the fight later.
- PENDING: footwork r3 side clip verdict (sent S382; "his ass is bouncing" fix) -> then FOOTWORK2 wire into the fight.

DO IN ORDER:
1. Collect claude/training1 (round 2: evenings follow the strip = REST is rest in the sim + balance numbers; PLANTRAY1
   camp tray 'THE PLAN vs Maria' + UNDRILLED x0.8; click-through film; skeptic). Look at r2_*.png + eyes the film, merge.
2. Collect claude/defflow1 (A1 sim matched defences, A2 3D DefFire/DefPose timed to contact, B FLOW; prove films
   final_*.mp4 measured like the short; skeptic). Eyes yourself on the ropes film, merge when it passes.
3. movepics1 round 2 (39 rejected cards) -> merge -> the hover card + training tray get the ink art.
4. Playbook one-page build from PLAYBOOK_SPEC_S381 (10 stages; GamePlan.gd 550 lines gets deleted).
5. Boxmap: park unless the operator says one more round. Theatre-ground (C223 float) still unfinished.
6. Owned mocap bake (killed S381; inventory E:/FightCamp/tmp/s381/ownedmocap/), pocket pass, export + WHAT_TO_TRY.

PC: E: fixed (87 GB free, pagefile moved). The operator games on this PC (ArcheAge, 7-11 GB) -> watchdog RED for RAM/
heat often; every Godot launch goes through the gate (non-RED AND fewer than 2 Godot processes):
C:/Users/user/AppData/Local/Temp/claude/8016259957f41297/db767ba5-bbfa-4c95-809c-837d924ef757/scratchpad/gated.sh
(WT=<worktree> or run from the worktree root). New PNGs on main need a headless --import in the main checkout before
tests (revert the .import line-ending churn after). Ziva was DOWN at S382 start (not restarted - PC RED).
