# S79 DIGEST - THE ROAD TO THE FIGHT + THE MENU REORGANISATION (2026-09-25)

Operator, verbatim (after the S78 video): "there has to be blockers. You should not be able to go to the fight that
fast. I mean, you didn't train, you didn't do anything"; "I don't see the timer. Where is the timer? Where are my
commands?"; "I don't understand what the fuck is the day. You have to reorganize everything".

## Shipped (ca5de555, on d0608ccc)
- **Fight-camp gate** - what a human does: a coach will not send a fighter out without a camp.
  `GameState.get_camp_gate_asks()` lists every booked fighter with no active camp while a camp is still possible;
  `continue_day()` refuses (no time moves) until each is answered; `fight_cold()` is the "send him in cold" answer
  for this booking only; `get_camp_summary()` for fight week. Every UI Continue (10 call sites) goes through
  `continue_day()`; `CareerRoot` jumps HOME on a refusal. `advance_day()` stays ungated, so the sim and its tests keep
  their clock. HOME's MUST ANSWER column shows the camp row: SET CAMP (opens the fighter's CAMP tab) and GO COLD, with
  readiness; the top bar's "N MUST ANSWER FIRST" counts it.
- **Round clock** - `FightWorldLiveScreen.broadcast_clock()`: round, time LEFT (a broadcast counts down), BREAK with the
  rest left, and the corner's standing order. Drawn as a plate top-left of the arena ("R2 2:14" / "CORNER: HOLD THE
  CENTRE"); the fight-night header's "LIVE" slot now carries the clock.
- **Honest tutorial** (24 steps): the training step waits on a plan actually set (`wait: training_set`, played by
  `TrainingHubPanel.tutorial_set_plan()` through the real click handlers), the camp is set before fight week (SET CAMP
  -> START A CAMP -> focus + protocol -> START CAMP -> WAY OUT), it stops at the real corner panel, and never presses
  4X. The walk driver paces Continue at 2 s a day. Walked live to step 18 (camp running, Continue moving); the full
  1X bout was not recorded this session (see Owed).
- **Menus (J54)** - THE DAY is HOME everywhere (rail, router label, seams, "BACK HOME"). Rail 8 -> 4 areas: HOME,
  FIGHTERS (Roster & floor, Training, Scouting), FIGHTS (Schedule, Rankings), MONEY (Office, Staff); the open area
  shows its pages indented. Every module id is still routable. J54's fifth area, GYM (facilities), needs the floor split
  from the roster - S80.
- **M32 look slice** - Lucide icons from M33 on the rail (`LucideIcons.gd`, SVG strings rasterised at runtime so they
  ship without an import step; ISC licence in `assets/icons/lucide/`); RADIUS 3 -> 6 (+ RADIUS_CARD 8); CONTINUE's
  words INK on GO; frames lose the filled header bar (title on the frame over a hairline; gold/bad keep their fill).
  **Inter is NOT shipped** - the font file is not on this PC (M33 staged it in Maria's workspace only); S80.
- **Words** - K77's house voice applied to the Handbook (65 of 92 lines changed, 27 already equal, 0 missed); J53 F1
  split `sanctioning` into Commission (licenses, approves bouts) and Sanctioning body (ranks, titles).

## Collected
U174 (boxing_output), C204 (alive stance), C203 (standing sources), Q177 (footwork pass 2) - all opt-in, OFF by
default; subsets green except `fight_stage_realism` (a known red). **Q177's test floors are below G100's** (burst >= 1.0 s
vs 1.5, hold >= 1.5 s vs 2.0) - Q178 restores them. Research: J53, J54, K77, M33, M34 (four directions), G103
(verbatim, from the in-page document). G101 answered in chat (band table below); its memo file did not attach -
asked to paste it.

G101's band words (Grok, blind pair with Dola's D23 still owed): PROFICIENCY 0-19 Gym novice / 20-39 Club amateur /
40-54 Regional / 55-69 National / 70-84 International / 85-100 World class. CONDITION % Not cleared / Overtrained /
Flat / Camp-ready / Sharp / Fight-night. FIGHT IQ Lost in there / Raw / Learning / Ring-wise / High IQ / General.
POTENTIAL Limited / Club ceiling / Regional ceiling / National ceiling / World prospect / Generational. MORALE Checked
out / Sour / Flat / Professional / Hungry / Locked in. Not wired until D23 lands (G wins a conflict with named sources).

## Tests
`menu_clarity_test` 0 failures, with the gate, the clock and the tutorial contract added; mutant (continue_day
ignoring the gate) caught with 2 failures. Subsets 0 failures: day_feed, boot_ (3), creation_root, career_loop_walk,
setpiece_panels, scene_router, schedule_hub (2), scouting_hub (2), rankings_hub, staff_hub, office_hub (2), gym_hub (2),
training_hub (2), corner_ (6), fight_night, schedule_progression, day_attention, ui_kit (3), profile_revamp,
boxing_output, fight_alive_stance, fight_footwork_economy, fight_realtime, fight_world_live. No nightly line exists
(`AgentComms/nightly/latest.txt` absent).

## Assigned
U175 Cursor (real recorded fight sound - Freesound CC0 + Sonniss parts only, licences kept, FightAudio synthesis
replaced) RUNNING; Q178 Qwen (footwork to G100's real floors) QUEUED behind the cap; G102 Grok (fight-hype sequences)
https://grok.com/c/77a712b8-2a1e-4cc3-ab08-e67db913a546; J55 John (the corner between rounds); M35 Maria (art ledger +
replacement briefs); K78 Kalli (S79 strings in house voice). Grok Bot account at 90% of its weekly limit (resets in 6 days).

## Owed / next
- The operator's pick of M34 A/B/C/D (sheet sent: `research/m34/M34_four_directions_sheet.jpg`).
- A recording of the new road to the fight at 1X (tutorial walk, `research/s79/tutorial.plan`) - not made because two
  shell agents held the CPU (operator cap).
- HOME is still a grey board with empty states - the illustrated HOME is S80, with Inter and the chosen direction.
