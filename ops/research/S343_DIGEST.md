# S343 digest - update 45: THE TAPE ROOM - her films, her flow, SPOT, your answer (2026-11-01)

Work in E:\FightCamp\Lean (main 6bc1a32; the tape room 28186cf). Build: Lean/Builds/FightCamp.exe (tools/export.sh).

## Operator inputs this session (verbatim)
- Board Q-S294-68 (tape room proposal TAPEROOM_S342.md), answered as a comment: "the player watches the films and it
  unflods like in grappleflows , player has appropriate counters for each clip to make his plan . put grappleflows in the
  game as core mechanic".
- "should we add a voice generator (not robotic voices,quality voices only) for the clip to describe the moves so the
  grappeflow picks it up?" -> answered no: our engine KNOWS every move it plays (the beat list is the narration), so the
  flow is drawn from it directly, exact and offline; GrappleFlows cannot ship inside the game (a paid web service). A
  quality coach voice-over could be polish later (his sound/money call after he plays it).
- "wanna try also your idea ?" (Claude's SPOT layer from the S342 proposal) -> built into the same room.

## What now works (evidence)
1. TapeClips.gd (pure): her file (OppFile) cut into 3-4 films - her game, her best weapon, a habit (before the weakness),
   her weakness; 15 film shapes (press, press_body, press_flurry, range, range_straight, counter, loadup, tiring,
   hurt_body, hurt_wild, drops_right, lunges, admires, slow_start, backs_up), each a ~8-9 s beat list with flow nodes
   (title, line, the label on the arrow in) and one tell node; her real record names the bout (RivalPast via
   Career.rival - the booked copy carries none). counters(when, habits, mastery): three moves out of the card the
   situation puts the fight on (PlanFight.GAME_CARD), one best / one ok-or-none / one wrong-or-none (PlanFight.ANSWERS,
   refine() so a hurt woman who hits back reads hurt_danger), unlabelled, the coach's line on what each DOES, greyed with
   "Learn the X first"; the answer's button position turns with the situation. pick(): a WHEN arrow replacing the one on
   that place+when. SPOT: spot_choices (her film's words + 2 others), spot_window (from 0.3 s before the tell node to
   2.2 / 1.6 / 1.0 s after by her rating - a top rival hides it better), spot_ok, watched() opens the tells
   (OppFile.open, new; tape() uses it). tests/tape_clips_test.gd: Maria vs Priya + every opponent/rival/national style.
2. TapeFilm.gd: her film on our own ring (FightStage, she in blue, the woman she fought in red, the referee) played by
   the fight's own beat switch (BeatFire); a FIXED in-ring hard camera (side-on, a little toward the other woman so she
   faces it, inside the ropes, widening when close) - the ring's shot director cut to a lens behind her shoulder and hid
   her hands; node stills cut from the viewport, cropped to the pair.
3. TapeRoom.gd: film left (TAPE tag + clock, Replay, Slow motion, SPOT), HER FLOW right (cards appear as the film passes
   them: still + title + line + time + who; pill edges; THE TELL marked), a hidden tell is a "?" card until SPOT names
   it; SPOT pauses on three choices (right = opens in her file now + names the node; wrong/late = that viewing only);
   YOUR ANSWER after each film (the tape suggests the answer once her file holds the tell); tabs per film (green when
   answered). Camp tab "Watch her tape" (film study bought), RosterActs "taperoom", `-- jump=taperoom`, Camp's film
   blurb. tests/tape_room_test.gd (the real buttons: nodes by the clock, SPOT early = spent, Replay + SPOT right =
   opens, suggested answer, two films two arrows, slow motion, Close), test_jump taperoom. run_tests 82/82.
4. Real-GPU stills (tools/taperoom_still.gd opp=0,2,megan; docs/playtest/S343/taperoom/; /review S343): both women
   head to feet, boots on, her face to the lens, no rope smear (the lens stays inside the ropes).
5. RISK TEST (the proposal's): the tells do NOT read on the body yet - Maria's "hands drop" keeps her gloves at her
   chin, Erin's right hand never drops (only the hook landing reads), Megan's lunge reads as a plain jab. TapeClips marks
   those beats `tell` (hand_drop / lunge / tired_guard / hands_low) -> TASK_TELLS1 (Goose #17) poses them.
6. MOVEPLAYER1 round 1 collected into main (6bc1a32, NOT wired): on a real GPU its probe read 3/5, not the 5/5 claimed
   (a finished clip leaves current_animation empty; the getters returned the values they set). Fixed: clips advance on
   their own length, the ghost reacts at contact, gap/alpha measured on the bodies/surfaces, the count holds the first
   pass -> MOVEPLAYER OK 5/5 measured. Visual gate FAIL (bare hands, feet out of frame, punches never reach at long
   range's middle, the pivot inside the ghost) -> round 2 (Goose #16): rebuild on FightStage bodies.

## Agent runs (in flight at the handover)
- TELLS1 (Goose #17, run 41297911140): TellPose.gd + tell_probe (TELL OK 4/4 on her bones) + the one BeatFire line.
- MOVEPLAYER1 r2 (Goose #16, run 41298441159), PADWORK1 r3 (Goose #13, run 41298536803: r2 FAIL - bare feet, box
  mitts, the hook's line re-printed the jab's glove; red stills docs/playtest/padwork_red/), CLINCH2 r2 again (Goose
  #14, run 41298574148: r2 timed out at 100 min waiting a whole bout - scripted beats now).
- FIGHTCARD1 r4 (Cursor, wt LEAN_FIGHTCARD1): ALIVE (RingCamera written 12:00) - the board's "dead" flag was wrong.
- SMOOTH2 stopped: r2 on CI OURS 344/min, 168 at a clip change (bound 310/150; baseline 377/203) - two red rounds,
  code audit of the clip-change joins before any third.

## Decided (and why)
- The flow is built from our own beat list, not from recognition: the engine knows what it plays (no voice-over, no
  GrappleFlows dependency in the game).
- Both mechanics in one room: his (watch -> flow -> counters into the plan) is the backbone, SPOT is the active layer on
  hidden tells; a wrong call costs only that viewing, so it never becomes a chore; passive tape study still runs.
- Counters stay unlabelled (reading her is the skill); the tape suggests the answer only once her file holds the tell.
- The Whimsical step is dropped: the tape room's flow column IS the GrappleFlows reference look now (TAPEFLOW1 next).
- Collect-time fixes on an agent's widget (MovePlayer sequencing, measured getters) done by Claude; animation defects
  (gloves, framing, reach, overlap) go back to the seat (S338).

## Next (S344)
Collect TELLS1 / MOVEPLAYER1 r2 / PADWORK1 r3 / CLINCH2 / FIGHTCARD1 r4 with the visual gate; TAPEFLOW1 (the plan's flow
view in the tape room's style); TAPEFIGHT1 (the real fight's HabitBeats mark the same tells); scouting step 3.

## Whimsical (operator: 'try also https://whimsical.com/')
Board https://whimsical.com/7MTv9msvNk7aXec4v8LbC9 (drawn through the connector, 18 objects, never its AI agent): Maria's film 1 as a top-down flowchart - grey move cards (title, one line, time), the tell filled blue, short labels beside the arrows, YOUR ANSWER a yellow diamond with three coloured pills. The reference for TAPEFLOW1 (the plan's flow view). Snapshot: Lean docs/playtest/S343/taperoom/whimsical_her_flow.png.
