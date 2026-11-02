# S137 LOOP PLAN - wire everything, loop first, "just one more turn" (Claude, 2026-10-01)

Operator, verbatim: "go ahead, wire everything with all the agents i want everything to be intergraded at AAA game level
(how pros do it , how AAA games do it ,what best reviews praise ) , prioritize game loop to be fun and addictive not
boring everything needs to have a meaning and reward the player for progressing and try to get the feeling of just one
more turn". Inputs: S137_WIRING_AUDIT.md (what is built and unwired), D66_STRICT_REVIEW.md (5/10: "lack of feedback,
clarity, and meaningful decision weight"), D68 (Dola, in flight: what reviews praise in the one-more-turn loop).
No .exe until waves 1-2 are wired (operator ruling S137).

## The loop we are wiring (what the player does, and what pulls him into the next turn)
WEEK: set training -> CONTINUE -> the week pays out (stat ticks, breakthroughs, money, rankings, objectives) -> a hook for
next week (an offer expiring, a fighter 1 rep from a breakthrough, a fight 3 weeks out, a rival calling out).
FIGHT: offer (clear risk/reward) -> camp (visible consequence) -> weigh-in -> walkout in the venue of the level -> the
fight (style, personality and training SHOW) -> scorecards -> purse, fame, ranking jump, honours -> the next offer is
bigger. Every number moves something the player can see; every screen says why it matters (D66).

## WAVE 1 - the loop payoff (highest; one-more-turn hooks)
| id | what the player gets | built piece to wire | AAA reference | owner |
|---|---|---|---|---|
| L1 | Week result: every fighter's stat deltas, breakthroughs, money in/out, rankings moved, objectives paid - and a NEXT WEEK hook line | DayFeedPanel "what changed" + WeeklyObjectives + GameState week report | Football Manager inbox + Civ turn summary | next free UI agent |
| L2 | Offers are decisions in the inbox: accept/decline short notice, promotion bouts, signing offers, contender series, renewals, retention, sponsorship offers, media questions | the 44 GameState actions with no button (audit B) | FM contract/offer flow, Motorsport Manager sponsor deals | Grok after G153, Qwen after Q222 |
| L3 | Fight payoff: judges' scorecards on the result; honours board, medal table, title tenure on the card and the office trophy wall; the walkout in the venue | ScorecardPanel, HonoursBoard, MedalTable, TitleTenure, WalkoutShot (`walkout_enabled`) | UFC/Fight Night broadcast result, FM trophy cabinet | Claude |
| L4 | Offer matchup summary: projected win %, style edge, ranking gap, purse vs fame (D66 #6) | `estimate_win_chance` (built, uncalled), StyleMatchup reads | OOTP scouting, FM match preview | next free agent |

## WAVE 2 - meaning in the fight (training and identity SHOW in the bout)
| id | what the player gets | built piece | owner |
|---|---|---|---|
| E1 | Personality shows: a Fearless man presses, a Reserved one counters | career_goals personality labels -> FightIntent/FightPlans | Codex (luna) C230 |
| E2 | Rivalry heat shows: a grudge fight is hotter | Rivalries heat -> FightRealtime (legacy sim had it) | Codex (luna) C230 |
| E3 | Training strands reach the fight | TrainingStrands -> fight inputs | after C230 |
| E4 | Technique effects (finish_chance, cut_chance, stop_hit, pushback...) do something | technique_catalog effect keys -> an effect processor | after C230 |
| E5 | Speed matters in decisions | FightIntent reads speed | after C230 |
| E6 | Feints are visible | engine feint -> a feint clip (C223) | C223 queue |
Every E-row: census before/after on the same seeds, KO+TKO, thrown/round, connect % stay in their sourced bands.

## WAVE 3 - clarity (D66 top 10, the reviewer's fixes)
Tooltips on every stat/number (GLOSSARY icon+tooltip direction), camp consequence preview, skill tree revealed with unlock
rules, finance breakdown + forecast, floor station purposes + expansion ROI, fatigue meter 0-100, Body Lab carryover.
Owners: Cursor (UI) as U204 lands; Grok bots specify the look.

## WAVE 4 - the look (Grok bots specify, agents build)
M38 arena (Maria, done: green ring, club-hall surround, light) -> M39 per-venue refinement of the six venues; K82/J58
room-to-concept changes (Kalli/John, in flight); U204 menu/room effects; Q222 fight effects.

## Running (S137)
Codex C229 Cascadeur (shovel hook, inside uppercut), Grok G153 fight gate (D67 rules collected), Qwen Q222 fight
effects, Cursor U204 menu/room effects, Kalli K82, John J58, Maria M39, Dola D68.
