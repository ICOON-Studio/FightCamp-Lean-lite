# Training tab: three different approaches (S419, open brief)

The operator on the built Training week page (11-10): "i do no tlike much the design can we have some different approaches on this training tab your fonts are small too i think". On its row of seven small fatigue bars: "this needs to be displayed difrfentely". On its week fatigue bar: "again same meters". On its goal sentence: "toomuch text cut uncessary".
Earlier rulings that still hold: "panels look excel board" (S416: an icon, a number and a short caption; words go in tooltips); only show what the player can do something about (S398); "all designs look similar" (S411).

You are ONE of three designers. Each starts from a different idea (yours is at the bottom of your prompt). Do NOT open the current page's code or any still of it, and do not look at the other designers' files: a design that starts from the current screen comes back as the current screen.

## Read first
- `ops/research/CRITIC_PACK.md`: the whole game. Sections 4.1 (the week) and 4.2 (pads, combinations, mastery) are the mechanics of this tab.
- The approved look: `docs/mockups/s416/overview_painted_ludo.png` (open it): dark slate boards in wooden frames with brass corners, painted wooden tabs and buttons, chalk-white and gold lettering. Pieces you may use as images: `assets/ui/wood/*.png` (panel, plank, tab, bar, red). The look is settled; the LAYOUT and how things are shown is what you design.
- `docs/mockups/s403/roster_mma8.json`: the fighter on screen is Lucy Jackson from this file.

## What the player does on this tab (the whole job of the screen)
1. Seven mornings: each a session (roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow, neck work) at Light, Normal or Hard, or rest. Mornings add up toward ONE goal (for example Stamina 64.2 to 66 in 4 weeks).
2. Seven evenings: Pads, Sparring, Film or Rest. A pad night carries drill cards: a move or a combination whose mastery grows (New, Raw, Usable 30, Sharp 60, Signature 85).
3. Tiredness, 0 to 100, builds through the week and drops each night. From 80 gains fall and injury risk rises. This is the cost of every choice above, so it must be readable at a glance, ONCE, as a picture, never as seven small bars or a sentence.
4. The coach has already written the week and offers one change with its effect. The player accepts, edits or leaves it, then moves the week on.
5. With a fight booked: the fight day is on the week, and a diet choice (Hold / Cut).

## Hard rules
- 1920x1080, one HTML file, self-contained CSS (images by relative path). Render it: `python tools/render_mockup.py docs/mockups/s419/<your file>.html`, then OPEN the PNG and look at it; fix what is cut, overlapping or unreadable and render again.
- Type: nothing under 20 px; labels and numbers the player acts on 26 px or more; headings 40 px or more.
- Words: at most 70 words on the whole screen, not counting names of sessions and moves and the numbers. No sentence longer than 6 words. Everything else is an icon, a number, a shape, a colour or a position.
- Every element either lets the player do something or shows the cost or gain of a choice. Anything else is cut.
- Tiredness is drawn once, as a graphic.
- The page must show a believable full week (the coach's week, one evening being edited or selected) with real numbers that add up.
- Never "he" or "she": "Lucy" or "the boxer".
- Nothing opens on a monitor: file tools only, no browser, no image viewer.
- Write only inside `docs/mockups/s419/`.

## Hand back
The PNG path, then: your idea in two sentences; where the eye goes first, second, third; what each control changes; the word count; the smallest type size used; what you would cut next.
