# LUDO ROUND 60 VERDICT (S222) - station card v2, one tooltip system, menu backgrounds with art + motion

Your notes it answers, verbatim: C63 "make it look less ai-made use icons and nice graphic instead of wording"; C64 "do not use so much
text , use also tooltip modals for explaining things"; C65 "fix the bakcgrounds put some art and motion"; Q-S220-3 "i do not want
random generated pictures i want pictures we can use in the game".
Ask `LUDO_ROUND60_ASK_S222.txt` (both pictures uploaded as one image); reply verbatim `LUDO_ROUND60_REPLY_S222.txt` (18,578 chars).
Ludo scores itself 9.6 / 9.4 / 9.1. Nothing below is built until you OK it.

## 1. Station card (the HEAVY BAG panel on the gym floor) - TAKEN
- 340 px wide, 266 px tall (the old one was a 380x620 slab of text). Six rows: name + size + close; a 10-block condition bar coloured by
  band + "38%" + a DAMAGED pill + a small (i); three icon tiles (down-arrow "x0.65" efficiency, medical cross "+1.25%" injury, clock
  "14h" to failing); TRAINS pills (POWER, FIT BOXING x1.0); upkeep with a coin icon + "2/2 in use"; SERVICE and REPLACE buttons.
- All the paragraphs (best for kickboxing / muay thai / karate, your fit) LEAVE the card and go into the (i) tooltip.
- REPLACE = hold the button 1 second to confirm (a fill runs across it), no extra pop-up window.
- CHANGED: the numbers come from the game, not from Ludo's text - SERVICE adds 50 and stops at 95 (your approved round 56 rule), not 88.
  Five bands as built: good / worn / damaged / failing / out of use.

## 2. One tooltip system for the whole game - TAKEN
- Hover 350 ms (instant when moving between neighbours), a small (i) glyph or a dashed underline on any number that has one; title +
  2 short lines + a mini bar or a number with its change; flips at the screen edges; disappears when you click, press Esc, pan or pause.
- First build: hover only (keyboard F1 "pin" comes later, as Ludo suggests).
- The copy is rewritten from the game's real rules, max 14 words each. Ludo's 10 lines name things the game does not have (e.g. a hidden
  "chin integrity", "wrist sprain" on the bag) - those are NOT used. First places: station card, runway, weekly upkeep, starting cash,
  floor space, each fighter stat, stress, career wear, fight offer, contract.

## 3. Backgrounds with art and motion - TAKEN, built from OUR OWN 3D gym (no generated pictures)
- Country and City steps (and the main menu): our real 3D club runs behind the panels in a hidden viewport, filmed by a slow camera:
  step 1 wide on the ring in morning window light, step 2 a slow dolly along the heavy-bag row; the camera glides between steps.
- Motion: one heavy bag swaying gently (+-1.8 degrees, 4.2 s), dust motes drifting in the light; a dark edge vignette and blur keep the
  panels readable. Everything freezes while you type, and a Reduce Motion setting turns it all still.
- Step 3 (Name the gym) already shows the live 3D gym in the centre (your round 57 approval) - it keeps that, plus the dust and vignette.
- CUT for the first build (as Ludo advises): light-beam cones, chalk puffs, the ceiling fan (we have no fan model).
- Budget: 60 fps cap, under 180 particles, under 45k triangles.

## Build after your OK
- STATIONWEAR1F (station card v2 + the tooltip component) -> cloud Cursor, stills on the game camera, then you.
- MENUBG1 (3D backdrop behind country/city/main menu) -> Cursor/Codex on the PC (needs the GPU for stills).
