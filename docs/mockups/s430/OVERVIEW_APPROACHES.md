# Fighter page, Overview tab: three approaches (S430)

Owner, 2026-11-11, on today's Overview: "this screen on the bottom is clipped , also it doesnt look good at all those wooden panels i think need to go and change the design".

Pictures (1920x1080, each with the guide's portrait and bubble in place, nothing under 20 px):
- A: `overview_a.png` (`overview_a.html`)
- B: `overview_b.png` (`overview_b.html`)
- C: `overview_c.png` (`overview_c.html`)

The same in all three: the top bar and the four tabs as they are today; no wooden frame anywhere; one gold button on the page (Enter for the nationals); all 19 numbers with the white ceiling tick and this week's gain; weight, freshness, the goal; the four actions; a full-body figure (a grey placeholder for the real 3D model); the chosen tab and the hovered row marked by a soft glow.

## A. The body chart
- Idea: the figure stands in the middle and every number sits beside the part of the body it works in (Head, Hands, Guard, Engine, Legs, On the scale), tied to it by a chalk line.
- The player can: enter the nationals (top line, beside the tabs); press "+ Sparring" or "+ Mobility" on the weakest number of a group to add that session to the week; Plan the week, Fight plan, Find a bout, Talk.
- Cut: the whole "At a glance" panel. Best and weakest show in the bar colours, room to grow is the gap to the white tick, Temper keeps its word on its own row, style and "in the ring" stay on the Playbook where the plan is written. "Work on Coachability, Confidence" is gone because neither can be trained: character rows are striped and say what they do instead ("shouts land less").
- Weakest point: it regroups the numbers by body part, so Physical / Skill / Mind (the groups on the signing card and the week review) are not on this screen; the right column is the busiest of the three.
- Build in Godot: large. A new layout, five group boxes, chalk lines that must stay on the 3D figure's head, gloves, chest, knee and feet, and a new "+ session" button on a row.

## B. The clean sheet
- Idea: one calm slate sheet with the three groups as meters and "Today" under them, the figure beside it, and a rail on the right where each button sits under the fact that explains it.
- The player can: read a reason, then press its button. 44 days: Enter for the nationals. Goal, 18 days: Plan the week, Talk. No bout booked: Find a bout. 5 arrows drawn: Fight plan. "Train" on the weakest trainable numbers opens the week on that session.
- Cut: the six "At a glance" rows and the separate goal and body panels. Style and "in the ring" survive as one line on the Fight plan card, where they are used; the character numbers sit under one line saying training does not move them.
- Weakest point: the closest to today's screen. It fixes the frames, the clipping and the empty slate, but it is still a sheet of 19 bars and has the least to look at.
- Build in Godot: small. The rows, bars, goal and body pieces of DarkOverview.gd are reused; the frames come off, the glance panel becomes the rail, and one "Train" button is new.

## C. The tale of the tape
- Idea: a broadcast tape down the middle, the fighter in red on the left and the region's five best in the weight class in blue on the right, so every number reads as ahead, level or behind.
- The player can: see "5 ahead, 3 level, 10 behind" at a glance; press "+ Roadwork", "+ Slip rope" or "+ Sparring" on the three biggest gaps that training can close; switch the comparison to the next opponent once a bout is booked; enter the nationals, Talk, Plan the week, Find a bout, Fight plan.
- Cut: "At a glance" and the Weak-to-Elite colours (red and blue now mean the two corners). Character numbers are compared too but carry a lock and never appear under "Gaps you can train".
- Weakest point: it needs a number the game does not hold yet (the region's top five, attribute by attribute; the mockup's blue numbers are made up), the figure is the smallest of the three, and 19 tape rows are the densest read.
- Build in Godot: medium. The tape row is one new control; the region's averages must be worked out from the ranking table, and the opponent's side uses the estimate the bout page already shows.

## Notes for whoever builds the pick
- "Talk to <name>" exists in the game only while a goal talk is waiting. The pictures draw it so the layout is judged with all four actions; when no talk is waiting the button is not drawn (never greyed).
- The guide (portrait 190 px, bubble 452 px wide) keeps its bottom-left corner in all three: the page leaves x under 690, y over 876 free. Once the guide is skipped that corner is bare floor in A and C and bare wall in B; nothing moves.
- Wood that remains: floorboards under the figure (A), one thin ledge under the sheet (B), none (C).
- The goal flag on the Stamina bar (A, B) marks the goal's target (61) on the bar it belongs to.
- Mood (B, C) is the morale word the Roster cards already show.
- Fonts are the game's own (assets/fonts: Permanent Marker, Barlow, Bebas Neue, Kalam), loaded by relative path; the HTML has no network reference. `gen_overview.py` writes the three pages; edit it and re-run, then `python tools/render_mockup.py docs/mockups/s430/overview_a.html docs/mockups/s430/overview_b.html docs/mockups/s430/overview_c.html`.
