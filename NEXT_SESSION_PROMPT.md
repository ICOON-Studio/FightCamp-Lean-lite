# S444 handover (written 2026-11-12 ~19:30 during S443; S442's handover is in git history at 08f5d813)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S444`
and redraw Miro.

## USAGE RULES (S442 burn, kept in S443: S443 used 5% -> ~8% of the week)
`get_usage` first; hand over at 300k context; at most TWO helpers at once; tell him the cost before a batch; one session
coordinates and pushes, the others report to it by SendMessage (S443 did this: worked well). Each helper ~300k tokens.

## HIS WORDS IN S443 (verbatim)
- Board: Q-195 "Stamina", Q-196 "Show me it in the game first", Q-197 "Yes, build it", Q-198 "check markup" (the bars in
  "In and out": "these bars look stupid do not fit here"), Q-199 "Yes, summary + tabs", Q-200 "All three", Q-201 "Yes, ease
  it as proposed", Q-202 "Delete both", Q-203 "Measure it now", Q-204 "Only above or level (recommended)".
- Corner card marks C320-C323 (coach line "random preset lines with no base on the fight ?"; "do not make the text about one
  fighter , write instead : when pressed"; "remove the good at it etc , shot the costs of energy instead"; Recover "doesnt
  seemlike an option ... real time changes should be shown with graphics"). C324/C325 blocks: "doesnt even look like a normal
  human", "nothing seem to be blocked red fighter misses , blue fighter just holds guard". C326 announcer swell "not bad for
  first try". C327 bubbles "remove the wooden panel , make it transparent ?". C319 headline "looks ok".
- Cooling idea: "ice bags on the back of the neck ... overdoing it leads to muscle stiffness ... can this be turned into a
  mechanism ... gives more things for player to do during corner and the feeling of time pressing ... and also a warning on
  the corner time": answered (corner minute in SECONDS, neck ice dose, rub the shoulders, seconds out at 0:10); "yes add it to
  the measurement" -> PUSHPROBE2 arm E.
- "check other sessions and coordinate them to report here"; "pc is not red" (it was AMBER: read the watchdog, not the queue);
  "check board"; "anything else can progress ?" (two session cards; he started both).

## DONE IN S443 (all pushed to main)
- Money page on one screen, no bars, not-built rows gone (42f3ee02); hover labels on small chrome, HoverLabel.gd.
- Stamina everywhere + one overall number, StatBlock.gd (524f8c56). NOT done: week review still lists Power/Technique; a
  Stamina session's gain still averages Stamina+Recovery; World's scouted Stamina still the old average; camp Stamina card
  text runs past its edge (old).
- No-sparring eased to 0.8 a point (61d58ec5). Fight bubbles see-through (da238dd2). E: 16 GB deleted (77 GB free).
- Corner card, his four marks (f9ac2cfa, bd97214c): coach line from Exchanges.read of the round; "When pressed"; EnergyPips;
  RecoverCards with the +energy ghost; card 766 px. The 0-of-0 was loop_shots' placeholder. Stills on the review board.
- Ask for a fight: S442's season probe (870c98f6, 33,739 bouts, spread ok); picks only from above (2f7515e2, Q-204).
- Qwen PR 238 Judges + PR 239 WorldNews collected after a blind review with fixes (50e1c92d, aaa73bc0, c4053f4c).

## IN FLIGHT AT WRITING (check each: `git log`, the review board, the session list)
- PUSHPROBE2 (S443 helper, dies with S443 if it is closed first): arms A-E at 3 and 6 rounds, 300 bouts a cell, ends ~20:40,
  result docs/PUSHPROBE2_RESULT.md, tools/pushprobe2*.gd. Then: show him the table; v3 design only from the numbers.
- Session "Result page: summary + tabs" (local_b9e2a770): Q-199 build.
- Session "Blind review + collect Qwen PRs 238 and 239" (local_4e39ebee): now wiring Judges to the fight night and
  WorldNews to the ladder.
- S439 lead (POWER1, worktree LEAN_POWER1, branch claude/power1): step 4 committed 17:39, blind read pending, never reported
  back (estimated 18:15). Collect against his C314/C315 ("no power behind the shot"); steps 2-3 fixes were never re-read.

## NEXT, IN ORDER
1. Collect what landed above; push.
2. PUSHPROBE2 table to him (cooling: keep or drop by the numbers).
3. Q-196: the fight-screen regroup shown in the game as stills (not shipped) - docs/mockups/s442/ux/ux_c_fight_hud.*.
4. Ask for a fight: the screen (map ASKFIGHT_MAP_S441.md, prices from the probe).
5. BLOCKLOOK1 with C324/C325; POWER1 collect.
6. Wire TraitLine, PlanPhase, LineGrade, Towel; fire level on with a re-measure. Brief Qwen (idle).

## TRAPS (S443)
- A still taken during a fade shows the 3D through a card: wait for alpha 1 (fight3d_play.gd now checks).
- godot_slot shows only who starts; the watchdog's verdict is the truth for RED/AMBER.
- A test that pins a sample bout's band breaks when a scale is eased on purpose: test agreement, not the band.
