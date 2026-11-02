# G156 — Wire the rest

A decision the player can make, and a sentence that explains a number already on screen, now runs in the career the player gets. Boot, then the gym, the day, the desk, fight week, the scale. `GameState.gd` and `UIKit.gd` are untouched. The new buttons call the actions that were already there.

## Census, before

`python Tools/wiring_census.py` on this branch before the wire. 288 scripts, 262 reachable, 26 unreached. Roots: `scenes/BootRoot.tscn`, `GameState.gd`, `UserSettings.gd`, `CompetitionData.gd`, `FeedbackOverlay.gd`, `TipLayer.gd`, `CoachMarks.gd`, `SceneRouter.gd`, `DevJump.gd`, `FightAudio.gd`.

Word modules are `RefCounted` statics with no `class_name`, so they count as reached only when a shipped script preloads them.

Unreached then:

| Lines | Script | What happened |
| --- | --- | --- |
| 528 | `FightHudPanel.gd` | Parked. See below. |
| 398 | `ScorecardPanel.gd` | Parked. |
| 326 | `FightClipAudit.gd` | Dev tool. Stays unwired. |
| 303 | `U162RetargetSpeed.gd` | Dev tool. |
| 300 | `MatRig.gd` | Dev tool. |
| 221 | `FightAnimLabScreen.gd` | Dev tool. |
| 214 | `UIKitGallery.gd` | Dev tool. |
| 205 | `FightPoseDOF.gd` | Dev tool. |
| 202 | `FightAnchorBake.gd` | Dev tool. |
| 169 | `StatSpread.gd` | Wired, through `G156Wire`, on the profile shape frame. |
| 154 | `FightAnchorIK.gd` | Dev tool. |
| 128 | `ApproachSweep.gd` | Dev tool. |
| 111 | `ArenaFit.gd` | Wired, on the gym expand row. |
| 107 | `FighterPortrait.gd` | In flight (U208 / U209). Not touched. |
| 104 | `FightPairedAnchor.gd` | Dev tool. |
| 103 | `CompetitionAge.gd` | Wired, on fight week. |
| 67 | `SpreadWords.gd` | Wired, on the profile shape frame. |
| 67 | `ApproachBand.gd` | Dev tool. |
| 62 | `SurfaceWords.gd` | Wired, on fight week. |
| 62 | `CapsulePresence.gd` | Dev tool. |
| 60 | `RingPlace.gd` | Parked. No player decision. The live room places bodies in 3D. |
| 53 | `LedgerWords.gd` | Wired, on the profile shape frame. |
| 52 | `ContestLength.gd` | Wired, on fight week. |
| 48 | `CapsuleCoverage.gd` | Dev tool. |
| 45 | `CapsuleDistance.gd` | Dev tool. |
| 25 | `VenuePhotos.gd` | Parked. The map is empty and the fallback path is blank, so a caller would show an empty frame. |

GameState public-func census, same moment (comments stripped, shipped scripts and scenes only): 363 public funcs, 121 never named outside `GameState.gd`, 33 of those also never called inside it.

| Line | Func | Now |
| --- | --- | --- |
| 362 | `get_world_summary` | Read on the offers desk (`WorldReads`). |
| 404 | `get_world_market` | Same, the market name when it has one. |
| 422 | `get_world_prospects` | Same, the count. |
| 699 | `get_world_coaches` | Same. |
| 708 | `get_world_organizations` | Same. |
| 776 | `get_organization_fighters` | Same, and only for an id the org list actually returned. |
| 1975 | `set_weight_cut_plan` | Three icons on fight week. |
| 1988 | `act_on_weight_cut` | Four icons on the open weigh-in. |
| 2518 | `get_world_event_detail` | Offers desk, and only for a real event id. |
| 2938 | `event_has_available_slot` | Same. |
| 3296 | `cancel_pending_new_career` | Abandon icon on the new-career board, only while a slot is pending. |
| 3760 | `get_used_floor_area_m2` | The arena-fit line above Expand. |
| 4191 | `move_decor` | Arrow on a hung wall piece that has a free slot. |
| 4392 | `mark_objective_complete` | Parked. Legacy stub. Weekly objectives use `claim_objective`. |
| 4426 | `set_selected_ruleset` | Parked. The settings board says the ruleset is read-only. |
| 5087 | `assign_training` | Parked. Superseded by `set_week_program_day`. A second button would write the week twice. |
| 5139 | `get_technique_training_options` | Called when the skills strip builds. The tree already lists the nodes, so no second catalogue is drawn. The count is stored on the strip. |
| 5216 | `get_discipline_training_options` | Gates the discipline icon. Shown only when a program is ready and none is active. |
| 5240 | `assign_discipline_training` | That icon. |
| 6766 | `cancel_development_program` | Cancel icon on the skills strip while a target is set. |
| 9783 | `force_request` | Parked. Dev injector. |
| 9826 | `get_rivalries` | Offers desk, only when the list is not empty. |
| 9917 | `get_gym_rivalries` | Same. |
| 11034 | `get_athlete_knockdown_ledger` | Offers desk, only when scored or suffered is above zero. |
| 11128 | `get_promoter_goodwill` | Offers desk, only when the dict is not empty. |
| 12268 | `get_grand_prix_bracket` | Offers desk, only when a grand-prix event has a tournament and the bracket has rounds. Otherwise no `Bracket` node. |
| 12488 | `get_media_questions` | Day feed. Nothing open, no card. |
| 12553 | `answer_media_question` | The answer icons on that card. |
| 13981 | `get_championship_read` | One real belt from `get_simulation_world`, weight class and discipline only. |
| 14598 | `cancel_fight_booking` | Cancel icon on a booked fighter's card. |
| 15110 | `get_athlete_cash` | Offers desk, the first roster fighter. |
| 17268 | `get_shortlist` | Offers desk, only when it is not empty. |
| 17584 | `release_coach` | Release icon on the selected coach. |

Already wired before this task, left alone: medal table, honours board, title tenure (Q223); the offer desk (G154); personality and rivalry heat in the fight (C230, S138); week in review (U205); camp consequences (G155).

## Parked, and why

`FightHudPanel` stays off the fight. The live room's HUD is `FightNightScreen` (round clock, 1x/2x/4x, sim to result). K83 (`research/bots_s138/kalli.txt`) is the scorebug, and that spec is still in progress. Mounting the heart-rate / trauma / attrition panel would cover the 3D room and draw a second clock. `ScorecardPanel` stays off too: `FightResultPanel` already draws the judges from `get_scorecard_read`.

`FighterPortrait` is U208/U209. Walkout is in the Codex queue. Bot art is U207. None of those files were edited. Gym theme music (S92) is not in the playlist; the operator ear test is still open.

Section C rows that are fight-engine data (technique effect keys, training strands, speed in transition, engine feints, skill consistency, kickboxing and MMA plan roles) are not buttons. They already run inside the fight. Personality and rivalry heat were wired before this task.

## What the player can now do

Icons, with a tooltip, via `UIKit.icon_plate` and `UIKit.tip`. `G156Wire.icon_button` sets the plate and its children to ignore the mouse so the click reaches the button. Godot 4.7 renames a second sibling that reuses a name; booked cards and the world-read labels are wrapped with `ScheduleHubPanel._keep_card_name`. Cut-plan and cut-action buttons use distinct names, so they do not need that wrap.

| Where | Control | Writes |
| --- | --- | --- |
| Fight week | `CutPlan_none`, `CutPlan_moderate`, `CutPlan_aggressive` | `set_weight_cut_plan`. The gold icon is the plan on the fighter. |
| Weigh-in, while the scale is open | `CutAction_standard`, `CutAction_emergency`, `CutAction_accept_miss`, `CutAction_withdraw` | `act_on_weight_cut`. Hidden once `weigh_in` is set. The panel still does not resolve the scale. |
| Day feed | `MediaDesk`, `MediaAnswer_<option id>` | `answer_media_question`. Absent when nothing is open. |
| Offers desk | `CancelBooking` on `BookedCancel_<id>`, section BOOKED | `cancel_fight_booking`. Absent when nobody is booked. |
| Skills strip | `CancelProgram`, or `DisciplineTrain` when a program is ready and none is active | `cancel_development_program`, `assign_discipline_training`. |
| Staff, a coach selected | `ReleaseCoach` | `release_coach`. |
| Gym walls, a hung piece with a free slot | `MoveDecor` | `move_decor`, then the panel's existing save. |
| New career, a slot pending | `AbandonCareer` | `cancel_pending_new_career`. |

Sentences, on the screen whose numbers they explain:

| Where | Node | Module |
| --- | --- | --- |
| Profile, shape frame | `StatBand` | `StatWords.stat_line`. Bands are the D23 caps: NOVICE, BEGINNER, CLUB-LEVEL, SOLID AMATEUR, NATIONAL CALIBRE, ELITE CONTENDER, WORLD-CLASS. |
| Profile, shape frame | `SpreadLine` | `StatSpread` + `SpreadWords`. |
| Profile, shape frame | `LedgerLine` | `LedgerWords`, from `get_body_read`'s record. An empty log's only sentence is "0 WEEKS LOST", and that line is not drawn. |
| Profile, shape frame | `StatLegend` | `AthleteStatModel.fight_legend_text` and `fight_legend_tooltip` (C44). |
| Fight week, gutter beside the card | `SurfaceLine`, `ContestLength`, `AgeClock` | `SurfaceWords`, `ContestLength`, `CompetitionAge`. The clock words show without inventing a birth date. A competition age is printed only when the save has a birth year. |
| Gym, above Expand | `ArenaFitLine` | `ArenaFit`. Expand stays enabled. A starter room that is short of a ring says SHORT. |
| Offers column | `WorldReads`, and `Bracket` only when a bracket has rounds | The reads in the table above. |

## Edited ranges

`Godot/scripts/G156Wire.gd` is new. The panels preload it as `G156`.

| File | Lines | What |
| --- | --- | --- |
| `StatWords.gd` | 49–64 | `band_word` is the D23 proficiency caps. `label`, `gloss`, `stat_line` unchanged. |
| `FightWeekPanel.gd` | 13–14, 20, 110–111, 146–184, 453–481 | The cut plan is the one write. Surface, contest length, and the age clock sit in the left gutter. The three cut icons sit under the week plate. |
| `WeighInPanel.gd` | 14–16, 22, 207–232 | The weigh-in decision is the one write, and only while the scale is open. |
| `DayFeedPanel.gd` | 34, 375, 815–862 | Press card above Your fighters, clear of the ring pin. |
| `ScheduleHubPanel.gd` | 48, 1101–1124, 1194–1262 | Empty desk requires nobody booked. World reads, then a BOOKED section with cancel. |
| `SkillsMovesPanel.gd` | 19, 277–341 | Cancel, or a ready discipline, at the end of the strip. Technique options are counted, not drawn again. |
| `StaffHubPanel.gd` | 30, 343–369 | Release on the coach card. |
| `GymHubPanel.gd` | 14, 615–647, 869–891 | Arena fit above Expand. Move on a hung piece. |
| `ProfileRevampPanel.gd` | 30, 1143–1224 | Shape frame: band, spread, ledger, legend. The radar is 228px so the sentences fit inside the clipped frame. |
| `CreationFlowPanel.gd` | 33, 108, 111–127 | Abandon, after the step match, only when `pending_new_career_slot` is set. |
| `tests/stat_words_test.gd` | band assertions | The contract now expects the D23 words. |

## Census, after

`python Tools/wiring_census.py` after the wire: 289 scripts, 270 reachable, 19 unreached. The seven word and fit modules, plus `G156Wire.gd`, are reached because the shipped panels preload them.

Still unreached, on purpose: `FightHudPanel`, `ScorecardPanel`, `FightClipAudit`, `U162RetargetSpeed`, `MatRig`, `FightAnimLabScreen`, `UIKitGallery`, `FightPoseDOF`, `FightAnchorBake`, `FightAnchorIK`, `ApproachSweep`, `FighterPortrait`, `FightPairedAnchor`, `ApproachBand`, `CapsulePresence`, `RingPlace`, `CapsuleCoverage`, `CapsuleDistance`, `VenuePhotos`.

## Proof

Parse gate, every touched script, before any test: `CHECK total=17 fails=0`, then again after the layout passes (`FightWeekPanel`, `ProfileRevampPanel`, `DayFeedPanel`, `G156Wire`).

Watchdog `2026-10-01 23:48:47` GREEN, then `run_tests.py --jobs 2 --only g156_,stat_words`. `g156_words_test` failed once: a fresh log drew "0 WEEKS LOST". `ledger_caption` now stays quiet unless there is a diagnosis, a last injury, or an unreadable row. Rerun `2026-10-01 23:49:51` GREEN, `g156_words_test` `failures=0`.

The five scene-tree tests, each with a show fixture and a control that must not draw the icon:

- `g156_weight_cut_test` `failures=0`. No bout: no cut icons, no surface line, no weigh-in actions. Booked: three cut plans, surface `BOXING · FOUGHT IN A RING · 6.7 M ACROSS`, contest `8 X 3:00`. Aggressive writes `weight_cut_plan`. Standard writes `weight_cut_action`. A settled scale hides the actions. Withdraw's tooltip says the bout comes off.
- `g156_media_test` `failures=0`. Quiet week: no `MediaDesk`. An open prediction draws `MediaAnswer_finish` ("Inside the distance"). Answering empties `get_media_questions` and writes `media_history`.
- `g156_booking_cancel_test` `failures=0`. Nobody booked: no cancel. Booked: `CancelBooking` and `WorldReads`. Cancel clears `booked_fight` and the icon leaves.
- `g156_program_coach_test` `failures=0`. Abandon only while a slot is pending, and it sets the slot back to 0. Discipline train wrote `boxing` on this starter. Cancel clears `technique_training_target`. Move wrote `flyer_wall` from `back_0` to `back_1`. Release removed the coach.
- `g156_words_test` `failures=0`. Band `POWER 28 · BEGINNER · TECHNIQUE 32 · BEGINNER · SPEED 29 · BEGINNER`, no POOR / FAIR / STRONG. Legend tooltip contains `DAMAGE ONCE A STRIKE LANDS`. Fresh body: no ledger. A contusion prints `1 DIAGNOSIS · 2 WEEKS LOST · LAST INJURY 0 WEEKS AGO`. Arena fit `SHORT BY 0.1 M · 81.0 M2 IN USE`.
- `stat_words_test` passed in the same `--only g156_,stat_words` run (the one failure that run was `g156_words_test`, fixed and rerun).

Watchdog `2026-10-01 23:50:43` GREEN, then `run_tests.py --jobs 2 --only smoke,schedule_hub,fight_week,weigh,profile_revamp,office_hub,ui_kit,offer_desk`: `SUITE total=18 fails=0`. No test filename contains `fight_week`; that token matched nothing. `offer_desk` was included because the offers column changed.

Windowed stills through `Tools/godot_hidden.ps1` (`tools/g156_stills.gd`), opened after capture:

| File | In frame |
| --- | --- |
| `previews/g156/creation_abandon.png` | Choose the market, abandon icon at the top left, gold Choose Market untouched. |
| `previews/g156/fight_week_cut.png` | Surface, `8 X 3:00`, and age-by-calendar-year in the left gutter. Bout line under the surnames. Three cut icons; the scale is gold. |
| `previews/g156/weigh_in_actions.png` | Four weigh-in icons under the official line. Standard is gold. To fight night stays the step. |
| `previews/g156/day_media.png` | "Prediction for the bout?" with flame, trophy, and ban, clear of The ring pin, above Your fighters. |
| `previews/g156/schedule_cancel.png` | World reads, BOOKED Eli Sterling, cancel icon on the right of that card. |
| `previews/g156/profile_words.png` | Shape frame: D23 bands, highest/lowest/spread, the contusion ledger, the info legend. |
| `previews/g156/gym_arena_fit.png` | Nothing selected. `SHORT BY 0.1 M · 81.0 M2 IN USE` above Expand. |
| `previews/g156/gym_move_decor.png` | Flyer and clip wall on the decor list, with the move control. Arena fit sits above Expand. |
| `previews/g156/staff_release.png` | Walt Briggs selected. Release icon on the coach card, Assign Fighter unchanged. |
| `previews/g156/skills_cancel.png` | Cancel icon on the strip beside Proficiency. |

This is a Godot desktop panel. It was verified by the scene-tree tests, the 18-test suite, and those stills. It was not verified in a browser.
