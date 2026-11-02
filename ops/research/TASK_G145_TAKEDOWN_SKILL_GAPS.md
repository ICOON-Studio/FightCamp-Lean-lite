# TASK G145 - GROK - HOW A WRESTLING GAP MOVES TAKEDOWNS AND GET-UPS (S114)
Status: CANCELLED S114 - a duplicate. The operator: "i am sure this research has been done at least 3 times already".
Takedown rates are in J20_THE_VALIDATION_CORPUS.md (success 35.3%, defence 69.8%, 0.29 att/min) and
J33_WHAT_THE_SPORT_MEASURES.md (TD accuracy ~40%, ~1.5 att/round); stuffed shots in G141_FRONT_HEADLOCK_AND_TURTLE.md;
landing seats in G143_TOP_POSITIONS.md; state shares in G138_MMA_FIGHT_STATE_TIME_SHARE.md. Grok chat a33c420e NOT collected.

Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S114). Deliverable: one markdown answer, which Claude
saves as research/G145_TAKEDOWN_SKILL_GAPS.md. Fresh chat.

## Why

G144 scaled the ground seats (guard, half, side, mount, back) by a grappling skill gap and by style. But a fight only
reaches those seats through takedowns, and a wrestler's edge lives mostly in whether the takedown lands and whether
the other man gets back up. The engine's next step is a fight-level census of mixed pairs (G144 section 5: grappler
beats striker 64-72%, wrestler control 6-12 min). Without takedown and get-up rates scaled by skill, that census
cannot hit those gates for the right reason.

## What would a human do?

A wrestling coach and a FightMetric analyst: the coach knows a D1 wrestler finishes a double against a kickboxer far
more often than against another wrestler, and that a striker's sprawl buys him a stand-up but not a clean escape; the
analyst shows it with UFCStats takedown accuracy vs opponent takedown defence, attempts per 15 min by pedigree, and
time-to-get-up after a takedown.

## Prefab check

Name any dataset that splits takedown success or get-ups by wrestling pedigree or skill tier (UFCStats TD Acc / TD Def
per fighter, FightAlpha-style TD-edge models, NCAA wrestling records, academic papers on wrestling background and
MMA outcomes), its licence, and whether its numbers are public.

## Questions

1. Takedown attempt rate per minute at range and in the clinch/fence, by attacker identity (wrestler / BJJ /
   striker): multipliers on an average UFC pair.
2. Takedown success given attempt, as a function of (attacker wrestling - defender wrestling): a multiplier per 20
   points on a 0-100 scale, with caps. Split open-range shots from clinch/fence takedowns if the data allows.
3. Where the takedown lands (guard / half / side / mount / back / turtle) and how that shifts with the gap.
4. Get-ups: after landing on the bottom, how quickly a man stands, by the bottom man's identity and the gap - as a
   multiplier on G143's `stand` row where it overlaps; say where it does not.
5. Sprawl / stuffed shot: what a failed shot costs the attacker (front headlock, guillotine exposure, a scramble to top).
6. Caps: the most extreme realistic rate (elite wrestler vs pure striker), so a sim never lands 100% of shots.
7. Acceptance: fight-level numbers a census of MIXED pairs should hit (takedowns landed per 15 min by pedigree,
   TD accuracy league-wide, share of fights with at least one takedown) - name the source for each.

Grade every figure S (sourced) / P (proxy) / J (judgement). Use the same convention as G144:
`d20 = (actor - opponent)/20`, `mult = clamp(base^d20, cap_lo, cap_hi)`, style factors after. Return ONE markdown
artifact named G145_TAKEDOWN_SKILL_GAPS.md.
