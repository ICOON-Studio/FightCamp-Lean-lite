# REALISM1 - BLOCKED before the first presentation fix

Baseline: master = origin/master = codex/realism1 at 3dcc7be7d0c82c0f00e9f458e23e5033bd01eaca.
Observed 2026-10-12, dedicated E:/FightCamp/wt/REALISM1 worktree. No .gd, tests, phase data or certificates changed.

The task requires C223 before the first fix. Its exact production command (with --jobs 1 added as instructed) selects
100 raw audition candidates per rig, rather than a bounded certified palette. It reports four failed retarget references:
combat_cross, combat_hook, combat_long_hook, combat_right_hook. All eight required source/reference GLBs below are absent;
git ls-files and git ls-tree HEAD return no tracked source to restore. Assets and C223 tooling are outside task ownership.
No checks were weakened or removed, no candidate filter was substituted, and no editor import was run.

## External blocker

Under Godot/assets/anim/c223/mixamo_pipeline_a/:

- Cross_Punch__A_Cross_Punch.glb and Cross_Punch__A_Cross_Punch_rest.glb
- Hook_Punch__A_Hook_Punch.glb and Hook_Punch__A_Hook_Punch_rest.glb
- Hook__Long_Hook_Punch_To_The_Head.glb and Hook__Long_Hook_Punch_To_The_Head_rest.glb
- Right_Hook__Right_Hook_Punch_From_Idle.glb and Right_Hook__Right_Hook_Punch_From_Idle_rest.glb

Tools/c223_parallel.py production --jobs 1 -- report=E:/FightCamp/tmp/realism1_c223.json was stopped after confirming
these errors. The runner strips the directory from report= and writes under previews/c223/; no merged
four-rig report was produced. A complete before/after pass-count comparison is unavailable. Partial welter_a only:
13 rows, 1 mechanical pass, 0 accepted. These are NOT certified palette pass counts.

```text
ERROR: C223 retarget reference failed combat_cross
ERROR: C223 retarget reference failed combat_hook
ERROR: C223 retarget reference failed combat_long_hook
ERROR: C223 retarget reference failed combat_right_hook
```

## The 13 checks: before and after

After is not run: there were no presentation fixes because the mandatory pre-fix gate is blocked.
The three population gates plus ten gated rules form TOTAL=13. R6 is informational and is included below separately.
R8 passes with zero paired contacts; this does not establish fist reach on a populated sample.

| Check | Before | Bound / basis | After |
| --- | --- | --- | --- |
| Population: different men | PASS; out-boxer vs pressure puncher, distinct stats and frames | Never identical | Not run |
| Population: legal booking | PASS; 66.0 / 66.5 kg | Welterweight <=66.7 kg | Not run |
| Population: bouts finish | PASS; 3/3, 59,406 frames | Every seeded bout finishes | Not run |
| R1 exchange rhythm | FAIL; active 1.76 s, inactive 4.70 s | 0.8..1.6 / 1.4..3.2 s; JPES 2016 art178 | Not run |
| R2 stance takes | FAIL; A=1, B=1 | >=3 each; operator spec, no study | Not run |
| R2b never frozen | PASS; A=0.0%, B=0.0% | <=2% each; physiology | Not run |
| R3 planted-foot skate | FAIL; mean 0.238, p95 1.519 m/s, n=63,808 | Mean <=0.10 m/s; physics/Q49 | Not run |
| R3b canvas | FAIL; 23/118,812 frames, deepest -0.071 m | No toe below -0.0263 m; physics/Q87 | Not run |
| R4 guard return | PASS; 473/476 exits (99%) | >=90%; Menzel/Potthast 2021 | Not run |
| R5 join speed | FAIL; LeftUpperLeg 11.80x, 5,194/440 deg/s | <=1.2x each joint; own authored motion | Not run |
| R5b same-frame join speed | FAIL; LeftLowerLeg 6.14x, 5,266/857 deg/s | <=1.2x each joint; same authored frames | Not run |
| R7 overlap | FAIL; 2,106 violating frames / 59,406 (3.5%) | Zero >0.02 m violations except contact glove window <=0.13 m; physics/Atha 1985 | Not run |
| R8 paired fist reach | PASS; 0 landed, 0 reached | Test's empty paired-contact arm; Q97/K50/K52 | Not run |

## Exact rule result blocks (study, threshold, measured values)

```text
RULE R1 space_between_exchanges | GATED S4a | FAIL
    study:    JPES 2016 art178 - boxing time-motion, World Championship later winners, 64/69/75 kg (J28, K29)
    real:     active 1.2+-0.8 s; inactive 2.3+-1.8 s; inactive >4 s averages 5.6+-1.7 s about 7.6 times a round
    bound:    mean inactive 1.4..3.2 s and mean active 0.8..1.6 s (study mean +- half an SD; a pause under 0.3 s joins its exchange - INFERENCE)
    label:    DOCUMENTED (bout); range width INFERENCE
    measured: active 1.76 s (n=247, p95 3.70); inactive 4.70 s (n=238, p95 12.50); inactive >4 s: 11.7 per round

RULE R2 stance_takes | GATED S4a | FAIL
    study:    NO STUDY - what neutral consists of is NOT FOUND in any bout study (J28, K29 GAPS)
    real:     none; the operator's realism spec: rotate several stance takes the way react_head rotates four
    bound:    at least 3 distinct stance takes seen per man
    label:    OPERATOR SPEC (no study)
    measured: A 1 takes ["idle"]; B 1 takes ["idle"]

RULE R2b never_frozen | GATED S4a | PASS
    study:    PHYSIOLOGY - a standing athlete is never motionless (quiet standing always sways; boxers in neutral bounce and step: Dunn 2017 via K29, unverified by Claude)
    real:     no bout number for 'frozen'; bouncing and stepping fill most of a round (K29)
    bound:    a stopped clip holding its last frame on at most 2% of frames per man
    label:    PHYSIOLOGY (no bout number)
    measured: A 0.0% frozen, B 0.0% frozen; 0 frames lying on the canvas after a knockdown, not counted; frozen on: {  }

RULE R3 planted_foot_skate | GATED S4a | FAIL
    study:    PHYSICS - a foot bearing weight has zero ground velocity; 0.1 m/s is the planted threshold Q49 found in practice
    real:     0 m/s
    bound:    mean horizontal speed of the lower toe while it is within 5 cm of the canvas (its rest height) at most 0.10 m/s
    label:    PHYSICS; threshold INDUSTRY (Q49)
    measured: mean 0.238 m/s, p95 1.519 m/s over 63808 planted frames; most skate by take: idle 0.16 m/s x57627, boxing_jab 0.93 m/s x901, react_head 0.82 m/s x842, boxing_cross 0.87 m/s x766, boxing_rear_hook 0.74 m/s x756

RULE R3b feet_above_the_canvas | GATED S4a | FAIL
    study:    PHYSICS - a foot cannot pass through the canvas; Q87 measured the bound clips themselves, unblended, through production: the deepest any takes a toe is 0.0263 m under its rest height (a pivot foot)
    real:     0 frames below the canvas
    bound:    no frame with the lower toe more than 0.0263 m under its rest height - anything deeper is made by the room, not the clips
    label:    PHYSICS; bound DOCUMENTED (Q87)
    measured: 23 of 118812 frames under the bound; deepest -0.071 m at seed 51227 A f14778 boxing_slip after boxing_slip; by the take 0.20 s earlier: { "idle": 14, "react_body": 1, "loc_strafe_left": 1, "boxing_rear_hook": 1, "loc_retreat": 1, "boxing_slip": 2, "loc_advance": 3 }

RULE R4 back_in_guard | GATED S4a | PASS
    study:    Menzel & Potthast 2021 (Sensors) - experienced boxers, n=11, single maximal punches on a BAG; return-to-guard in a BOUT is NOT FOUND (K29)
    real:     retraction to guard: cross 169+-41 ms, hook 168+-97, uppercut 171+-33, jab 262+-42; in combinations the next punch starts at the previous impact
    bound:    90% of punch exits: into anything but a punch, hand within 25% of its extension and at least mean-1SD after the peak (jab 220 ms, others 128 ms); into a punch, extension complete; into a hit reaction, not judged (J19, K30: the reaction starts at contact)
    label:    LAB (bag), not a bout; the 25% and 90% are INFERENCE
    measured: 473 of 476 exits pass (99%); 35 hit mid-punch, reported only (J19, K30); 0 kicks reported only (no bout study; Robalino 2025 LAB roundhouse return ~400 ms); 7 without an extension skipped; first failure: boxing_jab_body -> neutral: hand 0.12 of 0.28 m out, 1367 ms after the peak; failures by kind: { "into neutral: not home": 2, "into a strike: its own extension frame not reached": 1 }

RULE R5 joins_move_like_the_performance | GATED S4a | FAIL
    study:    DERIVED FROM THE CLIPS' OWN MOTION - the bought performance is the human reference; no study gives a blend time (J28 NOT FOUND; G57/J19 found engine defaults only)
    real:     each joint's own p99 angular speed across every frame of every clip, as authored, played unblended
    bound:    in the 0.35 s after any change of take - except into a hit reaction or a knockdown, which moves at the blow's speed (J19, K30) - each joint's p99 speed at most 1.2x its own clip p99 (factor INFERENCE)
    label:    DERIVED (the performance); factor INFERENCE
    measured: worst LeftUpperLeg at 11.80x; over the bound: Hips 988/400 deg/s, Spine 1012/580 deg/s, Chest 1346/644 deg/s, UpperChest 1346/662 deg/s, Neck 890/463 deg/s, Head 584/355 deg/s, LeftUpperArm 1602/674 deg/s, LeftLowerArm 1536/715 deg/s, RightUpperArm 1742/635 deg/s, RightLowerArm 1571/651 deg/s, LeftUpperLeg 5194/440 deg/s, LeftLowerLeg 5266/448 deg/s, RightUpperLeg 4345/519 deg/s, RightLowerLeg 4574/536 deg/s; configured blend 0.10 s (a setting, not an observation)

RULE R5b joins_against_the_same_frames | GATED S4a | FAIL
    study:    DERIVED FROM THE CLIPS' OWN MOTION - as R5, but the reference is the incoming take's authored speed at the same frames
    real:     the seen motion equals the performance's own at every join frame (ratio 1.0)
    bound:    in the same windows as R5, each joint's p99 speed at most 1.2x the incoming performance's own p99 over those very frames (factor INFERENCE, as R5); R5 and R5b both gate (operator, 2026-09-13)
    label:    DERIVED (the performance, same frames); factor INFERENCE
    measured: worst LeftLowerLeg at 6.14x; over 1.2x: Hips 988/798 deg/s, LeftLowerArm 1536/1150 deg/s, LeftUpperLeg 5194/857 deg/s, LeftLowerLeg 5266/857 deg/s, RightUpperLeg 4345/1121 deg/s, RightLowerLeg 4574/1502 deg/s; R5's reference is 85% idle frames (99375 of 117264)

RULE R6 ring_movement | REPORT S4 | INFO
    study:    Schortgen ECSS 2023 - French elite boxing, 32 fights (conference abstract, via K29); Thomson via M18
    real:     distance between the men 1.23+-0.16 m; 155+-28 m travelled per round (~0.86 m/s); mean ring speed 0.6 m/s
    bound:    none yet - S4 feeds the engine's 2D positions into the room
    label:    DOCUMENTED (abstract) / SECONDARY
    measured: mean body speed 0.448 m/s (p95 1.882); mean distance 1.24 m (p5 0.67, p95 2.15)

RULE R7 bodies_never_pass_through | GATED S4a | FAIL
    study:    PHYSICS - two bodies cannot occupy the same space; U95 capsule instrument (2 cm threshold); a glove travels ~11 cm past first contact (Atha 1985 BMJ, via K50/K52)
    real:     the men do not interpenetrate; at a landed blow the fist follows through ~0.11 m while the target yields
    bound:    no pair deeper than 0.02 m except a glove in its owner's contact window (+-3 frames), and that at most 0.13 m (0.11 m follow-through + the 0.02 m threshold)
    label:    PHYSICS / DOCUMENTED (Atha 1985, one punch) / INFERENCE (the window and the cuff)
    measured: overlap share 3.5%, violating share 3.5%, allowed-contact depth p95 0.000 m; top violating class pairs: arm>hand(2039 f=22,22,60,61,61,62,62,64); arm=arm(1381 f=62,62,63,63,64,64,86,86); hand>torso(636 f=61,61,86,87,103,103,130,130); hand=hand(620 f=60,202,203,206,210,215,218,220); leg=leg(252 f=3182,4366,4366,4366,4786,4787,4787,4787)

RULE R8 the_fist_reaches_its_target | GATED S4a | PASS
    study:    PHYSICS - a blow that lands touches its target; Q97 (our straights pass 0.3-0.4 m low, hooks 0.3 m wide); K52: straights land on the jaw/lower face, hooks on the side of the jaw (Walilko 2005, Viano 2005, Cournoyer 2019)
    real:     a landed blow puts the glove on the jaw or face (straight, uppercut), the side of the jaw or temple (hook), the trunk (body shot)
    bound:    every landed hand strike's glove comes within 0.02 m (the U95 threshold) of its target part's surface by contact
    label:    PHYSICS / DOCUMENTED (K52 impact points)
    measured: landed 0, reached 0 (0%), gap p10/p50/p90 0.000/0.000/0.000 m
TOTAL=13 fails=7
FAIL
```

## Every completed runner result line

```text
CHECK total=2 fails=0 autoload_refs=0 autoload_warnings=0 time=2s
[  1/1] FAIL   fight_stage_realism_test.gd                  rc=1
SUITE total=1 fails=1
[  1/22] PASS   bench1_test.gd                               
[  2/22] PASS   certified_palette_test.gd                    
[  3/22] PASS   fatigue_body_read_test.gd                    
[  4/22] PASS   fatigue_curve_test.gd                        
[  5/22] PASS   fatigue_posture_test.gd                      
[  6/22] PASS   fight_stage_director_test.gd                 
[  7/22] PASS   fight_stage_fatigue_switch_test.gd
```

The broader baseline was stopped at 7/22 completed tests after the external blocker was confirmed; its in-flight test
has no result line and no overall suite result exists. The standalone realism baseline was allowed to finish all three
bouts. All completed lines above were before any edit. No after suite or after C223 run was made.

## Engine and workflow

The first runner invocation selected Chocolatey's godot shim and therefore its console sibling; that incomplete run was
stopped. Explicit GODOT_EXE was then used for parse and the completed baseline. Sandbox LOCALAPPDATA points to
E:/FightCamp/codex_localappdata and reading the user Programs directory was denied. The actual non-console Chocolatey
4.7.2 executable and the task's C:/Users/user/AppData/Local/Programs/Godot/Godot_v4.7.2-stable_win64.exe were verified
byte-identical: SHA256 AB1824F85BFD8E0E4128182C000C4003A3E042245B2967848D089B2A04B22424.
No editor import, windowed run, image viewer, browser or Explorer was used. Only task-owned process trees were stopped.

No HANDOFF block was edited: this is a document-only blocker report, per agent entry rules. REALISM1 remains BLOCKED,
not complete. The branch contains this digest and its blocker/message records only; no master push.

## Left undone / resumption condition

Restore the eight raw GLBs, or have Claude correct TASK_REALISM1's required C223 invocation to the intended certified
production scope. Changing that requirement or creating/replacing these assets is outside this task's owned files.
Then obtain a complete C223 baseline before the first fix, resolve all seven presentation rules, commit after each rule
turns green, run all 22 regression tests with --jobs 1, compare C223 before/after counts, and publish the implementation.
No threshold or study dispute is asserted here.
