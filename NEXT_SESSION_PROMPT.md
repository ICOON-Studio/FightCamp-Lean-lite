# S425 handover: MECHANICS FIRST, agents carry the work (written 2026-11-10 at the end of S424)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S425` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring; the frame refuses to resize - harmless; after a redraw run `learn` / `trim` as the svg command prints).
Older handovers are in git (this file's history); S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## What S424 did
- His board answers: Q-176 dues "Yes, but change something ... ok for the mechanism but the design needs better presentation";
  Q-175 cutman "need to improve the depth of the mechanic, rated 4/10 does worth investing time i think" (read: keep it,
  deepen it, no build).
- DUESBAND1 (Membership intake chance per band + tests/dues_bands_sim_test.gd: no band wins all 9 cases, control = flat
  0.35 must show premium everywhere) -> Goose issue #165. After it lands Claude wires HomeJuniors.chance(band) and
  "takes effect next month" (GymSpend.set_dues) - small, by hand.
- Dues presentation: Ludo `image edit` repaint in the Overview look (docs/mockups/s416/overview_painted_ludo.png as reference):
  slate price boards in wooden frames, members painted on each. Pick docs/mockups/s424/dues_painted_v4.png (every number
  right); build note: people ABOVE the numbers (try 1's layout). Board Q-177.
- R28 v3 for depth -> Kalli SQ32 (ops/research/K_R28_CUTMAN_V3_BRIEF.md: before / in the round / the scorecards / the
  minute's 60 s / after). When it lands: two critics (CRITIC_PACK, 10/10 lists + drawings), then the board.
- R37: the PRO ask already exists (ProLadder -> Matchmaking.ask, refusals with reasons). The amateur ask is the work ->
  John SQ33 (ops/research/J_AMATEUR_ASK_S424_BRIEF.md: how a club really gets a bout, refusal reasons, lead times).
- FIGHTSLIDE3 collected (2dce6130): no single slide cause.
- LEGTREMBLE3's head_aim red is a VOID: `_reset` reads the hips gap 3 frames after the guard (0.972 vs gap_m 0.916, tol
  0.05). LEGTREMBLE4 queued on Qwen (measure the settle main vs branch; wait for it or re-bake the hips).
- KDFIX3 NOT merged (branch qwen/kdfix3 3f227d73 pushed): knockdown sway 1.91 -> 0.76 cm, bar 0.68; its "fall clip settles"
  claim contradicts its own 0.18 floor; block_meet red on the branch but green on main's nightly. KDFIX4 queued on Qwen.
- FIGHTDISPLAY1 (Cursor): the process hung on "Connection lost" AFTER building; with his OK ("Yes, stop and relaunch")
  Claude stopped the tree by PID and the runner landed it: PR #167 (+1041 -18: CornerBar, NowPlate, ScoreBug, ShoutBar,
  FightHud, FightView, tests/corner_bar_test.gd). 7 of 7 regressions pass; its own corner_bar_test fails 1. No relaunch.
- Nothing in the game changed this session (a probe tool, docs, briefs): no export.

## Order for S425
1. Board: Q-177 (dues look). On yes: brief the DUES card for Cursor from dues_painted_v4.png.
2. FIGHTDISPLAY1 = PR #167: find corner_bar_test's one failure, fix, render the live round on the hidden desktop and LOOK
   (his drawing docs/mockups/s422/fight_10_simvet.html is the bar), collect by diff; then FIGHTDISPLAY2 launches.
3. Collect: DUESBAND1 (Goose #165: read the 9-case table yourself), then wire HomeJuniors; LEGTREMBLE4, KDFIX4 (Qwen); close
   PR 162 when a KDFIX lands; films after each animation merge (LOOK at them).
4. Kalli SQ32 -> critics -> board. John SQ33 -> R37 amateur ask map -> critics -> board. Then R55, R58 maps.

## Traps
- `agent_comms.py ask --attach` resolves paths from ops/: pass absolute paths.
- `seat_queue.py add --brief` takes the path from ops/ (research/<file>.md).
- A REGRESSION test that lives only on the BASE branch fails brief_contract: keep it in the RESULT lines instead.
- A seat calling a red test "pre-existing": check the nightly (ops/AgentComms/nightly/latest.txt) before believing it.

SETTINGS: S424 ran on Opus 5.5. Weekly plan use was ~88% at S423's end (resets 11-12): propose Sonnet, high effort, Fast off, until the reset.
