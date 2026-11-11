# Set X: the closest literal match to the gym screen (S431)

Two pages, 1920x1080, drawn to sit beside `../ref/gym_screen.png` as the same game.
- `squad.png` (`squad.html`): the page behind the gym's "Fighters" pin, all four fighters.
- `overview.png` (`overview.html`): one fighter, first tab. It is `../../s430/overview_a.html` with only the listed changes.

Rebuild: `python build.py` here, then from the repo root `python tools/render_mockup.py docs/mockups/s431/set_x/overview.html docs/mockups/s431/set_x/squad.html`.
`cut_figure.py` and `cut_faces.py` made `figure.png` and the `face_*.png` files. No game file was changed.

## Colours, sampled from the gym screen with PIL (not guessed)
| Hex | Where it is on the gym screen | Where I use it |
|---|---|---|
| `#1a1512` (wood, median of the bar) | top bar plank | top bar: the game's own `assets/ui/wood/bar.png`, laid as the game lays it |
| `#3b261e` | the light edge line under the bar (row 73) | comes with the bar texture |
| `#462f24` / `#473024` | Mail, NEEDS YOU and "More below" planks | Gym, Mail, NEEDS YOU; the three plank buttons on Squad (`plank.png`) |
| `#30251e` | the back, forward and Menu plates | the same three (`tab.png`) |
| `#6e9fe7` (code `#6ea2f2`) | the brush club name | club name |
| `#ede1cd` / `#efe2ce` (code `#efe6d8`) | date, Mail, NEEDS YOU words | the same words, and the words on planks |
| `#b6a487` (code `#b8a88f`) | "Week 2", "running -$680 a week" | the same two lines |
| `#e7bd55` (code `#e8c15a`) | the gold money number | the money number |
| `#1c2640` | the round pin's fill | portrait rings' backing, the state pin on each portrait, the coach's pin, the six body pins, the guide's ring |
| `#ffffff` | the pin's 3 px ring, the plate's words | every pin ring, plate words |
| `#e1473a` (code `#e2483d`) | the red "Fights" pin (it needs you) | Samira's pin, the "needs you" dot in the key |
| `#1d2741` | the navy name plate under a pin | fighter names, the tabs on both pages, the guide's bubble |
| `#252d45` | the news strip | "next fight" strips, the Squad news strip, the Overview's NEXT STEP strip |
| `#1a2033` / `#275696` / `#8eb9f3` | the strip's tag: back, left bar, words | every tag; `#275696` is also the chosen tab |
| `#574f52` / `#e04147` | the training mat and its red edge, where the Fighters pin stands | the floor under the figure on the Overview (dimmed for the dark page) |

Kept from overview_a, because he said "looks nice": the page's dark wall with a warm lamp, the meter colours (weak `#dd4b3d`, fair `#f28d27`, solid `#4d8ef0`, strong `#3fc07a`, elite `#ad80ff`), the white ceiling tick, the gold headings (`#ffd24a`), the gold button (`#ffe070` to `#f0b32a`).

## What I took from the gym screen
- The top bar, piece by piece from `Shell.gd`: 78 px, 18 px sides, 14 px gaps, 36 px arrow plates, the name in Permanent Marker 32, date 19 / week 15, planks 128x48, the money 24 / 15, NEEDS YOU 270x54, Menu. It uses the game's own wood cuts. Measured against today's build the pieces land within 1 px (Gym 656 to 780, Mail 789 to 920, money ends 1543, NEEDS YOU 1558 to 1824, Menu 1841 to 1899).
- One addition to the bar on an inner page: the "Gym" plank, the way back. It is what the build already shows on inner pages.
- NEEDS YOU stays the dark plank of the gym screen (today's inner pages paint it orange or red). The page's own next step is the one gold button.
- The pin: each fighter is a big pin (the face in the white ring) with the name on the navy plate under it, exactly the "Fighters" pin's shape. A small pin on the portrait says what is next; the red one is the fighter who needs an answer.
- The news strip with its blue tag: every "next fight" line, and the sentence at the top right, in the gym strip's own wording.
- Plank buttons: the gym screen has them below the bar too ("More below"), so the three quiet actions on Squad are planks.

## Wood: where it remains, read off the gym screen
The gym screen has wood in two places only: the top bar, and plank buttons. So: the top bar and plank buttons, nothing else. No wooden frame, no rivets. The floorboards under the figure in overview_a are gone; the figure stands on the gym's dark training mat with the red edge.

## Squad: what is on it
Four columns, one per fighter, no frames (a dotted line between them, like the Overview's leader lines).
Face and name, one line of facts, five numbers with the ceiling tick, TODAY (tiredness with rest days, weight against the limit, mood), "Coach says" (what the fighter needs this week, with its number), the next fight on a strip, one action.
Lucy: no bout, nationals open, "Enter the nationals". Samira: an offer waiting, red pin, the gold "Answer the offer". Tess: fights Saturday and needs four rest days, "Set the fight week". Ana (no-gi): open in 12 days, "Enter the open".
Rest days use the game's rule (`Aftermath.rest_days`: fresh under 50, a rest day leaves 87%). Weight limits 60 / 65 / 75 kg are the game's. A click on a face opens that fighter's page (not drawn as a button).

## Overview: the changes made to overview_a, and nothing else
1. Top bar: the gym screen's.
2. "Engine" is "Cardio".
3. On the scale: Freshness (five pips) became Tiredness: a bar to 100, the white tick at 80, the number, "Fresh, no rest day".
4. Six tabs: Profile, Condition, Training, Playbook, Fight plan, History, drawn as the gym's navy plates; the chosen one keeps its glow.
5. The real 3D figure, cut from today's Overview, twice its size there.
6. Ties to the gym: the NEXT STEP line sits on the news strip with a blue tag; each leader line ends in a small pin on the body; the guide's face is in a pin ring and the bubble is navy.
Also changed, to stay true: the guide's sentence (it said "sign a second boxer", which is wrong with four fighters) and the floor (see Wood).

## Unsure, his call
- Small words in the top bar: "Week 4", "running -$607 a week", the line under NEEDS YOU are 15 px and "Menu" 16 px, as on the gym screen. His rule is nothing under 20 px. I kept the bar a true copy; fixing it means changing the gym screen's bar too.
- The dates: both pages keep overview_a's day (Tue 27 Jan, week 4, $18,702), not the gym picture's (Mon 12 Jan). NEEDS YOU names Samira's offer so Lucy's page can keep "Enter Lucy for the nationals" unchanged.
- The guide (old trainer) is drawn on the Overview only. On Squad it would cover the bottom of Lucy's column (her strip and button). Either Squad gives up its bottom 190 px on the left, or the guide speaks from somewhere else on that page.
- "Compare two" as a tab on Squad comes from the menu proposal and the four-fighter scope; he has not picked the structure yet.
- Body pins: six small pins on the figure replace the plain dots. If they feel busy on the 3D body, the dots go back; nothing else depends on them.
- Mood and the grappler's "Blue belt, 41 of 60 hours" are shown as numbers; the build shows mood as a word only, and the belt bar's hours are made up for the picture. "Nia Okoro" is a made-up opponent.

## Still weak
- The figure is an upscaled cut-out (it is 440 px tall in the build), so it is soft, and its boots were traced by hand because they are black on black. A build would draw the live model.
- Squad is dense: eight meters a column. It reads across well, but a fighter with no problem looks as busy as one with three.
- The state pin on each portrait uses a calendar icon three times; only the red envelope reads at a glance.
- Most bars are blue (the true numbers sit 55 to 65), so the weapon and the weak spot do not jump out the way green and amber did in the earlier Squad drawing.
