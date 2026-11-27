# S571 digest (2026-11-27, Opus 5.5)

## Owner's words this session
- "how are the new rules going ? is better fun than previous ?" - answered: v4 cup means below.
- "is the hud affecting the rating ?" - no: cup bouts are played in text, no screen; the 7 is about rules.
- Mark C522 on the S570 strip: "WHY 2 CARDS DO YJE SAME THING ?"

## Done
- Strip v0.571.1: Stay put leaves the moment slots (it showed the same guard words and picture as the GUARD moment
  beside it); one green strap "FEET, ALL BEAT: STAY PUT" on the row under the strip (no height cost at 1080).
  page_play_test 4 passed. Review board: 2026-11-27_2235_strip_v0_571_1.
- OCTAGON (the owner's design, proto/octagon): v4 -> v4.6 through six cup rounds, every change measured on the bots
  (pool_sim n=40, 2240 bouts) before it went on. Means (fun / depth, 4 seats):
  | rules | fun | depth | note |
  | v3 (S570) | 7.0 | 7.25 | |
  | v4 r1 | 6.5 | 6.75 | stamina lock: both men at 0 for a round |
  | v4 r2 (stamina fix) | 6.5 | 6.5 | lock gone; jab too strong, rock->rock->KO, Long dead |
  | v4.2 r3 | 7.25 | 6.25 | best fun; speed decides, unseen speed numbers |
  | v4.3 r4 | 6.5 | 6.5 | Range Jab drill on a man standing still |
  | v4.4 r5 | 6.25 | 6.0 | 7 of 8 agent bouts were KOs inside 2 rounds |
  | v4.5 r6 | 7.0 | 7.0 | DEPTH AT TARGET; John v Maria went 3 rounds, 28-28 |
  Target FUN 8 / DEPTH 7 (owner: "keep playing until you reach"). v4.6 is ON, not yet played.
- Rules now on (fighters_v4.mjs useV4): swapRange/swapFree/spentRest (stamina), noReRock, pushMid, jabTrade 3 (a jab
  faster than a power punch trades; a man stepping in is halved), longJab (Range Jab at Long) + feelFlat (speed 8),
  elbows (Elbows Down, a body guard, in every deck), holdParry (Hold Ground parries a jab at Long), score107, ctrHalfPow
  (a counter adds half the power bonus), rockClinch (Clinch & Hold for a rocked man), buffOne (+1 speed boosts),
  hp 1.25, feelMeets (the Range Jab meets a step-in), baitCap (a baited counter costs at most 3). Bots: 44-55%,
  finishes 30% (agents finish far more than bots: 87% v 48% at the old health - the bot finish band is not the target).
- Rejected on the bots (pressure boxers 59-72%): tradeGap (close speeds trade), feelTie, styleSpeed (Pressure +1 at
  Close), stack=0 (step-ins do not stack), plain jabTrade 1.
- Bugs fixed: the hand's NOW speed and his bonus line left out the v4 hand-speed/reach bonuses (one attrSpd for rules
  and view; a tie line); v4 bouts were never told the v2/v3 rules; a stopped combo says why; the read's +2 lived in
  buffSpd; a jab out of range halved the punch it "traded" with; the push-back line contradicted itself.
- Workers: KICKFIX6 resumed (two balance chains, background bash in this session), RULES569 (console tab c1) and
  TYPES1 (console tab c2) launched. BUILD1 stays BLOCKED (S570 critics 6/6 and 4/4: a hurt part never took a card in
  any probe run - round 4 must make it happen).
- TASK_LAYERS1.md written (phase 1: every family with masks); board Q-S294-347 asks the owner to look at
  order.html?layers=1 first ("your look decides").

## Evidence
pool_sim lines in each commit message; cup logs + verdicts E:/FightCamp/tmp/octcup4/r1..r6_* (VERSUS_*.md). Cup
verdicts copied to ops/research/octagon/cup4/.

## Not done
- Cup round 7 on v4.6 (Claude v Maria: silk v snapshot; John v Kalli: truck v longnight) - fun is 1 short of 8.
- Open asks from r6 not built: one stamina line per man per exchange; every Defend shows its repeat cost; "body 1/20 -
  one more body shot ends it"; a both-zones guard for a man low on both bars (Kalli); counter v counter clinches (John);
  a running scoreboard (Maria).
