# STYLE1 Result

Probe run: 2026-11-15T04:52:12. N=10 bouts per fighter per cell, 60 fighters, 6 styles, 4 opponents.

## Question

Does any named style dominate, and is each one worth having?
Gate: each style's effect worth 1.5 to 4 wins in 100 against its best opponent.

## Method

Part A: 60 generated fighters (seeds 7100-7159), 6 named styles, 4 style opponents.
For each fighter x style: set the style's 3 moves to 60 mastery, set named_style, play 10 bouts vs each opponent.
Control: same fighter, same moves at 60, no named_style.
Delta = win% with named style minus win% without.

Part B: 3 seeds x 64 fighters (4 prospects + 60 walk-ins), 2 seasons (104 weeks).
Track first week each style held, style named, two_held at any Monday.

## Part A: Delta Table

| Style | vs Pressure | vs Counter | vs Volume | vs Boxer-puncher | Best Delta |
|-------|-------------|------------|-----------|------------------|------------|
| Out-boxer | +1.3 | +0.2 | +0.3 | +0.0 | +1.3 |
| Volume puncher | +1.0 | +0.8 | +0.8 | +0.5 | +1.0 |
| Boxer-puncher | +0.0 | +0.0 | +0.0 | +0.0 | +0.0 |
| Pressure fighter | +0.0 | +0.0 | +0.2 | +0.0 | +0.2 |
| Slugger | +0.0 | +0.0 | +0.0 | +0.2 | +0.2 |
| Counter-puncher | +0.0 | +0.0 | +0.0 | +0.0 | +0.0 |

## Part B: Road to Each Style

| Style | Median Weeks | Named Share |
|-------|--------------|-------------|
| Out-boxer | never | 0.000 |
| Volume puncher | never | 0.000 |
| Boxer-puncher | never | 0.000 |
| Pressure fighter | never | 0.000 |
| Slugger | never | 0.000 |
| Counter-puncher | never | 0.000 |

Two held at once: 0.000 of careers
Spread of medians: 0 weeks

## Gates

- Gate 1 (each style worth 1.5-4 wins in 100): FAIL
- Gate 2 (no style best vs all): pass
- Gate 3 (no style named >1/3 careers): pass
- Gate 4 (two_held <1/4 careers): pass
- Gate 5 (spread of medians <=3 weeks): pass

**STYLE1 pass=0 why=gate1_fail**

## Plain Words

A named style is worth having if its best delta is positive and in the 1.5-4 range. 
No style's effect is in the 1.5-4 range. 
No style dominates all four opponents. 
The effect to change is Out-boxer's { "lever": "range_open", "add": 0.1 } (1.33333333333333). 
Increase it so the delta is closer to 2.

## Claude's read (S481)
- Gate 1 is the finding: the six named styles are worth 0 to 1.3 wins in 100 against their best opponent (bar 1.5 to 4).
  N=10 a cell is noisy (one win = 1 in 100 here), but every style sits at or under the bar's floor, so the read stands.
- Part B is NOT evidence about the game: it ran the probe's own simplified career (S1Rules.sim_career), not prog_probe's
  week loop the brief named, and "never held" may be that model. STYLE2 tunes the effects (Part A, N=40) and redoes Part B
  on tools/prog_probe.gd's loop.
