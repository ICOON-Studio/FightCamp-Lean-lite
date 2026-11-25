# Ring Switches in S556: the two changes both seats asked for, and the body jab on the page (2026-11-25)

Everything here is two equal men who both play each beat's best mix, 84 bouts, on `proto/twohands/tools/balance.mjs`.
The southpaw has its own page: `docs/RINGSWITCH_SOUTHPAW_S556.md`. The body jab's take: `docs/BODYJAB1_RESULT.md`.

## NOT GREEN (read this first)
- **He has not played any of it.** His play is the gate.
- **The men do not play FOR the ground rule.** The look-ahead does not know that an even round goes to the man who
  backed off less, so the solved mix backs off as before. Against a human who does play for it the opponents will be a
  little too generous with ground. Teaching the look-ahead the rule is the next step if he likes it.
- The nine bars are mine, as in S555. 84 bouts is +-10 points on a share of bouts.
- **The jab still lands too often** (72 to 79%; my bar is 65%) and now the body jab does too (66 to 69%). Both are 1-health
  punches; the bar they fail is the same one the S555 page failed.
- **The body jab's blocked and missed pictures show the glove at chest height** (docs/BODYJAB1_RESULT.md).
- The health change was measured on the page's table before it went on the page, then the table was rebuilt.

## The two changes
| What | The page before | An even round to the man who gave less ground | Moving costs breath | Both |
|---|---|---|---|---|
| Bars passed | 8 of 9 | 8 of 9 | **7 of 9** | 7 of 9 |
| Draws | 12% | **6%** | 8% | 5% |
| Bouts stopped / knockdowns a bout | 20% / 2.3 | 20% / 2.3 | 21% / 2.5 (over the bar) | 21% / 2.5 |
| Beats at Inside / Mid / Long | 32 / 35 / 33% | the same | 25 / 37 / 39% | 25 / 37 / 39% |
| Feet stay / step in / back off (share of beats) | 27 / 31 / 36% | the same | **47** / 25 / 24% | 47 / 25 / 24% |
| No punch in a beat / two punches | 13% / 16% | the same | 19% / 19% | 19% / 19% |
| The jab / the cross / the overhand land | 72 / 46 / 77% | the same | 77 / 63 / 83% | 77 / 63 / 83% |
| The body cross falls short | 33% | the same | 43% (over the bar) | 43% |

- **An even round to the man who gave less ground** (`ops/research/s556_balance/ground.json`). One round in eight
  (12%) ends level on points; 61% of those are then decided by who backed off less. Draws halve and nothing else moves,
  because only the scoring changed. It costs one line of rule. **This one is worth having.**
- **Moving costs breath** (`breath.json`: a held hand gives its +1 stamina only on a beat the feet stayed). It does
  what it says and that is the problem: the men stop moving (feet stay in 47% of beats, was 27%), Inside is fought
  less, standing men hit each other more often (the cross lands 63%, was 46%), the body cross falls short more. One bar
  fewer. **Not worth having as it is**: the S555 rules already price a back off with ground.
  The owner, the same day: "Maybe breath can be used to put a limit on movements if that becomes an issue". So it is
  KEPT IN RESERVE as the limiter on movement (`ops/research/s556_balance/breath.json` still fits the page): it comes
  back, measured again, only if moving turns into a problem (a player who runs, a round of nothing but steps).

## What went on the page
`proto/twohands/order.html`, by three small patches kept in `ops/research/s556_balance/` (`apply_bjab.py`,
`apply_ground.py`, `apply_hp18.py`):
1. **The body jab** (lead hand, 1 stamina, 1 health, fast, reaches Mid and Long, the body line: a lead hand held LOW
   blocks it). A light punch: it does not shorten his stamina bar. Its own pictures (`docs/BODYJAB1_RESULT.md`). The
   opponents throw it too.
2. **An even round goes to the man who gave less ground.** The bell line says so when it decides a round; the score
   line says on hover how often each man has backed off this round.
3. **Health 18** (was 17), the opponents 16 / 21 / 18 (were 15 / 20 / 17). Why: see the table.

| What | S555 page | + body jab and the ground rule (health 17, 168 bouts) | + health 18 (168 bouts) | The bar |
|---|---|---|---|---|
| Bars passed | 8 of 9 | 7 of 9 (both sets) | **8 of 9 (both sets)** | |
| Jab / body jab, share of beats | 22% / - | 13% / 12% | 13% / 12% | |
| Lead hand held low / high | 27% / 12% | 32% / 9% | 32% / 9% | |
| The cross / the body hook, share of beats | 18% / 8% | 23% / 4% | 22% / 4% | each 3% or more |
| The jab lands / the body jab lands | 72% / - | 79% / 66% | 73% / 69% | 30 to 65% (the failing bar, as before) |
| Bouts stopped | 20% | **27%** | 16% | 10 to 40% |
| Knockdowns a bout | 2.3 | **2.7** | 2.25 | 0.5 to 2.5 |
| Draws | 12% | 6.5% | 7.5% | at most 20% |
| Beats at Inside / Mid / Long | 32 / 35 / 33% | 32 / 35 / 33% | 32 / 35 / 33% | each 15 to 55% |

What the body jab does: Long now has a guess. The jab hand is split evenly between head and body, and the lead hand
is held low more (it stops the body jab, the body hook and the body cross), which lets the cross through more often.
It also adds landed punches at Long, so with health 17 the fight was a little too bloody on my bar; one point of
health brings it back. The body hook is now the least used punch (4% of beats, bar 3%): watch it.

The player who answers the man's last beat (84 bouts each, health 18): wins 54 / 51 / 40% against the Jabber, the
Slugger and the Body Snatcher (S555: 44 / 56 / 42%). Bouts ending in a stoppage either way: 44 / 46 / 67% (S555: 39 /
40 / 64%). 

The page as committed, its own table rebuilt (identical to the one before: the look-ahead does not count health),
84 bouts: 8 of 9 bars, stoppages 14%, draws 5%, knockdowns 2.1, Inside / Mid / Long 31 / 34 / 35%. `rules_test.mjs`:
34 tests pass (two new: the body jab's cover, the back-off count). One beat played in the browser against the Jabber:
both men threw a body jab, both landed, no error.

## How to run it again
```
node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84 tweak=ops/research/s556_balance/ground.json table=proto/twohands/vtable.json     (2 minutes: the look-ahead is the page's)
node proto/twohands/tools/balance.mjs table tweak=ops/research/s556_balance/breath.json out=<f>.vt.json iters=300 jobs=7                              (4 minutes)
node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84 tweak=ops/research/s556_balance/breath.json table=<f>.vt.json
```
`balance.mjs` now scores a round level on points by ground when the page's `N.even` is set (a tweak sets it), and prints
how many rounds were level and how many of those the ground decided.
