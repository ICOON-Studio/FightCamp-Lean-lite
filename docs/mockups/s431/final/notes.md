# Final set: Fighters page and fighter Profile tab, matched to the gym screen (S431)

Pictures: `squad.png`, `overview.png`, `side_by_side.png` (the real gym screen beside both pages, plus the shared parts cut
out at full size). All three are 1920x1080, opened after the last render, whole to the bottom edge, nothing clipped.
`build.py` writes the three HTML pages; `overview.html` is `s430/overview_a.html` with the changes below applied one by one
(each replacement is asserted, so nothing else in that drawing moved). No game file changed, nothing committed.

## Kept from the gym screen (colours sampled from ref/gym_screen.png with PIL)
| Part of the gym screen | Sampled | Where it is used |
|---|---|---|
| Top bar wood, its light edge | #191411, #1f1914 | The top bar on both pages, built from the game's own wood cuts (bar, plank, tab) |
| Plank buttons (Mail, NEEDS YOU, More below) | #463024 | Gym, Mail, NEEDS YOU in the top bar only |
| Dark plates (back, forward, Menu) | #332720 | The same three |
| Brush club name | #6e9fe7 | Club name |
| Date and plank words / quiet words | #ede0cc, #efe2ce / #b19f84 | Date, Mail, NEEDS YOU / "Week 2", "running -$680 a week" |
| Money | #e7bd56 | The money number |
| Pin: fill, white ring | #1c2640, #fdf9f2 | Body pins and group-title pins (Profile), fighter faces, action pins, coach pins, the page badge (Fighters) |
| Red pin | #e1473a | The one fighter who needs an answer (badge on the face, dot on the switcher) |
| Navy label and its words | #1c2741, #fffbf3 | Fighter names, weight class, tabs, action labels, "Coach" under the coach's face |
| News strip, tag bar, tag words | #252d44, #275696, #8fb9f3 | "Show in 19 days" next step (Profile), "This week" (Fighters), every small tag; #275696 is also the open tab |
| Training mat and its red edge | #584f52, #dc4048 | The floor under the 3D figure, dimmed |

Kept from overview_a because he said "looks nice": the dark frameless wall with the warm lamp, the coloured bars with the
white ceiling tick, the dotted leader lines, the gold button, the short captions, the type.

## Where wood remains
Read off the gym screen: it has wood only in the thin top bar and its plank buttons (plus "More below"). So on both pages
wood is the top bar and nothing below it. No frames, no rivets, no plank buttons under the bar. The inner pages add the
build's own "Gym" plank in the bar as the way back; there is no new shell.

## What the judges asked for, and what I did
Two of three judges picked set X; I started from its files (top bar, pins, faces, figure, mat).
- Both pages show the gym screen's own Monday (12 Jan, week 2, $16,841, Lucy's offer), not X's 27 Jan, so the three
  pictures are one moment of one game (two sets and two judges' drawings did this).
- Profile, inside his allowed list: gym top bar; Engine is Cardio; tiredness meter (bar with the "too tired from 80"
  zone, 38, "Fresh, no rest day") beside weight; six tabs as navy labels; the real 3D figure; next step on the blue-tag
  strip; 44 px icon pins on the body and the same pin before each group title (two judges).
- Profile, asked by all three judges and added: Mood as a third row (so the group is called TODAY, not "On the scale");
  "+ Cut" on a weight that is over; four face pins above the figure to step between fighters; weight class on a navy
  label with the style word and "1 win from the table". These go past his six listed changes: each is one line in
  build.py if he wants it out.
- The four quiet actions are the gym's pin fused to its navy label (two judges; one wanted wooden planks, but the gym
  screen has no wood below the bar). "Find a bout" is gone (an amateur cannot ask, and an offer is open): Compare takes
  its place. "Talk to Lucy" (no talk waiting) became Stipend, the fighter's weekly cost (two judges).
- Coach: the real face in the pin's ring, named "Coach", navy bubble, and the game's own "Do it" button in place of
  "Skip the guide"; the line points at the highlighted Inside fighting row.
- Legend cut to one line; the Legs caption says what the group does.
- Fighters page: one row a fighter, no boxes (all three judges praised the row pages most, and asked to drop X's 20
  stat bars and dotted dividers). From Z: overall ring, big-number tiles for tiredness, weight, mood, goal ring, the pin
  with its label as "Do next". From Y: "Coach says, this week" with its tag and weekly gain, the "This week" strip, Club
  week tab, "Find a fighter, 4 of 4 places taken". Gold only on the one answer that stops the clock.
- Judges split on comparing ability here (one wanted Y's table, two called it a spreadsheet). I drew five small bars a
  fighter, one per body group, under the same five pins as the Profile page, with a gold dot on the best of the four.
- Judges split on the per-row timeline (two for, one against as too small): left out; the days number and date say it.
- Weight with no bout booked is grey with its limit; amber only when a weigh-in is coming (one judge, plainly right).
- Not done, on purpose: weapons row, opponent estimate on the bars, injury pin, folding the character rows, a blurred
  gym backdrop. Each would change the drawing he approved or show a state that is not happening.
- Staff by role everywhere ("Coach says", "Coach is off Wednesday"); full names in headings, first names in text; no
  she or her.

## Still weak / his call
- The top bar's small lines (15 to 16 px) break his 20 px rule; they are the gym screen's own, copied as they are.
- "TODAY" replaced "On the scale", and the extras above go past his list.
- The figure is an enlargement of a 440 px render: slightly soft, boots traced by hand.
- Made up for the picture: Samira's, Tess's and Ana's numbers, moods and goals, the body-group numbers (averages), the
  open's date. Ana is drawn on the boxer's five groups; a no-gi athlete needs a body chart of its own before building.
- "Club week", "Compare two", "Rest 3 days" as one press and the "This week" strip come from agreed plans, not the build.
- The two "No bout" rows leave their Next fight cell thin.
- The Fighters page needs its one-line key because a picture cannot hover; in the game the five pins explain themselves
  on hover.
- In `side_by_side.png` the top-bar cut-outs show each bar's two ends; the middle (where inner pages add "Gym") is in
  the full pictures.
