# M44 - the camp's last spar: a live stats panel beside our ring (mock-up for SPAR1)

Maria, art direction please: ONE mock-up image (1920x1080) and a short note of the rules you used. Operator 2026-10-09 (S187),
verbatim: "what do you think of that picture to use in the training ring or camp as final test before the real fight , we replace
the right ring and fighters with ours ?" then "yes queue SPAR1 and ask Maria for a mock".

## What the screen is
Fight week of a boxing camp. The fighter spars 2 rounds against the partner the camp cast to box like his opponent. The player
watches this panel, reads whether the plan works, changes one thing in the plan, then goes to the weigh-in. It is a TEST, not the
real fight - the screen should feel like the gym (training floor, chalk, tape), not the arena broadcast.

## The reference (a sports-management game's "RINGSIDE" screen, described - copy its MECHANISM, not its look)
- Left ~60%: two columns of MIRRORED bars, red corner left, blue corner right, the row name in the middle:
  - condition rows: CONSCIOUSNESS 78% | 95%, CORE 98% | 96%, ENERGY 95% | 2%, INJURIES None | None;
  - punch rows, landed / thrown: JABS 0/0 | 0/1, CROSSES 0/1 | 0/1, HOOKS 3/13 | 8/25, UPPERCUTS 0/6 | 9/22, TOTAL 3/20 | 17/49,
    KNOCKED DOWN 0 | 0;
  - four tug-of-war bars, one bar each, red share vs blue share: WORK RATE, ACCURACY, JABBING, POWER SHOTS.
- Right ~40%: a top-down ring with two coloured discs (we REPLACE this with our own 3D ring and our two fighters, the game camera).
- Top strip: the screen name, the date/week, speed (1x), round, clock. Bottom strip: one commentary line
  ("...Tyler glancing the uppercut off his elbow...").

## Our version - what I need you to decide and draw
1. Our look, not theirs: the game's dark wood/brass HUD2 style (see docs/previews/ui_s185 + the HUD2 stills you marked earlier);
   gym, not broadcast. Icons with tooltips over text labels (operator rule) - e.g. a heart/lungs icon for ENERGY, a head for
   CONSCIOUSNESS (we call it HURT), a torso for CORE (body damage).
2. A FIRST-SPAR version that is calm: the four tug-of-war bars + energy + hurt, nothing else; the full punch table opens on click.
   Draw the calm version as the main image and the opened table as a small inset.
3. Where the plan change lives: one button/card "CHANGE ONE THING" after round 2 - show it.
4. Our two fighters: red corner = our boxer (green/red trunks today), blue = the sparring partner (headgear - it is a spar).
5. The 3D ring keeps the 16px-safe right side; the panel must not cover the fighters.

## Prefab check / what would a human do
Fight-night broadcast stat overlays (DAZN, Sky Boxing CompuBox graphics) use exactly these mirrored bars; borrow their clarity.

Reply with the image + 5-10 lines of the rules (font sizes, colours, what is hidden at first).
