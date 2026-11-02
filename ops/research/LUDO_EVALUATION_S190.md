# FightCamp vs Ludo - evaluation + the redesign plan (S190, 2026-10-09)

Operator S190 (verbatim): "i want you to prioritize the ludo , if we need to redesign everything to match its ideas do it , continue with
ludo on this session and then evaluate our work against ludos propositions". Ruling D39 LUDO FIRST. Sources: LUDO_LOOPS_S188.md (rounds
1-2), LUDO_ROUND3_S188.md, LUDO_ROUND4_S190.md (Ludo's consolidated loop, mock-ups, migration plan). Code state: a read-only sweep of
the tree at 59c09315 (file:line evidence below; GS = GameState.gd, FR = FightRealtime.gd).

## 1. Scoreboard - the 20 propositions against the game today
BUILT 2 (one in a different model than Ludo's) - PARTIAL 15 - MISSING 3.

| # | Ludo proposition | Today | Evidence | Gap to Ludo |
|---|---|---|---|---|
| 1 | Coach runs a skipped day at 80%, confirm drawer, amber weight warning | PARTIAL | GymHall3D.gd:682 coach_runs_rest; career_morning.json coach_day 0.8 (S189) | drawer + amber = FLOORGAIN2B (Codex, running); WeightCut.gd:165 on_track not read by the hall |
| 2 | Last spar "lock one, sacrifice one" | PARTIAL | FightCamp.gd:31,180 auto taper; fight_camp.json focus_tracks | no spar decision at all; taper is automatic |
| 3 | Tell bank: sparring + film, up to 3 per opponent | BUILT (2 reads) | CornerPitStop.gd:64-77 READ_CARDS tell/exit; FR:1813, FR:4927 | 2 generic reads, not 1-3 NAMED tells; not shown on the fight HUD |
| 4 | Mastered card auto-fires; pad chain trigger->evasion->counter; stool "executed 2/3" | DATA-ONLY | MoveCards.gd:120; move_cards.json 120/600 min | card mastery never reaches the fight (ComboMastery.gd unused by FR) |
| 5 | Weight-cut roulette + "chin compromised" | PARTIAL | WeightCut.gd:17 actions, :131 night_penalty; WeighInPanel.gd:214 | penalties live only in the OLD engine (FightSimulation.gd:1249); no marker; options are not Ludo's three |
| 6 | Heavy bag "dead arms" / snap | PARTIAL | PitStop.gd soreness; DayLapSplice.gd:69 | soreness resets per day; nothing reaches fight night |
| 7 | Treadmill lateral movement budget | PARTIAL | FR:1995 strand_edge_footwork; TrainingStrands.gd | a +-6% edge, no spendable budget |
| 8 | Members + sparring partners living on the floor; spy day | PARTIAL | Membership.gd; GymClub3D.gd:750 walk-ins | members walk in but do not train at stations; no spy |
| 9 | Fight-2 cut: towel vs push on + permanent cut-prone scar; ringside doctor | PARTIAL | CornerPitStop.gd:244 close the cut; FR:3439 doctor; FR:2768 towel | doctor never stops for a CUT; no scar trait; no purse trade-off |
| 10 | Eye test (pulse gauge vs "I'm fine") + stool tone vs state word | PARTIAL | CornerPitStopPanel.gd:47 calm/fire/truth; FR:2848 heart zone | no state word, no lie, no "older brother" tone; tone only moves volume |
| 11 | Cutman triage, 2 action points | BUILT, other model | CornerPitStop.gd:19-24 45 s over 3 lanes | seconds + lanes, not 2 AP on 3 named zones |
| 12 | Mid-round shouts, 3 per round, ring IQ x trust | MISSING (old engine only) | CoachRapport.gd:142; FightBeatAdapter.gd:606 listen 1.0 | live rule "the corner only speaks between rounds" (FR:2854) |
| 13 | Career wear / mileage ledger | PARTIAL | FightSimulation.gd:1225 chin wear; Mileage.gd | old engine only; hidden; hard sparring does not wear |
| 14 | Referee personalities | MISSING | FR:504 one fixed stoppage model | per-bout referee + badge |
| 15 | Promoter's trap | PARTIAL | ShortNotice.gd (purse x1.35) | no unbeaten-record stake, no TV-payday letter |
| 16 | Gym hierarchy / sparring chemistry | PARTIAL | Rivalries.gd; GymHeat.gd | teammates never affect each other's morale |
| 17 | Poached fighter; partner sells the plan | BUILT (poach) / MISSING (leak) | GS:9405, GS:9337; Retention.gd:134 | the leak |
| 18 | Youth academy pipeline | PARTIAL | AmateurBooking.gd; GymWing.gd:24 | no junior intake - Ludo: NOT in the demo |
| 19 | Basement smoker circuit | MISSING | - | Ludo: NOT in the demo |
| 20 | Painted colour-coded drill routes | MISSING | GymHall3D.gd:85 _route_points (walk path, not drawn) | draw the day plan on the floor |

## 2. Where we already match Ludo (keep)
- The training lap itself: Ludo's migration plan says KEEP AS IS for GymHall3D's stations, clock, stamina and the 80% auto day.
- The camp spine (focus, protocol, partner cast like the opponent, visiting coach, film depth 0-3, diet), the corner + towel, the
  weigh-in, cuts and the doctor, short-notice offers, poaching, amateur ladder - the raw material for 15 of the 20 exists.

## 3. Where Ludo says we are wrong (redesign under D39)
1. **The fight engine split.** Weight-cut chin, career chin wear and the obey roll live only in the OLD FightSimulation.gd; the fight the
   player watches (FightRealtime) never reads them. Ludo's whole loop ("the week shows up on Saturday") needs them in the live engine.
2. **Training never reaches the fight.** Card mastery, soreness/dead arms, footwork budget: data on the floor, nothing in the ring.
   Ludo's core promise is "you build the script during the week, and watch the boxer execute it on Saturday".
3. **The corner model.** Ours: 45 seconds over three crew lanes + calm/fire/truth. Ludo: ONE 3-column drawer readable in < 10 s -
   stool diagnostic (pupil + pulse -> state word -> 3 tones, mismatch = panic) | cutman 2 AP on 3 named zones | round strategy
   (pad-chain emphasis + ring position) | CONFIRM & SEND OUT with an auto-countdown.
4. **No decisions in the round.** Ludo puts 3 shouts and a drag-the-towel tray on the live fight HUD; our live rule forbids mid-round
   calls. D39 reopens that rule.
5. **The fight week has no rhythm.** Ludo's week is Mon pads chains / Tue lock-one-sacrifice-one spar / Wed recovery / Thu film tells /
   Fri weigh-in roulette / Sat fight - one decision a day. Ours is the same lap every day.
6. **The gym screen.** Ludo's (01_gym_screen.png): roster column left, WEEK CALENDAR right (one row per day, amber flags), painted
   colour routes on the floor, active-fighter bar + weight vs target at the bottom, ADVANCE DAY (space, 1-s long press).
7. **Scope of the demo.** Ludo cuts from the first hour: smoker circuit, youth academy, poaching/espionage, custom gym building/facility
   upgrades ("a fixed, hand-crafted garage gym"), and keeps it to 1 fighter + 1 sparring partner.

## 4. The redesign plan - Ludo's own build order (D: the first-hour demo), mapped onto our code
Each item is behind a switch until the operator OKs it on the game camera (CLAUDE.md s2 visual rule).

| Order | Ludo mechanic | Verdict (Ludo 4c) | Our work | Seat |
|---|---|---|---|---|
| M1 | 3D match viewer + telemetry HUD (pulse BPM green/amber/red top-left, round/timer/speeds + referee badge top-centre, opponent + tell icons top-right) | CHANGE | LUDO-HUD1: FightNightScreen live HUD to the 02_fight_night_screen layout | Cursor after PLAYUI1C |
| M2 | Stool diagnostic: pupil + pulse -> state word (terrified/complacent/enraged/groggy) -> Cold General / War Cry / Older Brother; match +10% composure, mismatch = panic (game plan dropped for the first 30 s) | CHANGE | LUDO-STOOL1 pure fold (Arena), then wire into the corner + FR | Arena -> Codex |
| M3 | Cutman 2 AP: ice the eye (hook defence back) / swab the cut (delays the doctor) / ice the neck (+8% stamina) | CHANGE (replaces the 45 s lanes) | LUDO-CUT1: CornerPitStop AP model | Qwen |
| M4 | Pad chains: mastered card -> trigger/evasion/counter; fires with chance mastery x ring_iq/70 at mastery >= 0.25, 4 s cooldown, banner, stool "executed 2/3" | CHANGE (biggest) | LUDO-PAD1 pure PadChain (Arena) -> LUDO-PAD2 FR hook (Codex sol) | Arena -> Codex |
| M5 | Gym floor + day advance | KEEP + routes | FLOORGAIN2B drawer (running); LUDO-ROUTES1 painted routes = CLUBROUTES1; LUDO-GYMUI1 roster left / week calendar right / ADVANCE DAY | Codex / Cursor |
| M6 | Lock one, sacrifice one (fight-week Tuesday spar) | CHANGE | SPAR1 (SPAR1A SparRead on Arena) + the choice: lock = +15% that drill, sacrifice = -10% guard vs his secondary weapon | Arena -> Claude |
| M7 | Film tells bank: depth 1-3 = 1-3 NAMED tells on the opponent HUD | CHANGE | LUDO-TELLS1: tells per opponent from his style; replaces the 2 generic reads (merge SPARTELL1) | Arena |
| M8 | Weight-cut roulette: Safe Sweat (0% miss, -5% stamina) / Sauna Push (10% fail, chin -15%) / Extreme Drain (+10% power, 30% miss = -20% purse, chin red) | NEW screen + live-engine wiring | LUDO-CUT3 = CHINCUT1: WeighInPanel options + chin/stamina into FR + the chin marker | Codex |
| M9 | Doctor stoppage + towel + permanent Cut-Prone scar | CHANGE | LUDO-DOC1 = CUTSCAR1: doctor inspects cuts; push on -> trait on the sheet | Qwen |
| M10 | Promoter's trap: amateur trophy vs $5,000 TV bout vs a slugger, after fight 2 | NEW | LUDO-TRAP1 = OFFERTRAP1 on ShortNotice | Qwen |
| + | Mid-round shouts (3/round, ring IQ x trust) and drag-towel tray on the live HUD | CHANGE (reopens FR:2854 rule) | LUDO-SHOUT1 = SHOUT1 | after M1 |
| + | Fight-week cadence Mon-Sat (one decision a day) | CHANGE | LUDO-WEEK1: the camp's LAST week runs Ludo's six days; earlier camp weeks stay lap days | Claude design |
| later | referee personalities, mileage ledger (merge scar), sparring chemistry, members at stations, leak/spy, academy, smoker | after the demo | REFEREE1, WEAR1, MEMBERS1, ... | - |

Merges Ludo asked for (E): pads/treadmill/heavy bag feed the fight (one engine hook, not three meters); film + spy + leak = one tells
system; scar + mileage = one ledger; eye test + tone = one stool diagnostic; academy/smoker/trap phased out of the demo except the trap.

## 5. What to cut from the demo (Ludo D) - behind switches, never deleted
Smoker circuit, youth academy, poaching/espionage, custom gym building/facility upgrades in the first hour (start in a fixed garage gym),
more than 1 fighter + 1 sparring partner in the first hour.

## 6. FINAL VERDICTS for the operator's approval (Ludo round 4 build order + Ludo round 5 rulings; nothing is built before his OK)
| V | Verdict (Ludo's ruling) | Changes in our game |
|---|---|---|
| V1 | Corner = our 3 lanes + 45 s, pace slider REPLACED by 2 AP per lane (6 AP): 1 AP = 15 s careful (0% mistake), 2 AP = 30 s, a 3rd emergency AP = 15 s rushed (35% blunder) | CornerPitStop pace -> AP; panel shows AP pips per lane |
| V2 | Tones keep OUR names (Calm / Fire Him Up / Tell Him the Truth) but are tested against heart zone + state word (Groggy / Panicked / Complacent): match = +10% composure + plan held; wrong (e.g. Fire on a panicked red-zone kid) = BPM > 190 + sloppy brawling | tone stops being "volume only"; new state word in the live fight |
| V3 | NO mid-round shouts - the corner stays silent in the round (our rule kept) | drops SHOUT1 / LUDO-SHOUT1 |
| V4 | Tells: keep TELL (mimic partner) + EXIT (film), but each is a permanent NAMED read on the HUD ("Drops left on cross: +12% counter window"); the chief spends 1 AP to switch one on for the rest of the bout | replaces +2% one-round reads; up to 3 per opponent (round 4) |
| V5 | Camp: weeks 1-3 = ours (focus, protocol, mimic partner, recovery/diet); week 4 = Ludo's fight week Mon pads route / Tue 2-round spar + Lock One, Sacrifice One / Wed recovery / Thu film / Fri weight-cut roulette / Sat fight | auto taper replaced by the fight week |
| V6 | Lap days: manual Mon + Tue of each camp week; Wed-Fri the coach auto-runs at 80% unless the player toggles Manual Control; one critical decision modal each morning | uses FLOORGAIN2 coach day; a morning decision card |
| V7 | Hour 1: starter garage gym, 1 amateur + 1 mimic partner; store buttons and expansion doors chained ("Unlocks at Pro License Tier"); members train in locked ambient zones; until fight 2 is won | club expansion + extra signings locked in hour 1 (switch, not deleted) |
| V8 | Pad chains: a mastered card becomes trigger -> evasion -> counter and fires in the LIVE fight (chance mastery x ring IQ / 70 at mastery >= 0.25, 4 s cooldown, banner, stool "executed 2/3") | FightRealtime hook (the big one) |
| V9 | Weight-cut roulette Fri: Safe Sweat (0% miss, -5% stamina) / Sauna Push (10% fail, chin -15%) / Extreme Drain (+10% power, 30% miss = -20% purse, chin red); chin marker on the live HUD | penalties move from the old engine into the live fight |
| V10 | Doctor inspects cuts; towel or push on -> permanent Cut-Prone scar on the sheet | doctor-for-cuts + trait |
| V11 | Promoter's trap after fight 2: amateur trophy vs a $5,000 TV bout vs a slugger | one authored offer |
| V12 | Live fight HUD to Ludo's mock-up 02 (pulse BPM green/amber/red, round/timer/speeds + referee badge, opponent tells row, towel tray); gym screen to mock-up 01 (roster left, week calendar right, painted colour routes, ADVANCE DAY) | HUD + gym layout |
| V13 | Hour-1 start (Ludo round 6): no coach hire at minute 0 (solo player-coach; hiring an assistant unlocks at minute 37 after the first $350 purse); the interview stays but as a 3-prospect shortlist that always leads with Leo Vance (+2 alternative archetypes); the player still picks 3 move cards, the 3rd slot locked to a pad chain; Sal = the gym's contracted house sparring partner from day 1 at $50/week, never booked to fight; Leo is FIXED in the first run (19, chin 82, head movement 14, orthodox), later saves get generated recruits from his template | the empty-gym start (GS empty_gym_start ~4604, GymHallPanel coach hire + interview) is reordered |
Build order (Ludo D): V12 fight HUD -> V2 stool -> V1 corner AP -> V8 pad chains -> V6/V12 gym -> V5 spar lock -> V4 tells -> V9 weigh-in -> V10 doctor -> V11 trap; V7 at the start of the first-hour pass.
