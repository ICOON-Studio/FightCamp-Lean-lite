# TASK PUNCHCHANCE1 - "Puncher's chance": a comeback switch on the board (S559, design + measure)

Kind: probe. Model: claude-opus-5-5. Discipline: boxing (Ring Switches, then kickboxing).
Seat: the next session (or a console worker). Estimate: 2-3 hours, ~1 hour of balance runs.

## Why
Owner S559: "can you add a jumpswitch on the board for the card game . We will name it "Puncher's chance" for now ,what do
you think ?". Claude's answer (S559): yes - boxing's comeback: the man behind can always land the one that turns the fight -
but as a switch with a price, never a lottery. Related: his S559 idea of critical shots (a liver shot, a chin that breaks
once conditions are met) - this is the first of that family.

## The rule to measure (a tweak on order.html first, then a page copy like kick.html / head.html)
- OPEN only to the man BEHIND: his health under the other's, or behind on the cards in the last round (PROPOSAL, measure
  both triggers); ONCE a round. Shown to both men ("his puncher's chance is loaded").
- THE SWITCH sits on the board beside the clinch: when on, the next power punch he throws this beat (3 health or more:
  hook, cross, overhand, uppercuts) goes all in: DOUBLE damage, and if it lands he goes down whatever his health (a
  knockdown).
- THE PRICE: +2 stamina; if that punch misses or is blocked, he is wide open: the other man's punches for the rest of the
  beat are counters (+1) and land through his guard.
- The look-ahead (solveBeat) must see it: it is a plan option (plansFor) like the clinch.

## S560 state of the page (read first)
- The PULL COUNTER is on order.html since S560 (owner: "Yes, put it on"): a back off arms that man's next punch in the beat,
  +1. Measured before it went on: 8 of 9 bars, the jab lands 68%. The page's own table (`proto/twohands/vtable.json`) was
  rebuilt for it. rules_test is 37.
- You change NO page: tweak files only (`src` pairs are exact text of order.html, no trailing newline). Your tables go to
  your own out folder (`balance.mjs table tweak=<f> out=<dir>/<name>.vt.json`), never to the page's vtable.json.
- Another worker (HEADPICS1) renders pictures and edits head.html's page part; do not touch its files.
- Commit ONLY your paths by pathspec (`git commit -- <files>`), `git diff --cached --stat` first; appended comments `/* */`.
- Result file: `docs/PUNCHCHANCE1_RESULT.md`, ending with `PUNCHCHANCE1 DONE` or `PUNCHCHANCE1 BLOCKED: <why>`.

## Bars (balance.mjs + a new comeback count)
- The 9 bars hold (8 of 9 today on order.html).
- The comeback bar: in bouts where a man is behind by 4+ health after round 1, he wins 15-30% (measure today's number
  first: without the switch) - a real chance, not a coin flip.
- Not a must: used in at most 1 beat in 3 when open; and never in more than 10% of all beats.
- Stoppages stay 10-40%; knockdowns 0.5-2.5 a bout.

## Feedback loops
- Behind -> the switch -> a knockdown -> 3 points and the other man behind -> HIS switch opens: a loop. Cap: once a round
  per man, and the knocked-down man's switch does NOT open in the same round he was dropped by it. One-rep trial first:
  60 bouts, count how often the switch opens for both men in one round; stop and re-design if over 1 in 5 rounds.
- Health trigger x the limp (kick.html) x body shots that shorten stamina: none feed back into the trigger except health.

## Do
1. Count today's comeback number (no switch) with a small probe on balance.mjs play output (who led after round 1, who won).
2. The tweak file `ops/research/s558_balance/punch_chance_a.json` (the health trigger) and `_b` (the cards trigger); rule tests
   in a new `proto/twohands/tools/punch_chance_test.mjs`; `balance.mjs table` + `play n=84` for each.
3. Report the bars, the comeback number before / after, usage, and the loop count.

## Contract
- OWNS: ops/research/s558_balance/punch_chance_*.json, proto/twohands/tools/punch_chance_test.mjs, a result file
- RED_TEST: the comeback count without the switch (the number to move)
- REGRESSION: rules_test 37, page_play_test 4
- VISUAL: none until it passes; then a page copy + his play

## Prior research
docs/RINGSWITCH_S558.md (the bars), ops/research/DESIGN_PROGRESSION1.md (the Signature-move idea), the S559 critical-shots
answer; `python ops/Tools/prior_research.py comeback knockdown puncher one punch`.

## What would a human do?
A designer prices the comeback so it is a choice with a risk both players can see, then counts comebacks before and after.

## Prefab check
Not applicable (our rule).
