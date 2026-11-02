## DECISIONS

One row per clip. Verdict from the numbers, not the name. Facing signed toward toes; all hands_forward positive.

| Clip | Loops? | Hands up? | Hands fwd? | Staggered? | Standing? | Osc/min (Davis 47-56) | Verdict |
|------|--------|-----------|------------|------------|-----------|----------------------|---------|
| H2H_Idle.FBX | yes (0.11°) | yes (0.167 m below head) | yes (0.124 m) | yes (0.41 m stagger, 0.28 m width) | yes | 64.3 (above Davis) | **Boxer's stance** - seamless loop, bounce, guard position |
| H2H_BlockIdle.FBX | no (3.74°) | barely (0.035 m) | yes (0.042 m) | yes (0.53 m stagger) | yes | 78.3 (above Davis) | **Block** - not a loop, hands close to head, defensive |
| H2H_JumpIdle.FBX | yes (0.02°) | yes (0.155 m) | yes (0.118 m) | yes (0.39 m stagger) | **no** - airborne (lowest foot 1.229 m, amp 1.547 m) | 50.0 | **Jump** - both feet off the ground, not a stance |
| H2H_LegBlockIdle.FBX | yes (0.05°) | yes (0.120 m) | yes (0.046 m) | minimal (0.18 m stagger) | **no** - lowest foot 0.151 m > 0.15 m | 78.3 (above Davis) | **Leg block** - check-low posture, foot barely lifts |
| Standing_Idle.FBX | yes (0.06°) | no (0.692 m - hands at sides) | yes (0.007 m) | minimal (0.24 m stagger) | yes | 27.0 (below Davis) | **Relaxed stand** - hands down, not a fighter's stance |
| idle_A.fbx | yes (0.86°) | yes (0.169 m) | yes (0.181 m) | minimal (0.05 m stagger) | yes | 0.0 (no bounce) | **Static hold** - loops, hands up, zero oscillation; candidate but no boxer bounce |
| idle_Tiramis.fbx | yes (0.86°) | yes (0.190 m) | yes (0.209 m) | slight (0.16 m stagger) | yes | 0.0 (no bounce) | **Static hold** - loops, hands up, zero oscillation; candidate but no boxer bounce |
| muay_thai_guard_stance.fbx | no (5.17°) | yes (0.156 m) | yes (0.260 m) | yes (0.28 m stagger) | yes | 0.0 (no bounce) | **Muay Thai guard** - not a loop, static, different martial art |
| wrestling_guard_position.fbx | yes (2.86°) | yes (0.258 m) | yes (0.033 m) | yes (0.21 m stagger) | **no** - pelvis at 0.085 m, extreme low crouch | 0.0 | **Wrestling crouch** - pelvis far below standing range |
| staff_spin_guard.fbx | no (69.42°) | yes (0.371 m) | yes (0.265 m) | yes (0.36 m stagger, 0.89 m width) | yes | 0.0 (no bounce) | **Weapon stance** - not a loop, wide stance for staff |
| sword_draw_stance.fbx | no (84.20°) | yes (0.494 m) | yes (0.120 m) | yes (0.47 m stagger, 0.63 m width) | yes | 0.0 (no bounce) | **Weapon stance** - not a loop, sword-draw posture |

**Unmapped (bones not found):** none - all eleven rigs were fully mapped.

## H2H_JumpIdle: airborne, not wrongly composed

lowest_foot_y_max_m = 1.229 m: the lower foot never comes below 1.23 m, so both feet are off the ground for the entire clip. pelvis_y_amp_m = 1.547 m is the vertical travel of an airborne character, not a composition error. The RamsterZ tree composition was validated by U83 on H2H_Idle; the same method on JumpIdle gives numbers that are physically consistent with a jump idle.

## Verdict: which could be a boxer's stance take in rotation with H2H_Idle?

**Only H2H_Idle itself is a true boxer's stance** - it loops seamlessly, has the boxer's bounce (64.3 osc/min, above Davis's 47-56 but close to the women's 63), hands up in guard, feet staggered, standing=true.

**idle_A and idle_Tiramis are candidates** - they loop seamlessly and have hands up in front of the chest, but zero pelvis oscillation (static holds). They could be stance takes if the operator accepts a motionless stance.

**The rest are not boxer's stances:**
- H2H_BlockIdle is a block (not a loop, defensive posture)
- H2H_JumpIdle is a jump (airborne, both feet off the ground)
- H2H_LegBlockIdle is a leg block (check-low posture, foot lifts off ground)
- Standing_Idle is a relaxed stand (hands at sides)
- muay_thai_guard_stance is a muay thai guard (not a loop, static)
- wrestling_guard_position is a wrestling crouch (pelvis at 0.085 m, far below standing range)
- staff_spin_guard and sword_draw_stance are weapon stances (not loops, weapon-specific postures)

**Davis's reference:** elite boxers make about 47-56 vertical hip oscillations per minute (men), about 63 (women) - a rate, not an amplitude. H2H_Idle's 64.3 osc/min is slightly above the men's range but close to the women's rate.

**Pack status:**
- ramsterz_h2h: approved (Standard Unity Asset Store EULA)
- magicpot_fm1: candidate (Standard Unity Asset Store EULA)
- motifect: candidate (Pack README: licensed for commercial and non-commercial game/interactive projects)

Clips in candidate packs may still be measured; they are not yet approved for production use.
