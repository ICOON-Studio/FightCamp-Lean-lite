---
name: project-fight-stage-state-2026-09-09
description: "Where the real-time fight stands after R84 - what is wired, what is measured, and the five findings queued for R86/R85"
metadata: 
  node_type: memory
  type: project
  originSessionId: 547a59a5-a62e-4f36-b301-7660c40b8175
  modified: 2026-09-09T15:09:12.368Z
---

State as of 2026-09-09 evening. The repo records the detail; this is the
orientation a fresh session needs so it does not re-derive it.

**The real-time fight can now be fought AND won.** R84 (`deb625a`) put scoring,
stoppage and result on `FightRealtime.gd`: rounds fold through U22's
`RealtimeRoundStats` into R38's `JudgePanel`, four stoppage rules fire (KO,
three-knockdown TKO, doctor, decision), `result()` returns a verdict. Suite was
`total=202 fails=0` at `ffa5445`.

**Measured behaviour of our own engine, so nobody re-measures it:** 812 impacts
per 3x5 bout, 5.43 shocks/fight, 0.68 knockdowns/fight, 23% of bouts stopped,
`head_neck` ending 49.7-75.3, stamina ending 57.7-65.7. Target shares after the
R84 ruling: head 60.1%, torso 28.1%, legs 11.8%, arms 0.

**The strike-target question is RULED and must not be reopened as an
oversight:** 0.60 head / 0.28 torso / 0.06 each leg, arms deliberately 0.00
because an arm is never a target (U20 separates `guard_region`). Legs were a
bug; arms are correct.

## The five findings queued, none of them fixed

1. **A 12-round fight is stopped 100% of the time.** That is the WEAR rate
   (`ImpactModel.WEAR_SCALE`, C63/R83F), not the stoppage rules. Blocks any
   championship-distance bout. R86 part B.
2. **A split or majority decision is arithmetically IMPOSSIBLE — and this is
   now a BLOCKER, not a curiosity.** No grappling means damage is the only
   non-zero weight, and J1 3.2 forbids judge bias touching damage, so three
   judges cannot disagree. Undisputed's scorecard screen (seen first-hand)
   shows three NAMED judges whose cards differed by a round while agreeing on
   the winner - which is the entire point of showing a scorecard. Rendered on
   our engine that screen would be three identical rows and three identical
   totals, advertising the defect. **Do not build the scorecard screen until
   judges can disagree.**
3. **The doctor's `head_neck <= 15` cannot fire in a 3x5** (heads end 49.7+).
   Deliberately NOT tuned down; proven reachable over 12 rounds instead.
4. **No shipped boxing/MMA sim degrades ACCURACY with fatigue** (U23, Cursor).
   Fight Night, EA UFC 3/5 and Undisputed spend the tired man by rate, power
   and vulnerability. G31's `technique_multiplier` is our own invention; its
   `defense` and `output` terms are the supported steals. R86 must not treat
   the technique term as validated.
5. **A hit does not occupy the next tick.** `shocked`/`knockdown` are event
   vocabulary, not states - a man cracked at tick N is fully able at N+1, which
   is why 812 impacts happen. The steal is commitment ticks on the attacker and
   hurt ticks on the victim, lengthened in the CORNER where `pressure` already
   exists and currently affects nothing.

## The two-task split keeps paying

Grok writes a pure module from a stated contract; Qwen writes its test from the
SAME contract without seeing the module. Three for three: G29, G30T (found
`MAX_REST_FRACTION`), G31T (found `output_multiplier(1.0)` returning
0.44999999999999996, fractionally BELOW its own floor - the fault was Claude's
contract promising both "exactly the FLOOR" and "never below FLOOR" from a
formula that cannot keep both). **Keep writing the contract, not the code, and
keep the test author blind.**

## Undisputed is the design reference and has been driven first-hand

`research/R85R_UNDISPUTED_HUD.md` holds it. Headline: **cardio is shown
as a HEART RATE, not a stamina bar**, and the between-rounds corner splits
damage into continuous bars (Head, Body) plus **discrete 4-pip rows for cuts
and swelling, left/right**. Attrition is continuous; trauma is discrete. Their
six damage slots are head, body and four facial trauma slots - a better carve-up
for boxing than our head/torso/2 arms/2 legs.

**The scorecard is a pure rendering job otherwise.** `JudgePanel.score_round`
already emits exactly the shape Undisputed draws - per judge, per round, a
10-9 card - and `state["scorecards"]` stores `{round, cards, consensus}`.
Nothing displays it.

Related: [[project-agent-host-capabilities]],
[[feedback-check-research-record-first]].
