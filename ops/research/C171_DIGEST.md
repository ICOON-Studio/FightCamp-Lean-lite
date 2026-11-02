# C171 - standing hold queue

C171 supersedes the general fetch/rebase, brief/inbox, HANDOFF and one-stage
startup/stop rules. No fetch, rebase, pull or HANDOFF access. The documented
FIGHTCAMP_STAGE_GATE=off override is used for this explicitly standing task.
The comms CLI accepts --topic C171 (not the task text's --subject).

## 1. Mount Control - bjj_mount

_Att is the top player, controlling the supine opponent from a bilateral knee
base. Before authoring, the probe declared both knee-to-opponent-hip distances,
both bottom hand-to-top-hip frames and chest-to-chest pressure. These are joint
centre contacts, not skin collision certification.

Attempt 1: worst 49.899120%, bottom right hip frame. Attempt 2 moves both bottom
frames to the upper hip surface (10 cm up and headward); the contract and 30%
ceiling are unchanged. Final worst **18.716070%**, 241 samples including midpoints:
left knee 9.075749%, right knee 8.749447%, left frame 17.820217%, right frame
18.716070%, chest 5.532935%. No solver, retarget or stage-player edits.

Probe fixes: run after tree entry to remove inherited transform errors; compare
new declared contacts with actual exported source at every sample, fail missing
bones and any drift above 30%. Exported victim namespace stripped by the existing
helper before measurement. The first missing-bone reading correctly caught that
export normalization omission; it was not a failed authoring attempt.

Hard controls: RamsterZ 0.302639 / 0.304671; established clinch control
att_lhand_to_vic_neck 15%; side control 14.8173%, 7720 checks, failures=0.
The unrelated pre-existing clinch victim-hand diagnostic still reports 34%,
unchanged; the historical hard control is the attacker left collar tie.

Visual review: all four views show a low chest-down mount, with the top player's
knees either side of the supine man's torso rather than both on one side.
RENDER total=1 fails=0; SHEET total=1 fails=0 (24 populated tiles).
Sheet: clip_audit/paired/sheets/Cascy_Mount__sheet.png.
Parse: CHECK total=2 fails=0. Clip subset: SUITE total=10 fails=0.
Grapple: SUITE total=10 fails=0. Pair: SUITE total=7 fails=1 (parked fight_pair_live_test only). Technique ID: SUITE total=1 fails=0. No full suite.

## 2. Closed Guard - bjj_guard - SKIPPED after two attempts

_Att is the bottom guard player who owns the enclosing legs. Declared before
construction: same-body foot/foot ankle lock, both knee/top-hip wraps, both
bottom hand/top-neck collar frames. The catalogue ID is present and verified.
Attempt 1 ankle lock: source .084843349 m, target .135397540 m, worst 59.590092%.
Attempt 2 crosses the feet farther behind the lumbar spine: source .134179956 m,
target .195939626 m, worst **46.047973%**. Other contacts are below 15%.
The unchanged 30% ceiling fails twice, so the hold is skipped, not shipped.
Binding removed. Failed exports and Cascadeur source retained only as authoring
evidence under Tools/cascadeur/c171_closed_guard, outside the game's clip directory.
No engine correction attempted and no third authoring attempt.

Visual review: the bottom player's legs enclose the hips and the feet cross
behind the top back, but the lock spreads after retargeting; this is a rejected
closed-guard attempt, not a certified playable closed guard. Both render and
sheet population gates pass; the sheet is retained for the later open-guard
comparison. RENDER total=1 fails=0; SHEET total=1 fails=0, all 24 tiles.
Hard controls freshly unchanged: RamsterZ .302639/.304671, clinch collar tie 15%,
side control .148173 worst drift with 7720 checks and 0 failures.
Push of mount was rejected twice by automatic approval review, which requires
explicit destination authorization for the existing origin/master remote.
The operator question remains pending; continue local work and per-hold reports.
Closed-guard cleanup gates: parse 2/0; clip 10/0; grapple 10/0; pair 7/1 (parked only); technique_id 1/0.

## 3. Turtle - bjj_turtle

_Att is the top rider behind the folded opponent. Contacts declared before
construction: left hand/neck, right hand/hip, each top knee/opponent hip, and
chest/back pressure. First attempt passes, worst **11.194065%** (left neck
control), 241 samples; other contacts: 7.042426%, 1.016367%, .413890%, 1.256282%.
No second attempt or engine changes needed.

Visual review: the bottom man is folded face-down over his knees with hands
forward, and the top man rides behind and above him; it reads as a turtle ride
from the side and low views. The existing bone-based framing accommodates it
without changes. RENDER 1/0; SHEET 1/0, 24 populated tiles.
Sheet: clip_audit/paired/sheets/Cascy_Turtle__sheet.png.
Hard controls: RamsterZ .302639/.304671, clinch collar tie 15%, side control
14.8173% (7720 checks, 0 failures). Parse 2/0.
Turtle subsets: clip 10/0, grapple 10/0, pair 7/1 (parked only), technique_id 1/0.

## 4. North-South - bjj_north_south - SKIPPED after two attempts

_Att is the top player facing opposite the supine opponent. Declared contacts:
both top hands to opponent upper arms, both bottom hands to top chest, top
chest to bottom head. Attempt 1 worst 39.772830%; attempt 2 moves the bottom
frames lower on the top pectoral surface, worst **33.372926%**. Two failures:
skip, binding removed, rejected exports moved to the authoring evidence folder.
No thresholds changed or engine files edited.

Render repair: the former camera used the same largest-dimension distance for
all directions. North-south's long body span gave only 2.54-2.56% body coverage
in two views, below the unchanged 3% gate. _aim now fits the eight posed-box
corners to each camera's horizontal/vertical perspective frustum, including
skin padding and depth, with 15% framing margin. No coverage, deck-rest or
plausibility thresholds were loosened. Final coverage 3.68/9.19/3.84/8.45%.
RENDER 1/0 and SHEET 1/0; all 24 tiles populated.
Visual review: the two bodies clearly oppose head-to-toe, with the top chest
over the bottom head/shoulder region; the failed bottom frames prevent acceptance.
Sheet: clip_audit/paired/sheets/Cascy_NorthSouth__sheet.png.
The task's explicit read-set overrides the general visual-law extra-file read;
no design-system UI or colours were changed, only this authorized camera tool.
Hard controls unchanged: RamsterZ .302639/.304671; clinch collar tie 15%; side
14.8173%, 7720 checks, zero failures. Parse 3/0.
North-south cleanup subsets: clip 10/0, grapple 10/0, pair 7/1 parked only, technique_id 1/0. Camera regression: mount and turtle re-rendered, sheets reviewed, both RENDER 1/0 and SHEET 1/0.

## 5. Knee-on-Belly - bjj_knee_on_belly - SKIPPED: source contact absent

_Att is intended to be the top player with left knee across the abdomen and
right foot as a wide base. Declared before construction: knee/bottom spine,
left hand/bottom right upper arm, right hand/bottom hip, bottom left hand/top
knee. Builder first rejected an unreachable arm; lowering the crouch made the
source targets reachable without lengthening bones.

Attempt 1 numerical worst drift 19.258858%, but this is NOT a pass: source
knee/belly .651006479 m and bottom hand/knee .877508582 m are separated, not in
contact. Render inspection caught the bad pose. Live Cascadeur measurement:
requested knee [-14.51,23,21.60] cm, solved calf [63.82,1.69,21.54] cm. The
source solve chose the other folded-leg branch.
Attempt 2 explicitly reapplies knee MainPoints after the body/feet update.
The requested knee still does not land; .651486 m maximum knee/belly and .878070 m
maximum hand/knee. Retarget worst 24.905199% is immaterial to absent contact.
No third attempt. This skip applies the task's contact/visual validity requirement:
shipping a preserved miss would violate it even though relative drift is below 30%.

Probe schema tightened with source-distance envelopes of .30 m knee/spine and
.25 m hand/knee, so this exact false positive is now two loud failures. No existing
threshold widened. The ineffective opt-in helper change was removed; its replay
is preserved as attempt2_apply.py beside MEASURE.json and the rejected exports.
Runtime binding removed, GLBs moved out of the game directory. No engine edits.
Visual review: a crouched top fighter is beside the opponent, but his knee is
not on the belly; this does NOT read as the requested contact position.
RENDER 1/0 and SHEET 1/0 certify populated frames only, not acceptance.
Hard controls unchanged: RamsterZ .302639/.304671, clinch collar tie 15%, side
14.8173% (7720 checks, 0 failures). Parse 3/0.
Knee-on-belly cleanup subsets: clip 10/0, grapple 10/0, pair 7/1 parked only, technique_id 1/0.

## 6. Open Guard - bjj_open_guard

_Att is the bottom guard player. Declared before construction: separate left
and right foot/top-hip frames, both bottom collar frames, and the ankle gap.
Unlike a contact, the gap must stay >=.25 m in BOTH source and target; the foot
frames also have a .30 m source envelope. No crossed ankle lock is authored.
First attempt worst **21.533121%** (left foot/hip), 241 samples. Right foot
19.986016%, collar frames 14.938892%/14.065050%, ankle-gap drift 13.155359%.
Source ankle gap .399994260 m, target .452586993 m; no gap-floor failures.

Visual review: the high view shows two separated feet on the hip sides, while
the rejected closed-guard sheet has feet crossed behind the back; the two are
visibly distinct side by side. This accepts open guard only, not the rejected
closed-guard source. Full sheet pair and close high/side comparison are in
clip_audit/paired/sheets/C171_closed_vs_open__sheets.png and __detail.png.
RENDER 1/0; SHEET 1/0, 24 populated tiles. No source correction needed.
Hard controls unchanged: RamsterZ .302639/.304671, clinch collar tie 15%, side
14.8173%, 7720 checks, zero failures. Parse 3/0.
Open-guard subsets: clip 10/0, grapple 10/0, pair 7/1 parked only, technique_id 1/0.

## 7. Front Headlock Control - bjj_front_headlock - SKIPPED after two attempts

_Att is the front controller, facing the folded opponent and clasping beneath
his neck. Contacts declared first: both under-chin hands to neck, same-body hand
clasp, and chest/head pressure. Source envelopes also reject separated grips.
Attempt 1 worst 30.447028% (left under-chin control), just above the unchanged
30% ceiling. Attempt 2 lowers the top chest 6 cm and the clasp 2 cm to improve
pressure; worst worsens to **36.205861%**, with right hand 35.414963% and clasp
31.498011%. Chest/head drift is 26.981070%. No third attempt or rounding down.
Runtime binding removed and rejected exports retained only under the source
work directory. No solver/retarget/stage-player changes.

Visual review: the front fighter's arms encircle the folded opponent's head
with hands clasped below it, so the position reads as front headlock, but contact
preservation fails. RENDER 1/0 and SHEET 1/0 (24 populated tiles), both attempts
reviewed. Sheet: clip_audit/paired/sheets/Cascy_FrontHeadlock__sheet.png.
Hard controls unchanged: RamsterZ .302639/.304671, clinch collar tie 15%, side
14.8173% (7720 checks, 0 failures). Parse 3/0.
Front-headlock cleanup subsets: clip 10/0, grapple 10/0, pair 7/1 parked only, technique_id 1/0.

## 8. 50/50 Guard - bjj_5050

_Att is the first rig by convention, not because 50/50 has a dominant player;
both receive mirrored seated leg entanglements. Declared before construction:
each actor's inside and outside foot to the opponent's inside upper-leg joint.
Each source endpoint pair must also remain within .30 m.
First attempt passes: A inner 11.083055%, A outer 3.246063%, B inner
**11.882802%**, B outer 2.074139%; 241 samples. Source means .20921/.24440 m;
target means .23111/.25172 m (A) and .23265/.24858 m (B).

Visual review: two opposing seated players have interlaced legs through the
shared centre, with equivalent wraps on each side; it reads as symmetric 50/50.
All four camera views reviewed. RENDER 1/0; SHEET 1/0, 24 populated tiles.
Sheet: clip_audit/paired/sheets/Cascy_5050__sheet.png. No correction needed.
Hard controls unchanged: RamsterZ .302639/.304671, clinch collar tie 15%, side
14.8173% (7720 checks, 0 failures). Parse 3/0.
50/50 subsets: clip 10/0, grapple 10/0, pair 7/1 parked only, technique_id 1/0.

## Queue disposition

All eight holds attempted in measured order. **4 accepted locally, 4 skipped.**
Accepted: Mount 18.716070%, Turtle 11.194065%, Open Guard 21.533121%,
50/50 11.882802%. Worst accepted drift: **21.533121%**.
Skipped: Closed Guard 46.047973% final, North-South 33.372926% final,
Knee-on-Belly absent source contact (24.905199% drift is not acceptance),
Front Headlock 36.205861% final. Worst final drift across all eight: 46.047973%.
Worst observed across all attempts: 59.590092% (closed guard attempt 1).
Every hold has its own commit and immediate AgentComms report; the final tally
is sent after the last hold. No full suite, no forbidden engine edits, no
HANDOFF/status/digest exploration. Concurrent FightRealtime.gd and suite-state
changes belong to other work and were not staged.

All four accepted holds were rendered and inspected, and the complete guard
sheets were compared side by side. Accepted overview:
clip_audit/paired/sheets/C171_accepted__overview.png.
These are held-position loops with a breathing cycle; they do not certify
entries, exits, submissions, skin collision or all fighter proportions.

Publishing remains blocked: automatic approval review rejected origin/master
pushes despite the task's general push instruction. Identified destination:
https://github.com/Guru-Meditation/FightCamp.git, master. A request for explicit
operator destination approval was presented; no response has arrived during
this run. Commits are local, not claimed pushed. Do not bypass that rejection.
