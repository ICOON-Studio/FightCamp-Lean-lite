# S427 handover: block_meet red on main, KDFIX5, week design v3 (written 2026-11-10, end of S426)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S427` and redraw the Miro map (partial svg is enough).
Digests: ops/research/S425_DIGEST.md (S426 has none: its facts are here and in roadmap.json `now`).

## His words in S426 (verbatim)
- On the corner-bar still (marks, ops/Feedback/2026-11-10-12..15): "what is this ?" (the empty box beside the clock); "the number on the
  head implies that the his is in the head no need for text"; "what do you mean wrong, are you saying to the player do not choose this ?
  is this how games work ?"; "what are these symbols ??" (bolt + arrows). Q-S294-178 (pads for two): "how much is this designed rated ?".
- "also the hud hides players feet"; "this background effects looks weird when there is motion in the front" (a crop: a hair edge ghosted
  three times); "add this picture on the board so i can mark areas" (done: 8787/review, post 2026-11-10_1714).

## Done in S426 (committed ec7d7940, de5183d8; exported 17:21; WHAT_TO_TRY current)
- CornerBar.gd: LAST CALL box titled ("Said nothing" when no call); grade chip Risky (was Wrong; tooltip says it plays into her and can
  still be picked); cost in words (Rests well / Rests / Even / Tires / Tires a lot). RoundHits.gd: a number badge on the spot, no words.
- Feet: TvShot.BAR_DROP_M 0.3 (the lens looks lower; FOOT_M stays -0.2): two real stills show both boots above the bar.
- Blur: RingCamera motion blur samples 3 -> 8, object multiplier 0.7. A STILL CANNOT SHOW IT: he judges it in motion.
- claude/grapplefix1 collected by diff (bjj match/clash/mat/beat/finish tests green). Still wrong: drift (19-23 unnamed position changes),
  bodies through each other, the Mount pose, call cadence (aim one per 30-40 s when the position changes), call cards cover the pair.
- KDFIX5 launched on Qwen (qwen/kdfix5, brief ops/research/TASK_KDFIX5.md, from cursor/kdfix4).

## Open, in this order
1. block_meet_test (S426, FIXED): the red was a fluke (rhythm step/fidget mid-read; the test now holds the stage still) plus one real row (A_B
   right cross 3.7 cm inside the block): FightStage CROSS_STANDOFF_M 0.015 in the block target; failures=0 in 3 runs of 3, head_aim, beat_clips,
   move_tip, guard_weave, fight_flow green. BLOCKMEET3 (Qwen) superseded. The legs code (qwen/legtremble4, no clips, no leg_tremble_test) moved
   block_meet to a different row (A_A left hook touch 0.050) when tried before this fix: retry it now; LOOK at its four films first.
2. Collect KDFIX5 by diff (rerun knockdown_still_test and block_meet_test 3 times each; a green claim is not a pass).
3. Briefs: legs (fewer, longer clips; the hip drop fix in BoxerFootworkRig is good), grappling (drift, bodies, cadence). PRs 162/163/166/168/169 are stale:
   close them once their useful parts are on main or in a brief.
4. FIRELEVEL1 (PR 175, rule + one line in LiveRound) HAS A BUG (S426, read PlanFight.can_do): today a combo is doable when its PUNCHES are
   learned (Combos.LEARN_AT 30 on moves), not when the combo itself is drilled. FireLevel.mastery_of reads f["combos"][id] (0 if undrilled),
   so with NO key an undrilled but doable combo gets share 0.0 and stops being planned: 'no key = today's game' is false. Fix at collect:
   share() returns 1.0 when level_shares is empty, and a test for it; its 41.3 control only held because Lucy's combos were drilled. THURSDAY1 (PR 176): the 40 camps collapse to two identical results: rerun with real different seeds.
   Then week design v3 (WEEK_DESIGN_V2_S425.md) -> two FRESH critics 7+ -> his board.
5. Chat seats: SQ31-SQ36 answers unread (dues choice, cutman v3, amateur ask, cheap club money, her week page); SQ37 real belt ladder, SQ38 small world.
6. His marks on the new corner still (review board), then the Dues tab polish.

## Traps
- A seat's "all green" is a claim (KDFIX4, DUESCARD1). A test that is red on main is not "pre-existing" until you ran main.
- RingCamera.gd is exactly 500 lines: any addition needs a cut elsewhere (file_limits_test).
- `git apply -R` of a patch then re-apply is the safe way to compare main with a branch in this checkout (no stash).
- fight3d_play.gd on the hidden desktop: ~1.5 min normally; it once timed out at 420 s while other jobs ran: rerun.
- Subagents die with the session. Dispatcher holds seat launches while a windowed render runs and the PC is not GREEN.

SETTINGS: S426 ran on Sonnet 5.5; weekly plan use was high (resets 11-12). Next session: Sonnet 5.5, high effort, Fast off.
