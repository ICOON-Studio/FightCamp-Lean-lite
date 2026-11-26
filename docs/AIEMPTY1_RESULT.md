# AIEMPTY1 - his empty beats: the count and the filter (S564, probe, Arena seat)

Brief: `ops/research/TASK_AIEMPTY1.md`. Node only, 2 cores, one run at a time, all runs `who=mix n=84 seed=1 jobs=2`
(worker seeds 100 and 101), on main `8425298` with no page, rules, balance.mjs or test edit.

**Result: none - the filter does what it says (his plain beats go to 0 empty beats) but it makes two of the three men
stronger by itself: the player-bot's win share falls 71 -> 63% against the Slugger and 75 -> 52% against the Body
Snatcher (bar: within 5 points). And 53% of his empty beats come from the solved mix, which the filter does not touch.**

## Tools and checks
- `proto/twohands/tools/probe_empty.mjs` - a line-for-line copy of balance.mjs's bout loop (same seeds, same bouts, same
  report) plus the count. The branch of `ai()` that picked each of his plans is read by three src patches that only set a
  field on the plan `ai()` returns (habit `read` / solved `mix` / `plain` beat; `plainAll` = the plain fallback when `own`
  is empty). No number and no random draw changes.
- **Identity with balance.mjs** (every report line equal, the run-time line aside): today, opp=0 n=2; with the tweak,
  opp=1 n=12 (`balance.mjs play who=mix opp=1 n=12 seed=1 jobs=2 tweak=ai_no_empty.json` = the probe's trial). So each
  `aiempty_*` file's report IS the balance.mjs report on that seed and tweak.
- The empty kinds are read on the state the plan was chosen in: E1 push off ordered after his back off; E2 feint with no
  punch of his after it; E3 step in at Inside with ropes 0; E4 back off at Long with no punch after it.
- `ops/research/s558_balance/ai_no_empty.json` - one src patch: `const all = plansFor(S, 1)` in the plain-beat branch of
  `ai()` becomes `plansFor(S, 1).filter(not E1-E4)`, so `own` and its fallback are both clean (the hold-still plan is
  never empty, so the list is never empty). The solved mix and the habit read are left alone (the read gave 10 empty beats
  in 4389 - 0.2 per 100 - and it answers a plan of yours it expects, e.g. a step in at Inside against your habitual
  back off is a cut-off, not empty).
- One-rep trial (n=12 a man, with the tweak): loads; plain-beat E1-E4 = 0 against all three men.
- Regression: `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed.

## 1. The count: his empty beats per 100 of his beats, by the branch that picked them (today v filtered)
Each branch row is per 100 of ALL his beats, so the branch rows add up to the "all" row ("any" = a plan with at least one
empty kind; a plan can be two kinds).

| man | branch (his beats today / filtered) | E1 today / filt | E2 today / filt | E3 today / filt | E4 today / filt | any today / filt |
|---|---|---|---|---|---|---|
| The Jabber | **all** (1451 / 1441) | 1.2 / 0.1 | 4.3 / 0.0 | 1.4 / 0.3 | 11.2 / 7.6 | **16.7 / 8.0** |
| | habit read (99 / 68) | 0.0 / 0.0 | 0.0 / 0.0 | 0.0 / 0.0 | 0.1 / 0.3 | 0.1 / 0.3 |
| | solved mix (730 / 734) | 0.7 / 0.1 | 0.0 / 0.0 | 0.6 / 0.3 | 7.0 / 7.3 | 8.2 / 7.8 |
| | plain beat (622 / 639) | 0.5 / 0.0 | 4.3 / 0.0 | 0.9 / 0.0 | 4.2 / 0.0 | 8.4 / **0.0** |
| The Slugger | **all** (1476 / 1495) | 0.3 / 0.1 | 4.7 / 0.0 | 20.5 / 7.6 | 3.0 / 2.9 | **26.8 / 10.6** |
| | habit read (43 / 39) | 0.0 / 0.0 | 0.0 / 0.0 | 0.2 / 0.1 | 0.0 / 0.0 | 0.2 / 0.1 |
| | solved mix (833 / 867) | 0.1 / 0.1 | 0.0 / 0.0 | 9.6 / 7.5 | 3.0 / 2.9 | 12.7 / 10.6 |
| | plain beat (600 / 576 + 13 fallback) | 0.1 / 0.0 | 4.7 / 0.0 | 10.8 / 0.0 | 0.0 / 0.0 | 14.0 / **0.0** |
| The Body Snatcher | **all** (1462 / 1492) | 0.9 / 0.5 | 2.5 / 0.1 | 15.0 / 10.5 | 2.8 / 3.2 | **20.5 / 14.3** |
| | habit read (65 / 66) | 0.0 / 0.0 | 0.0 / 0.0 | 0.4 / 0.1 | 0.0 / 0.0 | 0.4 / 0.1 |
| | solved mix (1107 / 1103) | 0.6 / 0.5 | 0.1 / 0.1 | 9.8 / 10.4 | 2.8 / 3.2 | 13.3 / 14.1 |
| | plain beat (290 / 315 + 8 fallback) | 0.3 / 0.0 | 2.3 / 0.0 | 4.8 / 0.0 | 0.0 / 0.0 | 6.7 / **0.0** |

Where his empty beats come from today (beats with any empty kind): the Jabber 49% solved mix / 50% plain / 0% read; the
Slugger 47 / 52 / 1; the Body Snatcher **65** / 33 / 2; **all three men 53% solved mix / 45% plain / 1% read**.
Of his plain beats, 20% (Jabber), 34% (Slugger) and 34% (Body Snatcher) were empty - the beats a player reads him on.
By range: every E1 and E3 is at Inside, every E4 at Long, E2 at all three. The player-bot (the solved mix) plays them too:
12.5-13.0 per 100 (mostly E4 and E3).

The brief's stop clause ("if most empty beats come from the solved mix, say so and stop") is met overall (53%) and for
the Body Snatcher (65%), not for the Jabber or the Slugger (just under half). The filter was measured anyway, as the plain
half is a filter question; the mix half is reported as a rules question below.

## 2. His strength today v filtered (the player-bot's results, `who=mix`, n=84, seed=1)
| man | player-bot wins today -> filtered | change | stops him | is stopped | health taken a bout (you v him) | within 5 points? |
|---|---|---|---|---|---|---|
| The Jabber | 76% -> 77% | +1 | 35% -> 42% | 4% -> 5% | 24.4 v 18.4 -> 25.0 v 18.0 | yes |
| The Slugger | 71% -> 63% | **-8** | 25% -> 11% | 1% -> 4% | 27.2 v 17.3 -> 25.8 v 19.3 | **no** |
| The Body Snatcher | 75% -> 52% | **-23** | 32% -> 7% | 4% -> 6% | 24.9 v 20.0 -> 22.5 v 19.6 | **no** |

Why: the plain beats must hold one of his liked switches. The Slugger and the Body Snatcher like `in`, so at Inside a third
of their plain beats were "step in" at Inside (E3: 1 stamina for a step that cannot close the range). With step in filtered out,
the only liked switches left at Inside are their punches, so those beats become punches (his beats with no punch: Slugger
26% -> 20%, Body Snatcher 20% -> 18%) and the player-bot stops him far less. The empty beats were a hidden handicap that
the S555 skill numbers (0.58 / 0.78) were set with. Noise: n=84 puts about 7 points of noise on a difference of win
shares; the Body Snatcher's -23 is about 3 times that, the Slugger's -8 about 1 times (but outside the bar as measured).

## 3. The mirror (opp=mirror does not call ai())
`balance.mjs play who=mix opp=mirror n=84 seed=1 jobs=2`, today and with the tweak: every line identical, **BARS 7 of 9
pass** both times (FAIL: Push off 3% dead; Jab lands 70%, Overhand 74%). The nine bars do not move.
(`results/aiempty_mirror.txt`)

## For the lead
- The plain-beat half is filterable, but not on its own: the filter has to come with the Slugger's and the Body Snatcher's
  skill set again on the instrument (the S555 way: `balance.mjs play who=sensible` / `who=mix`), or as a softer variant
  that swaps the empty part for "hold" rather than drop the plan. Either way, more than this brief allows.
- The solved-mix half is a rules question: the mix uses a back off at Long with no punch (E4, 3-7 per 100) and a step
  in at Inside (E3, up to 10 per 100) because, against a man who may step (cut off his back off, undo his step in), those
  are worth something. They are "empty" only against a man who stands still, so the playtesters still see them.

## Files
- `proto/twohands/tools/probe_empty.mjs`
- `ops/research/s558_balance/ai_no_empty.json`
- `ops/research/s558_balance/results/aiempty_count_{jabber,slugger,bodysnatcher}.txt` (today)
- `ops/research/s558_balance/results/aiempty_filter_{jabber,slugger,bodysnatcher}.txt` (with the tweak)
- `ops/research/s558_balance/results/aiempty_mirror.txt`

none: ai_no_empty.json takes his plain-beat empty beats to 0 but makes the Slugger (-8) and the Body Snatcher (-23)
stronger against the player-bot, past the 5-point bar, and 53% of his empty beats come from the solved mix (a rules
question for the lead).

AIEMPTY1 DONE
