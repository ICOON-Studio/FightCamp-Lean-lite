# J57 WHAT A LANDED LEG KICK LOOKS LIKE ON THE MAN WHO TAKES IT

Done by Claude, S98 2026-09-27 (John's Grok Bot is at its weekly limit; the operator said "u take all their tasks").
Task: `TASK_J57_WHAT_A_LANDED_LEG_KICK_LOOKS_LIKE.md`. Feeds Codex C214 (the react_leg ladder).
Tags: SOURCED (link) / PROXY / JUDGEMENT.

## What exists and what does not

No published study counts receiver REACTIONS to landed low kicks. The kickboxing studies count kicks thrown, landed and
checked, not what the body did afterwards (Slimani 2017; Wasacz/Niewczas 2024; K-1 technique-frequency studies, where the
low kick is ~25% of all kicks - SOURCED:
https://www.researchgate.net/publication/359011880_ANALYSIS_OF_KICKBOXING_BASED_ON_THE_TYPE_AND_FREQUENCY_OF_APPLIED_TECHNIQUES).
Glory and Wikipedia describe the effect qualitatively: loss of stability and mobility, a leg that "feels heavy", a leg
temporarily "paralysed" after enough punishment, and sweeps when a kick lands on the weight-bearing leg (SOURCED:
https://glorykickboxing.com/news/the-art-of-low-kicks, https://en.wikipedia.org/wiki/Low_kick). So the shares below are
JUDGEMENT, built on G134's counts: ~8 landed low kicks per fighter per K-1 fight, a limp after 8-12 clean thigh kicks,
3-6 hard calf kicks, and knockdowns from low kicks being rare enough that single fights are remembered for them.

## 1. Reaction shares for a landed low kick (JUDGEMENT, anchored on G134)

| Reaction | Fresh leg | Leg already HURT | Notes |
|---|---|---|---|
| Nothing visible / absorbs, keeps punching | ~55% | ~25% | glancing, partly checked, or landed on a braced leg |
| Weight shift / lifts the foot / hitch | ~35% | ~40% | the everyday reaction: the leg comes off the floor for a beat |
| Stumble step (one or two re-balancing steps) | ~8% | ~22% | usually a kick that landed on the weight-bearing leg |
| Buckle (knee dips, hand may touch down) | ~2% | ~11% | calf kicks and late-fight thigh kicks |
| Knockdown from the kick | <0.5% | ~2% | the leg gives out; commonly the 2nd-3rd round of a leg-kick war |

Why the fresh-leg column is so quiet: a K-1 fighter lands ~8 low kicks a fight and a limp usually comes only after 8-12
clean ones (G134 section 3). If a quarter of fresh-leg kicks produced a stumble or worse, every fight would look like a
leg-kick stoppage, and in real fights it does not.

## 2. What raises the chance of a big reaction

- **Calf vs thigh** (SOURCED: https://en.wikipedia.org/wiki/Peroneal_strike,
  https://www.thesportster.com/why-calf-kicks-effective-in-mma-explained/): the peroneal nerve sits under the skin
  beside the fibula. A calf kick makes the foot go numb and the leg buckle with far fewer strikes (G134: 3-6 against
  8-12 for the thigh). Roughly doubles the buckle share (JUDGEMENT).
- **Landing on the weight-bearing leg** (Wikipedia, qualitative): a kick to the leg he is standing on becomes a sweep
  or a stumble. The same kick to an unweighted leg just moves the leg. The single biggest factor (JUDGEMENT).
- **Accumulated damage:** the reaction grows once a leg passes about half of its limp count (~5 clean thigh kicks). After
  that, stance switches and stumbles appear (G134 case pattern: Verhoeven vs Silva, Wilnis vs Rodriguez).
- **Checked kicks** produce no receiver reaction; the kicker may be the one hurt.

## 3. How long before he is back in stance (JUDGEMENT, from fight film pace)

| Reaction | Time back in stance |
|---|---|
| Nothing / absorbs | 0 s |
| Hitch / weight shift | 0.3-0.6 s |
| Stumble step | 0.8-1.5 s |
| Buckle | 1.5-2.5 s |
| Knockdown | referee count; the leg-kick TKO usually follows within the round |

The current `react_leg` (StaggerLarge04, 2.7 s, hands and knees) is a knockdown-tier reaction.

## 4. Recommendation for C214: a 3-tier ladder

| Tier | Clip kind | Fresh leg | Leg HURT (band hurt) | Leg CRITICAL or worse |
|---|---|---|---|---|
| Light: hitch, <= 0.6 s, stays upright | StaggerSmall / HitReaction | 90% (includes "nothing") | 65% | 35% |
| Medium: stumble or buckle, <= 1.5 s, upright | StaggerMedium | 10% | 32% | 50% |
| Heavy: collapse (StaggerLarge04) | the current clip | 0% | 3% | 15% |

Rule of thumb: the heavy clip plays only when the leg is already hurt, and mostly when it is critical. That is exactly
C214's brief. Add the medium tier, and make a calf kick or a kick to the weight-bearing leg step up one tier.
