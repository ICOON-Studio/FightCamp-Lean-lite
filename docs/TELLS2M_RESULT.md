# TELLS2M RESULT - the tells, version 2, measured on the instrument (S563, probe; Arena seat)

Task: ops/research/TASK_TELLS2M.md. Tool: `proto/twohands/tools/probe_tells.mjs` (new), test `probe_tells_test.mjs` (new).
Raw: `ops/research/allplay2/tells2m_b<bot>_<man>.txt` (10 files, each committed and pushed as it finished).
Nothing else was edited: no page, no rules.mjs / balance.mjs / tells.mjs / play_cli.mjs, no test.

**Status: the one-rep trial (n=12 a pair, seed 1) ran in full. Its stop rule fired: BOT 1 won 29 of 34 decided bouts
(85.3%, over the 85% line). So the n=84 run was NOT started.** Every number below is from n=12. At that size a 10-of-12
pair has a 95% range of about 52-98%, so read the gaps between the bots as signs, not as measurements.

## How it was played
- Whole bouts on the page's rules (order.html through rules.mjs, vtable.json as the page loads it). The man is the page's
  opponent, choosing with `ai()`. His beat is chosen FIRST, and his cue comes from that beat:
  `tellOf(opp, his, c, 2)` (as play_cli.mjs tells=2). A fake costs him 1 stamina after the beat.
- BOT 0 = the page's mix (balance.mjs `who=mix`). BOT 1 = BOT 0's beat with its HELD hands moved to the lines the cue
  names (shoulder: both high; knees: both low; front foot: no back off; back foot or quiet: no change), its punches kept.
  BOT 2 = BOT 1, except that when `LIES[opp].test(c)` holds it plays BOT 0's beat.
- All three bots use the same seeds, so a bout starts from the same draws for each bot. The only thing that differs is
  what the tell makes the bot do.
- Test: red first (module not found), then 5 of 5 pass. Those 5 include "BOT 0 replays a balance.mjs mirror bout for
  bout on the same seed".
- Regression: rules_test 37 passed, page_play_test 4 passed.

## The table (trial, n=12 a pair, seed 1)
| bot | against | wins of decided | knockdowns a bout (him / you) | stoppages | his fakes per beat | his stamina at the bells (R1 / R2 / R3, of 8) |
|---|---|---|---|---|---|---|
| BOT 0 no tell | mirror mix | 50% (6 of 12) | 2.83 (1.33 / 1.50) | 25% | - (no tells) | 1.6 / 2.3 / 3.1 |
| BOT 0 no tell | Jabber | 83% (10 of 12) | 2.75 (2.33 / 0.42) | **50%** | 29% | 2.3 / 2.0 / 2.3 |
| BOT 0 no tell | Slugger | 83% (10 of 12) | 2.00 (1.42 / 0.58) | 17% | 36% | 1.2 / 2.3 / 2.8 |
| BOT 0 no tell | Body Snatcher | 67% (8 of 12) | 2.75 (1.58 / 1.17) | 17% | 9% | 2.1 / 3.0 / 2.3 |
| BOT 1 blind | Jabber | 83% (10 of 12) | 2.50 (1.92 / 0.58) | 25% | 31% | 2.3 / 2.7 / 2.0 |
| BOT 1 blind | Slugger | 75% (9 of 12) | 1.67 (1.33 / 0.33) | 17% | 29% | 2.3 / 2.5 / 2.0 |
| BOT 1 blind | Body Snatcher | 100% (10 of 10, 2 draws) | 2.42 (2.08 / 0.33) | 33% | 11% | 2.1 / 2.1 / 2.3 |
| BOT 2 knows the lie | Jabber | 83% (10 of 12) | 2.75 (2.17 / 0.58) | **42%** | 24% | 2.3 / 1.6 / 2.4 |
| BOT 2 knows the lie | Slugger | 100% (12 of 12) | 1.75 (1.58 / 0.17) | 33% | 38% | 1.8 / 2.1 / 2.4 |
| BOT 2 knows the lie | Body Snatcher | 100% (11 of 11, 1 draw) | 2.25 (2.08 / 0.17) | 33% | 13% | 2.1 / 2.6 / 2.1 |

Health he dealt a bout (from the same files). Following blindly cut it a lot against the Body Snatcher and not against
the other two:
| against | BOT 0 | BOT 1 | BOT 2 | his punches landed, BOT 0 -> BOT 1 -> BOT 2 |
|---|---|---|---|---|
| Jabber | 14.8 | 16.0 | 14.6 | 45% -> 48% -> 43% |
| Slugger | 15.3 | 15.9 | 11.7 | 44% -> 47% -> 35% |
| Body Snatcher | 21.3 | 15.2 | 13.8 | 57% -> 48% -> 46% |

How often each cue lied when it was shown (BOT 1 bouts):
- Jabber: the shoulder cue was fake on 66 of 132 beats.
- Slugger: the shoulder cue was fake on 62 of 111 beats.
- Body Snatcher: the knees cue was fake on 23 of 113 beats.
- No other cue ever lied.

How often each man's lie condition held, of all beats: Jabber 41-46%, Slugger 41-46%, Body Snatcher 19-28%.

## The bars (trial numbers)
- **BOT 1 at most 55% of decided against each man: FAIL against all three.** Jabber 83%, Slugger 75%, Body Snatcher 100%.
  - The control is already above the bar: BOT 0 wins 83 / 83 / 67%. So the bar cannot be met even by a tell that is
    worth nothing.
  - What the tell itself adds (BOT 1 minus BOT 0): Jabber +0, Slugger -8, Body Snatcher +33 points.
- **BOT 2 at 70% or more, OR at least 10 points over BOT 1: PASS against all three.**
  - Through the 70% clause: Jabber 83%, Slugger 100%, Body Snatcher 100%.
  - The +10 clause alone passes only against the Slugger (+25). Jabber is +0, and the Body Snatcher is +0 because BOT 1
    is already at 100%.
  - Again, the 70% clause is met by the control alone.
- **BOT 0 about 50% against the mirror mix: PASS**, 50% (6 of 12).
  - Against the page's men the control wins 67-83%. That is the S555 design (their skill is under 1: 81 / 69 / 62% in
    ops/research/s555_balance/opponents_on_the_page.txt). It is not a fault of this probe, but it is why every win-rate
    bar here is lopsided.
- **His fakes on 15-30% of beats: FAIL for 5 of the 9 pairs.**
  - Jabber: 29 / 31 / 24%, passes in 2 of 3.
  - Slugger: 36 / 29 / 38%, passes in 1 of 3.
  - Body Snatcher: 9 / 11 / 13%, passes in none.
  - Against the mix bot the Jabber's and the Slugger's conditions hold on 41-46% of beats, against 27-29% in AI-v-AI
    bouts. A strong player backs him off and lands more, so these two lie more.
- **Stoppages 10-40% in every pair: FAIL in 2 of 10.** Jabber v BOT 0 is at 50% and Jabber v BOT 2 at 42%. The other 8
  are at 17-33%.

## The feedback loop and the cap
- Nothing feeds back into how he lies (his AI does not know it is read), and v2 has no cap. In the trial that does NOT
  make BOT 1 too strong overall, because the lies are bluffs only.
  - Against the Jabber and the Slugger, about half of all shoulder cues are fakes. A blind follower gains nothing (+0)
    or loses (-8), and lets in slightly more health.
  - The Body Snatcher lies least (about 11% of beats). His knees cue is true 4 times in 5, so blind following is worth
    the most against him: +33 points, and 6 health a bout less taken.
  - So the missing cap matters only where the lie rate is low, which today is the Body Snatcher.
- A fake costs 1 stamina, but the liars do not end rounds more tired than the man who lies least. At the bells the
  Jabber averages 1.6-2.7, the Slugger 1.2-2.8 and the Body Snatcher 2.1-3.0. The bots in the player's corner end on
  1.0-2.4. Every man finishes a round near empty anyway, so the fake's cost is lost in that.

## Is the tell worth showing on the page as it is?
1. **Not yet.** The trial is too small to decide, and its stop rule fired. Within it, the tell is worth nothing to a
   blind follower against the Jabber and the Slugger (half of their shoulder cues lie), and it is worth a lot against
   the Body Snatcher (his knees cue is true 4 times in 5).
2. **What to change:**
   - Retune the lie conditions so each man fakes on about 1 beat in 5 against a STRONG player, not just AI v AI. The
     Slugger's "you landed on him" and the Jabber's "after he backed off" fire on 41-46% of beats against the mix. The
     Body Snatcher's "you blocked any punch" fires on only 9-13%.
   - Restate Kalli's bars relative to the control (for example BOT 1 at most BOT 0 + 5 points, BOT 2 at least BOT 1 +
     10), or measure against men at skill 1 so the control sits near 50%.
3. **Then run n=84.** The runner and the tool are ready:
   `node proto/twohands/tools/probe_tells.mjs bot=<0|1|2> opp=<0|1|2|mirror> n=84 jobs=2 seed=2`. That is about 20 min a
   pair on 2 cores, about 3.5 h for all 10 pairs.

TELLS2M BLOCKED: the one-rep trial's stop rule fired (BOT 1 won 29 of 34 decided = 85.3% > 85%), so the n=84 run was not
started. The trigger is mostly the control's own edge: BOT 0 already wins 28 of 36 (78%) against the page's men. The
owner or lead decides whether to waive the stop or restate the bars relative to BOT 0, and then the n=84 run follows.
