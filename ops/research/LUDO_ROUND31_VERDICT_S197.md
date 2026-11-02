# Ludo round 31 - Claude's verdicts for the operator (S197, 2026-10-11)
Source: research/LUDO_ROUND31_S197.txt (Ludo's answer, verbatim). Nothing below is built until you approve.

## 1. The morning card leaves the gym floor (Ludo Part 2) - TAKE
- The dark card top-right ("A quiet week" + STEP IN / SKIP THE DAY) is removed.
- Its line moves INTO the top time bar as a one-line ticker: `MON, WEEK 1 | pause/1x/4x/16x | "A quiet week. Danny on Pad Work at 14:00." | [STEP IN]`
  (bar 1200 x 52 px, top centre; gold STEP IN / CONTINUE button at its right end).
- On days that need you (fight booked, fighter hurt, weight over) a "coach" drawer slides in from the right with the decision;
  ordinary training days never stop you.
- Calendar: a thin right-edge tab (36 x 180 px) that shows the countdown to the next event ("5d"); a click slides the calendar
  over the right third with time paused.
- CORRECT: keep our existing time bar (play/pause/fast) and add the ticker to it - no second bar. The bottom dock keeps our icons
  (Ludo listed 8 F-keys: F1 roster ... F7 inbox - we add those shortcuts).

## 2. The interface rule (Ludo Part 1) - TAKE the rule, build screen by screen
- The 3D gym is always the home. A screen is a drawer over the RIGHT 38% (734 px wide, x 1186-1920); 62% of the gym stays visible;
  opening a drawer pauses time.
- Design system: Chakra Petch for headings, Inter for text, JetBrains Mono for numbers; dark panels #12161F at 96%, gold #D69E2E
  as the gym colour, green/amber/red for good/warn/bad.
- 15 screens specified with pixel rectangles (fighter profile, roster, scouting, staff, calendar + offers, camp, fight week,
  live fight HUD, corner, result, finances, inbox, rankings, settings).
- CORRECT: fonts must be checked for licence (all three are free, OFL) before shipping; we restyle our existing screens to
  this system one at a time, after the playable loop works - not before.

## 3. The beautiful-gym look (Ludo Part 3) - TAKE, built behind `gym_look2` (OFF)
- Cool daylight key light from the skylight, 6 neutral fill lights, 4 warm grazers on the brick wall, filmic tone, soft contact
  shadows, light glow and a faint dust haze; floor colours per zone (navy stretch mat, green turf, darker bag-line rubber).
- Built today (code + data, switch OFF). Stills on the game camera come next (the PC was too hot to render them now).
- STILL OWED by Ludo: equipment palette, the three camera shots, post-processing, "what makes it alive"; and round 30's
  remaining sections. Asking costs about 200 credits in one go - only on your word.
