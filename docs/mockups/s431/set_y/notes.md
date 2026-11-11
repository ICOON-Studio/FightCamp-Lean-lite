# Set Y: Fighters (all four) and the fighter's Profile (S431)

Two pictures, 1920x1080, drawn to sit beside the gym screen (`../ref/gym_screen.png`), which is untouched.
- `squad.png` (`squad.html`): the page behind the gym's "Fighters" pin. Angle: the serious management sim.
- `overview.png` (`overview.html`): Lucy Jackson, first tab. It is `s430/overview_a` with only the listed changes.
- `figure.png`: the 3D figure cut out of `../ref/overview_today.png` by `cut_figure.py`.
- `gen.py` writes both HTML pages (`python docs/mockups/s431/set_y/gen.py`, then `python tools/render_mockup.py ...`).

Both pages show the same day as the gym screen (Mon 12 Jan 2026, week 2, $16,841, Lucy's bout offer open), so the three
pictures can be put side by side.

## Palette (sampled from gym_screen.png with PIL, not guessed)

| Hex | Where it is on the gym screen | Where I use it |
|---|---|---|
| `#19130f` to `#1b1512` | top bar wood (mean of the plank) | top bar (the game's own `assets/ui/wood/bar.png`), and the page wall starts at `#1b1512` |
| `#442c24` / `#4c3424` | wood-plank buttons (Mail, NEEDS YOU, More below) | the same planks (`plank.png`): Gym, Mail, NEEDS YOU, and "Answer" beside the strip |
| `#2c241c` / `#342c24` | darker plates (back, forward, Menu) | the same (`tab.png`) |
| `#6e9fe7` | club name, brush letters | club name |
| `#ede1cd` / `#efe2ce` | chalk white: date, button words | top bar words |
| `#b7a488` / `#b7a588` | quiet chalk: "Week 2", "running -$680 a week" | the same two lines |
| `#e5bc55` | the money number | the money number |
| `#1c2640` (pill `#1d2741`) | pin fill and the navy pill label | pins (page badge, session icons, ends of the leader lines), navy pills (weight class, style) |
| `#fdf9f1` (text `#fffbf3`) | the pin's white ring, pill words | rings round pins and faces, pill words |
| `#e1473a` | the red pin (it needs you) | the red "!" pin on Lucy's row, and that row's red wash |
| `#252d45` | the news strip | the strip top right on both pages |
| `#1a1f31`, `#275696`, `#8eb8f2` | the strip's tag: ground, left bar, letters | every tag (THIS WEEK, SHOW IN 19 DAYS, GOAL, FIX, REST, DRILL, OFFER, NOT ENTERED) |
| `#030302` | the dark margin round the gym picture | not used: the pages keep overview_a's warm dark wall |
| `#4c464b` to `#82767b` | the training floor (grey mat) | the floor under the figure, darkened (`#3b363a` to `#1b191b`) |

Kept from overview_a because he said it looks nice: gold `#ffd24a` (buttons, group titles), the meter colours weak
`#dd4b3d`, fair `#f28d27`, solid `#4d8ef0`, strong `#3fc07a`, elite `#ad80ff`, ink `#f1e8da`, quiet ink `#c9b9a2`.

## What I took from the gym screen

- THE TOP BAR, piece for piece: 76 px high, the same wood, brush name, date, planks, gold money, NEEDS YOU plank, Menu.
  Built from the game's own files and checked by laying my bar over the real one. Inner pages add the "Gym" plank
  with the bag icon, exactly where today's pages have it (`../ref/roster_today.png`): that is the way back to the gym.
- THE PIN: round, navy, white ring. It is the page badge beside "Fighters" (the pin you clicked), the session icon in
  "Coach says", the ring round every face, and the dot where a leader line meets the body. The red pin means the same
  as on the gym screen: this one needs you.
- THE NAVY PILL: weight class under each name, style in the lower table, "Lightweight" on the Profile.
- THE BLUE-TAG STRIP: top right on both pages, with a button beside it as on the gym screen. Its letters are scaled
  up (tag 20 px, text 22 px; the gym screen's are about 15 and 17).

## Wood: where it remains, read off the gym screen

On the gym screen wood is the top bar and the small plank buttons, nothing else: the picture has no wooden frame, the
pins and the strip are navy. So on my pages wood is the top bar and one plank button ("Answer"). No frames, no rivets,
no slate boards. The floorboards overview_a had under the figure became the gym's grey training floor.

## Squad page: what I decided

- One row a fighter, read left to right: who, what Coach says this week, tiredness, weight, mood, next fight, one button.
  Only Lucy's button is gold, because only Lucy's row stops the week (the top bar says the same).
- "Coach says" is one call each: the session, the number it moves, and a tag for why (GOAL, FIX, REST, DRILL). The
  seven squares are the mornings open for training (paid seat 6, college 4, shifts 2, three classes for the grappler).
- Tiredness: bar, number, word, and the rest days needed. The white tick and the red end are 80, where the game calls
  a fighter overreached.
- Weight: the white tick is the class limit; over it turns amber and says by how much.
- SIDE BY SIDE: the ten numbers every fighter has, in the groups of the body chart (Head, Hands, Guard, Cardio, Legs),
  so this table and the Profile page teach each other. Each cell is a number, a small meter and the ceiling tick; a gold
  dot marks the best of the four; Heart is striped (character, does not train). Last column: style and best move.
- Staff by role: "Coach says", "Slip rope with Coach", "Coach is off Wednesday". Fighters: full name in the row
  heading, first name in the table and in running text. No she / her / he / him anywhere.
- Tabs under the title (All four, Club week, Compare two, Find a fighter) are the proposed pages of this area, drawn
  like the fighter's tabs. They are not a new global menu; the structure is still his to decide.

## Overview page: the changes, and only these

1. Top bar: the gym screen's.
2. "Engine" is "Cardio" (also on the squad page).
3. "On the scale": weight against the limit (0.9 over, with "+ Cut"), and the tiredness meter: bar, 38, "Fresh, 0 rest
   days needed". It replaces the five freshness pips.
4. Six tabs: Profile, Condition, Training, Playbook, Fight plan, History.
5. The real 3D figure, 780 px tall, in place of the grey one. The six leader lines were moved to its hairline, glove,
   shoulder, chest, knee and boot.
6. Small ties: the "NEXT STEP" line is now the blue-tag strip (same gold button beside it), "Lightweight" is a navy
   pill, the line ends are small pins, the floor is the gym's.
Numbers are the build's for this day (`overview_today.png`): overall 59, record 3-1, weight 60.9, tiredness 38. The
goal block and the four action buttons are as on overview_a.

## What I am unsure of

- THE TOP BAR HAS TYPE UNDER 20 PX in the build: "Week 2", "running -$680 a week" and the second line of NEEDS YOU
  are 16 px. I copied them as they are, because the bar must be the gym screen's. If he wants them bigger, the gym
  screen's bar has to change too, and that is his call.
- "Rest days needed" has no rule in the game yet. I drew it as days of rest until tiredness is back under 50 (the
  point where heavy legs start to count on fight night). The rule needs deciding.
- The ten shared numbers: the game today gives the grappler six numbers, not ten. The table draws the agreed
  ten-attribute list for all four. Ana's numbers, and Samira's and Tess's, are made up for the picture; Lucy's are real.
- Faces: Lucy and Samira are their own (`Faces.CAST`). Tess and Ana are stand-ins from the game's cast.
- The bout sheet ("3 on the bout sheet"), mornings by job, the paid seat and "Coach says" pulls come from the agreed
  four-fighter and amateur-week plans, which are not built.
- Whether a grappler steps on a scale for an open: not established, so Ana's weight cell says "no weigh-in".

## What is still weak

- THE GUIDE: while the first-hour guide runs, the old trainer and the speech bubble sit bottom left (as on the
  Overview). On the squad page that corner holds the left half of SIDE BY SIDE. Either that band folds away until the
  guide ends, or the guide moves on this page. Not solved here.
- The figure is enlarged 1.8 times from a 440 px crop, so it is a little soft; the build would draw it sharp.
- The lower table is still a table. It is the right tool for comparing four people, but it is the part of the page
  closest to "excel board". If he dislikes it, "Compare two" can carry it and the four rows can grow taller.
- The guide's portrait on the Overview is still overview_a's drawn stand-in; I was told not to restyle the rest.
- The wood on the left 100 px of my top bar is a shade lighter than in the screenshot (the game seems to darken it).
