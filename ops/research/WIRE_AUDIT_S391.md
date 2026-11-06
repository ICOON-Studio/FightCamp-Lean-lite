# Wire audit, S391 (2026-11-06, origin/main 6a8dbcd3)

Operator: "assign a sub agent to check the commits if anything is missing and wire up everything".
Checked against the code on origin/main, not commit messages or roadmap rows. "Lines on main" = the share of a branch's added
code lines found anywhere in main's .gd files: it catches code moved between files, it is not proof of behaviour, so behaviour
was checked separately.

## Counts

| Verdict | Branches (55) | Other items |
|---|---|---|
| WIRE | 1 (claude/footwork1) | 4 small changes: 3 lifted from claude/defflow1, 1 test list; plus af_walk on boxers (found while wiring) |
| DROP | 44 (38 + the 6 known) | 3 orphan scripts (Referee, BodyTurn, GroundRules) |
| NEEDS OPERATOR | 3 (defflow1, boxmap1, fightcard1) | PadWork + Mitts, the 7 owned mocap takes |
| Owned by other session | 7 (bjj9r12-r17 rounds, ground2a, theatre-ground) | GrapplePlayer DEFAULT_OFF layers, tap_out |
| Keep as is | - | 3 tools-only scripts (BalanceHarness, CardStage, TrainingWeek) |

The pure rule modules that looked like the likeliest misses are not misses: PaceAim, BodyTrack, ShortPunch, ProDebut and the Kalli
numbers are all live on main. No finished feature hides behind a switch outside scripts/grapple.

## Branches

Known DROP, not re-reviewed: agy/fight9r15, r17, r18, r19 (scored under R16, hand merged), qwen/sound1, sound1r2 (sounds hand-wired S390).

| Branch | What it does | State on main | Verdict |
|---|---|---|---|
| claude/footwork1 | Procedural bounce + step-drag | Never wired | WIRE: done, see below |
| qwen/paceaim1 | Pace and aim numbers | 97 % of lines; PaceAim called at LiveRound.gd:236, ShoutBar.gd:85 | DROP: collected, then tuned |
| qwen/bodytrack1 | Burn colours and words | Files identical; BodyBurn, BoutNight, BodyFigure call it | DROP: collected |
| qwen/shortpunch1 | Inside-range fist travel | Files identical; BeatFire.gd:131 | DROP: collected |
| qwen/prodebut1 | Pro debut money sheet | Files identical; Roster.gd:212, ProOffer | DROP: collected |
| qwen/kallinums1 | Combo cap, long gamble, graded card | 95 %; OwnCombos.gd:47-51, ComboStrip.gd:49 | DROP: collected, then reworked |
| qwen/ground3 | Paper ground fight | 99 %, collected 20b90407; no game caller | DROP: BjjMatch/BjjWalk do this, bible line 54 puts MMA out |
| qwen/noref1 | No referee, push-off | Replaced by the PushOff.gd in 5b2a4983 | DROP: superseded |
| agy/refbreak1 | Referee break, RefReach.gd | No referee in the ring (FightCast.gd:47) | DROP: feature removed |
| cursor/fight9r4 | Push-off without limb pass-through | Main's PushOff.gd is the 5b2a4983 rewrite | DROP: superseded |
| agy/fight9r1, r6, r9 | Early motion rounds | r7 kept on fight9base, rounds 1-8 superseded | DROP: no new file lost |
| agy/fight9r10-r14 | Motion rounds, 5 siblings | Each rebuilt from the base, 5-18 % of lines; PRs closed | DROP: R16 hand merge 9d7b8c28 replaced them |
| claude/locowalk3, cursor/locowalk1, 2, 4 | Ludo walk bakes for the count | No walk_*_guard clips on main | DROP: Ludo walks dropped S381, the rig does this now |
| claude/jabfix1 | One binary clip | Its own commit says not for merge | DROP |
| cursor/trainclips1 | Session cards | r5 on main (66237c8a) | DROP: collected |
| goose/issue-8 | Balance numbers | 100 % of lines | DROP: collected |
| goose/issue-10, 18 | Glove push smoothing | SOFT_M knee in GloveClear.gd:20; JoinSmoother collected | DROP: closed by Q-S294-89 |
| goose/issue-11 | TAKEFIX1 | e351fd2f; OFF_TAKES refilled on purpose S390 | DROP: collected |
| goose/issue-13 | PadWork + Mitts | Files identical (64fe0f55); feature orphaned, see scripts | DROP branch only |
| goose/issue-14 | Clinch rounds | Rejected r4; Ziva's version collected 9092e67d | DROP: superseded |
| goose/issue-16 | MovePlayer | 87 %, heavily evolved since | DROP: collected |
| goose/issue-17 | TellPose | On main, called at BeatFire.gd:49 | DROP: collected |
| goose/issue-48 | Corner lens | Identical, test in the suite | DROP: collected |
| goose/issue-53 | Desk Home review | The .md is on main; only the mockup .html is not | DROP |
| arena/c361ab64 | Fight words contract test | 97 %, in run_tests | DROP: collected |
| ziva/bodyreact1 | Body shot reactions | 98 %, 18b9a8cf | DROP: collected |
| ziva/footwork1 | Join smoothing (not the procedural footwork) | 100 % of lines | DROP: collected |
| ziva/smooth3-r4 | Reach and fade tuning | Reverted on its own branch; Q-S294-89 "stop tuning" | DROP |
| ziva/lean | Playtest reviews S311-S317 | Docs only, stale | DROP |
| claude/defflow1 | Matched defences + FLOW | See below | NEEDS OPERATOR: new mechanic, film failed |
| claude/boxmap1 | Boxing in the GrappleMap engine | Absent, 5.5k lines | NEEDS OPERATOR: he said "park it" |
| cursor/fightcard1 | Ring walks her onto the plan's card | Only CardStage.gd on main, one tool; no apply_card | NEEDS OPERATOR: 5 rounds failed, referee and camera parts obsolete |
| agy/bjj9r12, r13, cursor/bjj9r14, r15, r17 | Grapple rounds | Unmerged; BJJ9R18 started from R16 | Owned by other session |
| cursor/ground2a | GrappleContact round | 63 %; a later GrappleContact.gd is in use | Owned by other session |
| claude/theatre-ground | Bodies rest on the mat, SkinFloor.gd | Absent; operator C226 "this is beautiful" | Owned by other session; worth a look there |

Gap worth naming from fightcard1: the plan's ring card never moves the fighters on main. A real gap between the plan and the 3D fight,
but the fix is new staging work, not a merge.

### claude/defflow1 in detail

git cherry finds 0 of 40 non-merge commits on main; the other 4 are merges. Main lacks every new file: DefTable, DefenceMatch,
DefenceFlow, FlowStreak, FlowLive, DefFire, DefPose, FlowCue, BodyKeep, FootGeom, ShownTap and their 7 tests. Only 4 research docs
reached main. A read-only merge test shows 7 conflicts. The blocker is quality, not merging: r3 film verdict FAIL
(DEFFLOW2_R3_VERDICT_S386.md), blind critics gave round 2 a 3 against Undisputed's 7 and a 2 against UFC 6's 8.

| Behaviour | Branch | Main |
|---|---|---|
| Parry | Yes | No |
| Duck, duck in, smother, brace as answers | Yes | No (HitSnap.brace is a reaction, not a choice) |
| Slip, pull | Per punch and room | Old form: RoundStyle.gd:29 weights |
| Answer chosen for the punch | DefenceMatch.pick | No |
| Procedural defence layer | DefFire + DefPose | No |
| FLOW streak, replay, gold tag | Yes | No (filed as "needs OK", 3e9eb2d2) |
| Zero-mean stamina, legs cost, slower read | LiveRound, BodyLoad, TheRead | No |
| Planted feet in a defence | FootPlant, Footwork | No |
| Head kept out of the chest | BodyKeep, RingPlace floor | No |
| Punch-to-punch join, re-hit carry, live sway | PunchReach, HitSnap, RingPlace | No: separable, W1-W3 below |

## Scripts nothing loads

328 scripts under scripts/, 320 reachable from scenes/Main.tscn (preloads, load paths, class_name uses, comments stripped, unused preload
consts ignored). File level: a dead function inside a loaded file does not show.

| Script | Referenced by | Verdict |
|---|---|---|
| fight3d/Referee.gd (370 lines) | tools/ref_probe.gd; preloads in FightCast and TapeFilm unused | DROP: NOREF 5b2a4983. FightStage.referee and RingCamera.avoid are dead too |
| ui/BodyTurn.gd | 2 tests, 1 tool | DROP: last caller removed 4cb4b9ab (live holo off); body_tip_test needs it, so trim that first |
| rules/GroundRules.gd (383 lines) | Its test (BjjMatch names it in a comment only) | DROP: see qwen/ground3 |
| fight3d/PadWork.gd + Mitts.gd (525 lines) | 2 tools | NEEDS OPERATOR: finished, no screen plays it, using it means a new view |
| fight3d/CardStage.gd | tools/bake_flow_stills.gd | Keep: tool data |
| rules/TrainingWeek.gd | 3 tests, tools/bake_session_pics.gd | Keep: the bake reads it |
| rules/BalanceHarness.gd | 5 tools, 1 test | Keep: dev tool |

Assets: the 7 takes in assets/anim/baked/owned are in no game script (NEEDS OPERATOR; they also touch the clip licence list).
Tests outside the suite: body_tip_test, session_pics_test (W4), grapple_attacker_test (other session).

## Switches

- No `ENABLED := false`, `const X := false`, `if false` or environment gate anywhere in scripts/.
- GrapplePlayer DEFAULT_OFF (idle, sep, carry, impact, route): off limits here, named only.
- FightIntro `fromcorners` / `from_corners`: only film tools and probes set it, so CornerStart never runs in play. By design, but see below.
- Debug or probe arms, no feature behind them: elbowsalways, bentwrist, onepass, ropelog, show3d, film=, look=, auto=1, plan=1, TestJump jumps.
- BeatClips.OFF_TAKES holds 19 takes off on purpose (S390, reversible).

## Claims of done that main does not match

| Claim | Found on main | Note |
|---|---|---|
| "every finish ends in a tap (GrappleFinish.tap_out)", S390 block | tap_out has no game caller, only tests/grapple_attacker_test.gd:39; BeltMatch.gd:208 uses squeeze | Name stale, squeeze documented to carry the tap, not traced end to end. Other session's |
| roadmap done_recently, 12 rows | 9 not on main: FIGHT9R10-14, BJJ9R13, 14, 15, 17 | Means "ran", not "shipped". Only FIGHT9R16, BJJ9R16, BJJ9R18 landed |
| "R16 merged" | Partly: 8 of 39 KneeTrack lines; replay timing retuned S390 | The 6.5 film was R16's own tree, not main's: do not quote it for main |
| "KnockdownCount.gd and GrappleBrowser.gd over 500 lines" | Also MovePlayer 648, GamePlan 550, GrappleFinish 545, MatTreeInfo 502 | List incomplete |
| CLAUDE.md:71 "4 weeks below $0 closes" | GymBills.gd:14 says 8 (S327) | Stale since S327 |
| OWNED_MOCAP_S381 7 takes | Merged, nothing plays them | The doc is honest; easy to read as done |
| Rule "no casual walk on boxers" (S377) | CornerCrew.walk played af_walk on boxers in the game's real intro and corner minute | Found while wiring, see below |

Spot checks that held: GrappleDrawn.track, LOCKED IN, --rating, sounds hand-wired, Playbook tab 7, PosterReveal, Ana after week 1, Records page,
Camp Board proposal only.

## WIRE list

| Item | What | State | Proof |
|---|---|---|---|
| F1 | claude/footwork1 into the ring (RingFeet.gd, split rig, Footwork range steps) | Wired, default ON | ring_feet_test, boxer_footwork_test, tools/ring_feet_probe.gd, films below |
| F2 | af_walk off boxers: CornerCrew.walk steps them on the rig (full intro, corner minute, CornerStart); count walker too | Wired | corner_start_probe 0 failures (ball slide mean 0.014 m/s), knockdown_film walk 2.93 m |
| W1 | Punch-to-punch join (defflow1 PunchReach.gd) | Wired | hit_gap_probe 3 of 34 past 0.15 m, same as before |
| W2 | Re-hit carry (defflow1 HitSnap.gd) | Wired | body_react_probe PASS, 48/48, worst curl 22.3 (bar 18) |
| W3 | LIVE_SWAY head sway at every range | NOT wired: the coordinator's new upper-body layer owns leans between punches; two sways would fight | - |
| W4 | body_tip_test, session_pics_test into the suite | Wired | both green on first run |

## Footwork, how it is wired

- The fight still decides where she stands (bx["pos"], Footwork.walk, RangeBreath). Nothing it decides changed. RingFeet.tick chases that place with step
  pairs (BoxerFootwork.go), and RingPlace shows the body over the feet (RingFeet.shown), so the body travels only as far as the feet go down.
- Stack: JoinSmoother, TiredSag, BoxerFootworkUpper (hips, lean, lag, nod, twist), GuardTuck, PunchReach, HitSnap, GloveClear, ElbowClear, KneeTrack, FootPlant,
  BoxerFootworkRig (legs), FloorClear, twist. The hips and torso run before the arms' IK, or every landed glove would miss by the bounce.
- FootPlant stays under the rig. The rig lets go (want 0, eased 0.2 s) for knockout, fall, countdown, win clips, from the tie-up on, and in a scene for anything
  but her guard.
- Steps at punching range: Footwork._range_steps, phases pocket, in (the other boxer), inside. With the rig a step waits for the feet to land the last one.
- A punch drives off its foot (heel up, foot turned in on its ball); a planted leg at full reach lifts its heel instead of dragging the foot.
- Control arms: `-- nofootwork` = the S320 glide on FootPlant; `-- stepclips` = the old stride clips. The Playbook's MovePlayer keeps FootPlant (rig_on false).

## Measured, 170 s of a real bout (tools/ring_feet_probe.gd, headless with show3d)

| Bar | Result | Control arm (`nofootwork`) |
|---|---|---|
| Planted skate, mm a frame p99 | 4.8, 4.2 (0.00 before the boot spacing; the nudged foot sits at full reach) | clips scored 4/10 for skating |
| Feet crossed, frames | 0 of 5,106 | - |
| Standing balls under 0.2 m of the other's | 12 of 5,106 frames (1,439 before the boot spacing) | - |
| Knee p99 / locked past 170 deg | 160 / 0 % | 164 / 0.1 % |
| Feet moving, share of the round | 55 %, 55 % | real boxers 53-56 %; the S311 note read ours at 8-9 % |
| Step pairs a minute | 149, 140 | - |
| Body off its place, p90 | 0.13-0.20 m | - |
| Knee shake, the standing leg | 3.6 | 3.6-3.9 (all legs): no tremble added |
| Glove to target at contact, p50 / past 0.15 m | 0.03 m / 5 of 40 | 0.02 m / 3 of 40: two more misses, all on hooks and body shots |

Other checks with the rig on: clinch_check 6/6; body_react_probe PASS (48/48, worst curl 22.3, bar 18); corner_start_probe 0 failures (now read on the ball of
the foot, as the heel pumps on purpose: slide mean 0.014 m/s, bar 0.10); corner_film 0 failures (gloves touch 0.065 m, hips on the stool); boxer_footwork_test,
ring_feet_test green, orthodox and southpaw on the drawn skeleton.
knockdown_film reports two FAILs that are in the control arm too, so not from this work: "the fall starts after the shot lands (0.17 >= 0.24)" and
"the knocked-out boxer stays on the canvas (head at most 1.5 m)", though the KO film shows him down to the end of the count. Not checked on a clean main checkout.

## Films watched (E:/FightCamp/tmp/s391/feet, eyes bursts)

| Film | What | Timestamps |
|---|---|---|
| r5/r5_final.mp4 | Final code, broadcast lens, men | 0:13.3-14.7, 0:29.3-30.7 |
| r4/r4_side.mp4 | Side lens: cross drives off the rear heel; inside hook | 0:18.5-19.3, 0:26.6-27.4 |
| r3/r3_side.mp4 | Side lens, steps at range | 0:12.2-13.8, 0:23.2-24.8 |
| r2/r2_intro.mp4 | The game's full intro: walk to the corner and the centre in guard | 0:06.9-9.1, 0:22.3-24.3 |
| r1/film.mp4 | Corner walk | 0:03.0-4.6 |
| kd/kd_count.mp4, ko/ko_end.mp4 | Fall free, count, walk to the neutral corner, BOX!, KO stays down | sheets, 0:09-0:34 |

Eyes score for the footwork in a real fight: 6.5/10 (no blind judge yet). Still wrong: pro_body_shot drops the hips to 0.59 m with the rear foot held, so the rear
knee comes to 0.19 m off the canvas (0:19.8 of r1); steps are one even step-drag, no feints or stance switches; a nudged foot lands off the stance; at round's end boxers
walk to the stool in their guard, which obeys the no-casual-walk rule but is a taste call.
