# S316 - The body map and the round data (operator ask, 2026-10-30)

Operator: "add a body visual with muscle that will be real time interactive on where the hits are being taken and changing
colour on that area, and how corner can fix it, ice on muscle or whatever. the decision on the round has no real data i
think for the player to pick a tactic".

## What the real corner and broadcasts do (G132, S96 Grok, 109 sources; topics/body_damage.md SETTLED)
- One minute. The cutman works the face (cut: pressure + adrenaline 1:1000 swab + Vaseline; swelling: the iced enswell,
  held, never smeared); the chief second talks, water, ice on the ribs. One pair of hands per job.
- Ice buys numbness and less swelling for one round, not structure. Body damage is NOT closed in 60 s (10-20 % of the sting
  off at most). A hurt hand gets almost nothing legal in 60 s.
- Broadcasts show live strike tallies by head / body and replay the damaging shot. Games: EA UFC shows region bars + icons;
  Fight Night Champion's face damage and its cutman mini-game were the best liked.
- Settled bands (do not retune): fine > 55, hurt <= 55, critical <= 35, doctor <= 15 per region.

## The design (Claude's call; the operator approves before it is built)
1. SIX PLACES ON A BOXER: head (the chin/brain - knockdowns), left eye, right eye, nose and mouth, left ribs, right ribs
   (the liver side: an orthodox lead hook to the body lands there). Each starts at 100 and falls with every landed punch that
   reaches it (who, which hand, head or body from the fight beats; a jab lands on the face, hooks on the side they come from).
2. LIVE FIGURE (the "muscle" picture): a small front-view anatomy figure for each boxer beside the score panel. The hit place
   flashes the moment a punch lands, then holds its band colour (green fine, amber hurt, red critical, purple doctor). Hovering
   (or tapping) a place shows its number and the last 3 punches that landed there.
3. THE CORNER MINUTE uses the figure: the big figure of HER on the corner card, and the jobs are placed on it -
   - cutman (one job): enswell on an eye (swelling back one band for a round), or pressure + adrenaline on a cut (stops the
     bleeding for a round), or nothing;
   - the second (one job): ice on the ribs (that side 10-20 % back, the energy cost of body shots eased for a round), or water
     (energy), or "clear her head" (only when hurt at the bell).
   You pick one cutman job and one second job: the real one-pair-of-hands choice, zero work in a clean fight.
4. THE ROUND'S DATA for the tactic pick (what a real chief second reads off the round): for each boxer
   - punches thrown / landed by kind (jab, straights, hooks, uppercuts, body), as numbers and %;
   - where she was hit (the figure) and what she left open: "Maria's right hand drops after her jab: 4 of 6 times";
   - energy at the bell and its trend; the round's score as the judges saw it.
   Each of the eight calls shows the number that argues for it ("Go to the body - Maria's ribs: hurt, 9 landed").

## Order of work
Rules first (pure, testable): BodyMap regions from the beats + a round tally. Then the live figure (HUD), then the corner card
figure + jobs, then the round data on the corner card. Each step gets its own test; the figure gets game-camera stills.
