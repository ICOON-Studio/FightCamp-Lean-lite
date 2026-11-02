# Q160 DIGEST - SEE the 8 holds the family map leans on, and price the 66-technique striking gap

## Part 1 - Render every hold PAIRED_FAMILY_BINDINGS references

### What changed
Rendered the 8 unique pair keys that PAIRED_FAMILY_BINDINGS (after Q159) references.
The render tool (`tools/render_paired_hold.gd`) only handles Cascadeur .glb pairs in
`CASCADEUR_DIR`. Of the 8 pair keys, only 1 is a Cascadeur pair; the other 7 are
RamsterZ .fbx pairs in `ramsterz/` and the tool refuses them.

### Render results

| Pair key | Source | Render key | Result |
|---|---|---|---|
| grapple_submission_attempt | RamsterZ .fbx | Paired_FullMount_H2H_ArmBar | REFUSED (not in CASCADEUR_DIR) |
| grapple_takedown | RamsterZ .fbx | Paired_FullMount_Takedown_DoubleLeg_Start | REFUSED |
| grapple_throw | RamsterZ .fbx | Paired_FullMount_Takedown_BodyLock_Start | REFUSED |
| grapple_sweep | RamsterZ .fbx | Paired_FullMount_Reversal | REFUSED |
| grapple_escape | RamsterZ .fbx | Paired_FullMount_PushOff | REFUSED |
| grapple_control | RamsterZ .fbx | Paired_FullMount_Takedown_BodyLock_Loop | REFUSED |
| bjj_side_control | Cascadeur .glb | Cascy_SideControl | RENDERED (24 frames) |
| mma_guard_gnp | RamsterZ .fbx | Paired_FullMount_H2H_Punches | REFUSED |

### Cascy_SideControl read
Side view (side__02): Top man (blue gloves, black shorts) perpendicular across bottom
man (red gloves, maroon shorts) who lies flat on his back. Top man's torso is across
the bottom man's chest, knees on the mat. Textbook side control.

High view (high__02): Confirms the perpendicular arrangement. Top man's weight is
distributed across the bottom man's torso, not concentrated on the head or hips.
Bottom man's legs are extended, arms are up in guard position.

### Holds that lie about themselves
**None found in the rendered set.** The one rendered hold (Cascy_SideControl) shows
exactly what its name says: side control.

**The 7 RamsterZ pairs that refused are themselves a finding:** the render tool
cannot visually verify 7 of the 8 holds that 176 grappling techniques lean on.
The tool is hardcoded to `CASCADEUR_DIR/*.glb` and refuses RamsterZ `.fbx` pairs
even though the files exist on disk. This is a tool limitation, not a missing file.

### Files added
- `previews/family_holds/Cascy_SideControl_side.png`
- `previews/family_holds/Cascy_SideControl_high.png`

---

## Part 2 - Price the striking gap

### What changed
Added 21 free-coverage bindings to `STRIKE_FAMILY_BINDINGS` from unbound RamsterZ
H2H clips. These are techniques that were NONE but have owned clips that cover them.

### Coverage before/after
```
BEFORE: EXACT 26, NEAR 132, FAMILY 296, GAP 14, NONE 66
AFTER:  EXACT 26, NEAR 132, FAMILY 315, GAP 14, NONE 47
```
FAMILY +19, NONE -19. (Added 21 bindings; 2 techniques were already classified
as something other than NONE.)

### Free coverage bindings added (21 techniques)

| Clip | Techniques bound | Branch |
|---|---|---|
| H2H_LeftCutKick_Forward | savate_chasse_frontal, savate_chasse_lateral, savate_chasse_bas, savate_coup_bas, savate_revers_fouette, savate_revers_balance | chasse (3), revers_lowline (3) |
| H2H_GroinPunch_InPlace | arnis_empty_hand_strike | empty_hand (1) |
| H2H_Dodge_Left/Right/Forward/Back | boxing_pivot_footwork, boxing_circle_lead, boxing_circle_rear, boxing_feint, boxing_angle_step, boxing_switch_stance | footwork_ring (6) |
| H2H_RunForward/Back | boxing_step_in_out, boxing_rhythm_change, boxing_drawing, savate_direct, savate_direct_fouette, savate_elite_chain, savate_direct_double | footwork_ring (3), movement_boxing (4) |

### Remaining NONE (47 techniques) - the striking authoring order

| Branch | Count | What it needs |
|---|---|---|
| combinations | 21 | Multi-technique chains - Cascadeur or Higgsfield text-to-motion |
| footwork_ring | 0 | (all 9 bound above) |
| defense_counters | 5 | Boxing/tkd counters - need counter-specific clips |
| single_stick | 4 | Arnis single stick - need weapon pack |
| movement_boxing | 0 | (all 4 bound above) |
| disarms | 3 | Weapon disarms - need weapon pack |
| double_weapon | 3 | Arnis double stick - need weapon pack |
| chasse | 0 | (all 3 bound above) |
| revers_lowline | 0 | (all 3 bound above) |
| locks_counters | 2 | Silat locks - Cascadeur |
| movement | 2 | Capoeira movement - Cascadeur |
| entries | 2 | Wrestling entries - Cascadeur |
| pasang_langkah | 1 | Silat movement - Cascadeur |
| catches | 1 | Sanda catch - Cascadeur |
| catches_takedowns | 3 | Sanda/silat catches - Cascadeur |
| combat_linking | 1 | Sambo - Cascadeur |
| empty_hand | 0 | (1 bound above) |
| sweeps_acrobatics | 1 | Capoeira sweep - Cascadeur (au_role is acrobatic, not a backflip) |

### Files changed
- `Godot/scripts/FightClipBinding.gd` - Added 21 entries to STRIKE_FAMILY_BINDINGS

## Gate
Parse gate: 0 fails on 1 touched script.
Focused test: fight_hold_binding_test.gd failures=0.
Coverage tool: BEFORE NONE=66 → AFTER NONE=47.

Co-Authored-By: Qwen <noreply@qwen.ai>
