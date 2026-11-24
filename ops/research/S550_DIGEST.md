# S550 digest (2026-11-24, Fable) - boxer v boxer built twice, two critics, two probes ordered

## The owner's words, and what was done
- "check other sessions to report here" -> the S549 session had stopped past its limit; PLANIMPACT1 had landed (no
  lever passed) with Q-333 on the board; reported.
- Q-333 "Second probe" (the written plan) -> `TASK_PLANIMPACT2.md`, worker launched 15:48 (console tab PLANIMPACT2).
- Q-334 "Probe the changes" (coaches, Kalli 5 / 5) -> `TASK_COACHMAP2.md`, QUEUED behind PLANIMPACT2 (its change 1 is
  the same lever with another owner: one rule is not sold twice).
- "Give me the link for my phone" -> the version 2 page as one file, published private:
  https://claude.ai/artifact/RVECDqN7dwM9NLGVqQjQxq (`proto/boxcards/build_phone.py` -> `phone.html`).

## Built: boxer v boxer as its own engine (`proto/boxcards/`), twice
- VERSION 1 (`rules.mjs`, 12 tests, `DESIGN_BOXCARDS1.md`): a volley of up to three face up against ONE answer; rounds
  scored 10-point; knockdown and count; body work shortens the wind bar. 400 bot bouts: 5 of 6 bars (first lead 53.6%,
  a combination in 90%, 32 decisions both men, 83.5% to the judges v a 40-70 bar). The old game: 400 of 400 knockouts.
  Arena, code-checked: REAL 5, DEPTH 6, PLAY 6. Main fault: the answerer sees the whole volley.
- VERSION 2 (`rules2.mjs`, `bot2.mjs`, `probe2.mjs`, 21 tests, `DESIGN_BOXCARDS2.md`): the volley face down, turned
  one punch at a time; each punch asks "pay to stop it or take it"; slip-and-counter and a trade over the lead punch;
  cards never turned go back; a breather costs 2 points and gives a fresh hand. 400 bouts: 4 of 6 bars (80.0% to the
  judges, first lead 53.8%, a combination in 89.8%, a knockdown in 43%, 17 decisions a man); the reader beats the
  slugger 99%; no blind pilot over 50% (eight of mine, five of Arena's).
  Arena, a fresh chat: REAL 6, DEPTH 5, PLAY 7. Still under 8. Its four contract faults fixed with tests.
- The playable page: preview `boxcards` (port 8798; `index.html` = version 2, `v1.html` = version 1), and the phone link.
- Two corner's-minute versions measured and left OFF (version 1 engine): a healing corner makes bouts quieter (90% to
  the judges); a plan corner is inert (every plan against every plan 49-51%).

## METHOD finding
Both critic rounds put NO RANGE first. So: no third patch round; version 3 is a range track with its own scope,
`CARDRANGE_SCOPE_S550.md`, phase 0 = the owner's play of version 2.

## Collected
- PLANIMPACT1 (by the S549 session): no lever passed; lever 2 pays for HAVING a plan (best minus careless 2.3 / 0.9).
- The 05:00 tests of 11-24 (499 / 11): the same four red files as recorded; nothing new.

## Running at the handover
- PLANIMPACT2 (Opus, tab PLANIMPACT2, from 15:48, about 4 h) -> `docs/PLANIMPACT2_RESULT.md`.
- John SQ325 (boxing facts) sent, no answer. Dola SQ324 not sent (no debug port).
- NOT launched: COACHMAP2 (after PLANIMPACT2), MATCHBOTS2, BODYCROSS4 (the animation item: one worker while his game
  is open, and the plan probe had the slot all session).

## Lessons
- The one-bout trial found "nobody leads" on BOTH versions before any table. A defence that is free makes leading a
  loss; the fix each time was a boxing fact (a jab is not countered; a trade only over the lead; no clinch first).
- A trailing `//` comment appended to a one-line statement by a script swallowed the rest of the line, twice. Put the
  comment on its own line, and run the tests before the table.
- A heredoc with an apostrophe in the body breaks the whole command: files go through the Write tool.
- The preview pane has no viewport tag for a bare page: test a phone layout with the tag the publish step adds.
- `idle_guard.py ok` is only for a question to the owner; used to wait on a watcher it is refused, rightly.
- An Arena critic takes 14-25 minutes; give it "read ten bouts first" and "measure what you propose".
