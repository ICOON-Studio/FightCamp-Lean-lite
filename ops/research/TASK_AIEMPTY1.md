# TASK AIEMPTY1 - his empty beats: how often he picks a plan that cannot do anything, and the filter (S564, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches, order.html). Seat: Arena on
ICOON-Studio/FightCamp-Lean-lite. Estimate: 1-2 hours on 2 cores.

## Why
Two playtesters named it in ALLPLAY2 / ALLPLAY2B (ops/research/allplay2/): Antigravity - the AI queued "Back off -> Push
off" (Bout 1 R3B2, Bout 2 R1B6, Bout 3 R1B3 and R2B3), "Step in" while Inside, and a "naked Step in, Feint with no punch";
Arena (ALLPLAY2B fix 5): "Remove the AI's empty beats ... a back off or a push with nowhere to go teaches nothing and stalls
the beat". A real opponent never throws a beat that cannot do anything; it reads as a broken AI.
How he picks (order.html `ai()`, lines 297-312): a habit read (OPP.read), then with odds OPP.skill the solved mix
(`solveBeat`, B side), else a PLAIN beat of his style from `own` - which already drops a push off away from Inside and
punches that miss a man standing still, but not the empty kinds below.

## The empty kinds (a plan of his that can never do anything with that part)
- E1 a push off ordered AFTER his back off in the same plan (the back off takes him out of Inside first; push is Inside only).
- E2 a feint with no punch of his after it in the plan's order (the feint opens a line for a later punch; with none it is
  a stamina cost for nothing).
- E3 a step in at Inside with no ground given (ropes 0): the range cannot close and there is no ground to win back.
- E4 a back off at Long with no punch after it in the plan (no pull counter to use; he only gives ground).

## Do
1. COUNT (no rule change): play `balance.mjs play who=mix opp=<0|1|2> n=84 seed=1 jobs=2` with a counting copy of the bout
   loop under your own name (`proto/twohands/tools/probe_empty.mjs`, modelled on probe_punch_chance.mjs: same seeds, same
   bouts - check its bars equal balance.mjs's on the same seed). Report per man: his beats, E1-E4 per 100 beats, and which
   branch picked them (habit read / solved mix / plain beat).
2. FILTER: a tweak file `ops/research/s558_balance/ai_no_empty.json` (`src` patches on order.html, as the other tweaks)
   that drops E1-E4 from the PLAIN-beat list `own` (and from the habit read's answers if any came from there). Leave the
   solved mix alone (it is the rules' own answer; if most empty beats come from it, say so and stop - that is a rules
   question for the lead, not a filter).
3. MEASURE the filter: the same count (E1-E4 per 100 beats -> near 0 for the filtered branches) and his strength -
   `balance.mjs play who=mix opp=<0|1|2> n=84 seed=1 jobs=2 tweak=ai_no_empty.json` against today's: the player-bot's win
   share against each man within 5 points of today's (a filter must not make him stronger or weaker by itself).
   The mirror (opp=mirror) does not use ai(): the nine bars do not move - one seed to show it.

## Feedback loops
None that grows: the filter removes choices from his plain beats; nothing he does feeds back into the filter. One-rep
trial first: n=12 a man with the tweak - it loads and E1-E4 fall.

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs or any test; delete no test; never commit `*.vt.json`. Commit and push each
result txt as it finishes. One pull request at the end; never merge.

## Contract
- OWNS: proto/twohands/tools/probe_empty.mjs, ops/research/s558_balance/ai_no_empty.json,
  ops/research/s558_balance/results/aiempty_<count|filter>_<jabber|slugger|bodysnatcher>.txt, ops/research/s558_balance/results/aiempty_mirror.txt,
  docs/AIEMPTY1_RESULT.md
- RED_TEST: none (a probe; the count on today's page is the red)
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed
- VISUAL: none

## Result
`docs/AIEMPTY1_RESULT.md`: the count table (man x E1-E4 per 100 beats x branch), today v filtered; his strength today v
filtered; the mirror bars. One line: "put on the page: ai_no_empty.json" or "none: <why>". End with `AIEMPTY1 DONE` or
`AIEMPTY1 BLOCKED: <why>`.

## Prior research
ops/research/allplay2/antigravity/ALLPLAY2_ANTIGRAVITY.md (section 5, item 4), ops/research/allplay2/arena/ALLPLAY2B_ARENA.md
(fix 5), ops/research/s555_balance/opponents_on_the_page.txt (their skill), docs/RINGSWITCH_S558.md.

## What would a human do?
A designer watches the AI's choices for moves a human would never make, and removes only those, without making him a
better or worse fighter.

## Prefab check
Not applicable (our rules).
