# C172 - the four missed holds and clinch contact

Task-specific read boundaries and standing loop supersede general startup,
fetch/rebase, brief/inbox, HANDOFF and one-task-stage stopping rules.
No fetch/rebase or other agent's digest reads. Only PAIRED_STRIKE_BINDINGS
may change in FightClipBinding.gd. Claude's work is excluded from staging.

## 1. Closed guard - bjj_guard - pre-authoring diagnosis

_Att is the bottom player, owning the enclosing legs. Existing declared
contacts remain ankle-to-ankle on A, both knee-to-B-hip wraps and both
A-hand-to-B-neck frames; no threshold changes.

C171 tried a conventional enclosing guard, then crossed the feet farther
behind the lumbar spine. Its measured ankle gaps were 8.4843 -> 13.5398 cm
and 13.4180 -> 19.5940 cm (source -> target); drift 59.590092% and 46.047973%.
The absolute retarget separation increased by 5.06 and 6.18 cm. Moving the
feet farther apart reduced the percentage without solving lock preservation.
These are C171 measurements, to be rechecked before new posing.

New approach: break down the top player's trunk and lower his waist between
the enclosing legs, then close the ankle crossing around that smaller section.
This changes the body arrangement and leg directions rather than repeating
the farther-apart ankle adjustment. First measure source/target limb lengths
and the existing lock; if evidence points to retarget rather than pose, record
and skip without engine changes. No new pose has yet been authored.

Baseline recheck reproduces 13.417996 -> 19.593963 cm. Source thigh/shin
45.4119/40.6597 cm; target 44.1590/43.1360 cm (left), total 87.295 cm
versus source 86.072 cm. The target legs are not too short overall. Their
segment directions match within .000034 degrees, but target hip offsets
differ by about 32 degrees. Attempt 1 therefore lowers the top waist and
uses a staggered crossing (mostly along the body, less lateral crossing)
to reduce sensitivity to the unequal thigh/shin proportions. This is not
the C171 farther-apart lateral lock. Hard controls all match baseline.

Attempt 1 contact worst 14.870063%, ankle 3.634568% (13.5639 ->
14.0501 cm). Render/sheet both 1/0, but close side inspection shows two
upright, separated feet rather than a convincing ankle lock. Numerically
preserved separation is insufficient, so this attempt is not accepted.
Attempt 2 retains the lower waist, narrows/staggers the ankle centres and
rotates the complete foot controller groups inward to hook the feet across
one another. This addresses the observed foot orientation, not a percentage.

Attempt 2: worst **14.832223%**, ankle lock **4.188641%**, source
9.7992 cm -> target 9.3983 cm; all five contacts below 30%, 241 samples.
Visual review: the bottom player's legs encircle the lowered top waist and
the inward-turned feet cross behind it; the side and high views now read
as closed guard. RENDER 1/0; SHEET 1/0, all 24 tiles inspected.
Sheet: clip_audit/paired/sheets/Cascy_ClosedGuard__sheet.png.
Cascadeur's native save reports failure creating its temporary file, despite
successful controller writes and GLB exports. The exact RIG.json, CLIP.json,
builder and C171 source scene preserve replay; no .casc save is claimed.
The first bounded run passed clip 10/0, grapple 10/0, pair 7/1 parked only,
technique_id 1/0. Re-running against final attempt-2 exports before committing.

Final attempt-2 gates: parse 3/0; clip 10/0; grapple 10/0; pair 7/1
(fight_pair_live_test PARKED only); technique_id 1/0. No full suite.
Hard controls: RamsterZ .302639/.304671; clinch collar 15%; side control
14.8173%; mount 18.716070%; turtle 11.194065%; open guard 21.533121%;
50/50 11.882802%. All unchanged. Closed guard accepted.

Closed guard publication: 1dce3989 pushed to origin/master; immediate C172
AgentComms report acd469fce6ba sent.

## 2. Front headlock - bjj_front_headlock - before authoring

_Att is the front controller. Existing contacts unchanged: both hands/neck,
same-body hand clasp and chest/head pressure, including source envelopes.
C171 attempt 1: left under-chin 30.447028%, right 29.650758%, clasp 8.967214%,
chest/head 20.405956%. Attempt 2 lowered the chest 6 cm and clasp 2 cm;
worst rose to 36.205861%, clasp 31.498011%. Lowering the entire assembly
changed segment directions without improving the retargeted grip.
New approach: restore the first attempt's body height and under-chin grip,
but tuck the elbows down beside the neck rather than flaring beside the
head. This changes the two-bone arm bend plane, not chest or clasp height.
It should also read as a compact front headlock instead of winged elbows.

Attempt 1 tucked elbows: worst 33.782422%, both under-chin contacts fail;
clasp 9.338579%, chest/head 20.405839%. Added signed endpoint-vector
diagnostics without changing gates. Left source (-8,-10,10) cm becomes
(-8.81,-10.32,16.97) cm: the main miss is longitudinal, not vertical.
Attempt 2 changes the wrap depth: clasp beneath the neck at z=-4 cm relative
to its centre, instead of 10 cm forward, retaining the tucked elbows and
original torso height. This is a deeper encircling grip; not C171's lowered
chest/clasp retry. Source envelopes and 30% ceiling remain unchanged.

Attempt 2 passes: left under-chin 2.315099%, right .921408%, clasp
9.857229%, chest/head **20.406136% worst**, 241 samples, no failures.
Render review: a front controller sprawls toward the folded opponent with
arms encircling the head and hands clasped underneath; this reads as front
headlock. Both attempts inspected; final RENDER 1/0, SHEET 1/0 (24 tiles).
Sheet: clip_audit/paired/sheets/Cascy_FrontHeadlock__sheet.png.
Native scene save has the same temporary-file failure; exact controller
replay and exported pair are retained, with the C171 native scene as base.
All seven hard controls reproduce the closed-guard entry's exact baseline.

Final gates: parse 3/0; clip 10/0; grapple 10/0; pair 7/1 (parked only); technique_id 1/0. Front headlock accepted.

Front-headlock publication: d290da0f pushed master; report 89145e42c315 sent.

## 3. North-south - bjj_north_south - before authoring

_Att is the head-to-toe top controller. Existing declarations remain both
top hands/opponent upper arms, both bottom hands/top chest, top chest/bottom
head. C171 moved bottom frames lower on the pectoral surface: 39.772830%
then 33.372926% worst. The second attempt still enlarged bottom hand/chest
separation from 23.199 cm to about 30.94 cm. Before selecting a new pose,
recheck signed endpoint vectors; no new pose has yet been authored.

Recheck: bottom left frame source (-13,-15,-12) cm -> target
(-11.83,-21.74,-18.56) cm; both downward and longitudinal separation grow.
New approach: a hip-raised, chest-down sprawl (top trunk pitched 15 degrees),
with the bottom forearms forming a more vertical shelf under the sternum.
This changes trunk orientation and arm support geometry, rather than moving
the same low pectoral frame still lower as C171 did. Hands remain on the
declared chest endpoint; underhooks and chest/head pressure remain declared.

Attempt 1 fails: bottom left 50.795730%, right 50.321400%; other contacts
under 16%. Both render gates pass; head-to-toe pressure reads, but the
bottom frames are not accepted. Segment diagnostics explain the miss:
bottom upper arms point inward and forearms outward; target forearms are
about 29 cm versus source 23 cm. That amplifies the wrong bend direction.
Attempt 2 explicitly places the bottom elbow poles outside the ribs and
down toward the mat, so forearms rise inward to the sternum. The chest
contacts stay at the same locations as attempt 1. This changes elbow bend
planes, not the low-pectoral position C171 repeatedly adjusted.

Attempt 2: worst **17.603796%** (bottom left frame); right frame
16.801316%, underhooks .876444%/1.555336%, chest/head 15.177140%.
All 241 samples pass. Visual review: the bodies face opposite directions,
with the top chest over the bottom head/shoulders and bottom forearms
framing inward; this reads as north-south. Both attempts inspected.
Final RENDER 1/0; SHEET 1/0, 24 populated tiles.
Sheet: clip_audit/paired/sheets/Cascy_NorthSouth__sheet.png.
All seven hard controls unchanged at the exact baseline values above.
Native save limitation persists; controller replay and exports retained.

Final gates: parse 3/0; clip 10/0; grapple 10/0; pair 7/1 parked only; technique_id 1/0. North-south accepted.

North-south publication: eaebbec8 pushed master; report 5ea748b1b066 sent.

## 4. Knee-on-belly - bjj_knee_on_belly - before authoring

_Att is the top player. Verified declaration: A LeftLowerLeg to B Spine
(abdomen), NOT pelvis or chest. Other contacts: A left hand/B right upper
arm, A right hand/B hips, B left hand/A left knee. Existing .30 m knee/belly
and .25 m hand/knee source envelopes remain unchanged.
C171 requested a knee near [-14.51,23,21.60] cm but solved [63.82,1.69,21.54],
65 cm from the abdomen. Reapplying calf_MainPoint after the body/foot update
failed identically. Both attempted the same folded branch through knee-point
writes, and the position did not read even when drift percentages passed.
New mechanism: drive calf_LimbDir, the leg bend-plane controller, from the
intended knee; exclude calf_MainPoint from writes, just as arm authoring
drives forearm_LimbDir and leaves forearm_MainPoint solved. Keep hip/ankle
positions and the contact declarations. Measure solved knee before accepting
any retarget number. This is neither C171's initial simultaneous point write
nor its post-update knee reassertion.

Attempt 1 remains invalid: source knee/belly max .651312 m, hand/knee
.877856 m; worst drift 19.258784% is irrelevant. The bend-direction write
did not change the solved branch. Render inspected: knee is beside the
opponent, not bearing on the belly. RENDER/SHEET 1/0 are population only.
Attempt 2 abandons that folded leg geometry: build from a knee at (0,23,16)
cm on the abdomen, derive a reachable hip 15 cm above it, and trail the
ankle behind the knee along the opponent's body rather than folding it
back under the same hip. The torso leans across from the opposite side;
the other foot gives a wide base. All lengths come from the reference rig.
This is a new whole-body arrangement, not another attempt to force the old
folded branch. No source-contact envelope or drift threshold is widened.

Attempt 2 reaches the source abdomen: knee/belly mean .152438369 m,
target .211237693 m, **38.596042% worst**. Hand/knee source .137124413 m,
target .162640015 m, 19.686817%. Other contacts 7.325400%/7.529813%.
Source envelopes pass; knee contact preservation does not. This is a
retargeted lateral offset (source x=-.018 cm, target x=-9.35 cm), not the
old 65 cm source miss. No engine corrections and no third attempt.
Visual review: the second pose places the knee over the midsection, but
the low cross-body crouch still does not give a clean isolated knee-pressure
silhouette. It is rejected on the measured gate regardless. Both attempts
rendered and inspected; RENDER 1/0, SHEET 1/0 (24 populated tiles).
Binding removed; final rejected GLBs moved into Tools/cascadeur/c172_knee_on_belly
as evidence, outside runtime assets. **SKIPPED after two new approaches.**

Cleanup gates: parse 3/0; clip 10/0; grapple 10/0; pair 7/1 parked only; technique_id 1/0. All seven hard controls unchanged. Knee-on-belly remains unbound.

Knee-on-belly publication: c2e084d9 pushed master; report 76a325cfcb95 sent.

## 5. Clinch victim right hand / attacker left upper arm - before authoring

_Att remains the collar-tie controller. Existing PAIRS declarations remain
unchanged. C171 retained the 34% victim-right-hand diagnostic and never
claimed it passed; the tracked attacker-left-hand/neck control was 15%.
New approach: change only the victim right arm's elbow bend plane in
Cascadeur while retaining its hand target on the upper arm. Reconstruct
the original clinch controller motion using the existing builder, export
its unmodified and edited versions, and transfer only the three right-arm
rotation channels into the original victim GLB. Preserve every other byte
and the entire original attacker export. Verify channel times/counts and
parent compatibility. This prevents unrelated torso or collar-tie changes.
Measure actual exported source contacts as well as the historical S31
readings, so a changed source gap cannot masquerade as a repaired contact.

Reconstruction check: 121 matching frames. Original/reconstructed parent
local rotation differences: pelvis .0154 degrees, stomach .0152, chest
.0333, right clavicle .0544; source poses agree closely. The runtime parent
channels will remain byte-identical. Baseline live-source gate exposes a
42.739295% worst instantaneous victim-hand drift (historical mean 34%).
Mean source .083244091 m -> target .054002627 m: the contact over-closes.
Original elbow flares outward; the target's longer forearm pulls the hand
inward past the upper arm. Attempt 1 tucks the victim elbow inward and
slightly down, changing the forearm direction while keeping the source grip.

Attempt 1 historical probe: collar tie 15%, victim hand 18%; own line
`S31CONTACT worst=vic_rhand_to_att_larm 18%`. But the live-source 241-sample
gate finds **90.794065%** peak victim-hand drift. A mean improvement hides
a severe transient, so this attempt is rejected. All non-right-arm bytes
were preserved (4961 changed bytes restricted to three quaternion tracks).
Attempt 2 returns to the stable original elbow direction and raises its
pole 25 cm, rather than swinging it across the body. This should give a
more downward forearm direction and avoid the inward path's transient
over-closing. The source hand target remains unchanged.

Attempt 2 passes the live-source gate: **25.699268% worst**, victim right
hand/attacker left arm. Actual source mean .091995966 m, target .072303354 m.
The source gap changed with the solve, so acceptance uses this actual new
source, not the old .083 m constant. Other instantaneous peaks: collar tie
18.092802%, opposite hand 8.010419%, heads 16.074947%, hips 4.332965%.
Historical tracked reading remains exactly 15%; victim hand improves
34% -> 13%. Probe's own line:
`S31CONTACT worst=att_lhand_to_vic_neck 15%`.
Packaging changed only 4247 bytes inside arm_r/forearm_r/hand_r rotation
outputs, with 121 matching sample times; every other victim byte is unchanged.
The original attacker GLB is byte-identical (SHA256 in c172_clinch/FINAL.json).
This is original Cascadeur controller authoring plus a bounded export splice;
no retarget, pose solver, stage-player, or forbidden binding edits.

Final visual review: both men retain the collar-and-upper-arm clinch through
the six photographed moments; the adjusted victim elbow remains controlled.
Both attempts reviewed. Final RENDER 1/0, SHEET 1/0 (24 populated tiles).
Sheet: clip_audit/paired/sheets/Cascy_CageClinch__sheet.png.
Also compared the new closed guard against C171's open-guard sheet: the new
inward foot crossing is distinct from the existing separated hip frames.
Accepted overview: clip_audit/paired/sheets/C172_accepted__overview.png.

Final clinch gates: parse 3/0; clip 10/0; grapple 10/0; pair 7/1
(fight_pair_live_test PARKED only); technique_id 1/0. Live-source contact
check 241 samples, failures=0. All seven hard controls unchanged.

## Queue disposition

| Item | Result | Worst accepted/final drift |
|---|---|---|
| Closed guard | Accepted, second new attempt | 14.832223% |
| Front headlock | Accepted, second new attempt | 20.406136% |
| North-south | Accepted, second new attempt | 17.603796% |
| Knee-on-belly | Skipped after two new attempts | 38.596042% |
| Clinch right-arm repair | Accepted, second new attempt | 25.699268% |

Worst accepted drift is 25.699268% (live-source peak, clinch). Worst final
queue result is 38.596042% (rejected knee). Worst observed across the new
attempts is 90.794065% (rejected first clinch path); mean-only reporting
would have hidden that failure. Historical clinch collar tie stays 15%,
victim-hand mean drift improves 34% -> 13%, probe worst is collar tie 15%.

Every hold was separately authored/assessed, rendered and inspected. Each
completed hold has one isolated commit, push to master and immediate C172
AgentComms report. No forbidden reads, no HANDOFF edits, no fetch/rebase,
no full suite, no solver/retarget/stage-player edits. Other agents' files
were never staged, stashed, reset or checked out.

These are original held-position loops, not entry/exit/submission sequences
or certification across all fighter proportions. Native scene saves failed
for the new work; exact controller data, replay scripts and exports remain.

Authored 4 (3 new holds + 1 clinch repair); skipped 1; worst accepted drift 25.699268%; worst overall 90.794065% (rejected attempt).

## C173 follow-up - kneeling closed guard

The reference `research/_captures/ground_video/closed_guard_locked.mp4`
shows the top fighter on both knees beneath his hips, shins trailing back.
The accepted 1dce3989 sheet instead shows a flat top player. This follow-up
changes the top player's support geometry and raises the existing staggered
ankle crossing around his lumbar spine. Both collar frames remain declared.
No contact threshold, binding, retarget or runtime solver change.

Original controller authoring: `Tools/cascadeur/build_c173_kneeling_guard.py`.
Top hip centre solves at y=47.905 cm; left/right knee centres at
y=4.295/4.295 cm, z=-7.921 cm against hip z=-5.010 cm. Thus knees are
under the hips, with ankles trailing at z=-48.238 cm. Both source shins
have ground-support geometry. Source joint centres are not skin/mat collision
certification across all fighter sizes.

The ankle lock retains its staggered narrow crossing and inward foot rotation;
the new source ankle gap is .097974 m, versus .097992 m for 1dce3989.
It is not widened to make a percentage pass.

| Unchanged contact | Source m | Target m | Worst drift |
|---|---:|---:|---:|
| Ankle lock | .097973816 | .125414536 | **28.077703%** |
| Left knee wrap | .349021723 | .335479307 | 4.127235% |
| Right knee wrap | .371235650 | .347680990 | 6.576594% |
| Left collar frame | .164969921 | .204688873 | 24.105463% |
| Right collar frame | .164971445 | .203299350 | 23.262905% |

All 241 samples pass the unchanged 30% ceiling. The first kneeling candidate
passes, so it replaces the flat version; no fallback to 1dce3989 is necessary.
The lower numerical margin (28.08% vs 4.19% ankle drift) is reported explicitly.
The renderer and sheet gate both pass 1/0, all 24 tiles populated and reviewed.
Visual assessment: the top player now visibly kneels over the supine guard
player, with the bottom feet crossed behind his waist; this reads as kneeling
closed guard in the side and low views.

Before and after, side by side (left = 1dce3989; right = kneeling):

![Closed guard comparison](../../Tools/cascadeur/c173_kneeling_guard/comparison.png)

Individual sheets: [before](../../Tools/cascadeur/c173_kneeling_guard/baseline_sheet.png),
[after](../../Tools/cascadeur/c173_kneeling_guard/kneeling_sheet.png).

Parse 3/0. Unchanged hard controls: RamsterZ .302639/.304671;
clinch collar tie 15%; side 14.8173% (7720 checks, zero failures);
mount 18.716070%; turtle 11.194065%; open guard 21.533121%; 50/50 11.882802%.
Per C173's ceiling, only the clip subset is run beyond those named controls;
no full suite. Native Cascadeur save still fails creating a temporary file;
RIG.json, CLIP.json, the builder and both real GLB exports preserve replay.
`--only clip`: **SUITE total=10 fails=0** on the final kneeling exports.
