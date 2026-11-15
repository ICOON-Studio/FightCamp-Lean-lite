# WHYGRADE1: why a good plan reads GOOD less often since CARDFIX1

## The numbers

| Commit | graded_good | of 540 |
|--------|-------------|--------|
| 3fd32033^ (pre-CARDFIX1) | 375 | 69.4% |
| 7e993c55 (main, post-CARDFIX1) | 278 | 51.5% |
| **Drop** | **97 bouts** | **-17.9 pp** |

## The situation that lost the most edge: counter at long -> outside

### What changed

CARDFIX1 made two changes (commit 3fd32033):
1. `GAME_CARD["counter"]` moved from `"long"` to `"outside"` (a counter-puncher waits outside her range)
2. `she_tired` / `she_hurt` no longer put the boxer on a fixed card (inside / own_ropes) - she is tired or hurt where she stands, a lost exchange moves her (where_next)

### Where the plan's edge went

**1. counter at long -> counter at outside (the biggest loss)**

Before CARDFIX1, counter exchanges happened at `long`. The GOOD plan's `1-1` fires there:
- Pre-fix: counter|long n=487, fired=235 by 1-1:235, won=265 (54%). No plan: 45% won. **Plan edge: +9 pp.**
- Post-fix: counter moved to `outside`. The GOOD plan has no arrow for outside counter:
  - counter|outside n=261, fired=0, won=115 (44%). No plan: 45%. **Plan edge: -1 pp.**
  - counter|long still exists (n=239, fired=117, won=145, 61%) but lost 248 exchanges (487 -> 239).

The plan's 1-1 answered counter at long (it's in ANSWERS.counter.best). At outside, 1-1 is not in the plan, and no plan arrow starts at outside. The 261 counter exchanges at outside read as improvised - the plan contributes nothing.

**2. she_tired at inside -> she_tired spreads (second loss)**

Before CARDFIX1, she_tired always put her at `inside` where `tie_up` fires:
- Pre-fix: she_tired|inside n=1297, fired=1297 by tie_up:1297, won=724 (56%). No plan: 47%. **Plan edge: +9 pp.**
- Post-fix: she_tired happens where she stands. Only 561 of the exchanges land at inside:
  - she_tired|inside n=561, fired=561 by tie_up:561, won=272 (48%). No plan: 43%. **Plan edge: +5 pp.**
  - The rest spread to clinch (240), long (226), mid (131), own_ropes (55), opp_ropes (32), outside (7) - places where the GOOD plan has no she_tired answer.

Tie_up is still best at inside for she_tired, but the situation now happens there less than half the time. The plan's edge diluted from +9 pp to +5 pp on fewer exchanges.

**3. she_hurt at own_ropes -> she_hurt spreads (smaller loss)**

Before CARDFIX1, she_hurt always put her at `own_ropes` where `pivot_out` fires:
- Pre-fix: she_hurt|own_ropes n=402, fired=402 by pivot_out:402, won=152 (38%). No plan: 37%. **Plan edge: +1 pp.**
- Post-fix: she_hurt spreads. own_ropes n=240, fired=240 by pivot_out:240, won=84 (35%). No plan: 35%. **Plan edge: 0 pp.**

Pivot_out was barely better than no plan at she_hurt|own_ropes (+1 pp). Now it's neutral. The situation also happens less (402 -> 240+84+50+43+36+12 = 465 total, some at new places).

### Summary

| Situation|Place | Pre-fix fires | Post-fix fires | Plan edge before | Plan edge after |
|----------|-------|---------------|----------------|------------------|-----------------|
| counter\|long | 235 (1-1) | 117 (1-1) | +9 pp | +16 pp (but half the exchanges) |
| counter\|outside | 0 | 0 (none fire) | n/a | -1 pp (261 exchanges, no answer) |
| she_tired\|inside | 1297 (tie_up) | 561 (tie_up) | +9 pp | +5 pp |
| she_hurt\|own_ropes | 402 (pivot_out) | 240 (pivot_out) | +1 pp | 0 pp |

The biggest single cause: **counter moved from long to outside, and the GOOD plan (1-1, step_back, pivot_out, tie_up) has no answer for counter at outside.** Before CARDFIX1, 235 of 487 counter exchanges at long fired 1-1 at +9 pp over no plan. After, 261 counter exchanges at outside fire nothing from the plan, reading as improvised.

The fix for the plan is to add an outside arrow that answers counter: `feint` (ANSWERS.counter.best includes feint, and StrikeMap.move("feint").from = "outside"). The 05:00 review tested this and found it "changed nothing (276)" - but that was before measuring where the fires went. The table shows why: feint at outside would answer 261 counter exchanges that currently read as no plan.
