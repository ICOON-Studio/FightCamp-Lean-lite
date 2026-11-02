# TASK ZIVAPLAYTEST1 - play the boxing demo as a player and rate it: what works, what breaks, what to improve first (boxing demo)

Kind: research
Model: Ziva Smart, reasoning MAX, a NEW Ziva chat (after ZIVAMOTION2 round 2 ends - it did, S268 collected c94eeae4 - never two Ziva chats at once). Discipline: BOXING.
Operator S267: "ask ziva to playtest the game and how it would rate it, what need improvements".
READ-ONLY: this task changes NO game file. Output = one report file + stills. Worktree E:/FightCamp/wt/ZIVA after `git merge origin/master`.

## What to play (the game a player gets: `-- as_game`, the switches GAME_ON)
1. NEW CAREER: creation (country, city, gym name) -> the club (gym3d_main + gym4_club).
2. ONE GYM DAY on the floor: the morning Day Plan, the boxer walks and works stations, the meters (gains / attrition), the gain
   bubbles, the STATION FOCUS (S268: the FOCUS CARD at the bottom of the screen at every station, keys 1-3; the morning Day
   Plan's FOCUS picker per block), a sparring block and its RING REPORT card, the coach, the brow cut + cutman in the fight.
3. A WEEK: advance days, see the "CHANGE THE PLAN" morning line after 3 same-focus days, the weekly report.
4. BOOK + WATCH A FIGHT: find a fight, the fight night, the live 3D boxing fight to the end, the corner between rounds, the result.
Use run_scene / playtest and your get_screenshot; save every screenshot you judge to `previews/s267_ziva_playtest/`.

## The report: `research/ZIVA_PLAYTEST_S267.md`
1. RATING out of 10 for each: first 5 minutes, gym floor loop, station focus, fight watchability, corner, menus/HUD, overall - and
   one line WHY for each, the way a Steam reviewer of a management sim would put it.
2. TOP 10 PROBLEMS ranked by how much they hurt a new player: what you did, what you saw, what you expected, the screenshot path,
   the script/function you believe is responsible (trace it, do not guess - name file:line).
3. BUGS (crash, script error, stuck state, wrong number) separately, each with the exact repro steps.
4. TOP 5 IMPROVEMENTS that would most raise the overall rating for the least work.
5. What already feels GOOD (keep list).
Compare against Two Point Museum / Game Dev Tycoon / Football Manager where it helps (research/TWOPOINT_ALIGNMENT.md).

## Rules
- Do not fix anything in this task - the report is the deliverable; Claude turns it into tasks.
- No MMA / kickboxing - the demo is boxing only.
- Stills of the fight through record_room as_game + still_framing save_if_framed (no feet-only frames).
- Commit the report + screenshots to ziva/playtest and push.

## Contract
OWNS: research/ZIVA_PLAYTEST_S267.md, previews/s267_ziva_playtest
RED_TEST: none (research)
REGRESSION: none
VISUAL: yes
