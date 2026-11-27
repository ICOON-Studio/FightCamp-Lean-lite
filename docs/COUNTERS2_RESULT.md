# COUNTERS2 - the check hook, round two: a read, not a sure thing (S569)

Owner S569, on the two counters: "Second round" (the check hook only; the timed counter stays parked). I measured this on today's
page (v0.568.12, with the feint fix). order.html was not touched: every rule lives in a tweak's `src` patches. Console worker, main checkout.

## Verdict
**No version passes every bar. None goes on the page, and there is no toy page** (the brief builds check.html only for a version that passes).
All three versions fail the same bar: **when he cuts you off, the hook lands 90-100%** (bar: 45-80%). H3b is the closest: it keeps
today's 8 of 9 on both seeds, but it lands 95-100% when he cuts you off and gives +6 against the Body Snatcher (cap +5).

**For the owner (what the player would feel):**
- Back off and throw the lead hook while he walks in: it still lands almost every time it happens, so it feels like a sure thing, not a read.
- Holding your lead hand high on the way in does block it, but the man who walks into it nearly always has that hand busy, so the answer is almost never there when it counts.
- The fight itself barely changes (stepping in ~31%, Long ~32%, today's bars kept with H3b), so the check hook is a rare bonus, not a new way to box.

## The control: today's page
The FEINTFIX2 G1 runs (and the page commit's g1page_s1/s2) are not reusable. balance.mjs splits the bouts across workers with
seed*100+worker, so a run's dice depend on jobs=. I re-ran today's page under my measurement loader, with COUNTERS1's command at
jobs=1, and its seed 1 report differs from g1page_s1. Every control below is that run (results/counters2_today_*.txt), and every
version uses the same split (n=84, jobs=1). Today's feint loop (35/53/37) is the same as the page commit's figure.

## The versions (tweaks in ops/research/s558_balance/)
- **H3** (counters2_h3.json) = COUNTERS1's H2 plus the answer. In the moment of the hook, if the man who cut you off has his lead hand
  guarding high (held high, or thrown in another moment, and not a feint still to come), there is no check hook: it is a normal lead
  hook, with normal cover and no +1. It catches only a man whose lead hand is out, a feint still to come, or held low.
- **H3b** (counters2_h3b.json) = H3 without the +1. The check hook does its base damage. Run because H3's n=12 trial failed a bar
  (it landed 4 of 4 when he cut you off).
- **H4** (counters2_h4.json, my own) = H3b, but the angle beats his rear hand only when his LEAD hand is out throwing in that same moment
  (he rushes in swinging, square). Otherwise it is a normal lead hook. Why: it aims at the bar that killed H3 and H3b (lands when cut off).
  It narrows the rule to the film's own picture: Hatton swinging his left hook as he comes in.

## scene_check (results/counters2_scenes.txt, counters2_scenes_h4.txt)
| version | checks | Mayweather's hook lands | any other check turned MISMATCH |
|---|---|---|---|
| today | 10 of 14 | MISMATCH (blocked by Hatton's rear hand, held high) | - |
| H3 | 11 of 14 | **MATCH** (-4: "Hatton's lead hand was out", the angle) | none |
| H3b | 11 of 14 | **MATCH** (-3) | none |
| H4 | 11 of 14 | **MATCH** (-3: "his lead hand was out swinging") | none |

What the film shows: the scene gives Hatton `lead: 'hook', order: 'feet,lead'`. His left hook is thrown in moment 2, the same moment as
Mayweather's hook, so his lead hand is busy and the answer does not apply. I did not edit the scene. "Hatton goes down" stays MISMATCH
under every version (he starts at 5 health in the scene, and this hook does 3-4), the same as in COUNTERS1.

## The one-rep trials (n=12, seed 1, jobs=2: results/counters2_<v>_n12_s1.txt)
| version | table | bars | step in | Long | chosen | lands when he cut you off |
|---|---|---|---|---|---|---|
| H3 | 959 s, jobs=2 | 6 of 9 | 30.0% | 31.6% | 4.2% | 4 of 4 |
| H3b | 1013 s, jobs=2 | 5 of 9 | 33.3% | 23.6% | 3.4% | 4 of 4 |
| H4 | ~20 min, jobs=2 | 6 of 9 | 32.5% | 31.5% | 3.7% | 2 of 2 |
No version went under 22% step in, so all three went on to n=84.

## The table (n=84 mirror, jobs=1)
"Chosen" = the back off + lead hook plan (back off before the hook), share of beats per man. "Lands when chosen" = that plan's hook
lands (any reason). "Lands when he cut you off" = his step in met your back off in the same moment and your hook then landed. "Lead high on
step in" = share of step ins where the stepper's lead hand guards high in the moment after his step.

| version | seed | bars (red numbers) | mirror | chosen (2-15%) | lands when chosen | lands when he cut you off (45-80%) | step in (>= 22%) | Long (<= 45%) | lead high on step in |
|---|---|---|---|---|---|---|---|---|---|
| today (control) | 1 | **8 of 9** - Jab lands 68%, short 3%; Overhand lands 73%, short 17% | 56% | 0.6% | 23.5% (4/17) | (60.0% (3/5), a plain hook) | 32.8% | 31.6% | 39.4% |
| today (control) | 2 | **8 of 9** - Jab lands 66%, short 4%; Body jab lands 66%, short 4%; Overhand lands 73%, short 20%; Rear uppercut lands 66%, short 25% | 49% | 0.7% | 35.0% (7/20) | (70.0% (7/10), a plain hook) | 31.7% | 31.7% | 39.0% |
| H3 | 1 | **6 of 9** - dead: Push off 3%; Jab lands 71%, short 4%; Overhand lands 69%, short 20%; order: ordered 67%, most often first 60% | 51% | 4.6% | 27.0% (37/137) | **97.0% (32/33)** | 30.0% | 35.6% | 48.5% |
| H3 | 2 | **7 of 9** - Lead uppercut lands 69%, short 18%; Overhand lands 71%, short 20%; order: ordered 65%, most often first 61% | 60% | 4.6% | 23.9% (33/138) | **93.8% (30/32)** | 31.1% | 34.2% | 47.1% |
| H3b | 1 | **8 of 9** - Body hook lands 68%, short 9%; Overhand lands 81%, short 12%; Rear uppercut lands 45%, short 42% | 51% | 3.9% | 31.6% (37/117) | **94.6% (35/37)** | 32.1% | 31.6% | 43.5% |
| H3b | 2 | **8 of 9** - Jab lands 66%, short 2%; Overhand lands 77%, short 15% | 57% | 3.3% | 29.9% (29/97) | **100.0% (28/28)** | 31.3% | 32.8% | 41.5% |
| H4 | 1 | **7 of 9** - dead: Push off 3%; Jab lands 70%, short 2%; Overhand lands 72%, short 23% | 55% | 3.2% | 31.9% (30/94) | **90.3% (28/31)** | 31.5% | 33.9% | 42.2% |
| H4 | 2 | **8 of 9** - Jab lands 68%, short 3%; Overhand lands 74%, short 18%; Rear uppercut lands 68%, short 21% | 51% | 3.4% | 32.0% (32/100) | **91.4% (32/35)** | 32.0% | 32.0% | 43.3% |

Bar by bar:
- **Bars vs today (8 / 8):** H3 6 / 7 ✗, H3b 8 / 8 ✓, H4 7 / 8 ✗ (seed 1: Push off at 3% unrounded, under the floor). The mirror stays within 40-60% everywhere.
- **Chosen 2-15%:** all three ✓ (3.2-4.6%; today 0.6-0.7%).
- **Lands when he cut you off 45-80%:** all three ✗ (90-100%).
- **Step in >= 22%, Long <= 45%:** all ✓ (step in 30-32%, Long 32-36%). The stepping-in loop the brief named did not appear.
- **Lead high on step in:** 39% today, 42-49% under the versions. Steppers do learn to come in behind the lead hand a little more.

## Against the three men (n=84, seed 1, mix player; cap: +5 over today)
| | The Jabber | The Slugger | The Body Snatcher |
|---|---|---|---|
| today | 75% | 65% | 68% |
| H3 | 83% | 67% | 63% (**+8** Jabber ✗) |
| H3b | 76% | 69% | 74% (**+6** Body Snatcher ✗) |
| H4 | 79% | 54% | 64% (+4 / -11 / -4 ✓) |

## The feint loop (probe_clinch.mjs n=60: loop = feint + overhand, then clinch; results/counters2_*_feintloop.txt)
| | The Jabber | The Slugger | The Body Snatcher |
|---|---|---|---|
| today | 35% | 53% | 37% |
| H3b | 33% | 42% | 48% |
No version passed, so the brief's loop run on a passing version had nothing to run on. I ran it on H3b, the closest, as a pointer: it is
**worse than today against the Body Snatcher (+11)**, which would fail that bar too.

## Why the read bar does not move (the finding)
Every version still lands 90-100% when he cuts you off, and only part of that is the check hook. In H4, 15-19 of the 28-32 landed hooks
are check hooks. The rest are plain lead hooks that land under today's own cover rules, because his rear hand is not up either. The man
who walks into a back off in the solved mix nearly always comes in punching, so both his hands are busy in the hook's moment. This
plan is chosen in only 3-5% of beats, too rarely for the stepper's mix to pay for a guard against it. So a cover rule cannot make it a
read: whatever answer we give him, he does not hold it, because the plan is rare. To land 45-80%, the step in itself must change: for
example, a man who steps in and punches in the next moment pays something, or a back off + hook costs a stamina point so it is
chosen more often and he starts guarding. Both are bigger changes than this brief allows (step-in and stamina rules), so I did not
run them.

## Files and commands
- Tweaks: counters2_h3.json, counters2_h3b.json, counters2_h4.json. Tables (not in git): E:/FightCamp/wt_tmp/COUNTERS2/{h3,h3b,h4}.vt.json.
- Results: ops/research/s558_balance/results/counters2_*.txt. The measurement-only loader (COUNTERS1's, plus the lead-high-on-step-in
  count; it changes no rule, draw or number) is printed at the bottom of counters2_h3_n12_s1.txt.
- Regression: `node proto/twohands/tools/rules_test.mjs` -> RULES_TEST 37 passed. `node proto/twohands/tools/scene_check.mjs` -> 10 of 14, unchanged.
- PC: the watchdog stayed AMBER the whole time, for C: free space only (9.4-10.1 GB; CPU 22-48%, 57-62 C). Tables ran at jobs=2 and plays at jobs=1, beside KICKFIX5.

COUNTERS2 BLOCKED: no version passes every bar - the check hook lands 90-100% when he cuts you off under H3, H3b and H4, because the man who walks into a back off nearly always comes in punching and the plan is too rare for him to guard against it; a cover rule cannot make it a read.
