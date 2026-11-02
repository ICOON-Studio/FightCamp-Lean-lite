# S291 - Where we focus (Claude, as game designer)

Operator (verbatim, S291): "as a game designer for this game can you have your own proper presentation for the game , wehre do you
think we should focus ? we lose too much time on the gymfloor and the result is still 0 , havent been able to play the game ? do you
need to research how to tighten game presentation and game mechanics and star tbuilding the game as it s supposed to be please"

Deck (11 slides): https://claude.ai/artifact/7eNQCRoaEBswxzq18YyRKm

## The honest read
- About 4 in 10 commits since 2026-10-20 went to the gym floor and build mode (130 of 311 by commit subject - a rough count).
- The operator has not played walk-in -> training -> booking -> fight -> result in one sitting. Until S291 the quick start opened on a
  half-empty gym (fixed 7cc64496).
- The loop's pieces exist (goal card + meters + coach LOOP1 S238; FIGHTLINK 1-5 S250-S253; post-fight why S252; corner lines S253) but
  were never joined into one path the operator can play in the .exe.

## The game in one sentence
You run a boxing gym. Take one fighter from the day he walks in to fight night. Every day you decide how he trains, and in the ring you
find out if you built him right. The gym is the stage and the money; the fighter is the game.

## Pillars
1. Train it, see it - every session shows what it gave (operator Q-S237-1: "feeling of progrsession and improvement from training").
2. Read the man - gains against wear, one clear decision a week (push / hold / rest).
3. Fight night pays off - a watchable bout that plays the way you trained him, and a report that says why.

## The gym, for the demo (SCOPE CHANGE - needs the operator's yes)
- IS: the stage; a built gym from minute one (QUICK START); upgrades bought into fixed spots (Two Point style); readable money.
- IS NOT: drawing rooms from an empty building (the MGT2 build), placing/turning every piece by hand, a building game on its own.
- Nothing deleted: room drawing stays in the code behind its switch and can come back after the demo.

## The golden path - first fight inside 20 minutes (targets, not measurements)
0 min quick start (built gym, a coach) -> 1 min he walks in with a goal ("a fight within a month") -> 2-12 min four weeks of training,
one plan decision a week, days at 3x, meters -> 12 min three offers -> 14 min fight week (film shows one habit, taper) -> 15-20 min
fight night, the why, the next goal.

## Research (this session, web)
| Source | Finding | What we do |
|---|---|---|
| Punch Club reviews (godisageek.com, useapotion.com) | grind is the top complaint; losses the stats say you should win frustrate | short weeks, one decision each; a report that explains every loss |
| Motorsport Manager reviews (osftw.com, digitallydownloaded.net) | the hook is between races: debrief, then straight into preparing | the fight report hands you the next goal |
| Cheung, Zimmermann, Nagappan, "The First Hour Experience" (Microsoft Research) | players decide early; lost early = lost | first fight inside 20 minutes |
| Indie slice post-mortems (bugnet.io, wayline.io - practitioner opinion) | systems built before the loop was fun cost months | no new system until the path plays |

## Presentation
- Week: one top bar, the goal card, the two meters, nothing else by default; gains float off where they happen; one end-of-week card.
- Fight night as a show: walkout + tale of the tape, round cards, the corner between rounds with one call, scorecards, then the why.

## Stops / goes on
- PARKED until the path plays: drawing rooms/doors/caps; placement polish (holograms, turning, wall snap); new decor/rooms/floor items;
  story, MMA, equipment wear. A defect the operator SEES while playing the path is still fixed the same day.
- NOW: join the loop end to end; the meters + weekly card; fight-night presentation and the why; fight look (punches, footwork).

## How we build from now
1. The path is the test: an automated run plays the golden path from QUICK START as the game (switches on). playable_loop_test is green
   in the 2026-10-22 nightly only on the plain arm (switches off) - not the game he plays.
2. Claude plays the path in the .exe at every session start; what breaks is the day's first job.
3. One build a week to the operator: a full fighter story to play and judge.
4. No new system starts while any step of the path is broken; agents get path steps only.

## The call (board)
Park gym building; make the fighter's path playable end to end first. If yes, the next session builds the game-arm path test from
QUICK START, plays it, and fixes the first step that breaks.
