# Q35 — The Collision Floor

**Date:** 2026-09-10  
**Owner:** qwen  
**Tier:** NEW TEST FILE ONLY  
**Status:** Complete

## What was measured

200 seeded boxing bouts (seeds 200000–200199, same as Q34), three candidate floors: 0.30 m, 0.45 m, 0.60 m. For each floor:

1. **How often would the floor bind?** Fraction of ticks and scored strikes with separation below the floor.
2. **Where does it touch?** Grapple stance (standing/clinch/ground) and ring place (centre/ropes/corner) for sub-floor separations.
3. **What would it cost?** Count of scored strikes that would have been pushed out of range.
4. **Standing-only figure.** Exclude clinch and ground ticks; report the same metrics.
5. **Recommendation.** One floor value or none, with reason.

## Results

### Overall context (Q34 numbers for comparison)

- Total ticks: 3,706,360
- Scored strikes: 148,232
- Separation distribution (all ticks): min=0.0000, p05=0.5675, median=1.3178, p95=2.0748, max=3.7590
- Strike distance distribution: min=0.0000, p05=0.3290, median=0.8851, p95=1.0832, max=1.1000

### Candidate floor: 0.30 m

| Metric | Value |
|--------|-------|
| Ticks below floor | 37,175 / 3,706,360 (1.00%) |
| Scored strikes below floor | 6,173 / 148,232 (4.16%) |
| Standing-only strikes below floor | 6,173 / 148,232 (4.16%) |
| Sub-floor tick stance breakdown | Standing: 37,175 (100%), Clinch: 0, Ground: 0 |
| Sub-floor tick place breakdown | Centre: 25,277 (68%), Ropes: 11,041 (30%), Corner: 857 (2%) |
| Clinch+Ground share of sub-floor ticks | 0.0% |

### Candidate floor: 0.45 m

| Metric | Value |
|--------|-------|
| Ticks below floor | 108,420 / 3,706,360 (2.93%) |
| Scored strikes below floor | 14,764 / 148,232 (9.96%) |
| Standing-only strikes below floor | 14,764 / 148,232 (9.96%) |
| Sub-floor tick stance breakdown | Standing: 108,420 (100%), Clinch: 0, Ground: 0 |
| Sub-floor tick place breakdown | Centre: 72,478 (67%), Ropes: 32,915 (30%), Corner: 3,027 (3%) |
| Clinch+Ground share of sub-floor ticks | 0.0% |

### Candidate floor: 0.60 m

| Metric | Value |
|--------|-------|
| Ticks below floor | 208,389 / 3,706,360 (5.62%) |
| Scored strikes below floor | 29,495 / 148,232 (19.90%) |
| Standing-only strikes below floor | 29,495 / 148,232 (19.90%) |
| Sub-floor tick stance breakdown | Standing: 208,389 (100%), Clinch: 0, Ground: 0 |
| Sub-floor tick place breakdown | Centre: 130,707 (63%), Ropes: 69,701 (33%), Corner: 7,981 (4%) |
| Clinch+Ground share of sub-floor ticks | 0.0% |

## Key findings

1. **All sub-floor separations are standing exchanges.** In boxing, the grapple stance is always "standing" at sub-floor separations — zero clinch, zero ground. This means the floor would directly affect free-standing exchanges, not clinch or ground work where visual interpenetration is expected and acceptable.

2. **The floor is NOT free in boxing.** Unlike MMA or grappling arts where sub-floor separations might cluster in the clinch or ground (where two men ARE touching and the stage can present those seats with their own animation clips), boxing has no such escape. Every sub-floor separation is a standing exchange where two men would visually interpenetrate on the 3D stage.

3. **The cost scales with the floor value.**
   - 0.30 m: 4.2% of strikes (6,173) would be pushed out of range
   - 0.45 m: 10.0% of strikes (14,764) would be pushed out of range
   - 0.60 m: 19.9% of strikes (29,495) would be pushed out of range

4. **Sub-floor separations occur across the ring.** Roughly 2/3 in the centre, 1/3 on the ropes, a small fraction in the corners. This is not a ropes-only or corner-only phenomenon — it is a general feature of close-range boxing.

5. **The clamp cannot be modeled without touching the engine.** The fight is byte-exact-replay by design (R82). A clamp in `RingSpace.step` would change positions mid-fight, which would change the entire fight trajectory — different strikes would land, different intents would be chosen, different outcomes would result. The measurement delivered here is the post-hoc analysis of what the floor would have caught, not what it would have changed the outcome of. Re-pinning is a separate, deliberate decision.

## VERDICT

**Recommendation: 0.45 m.** It catches 10% of strikes, which is significant but not catastrophic. 0.30 m catches fewer (4.2%) but may not fully solve the visual interpenetration problem on the 3D stage. 0.60 m catches 20%, which is too many strikes and would substantially alter the fight.

**Moves pins: YES.** Any floor changes positions, which changes the fight. The 10% figure means 14,764 strikes in this 200-bout sample would have been pushed out of range. Claude must decide at integration whether to re-pin the affected cards. R85's rule is that nobody re-pins a red card to make it green — the decision is deliberate, not automatic.

## Test file

`Godot/tests/fight_collision_floor_test.gd` — parse gate passed, 8 sanity checks passed.

## Methodology note

The task asked to "model the clamp inside your test" or "if you cannot do it without touching the engine, say so plainly." I cannot model the clamp without editing `RingSpace.gd` because the clamp would change positions mid-fight, which would change the entire fight trajectory. The measurement delivered is the post-hoc analysis of what the floor would have caught, not what it would have changed. This is the measurement the task file says to deliver "if you cannot do it without touching the engine."
