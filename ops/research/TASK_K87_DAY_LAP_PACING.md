# TASK K87 - Design study: the PACING of a training day you watch (race = the week, lap = the day) - study + pictures only, never code

You are Kalli, the design agent. Reply in this chat with ONE document.

## Context
FightCamp is a boxing gym management game (Godot 4, 3D). One fighter trains in a 3D gym while a day clock runs (10 game hours,
today ~3 real minutes, no fast-forward while he trains). The player clicks a station (bag, pads, ring, speed bag, treadmill, bike,
weights, stretch corner); the fighter walks there (walking costs minutes), trains, and drains STAMINA; a coach buffs the station he
stands at and has a POOL that must last the WEEK. The operator, verbatim (2026-10-08):
"other games with timing and simialr game mechanice as our (motorsport manager loop . i am thinking the race is the scheduled training
the lap is the day there is a goal to reach in time and time is ticking and trying to achieve the best result out of the trianing
session each day or week (not sure about the pacing)"
Earlier ruling (2026-10-06): "we are not making a copy of motor sport [...] every week the trainging is set and you watch the fighter do
it you watch him and intervene when you want to press him harder or easy him".

## Prior research (do not repeat it)
G112 (training loop survey, Two Point Campus "watching people do the thing is the reward"), D68 (one more turn), MMAM2_WATCH_S172
(MMA Manager 2: one station at a time, energy bar), J63 (walking made watchable). NONE set the PACING numbers: real seconds per game
day, how many decisions per day, what the goal of a day/week is, and when the game stops by itself. That is the gap.

## What would a human do?
Time the reference games with a stopwatch: Motorsport Manager (a race: real minutes, laps, how many decisions per lap, what the
player reads while it runs), Chef: A Restaurant Tycoon Game (a service), Two Point Hospital (a day), Overcooked (a level timer + target),
Football Manager (a match at normal speed), MMA Manager 2 (a training day).

## The questions
1. A table: game | the "race" | real minutes | the "lap" | decisions per lap | speed controls | what auto-pauses | the goal shown on screen.
2. What makes the clock feel like pressure, not waiting (a visible target, a pit-window, a rival, a rising cost)?
3. Recommend OUR numbers: real time per game day, days per week shown vs skipped, decisions per day, the DAY goal and the WEEK goal
   (e.g. "jab usable by Friday", "stamina above 30 at the bell"), what auto-pauses, speed steps. Give two variants (short and long day)
   and say which you pick and why.
4. One picture (or ASCII) of the screen during a day: where the clock, the goal, the stamina bar and the coach pool sit.

## Deliverable
ONE document, answer first, max 200 lines, every claim tagged SOURCED (url + date) or JUDGEMENT. Title it "K87 - Day-lap pacing".
