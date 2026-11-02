# S342 digest - update 44: text walls trimmed, rules from real fight plans, attributes as bars (2026-11-01)

Work in E:\FightCamp\Lean (main 5402728 + the session's last commit). Build: Lean/Builds/FightCamp.exe (tools/export.sh).

## Operator inputs this session (verbatim)
- Board: Q-S294-66 "Yes, put them back" (six cleaned punch takes); Q-S294-67 "Yes, apply all 5" (real-plan rule edits).
- Review comments: C158 attributes board "better but still needs a lot of improvement"; C159/C160 flows "ok"; C161 plan
  board "can we have more explaining on this".
- "ok" (to "Should the next session upload our grapple clip to GrappleFlows as a recognition test?").
- "am connected [whimsical oauth link]", "sign in is done", "whimsical is open on chrome and also the windows app is installed".
- "you have room to put a player so that it displays the animation sequence with ghost opponent or something".
- "buy credits for whimsical" -> after the numbers: "Nothing yet (Recommended)".
- "https://www.flova.ai/en/skill/?tab=featured are these skills good for you ?"
- GrappleFlows needs Pro to read own footage: "I'll start the free trial" (he enters the card himself).

## What now works (evidence)
1. TAKEFIX1 collected (Lean e351fd2): six stepping / wide-miss punch takes play again (TAKE CLEAN 24, was 18; GLOVE HIGH 0;
   BeatClips.OFF_TAKES empty). Only the 9 real files applied (Goose's 127 import .uid leftovers left out); PR #15 closed.
2. Text walls trimmed (990f1e1, operator S341 ruling): Icons.gd (Lucide ISC line icons kept as SVG in code - sharp at any
   size, no import step, every icon carries a tooltip per J52). HER FILE = one icon row a tell, the answer behind a green
   check, a hidden tell behind a lock (how to find it on hover), found/total as pips; HER RECORD = W/L chips (bout on
   hover, our gym blue); WITH US one line - the card is about half the height. Real fight plans one line each (fights +
   idea on hover, a load icon, a target on the ones for her opponent); WHEN as small pills; plan rows one line (branch
   icon, move, path, untrained mark, remove x). Tests updated to the new UI with the same behaviour checked
   (strike_browser, plan_screen, tieup_plan); golden_path green. Stills before/after on /review and sent.
3. C161: MapLegend.gd - the move map's key (line colours, the loop, "n out m in", the three build steps) in the strip
   under the bottom cards; card tooltips "n moves start here, m end here".
4. Q-S294-67 (985c125): PlanFight.ANSWERS follows REALPLANS_S341 s3 - press +push_off ok; range 1-1 ok, 1-2 best; loadup
   step_in ok, tie_up best; counter 1-2-3b ok; two refined situations via PlanFight.refine (LiveRound): hurt_danger (a
   hurt opponent with a "when she is hurt" habit: straight punches + cut the ring, wide flurries wrong) and counter_late
   (the round's last exchange: the flurry is ok). plan_fight_test +7 checks. Consequence measured, not hidden: the
   starter plan's opening 1-2 is now the walk-down's jab, so t_walk (rebuilt in the real order: 1-2 at range, cut the
   ring once she tires, finish on the ropes) wins as many exchanges as the starter (0.549 = 0.549) but can no longer
   beat it; its gate is "matches" (the S341 t_walk at 0.535 fails it). Holyfield's template still reads below the starter
   (0.494 vs 0.508, reported, not gated).
5. C158 (dc0c51d): attributes as bars - StatBar.gd (0-100 scale, tweens in, a tick at her potential on fight values), band
   colours weak red / fair amber / solid blue / strong green / elite purple, an icon each, temper a Patient/Even/Trader
   scale; radar names only; AT A GLANCE under MIND (board ~100 px shorter). layout_snapshot: AttrRadar's static frac()
   no longer passes for a bar (7 script errors in every layout run since S340 gone).
6. GrappleFlows recognition test - ANSWERED NO (operator S341 "will the video (upload your own footage) decode some of our
   footage"): GrappleBrowser `film=1` (5402728) recorded our 6-move walk clean (docs/playtest/S342/our_grapple_chain.mp4,
   28 s); the operator started the Pro trial ($86/yr after 7 days - he cancels); uploaded at grappleflows.com > Video.
   Result (docs/playtest/S342/grappleflows_result.jpg): "We couldn't hear anyone teaching - this video has sound, but we
   couldn't pick out a voice explaining the technique." Its upload says "spoken audio required": GrappleFlows builds a
   flow from a coach's NARRATION (speech to text), not from the motion. A voice-over of our own would only echo our
   words back. Operator "try again": a retry with a GENERIC voice-over that never names a position (Windows speech,
   "watch where she starts... now she moves into the next position...") - if it named mount/guard it would have read the
   motion. Result (grappleflows_result_voiced.jpg): "This video doesn't teach a technique we can map. We build a chart
   from a coach explaining positions and steps out loud." Conclusive: GrappleFlows maps the words only, never the
   footage. Operator "the voice needs to describe the actions": the same walk (GrappleBrowser now prints `WALK from |
   move | lands`) with a coach's voice-over naming each step -> GrappleFlows built "Match Breakdown: Mount Sweep To Foot
   Over Foot Pass", 6 nodes in our order (Top Postures In Mount -> Bridge Sweep To Closed Guard -> Arm Lock Attempt ->
   Switch To Triangle -> Defender Stands Up -> Foot Over Foot Pass), each node a THUMBNAIL CUT FROM OUR FOOTAGE with a
   timestamp that jumps into the clip, each edge a short pill label ("opponent escapes the arm lock"); operator "tide it
   up" -> Arrange/auto-group = a clean top-down chain (docs/playtest/S342/grappleflows_flow_whole.jpg, _nodes.jpg,
   our_grapple_chain_narrated.mp4). Two node thumbnails came out blank and two share one frame (its own frame picking).
   TAKEAWAY for our flow view (decided): a node = a still of that position from our 3D + a short title + one line; an
   edge = a short pill; clicking a node plays that move (the MOVEPLAYER1 player) - draw it in Whimsical next session.

## Decided (and why)
- Whimsical: the connector added mid-session never reaches a running session (connector list fixed at start); next
  session draws the flow-view / plan wireframes through it. Its own AI agent spent the free 10 credits on one board and
  left 2 boxes; packs are 250/$25, 1,000/$100; the free plan caps 50 board objects a month. Operator: buy nothing yet.
- Flova.ai: an AI video generator (Seedance 2.5, OmniHuman, Nano Banana) with hosted "skills" and a CLI for agents. Not
  for building the game (its output is pictures and video; MetaHuman-only rule; duplicates Higgsfield/Ludo/Tripo/fal);
  maybe later for a Steam trailer. Its CLI install runs their setup script - only for a concrete trailer job.
- The move player (operator's idea) goes to an agent (S338 "agents on animations"): TASK_MOVEPLAYER1 -> Goose #16.

## Agent runs (in flight at the handover)
- FIGHTCARD1 (Cursor) round 4 running (wt LEAN_FIGHTCARD1; out FIGHTCARD1_r4_out.txt): r2 staged the card but the camera
  hid it; r3 (400d9aa) put the lens inside the ring, both faces read - still NOT merged: the near boxer fades see-through
  (lens < 1.5 m), the referee stands between / against the boxers at ropes and corner, one shoulder shot over the trapped
  boxer, only 2 samples a card. r4 brief measures all four (near_m, ref_gap, ref_off_line, ref_cover, over_trapped, >= 6
  samples).
- MOVEPLAYER1 (Goose #16, branch goose/moveplayer1): the 3D move player for the plan map (MOVEPLAYER OK 5/5 probe,
  ghost opponent alpha <= 0.45). Claude wires StrikeBrowser after the visual gate.
- CLINCH2 round 2 (Goose #14): branch still at r1 ed71b0b at the handover. PADWORK1 round 2 (Goose #13, 646db61) landed -
  visual gate next session. SMOOTH2 (Goose #10, 5433447) pushed - check its probe.

## Next
Collect with the visual gate (FIGHTCARD1 r4, PADWORK1 r2, CLINCH2 r2,
SMOOTH2, MOVEPLAYER1 + wire it into the plan map), Whimsical wireframe of the flow view (connector), scouting step 3
(scout trip) + OPPPLAN1.
