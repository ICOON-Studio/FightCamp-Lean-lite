#!/bin/bash
# S381 OWNED MOCAP: the takes baked onto our boxer (tools/owned_mocap_bake.gd). Sources stay OUTSIDE the repo:
#   X  = the Rokoko free combat pack (Downloads/Combat.zip) and the Ailive Fab pack (Downloads/boxing.zip), extracted
#   CJ = CMU trials converted by tools/cmu_amc_source.py (python -I tools/cmu_amc_source.py <s>.asf <t>.amc cmu_<t>.json)
#   run from the repo root: bash tools/owned_mocap_takes.sh <X dir> <CJ dir> <Downloads dir>
#   bars after a bake: <godot> --headless --path . --script res://tools/owned_mocap_measure.gd -- res=<a.res,...>
#   S383: CMU hands + toes are held at the reference pose (bake hold=, default for json), plants pinned by leg IK.
X=$1; CJ=$2; DL=$3
G="${GODOT_EXE:-$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe}"
b(){ "$G" --headless --audio-driver Dummy --path . --script res://tools/owned_mocap_bake.gd -- "$@" dir=res://assets/anim/baked/owned 2>&1 | grep -E "^OWNEDMOCAP [a-z]|FAILED|SCRIPT ERROR" | sed 's/ -> res.*//'; }
# DROPPED S383 on the bars AND the independent eyes check: Rokoko FightingIdle (52 s) - the guard is down 7.9 s at a
#   stretch (35 % of the take): a rest between rounds, hands at the hips, legs straight, no bounce. Not baked.
b fbx in=$X/Combat/Combat/ShadowBoxing_mixamo.fbx out=rk_shadowboxing_a t1=11.9      # S274: 11.93-17.13 crouches + turns 70 deg
b fbx in=$X/Combat/Combat/ShadowBoxing_mixamo.fbx out=rk_shadowboxing_b t0=17.2 t1=23.0  # eyes S381: 23.4 a knee strike, 28+ walks off
b fbx in=$X/Combat/Combat/Boxing_mixamo.fbx out=rk_boxing t1=15.5                             # eyes S381: 16+ the guard drops (take ends)
# DROPPED on eyes S381 (see ops/research/OWNED_MOCAP_S381.md): Mixamo "Offensive Idle" (hands at the hips, a warm-up),
# Ailive Boxing_Footwork (stance ~1 m wide, rear hand at the hip), Ailive Dudging_with_a_Sway (a 2 s lunge, hands low).
for t in 14_01 14_02 13_17 13_18; do b json in=$CJ/cmu_$t.json out=cmu_$t; done
# DROPPED S383 on the independent eyes check (not baked any more; .res removed, see ops/research/OWNED_MOCAP_S381.md):
#   cmu_14_03 - rear hand dropped to the hip every ~9 s (11.7, 20.3, 29.5, 39.1), feet together standing tall at 21.3,
#     37.1-38.5. Salvage later only as a cut: t1=2.5 or t0=12 t1=19.
#   cmu_15_13 - rear hand cocked behind the hip before nearly every cross (telegraphed), arms flung out in a T at take
#     37.3-37.6 s, lead glove over the head at 8.3-8.5. Salvage later only as a cut: t0=16.9 t1=35.3.
#   cmu_17_10 - 17.4-18.4 s a flail (rear foot kicked up, glove overhead, forearm across the chest), 12.0 a near-kneel
#     lunge, 22.2-23.0 feet together. Salvage later only as a cut: t1=17.3 (re-check the 12.0 lunge, 16.4/16.9 bounces).
# DROPPED on eyes S381: CMU 15_05 guard window 145.7-190.4 (feet together, hunched, elbows flare) - and 15_04 (same actor) not baked.
