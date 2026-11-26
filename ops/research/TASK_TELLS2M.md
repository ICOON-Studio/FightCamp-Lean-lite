# TASK TELLS2M - the tells, version 2, measured on the instrument (S563, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (order.html rules). Seat: Arena on ICOON-Studio/FightCamp-Lean-lite.
Estimate: 2-3 hours.

## Why
Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is
?". Four playtesters (ops/research/allplay2/) picked ONE body tell before each beat, never his whole plan; version 2 is in
the words tool (`proto/twohands/tools/tells.mjs`, `tellOf(opp, plan, c, 2)`; DESIGN_TELLS2.md). Ziva: the tell was "worth
about 4 points a bout". Before it goes near the page, the balance tool must say how much a tell is worth to a player who
follows it blindly, and to one who knows each man's lie - Kalli's bars (RINGSWITCH_READ_BRIEF_KALLI.md, "To reach 10" 1).

## What to build (new files only: proto/twohands/tools/probe_tells.mjs + probe_tells_test.mjs)
Whole bouts, the page's opponents (opp 0, 1, 2) choosing with `ai()` as on the page, a bot in the player's corner:
- BOT 0 "no tell": the page's own mix for the player (as balance.mjs `who=mix`) - the control.
- BOT 1 "follows the tell blindly": as BOT 0, then its two HELD hands are set to cover the lines the cue names (rear
  shoulder -> lead high + rear high; knees -> lead low + rear low; back foot or quiet -> as BOT 0; front foot -> as BOT 0
  but no back off), keeping its punches. The cue comes from `tellOf(opp, hisPlan, c, 2)` with his plan chosen first (as
  `play_cli.mjs` does since S563: his beat is chosen before yours).
- BOT 2 "knows his lie": as BOT 1, but when that man's lie condition holds (`LIES[opp].test(c)` in tells.mjs) it ignores
  the cue and plays BOT 0's beat.
A fake costs him 1 stamina after the beat (as play_cli.mjs, tells=2). One-rep trial first: n=12 a pair; then n=84.

## Bars (report each, pass or fail with the number)
- BOT 1 against each man: wins at most 55% of decided bouts (a tell followed blindly must not win the fight by itself).
- BOT 2 against each man: wins 70% or more, OR at least 10 points more than BOT 1 (finding the lie must pay).
- BOT 0: about 50% against the mirror mix (the control; if it is far from 50% say so and why).
- Each man's fakes on 15-30% of beats in these bouts (tell_rates.mjs measured 29 / 27 / 13% with the AI in both corners).
- Stoppages 10-40% in every pair.

## Feedback loops
- Tell -> covered lines -> his punches land less -> he loses more -> nothing feeds back into how he lies (his AI does not
  know it is read). Cap: none in v2 by design; say whether that makes BOT 1 too strong. A fake costs him 1 stamina, so a
  man who lies a lot tires: report his average stamina at each bell.
- One-rep trial first (above); stop if BOT 1 wins over 85% of the trial.

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs, tells.mjs, play_cli.mjs or any test; delete no test; never commit
`*.vt.json`. Commit and push every result txt as it finishes (`ops/research/allplay2/tells2m_<bot>_<opp>.txt`). One pull
request at the end; never merge it.

## Contract
- OWNS: proto/twohands/tools/probe_tells.mjs, proto/twohands/tools/probe_tells_test.mjs,
  ops/research/allplay2/tells2m_b0_jabber.txt (and one txt per bot and man, same pattern), docs/TELLS2M_RESULT.md
- RED_TEST: proto/twohands/tools/probe_tells_test.mjs (red first: module not found; then: BOT 0 replays a balance.mjs
  mirror bout bout for bout on the same seed; BOT 1 holds lead low + rear low on a knees cue; BOT 2 plays BOT 0's beat when
  LIES[opp].test holds)
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed
- VISUAL: none

## Result
`docs/TELLS2M_RESULT.md`: one table - bot | against | wins of decided | knockdowns a bout | stoppages | his fakes per beat
| his stamina at the bells - then the bars, and three plain lines: is the tell worth showing on the page as it is, and
what to change if not. End with `TELLS2M DONE` or `TELLS2M BLOCKED: <why>`.

## Prior research
ops/research/DESIGN_TELLS2.md, ops/research/allplay2/ (the reports), ops/research/RINGSWITCH_READ_BRIEF_KALLI.md,
ops/research/RINGSWITCH_TELLS_BRIEF_JOHN.md, proto/twohands/tools/tell_rates.mjs (how the AI is put in both corners).

## What would a human do?
A designer gives a tester bot the same information a player gets and measures whether reading it wins too much or too
little, before drawing a single pose.

## Prefab check
Not applicable (our rules).
