# TASK FEINTFIX2 - the feint that opens the overhand: three answers measured (S567)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Puncher's chance, order.html).
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite. Estimate: 4-6 hours.

## The owner's words
S567: "write the feint fix brief and measure it".

## Why (read these first, in this order)
- `docs/JABLAND2_RESULT.md` and the clinch cross-check in NEXT_SESSION_PROMPT.md ("CLINCHFIX3"): the loop "step in, FEINT,
  OVERHAND, then clinch" wins 38 / 63 / 70% against the three men (bar: under 30%); the three fixes measured so far (D: the
  feint opens the overhand only Inside; E: a punch that lands on you in your feint moment wastes it; F: both) all drove the
  feint AND the overhand to 1-2% of beats (floor 3%). The fix must cut the opening WITHOUT making the feint worthless.
- The league, S567 (`ops/research/versus/`): every seat found it. John and Kalli: "feint then cross ... nothing answers it
  except backing off". The Claude (Opus) player beat Dola with "step in, feint, overhand" three times out of three
  (`dola_v_claude/VERSUS_CLAUDE.md`), and explained the mechanism: the lead hand is STILL UP in moment 1 (it blocks his jab),
  feints in moment 2, and that block turns the overhand into a counter (+1): 4-5 health from Long, never punished.
- The film, `docs/SCENES1_RESULT.md`: Hearns v Duran is a low left then the right hand over the top half a second later.
  Feint-then-right-hand is real boxing and MUST stay possible.
- The seats' written ideas: `ops/research/FEINTFIX1_BRIEF_KALLI.md`, `ops/research/FEINTFIX1_BRIEF_DOLA.md`.

## The versions (each a tweak file on the rules above the page's `// ---- the page` mark; deterministic, no dice in a beat)
- G0: the page as it is (control), same seeds and counts.
- G1 - THE FEINTING HAND DOES NOT GUARD FIRST (the Claude player's finding): in a beat where your lead hand feints, that hand
  guards nothing in the moments BEFORE its feint (today it is "still up" until its own moment). Nothing else changes.
- G2 - A SLOW PUNCH FINDS THE HAND COMING BACK (Kalli): a punch of speed "slow" (the overhand, the rear uppercut) that lands
  only because the feint drew his hand does 2 less (never under 1). Fast and medium punches after a feint are unchanged.
- G3 - A MAN WHO THROWS NOTHING DOES NOT BITE (John and the Claude player): if the other man holds BOTH hands this beat
  (no punch, no feint, no push; feet free), the feint draws nothing.
- G12 = G1 + G2. G13 = G1 + G3. Run a combination only if neither of its halves passes alone.
- NOT a version, say why in the result: "a lead feint never pulls the rear hand" (Dola's second) removes the Hearns exchange;
  "a 50% chance the hand still blocks" (Dola's first) puts a die in a beat.

## What to measure, in this order (one run at a time; commit and push after each; n=12 trial before any table)
For each version: `balance.mjs play who=mix opp=mirror n=12 seed=1 tweak=<file>` on the page table; if nothing breaks, its own
table (`balance.mjs table tweak=<file> out=<v>.vt.json`), then `play n=84` on seeds 1 and 2 against the mirror. Then, on that
version's own table:
1. THE LOOP: `proto/twohands/tools/probe_clinch.mjs` as CLINCHFIX3 ran it (the bot that plays only step in, feint,
   overhand, then clinch) against the three men, n=60.
2. THE OPUS PLAY: the same bot WITHOUT the clinch, and the "feint then cross" bot, against the three men, n=60.
3. COUNTS (`proto/twohands/tools/probe_feint.mjs`): feint share of beats, overhand share, how often a punch after a feint
   lands, and the health it does.
4. THE FILM: `node proto/twohands/tools/scene_check.mjs feint_overhand` with the tweak applied (extend the tool with a
   `tweak=` argument if it has none): Hearns's feint and overhand must still LAND against a man holding his lead hand low
   and his rear hand high. (Under G2 it lands for 2 and may not drop him: report the health, the check is "lands".)

## The bars
- The page's nine bars on both seeds: at least as many as G0 on the same seed, never losing "mirror 40-60%".
- The loop under 30% against every man; the Opus play (no clinch) and feint-then-cross each under 35% against every man.
- The feint in at least 3% of beats and the overhand in at least 3% of beats, on both seeds (D, E and F failed here).
- A punch after a feint lands 45-75% of the time (today 83-94%).
- The Hearns beat still lands.
- Knockdowns a bout and stoppages within G0 + 0.3 and G0 +- 5 points (a weaker feint must not turn into longer, duller
  bouts: also report health dealt a round beside G0, under 90% of G0 = failed).

## Feedback loops
- A weaker feint -> chosen less -> the men hold their guards more -> every power punch lands less -> bouts go long: the
  health-a-round bar above is the cap; report beats with no punch landed beside G0.
- G1 makes the feinter open to a jab in moment 1 -> the jab is chosen more against a known feinter -> Long grows: report
  the jab's share of punches and Long's share of beats beside G0 (Long over 45% of beats = failed).
- G3 rewards doing nothing -> both men hold -> nothing happens: report the share of beats where a man holds both hands
  beside G0 (over G0 + 10 points = failed).
- One-rep trial first: n=12 before any table; stop a version whose trial has any switch over 40% of beats.

## Not allowed
No page edit, no `rules.mjs` / `balance.mjs` / `play_cli.mjs` edit (probe files may be extended; old calls keep their
output), no test deleted or loosened. ONE pull request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/feintfix2_g1.json, ops/research/s558_balance/feintfix2_g2.json,
  ops/research/s558_balance/feintfix2_g3.json, ops/research/s558_balance/feintfix2_g12.json,
  ops/research/s558_balance/feintfix2_g13.json, ops/research/s558_balance/results/feintfix2_*.txt,
  proto/twohands/tools/probe_feint.mjs, proto/twohands/tools/probe_clinch.mjs, proto/twohands/tools/scene_check.mjs,
  docs/FEINTFIX2_RESULT.md
- RED_TEST: G0: the loop 38 / 63 / 70%; a punch after a feint lands 83-94%
- REGRESSION: rules_test.mjs 37, page_play_test.mjs 4, scene_check.mjs (10 of 14 without a tweak)
- VISUAL: none

## Result
`docs/FEINTFIX2_RESULT.md`: one table (G0, G1, G2, G3 and any combination run, by seed: bars passed with each red bar's
number, the loop / the Opus play / feint-then-cross against each man, feint share, overhand share, landing after a feint,
health a round, knockdowns, stoppages, jab share, Long share, both-hands-held share, the Hearns beat), then three plain
lines: which version goes on the page, what the player would see, what is still wrong. End with `FEINTFIX2 DONE` or
`FEINTFIX2 BLOCKED: <why>`.

## Prior research
docs/JABLAND2_RESULT.md, docs/JABLAND1_RESULT.md, docs/SCENES1_RESULT.md, ops/research/FEINTFIX1_BRIEF_KALLI.md,
ops/research/FEINTFIX1_BRIEF_DOLA.md, ops/research/versus/*/VERSUS_*.md (the league's verdicts).

## What would a human do?
A boxer who feints with his lead hand has taken it off guard duty for that instant; and a man who does not react to a
feint is not opened by it.

## Prefab check
Not applicable (our rules).
