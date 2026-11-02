# S137 WIRING AUDIT - what is built but does not reach the player's game (Claude, 2026-10-01)

Operator, verbatim: "Do not build another exe unless everything we've built so far is all gated to the gym, fight and
the fight engine. Do a thorough check what other mechanics are built and are not gated the game."
Reading taken: "gated" = WIRED - a built mechanic must run in the game the player gets (boot -> career -> fight).
RULING RECORDED: no new .exe until the PLAYER-FACING and FIGHT rows below are wired or explicitly parked by the operator.

## Method (re-runnable)
1. `python Tools/wiring_census.py` - scripts reachable from project.godot's main scene + autoloads, following res:// paths
   and class_name uses, comments stripped. 254 of 283 reachable; 29 UNREACHED.
2. GameState function census (S137 scratch script, re-run before acting): 356 public `func`s; 128 never named by any other
   shipped script/scene; 44 of those are not called inside GameState either = unreachable actions (dynamic callers
   HomePinReads._call / ProfileRevampPanel._call take literal names, so the census holds).
3. Option switches defaulting OFF and not in `FightRealtime.DEMO_SWITCHES` / room `demo_switches_on()`.
4. Record sweep (digests S1xx, topics, DECISION_LEDGER, roadmap) for "built, never wired" - each row re-checked against
   HEAD 6f067f37. Spot-checked in code: personality (0 fight files), technique effect keys (0 hits), entry_safety_gates
   (0), walkout_enabled false (FightNightIntro:42), rivalry heat absent from FightRealtime, boxing_feint bound to idle.

## A. FIXED THIS SESSION
- Arenas: six G74 venues (R1-R6) were built but FightNightScreen never passed `venue` - every career bout ran in the grey
  void. Now VenueLadder: regional / national / international (commit 6f067f37).

## B. PLAYER-FACING, BUILT, NOT WIRED (wire before the exe)
| Mechanic | Built in | Missing |
|---|---|---|
| Judges' scorecard after a fight (ScorecardPanel, 408 lines) | U24 | a caller on the result screen (judges now disagree, G152) |
| Live fight HUD: heart rate, trauma pips, attrition (FightHudPanel, 534) | U25 | mount in the 3D room (check against the room's own HUD) |
| Medal table, honours board, title tenure (MedalTable, HonoursBoard, TitleTenure) | G25/G26/G21 | fighter card / office caller |
| Fighter portrait = the same seeded man as the ring (FighterPortrait) | S93 | fighter card caller |
| Injury ledger words, stat-shape words, ring/cage/mat words, contest length, competition age (LedgerWords, SpreadWords+StatSpread, SurfaceWords, ContestLength, CompetitionAge) | Q5/Q7/Q8/C76/G24 | callers on the card / booking / rules screens |
| Arena fits the gym room (ArenaFit) | G20 | gym building caller |
| 44 GameState actions with no button: accept/decline promotion bout, accept short notice / pass, accept signing offer, contender series invite, renewal / retention offers, sponsorship offers list, media questions + answer, weight-cut plan + act on it, Grand Prix bracket, rivalries list, championship read, cancel booking, poach match, release coach, cancel development programme, world coaches/prospects/market/organisations/summary, knockdown ledger, promoter goodwill, estimate win chance | various | a screen action or read for each (list: S137 scratch census) |
| Live walkout shot (WalkoutShot, C207) | C207 | `walkout_enabled` false "until the hall has a crowd" - the venues now have crowds |
| Gym theme music (Ludo pilot) | S92 | not in the playlist folder; operator ear test pending |
| Skill band words (D23) | S79 | StatWords still POOR/FAIR/STRONG/ELITE |
| Stat legend tooltip | C44 | a caller |

## C. FIGHT ENGINE - BUILT DATA THE FIGHT IGNORES
| Mechanic | Missing |
|---|---|
| Personality (8 labels) | no fight file reads it - a Fearless and a Reserved man fight the same (R147) |
| Rivalry heat | read by the legacy FightSimulation only; the live engine (FightRealtime) never reads it |
| 47 technique effect keys on 140 nodes (finish_chance, cut_chance, stop_hit, pushback...) | no effect processor (Q68) |
| Training strands | fed by every rep, read by nobody in the fight (R147) |
| Speed in the transition decision | FightIntent never reads speed (R149) |
| Engine feints | engine throws ~7/min; the room shows none (binding = idle) |
| Skill consistency (spread narrows with skill) | legacy engine option only |
| Plan roles for KB/MMA | boxing only (Q193/Q194) |
| entry_safety_gates, progression rules, age limits in data | no enforcement code - G153 (Grok, fight gate) in flight |

## D. FIGHT LOOK - BUILT, OFF BY A RECORDED VERDICT (stay off unless the operator re-opens)
hit_physics (C188 failed its gate), foot_pivot (S131 no effect), human_speed_tempo (U164), readable_onset (U165),
strike_speed_caps (U160, operator A/B never given), standing_sources_v1 (C203 pending review), separation_strip_velocity
(S62), Marpa venue_art (MMA - not the boxing demo).

## E. DEV TOOLS - correctly not in the game
FightClipAudit, U162RetargetSpeed, FightAnimLabScreen, UIKitGallery, ApproachSweep, ApproachBand, CapsulePresence,
CapsuleCoverage, CapsuleDistance, capsule_overlay; research instruments FightPoseDOF, FightAnchorBake, FightAnchorIK,
FightPairedAnchor, MatRig (mat rulesets - not the boxing demo).

## F. ACQUIRED, NEVER BOUND (content, not code)
45 Meshy clips, 15 Seedance boxer videos, 7 suit grappling videos, 361 Mixamo clips, QuickMagic guard pass, Harmony4D;
C199 closed guard; BJJ C134/C137/C138 branches; Q175 clinch; 12 uncertified boxing moves (C229 Codex on 2 now).
