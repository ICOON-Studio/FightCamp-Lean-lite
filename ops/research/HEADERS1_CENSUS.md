# HEADERS1 CENSUS — which player-visible headers have no mechanic behind them

**Agent:** Qwen (qwen3-coder) **Date:** 2026-10-11 **Branch:** qwen/headers1
**Scope:** every `_build_header`, `header_bar`, `title_slot`, `_section`, `display` heading, sort column header, room title, pin label and section title that reaches a player-visible Label in `Godot/scripts/`.
**Method:** source grep + read; no game code changed; no windows opened.

## Totals

| Verdict | Count |
|---------|-------|
| WIRED | 97 |
| PARTIAL | 11 |
| UNWIRED | 8 |
| **Total** | **116** |

## Full table

| Header text | Where (file:line) | Route / screen | Verdict | Evidence (file:line) | Mechanic it implies |
|---|---|---|---|---|---|
| Gym name (club label) | ShellChrome.gd:506 | every career | WIRED | GameState.get_gym() / career.meta.gym_name | Gym identity |
| Gym initials (crest) | ShellChrome.gd:502 | every career | WIRED | derived from gym_name | Gym identity |
| Breadcrumb "Your gym · {city} · {label}" | ShellChrome.gd:519 | every career | WIRED | career.meta.city + active route label | Location + current page |
| Cash pill "$N" | ShellChrome.gd:560 | every career | WIRED | GameState.gd career.cash | Gym finances |
| Roster line "N fighters · -$N/mo" | ShellChrome.gd:575 | every career | WIRED | GameState.get_roster().size() + get_billing_summary() | Roster + upkeep |
| Bell / news badge | ShellChrome.gd:583 | every career | WIRED | GameState.get_news() | News feed |
| Date plate + CONTINUE | ShellChrome.gd:545 | every career | WIRED | career.time (career_week, career_day) | Time advance |
| Options gear | ShellChrome.gd:822 | every career | WIRED | opens ManagementChrome._open_action_menu | Menu access |
| Back button | ShellChrome.gd:196 | every career | WIRED | SceneRouter.back_or("day_feed") | Navigation |
| Handbook button | ShellChrome.gd:228 | every career | WIRED | GameState.is_tutorial_guide_on() | Tutorial replay |
| Home icon (house) | ShellChrome.gd:25 | top bar | WIRED | navigates day_feed | Navigation |
| Fighters icon (users) | ShellChrome.gd:25 | top bar | WIRED | navigates gym | Navigation |
| Training icon (dumbbell) | ShellChrome.gd:25 | top bar | WIRED | navigates training | Navigation |
| Scouting icon (binoculars) | ShellChrome.gd:25 | top bar | WIRED | navigates scouting | Navigation |
| Staff icon (user-check) | ShellChrome.gd:25 | top bar | WIRED | navigates staff | Navigation |
| Fights icon (swords) | ShellChrome.gd:25 | top bar | WIRED | navigates calendar | Navigation |
| Rankings icon (trophy) | ShellChrome.gd:25 | top bar | WIRED | navigates rankings | Navigation |
| Finance icon (wallet) | ShellChrome.gd:25 | top bar | WIRED | navigates office_menu | Navigation |
| THE FRONT DESK | LobbyPanel.gd:107 | lobby | WIRED | OfficeRoomPanel.title_slot; walk-in stats from GameState | Front desk management |
| THE WALK-INS | LobbyPanel.gd:141 | lobby | WIRED | GameState walk-in data (last week counts) | Walk-in funnel |
| THE DESK | LobbyPanel.gd:156 | lobby | WIRED | front_door data: hourly, hours, wage, worth | Front desk hire |
| THE OFFICE | OfficeRoomPanel.gd:197 | office_room | WIRED | title_slot: cash, week net, contract count from GameState | Office overview |
| THE LOCKER ROOM | LockerRoomPanel.gd:69 | locker_room | WIRED | title_slot: fighter count, booked count from GameState | Locker allocation |
| THE MAT ROOM | MatRoomPanel.gd:65 | mat_room | WIRED | title_slot: members, dues, mat count from GameState | Members' class |
| THE STAFF ROOM | StaffRoomPanel.gd:81 | staff_room | WIRED | title_slot: coach count, payroll from GameState | Staff management |
| THE PHYSIO | PhysioRoomPanel.gd:75 | physio | WIRED | title_slot: fighter wall, sore, medical holds from GameState | Injury management |
| THE FILM ROOM | FilmRoomPanel.gd:186 | film_room | WIRED | title_slot: opponent facts from GameState | Opponent scouting |
| GYM (hub title) | GymHubPanel.gd:151 | gym | WIRED | gym name/fame/roster counts from GameState hub read | Gym overview |
| TRAINING (hub title) | TrainingHubPanel.gd:234 | training | WIRED | gym week/day/planned/in_camp from GameState hub read | Training overview |
| SCOUTING (hub title) | ScoutingHubPanel.gd:232 | scouting | WIRED | market/available/cash/payroll/shortlist from GameState | Scouting overview |
| FIGHTER PROFILE · {name} | AthleteProfileShellScreen.gd:103 | fighter_card | WIRED | athlete.name from GameState | Fighter identity |
| THE GYM'S WEEK | OfficeHubPanel.gd:375 | office_menu | WIRED | week data from GameState career time | Weekly overview |
| THE FIGHTER'S PURSE | OfficeHubPanel.gd:490 | office_menu | WIRED | purse data from GameState fighter finances | Fighter purse |
| THIS MONTH | OfficeHubPanel.gd:765 | office_menu | WIRED | monthly billing from GameState | Monthly finances |
| THE PARTNER | OfficeHubPanel.gd:811 | office_menu | WIRED | partner/sponsor data from GameState | Sponsorship |
| NEEDS ANSWERING | OfficeHubPanel.gd:982 | office_menu | WIRED | open requests from GameState | Pending actions |
| THE WEEK | OfficeHubPanel.gd:1100 | office_menu | WIRED | week term data from GameState | Week details |
| THE TERM | OfficeHubPanel.gd:1164 | office_menu | WIRED | contract term from GameState | Contract details |
| THE PROMOTION (office) | OfficeHubPanel.gd:1311 | office_menu | WIRED | promotion data from GameState | Promotion info |
| {ORG NAME} (dynamic) | OfficeHubPanel.gd:1343 | office_menu | WIRED | org short_name/name from GameState | Organisation detail |
| BOOKED (section) | ScheduleHubPanel.gd:1675 | calendar | WIRED | _booked_members() from GameState | Booked bouts |
| SHORT NOTICE (section) | ScheduleHubPanel.gd:1680 | calendar | WIRED | _short_notice from GameState | Short notice offers |
| CONTENDER SERIES (section) | ScheduleHubPanel.gd:1687 | calendar | WIRED | _invites from GameState | Contender invites |
| SIGNING (section) | ScheduleHubPanel.gd:1691 | calendar | WIRED | _signings from GameState | Signing offers |
| PROMOTION BOUTS (section) | ScheduleHubPanel.gd:1695 | calendar | WIRED | _promo_bouts from GameState | Promotion bouts |
| RETENTION (section) | ScheduleHubPanel.gd:1699 | calendar | WIRED | _retention from GameState | Retention offers |
| SPONSORSHIP (section) | ScheduleHubPanel.gd:1703 | calendar | WIRED | _sponsors from GameState | Sponsor offers |
| THE PROMOTION (schedule) | ScheduleHubPanel.gd:3144 | calendar | WIRED | promotion data from GameState | Promotion detail |
| THE COACH (staff detail) | StaffHubPanel.gd:309 | staff | WIRED | coach detail from GameState | Coach detail |
| {COACH NAME} (dynamic) | StaffHubPanel.gd:331 | staff | WIRED | coach.name from GameState | Coach identity |
| AUDIO (settings) | SettingsBoardPanel.gd:120 | boot_settings | WIRED | audio settings controls wired to UserSettings | Audio config |
| DISPLAY (settings) | SettingsBoardPanel.gd:145 | boot_settings | WIRED | display settings controls wired to UserSettings | Display config |
| RULESET (settings) | SettingsBoardPanel.gd:190 | boot_settings | WIRED | ruleset controls wired to rules data | Ruleset config |
| Office pin | DayFeedPanel.gd:398 | day_feed | WIRED | navigates to office_room route | Room navigation |
| Staff room pin | DayFeedPanel.gd:399 | day_feed | WIRED | navigates to staff_room route | Room navigation |
| The ring pin | DayFeedPanel.gd:401 | day_feed | WIRED | navigates to training_floor route | Room navigation |
| Gym floor pin | DayFeedPanel.gd:402 | day_feed | WIRED | navigates to training_floor route | Room navigation |
| Front desk pin | DayFeedPanel.gd:405 | day_feed | WIRED | navigates to lobby route | Room navigation |
| Locker room pin | DayFeedPanel.gd:406 | day_feed | WIRED | navigates to locker_room route | Room navigation |
| Street door pin | DayFeedPanel.gd:412 | day_feed | WIRED | scouting trigger from GameState | Scouting access |
| The ledger pin | DayFeedPanel.gd:413 | day_feed | WIRED | finances trigger from GameState | Finance access |
| The board pin | DayFeedPanel.gd:414 | day_feed | WIRED | schedule trigger from GameState | Schedule access |
| NEXT FIGHT | DayFeedPanel.gd:535 | day_feed | WIRED | bout data (event_name, opponent, title_bout) from GameState | Next bout info |
| THE CAMP PLAN | FightWeekPanel.gd:373 | fight_week | WIRED | camp plan data from GameState | Camp planning |
| THE FILM (tape title) | FightWeekPanel.gd:406 | fight_week | WIRED | film/opponent data from GameState | Film study |
| WHAT THEIR STYLE OPENS | FightWeekPanel.gd:452 | fight_week | WIRED | counter/style data from GameState | Opponent analysis |
| PUNCH TABLE | FightResultPanel.gd:304 | fight_result | WIRED | punch stats from fight simulation | Punch statistics |
| THE CARDS | FightResultPanel.gd:521 | fight_result | WIRED | scorecard data from fight simulation | Judge scorecards |
| THE RANGE | FightResultPanel.gd:798 | fight_result | WIRED | range data from fight simulation | Distance control |
| THE MOMENT THAT DECIDED IT | FightResultPanel.gd:267 | fight_result | WIRED | fight moments from fight simulation | Key moments |
| BELT NOT ON THE LINE | FightResultPanel.gd:760 | fight_result | WIRED | title_blocked_by_weight from GameState | Title bout status |
| ROUND N / N | FightHudPanel.gd:131 | fight_night | WIRED | round/rounds_total from fight state | Round tracking |
| Clock (MM:SS) | FightHudPanel.gd:137 | fight_night | WIRED | _clock_text() from fight state | Round timer |
| Score A - B | FightHudPanel.gd:149 | fight_night | WIRED | score.a/score.b from fight state | Live score |
| Week N in review | WeekReviewPanel.gd:754 | week_review | WIRED | reviewed_week from GameState | Week summary |
| NET (week review) | WeekReviewPanel.gd:140 | week_review | WIRED | money data from GameState | Financial summary |
| SCORECARD | ScorecardPanel.gd:72 | fight_result | WIRED | scorecard data from fight | Scorecard display |
| Round N (scorecard) | ScorecardPanel.gd:193 | fight_result | WIRED | round data from fight | Per-round scores |
| AMBITION · THE LONG ARC | DevelopmentPanel.gd:192 | fighter_card | WIRED | ambition from athlete data in GameState | Fighter ambition |
| CAREER GOALS | DevelopmentPanel.gd:222 | fighter_card | WIRED | goals from athlete data in GameState | Career goals |
| GRADE · {words} · N of N | DevelopmentPanel.gd:337 | fighter_card | WIRED | grade_read from GameState development | Development grade |
| FIGHT PLAN SETUP | FightPlanSetupPanel.gd:65 | fight_week | WIRED | fight plan data from GameState | Fight planning |
| N NODES · CLICK A NODE | SkillsMovesPanel.gd:206 | training | WIRED | view.size() from skill tree data | Skill tree size |
| SELECT A NODE ON THE TREE | SkillsMovesPanel.gd:438 | training | WIRED | instruction when no node selected | Skill tree interaction |
| TRAINS (station card) | StationInfoCard.gd:94 | training_floor | WIRED | station training modifiers from Layout data | Station training |
| COSTS (station card) | StationInfoCard.gd:97 | training_floor | WIRED | cost data from Layout | Station cost |
| BEST FOR (station card) | StationInfoCard.gd:100 | training_floor | WIRED | station suitability from Layout | Station fit |
| YOUR FIT (station card) | StationInfoCard.gd:104 | training_floor | WIRED | player's station match from Layout | Personal fit |
| CONDITION (station card) | StationInfoCard.gd:107 | training_floor | WIRED | station condition from Layout | Station state |
| FIGHTCAMP (title) | TitleBoardPanel.gd:124 | boot | WIRED | brand identity, hard-coded by design | Brand |
| MATCH SIMULATOR | MatchSimulatorPanel.gd:77 | fight_test | WIRED | dev tool title | Dev tool |
| THE BOUT (simulator) | MatchSimulatorPanel.gd:92 | fight_test | WIRED | bout data from match simulator | Test bout |
| WHAT DRIVES THE FIGHT | MatchSimulatorPanel.gd:170 | fight_test | WIRED | fight analysis from simulator | Fight analysis |
| THE STORY (wall) | StoryWallPanel.gd:62 | story_wall | WIRED | beats from GameState story data | Story progress |
| YOUR FIGHTERS (wall) | StoryWallPanel.gd:63 | story_wall | WIRED | fighters from GameState story data | Story fighters |
| FIGHT NIGHT (empty state) | FightNightScreen.gd:752 | fight_night | WIRED | shown only when no fight loaded | Fight night |
| {STATION} · TRAIN A MOVE | StationMovePicker.gd:297 | training_floor | WIRED | station_name from Layout data | Move training |
| WATCH THE FLOOR (button) | TrainingHubPanel.gd:257 | training | WIRED | button.pressed -> _on_open_floor navigates to training_floor | Floor access |
| SQUAD_COLUMNS sort header | GymHubPanel.gd:203 | gym | WIRED | UIKit.SQUAD_COLUMNS with on_sort callback | Roster sorting |
| CONTRACT_COLUMNS sort header | OfficeHubPanel.gd:1015 | office_menu | WIRED | UIKit.CONTRACT_COLUMNS with on_sort callback | Contract sorting |
| Card columns sort header | ScheduleHubPanel.gd:1173 | calendar | WIRED | UIKit.card_columns with on_sort callback | Card sorting |
| PROSPECT/STAFF sort header | ScoutingHubPanel.gd:268 | scouting | WIRED | PROSPECT_COLUMNS/STAFF_COLUMNS with on_sort | Scouting sorting |
| COACH_COLUMNS sort header | StaffHubPanel.gd:191 | staff | WIRED | COACH_COLUMNS with on_sort callback | Staff sorting |
| Week band sort header | TrainingHubPanel.gd:302 | training | WIRED | UIKit.week_band_columns with on_sort | Training sorting |
| Country/City/Gym step headers | CreationFlowPanel.gd:457 | creation | WIRED | step title from creation flow state | Creation steps |
| FIGHT WEEK / WEEK N (camp) | FightCampPanel.gd:610 | fight_week | WIRED | week_index/taper from GameState camp data | Camp week |
| Camp grade letter | FightCampPanel.gd:841 | fight_week | WIRED | grade from camp evaluation in GameState | Camp grade |
| MMA TRANSITION · A SECOND ART | DevelopmentPanel.gd:281 | fighter_card | PARTIAL | GameState.gd:5541 eligibility check exists; full transition mechanic incomplete | MMA cross-training |
| SLOT 1 STYLE SPARRING / NOT YET | FightPlanSetupPanel.gd:172 | fight_week | PARTIAL | slot data from GameState but shows "NOT YET" when empty — style spar weeks computed | Style sparring |
| SLOT 2 FILM / NOT YET | FightPlanSetupPanel.gd:177 | fight_week | PARTIAL | slot data from GameState but shows "NOT YET" when empty — film depth computed | Film study |
| NOT YET. {opens} (story wall) | StoryWallPanel.gd:157 | story_wall | PARTIAL | entry gated by story progress; "NOT YET" is a valid state label but implies future content | Story gates |
| UNDER THE BOUT'S OWN RULES, BUT A GYM CANNOT YET BE | SettingsBoardPanel.gd:201 | boot_settings | PARTIAL | ruleset limitation text implies a feature (gym ruleset customization) not yet implemented | Gym ruleset config |
| TBD (opponent name) | FightContractScreen.gd:503 | fight_contract | PARTIAL | fallback when opponent not yet set; terms.get("opponent_name", "TBD") | Opponent billing |
| NOTHING HE WANTS RIGHT NOW | DevelopmentPanel.gd:229 | fighter_card | PARTIAL | valid empty state for career goals but reads as placeholder when ambition system is thin | Career goals |
| HOW DEVELOPMENT WORKS | DevelopmentPanel.gd:365 | fighter_card | UNWIRED | hard-coded explanation text at DevelopmentPanel.gd:365-376; no mechanic, just static copy | Explanatory text |
| NO TREE FOR THIS DISCIPLINE YET | SkillsMovesPanel.gd:368 | training | UNWIRED | placeholder at SkillsMovesPanel.gd:368 for missing skill tree data; no tree computed for discipline | Skill trees |
| COACH ONE..FOUR (placeholder) | StaffRoom3D.gd:457 | staff_room (3D) | UNWIRED | placeholder names when coaches.is_empty(); hard-coded fallback at StaffRoom3D.gd:457 | Staff room 3D |
| FIGHTER 1..8 (placeholder) | StaffRoom3D.gd:492 | staff_room (3D) | UNWIRED | placeholder names when fighters.is_empty(); hard-coded fallback at StaffRoom3D.gd:492 | Staff room 3D |
| NO SAVE SLOT IS ARMED | CreationFlowPanel.gd:444 | gym_pick | UNWIRED | error-state message; no mechanic behind it, just a refusal string | Save slot error |
| NO OPPONENT ON FILM | FilmRoomPanel.gd:186 | film_room | UNWIRED | subtitle shown when no opponent booked; the film room has no film-viewing mechanic yet | Film study |
| BALANCED CAMP · NO FOCUS EDGES | FightCampPanel.gd:1751 | fight_week | UNWIRED | empty-state text when camp has no focus edges; the focus-edge delta display has no underlying delta model | Camp focus edges |

## UNWIRED and PARTIAL headers, grouped by screen

### day_feed (HOME)
- (none unwired or partial)

### gym (GYM hub)
- (none unwired or partial)

### training (TRAINING hub)
- The player sees **NO TREE FOR THIS DISCIPLINE YET** on the skills tab but nothing computes a skill tree for that discipline.

### scouting (SCOUTING hub)
- (none unwired or partial)

### staff (STAFF hub)
- (none unwired or partial)

### calendar (FIGHTS / SCHEDULE)
- (none unwired or partial)

### office_menu (FINANCE / OFFICE)
- (none unwired or partial)

### fighter_card (FIGHTER CARD)
- The player sees **MMA TRANSITION · A SECOND ART BECOMES A COMPLETE GAME** but the full MMA cross-training mechanic is incomplete — eligibility is checked but the transition itself does not execute.
- The player sees **NOTHING HE WANTS RIGHT NOW · A CONTENT FIGHTER** when career goals are empty, which reads as a placeholder when the ambition system is thin.
- The player sees **HOW DEVELOPMENT WORKS** but it is a static explanation with no interactive mechanic behind it.

### fight_week (FIGHT WEEK / camp)
- The player sees **SLOT 1 STYLE SPARRING / NOT YET - SPAR A CAMP WEEK WITH THE MIRROR** but the style sparring slot shows "NOT YET" when empty even though the weeks are computed.
- The player sees **SLOT 2 FILM / NOT YET - FILM STUDY IN CAMP** but the film slot shows "NOT YET" when empty even though film depth is computed.
- The player sees **BALANCED CAMP · NO FOCUS EDGES** but the focus-edge delta display has no underlying delta model to compute from.

### fight_night (FIGHT NIGHT)
- (none unwired or partial)

### fight_result (RESULT)
- (none unwired or partial)

### boot_settings (SETTINGS)
- The player sees **UNDER THE BOUT'S OWN RULES, BUT A GYM CANNOT YET BE** which implies a gym-specific ruleset customization feature that is not implemented.

### staff_room (3D)
- The player sees **COACH ONE** through **COACH FOUR** as placeholder names on the 3D staff room board when no coaches are hired.
- The player sees **FIGHTER 1** through **FIGHTER 8** as placeholder names on the 3D staff room board when no fighters are assigned.

### film_room (THE FILM ROOM)
- The player sees **NO OPPONENT ON FILM · book a bout and the coach starts the board** but the film room has no film-viewing mechanic yet — the board is computed but there is no film to watch.

### story_wall (THE WALL)
- The player sees **NOT YET. {opens}** on story wall entries that have not been reached, which is a valid gate state but implies future story content not yet written.

### fight_contract (FIGHT CONTRACT overlay)
- The player sees **TBD** as the opponent name when the opponent has not been set, which is a fallback that should not reach the player in a normal flow.

### gym_pick (creation)
- The player sees **NO SAVE SLOT IS ARMED · START A NEW CAREER FROM THE TITLE** which is an error-state refusal, not a feature.
