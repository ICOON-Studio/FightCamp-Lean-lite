# TASK HEADPULL1 - the head-movement page with the pull counter: does it hold 9 of 9? (S560, one measure)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches).
Seat: Arena, its own clone of the code mirror. Estimate: 40-60 minutes, nearly all of it two balance runs.

## Why
`proto/twohands/head.html` (slip, roll, lean back, slip in on the feet switch) measured 8 of 9 bars
(`ops/research/s558_balance/results/head_base.txt`): its one red bar is "every punch lands 30-65%": the lead uppercut
landed 66%, on about 45 throws - one point over, inside the noise of 56 bouts. Since then the PULL COUNTER went onto the
boxing page (a back off arms that man's next punch in the beat, +1). The owner's next call is whether head movement goes
on the main page, so we need its numbers WITH the pull counter and on a bigger sample.

## Do
1. `ops/research/s558_balance/head_pull.json` is the tweak (page head.html + the pull counter). Check it loads:
   `node proto/twohands/tools/tweak_check.mjs ops/research/s558_balance/head_pull.json`.
2. Look the round ahead: `node proto/twohands/tools/balance.mjs table tweak=ops/research/s558_balance/head_pull.json
   out=tmp_head/head_pull.vt.json iters=300 jobs=<your cores>`.
3. Play it twice, 84 bouts each, two seeds if `play` takes a seed (read balance.mjs's header for its arguments; if it takes
   none, run it twice and say so): `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84
   tweak=ops/research/s558_balance/head_pull.json table=tmp_head/head_pull.vt.json`.
   Save each output as `ops/research/s558_balance/results/head_pull_1.txt` and `head_pull_2.txt`. COMMIT AND PUSH after
   each run.
4. `docs/HEADPULL1_RESULT.md`: the nine bars of both runs side by side with head_base; for each head move (slip, roll,
   lean back, slip in) its share of beats; the jab's and the lead uppercut's landing rate in each run; how often the pull
   counter's "+1" punch was thrown if the output shows it. Then one line: 9 of 9 in both runs, in one, or in neither -
   and, for a bar that fails in both, the size of the miss.

## Feedback loops
None new: this measures an existing rule set. (The pull counter feeds backing off, which gives ground; the ground rule
already caps it: two back offs and a man is on the ropes.)

## Not allowed
Change no page, no rule, no test and no tweak file. Do not commit the `*.vt.json` table. Node only. Open ONE pull request
at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/results/head_pull_1.txt, ops/research/s558_balance/results/head_pull_2.txt, docs/HEADPULL1_RESULT.md
- RED_TEST: head_base's bar "every punch lands 30-65%" (lead uppercut 66%)
- REGRESSION: head_test.mjs 11 passed, rules_test.mjs 37 passed (run both once; nothing is edited)
- VISUAL: none

## Prior research
docs/RINGSWITCH_S558.md (the bars and how they are read); ops/research/PULLCOUNTER_S559.md.

## What would a human do?
Re-run the measure on a bigger sample before touching a rule that misses its bar by one point.

## Prefab check
Not applicable.
