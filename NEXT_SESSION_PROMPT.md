# S426 handover: collect the animation branches, the week design v3, the measurements (written 2026-11-10, end of S425)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S426` and redraw the map (a PARTIAL svg is enough: the frame, the changed cards; then `trim` / `learn` as the svg command prints).
Digest of S425: ops/research/S425_DIGEST.md. Older handovers are in git.

## His rulings in S425 (verbatim)
- "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for a critics +7/10" (CLAUDE.md).
- "maybe review combine old ideas to rise their depth to +7 and maybe come with new things ? can other free agents work on
  that , the focus needs to be for the player to have things to do during a week make him anticipate the changes and be
  more interactive with deicions/choices and rewarding for keep playing and progressing".
- On screens: he first asked for no sentences, then "maybe i have overdone with the sentences , i let you judge", then
  "i do not want impose rules on your designs, remove it and do it as think it is better". NO rule: Claude's judgement.
- Scope: asked "After the week is built, widen the scope to a small living world with a belt ladder?" -> "Yes, after the
  week" (CLAUDE.md item 4). He bought Boxing Manager (Steam): ops/research/BOXING_MANAGER_COMPARE_S425.md.

## State of the work
- ON MAIN: the Dues tab (Club > Money > Dues, three painted boards, looked at: docs/mockups/s425/dues_tab_real.png; the
  three fees do not sit on one line: small polish). ReadBack.gd (two switched-off rules, measured and rejected).
  Probes: tools/pads_for_two_probe.gd, tools/read_back_probe.gd. EXPORTED 16:17 with the Dues tab (Builds/FightCamp.exe, WHAT_TO_TRY current): no need to run `sh tools/export.sh`
  and update WHAT_TO_TRY (Club > Money > Dues) unless S425's last message says it was done.
- WEEK DESIGN: v2 (ops/research/WEEK_DESIGN_V2_S425.md, docs/mockups/s425/week_v2.png, week_v2_thursday.png) scored depth
  5 from two fresh critics (week_v2_critic_*.md). Measured since: the full plan-reading game is OUT (READBACK1-3 in
  docs/READBACK1_RESULT.md: best answer +3.7 of 7 points; a line waited for from round 1 costs 15). v3 must reach 7 on:
  lines that fire as they are drilled, the Thursday choice, the coach's evenings, rewards that open choices, and the
  corner minute (Claude's mockup docs/mockups/s425/corner_v1.png from his reference; on the review board, no reaction yet).
  Wait for FIRELEVEL1 and THURSDAY1 before writing v3. Ideas to take from Boxing Manager into "ask for a fight": risk
  label on offers, refusal reasons, win chance from repeated sims, skip to next event.
- MEASUREMENTS RUNNING (Qwen): FIRELEVEL1 (qwen/firelevel1), then THURSDAY1.
- CURSOR: FIGHTDISPLAY2 running (cursor/fightdisplay2); then TRAININGB1.
- ANIMFIX1 (the Fable subagent) FINISHED. Its full report is in the S425 transcript; the short of it:
  * Boxing legs, branch qwen/legtremble4 (5b84d0fe, PR 168): the head_aim VOID was the test's own reset (fixed in the
    test); the footwork rig dropped the hips 8 cm under every punch (fixed: BoxerFootworkRig.gd, RingFeet.gd,
    FootPlant.gd; new tests/legs_level_test.gd, tools/round2_film.gd, tools/knee_zigzag.py). THE LEGS STILL TREMBLE: the
    wobble sits at clip changes (1.1 to 1.5 a second per boxer). The 149 rewritten clips change nothing measurable
    (collecting them is optional). block_meet_test is red on the branch and flaky on main. Films on the review board
    (its rating 5/10). Next real step: fewer and longer clips, or one owner for the legs all round.
  * Grappling, branch claude/grapplefix1 (18326652): fixed "Move up" shown for moves down, positions paid twice, the
    score landing 2 s before the bodies, calls three in 13 s; BjjMatch.gd, BeltMatch.gd, MatHud.gd, BjjClash.gd.
    STILL WRONG: 19 to 23 unnamed position changes a bout (BeltMatch._drift), bodies through each other, the "Mount" pose
    is not a mount (data), only 1 or 2 calls in five minutes now (Claude decides the cadence: aim for one about every
    30 to 40 s when the position changes), call cards cover the pair. Films on the review board (its rating 4/10).
  * Cursor's KDFIX4 (cursor/kdfix4, PR 169): NOT green. knockdown_still_test red 3 runs of 3 (sway 2.30 cm against 0.5),
    block_meet red. Cursor's "all green" was false. Do not merge; brief KDFIX5 with those exact lines.
- CHAT SEATS queued or answered: Kalli SQ35 (cutman v3 pasted), SQ36 (her week page), SQ38 (small world); John SQ31
  ANSWERED (J_DUES_CHOICE_S421_BRIEF_JOHN.md, unread), SQ33, SQ34, SQ37 (the real belt ladder).
- Q-S294-178 is answered by his chat messages (combine the ideas): close it on the board.

## Order for S426
1. Collect qwen/legtremble4 and claude/grapplefix1 by diff: read each diff, run the touched tests, LOOK at the four films
   on the review board yourself, merge what is green and visibly better; leave the 149 clips out unless a film shows a
   gain. Then one new animation brief per track (legs: fewer and longer clips; grappling: drift, bodies, cadence) and
   KDFIX5.
2. FIRELEVEL1 and THURSDAY1 results -> week design v3 (a designer subagent, then two FRESH critics, 7+ -> his board).
3. Export, WHAT_TO_TRY, his playing.
4. Chat seat answers: cutman v3 -> critics; dues sums (claude/duesband1); R37 map; the small world.

## Traps
- A seat's "all green" is a claim: KDFIX4 and DUESCARD1 both passed their tests and failed on the real screen or on a rerun.
- A python heredoc with triple quotes breaks in this shell: write the script to the scratchpad and run it.
- `git diff --stat` across branches: add `2>/dev/null`. A bare Godot start is blocked: use ops/Tools/godot_slot.py.
- The dispatcher holds tests while a windowed render runs and the PC is not GREEN: run `seat_dispatch.py --act` again later.
- Subagents die with the session: do not clear a session while one runs.
- Two critics at the same low depth twice = change the mechanic; and measure before building (READBACK saved a build).

SETTINGS: S425 ran on Fable 5.2 and ended past 600k of context. Weekly plan use was 89% of all models before the session's subagents (resets 11-12): propose Sonnet 5.5, high effort, Fast off, until the reset.

## Landed after the handover text
- FIRELEVEL1 (Qwen, qwen/firelevel1 6748de49, PR 175, NOT collected): control 41.3 exact. With the rule on, the plan's one
  combination at usable / sharp / signature wins 38.0 / 39.8 / 42.5% (shares 0.6 / 0.8 / 1.0) and 37.0 / 39.8 / 42.5%
  (0.5 / 0.75 / 1.0): drilling one combination from usable to signature is worth 4.5 to 5.5 wins in 100 (today: 1). An
  only-just-learned plan is 3.3 to 4.3 worse than today's game (a cost for new players). Only the combination can vary
  in that plan (steps always fire): a plan with two or three combinations is unmeasured. Collect by diff (it touches
  LiveRound.gd: check the line count and that no key = the game as before), then decide the shares for v3.
- THURSDAY1 launched on Qwen after it (or queued: run `python ops/Tools/seat_dispatch.py --act`).
