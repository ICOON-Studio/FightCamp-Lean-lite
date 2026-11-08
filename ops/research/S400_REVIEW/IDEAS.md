# S400 Miro idea inventory vs today's code (read-only; Miro board uXjVETf7la4=)

COUNTS: total 96 | BUILT 41 | PARTLY 37 | NOT BUILT 18

Method: every idea sticky/card/node from the five frames, checked with 1-3 greps over scripts/ (S400, 2026-11-08). Skipped: headings, frame instructions, Claude / Kalli / John opinion-lane stickies, and the operator's YOUR NOTES stickies that only affirm or complain ("Keep it", "Planned vs actual is the hook", "Too many picks...", "Real numbers sell the weight cut", "Fun: one twist...", "Fun: she pushes back..."); his proposals are listed. "unsure" = not confirmed by grep. Ids are data-miro-id with the prefix 3458764689 dropped (add it back).

## Frame 3458764689105432916 - Idea backlog - mechanics and looks
| id | idea | kind | built | evidence |
|---|---|---|---|---|
| 105483020 | Trust meter: overrule her and it drops | mechanic | PARTLY | morale is the trust score (FighterProfile.trust, PushBack.gd, WeekTwist ASKS "overruled"); no separate meter by design |
| 105483021 | Opponent tape: scout clips reveal habits | mechanic | BUILT | rules/OppFile.gd, rules/TapeClips.gd, ui/OppFileCard.gd |
| 105483022 | Corner calls cost her trust if wrong | mechanic | PARTLY | trust scales what she takes in of calls (FighterProfile.trust); a wrong call lowering trust: unsure |
| 105483023 | Sparring partners have their own styles | mechanic | PARTLY | southpaw partner twist (WeekTwist), SparNights.gd, BjjOpp PARTNER_STYLE; no partner roster with styles |
| 105483024 | Scars: past injuries change future risk | mechanic | PARTLY | scars are cosmetic by bouts boxed (FighterLook.gd, FighterFace.gd); injury state in state/Injuries.gd; scar to risk link not found |
| 105483025 | Rival arcs across several fights | mechanic | PARTLY | RivalPast.gd (history), trash_talk twist, Matchmaking.gd; multi-fight rematch arc: not found |
| 105483026 | Gym culture: members copy her habits | mechanic | NOT BUILT | no hit for culture or habit copy in scripts/ |
| 105483027 | Coach hires bring a signature drill | mechanic | NOT BUILT | StaffRoles.gd / HeadCoach.gd give one-number edges, not a signature drill (unsure) |
| 105483112 | Fight poster generated for every bout | look | BUILT | ui/FightPoster.gd |
| 105483113 | Gym walls fill with her photos and belts | look | PARTLY | Home whiteboard pinned note/photo (ui/areas/Home.gd); belts/trophy wall: not found |
| 105483114 | Portrait shows fatigue, cuts and the weight cut | look | PARTLY | cuts/swell/shut on the portrait: ui/FaceMarks.gd; fatigue and weight-cut look: unsure |
| 105483115 | Week review as a coach's notebook page | look | PARTLY | ui/modals/WeekReview.gd + ReviewReveal.gd, rules/CoachNotes.gd; notebook-page look: unsure |
| 105483116 | Fight week: UI goes darker and tighter | look | PARTLY | corner minute is letterboxed (fight3d/CornerMinute.gd); a fight-week UI theme: not found |
| 105483117 | Sound: marker squeak, bell, crowd swell | look | PARTLY | bell + crowd swell in audio/FightSfx.gd (unheard sounds wait on the sound board); marker squeak: not found |
| 105483118 | Gym changes by time of day and season | look | NOT BUILT | seasons only price heating (GymBills.gd); no visual change |
| 105483119 | Draggable magnets between days | look | BUILT | ui/WeekBoard.gd, WeekDay.gd, WhiteboardKit.gd (magnet) |
| 106015957 | Corner minute: three fixes, time for two | mechanic | BUILT | fight3d/CornerMinute.gd, rules/CornerCard.gd, CornerJobs.gd |
| 106015958 | Shout bar only lands if trust is high | mechanic | PARTLY | fight3d/ShoutBar.gd exists; trust scales calls (FighterProfile.trust); a hard "only if high" gate: unsure |
| 106015959 | Cutman: a closing eye, stop or go on | mechanic | PARTLY | cutman in pro corner (CornerCrew.gd), closed eye drawn (FaceMarks.gd); stop-or-go decision: not found |
| 106015960 | Opponent adapts to your plan by round 2 | mechanic | NOT BUILT | RoundStyle habits only (fades after round 2); no adaptation to the player's plan found (unsure) |
| 106016099 | Scorecards shown after each round | mechanic | PARTLY | BoutRules.scorecards (end of bout), ui/Broadcast.gd; per-round cards: unsure |
| 106016100 | Crowd momentum sways close rounds | mechanic | PARTLY | crowd follows the fight in audio only (FightSfx.gd); no scoring effect found |
| 106016102 | Walkout: her song, the robe, the crowd | look | PARTLY | walk-in intro (fight3d/FightIntro.gd, Attendance.gd room); song and robe: not found |
| 106016103 | Corner as top-down stool view, ice and towel | look | PARTLY | stool, ice, water (CornerCrew.gd, CornerJobs.gd) in a cinematic view; top-down view: not found |
| 106016104 | Damage shows on her face round by round | look | BUILT | ui/FaceMarks.gd, rules/BodyMap.gd, fight3d/FighterFace.gd |
| 106016105 | Slow-mo replay of the punch that decided it | look | PARTLY | slow-mo/close-up on the big shot (FightSfx.gd comment, CLAUDE.md week 5); a replay: unsure |
| 106016106 | Silence before the verdict is read | look | PARTLY | FightSfx HUSH before the round's big shot; before the verdict: unsure |
| 106016107 | Small hall to arena as her career grows | look | PARTLY | rules/Attendance.gd + FightSfx.setup_room scale the room by attendance (sound/room); visual venue: unsure |
| 106568246 | Her prime: a peak window, then decline | mechanic | PARTLY | world/WorldAge.gd (rise, peak, decline) for the world; for the player's own fighters: unsure |
| 106568247 | Retirement talk: when to hang them up | mechanic | NOT BUILT | retirement exists for world boxers only (WorldAge.gd, Matchmaking); no player prompt found |
| 106568248 | Retired fighters come back as coaches | mechanic | NOT BUILT | no hit |
| 106568249 | Legacy: your gym's style spreads | mechanic | NOT BUILT | no hit |
| 106568543 | Weight class moves: up a division or not | mechanic | NOT BUILT | unsure; divisions exist (Matchmaking, WorldRank) but no move choice found |
| 106568544 | Promoters court her; loyalty vs money | mechanic | PARTLY | Matchmaking.gd (promoter offers, four pulls), StarDeal.gd (contract renegotiation) |
| 106568545 | Career goals she sets herself, not just you | mechanic | PARTLY | rules/FighterGoal.gd (goals, trust/morale); whether she sets them herself: unsure |
| 106568546 | Career timeline of posters and belts | look | PARTLY | ui/SeasonRoad.gd, rules/Records.gd (GYM > Records); posters kept on a timeline: unsure |
| 106568547 | She visibly ages across the career | look | NOT BUILT | no age look in FighterLook.gd |
| 106568548 | Ranking ladder drawn as a climb | look | PARTLY | ui/SeasonRoad.gd (road), state/ProLadder.gd data; climb drawing: unsure |
| 106568549 | Hall of fame wall in the gym | look | NOT BUILT | no hit |
| 106568550 | Retirement montage of her best moments | look | NOT BUILT | no hit |
| 106607244 | Sponsor wants a fight before camp is ready | mechanic | PARTLY | short_notice and photoshoot twists (WeekTwist.gd); a sponsor forcing a fight: not found |
| 106607245 | Upgrades unlock new session types | mechanic | PARTLY | rules/GymUpgrades.gd (each moves one visible number); new session types: unsure |
| 106607246 | Members pay the bills, pros cost time | mechanic | BUILT | rules/Membership.gd, GameMoney.gd, GymBills.gd, StaffRoles.gd |
| 106607247 | Two fighters, one coach: who gets the pads | mechanic | NOT BUILT | unsure; no pad-time contention found |
| 106607424 | Local rival gym poaches your members | mechanic | NOT BUILT | Membership.gd says rivals were dropped; only a warning line in FighterGoal.gd |
| 106607425 | Win streaks bring walk-in prospects | mechanic | PARTLY | reputation to members (Membership.gd), walk-ins (FirstHour.gd, ClubStart.gd); streak-specific: unsure |
| 106607426 | Gym floor you see grow, mat by mat | look | PARTLY | premises tiers in GymUpgrades.gd; visual growth: unsure |
| 106607427 | Members train in the background, alive | look | NOT BUILT | unsure |
| 106607428 | Ledger as a battered cashbook | look | PARTLY | ui/areas/Money.gd ledgers; the books mockup docs/mockups/S400_money_books.png is a proposal, not built |
| 106607429 | Sponsor logos appear on her shorts | look | NOT BUILT | FighterLook has club trim only |
| 106607430 | Scouting as photos pinned to a corkboard | look | NOT BUILT | no hit (OppFileCard.gd is a card) |

## Frame 3458764689104088403 - Twist cards - draft
All ten are in rules/WeekTwist.gd (choices table; ids below), drawn at the week's end.
| id | idea | kind | built | evidence |
|---|---|---|---|---|
| 104088412 | 1 Southpaw in town | twist card | BUILT | WeekTwist id southpaw (extra spar, lefty edge 1.5) |
| 104088413 | 2 Tight knee | twist card | BUILT | WeekTwist id tight_knee |
| 104088414 | 3 Sponsor photoshoot | twist card | BUILT | WeekTwist id photoshoot (+$400, evening off / rep -1) |
| 104088415 | 4 Rival talks trash | twist card | BUILT | WeekTwist id trash_talk (3 members now, fixes land half as well) |
| 104088416 | 5 The scale won't move | twist card | BUILT | WeekTwist id scale_stuck |
| 104088606 | 6 Short-notice swap | twist card | BUILT | WeekTwist id short_notice (rare; Bouts.short_notice) |
| 104088607 | 7 Old coach visits | twist card | BUILT | WeekTwist id old_coach |
| 104088608 | 8 Combo clicking | twist card | BUILT | WeekTwist id combo_click |
| 104088609 | 9 Gym heating breaks | twist card | BUILT | WeekTwist id heating |
| 104088610 | 10 She wants a night off | twist card | BUILT | WeekTwist id night_off + PushBack ASKS |

## Frame 3458764689106635515 - Early Access top 5
| id | idea | kind | built | evidence |
|---|---|---|---|---|
| 106635523 | A twist card every Monday | mechanic | BUILT | rules/WeekTwist.gd |
| 106635526 | She pushes back, and trust keeps score | mechanic | BUILT | rules/PushBack.gd, FighterProfile.trust (morale = trust) |
| 106635580 | The week review as a reveal | mechanic | BUILT | rules/ReviewReveal.gd, ui/modals/WeekReview.gd |
| 106635583 | The corner minute: three fixes, time for two | mechanic | BUILT | fight3d/CornerMinute.gd, CornerCard.gd, CornerJobs.gd |
| 106635586 | A fight poster for every bout | look | BUILT | ui/FightPoster.gd |

## Frame 3458764689099716206 - Core loop - Early Access
(Parts 1-4 describe the core loop itself; the operator's proposals in the YOUR NOTES lane are listed after them.)
| id | idea | kind | built | evidence |
|---|---|---|---|---|
| 099716215 | 1 Mornings summed to the camp goal (Light/Normal/Hard, goal lines move live) | mechanic | BUILT | rules/WeekPlan.gd, TrainingWeek.gd, ui/WeekBoard.gd, WeekCamp.gd |
| 099716216 | 2 Evenings: move and combo lab, hit rate vs next opponent | mechanic | BUILT | rules/Combos.gd, ComboOdds.gd, OwnCombos.gd, ui/ComboBuilder.gd |
| 099716217 | 3 Fight plan: design it, Test it (20 bouts, where it breaks) | mechanic | BUILT | rules/PlanFight.gd, PlanLines.gd, TestDay.gd, SparNights.gd |
| 099716218 | 4 Planned vs actual with one-line reason + coach suggestion | mechanic | BUILT | rules/WeekActual.gd, WeekCause.gd, WeekCoach.gd |
| 103974456 | Merge day types with Light/Normal/Hard | mechanic | PARTLY | WeekPhase.gd header cites it (phase writes the week); full merge: unsure |
| 103974457 | Every random swing needs a readable reason | mechanic | PARTLY | WeekCause.gd (every gain carries its cause); all random swings: unsure |
| 103974458 | Test it accuracy follows scouting | mechanic | PARTLY | OppFile.gd hides habits until scouted; test accuracy tied to scouting: unsure |
| 103974459 | Let money push on training | mechanic | NOT BUILT | no cash input found in WeekPlan.gd (unsure) |
| 103974317 | Phase sets the default week; edit exceptions | mechanic | BUILT | rules/WeekPhase.gd |
| 104034747 | Fun: week review as a reveal | mechanic | BUILT | ReviewReveal.gd (same as top 5 #3) |
| 104034748 | Fun: a small goal every week | mechanic | PARTLY | FighterGoal.gd, PeakCamp.gd (camp goal lines); a weekly small goal: unsure |
| 104034749 | Fun: hard-week streak vs injury risk | mechanic | BUILT | TrainingLoad.gd (acute:chronic), InjuryRoll.gd |

## Frame 3458764689580854873 - The week: what makes it play differently (draft map)
Six group nodes (Monday's twist card, The camp sets the shape, The world knocks, She pushes back, Her body carries over, The review pays it off) are covered by their children below.
| id | idea | kind | built | evidence |
|---|---|---|---|---|
| 163151236 | One choice, a visible price | twist card | BUILT | WeekTwist.gd (a/b labels with lines) |
| 163151237 | Settled in the week review | twist card | BUILT | WeekTwist.gd (drawn at the week's end) |
| 163151238 | 10 draft cards ready to test | twist card | BUILT | WeekTwist.gd (all 10 plus 5 asks) |
| 163151239 | Phases count back from fight night | mechanic | BUILT | rules/WeekPhase.gd |
| 163151240 | Hard, skill, engine, rest days | mechanic | BUILT | rules/WeekPhase.gd |
| 163151241 | You edit only the exceptions | mechanic | BUILT | WeekPhase.gd + saved week repeats (WeekTwist header) |
| 163151242 | Sponsors want her time | twist card | BUILT | WeekTwist photoshoot |
| 163151243 | Rivals talk, opponents swap | twist card | BUILT | WeekTwist trash_talk, short_notice |
| 163151244 | Draft: sparring partners with styles | mechanic | PARTLY | southpaw partner only (WeekTwist); styled partner roster: not found |
| 162973745 | Habit overrides the plan (30% roll) | mechanic | PARTLY | rules/HabitFix.gd, HabitBeats.gd, PushBack.gd; the 30% number: unsure |
| 162973746 | Overrule or listen moves trust | mechanic | BUILT | PushBack.gd (heard/overruled to morale), FighterProfile.trust |
| 162973747 | She asks for a night off | twist card | BUILT | WeekTwist night_off / ask_rest |
| 162973748 | Fatigue fades over about 7 days | mechanic | PARTLY | TrainingLoad.gd chronic decay (EWMA); exact 7-day fade: unsure |
| 162973749 | Harder load, faster gains, more injury risk | mechanic | BUILT | TrainingLoad.gd, InjuryRoll.gd, WeekPlan.gd |
| 162973750 | Scars change future risk | mechanic | PARTLY | cosmetic scars only (FighterLook.gd); risk link not found |
| 162973751 | Planned vs actual, line by line | mechanic | BUILT | WeekActual.gd, ReviewReveal.gd |
| 162973752 | Ends on the biggest surprise: a trait | mechanic | BUILT | ReviewReveal.gd (surprise lands last) |
| 162973753 | Draft: teases next Monday's twist | mechanic | NOT BUILT | no hit for a next-week teaser (unsure) |
