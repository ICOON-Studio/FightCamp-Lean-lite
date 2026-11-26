# TASK PUNCHCHANCE2 - Puncher's chance, version C with the knockdowns back under the bar (S561, measures only)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches).
Seat: Arena, its own clone of the code mirror. Estimate: 1.5 to 2 hours on 2 cores, nearly all of it probe runs.

## Why
`docs/PUNCHCHANCE1_RESULT.md` (read it whole first): version C (the switch opens to the man 4+ health behind, once a
round) lifts the comeback from 10% to 18% (bar 15-30%), is used in 3% of beats and 30-33% of open beats. Its one cost:
2.6 knockdowns a bout against a bar of 2.5 (the page has 2.4), so it shows 7 of 9 bars instead of 8. The owner wants the
switch on a page copy to play; it goes there only when it holds 8 of 9 and the comeback stays inside 15-30%.

## Do
1. Three tweak files beside `ops/research/s558_balance/punch_chance_c.json` (copy C, change only what is named):
   - `punch_chance_e.json`: the trigger at 5+ health behind (`N.pcGap` 5).
   - `punch_chance_f.json`: C, but a man dropped by an all-in punch gets up on his knockdown health and that knockdown does
     NOT count toward the three-knockdown stoppage (it still scores its 3 points). The bout loop of
     `proto/twohands/tools/probe_punch_chance.mjs` counts knockdowns: give it this one rule behind a number in the tweak's
     `N` (for example `N.pcFree: 1`), off by default so every other tweak measures as before.
   - `punch_chance_g.json`: F with the trigger at 5+.
2. Each version: `node proto/twohands/tools/probe_punch_chance.mjs tweak=<file> n=84 jobs=<your cores>` and again with
   `seed=2`. Save the outputs as `ops/research/s558_balance/punch_chance_out/e84.txt`, `e84_s2.txt`, `f84.txt`,
   `f84_s2.txt`, `g84.txt`, `g84_s2.txt`. COMMIT AND PUSH after each run (the tweak file with its first result).
3. If none holds 8 of 9 with the comeback pooled over both seeds inside 15-30%, try ONE more idea of your own on a new
   letter and say why you chose it; otherwise stop.
4. `docs/PUNCHCHANCE2_RESULT.md`: PUNCHCHANCE1's table with the new rows (bars, comeback per seed and pooled, used when
   open, share of beats, the loop, lands, stoppages / knockdowns), then one line naming the version to put on the page,
   or "none: <the nearest and its miss>". End with `PUNCHCHANCE2 DONE` or `PUNCHCHANCE2 BLOCKED: <why>`.

## Feedback loops
- The switch feeds knockdowns; a knockdown widens the health gap; the gap opens the other man's switch. Cap already in
  the rule: once a round, and never in the round an all-in punch dropped him ("the loop" bar: open for both men in one
  round at most 1 round in 5). Print that bar for every version.
- F removes the all-in knockdown from the stoppage count: that could make an all-in punch free to eat. Check the "used
  when open" bar (at most 1 open beat in 3) does not fall as well as not rise: report both sides.
- One-rep trial first: each new tweak at `n=12` before its 84-bout runs, to see it loads and the switch is used at all.

## Not allowed
Change no page (order.html, kick.html, head.html, body.html) and delete no test. Node only. Open ONE pull request at the
end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/punch_chance_e.json, ops/research/s558_balance/punch_chance_f.json, ops/research/s558_balance/punch_chance_g.json, ops/research/s558_balance/punch_chance_out/e84.txt, ops/research/s558_balance/punch_chance_out/e84_s2.txt, ops/research/s558_balance/punch_chance_out/f84.txt, ops/research/s558_balance/punch_chance_out/f84_s2.txt, ops/research/s558_balance/punch_chance_out/g84.txt, ops/research/s558_balance/punch_chance_out/g84_s2.txt, proto/twohands/tools/probe_punch_chance.mjs, proto/twohands/tools/punch_chance_test.mjs, docs/PUNCHCHANCE2_RESULT.md
- RED_TEST: C's bar "bouts end both ways" (knockdowns 2.6 a bout, bar 2.5) in c84.txt and c84_s2.txt
- REGRESSION: punch_chance_test.mjs 13 passed (plus one new test for the free knockdown), rules_test.mjs 37 passed
- VISUAL: none

## Prior research
docs/PUNCHCHANCE1_RESULT.md; docs/RINGSWITCH_S558.md (the bars and how they are read); ops/research/TASK_PUNCHCHANCE1.md.

## What would a human do?
Keep the version that works and move the one number that broke, one change at a time, on two seeds.

## Prefab check
Not applicable.
