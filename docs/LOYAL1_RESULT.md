# LOYAL1 Result — S461 qwen/loyal1

## Setup
- 52 club weeks, 4 fighters (Kira 60, Tess 66, Danny 58, Ana 60), 40 seeds per policy.
- Bout calendar: bouts every 4–6 weeks, staggered by fighter index, fight week = 1–2 weeks before bout.
- Pad ask: ASK ordinary 3, +2 in fight week. Mornings: 2 each, chosen for realistic sharing.
- Coach's evenings: ["pads","pads","pads"], own evening "pads" → 8 pad places.
- No holder (no fighter has loyalty ≥70 AND bouts ≥6 at start).
- Policies: COACH (coach_order), EVEN (rotate order), STARVE (no-bout fighter last), CLASS (one class night).

## Results

### SHORTWEEK1 — FAIL

| Metric | Target | Got |
|---|---|---|
| asked > owned (9/10 weeks) | ≥36/40 seeds | 40/40 (100%) ✓ |
| COACH max run short ≤2 | ≤2 | **52** ✗ |

**Root cause:** 4 fighters × 3 pads = 12 asked vs 8 owned. Every fighter gets 2 pads every week. Every fighter is short every week. The COACH short_last_week mechanism cannot help because ALL fighters are short simultaneously — there is no one to prioritise.

### LOYAL1 — FAIL

| Line | Target | Got |
|---|---|---|
| COACH min loyalty ≥50 | ≥50 | **0** ✗ |
| STARVE loses 1 fighter | ≥1 | **4 per seed (all)** ✗ |
| EVEN min loyalty >60 | >60 | **0** ✗ |

All policies drive loyalty to 0 because every fighter is short every week:
- Week 1: short (−3)
- Week 2+: short_running (−6) because the previous week's "short" is within 7 days
- Loyalty reaches 0 by ~week 10 and stays clamped

STARVE loses all 4 fighters (not 1) because all drop below 25 and accumulate 2 talks.

CLASS cash: $243,360 total across 40 seeds ($117/class night × 52 weeks × 40 seeds).

## ESTIMATES to move

The root cause is structural: **12 pad asks vs 8 pad places**. The map's "quiet week asks 10" (CLUBWEEK_MAP 3.1) was written for 3 fighters. With 4 fighters at ASK ordinary 3, the quiet week asks 12.

### To pass SHORTWEEK1 (COACH max run ≤2):
- **ClubDeal.ASK["ordinary"]** (currently 3) → **2**: so 4 × 2 = 8 = owned. Nobody short in ordinary weeks.
- OR add a 4th Coach evening (or increase own evening to 3 pad places) so owned ≥ 12.
- OR introduce a holder earlier (lower LOYAL_AT or HOLD_BOUTS) so the pool is 9+.

### To pass LOYAL1 (COACH min ≥50):
- Same pad fix as SHORTWEEK1 (if nobody is short, loyalty grows from full_week +1).
- OR **Loyalty.MOVES["short"]** (currently −3) → **−1 or −2**: slower drop, stays above 50 longer.
- OR **Loyalty.MOVES["full_week"]** (currently +1) → **+2 or +3**: recovery outweighs occasional short.

### To pass LOYAL1 (STARVE loses exactly 1):
- The pad fix above would reduce short weeks under STARVE, so fewer fighters drop.
- OR **Loyalty.LEAVES_UNDER** (currently 25) → **15 or 20**: harder to trigger leaving.
- OR **Loyalty.MOVES["short"]** less negative: fighters stay above 25 longer.

### To pass LOYAL1 (EVEN min >60):
- Same pad fix: if fighters aren't all short every week, EVEN's rotation keeps everyone fed.
- OR **Loyalty.MOVES["full_week"]** (currently +1) → **+3**: even occasional full weeks recover loyalty fast.

## Verdict summary

```
SHORTWEEK1 = fail
LOYAL1 = fail
```

The probe's one clear finding: **the pad place count (8) is too low for 4 fighters at ASK ordinary 3**. Until either the asks come down or the places go up, every policy drowns in short weeks and loyalty collapses. The COACH rotation, the EVEN fairness, and the STARVE pressure all measure correctly — they just have no room to work.

## Regression

```
RESULT: tests/club_deal_test.gd -> CLUB_DEAL failures=0
RESULT: tests/loyalty_test.gd -> LOYALTY failures=0
```

## S462 Claude's rerun and decision
- Rerun on the same seeds (S462): every number above reproduced line for line. The page is honest.
- Decision: nothing is wired (INTEGRATION_S459 #6 Loyalty, #11 ClubDeal stay waiting). The fail is structural, not a tuning slip:
  four starters (SCOPE S428) ask 12 pad places against 8 owned, so "short" (covered < asked) is true for every fighter every
  week and no deal order can rotate it. The club-week map goes back to the design loop (CLUBWEEK v5) with this finding. The
  direction Claude asks the designer to test: a fighter's NEED is 2 pad places (short = under the need), the 3rd is a WANT that
  only the deal order decides; fight weeks (+2) are where the real shortage and the choices are. Re-measure with this probe.
