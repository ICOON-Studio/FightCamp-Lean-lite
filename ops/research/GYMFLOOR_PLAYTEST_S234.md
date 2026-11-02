# Gym floor playtest + rating ask (S234)

Operator (S234, verbatim): "while waiting ask agents to playetest and rate the gameaskludo to do the same and rate if we need
more mechanics to make the gymfloor not a boring act for the player"

Sent to: Kalli (game design), Dola (fresh eyes), Ludo (lead designer, with stills uploaded). Answers saved verbatim below.

## The ask (same text to every seat)

You are playtesting FightCamp, a PC boxing-gym management sim (Steam Early Access, $19.99; deep manager sim, not mobile).
You run a boxing gym. Your boxer trains on a 3D gym floor seen from above; then you book fights and watch them.
You cannot run the build, so this is a PAPER PLAYTEST: read the walkthrough of what the player actually does today
(every line below is in the shipped code), look at the stills, then:

1. RATE the gym floor as the player experiences it, 1-10, for: (a) fun minute to minute, (b) clarity (do I know what to do
   and why), (c) meaningful decisions, (d) feedback / juice, (e) does it make me want one more day. One line of reason each.
2. Is it a BORING ACT today? Say yes or no and why, honestly. Where exactly does attention drop?
3. MECHANICS MISSING: list the mechanics that would make the floor not boring, ranked by (fun gained / build cost). For each:
   what the player does, what it changes in the numbers, how often it fires per in-game day, and a real game that does it well.
   Keep it a deep PC manager sim (Football Manager, Punch Club, Game Dev Tycoon, Two Point Hospital, RimWorld are fair
   references; no mobile timers, no energy paywalls).
4. CUT LIST: anything on the floor today that adds noise and no decision.
5. The ONE change you would build first, and why.
Give the longest complete answer you can.

## What the player does on the gym floor today (from the code, S234)

- The club: "Anvil Street Gym", one open floor seen from above (game camera: overview, mid, a close view per station).
  17 stations: heavy bag x4, speed bag x2, ring (sparring), pads (with coach), defence drill (slip rope), mirror strip
  (move cards), treadmill, bike, recovery mats, agility ladder, power rack, olympic platform, weights. Rooms around it:
  reception, office (you), physio, locker, kit store.
- A DAY: the clock runs from 08:00 (minutes tick; speed controls). Your boxer has STAMINA and STRAIN bars and a form word
  (FRESH...). He walks to a station (walking takes minutes), prepares, then trains; each training block gives gains to the
  station's targets (heavy bag: power + stamina; speed bag: hand speed + rhythm; pads: technique + counter timing; ...).
  Gains float up over him as bubbles (Game Dev Tycoon style). Since S234 he plays the station's own workout animation
  (squats at the rack, runs on the treadmill, curls at the weights, punch combos at the pads).
- CUES (the 3 cards at the top): POWER THROUGH (+30% gains, burns 25% more stamina), CRISP FORM (+35% move-card drill,
  normal drain), PACE YOURSELF (-25% gains, saves 40% drain). One is active at a time.
- MOVE CARDS: a named technique (e.g. the jab) can be put "on him" - training then drills that move ("No move card on him -
  training the station only" when none).
- DAY GOALS (top left): e.g. "Stamina above 30 at the bell", "Jab usable by Friday"; a met goal pays +3 morale, +2 trust.
- THE RING MENU (click a thing on the floor):
  - fighter: talk; train at (station pick, which ranks every station BEST / GOOD for him); rest; head coach.
  - coach: drill focus, send to station, week hours, talk contract.
  - station: train here, coach here, queue next (dots + ring on the floor show the queued station; he walks there after
    the block), what it trains, upgrade (level 2 = +15% gains, level 3 = +35%).
  - office window: upgrades.
  - walk-ins (people come in off the street): greet, trial session, come back later, send away.
- MEMBERS: gym members train on the floor too and CLAIM stations (a claimed station asks you before your boxer takes it).
- After the day: day wrap, week review (payout), then the schedule / book a fight / watch the fight (separate screens).

## Stills attached / referenced
- docs/previews/floor_play_s229/01_gain_tick.jpg - a gain bubble over him at the heavy bag
- docs/previews/floor_play_s229/02_talk_line.jpg - the floor line after TALK
- docs/previews/floor_play_s229/03_station_advice.jpg - the station pick with BEST/GOOD
- docs/previews/floor_play_s229/04_queue_marker.jpg - a queued station (overview: the whole floor)
- docs/previews/gymlife_s234/ - the new station workouts (when taken)

## Answers (verbatim, char counts)
(filled as they land)
