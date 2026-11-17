# FIGHTPLAYER2 - the full scope for rebuilding the 3D fight's motion (S510, 2026-11-17)

A plan, nothing built. Written for the owner. Every claim about our code or a study names its file. GUESS = not measured.
Words used: a CLIP (or TAKE) is one recorded movement, e.g. a jab; RETARGETING = moving a clip recorded on the actor's
skeleton onto our MetaHuman skeleton; a JOIN = the moment one clip hands over to the next; a LAYER (or modifier) = code that
re-bends the bones after the clip each frame; IK = code that bends an arm or leg so the hand or foot lands on a chosen point;
ROOT MOTION = letting the clip's own hip travel move the boxer across the canvas; a MASK = playing a clip on part of the
body only (e.g. the trunk and head) while the legs do something else; a RULER = our own measuring script on a film.

## 0. The short answer
- The bought clips are fine on their own: the pack is clean at the source and, alone on our body, six of them scored 7.0
  with blind critics (`ops/research/TASK_RETARGET2.md`, `ops/research/RETARGET2B_RESULT.md`). The whole fight scores 4.5.
- The points are lost after the clip, in how we PLACE, AIM and PATCH it: every punch is pinned in place, the two bodies are
  moved to fit the clip (the opposite of Undisputed), and about 25 layers per boxer re-bend the result every frame. Each
  patch has caused the next one (section 1b). That matches the owner's "coding mistakes or pipeline", but it is not yet
  PROVEN: the raw-clips baseline running now decides it (section 1d).
- v2 does what Undisputed and Blood & Canvas measurably do: the footwork makes the distance, a clip is CHOSEN to fit it,
  the clip moves the body itself, reactions are captured clips laid over the legs, one short smooth join, IK only on the
  last 30 cm of a straight punch. Our own advantage: the round is already decided, so the plan can see the whole exchange
  before it plays.
- Most of v2 can be built and judged with clips we own before the end-of-November purchase; the purchase then buys only
  the rows in section 4 that the clip census (phase 1) still shows empty.

## 1. Diagnosis

### 1a. The scores
- Whole fight: r0 4 / 4 (S496), r12 5.0 / 5.0, r13 4.5 / 4.5, r14 4.5 / 4.5 (coach / animator;
  `NEXT_SESSION_PROMPT.md` "ANIMATION LOOP STATE"). Fourteen rounds of patches moved it about half a point.
- Clips alone on our body, turntable: mean 7.0, jab 7 (`ops/research/RETARGET2B_RESULT.md`). The stepping route vs the
  captured-takes route: 4 vs 3 (`ops/research/HUMANFIGHT1_DIGEST.md`).
- Old repo S274: the owner judged an A/B where the bone-rewriting layers were OFF "much better"; the decision then was
  "the captured clip is the base; layers come back only where they measure as needed" (`ops/research/ANIM_TOOLKIT_S274.md`).
  The layers came back anyway: S274 counted ~30, today there are ~25 per boxer (`scripts/fight3d/BoxerBuild.gd` build()).

### 1b. Where the damage comes from
| source | evidence | verdict |
|---|---|---|
| The clips | Clean at source: raw foot slide 0.11-0.30 m, 0 leg snaps in 6 of 7 tested (`TASK_RETARGET2.md`). But they are bag work: authored at one range (straights reach at 0.91-1.11 m, uppercuts only at 0.61-0.70 m, 65 % of a straight where Undisputed's is 97%) (`scripts/fight3d/RangeTable.gd` header, `REFERENCE_DISTANCES_S439.md`); the glove travels on 0.13 s past contact (`ArmHome.gd` header); 19 of the 59 Punch PRO punch takes are switched off on score (`BeatClips.gd` OFF_TAKES); one reaction take throws a jab's head to the ceiling (`pro_hit_by_jab_v4_short`, r14 coach). Three jab takes were hand-edited (`assets/anim/baked/fixed/`, CLIPFIX3) and two of them (`pro_left_jab_b`, `_c`) hold r14's worst head jumps "inside clip" (`E:/FightCamp/tmp/fightweek/r14blind/rulers_motion.txt`). | Partly to blame: wrong range, some bad takes, too few takes per family. Not the main cause on present evidence. |
| Retargeting | RETARGET2B brought the fidelity gate from 46 failures to 0 (`RETARGET2B_RESULT.md`, `tests/retarget_fidelity_test.gd`). Left over: a cross reaches 0.78 m on our body vs 0.94 m raw (hip-relative, same file; that both use one scale is not confirmed); three layers exist only to patch the conversion: KneeTrack (thigh roll caves knees, 57 clips failed), ElbowClear (male clips on narrower bodies), FloorClear (knockouts lie 10 cm under the canvas) (their headers in `scripts/fight3d/`). | Mostly fixed; the proportion faults belong in the bake, not in runtime layers. Unproven how much the shorter reach costs. |
| Joining | One dead-blending joiner (`JoinSmoother.gd`: 0.3 s, half-life 0.06 s; short punch joins 0.09 / 0.35 in `BeatFire.gd`). r14: only 2 of 14 head jumps happen at a clip change. But reactions replace the whole body so the legs stop (`UNDISPUTED_MIX_S391.md` issue 4); a punch clip held the boxer 0.42-1.4 s after contact against Undisputed's 0.11-0.17 s (`UNDISPUTED_STUDY_S254.md`); three reactions were cut by the hit man's own punch (r14 rulers). | The join itself is sound. The SCHEDULE around it (when control returns, full-body reactions) is wrong. |
| Aiming and placement | Every punch and reaction is played with the hips pinned in place (`FightClips.gd` hold_root_xz): a landed cross showed 0 cm of body travel against a real 28 cm (`PunchWeight.gd` header). The bodies are then MOVED to the chosen take's distance (`RangeTable.gd`, `RangeBreath.gd`, `PunchRange.gd`), and the glove is pulled onto the face by IK with a chest lean (`PunchReach.gd`, `ReachLimit.gd` up to 0.30 m). Result on film: one distance all bout (1.34 m median), lunges to 0.95 m stances, a head inside the other body for 3 frames (r14 rulers, both critics). | The main cause on present evidence: it is the opposite order of the shipped games (section 2). |
| Correction layers | Adding POWER1's punch weight and drive took head jumps from 5 to 53; with those two off, 8 (`PopCap.gd` header, memory S496). Layers fight each other in writing: "layers after the hold lift" the free glove over the head (`GuardBox.gd`); the arm clearance "leaves all of an overlap at once", 12-20 cm a frame (`ArmClash.gd`); ElbowClear moved elbows 2-18 cm after gloves were cleared (`ArmClash.gd`). r14: 11 of 14 head jumps happen inside a clip, where the layers act. | Large and self-feeding. The chain: pin the hips -> the punch has no body -> PunchWeight + drive -> head jumps -> PopCap -> glove held by IK -> arm hangs out -> ArmHome + carry -> free glove lifted -> GuardBox. |

### 1c. Every correction layer, what it corrects, and its fate in v2
Order as built in `scripts/fight3d/BoxerBuild.gd`; helpers called from inside them listed with their caller.
| layer | what it corrects | v2 |
|---|---|---|
| ElbowClear | elbow sinking into a narrower torso (clips from male bodies) | move into the bake, then delete |
| PunchWeight | puts back the hip travel that pinning removed | DELETE (root motion kept) |
| JoinSmoother | smooths every clip change (dead blending) | KEEP - the one joiner |
| RkJoinFeet | feet through joins into Rokoko takes (route off since S432) | DELETE |
| TiredSag | tired trunk fold and breathing | keep only if the owned tired idles do not read |
| GuardWeave | trunk wanders between punches | DELETE (critics: "weaves at nothing"); idle clips instead |
| FighterLife | breath, weight shift, eyes, blinks | KEEP eyes/face/breath, drop its stance edits |
| GuardTuck | pulls the clip's gloves (0.22 m out) to the face | REPLACE by guard-style idle clips |
| PopCapPre, PopCap | caps head and trunk jumps per frame | DELETE at runtime, keep as a ruler and test bar |
| ArmHome | brings the arm home ahead of the body | DELETE (clip's own recovery, control back at contact + 0.13 s) |
| PunchReach (+PunchReachMath, ReachLimit, ReachDrive, PunchPace drive) | glove onto the face, chest lean, carry, hand speed | REPLACE by one straight-punch IK with Undisputed's limits; carry and drive deleted; PunchPace's start trims kept as clip data |
| HitSnap (+HEADEASE) | adds a head snap on a hit; elbow brace on a blocked body shot | DELETE once reactions are sized clips; brace stays until block clips exist |
| GloveClear (+HeadClear) | gloves and heads out of the other's head | REPLACE by a check at plan time; no per-frame push |
| ArmClash | arms out of each other | DELETE (plan-time check) |
| KneeTrack | knees caved by the conversion | move into the bake, then delete |
| FootPlant + FootLock + FloorStand | planted feet stay planted, feet on the canvas | MERGE into one foot lock - KEEP (critics: "should be protected") |
| WalkPure | lets the feet go during the corner walk | keep with the walk |
| BoxerFootworkRig (+BoxerFootwork, KneeCalm) | procedural steps and bounce under the guard | KEEP for steps between punches; KneeCalm deleted if knee jerks go with the layers |
| FloorClear | knocked-down bodies under the canvas | KEEP until the knockout clips are fixed in the bake |
| GuardBox | free glove above the head | DELETE |
| MetaHumanTwist | twist bones so the skin does not wring | KEEP (skin, not motion) |
| BlockCatch (+BlockCatchPoint) | turns one arm so the guard meets a blocked punch | REPLACE by block-flinch clips |
| RangeTable, RangeLive, UpperRoom, PunchRange, RangeBreath | move the bodies to the take's distance; keep them apart | REPLACE by the choreographer (3b) |
| HitStep, HitStun, HitImpact | hit man steps back; locked in reaction; hit-stop | REPLACE by reaction clips with root motion + scheduling; hit-stop kept as an option (B&C 0.04 s, Undisputed none) |
| IdleMatch, ShownRoot, SideStep, MirrorClip | pose-matched entry to the guard; no root jumps; dodge steps; southpaw | KEEP |
Not touched: Clinch, KnockdownCount, CornerMinute, Referee, FightIntro, cameras, HUD. Result: about 8 of these ~40 scripts stay.

### 1d. What is unproven, and how the raw-clips baseline settles it
Unproven: (1) that the layers, not the clips, cost the points; (2) how much the shorter reach on our body costs;
(3) whether the head jumps "inside clip" come from the clip or from layers acting during it. The baseline running now films
the same bout four ways - raw clips, placement only, the full stack, and clips on their original skeleton - with the r14
rulers (`tools/fight_motion_rulers.py`). Read it like this:
| result | means | plan change |
|---|---|---|
| full stack worse than raw / placement-only | the layers do the damage | plan as written |
| placement-only clearly worse than raw | where and how bodies are put is the main damage | build the choreographer (phase 2) first |
| our body worse than the original skeleton | the conversion loses quality | re-bake first (phase 1b) |
| raw clips already show the faults (head back, arm out) | those takes are bad | the census drops them; the buy list grows |
| full stack better than raw | the layers help; the rebuild idea is wrong for us | stop; fix the named takes instead |
Judge it on the rulers and the owner's eye first (see decision 2 on AI critics).

## 2. How the three games do it (only what the studies measured; GUESS marks a guess)

**Undisputed** (Unity; `R121_UNDISPUTED_ANIMATION.md`, `UNDISPUTED_STUDY_S254.md`, `UNDISPUTED_MIX_S391.md`,
`REFERENCE_DISTANCES_S439.md`, `E:/FightCamp/tmp/undisputed_study/footwork_S381.md`)
- Distance first, clip second: each punch exists as an inside take (body moves 1-3 cm), a longer take (7-16 cm), a power
  take and lunge takes (35-63 cm). The clip is chosen to fit the distance; nothing stretches or folds one clip.
- Reach = 0.55 x the boxer's wingspan, about 1.0 m; the AI engages at 0.75-1.45 x reach.
- Arm IK only finishes the job: up to 0.30 m on straights, lean up to 30 deg, elbow never under 35 deg, full within
  0.35 m and gone by 1.25 m; hooks and uppercuts get almost none. The body is never warped onto the target.
- Control returns 0.11-0.17 s after impact; the clip's tail blends out under the next action.
- Joins: motion matching (each frame it searches a library of ~65,000 poses per style, one every 0.05 s, for the pose
  that best continues the motion) plus inertialization (the old pose's leftover movement fades out, no two clips mixed).
  Blend times: into a punch 0.15 s, slip 0.15, normal 0.30, weave 0.5; reactions in 0.05, out 0.20-0.25.
- Reactions: 18 snap-backs (left / centre / right, head / body, three strengths) + 6 stumbles + 12 counter-hit ones.
  Body masks exist (a body reaction without the arms, a head reaction of trunk and head only); that they lay reactions
  over the footwork at runtime is NOT confirmed (GUESS, strong).
- Footwork: ~53 long takes per style (28-45 min), no single-step clips used; steps are gather-and-reach pairs of
  0.55-0.60 s; guard bounce about 2 per second, 7 cm. 2,699 named fighter clips at least, 333 of them idles.
- No hit-stop found. Both stances captured, none mirrored.

**Blood & Canvas Bareknuckle (demo)** (Unreal; `BLOOD_CANVAS_STUDY_S392.md`, `REFERENCE_DISTANCES_S439.md`)
- 6 punches x 8 forms (standard, low, power, step and mixes). A step form is picked by range (the flag has no writer in
  the demo).
- No authored contact distance: the hit is the first touch of the hand on the body, mid-travel; its force is the fist's
  speed at that moment. Working distance 1.05-1.35 m centre to centre.
- Punches whole-body, blend 0.06 s. Hit reactions on an UPPER-BODY slot, 0.47 s, blend in 0.03-0.10 s, so the legs keep
  moving; stumbles (0.93 s) and knockouts whole-body. Hit-stop 0.04 s.
- Names in its animation graph: inertial blending, layered bone blend, control rig, foot trace; physics on arms, spine
  and head (names only; how they are used is a GUESS). ~130 fight clips: 20 flinches, 9 stumbles, 9 knockouts.

**Boxing Manager** (Godot 4.6.1 custom build; `BOXING_MANAGER_PLAYTEST_S426.md`, `BOXING_MANAGER_CAMERA_S501.md`,
`BOXING_MANAGER_COMPARE_S425.md`)
- Its animation data and code are in an encrypted pack: HOW it animates is UNKNOWN. Seen on screen only.
- The playtest: "bodies look alike and at our 3 to 4 frames a second I cannot judge the punches", yet its fight scored
  8 as a show: a camera that cuts every 5-8 s between three shots, a low lens (~1.3 m) with the boxers at ~60 % of the
  picture, state chips over the heads, replays, six speeds.
- Lesson: Godot can ship a watchable 3D boxing broadcast, and presentation carries much of it. GUESS: their motion is
  simpler than ours. The camera is a separate owner decision (section 6), not part of this rebuild.

## 3. The target: fight player v2

### 3a. The rule
The clip is the motion. Code only CHOOSES the clip, PLACES the boxer, JOINS clips and FINISHES the last 30 cm of a
straight punch. Nothing re-bends a clip's bones to hide a fault; a fault is fixed by choosing another take, by fixing it
once in the bake, or by buying or capturing a better take.

### 3b. From the settled round to the screen
1. Unchanged input: the round is settled by the rules; `ExchangeBeats.gd` / `BeatFire.gd` hand over beats (who throws
   what, landed clean / graze / blocked / slipped / missed, and when).
2. NEW: the CHOREOGRAPHER (a pure module, no scene, unit-tested; cloud seats can build it). It plans each 30-second
   exchange before it plays - something none of the three games can do, because their future is not known:
   - keeps a distance plan: rest out of reach (1.6-1.8 m, the coach's number), creep to ~1.4 m, step in as the punch
     lands, leave within 1-1.5 s; side steps and pivots at least every 20-30 s (both critics' 10/10 lists);
   - for each punch, picks the take whose measured contact distance is nearest the planned gap (section 3c);
   - may slide a beat up to about 0.25 s inside its exchange so a visible step and the punch fit; never across the
     exchange line, never changing order, count or outcome;
   - checks every contact against body rules from the clip database's stored poses: heads at least 25 cm apart, a head
     outside the other's chest, front boots not overlapping; a failing pair gets another take or another gap, at plan time;
   - picks each reaction by punch, side, zone and strength; no punch from the hit man until his reaction ends; a hit man
     whose own punch is less than halfway out drops it (animator item 2); the man who lands follows up or steps out
     within 6 frames (coach item 3);
   - writes a timeline per boxer: start time, clip, start point, speed, body part (whole / upper body), join time,
     footwork targets.
3. NEW: the PLAYER (small) plays the timeline: clips with their own hip travel (root motion; the pinning in
   `FightClips.gd` hold_root_xz is dropped for punches, steps and reactions); one joiner (`JoinSmoother.gd`) with
   Undisputed's times per kind; light reactions and blocks on the upper body with the legs on the footwork; the
   procedural footwork rig and one foot lock for steps between punches; the straight-punch IK; nothing else.

### 3c. A punch that fits the distance
The clip database (phase 1) stores, for every owned take measured raw on our body: the pelvis gap at contact, the hip
travel, when the hand is home, the reaction size and direction, and posture flags (face tipped more than 15 deg, glove over
the crown, back to the opponent). The choreographer looks up the takes of the punch the round asked for and takes the one
within 0.15 m of the planned gap (half of Undisputed's 0.30 m arm budget, so IK stays small); if none fits, the footwork
gets there first (a step the viewer can count), or a stepping take is used. IK then finishes straights only, with
Undisputed's limits (section 2); hooks and uppercuts land where their clip puts them. Control goes back to the
choreographer 0.13 s after contact so a combination's next punch starts while the last hand comes home.

### 3d. Reactions from captured clips
Light and medium hits: a captured reaction on the upper body, legs stay on the footwork, sized by punch (jab 8-12 cm of
head travel, cross 18-25, hook 20-30; both critics' numbers), joined in 0.05 s and out in 0.20 s. Heavy hits, stumbles and
knockdowns: whole-body clips WITH their hip travel, so the hurt man really gives ground. Blocked punches: a block flinch
clip (the blocker rocks). Hurt state: the three owned hurt idles (owned, never played; `ANIMATION_GAPS_S439.md` 8a).

### 3e. Joining, and what exists for Godot 4.7
- Inertialization: we already have it (`JoinSmoother.gd` is Holden's dead blending, a form of it). Keep it; set the
  times per kind (into a punch 0.15 s, reaction in 0.05 / out 0.20, slip 0.15, guard 0.30).
- Upper-body masks: Godot's AnimationTree blend nodes take bone filters (built in, `ANIM_TOOLKIT_S274.md`; `Q57_VARIETY_WITHOUT_BUYING.md`).
- Built-in helpers worth a trial: TwoBoneIK3D for the straight's arm and the feet; LimitAngularVelocityModifier3D as a
  last cap on joins (`ANIM_TOOLKIT_S274.md`).
- Motion matching: NOT for punches - it needs hundreds of takes to choose well (`R121_UNDISPUTED_ANIMATION.md` s6;
  John: "No, not with about 100 short clips", `J_FIGHT_ANIM_TECH_S431_BRIEF_JOHN.md`). Later, optional, for idles and
  footwork from long takes we own: godot-motion-matching (MIT, GDExtension, 0.2.1 for Godot 4.4+, NOT tried on 4.7.2),
  orangeduck/Motion-Matching (MIT, the reference code) (`ANIM_TOOLKIT_S274.md`). Decided: we build v2 on our joiner and
  Godot's own nodes; no add-on is needed to start.

### 3f. It still only SHOWS a settled round
The choreographer reads the beats and never writes them back. Bars: per round, the 3D's landed / thrown counts equal the
rules' (`BeatTally.gd`); every beat lands inside its exchange; outcomes are untouched. A golden-path test walks it.

### 3g. Where it lives
New folder `scripts/fight3d/v2/`, switch `-- fightplayer2`; the old player stays as the control arm until v2 wins. Every
file under 500 lines. The animation-loop session owns today's `scripts/fight3d` files; v2 adds files beside them.

## 4. The clip gap list (for the end-of-November purchase)
Counts are the smallest set that closes each gap from one camera (`ANIMATION_GAPS_S439.md`), checked against our tables
(`BeatClips.gd`, `assets/anim/baked`). Southpaw = mirrored, so orthodox only. The census (phase 1) confirms each row
before anything is bought.
| family (move x distance x side x zone) | v2 needs | we own that fits | gap | where it could come from |
|---|---|---|---|---|
| head punches, mid range | 6 punches, 2-4 takes each | jab 4, cross 4, lead hook 2, rear hook 1, uppercuts 1 each (Punch PRO plain) | uppercuts reach only at 0.61-0.70 m: 2 longer uppercuts; rear hook 1 more | owned Mixamo Boxing_Lead_Hand_Uppercut, Standing_Left_Uppercut_Punch (eye check); packs |
| head punches, inside (body moves 1-3 cm) | both hooks, both uppercuts | none made for it | 4 | no pack lists range takes (`MOCAP_PACKS_S439.md`): trimmed owned takes, a Cascadeur edit, or our own capture |
| stepping punches (35-63 cm) | 6 | _FT jab, cross, both hooks (some off on score) | 2 uppercuts (off on score) | animo pack (4 stepping punches + a step back) |
| body punches | 6 | body hook (`pro_body_shot`), kidney shot | 4-5: body jab, body cross, rear body hook, body uppercuts | animo pack (body versions of all 6); owned Mixamo body jabs and hooks |
| punch stopped on the guard (attacker) | jab, cross | none | 2 | make from ours (cut at guard contact + recoil) |
| head reactions by side and strength | ~3 sides x 2-3 strengths | ~14 in the pools, few light ones (most 12-28 cm) | ~4 light, 2 uppercut, 1-2 side | owned Mixamo Big_Hit_To_Head, Receive_Uppercut_To_The_Face; long Punch PRO takes we own but do not play |
| body reactions by side | liver, right ribs, body uppercut | 3 gut-shot folds, no side | 3 | owned Mixamo Receiving_A_Hit_To_The_Liver, Big_Rib_Hit, Receive_Stomach_Uppercut |
| block flinches (blocked punch rocks the man) | high / low x left / centre / right | Punch PRO Block_Straight_Hit v1-3 (off: rear glove over the head) | 3-6 | fix the owned three in the bake; owned Mixamo High/Low_*_Block |
| stumbles with steps | back, back-left, back-right, fold | none in Punch PRO | 4 | owned Mixamo Stumble_Backwards, Shove_Reaction; Punch PRO combo reactions with their hip travel |
| slips, ducks, pull-backs facing the man; parries | 4 + 2-4 | 6 dodges/weaves (they turn the back) | 6-8 | animo pack (8 parries, head-movement idles) |
| guard idles by style, dazed idle | 3-4 styles + dazed | 1 Punch PRO guard, 8 fidgets, 3 hurt idles (unused), 4 tired | 3-4 styles | animo pack (guards) |
| knockdowns to a knee (body), by side | 2-3 | 3 counts, 7 knockouts, knockout_v6 unused | 2 | owned Mixamo Kneeling_Down, Knocked_Down_To_Stomach |
| footwork | none in phase 1-4 | procedural rig (feet honest) + long takes (CMU, Rokoko) | 0 now | long takes only if the motion-matching trial runs |
| two men captured together | the only route past ~7.5 (r14 animator) | none | later | no pack found; our own capture |
Packs on the table (`MOCAP_PACKS_S439.md`): animo-mocap Boxing Animation Pack (Fab, EUR 58.57, 67 clips, all names
confirmed) covers the stepping, body, parry and guard rows; Punch Perfect (Unity, EUR 36.76 + VAT, 123 clips by the
developer's claim, no clip list, no rig named) is unknown until its preview is seen.
Buying rule (memory, S447): SEE THE MOTION BEFORE ANY BUY - watch the seller's own preview, judge stance width, guard
hands, punch distance and head on stills shown to the owner; no watchable preview = no buy. Before paying, read the AI
clause. After buying: bake through `tests/retarget_fidelity_test.gd`, then the census, then the eye check; a take that
fails stays out.

## 5. The phases, in order
| # | delivers | judged by | who | rough effort | before the purchase? |
|---|---|---|---|---|---|
| 0 | the raw-clips baseline (running): 4 films + rulers, the 1d table filled | rulers + owner's eye | Claude, PC (hidden desktop) | 1 day | yes |
| 1 | the clip census: `assets/data/clip_db.json` for every owned take (contact gap, hip travel, hand home, reaction size, posture flags), the bad takes listed, the final gap list | a test that every played take has a row; owner sees the dropped list | Claude (Godot tools exist: `tools/clip_contact.gd`, clip_recovery / clip_travel / punch_pace data); Qwen or Arena the checker + test | 2-3 days | yes |
| 1b | only if the baseline blames the conversion: knee, elbow and knockout fixes moved into the bake | `tests/retarget_fidelity_test.gd` + turntable stills | Claude | 2 days | yes |
| 2 | the choreographer (pure module + tests: distance plan, take choice, beat slide, body rules, reaction rules) | unit tests; golden-path counts equal the rules' | Arena or Goose (cloud), Claude reviews | 3-4 days | yes |
| 3 | the v2 player behind `-- fightplayer2`: root motion, one joiner, upper-body masks, straight IK, foot lock + rig | rulers (bars below), owner's eye, critics if allowed | Claude integrates; Grok Dev look fixes; Ziva an in-editor playtest | 1 week | yes, with owned clips |
| 4 | reactions and defence from owned clips: sized pools, block flinches, stumbles, hurt idles wired | same | Claude + PC seat | 3-4 days | yes |
| GATE | v2 must beat today's player by at least 1 point on the owner's eye and pass the rulers, or we stop and re-think | owner | owner | - | - |
| 5 | delete the replaced layers (1c), keep each one's test as a ruler on v2 | the kept tests stay green | Claude | 2 days | yes |
| 6 | the purchase: only the rows still empty, previews watched, baked, censused | eye check + rulers | owner buys; Claude bakes | 3-5 days | after 2026-11-30 |
| 7 | style idles; optional motion-matching trial for idles and footwork | owner's eye | Claude + PC seat on a worktree | 1 week, optional | partly |
Ruler bars for phase 3 (from the r14 critics): head jumps over 12 cm in one frame 0 outside a contact frame (14 today);
arm at full stretch at most 2 frames (4 today); head inside the other body 0 frames (3); distance between exchanges 1.5-1.8 m
(1.34); stance after a punch at most 1.3 x its rest length; reactions ordered jab < cross < hook in head travel.
Total: about 3-4 weeks of sessions to the gate with owned clips; the purchase fills in after. A GUESS, not measured.

## 6. Decisions only the owner can make
1. Build v2 beside today's player (today's kept as the control, the patch loop stops), or keep patching? (scope)
2. The MoCap Online licence asks for written permission for "any use ... in connection with artificial intelligence"
   (memory S495, `FIGHT_VIDEO_DATASET_S495.md`). Our blind critics are AI reading films of their clips. Write to MoCap
   Online for permission, or judge by our rulers and your own eye only? (money / legal)
3. End-of-November buy: the animo pack (EUR 58.57) after you watch its preview; Punch Perfect only if its preview shows the
   clips? (money)
4. Inside-range punches and two-man exchanges exist in no pack we found. Plan our own capture later, or live without? (scope, money)
5. Keep the stop rule: if v2 with our own clips does not beat today's fight by a point, 3D leaves the first release and a 2D
   view shows the settled fight? (scope)
6. A lower, closer side camera like Boxing Manager's: now, or after v2? (taste)

## 7. Risks, and what would stop or change the plan
- The baseline says the layers HELP (full stack beats raw): the rebuild stops; we fix the named takes instead.
- The baseline blames the clips or the conversion: phase 1 / 1b grow and the purchase matters more; the order still holds.
- No pack has short- and long-range takes: inside exchanges stay thin; the choreographer must avoid them or use trimmed takes.
- Deleting layers brings back faults the owner already flagged (sliding feet, gloves in heads, a glove over the head): every
  deleted layer's test stays as a ruler on v2, and nothing is deleted before the gate.
- The motion-matching add-on is untested on Godot 4.7.2 and is a compiled extension: optional only, on a worktree.
- Licence: AI critics on their clips (decision 2); the packs' own AI clauses (Fab "Allows usage with AI: No", Unity EULA
  2.2.1.1(g)). Bought files never go to the public mirror or into any AI tool.
- The ceiling: one-man clips joined well reach about 7-7.5 by the r14 animator's own estimate; 10 needs two men captured together.
- AI critic noise: three crosses in one film are noise (`NEXT_SESSION_PROMPT.md`); decide on rulers and the owner's eye.
- Budget and collisions: weekly usage was 77 % on S510; the animation-loop session owns `scripts/fight3d`, so v2 goes in its
  own folder; at most 3 PC agents; 500-line files.

## 8. Round 1 verdict and what it changed (S512, 2026-11-17)
Baseline (`FIGHTPLAYER2_BASELINE_S510.md`): raw clips 4.5 / 4.5 = placement only 4.5 / 4.5 = the full stack 4.5 / 4.5.
Table 1d row 1: the layers buy nothing, so the plan stands as written; no phase 1b (retargeting keeps the poses).
Scope critics, both over the 7 bar, so the build goes ahead:
| critic | will it work | order and size | file |
|---|---|---|---|
| Dola | 8 | 9 | `FIGHTPLAYER2_CRITIC_S512_DOLA.md` |
| Goose | 7 | 8 | `FIGHTPLAYER2_CRITIC_S512_GOOSE.md` |
Taken from their 10/10 lists (these are now part of the plan):
1. A foot-slide bar joins the phase 3 rulers: a standing foot travels under 1 m a round (RAW 33-37 m, shipped 0.2-0.4 m).
2. The choreographer never picks a take that leaves the arm IK more than 0.30 m to do; if no take fits, a visible
   step comes first.
3. Phase 4 is 1-2 weeks, not 3-4 days: 4a looks at every reaction, block and defence take on stills and fixes the
   table; 4b wires the pools.
4. Phase 1b is out unless a later film blames the conversion.
5. TiredSag stays until the owned tired idles are wired and judged.
6. New measures for the phase 3 rulers (Dola): how long a hit man cannot punch (jab 0.4-0.5 s, cross or hook
   0.6-0.8 s); control back 0.13 s after contact; a light foot hold, not a heavy lock.
7. What to expect, said plainly (Goose): v2 on owned clips about 5.5-6.5; with the purchase 6.5-7.5; past 7.5 needs
   two men captured together. Dola expects 6.5-7.0 on owned clips. The owner's bar is 7.0 with both blind critics.
8. Inside-range punches are no pack's: a later phase (own capture or a Cascadeur edit); the gate does not wait for them.
Phase 1 is done: `CLIP_CENSUS_S512.md`. Its findings that touch this plan: every owned punch lands from 0.53-1.03 m and
none carries a real step, so the feet close the distance first; the bought hooks pass under an upright man's chin; the
reaction pools come from the table by size and direction. Buy order: stepping punches, hooks at head height,
straight-back light reactions, longer uppercuts.
