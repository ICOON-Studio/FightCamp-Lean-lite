# SWITCHALL1 inventory

`GAME_ON` is the single shipped-on registry in `Godot/scripts/GameSwitches.gd`. `FightRealtime.DEMO_SWITCHES` is its engine-only projection. A `--script` process remains the OFF control arm unless the caller supplies that key or `as_game`.

| Switch | Source | Effect | Game before -> after | Pin |
|---|---|---|---|---|
| ground_arm | FightRealtime.gd:1194 | Enables the complete ground graph/decay arm. | both -> both | s58_ground_arms_test |
| trap_arm | FightRealtime.gd:1309 | Adds trap edges to ground choices. | OFF -> ON | switch_gate_test / grapple tests |
| defence_model | FightRealtime.gd:1332 | Selects the J50 read/defence model. | OFF -> ON | fight_realtime_test |
| feint | FightRealtime.gd:1820 | Enables feints. | ON -> ON | fight_realtime_test |
| boxing_output | FightRealtime.gd:1334 | Applies the boxing output mix. | OFF -> ON | fight_realtime_test |
| footwork_no_contact | FightRealtime.gd:1339 | Makes movement-only footwork non-contact. | OFF -> ON | fight_realtime_test |
| certified_palette | FightRealtime.gd:1725 | Restricts selection to certified moves. | ON -> ON | certified_palette tests |
| reach_edge | FightRealtime.gd:1340 | Enables the edge-of-range lead. | ON -> ON | reach_edge tests |
| in_round_recovery | FightRealtime.gd:1336 | Restores wind/body during a round. | OFF -> ON | recovery tests |
| angle_guard | FightRealtime.gd:1338 | Applies attack-angle guard coverage. | ON -> ON | angle_guard_test |
| identity_in_fight | FightRealtime.gd:1687 | Applies fighter identity to fight decisions. | ON -> ON | identity tests |
| boxing_clinch | FightRealtime.gd:1716 | Enables boxing clinch behavior. | ON -> ON | clinch tests |
| speed_in_decision | FightRealtime.gd:1700 | Applies speed to decision selection. | ON -> ON | decision tests |
| training_strands | FightRealtime.gd:1703 | Uses trained technique strands. | ON -> ON | training tests |
| technique_effects | FightRealtime.gd:1709 | Applies technique-specific effects. | ON -> ON | technique tests |
| cut_off_derived | FightRealtime.gd:1280 | Uses the derived lead for cut-off movement. | ON -> ON | measure_ring_position / fight_ring_position |
| camp_live | FightRealtime.gd:1893 | Carries fight-camp effects into the bout. | ON -> ON | camp_reaches_bout_test |
| pad_chains | FightRealtime.gd:1752 | Adds authored pad-chain choices. | ON -> ON | pad_chain tests |
| ludo_doctor | FightRealtime.gd:1666 | Enables the doctor decision path. | ON -> ON | doctor tests |
| ludo_composure | FightRealtime.gd:1731 | Applies live composure behavior. | ON -> ON | composure tests |
| ludo_cardauto | FightRealtime.gd:1733 | Enables boxing card auto-fire. | OFF -> ON | card-auto tests |
| ludo_shouts | FightRealtime.gd:1745 | Emits corner/apron shouts. | OFF -> ON | shout tests |
| ludo_referee | FightRealtime.gd:1895 | Enables referee intervention logic. | OFF -> ON | referee tests |
| corner_wired | FightRealtime.gd:1808 | Wires corner instructions into the bout. | OFF -> ON | corner tests |
| limb_damage | FightRealtime.gd:1810 | Applies limb damage outcomes. | OFF -> ON | limb damage tests |
| separation_strip_velocity | FightRealtime.gd:1360 | Removes inward velocity at the separation floor. | OFF -> ON | fight_separation_test |
| anim_scurve | FightStagePlayer.gd:14 | Shapes the punch animation curve. | OFF -> ON | fight_stage_scurve_switch_test |
| anim_fatigue | FightStagePlayer.gd:21 | Shows fatigue posture in stage animation. | OFF -> ON | fight_stage_fatigue_switch_test |
| anim_glove_spring | FightStagePlayer.gd:22 | Adds glove spring motion. | OFF -> ON | fight_stage_fatigue_switch_test |
| anim_inside_uppercut_ik | FightStagePlayer.gd:23 | Applies the inside-uppercut IK layer. | OFF -> ON | inside_uppercut_ik_switch_test |
| alive_breath | FightStagePlayer.gd:8 | Adds alive breathing motion. | OFF -> ON | alive stance tests |
| alive_events | FightStagePlayer.gd:9 | Adds event-driven alive motion. | OFF -> ON | alive stance tests |
| human_hit_additive | FightStagePlayer.gd:11 | Adds human-hit response motion. | OFF -> ON | fight world animation tests |
| human_flinch | FightStagePlayer.gd:42 | Adds human flinch response motion. | OFF -> ON | fight world animation tests |
| strikes_play_whole | FightStagePlayer.gd:367 | Keeps full strike clips in playback. | ON in game -> ON | fight_world_anim_test |
| reactions_play_whole | FightStagePlayer.gd:331 | Keeps full reaction clips in playback. | ON in game -> ON | fight_world_anim_test |
| strike_speed_caps | FightStagePlayer.gd:333 | Caps human strike clip speed. | OFF -> ON | fight_world_anim_test |
| human_speed_tempo | FightStagePlayer.gd:335 | Applies tempo correction to vendor clips. | OFF -> ON | fight_world_anim_test |
| skip_hand_continuity_while_stepping | FightStagePlayer.gd:340 | Skips continuity correction during a step. | OFF -> ON | fight_world_anim_test |
| metahuman_bodies | FightWorldStage.gd:27 | Selects the MetaHuman fighter body set. | OFF -> ON | fight_world_mount_test |
| metahuman_staff | FightWorldStage.gd:34 | Selects clothed MetaHuman staff models. | OFF -> ON | gym/staff room tests |
| broadcast_autocut | FightWorldLiveScreen.gd:876 | Selects broadcast camera cuts automatically. | OFF -> ON | broadcast_autocut_test |
| gym_look2 | GymLook2.gd:13 | Applies the new gym shell and dressing. | OFF -> ON | gym_look2_shell_test / gym_look2_props_test |
| gym_pack | GymPack.gd:44 | Uses the unified gym asset pack. | ON -> ON | gym_pack tests |
| club_zones | GymClub3D.gd:1636 | Replaces station props with zone-kit models. | OFF -> ON | club_zones_test |
| hud2 | GameState.gd:17899 | Applies the no-top-bar gym HUD. | OFF -> ON | hud2_pieces_test |
| career_wear | GameState.gd:17407 | Accumulates and displays career wear. | OFF -> ON | career_wear_state_test / profile_wear_meter_test |
| human_footwork | FightWorldLiveScreen.gd:858 | Applies human-controlled footwork presentation. | OFF -> ON | fight_world_anim_test |
| venue_art | FightWorldLiveScreen.gd:999 | Marks the venue-art presentation path. | OFF -> ON | fight_world_live_test |
| hit_physics | FightWorldLiveScreen.gd:1059 | Enables hit-driven body physics. | OFF -> ON | fight_world_anim_test |
| body_spacing | FightWorldLiveScreen.gd:859 | Adds body-spacing presentation. | OFF -> ON | fight_world_pair_test |
| inertial_joins | FightWorldLiveScreen.gd:860 | Smooths stage joins with inertia. | OFF -> ON | fight_world_anim_test |
| foot_pivot | FightWorldLiveScreen.gd:834 | Holds the planted foot through turns. | OFF -> ON | fight_world_anim_test |
| active_ragdoll | FightWorldLiveScreen.gd:272 | Enables active-ragdoll stage response. | ON -> ON | fight_world_live_test |
| ludo_hud | FightWorldLiveScreen.gd:302 | Uses the Ludo fight HUD. | ON -> ON | ludo_fight_hud_test |
| read_round | FightWorldLiveScreen.gd:308 | Shows the round telemetry panel. | ON -> ON | fight_hud_read_test |
| camera_keep_pair | FightWorldLiveScreen.gd:467 | Keeps both fighters framed together. | ON -> ON | fight_world_pair_test |
| contact_stop | FightWorldLiveScreen.gd:721 | Stops the receiving body at contact. | ON -> ON | fight_world_live_test |
| stance_offset | FightWorldLiveScreen.gd:737 | Offsets stance presentation by fighter. | ON -> ON | fight_world_anim_test |
| face_drawn_foe | FightWorldLiveScreen.gd:749 | Faces the drawn opponent during clips. | ON -> ON | fight_world_anim_test |
| hold_pair_geometry | FightWorldLiveScreen.gd:757 | Preserves pair geometry through holds. | ON -> ON | fight_world_pair_test |
| reface_in_takes | FightWorldLiveScreen.gd:766 | Refacing in authored takes. | ON -> ON | fight_world_anim_test |
| warp_on_line | FightWorldLiveScreen.gd:776 | Warps the root to align contact. | ON -> ON | switch_gate_warp_on_line_test |
| sequence_steps | FightWorldLiveScreen.gd:781 | Plays linked sequence steps. | ON -> ON | switch_gate_sequence_steps_test |
| contact_push_on_line | FightWorldLiveScreen.gd:790 | Applies the contact push along the approach line. | ON -> ON | switch_gate_contact_push_on_line_test |
| contact_push_carry | FightWorldLiveScreen.gd:798 | Carries contact push through the clip. | ON -> ON | switch_gate_contact_push_carry_test |
| root_accel_cap | FightWorldLiveScreen.gd:805 | Caps root acceleration. | ON -> ON | switch_gate_root_accel_cap_test |
| hand_contact_sync | FightWorldLiveScreen.gd:814 | Synchronizes hand contact with the beat. | ON -> ON | switch_gate_hand_contact_sync_test |
| glove_contact | FightWorldLiveScreen.gd:821 | Enables glove-to-body contact response. | ON -> ON | fight_world_anim_test |
| venue_halls | FightWorldLiveScreen.gd:829 | Uses venue hall dressing in presentation. | ON -> ON | fight_world_live_test |
| shuffle_from_bell | FightWorldLiveScreen.gd:840 | Enables shuffle from the bell. | ON -> ON | switch_gate_shuffle_from_bell_test |
| hands_smooth_in_whole | FightWorldLiveScreen.gd:843 | Smooths hand motion during full takes. | ON -> ON | switch_gate_hands_smooth_in_whole_test |
| alive_stance | FightWorldLiveScreen.gd:852 | Enables alive stance presentation. | ON -> ON | fight_world_anim_test |
| cam_spring | FightWorldLiveScreen.gd:861 | Smooths the camera with a spring. | ON -> ON | fight_world_live_test |
| fight_vfx | FightWorldLiveScreen.gd:874 | Shows fight VFX feedback. | ON -> ON | fight_world_live_test |
| open_spar_night | GameState.gd:6180 | Books the weekly open spar night when the floor qualifies. | OFF -> ON | floor events tests |

## Left OFF

| Switch | Reason |
|---|---|
| `fighter_skin=generator` (MPFB body selection) | Kept out of automatic game startup per S207; the default now stays on the normal Tripo body. A deliberately supplied skin arg remains a diagnostic override. |
| `bench1` | S208 Claude review: a SCRIPTED 30 s benchmark timeline (forced stamina 95/28, fixed action list, bench1_timeline.json) - an instrument; ON in the game it scripted every fight and broke switch_gate_hold_pair_geometry (hold error p90 0.32 -> 2.31 m). |
| `readable_onset`, `capsule_overlay`, `debug_overlay` | Debug/readability overlays; they expose stage instrumentation and remain off for the player. |
| Tool-only overlays, probes, recorders, and census switches under `Godot/tools/` | Development instrumentation, excluded from the player build. |

## S208 Claude review
- bench1 moved to Left OFF (above).
- LudoShoutBar built lazily: with ludo_shouts ON the live screen fed the bar before it entered the tree -> SCRIPT ERROR every frame (7 switch_gate tests).
- Pre-existing reds, not from this flip: switch_gate_contact_push_carry (nightly 10-11), switch_gate_hands_smooth_in_whole (red with the old switch set too).
