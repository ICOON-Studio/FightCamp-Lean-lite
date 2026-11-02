# TASK K-FIGHTWORDS1 - KALLI - fight night told in words (lean restart, week 2)

Model: Kalli (Grok bot, game design). Discipline: boxing (demo). Content only: no code, no repo.

## The game in one paragraph
FightCamp is a boxing gym management game. The player runs a small London gym and develops one amateur woman boxer,
Lucy Jackson (21, lightweight, orthodox out-boxer, 3-1 amateur). Week 2 of the restart adds her first bout for the gym:
an offer, a camp, the weigh-in, then FIGHT NIGHT told IN WORDS (no 3D yet): 3 rounds of 3 minutes. After each of
rounds 1 and 2 the player gives one CORNER CALL. After round 3 come the scorecards and "what decided it".

## What I need from you
A bank of short round lines (each under 90 characters, plain present tense, like a ringside reporter's notes, no
swearing, no real fighters' names) that the game picks from. Every round shows 3 lines: an opener, a key moment, a close.

Opponent styles (the game has these four): Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher.
Corner calls (the game has these three): long = "Stay long, jab and move"; body = "Go to the body"; calm = "Calm her down, breathe".
Round outcome: HER round (Lucy wins it) or THEIR round.

Give, as JSON:
{
  "opener": {"<style>": {"her": [4 lines], "their": [4 lines]}},
  "moment": {"<style>": {"her": {"none": [3], "long": [3], "body": [3], "calm": [3]}, "their": {"none": [3], "long": [3], "body": [3], "calm": [3]}}},
  "close":  {"her": [6 lines], "their": [6 lines]},
  "why_win": {"camp": [3], "film": [3], "corner": [3], "no_camp": [3]},
  "why_loss": {"camp": [3], "film": [3], "corner": [3], "no_camp": [3]}
}
"none" = round 1 (no call yet). Placeholders you may use: {her} = Lucy, {opp} = opponent first name,
{threat} = the opponent's threat (e.g. "left hook to the body"), {focus} = the camp focus (e.g. "conditioning"),
{round} = round number. "why_*" lines explain the result in one sentence each (the camp, the film study, the corner call,
or having no camp).

Make lines differ by style: a pressure fighter walks her down, a counter-puncher waits and punishes the jab,
a volume puncher never stops throwing, a boxer-puncher is sharp at range and dangerous up close.
Make the corner call SHOW in the moment line (if the call was "Go to the body", the line is about body work).

## Prior research
searched: fight night commentary round lines corner (nothing found). Canonical page: research/topics/plans_corner.md.

## What would a human do?
A boxing writer's ringside notes: short, concrete, one action per line, the corner's instruction visible in the next round.

## Prefab check
None needed: original text, written for this game.

Reply with the JSON only, as long as needed; if you run out of room, say CONTINUE and I will ask for the rest.
