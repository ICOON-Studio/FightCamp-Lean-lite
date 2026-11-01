# S344 - next session (written S343, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S343 shipped update 45: THE TAPE ROOM (operator Q-S294-68 + "wanna try also your idea ?") - her films on our ring, her
flow builds GrappleFlows-style beside the film, SPOT her tell, three answers into her plan. Digest:
Game\Godot\research\S343_DIGEST.md. Play it: `FightCamp.exe -- jump=taperoom`.

OPERATOR RULE S338: "keep all agents working on animations and you work on the mechanics and ui".

1. COLLECT with the visual gate (render on the hidden desktop, open every still yourself; a probe alone closes nothing):
   - TELLS1 (Goose #17, branch goose/tells1 or goose/issue-17): tools/tell_probe.gd TELL OK 4/4 measured on her bones,
     then YOUR render `tools/taperoom_still.gd -- <dir> opp=0,2,megan`: in each *_tell.png the tell plain to see (Erin's
     rear glove at her chest after the jab, Maria's guard at her chest, Megan over her front knee). Apply the DIFF
     (TellPose.gd, the tools, the ONE BeatFire line), never .uid leftovers.
   - MOVEPLAYER1 r2 (Goose #16): FightStage bodies, gloves + boots, head to feet, reach <= 0.12, min_gap >= 0.45. Then
     put it in the move map's bottom-left (StrikeBrowser), the key behind a "?", a click on a move or plan row plays it;
     in the tape room a counter's hover plays it.
   - PADWORK1 r3 (Goose #13), CLINCH2 (Goose #14, scripted clinch beats), FIGHTCARD1 r4 (Cursor, wt
     E:\FightCamp\wt\LEAN_FIGHTCARD1, out E:\FightCamp\tmp\FIGHTCARD1_r4_out.txt).
   - SMOOTH2 stopped (344/168 vs 310/150 after two rounds): a code audit of the clip-change joins before any third round.
2. TAPEFLOW1: the plan board's "See the flow" (FlowView.gd) in the tape room's GrappleFlows style - white cards with a
   still of the position, a short title, one line, pill edges; the card stills baked from CardStage once FIGHTCARD1
   lands (the Whimsical step is dropped: the tape room is the reference look).
3. TAPEFIGHT1: once TELLS1 is in, HabitBeats marks the same `tell` keys so the real fight shows her tells on her body.
4. Scouting step 3 - the scout trip (Godot/research/SCOUTING_S340.md), then OPPPLAN1, the sparring partner test.
5. The operator plays update 45 (WHAT_TO_TRY.txt top).
