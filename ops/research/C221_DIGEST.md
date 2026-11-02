# C221 - pass 3: suited human video to bound clips (BLOCKED BEFORE SOLVE)

## Pass 3 studio chain (2026-09-27)

| Studio step | Our equivalent | Cheapest test | Status |
|---|---|---|---|
| 1. Select performer and movement | One generated adult human; a straight-line unarmed strike from pass 2, with explicit lead side and guard recovery | Review existing pass-2 census and choose one complete technique before generation | Pending free gate; no pilot submitted |
| 2. Fit marker suit and label landmarks | C180 distinct flat segment colours with white grid; explicit left/right identity and joint landmarks | Reuse the existing suit legend and closed-guard clip, isolate actor A | Existing source available; broad segment masks are not joint centres |
| 3. Measure performer and calibrate capture volume | Fixed segment lengths, scale, floor plane, rest pose and camera projection recorded with the solve | Check existing footage and tracker output for observable calibration evidence | NOT PROVEN: no measured actor dimensions or calibrated camera matrices |
| 4. Capture synchronized views | Image first, inspect still, then one locked-camera video; any second view must demonstrate consistent geometry | Check existing two panels without assuming generated split-screen is calibrated stereo | NOT PROVEN: generated panels do not supply camera calibration |
| 5. Track and label markers | C180 HSV segment masks, confidence, 2D axes and grid roll; one actor selected | Rerun tracker with the existing legend, report missing segments | Rerun complete: 97 frames x 2 panels; actor A isolated; hand landmarks absent |
| 6. Solve articulated body in 3D | Original fixed-length skeleton fitted to observations in Blender through Higgsfield bl_* MCP; no SMPL/SMPL-X | Fit existing actor-A observations; measure reprojection, depth ambiguity and length consistency; inspect two angles | WEAKEST LINK: no validated 3D solve; MCP currently disconnected |
| 7. Clean solved motion | Resolve gaps explicitly; constrain joint limits and planted contacts; retain observation residuals | Test a short solved interval for foot drift <=0.05 m and no floor penetration | Not reached; authored motion must not be called recovered motion |
| 8. Export and retarget | Export animation and rest reference, then FightClipRetarget on f01 and f10 | Reuse C221 two-rig audition and compare source/target motion | Not reached |
| 9. Physical and visual acceptance | Both rigs: planted drift, skinned foot floor, strike timing and guard recovery; inspect hidden-Godot renders | One pilot only, two rigs, rendered from the game view | Not reached |
| 10. Bind and play in bout | Accepted binding plus technique_roles() routing | Actual bout playback and requested clip/binding/retarget/technique/fight_stage suite | Not reached; no new binding |
| 11. Preserve and deliver | Raw inputs at D:/FightCamp_originals/c221_source; receipts, reviewed previews, digest and Git commits | Verify source hashes, every charged job and delivered commit | Pass-3 spend 0/60 credits; no paid job submitted |

**Weakest link:** recovering a defensible articulated 3D body from uncalibrated broad segment masks. A connected Blender is necessary to exercise the requested implementation route, but connection alone does not solve calibration, hidden joints or depth ambiguity. A planar extrusion or hand-authored pose is not a passing body solve.

The operator's pass-3 instruction supersedes the task file's Kimodo route and 15-credit cap: image-first video, free solve first, then at most one paid pilot, up to 60 credits total. SMPL/SMPL-X remain excluded. Rebase deferred because this worktree contains pre-existing generated/import changes; those files are not owned by this pass. No HANDOFF or status document was opened directly. Generic brief/inbox returned unrelated assignments; only C221 was pursued.

### Free preflight result and exact stop

**STOP: row 6 cannot execute through the requested MCP because Blender is disconnected.** `bl_get_api` returned `Blender is not connected. Open the Higgsfield panel in Blender and press Connect in "Supercomputer Connection".` Two subsequent `get_host_status` calls independently reported Blender not connected. Connection was requested from the operator. No scene was modified, no skeleton was solved, and no two-angle skeleton review exists. This is an execution blocker, not a failed numerical solve and not evidence that the solo route cannot work.

The C180 tracker was rerun unchanged with the existing legend. The six-frame sheet was opened and inspected: the top fighter's cap leaves the frame in several samples and the masks cover broad surfaces, not bony joint centres. Actor A panel 0: cap visible 76/97 frames, each of the other nine coloured segments 97/97, both hands 0/97. Panel 1: left upper arm 0/97, the other nine coloured segments 97/97, both hands 0/97. Visibility is not a joint-accuracy measure. The full tracker result includes both actors; the separate actor-A file excludes actor B for the prospective one-body fit.

Evidence under `previews/c221/pass3/`: `existing_suit_segments.json`, `existing_suit_segments_sheet.png` (viewed), `actor_a_observations.json`, and `free_test_receipt.json` (command, source hashes, per-panel counts, unmet gates). Existing raw footage was read in place; no new raw generation was downloaded. New paid sources remain designated for `D:/FightCamp_originals/c221_source`.

PC watchdog passed with real Windows counters: GREEN, C free 50.8 GB, RAM 78%, CPU 8%, temperature unavailable. The initial sandbox reading was invalid (CIM access denied) and was not used. No `.gd` or runtime source was changed in pass 3, so parse and Godot suite were not rerun for this documentation/observation checkpoint; the prior `fails=1, fight_stage_realism` baseline is retained historical evidence, not a new pass. No Godot render was produced.

**Spend: 0 paid jobs, 0/60 pass-3 credits.** `python -m Tools.higgsfield.budget --estimate 0` was non-spending; its worktree ledger reports 0.70 under grant S72, which is stale relative to the pass-2 shared-ledger reconciliation below and must not be used as current shared account headroom. Reconcile the shared ledger before a future paid pilot. No `bl_generate_*` call was made.

Resume at row 6 after connecting Blender: load the bridge's mandatory Blender skills, fit the actor-A observations using an original articulated model, report calibration assumptions and ambiguity, and inspect two angles. Only a passing free solve unlocks the image-first solo pilot. No move is accepted or newly bound in this pass; all 47 remain unresolved on this branch.

## Pass 2 retained evidence

**0 accepted; all 47 NONE moves remain unbound.** Each has one valid full-prompt Kimodo audition,
measured on both rigs and reviewed in sampled render frames. All fail the physical gate on both rigs.
No move is delivered as playing in a bout. The required coverage reduction is UNMET.
Branch: `codex/c221-none-clips`; branch point: `deb68fe2bccd250550a8aec1e08867b83c2abbf5`.

## Delivery and source choice

Baseline: EXACT 26 + NEAR 132 = **158/534 (29.6%)**, NONE 47, GAP 14, family 315.
Final census confirms these counts unchanged; `docs/previews/c221/coverage_final.txt`.
Claude S114 approved extending `technique_roles()` and other playback lists for accepted ids.
No candidate qualified, so there are no production bindings or playback-list changes and no bout-playback evidence.

Owned-first screening found no identified complete match: RamsterZ inventory contains individual strikes,
dodges and locomotion; CMU catalogue discovery did not identify the exact complete missing sequences
(https://mocap.cs.cmu.edu/search.php). This is not an exhaustive visual audit of all CMU takes.
The existing `combo_jab_cross_hook.glb` is documented with three right-hand peaks and cannot establish
left jab / right cross / left hook. Every canonical candidate therefore used Kimodo `ardy-core`,
single actor, seed 222, with stance, action, side, height and recovery prompts in its receipt.
No clip purchases or two-body generation. Raw sources remain outside Git at
`D:/FightCamp_originals/c221_source/<candidate>/`.

**55 completed jobs, 5.5/15 credits total** (5.4 this continuation plus 0.1 at the checkpoint).
All 55 job ids, completion states and charges reconcile with the shared main-checkout
`Tools/higgsfield/spend.json`; see `docs/previews/c221/reconciliation.json` and `job_ledger.json`.
The 47 canonical mappings exactly match the NONE list below. The other eight are malformed-prompt attempts.

## Prompt defect and corrected auditions

The inherited generator bypassed the installed add-on's `motion.normalize_prompt()`: periods delimit
shots. Original duck-under and seven early Arnis attempts contained internal periods and are INVALID
full-prompt semantic auditions. Their physical measurements remain measurements of those outputs;
do not use their semantic failures as evidence against the intended prompts or the model.
The generator now normalizes each shot and requires one terminal period. Separate corrected receipts
preserve all original jobs. Later action-first requests use explicit timed stages where appropriate.
All 47 canonical requests passed the delimiter check. No further generation is queued.

## Measurements and render review

`c221_audition.gd` uses C207's cskel27 mapping, `build_silhouette_corrections` and `retarget_clip`,
source reference and hip carry. Distinct f01 welter and f10 heavy rig assets have different hashes.
At 30 Hz, wanted planted landmark drift <=0.05 m and minimum skinned foot Y >=0 m, with source contact
samples present. Each contact interval is measured from its initial horizontal landmark position;
foot vertices use all skin influences and inverse binds. Achieved values for every attempt are below.
Fixed body lift is 0.925 m. These are failures of this source/retarget audition pipeline, not proof
that no future retarget correction can work.

Every candidate was rejected before acceptance timing, whole-body floor collision and guard validation.
Those gates are NOT certified. Sampled 2 fps contact sheets were opened for the continuation; the original
checkpoint review is labelled as historical in review notes. Sheets cannot certify fast hand timing.
Source NPZ spot checks show some supposed ground chains remain upright before retargeting; see
`source_spot_checks.json`. All candidates also have full 30 fps MP4s.

Five **UNBOUND** reels cover the 47 canonical moves, ten per reel and seven in the last:
`docs/previews/c221/rejected_auditions_01.mp4` through `rejected_auditions_05.mp4`.
All five decoded without errors. `reels.json` maps reel order to candidates; per-candidate directories
contain MP4, review sheet and numerical samples. These are audition renders, not fight playback.

## Follow-up source / authoring routes

All 47 need another source or correction before binding. Per-move observations are in the table below.
Suggested next work, not completed assets:

- Arnis (16): specialist solo reference or Cascadeur authoring for stick chambers, wrist-led snaps,
  two-weapon coordination and disarm sequences; current gestures do not establish those mechanics.
- BJJ (6) and sambo (1): author actual floor transitions and linked positions; standing gestures cannot
  substitute for ground chains. Validate contacts through every transition.
- Judo (10): author distinct entry, reap/sweep, turn and recovery stages; tomoe additionally needs
  sacrifice-to-ground movement. Generated gestures do not establish the full sequences.
- Muay Thai (4) and karate (1): assemble verified correctly sided strike sources with authored transitions
  and recovery, then measure peaks against bout timing; current sequences fail physical acceptance.
- Capoeira (3): obtain genuine floor/inversion motion and validate hand as well as foot support.
- Wrestling (2), silat (3) and sanda (1): specialist solo entries/locks/catch-dump reference or authoring,
  with visible go-behind/level changes and guard recovery; generic arm gestures are insufficient.

## Checks and scope

- Final watchdog GREEN: C: 50.8 GB free, RAM 75%, CPU 3%.
- Parse: `CHECK total=2 fails=0 autoload_refs=0 autoload_warnings=0`.
- Final required focused gate: **`SUITE total=38 fails=1`**, matching the checkpoint baseline.
  The sole failure is `fight_stage_realism_test.gd`, with the same R1/R2/R3/R4/R5/R5b/R7/R8 failures.
  See `focused_gate.txt` and `realism_gate.txt`; production binding/gameplay scripts are unchanged.
- Final census: EXACT 26, NEAR 132, family 315, GAP 14, NONE 47; 158/534 (29.6%).
  No script errors in the final census. Coverage acceptance remains UNMET.
- Serial `--jobs 1`, idle priority; hidden Godot render wrapper. No full suite.
- Census tool supports sorted `-- --list none|gap`; checkpoint invalid/missing argument checks exit 2.
- Kept assigned dirty worktree without rebasing unrelated import sidecars. Fetch succeeded.
  Generic brief/inbox intake was set aside on continuation because explicit assignment controls and
  it can include prohibited status content. No HANDOFF, CURRENT_STATUS or archive read on continuation.
- Only explicit C221 paths staged; generated unrelated import sidecars and frame PNGs left unstaged.
  C221 remains INCOMPLETE; Claude owns integration. No HANDOFF edit or task-complete message.

## Baseline NONE list

| Technique id | Branch | Discipline |
| --- | --- | --- |
| arnis_abanico | single_stick | arnis |
| arnis_backhand | single_stick | arnis |
| arnis_block_counter | defense_counters | arnis |
| arnis_disarm | disarms | arnis |
| arnis_disarm_chain | disarms | arnis |
| arnis_empty_hand_trap | empty_hand | arnis |
| arnis_forehand | single_stick | arnis |
| arnis_gunting_limb | defense_counters | arnis |
| arnis_punyo | defense_counters | arnis |
| arnis_redonda | double_weapon | arnis |
| arnis_roof_block | defense_counters | arnis |
| arnis_sinawali | double_weapon | arnis |
| arnis_thrust | single_stick | arnis |
| arnis_thrust_disarm | disarms | arnis |
| arnis_weapon_flow_chain | double_weapon | arnis |
| arnis_witik_snap | defense_counters | arnis |
| bjj_back_take_rnc | combinations | brazilian_jiu_jitsu |
| bjj_chain_guillotine_mount | combinations | brazilian_jiu_jitsu |
| bjj_chain_kimura_sweep_back | combinations | brazilian_jiu_jitsu |
| bjj_darce_chain | combinations | brazilian_jiu_jitsu |
| bjj_kimura_chain | combinations | brazilian_jiu_jitsu |
| bjj_submission_chain | combinations | brazilian_jiu_jitsu |
| capoeira_au_role | sweeps_acrobatics | capoeira |
| capoeira_esquiva | movement | capoeira |
| capoeira_flow_chain | movement | capoeira |
| judo_renraku_deashi_osoto | combinations | judo |
| judo_renraku_harai_osoto | combinations | judo |
| judo_renraku_kouchi_seoi | combinations | judo |
| judo_renraku_osoto_ouchi | combinations | judo |
| judo_renraku_ouchi_osoto | combinations | judo |
| judo_renraku_sasae_taiotoshi | combinations | judo |
| judo_renraku_seoi_kouchi | combinations | judo |
| judo_renraku_uchimata_ouchi | combinations | judo |
| judo_renzoku_osoto | combinations | judo |
| judo_tomoe_chain | combinations | judo |
| karate_kizami_maegeri | combinations | karate |
| muay_thai_jab_cross_hook | combinations | muay_thai |
| muay_thai_teep_knee_chain | combinations | muay_thai |
| muay_thai_thip_clinch_knee | combinations | muay_thai |
| muay_thai_thip_mat_te_combo | combinations | muay_thai |
| sambo_throw_leglock | combat_linking | sambo |
| sanda_catch_dump | catches | sanda |
| silat_complete_response | pasang_langkah | pencak_silat |
| silat_kuncian_lock | locks_counters | pencak_silat |
| silat_total_response_chain | locks_counters | pencak_silat |
| wrestling_duck_under | entries | wrestling |
| wrestling_snapdown | entries | wrestling |

## Baseline GAP list

| Technique id | Branch | Discipline |
| --- | --- | --- |
| bjj_arm_drag | takedowns | brazilian_jiu_jitsu |
| bjj_guard_pull | takedowns | brazilian_jiu_jitsu |
| mma_sprawl_fronthead | scrambles_finishes | mma |
| mma_sprawl_to_back | scrambles_finishes | mma |
| mma_wall_walk | cage_work | mma |
| muay_thai_clinch_dump | clinch | muay_thai |
| muay_thai_dumps_offbalance | clinch | muay_thai |
| sambo_arm_drag_bodylock | grips_throws | sambo |
| sanda_full_chain | throws | sanda |
| silat_catch_dump | catches_takedowns | pencak_silat |
| silat_catch_kick_takedown | catches_takedowns | pencak_silat |
| silat_offbalance_chain | catches_takedowns | pencak_silat |
| wrestling_chain_wrestle | takedowns | wrestling |
| wrestling_mat_return | takedowns | wrestling |

## Continuation measured attempts

Booked task credits including original checkpoint and invalid auditions: **5.5/15** across 55 receipts.
Every job is also booked in the shared `Tools.higgsfield.budget` ledger. Exact submitted prompts, seeds, job ids,
reservations and actual cost are in `docs/previews/c221/job_ledger.json` and per-take receipt files.
Source: Kimodo ardy-core for each row; no identified complete owned clip was substituted.
Numbers are f01 / f10. Wanted planted drift <=0.050000 m and foot surface minimum Y >=0.000000 m.
These are unbound candidate auditions, not bout-playback evidence. Timing and full-body floor/guard validation
remain required before any physical-pass candidate can be accepted. MP4 and sheet are in each named candidate directory.

| Candidate | Drift m, f01 / f10 | Min foot Y m, f01 / f10 | Result | Visual review / limitation |
| --- | ---: | ---: | --- | --- |
| arnis_abanico | 0.101831 / 0.150363 | -0.021413 / -0.021949 | REJECT physical | Reviewed 2 fps sheet on both rigs; malformed prompt. Generic compact arm motion, wrist-fanning identity unproven. Both physical gates fail. |
| arnis_abanico_normalized | 0.163426 / 0.165272 | -0.019972 / -0.013789 | REJECT physical | Sampled frames show a broad torso turn and arm extension, not a clear wrist-led fan; arms drop on recovery. Both rigs fail physical gate. |
| arnis_backhand | 0.100615 / 0.143425 | -0.029892 / -0.020827 | REJECT physical | Reviewed 2 fps sheet on both rigs. Outward arm sweep visible; exact low-right finish and left-shoulder chamber not established. Physical failure on both rigs. |
| arnis_backhand_normalized | 0.077634 / 0.117025 | -0.049247 / -0.039280 | REJECT physical | Reviewed 2 fps sheet on both rigs after normalization. Deep forward lunge with hand gesture; high-left to low-right backhand arc not established. Both physical gates fail. |
| arnis_block_counter | 0.096852 / 0.132764 | -0.025301 / -0.020390 | REJECT physical | Reviewed 2 fps sheet on both rigs. Required roof-block then backhand then forehand sequence not established in sampled frames; brief generic arm action. Both physical gates fail. |
| arnis_block_counter_normalized | 0.217873 / 0.218920 | -0.016490 / -0.014983 | REJECT physical | Sampled frames show a small raised-hand gesture followed by arms-down recovery; block then distinct counter sequence is not established. Both rigs fail physical gate. |
| arnis_disarm | 0.035773 / 0.067166 | -0.007996 / -0.001458 | REJECT physical | Reviewed 2 fps sheet on both rigs. Two-hand circular gesture visible but imaginary wrist leverage/control not clear; no acceptance. Both physical gates fail. |
| arnis_disarm_chain | 0.491560 / 0.489885 | -0.020592 / -0.016065 | REJECT physical | Reviewed 2 fps sheet on both rigs. Overhead arm gesture followed by arms-down walking; full block-counter-disarm chain and guard recovery absent. Both physical gates fail. |
| arnis_empty_hand_trap | 0.092657 / 0.132462 | -0.024742 / -0.021112 | REJECT physical | Reviewed 2 fps sheet on both rigs. Hands rise together; wrist pin across opposite forearm not demonstrated. Physical failure on both rigs. |
| arnis_forehand | 0.061843 / 0.102407 | -0.039402 / -0.031018 | REJECT physical | Reviewed 2 fps sheet on both rigs. Short forward lunge with arm across centerline; diagonal high-to-low stick follow-through not demonstrated in sampled frames. Physical failure on both rigs. |
| arnis_forehand_normalized | 0.068719 / 0.084876 | -0.021665 / -0.007939 | REJECT physical | Reviewed 2 fps sheet on both rigs after normalization. Compact overhead/diagonal hand gesture, full high-right to low-left stick arc not established. Both physical gates fail: 0.069/0.085 m drift. |
| arnis_gunting_limb | 0.175741 / 0.175049 | -0.016363 / -0.014783 | REJECT physical | Reviewed 2 fps sheet on both rigs. Overhead arm action instead of chest-height scissor interception; ends with arms down. Both physical gates fail. |
| arnis_punyo | 0.055899 / 0.070476 | -0.021872 / -0.005836 | REJECT physical | Reviewed 2 fps sheet on both rigs. High guard and overhead arm gesture, no clear short chest-level butt-end strike. Physical failure on both rigs. |
| arnis_redonda | 0.089370 / 0.110631 | -0.019414 / -0.010285 | REJECT physical | Reviewed 2 fps sheet on both rigs. Alternating high arm circles visible, then arms drop at recovery; requested continuous circular pattern not established. Both physical gates fail. |
| arnis_roof_block | 0.077531 / 0.081123 | -0.021596 / -0.022362 | REJECT physical | Reviewed 2 fps sheet on both rigs. Overhead lift visible, but returns to extended-arm pose instead of requested guard; no sustained roof shape established. Both physical gates fail. |
| arnis_roof_block_normalized | 0.067191 / 0.085785 | -0.008224 / 0.000765 | REJECT physical | Sampled frames show a brief overhead hand lift, not an established sloping roof block; recovery drops the guard. Both rigs fail physical gate. |
| arnis_sinawali | 0.212321 / 0.216942 | -0.033105 / -0.020380 | REJECT physical | Reviewed 2 fps sheet on both rigs. Alternating arm sequence now visible with action-first prompt, but six-count chambers not established and recovery drops both arms. Both physical gates fail. |
| arnis_thrust | 0.075346 / 0.103054 | -0.019431 / -0.019481 | REJECT physical | Reviewed 3 fps sheet. High boxing guard and straight punch; no convincing stick-thrust chamber. Physical failure on both rigs. |
| arnis_thrust_disarm | 0.089910 / 0.096142 | -0.015562 / -0.013515 | REJECT physical | Reviewed 2 fps sheet on both rigs. Short thrust and two-hand motion visible, then orientation/guard changes; disarm lever not established. Both physical gates fail. |
| arnis_thrust_normalized | 0.075015 / 0.095750 | -0.017803 / -0.017406 | REJECT physical | Reviewed 2 fps sheet on both rigs after required prompt normalization. Forward straight punch visible; no convincing stick chamber. Physical failure on both rigs. |
| arnis_weapon_flow_chain | 0.325024 / 0.335743 | -0.025348 / -0.020904 | REJECT physical | Reviewed 2 fps sheet on both rigs. Several high arm sweeps visible, followed by arms-down steps; required forehand/backhand/redonda chain not established and guard not recovered. Both physical gates fail. |
| arnis_witik_snap | 0.094926 / 0.144629 | -0.021998 / -0.022039 | REJECT physical | Reviewed 2 fps sheet on both rigs; malformed prompt. Compact forward hand action, wrist snap unproven. Both physical gates fail. |
| arnis_witik_snap_normalized | 0.110976 / 0.108974 | -0.017389 / -0.015580 | REJECT physical | Sampled frames show a high two-hand gesture, not a clearly resolved one-hand snap and recoil; arms drop on recovery. Both rigs fail physical gate. |
| bjj_back_take_rnc | 0.182829 / 0.180453 | -0.050375 / -0.041102 | REJECT physical | Reviewed 2 fps sheet on both rigs. Upright walking and arm movement; no kneeling leg drag, seated hooks or rear-naked-choke shape. Different source/Cascadeur needed. Both physical gates fail. |
| bjj_chain_guillotine_mount | 0.136331 / 0.146972 | -0.034373 / -0.042930 | REJECT physical | Reviewed 2 fps sheet on both rigs. Raised arm then crouch/kneel and rise; guillotine clasp and mounted finish absent. Both physical gates fail. |
| bjj_chain_kimura_sweep_back | 0.276672 / 0.260429 | -0.016532 / -0.017688 | REJECT physical | Reviewed 2 fps sheet on both rigs. Static crouch with crossed arms, then rise; no kimura-driven bridge/sweep or seated back hooks. Both physical gates fail. |
| bjj_darce_chain | 0.141665 / 0.146544 | -0.016223 / -0.009737 | REJECT physical | Reviewed 2 fps sheet on both rigs. Upright arm gestures throughout, no kneeling DArce/anaconda clasp or shoulder roll. Both physical gates fail. |
| bjj_kimura_chain | 0.209456 / 0.217171 | -0.005925 / -0.004638 | REJECT physical | Reviewed 2 fps sheet on both rigs. Chair-like squat/hover and rise; no scissor sweep or armbar leg-over-head position. Both physical gates fail. |
| bjj_submission_chain | 0.267426 / 0.270282 | -0.018177 / -0.014727 | REJECT physical | Reviewed 2 fps sheet on both rigs. Remains standing; no supine armbar, triangle or omoplata. Raw source hips remain 0.833-0.944 m high, before retargeting. Both physical gates fail. |
| capoeira_au_role | 0.442570 / 0.470978 | -0.031056 / -0.043728 | REJECT physical | Reviewed 2 fps sheet on both rigs. Arms-up turn and leg sweep, no demonstrated inverted cartwheel or low hand-supported role; ends arms down. Both physical gates fail. |
| capoeira_esquiva | 0.119711 / 0.130733 | -0.023562 / -0.010701 | REJECT physical | Reviewed 2 fps sheet on both rigs. Forward crouch with both hands near head; requested lateral lean, extended right leg and left-hand floor support absent. Physical failure on both rigs. Raw NPZ contains the submitted text and differing joint motion, so source files are distinct. |
| capoeira_flow_chain | 0.356686 / 0.358360 | -0.027531 / -0.030486 | REJECT physical | Reviewed 2 fps sheet on both rigs. Upright knee lifts and hand gestures; low rasteira and hand-supported meia-lua are absent from sampled poses. Both physical gates fail. |
| judo_renraku_deashi_osoto | 0.361296 / 0.357520 | -0.015746 / -0.020435 | REJECT physical | Reviewed 2 fps sheet on both rigs. Arms extended sideways with torso bow, no clear low foot sweep followed by outside reap; arms-down recovery. Both physical gates fail. |
| judo_renraku_harai_osoto | 0.589070 / 0.602033 | -0.019504 / -0.016796 | REJECT physical | Reviewed 2 fps sheet on both rigs. Narrow stance and crossing steps with hands at hips; no hip-sweep entry followed by outside reap. Both physical gates fail. |
| judo_renraku_kouchi_seoi | 0.571134 / 0.575116 | -0.073764 / -0.073733 | REJECT physical | Reviewed 2 fps sheet on both rigs. Step and kneeling descent, no clear inside reap then shoulder-turn throw entry. Both physical gates fail; drift about 0.57 m and foot penetration about 0.074 m. |
| judo_renraku_osoto_ouchi | 0.083485 / 0.121492 | -0.031935 / -0.020039 | REJECT physical | Reviewed 2 fps sheet on both rigs. Straight hand strike from high guard; neither outside nor inside reap demonstrated. Both physical gates fail. |
| judo_renraku_ouchi_osoto | 0.143215 / 0.195929 | -0.036878 / -0.026360 | REJECT physical | Reviewed 2 fps sheet on both rigs. Forward straight hand strike; inside-to-outside reaping sequence absent. Both physical gates fail. |
| judo_renraku_sasae_taiotoshi | 0.167865 / 0.201565 | -0.029979 / -0.027032 | REJECT physical | Reviewed 2 fps sheet on both rigs. High-guard forward hand gesture; ankle block, turning extended-leg body drop and grip pull absent. Both physical gates fail. |
| judo_renraku_seoi_kouchi | 0.094775 / 0.142671 | -0.019571 / -0.019460 | REJECT physical | Reviewed 2 fps sheet on both rigs. High-guard hand gesture, no shoulder-turn entry or small inside reap demonstrated. Both physical gates fail. |
| judo_renraku_uchimata_ouchi | 0.594557 / 0.590703 | -0.023903 / -0.018256 | REJECT physical | Reviewed 2 fps sheet on both rigs. One-leg balance with arms out, then walking; inner-thigh throw and inside reap not demonstrated. Both physical gates fail. |
| judo_renzoku_osoto | 0.405058 / 0.402507 | -0.014123 / -0.012757 | REJECT physical | Reviewed 2 fps sheet on both rigs. High hand gesture and eventual arms-down stance; repeated outside reaps absent. Both physical gates fail. |
| judo_tomoe_chain | 0.117744 / 0.130617 | -0.023333 / -0.022466 | REJECT physical | Reviewed 2 fps sheet on both rigs. Stays upright with hand gestures; no backward sacrifice throw or ground armbar transition. Both physical gates fail. |
| karate_kizami_maegeri | 0.325314 / 0.333373 | -0.021780 / -0.013868 | REJECT physical | Reviewed 2 fps sheet on both rigs. Short hand gesture followed by walking with arms down; lead front snap kick not established. Both physical gates fail. |
| muay_thai_jab_cross_hook | 0.292021 / 0.290075 | -0.028025 / -0.019686 | REJECT physical | Reviewed 2 fps sheet on both rigs. One extended straight punch prominent; complete left-jab/right-cross/left-hook not demonstrated in sampled frames, ends arms down. Physical drift about 0.29 m on each rig. |
| muay_thai_teep_knee_chain | 0.420064 / 0.414107 | -0.032086 / -0.021805 | REJECT physical | Reviewed 2 fps sheet on both rigs. Brief raised knee/foot motion, but separate extended teep then opposite knee not established. Both physical gates fail. |
| muay_thai_thip_clinch_knee | 0.473072 / 0.468810 | -0.035726 / -0.021452 | REJECT physical | Reviewed 2 fps sheet on both rigs. Raised knee and hands near own head; distinct teep, forward collar-tie entry and opposite knee not established. Both physical gates fail. |
| muay_thai_thip_mat_te_combo | 0.319702 / 0.343708 | -0.018626 / -0.021115 | REJECT physical | Reviewed 2 fps sheet on both rigs. Knee lift, brief leg action and later hand action visible, but teep-cross-roundhouse order not established. Both physical gates fail; drift 0.32/0.34 m. |
| sambo_throw_leglock | 0.406179 / 0.414159 | -0.052782 / -0.034557 | REJECT physical | Reviewed 2 fps sheet on both rigs. Upper-body gesture, kneeling descent and rise; no hip throw-to-seated ankle-lock sequence demonstrated. Both physical gates fail. |
| sanda_catch_dump | 0.312179 / 0.330814 | -0.022283 / -0.021747 | REJECT physical | Reviewed 2 fps sheet on both rigs. Knee lift and high hand gestures; waist-height kick catch, lifting turn and dump not demonstrated. Both physical gates fail. |
| silat_complete_response | 0.534782 / 0.541150 | -0.039160 / -0.034157 | REJECT physical | Reviewed 2 fps sheet on both rigs. Brief high hand motion followed by arms-down stance; parry-side-kick-elbow-scissor sequence absent. Both physical gates fail. |
| silat_kuncian_lock | 0.105942 / 0.108632 | -0.018281 / -0.019153 | REJECT physical | Reviewed 2 fps sheet on both rigs. High guard and outward hand action, no two-hand wrist/elbow lock lever. Both physical gates fail. |
| silat_total_response_chain | 0.074464 / 0.122412 | -0.028670 / -0.034696 | REJECT physical | Reviewed 2 fps sheet on both rigs. Brief high hand action and guard; parry-elbow-lock chain not demonstrated. Both physical gates fail. |
| wrestling_duck_under | 0.282424 / 0.293225 | -0.021648 / -0.028056 | REJECT physical | Original checkpoint: sample sheet and two full-size frames reviewed then; deep squat, crossed arms, insufficient go-behind and arms-down recovery. Inherited multi-period prompt later identified as invalid shot formatting. Both physical gates fail. |
| wrestling_duck_under_retry | 0.635893 / 0.640719 | -0.032957 / -0.030315 | REJECT physical | Reviewed 2 fps sheet on both rigs. Arm gesture, crossing steps and then deep squat; go-behind pivot and return to low wrestling guard absent. Both physical gates fail, drift about 0.64 m. |
| wrestling_snapdown | 0.304083 / 0.308739 | -0.028442 / -0.028449 | REJECT physical | Reviewed 2 fps sheet on both rigs. Hands rise overhead and then drop; snapdown into front headlock clasp not demonstrated. Both physical gates fail. |
