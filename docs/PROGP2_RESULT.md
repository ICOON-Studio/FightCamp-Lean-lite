# PROGP2_RESULT - the Sharp choice measured: "cheaper" or "faster", for each punch (S563, probe P2 of DESIGN_PROGRESSION1)

The question (DESIGN_PROGRESSION1 3b, 5.3, 6): at Sharp (mastery 60) the player picks ONE upgrade for a move, for that
fighter, for good - "cheaper" (1 stamina less, min 1) or "faster" (one speed step: slow -> medium -> fast). Before any
screen or critic the balance tool must say whether the choice is a real one: an upgrade that is useless is a dead card,
one that is always right is a clog. Today the page (`order.html`) gives both men ONE shared punch table (`ACT`: a punch's
stamina and its speed). This probe gave each man his OWN copy of the table and played the solved mix against itself.

**How it was run.** `proto/twohands/tools/probe_sharp.mjs` loads the page's rules through `rules.mjs` with a patch (a text
replacement at load time - `order.html` is NOT edited), copying PROGP3's per-man method: seven named replacements give
`man(hp, o)` a `tb` field (the man's own copy of `ACT`), and every place the rules read a punch's stamina or speed FOR A
MAN reads HIS table - the cost of a plan (`cost(p, m)`, and its call sites in `plansFor`, `resolve` and `ai`) and who
lands first in a moment (the speed sort and its same-speed group in `resolve`), each falling back to `ACT`. The patch
throws if any replaced text is not on the page. Whole bouts: the solved mix against itself (balance.mjs
`play who=mix opp=mirror` style: both men draw from the beat's `solveBeat`), `iters=400`, `n=84`, `jobs=2`, `seed=1`
(workers at seeds 100 and 101). Equal tables replay balance.mjs's mirror bouts bout for bout with the same seed - held by
`probe_sharp_test.mjs`. The one-rep trial came first: the Cross both ways at n=24 won 59% / 52% of decided, neither over
the 75% stop line, so the runs went on. **The look-ahead table `vtable.json` was built for equal men and is used as it is
- an approximation for unequal men: it reads both men's punches at today's numbers.** A win share at n=84 has about a
10-point confidence interval: differences under ~10 points read as noise, but the bars below are the bars. "Which the mix
threw more" = the upgrade under which A threw the punch in more beats (A's share of beats, against B's, in that run).

## The table

| punch | cheaper: A wins | faster: A wins | gap | which the mix threw more (A v B, share of beats) | stoppages (cheaper / faster) |
|---|---|---|---|---|---|
| jab | no upgrade possible - needs its own pair | no upgrade possible - needs its own pair | - | - | - |
| bjab | no upgrade possible - needs its own pair | no upgrade possible - needs its own pair | - | - | - |
| hook | **43%** (36 of 83) - dead | no faster (already fast) | - | cheaper: A 15% v B 7% | 27% |
| lup | **59%** (47 of 79) - over | **53%** (42 of 79) - in | 6 | cheaper: A 14% v B 6% | 17% / 14% |
| lbody | **54%** (44 of 81) - in | **46%** (37 of 81) - dead | 8 | cheaper: A 15% v B 4% | 27% / 25% |
| cross | **62%** (50 of 81) - over | **63%** (50 of 80) - over | 1 | cheaper: A 39% v B 24% | 32% / 24% |
| over | **57%** (46 of 81) - in | **55%** (42 of 77) - in | 2 | cheaper: A 13% v B 4% | 21% / 32% |
| rup | **59%** (47 of 80) - over | **52%** (42 of 81) - at the floor | 7 | cheaper: A 14% v B 6% | 24% / 26% |
| rbody | **67%** (54 of 81) - over | **58%** (49 of 84) - at the top | 9 | cheaper: A 44% v B 24% | 24% / 29% |

Every raw run is `ops/research/s558_balance/results/sharp_<punch>_<cheaper|faster>.txt` (the trials are
`sharp_cross_cheaper_onerep.txt` / `sharp_cross_faster_onerep.txt`, n=24). **Stoppages are inside the 10-40% bar in every
pair** (14% to 32%); no pair flagged.

## The pair that works

- **Overhand: cheaper 57% / faster 55%, gap 2.** The one clean pair: both cards inside the 52-58% bar and within 6
  points of each other, so neither is always the pick and neither is never the pick. The cheaper overhand is thrown 3.3x
  more (13% of beats v 4%), the faster one 2.7x more (8% v 3%) - each card bends use its own way and neither runs away
  with the fight. This is the shape the design wants; the Overhand is where the Sharp choice can ship as specced.
- **Lead uppercut: cheaper 59% / faster 53%, gap 6 - the borderline second.** The choice is real (gap exactly 6, inside
  the tolerance) but the cheaper card sits one point over the bar, and it is the card the mix throws more (14% v 6%,
  2.3x). One point of noise from the bar; treat as "works with a nudge", not as clean.

## The dead or clogging ones

- **Jab, Body jab - no upgrade possible.** Both already cost 1 stamina (the floor) and are already fast, so "cheaper" and
  "faster" do nothing. Not run, by the spec: they need their own pair (the design already says some moves get one).
- **Lead hook - the cheaper card is a dead card (43%).** The cheap hook is thrown 2.2x more (15% of beats v 7%) and
  still loses: the hook's problem on this board is not what it costs but what it does when it lands. There is no faster
  card to pair it with (it is already fast), so the pair as specced cannot be a choice.
- **Body hook - a clog (gap 8).** Cheaper 54% (in) against faster 46% (dead): the player always takes cheaper, and the
  faster card is never the pick. Note the faster body hook does not even raise use (A 3% of beats v B 4%).
- **Cross - both cards too strong (62% / 63%), though the choice itself is real (gap 1).** Neither card is at the bar;
  the Cross's numbers are simply too good for a one-level upgrade, and the cheaper card throws it 1.6x more (39% v 24%
  of beats), bending the whole fight toward it.
- **Rear uppercut - a clog plus an over-strong card (gap 7).** Cheaper 59% (over the bar) against faster 52% (at the
  floor): the cheaper card is always the pick and is itself too strong.
- **Body cross - the worst clog (gap 9).** Cheaper 67% (way over) against faster 58% (at the top edge): the cheap body
  cross is thrown 1.8x more (44% of beats v 24%) and wins two bouts in three. The faster card is never the pick.

## A different pair to try for each of those (one line each, not measured)

- jab: its own pair - "+1 keep (the S554 rule at Sharp)" v "reaches one further (Long)"; the jab has no cheaper or faster to give.
- bjab: its own pair - "+1 damage" v "reaches one further (Long)".
- hook: "+1 damage (3 -> 4)" v "reaches Long" - cheaper is dead at 43%; give the hook effect, not a lower price.
- lbody: "cheaper" v "+1 damage" - the faster card is dead; a second effect card makes the pair a pick again.
- cross: "cheaper" v "reaches Long" (or "+1 damage" given up for the reach) - both cards are over the bar at the Cross's numbers, so the pair needs a smaller effect, not a bigger one.
- rup: "faster" v "reaches Mid" - cheaper is over the bar and clog-causing; the rear uppercut reaches Inside only today.
- rbody: "faster" v "+1 damage" - cheaper at 67% (44% of beats) bends the whole fight; the pair needs a smaller lever.

## The feedback loops

- **Upgrade -> more use of that punch -> more wins.** Every CHEAPER upgrade raised the punch's share of beats (1.6x to
  3.7x), and for the rear-hand power punches (Cross, Body cross, Overhand, both uppercuts) the wins followed - the
  exception is the lead hook, thrown 2.2x more and still losing (43%). The two FAST BODY punches raised use not at all
  (Body hook faster 3% v B 4%; Body cross faster 24% v B 25%): speed on a body punch does not make the mix throw it more,
  which is exactly why those faster cards are dead. A punch thrown 2x as often is the sign the upgrade bends the whole
  fight - true for the cheap Cross (39% v 24%) and cheap Body cross (44% v 24%), which are also the two over-strong
  cards.
- **Cheaper -> more stamina -> more punches each beat.** The cheap men threw two-punch plans more often (cheap Body cross
  27% of beats v B's 15%; cheap Cross 21% v 18%; cheap Hook 21% v 16%), capped by the stamina bar (8) and the cost floor
  (min 1 - which is why the jab and body jab have no cheaper card at all).
- **One-rep trial first.** The Cross both ways at n=24 (59% / 52%) - neither over the 75% stop line, so the n=84 runs
  went on.
- **The look-ahead table** `vtable.json` was built for equal men and is used as it is: it reads both men's punches at
  today's numbers, an approximation for unequal men (as PROGP3 reported of its own unequal-men use).

## Files and tests

- OWNS: `proto/twohands/tools/probe_sharp.mjs`, `proto/twohands/tools/probe_sharp_test.mjs`,
  `ops/research/s558_balance/results/sharp_*.txt` (thirteen n=84 runs plus the two n=24 trials), `docs/PROGP2_RESULT.md`
  (this file).
- `RESULT: proto/twohands/tools/probe_sharp_test.mjs -> PROBE_SHARP_TEST 5 passed` (red first: module not found; then
  equal tables replay a balance.mjs mirror bout for bout with the same seed; a man whose Cross costs 1 pays 1 in
  `cost()`; a man whose Cross is fast lands it before a medium punch in the same moment; the patch throws on a missing
  text; `setOf` builds the table and refuses the dead upgrades).
- REGRESSION: `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed, `probe_attributes_test.mjs` 5 passed (nothing
  they read was edited; the page, the existing tools and the existing tests are untouched - only new files were added).
- Not committed: no `*.vt.json` anywhere; no images, no Godot - node only.

PROGP2 DONE
