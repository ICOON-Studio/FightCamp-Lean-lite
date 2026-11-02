# M40 - the week review look (Maria) - RAW CAPTURE, collected S146 2026-10-02 19:54
Brief: TASK_M40_THE_WEEK_REVIEW_LOOK.md. Lines may be cut at the app's display width (a few end mid-sentence).

M40 The week review. The hero is NET, because it's the only number on the board that can flip the mood of the week. The three short rows are IN against BILLS, the fighter gains, and the NEXT WEEK hooks. The one thing to look forward to is the middle hook, which sits right above the green button. All sizes are px at 1920×1080. Every string below is EXAMPLE, because Kalli owns the words. Type is Inter with tabular numbers, and the display face appears once, on the NET number.

Backdrop and card. Replaces the flat #3c3c3c page.

Backdrop: the HOME gym render, full bleed at 1920×1080, blurred 10 px, with a #2a2019 overlay at 40% so it stays bright and warm.
Card: 1440×840 at x240, y70. Fill #2a2019, radius 12, a 2 px brass border #f0c233 at 60%, and a soft shadow 0/12/32 at 45% black.
Padding: 40 px inside, so the content area is 1360 wide. The 24 px gap above the button leaves the bottom margin at 56.
Header: 76 px tall with a 1 px divider in #362a20. It holds Lucide calendar-days at 32 px in gold, then "Week 4 in review" at 30/700 in #f6eddc. On the right is a date pill in #362a20 with 18 px #b5a68c text, "Mon 26 Jan".

Monthly bill strip. Replaces the grey one-line text.

Size and position: 1360×56 at card x40, y160. Fill is amber #f0a020 at 16% with a 4 px solid amber bar on the left edge. Lucide calendar-clock at 28 px in amber.
Billed week: the text is 20 px #f6eddc ("Monthly bill paid this week"). On the right are two chips, users "Wages $3,200" and wrench "Upkeep $1,468", each 18 px on #362a20.
Other weeks: four 14 px pips, filled up to this week, and a "Bill due in 3 weeks" label. The pips use fill against outline, not hue, to show how close the bill is.
Tooltips: hover the chips for the full breakdown, so it needs no sentences.

NET hero. Replaces the small red or white NET number.

Plate: 640×280 at card x40, y232. Fill #362a20, with a 14% tint of good or bad on the left half, and a 2 px border in good or bad.
Icon and word: trending-down or trending-up at 56 px, then "NET" at 20/700 caps in #b5a68c. A chip reads "Loss week" or "Profit week" at 18 px, with an icon, so state never relies on colour alone.
The number: 96 px display face, with a sign and tabular figures. Loss is "−$3,852" in #f2766f (the lighter text red, for contrast on brown), and the plate border uses #e5433a. Profit is "+$1,240" in #4fc46a.
Underneath: wallet and "Balance $21,148" at 22 px in #f6eddc, then a delta chip "vs last week +$1,100" at 18 px, with chevron-up or chevron-down.
Sparkline: four bars (last four weeks), each 36 px wide, bottom-right of the plate. Bars above zero are #4fc46a, those below are #e5433a, and this week's bar has a 2 px gold outline.

IN and BILLS tiles. Replaces the two white-number columns.

Tiles: two tiles of 696×120 at card x944, y232 (IN) and y392 (BILLS), each in #2a2019 with a #362a20 1 px border. Between them, a "−" glyph at 32 px in #b5a68c. Between the NET plate and the tiles, an "=" glyph in the 24 px gap.
Content: arrow-down-to-line (IN) or receipt (BILLS) at 32 px, the label at 18 px in #b5a68c, and the amount at 56/700 in #f6eddc.
Scale bar: a 10 px bar along the bottom, both drawn to the same scale (the longer figure fills the tile). IN is #4fc46a, BILLS is #e5433a. A loss week then shows at a glance that the red bar is longer than the green one.
Tooltips: hover shows the sources.

Fighter block. Replaces the dense "STAT 31.1 -> 31.4" text.

Position: 1360×200 at card x40, y528.
Header row: 36 px with users at 24 px gold and "Your fighters" at 22/700. On the right, the results chip from item 7.
Per fighter: one row of 130 px. A 88 px portrait circle with a 3 px gold ring, then the name at 26/700 in #f6eddc, and a programme chip (dumbbell plus the programme name) at 18 px.
Stats: up to three stat blocks per fighter, 380×64 each with 20 px gaps, picked by biggest gain. A "+2 more" chip with a tooltip covers any extras. With more than two fighters, the list scrolls inside the card, and only the best fighter shows by default.

How a gain is drawn. Replaces the text pair with arrows.

Stat block: stat icon at 24 px (flame Power, zap Speed, shield Defence, wind Stamina, and so on) with the label at 18 px in #b5a68c. Then "31.1 → 31.4" at 18 px, tabular.
Bar: 280×14 on a #362a20 track. It shows the 5-point band that holds the value (here 30–35), so a 0.3 gain is about 17 px, not an invisible 3. The old part is #b5a68c. The gain segment is #4fc46a with a minimum width of 12 px and a bright 3 px cap, and diagonal stripes at 45° so it reads without colour. The band's end value (35) sits at the right of the bar in 14 px #b5a68c.
Pill: to the right, 64×28, fill #4fc46a, text "+0.3" at 18/700 in INK #1b1207, with chevrons-up at 16 px. Zero gain shows a muted "0.0" pill with minus, with no bar fill.
Best gain: the largest gain in the row gets a gold 2 px outline on its block and a sparkles icon at 20 px.
Band crossed: if a stat crosses a band, the bar refills in the next band and the pill adds arrow-up-to-line, in gold. That moment is the loudest thing on the board.

Results chip. Replaces the "29 RESULTS AROUND THE WORLD" line and the greyed "no bouts" sentence.

Chip: 260×36 at the right of the fighters header, fill #362a20, globe at 22 px, text "29 results" at 18 px in #f6eddc. A tooltip lists them.
If your gym fought: a second chip, swords plus W or L with the score, gold border on a win. If it didn't, show nothing at all, and drop the "no bouts" sentence.

NEXT WEEK hooks. Replaces the two hourglass lines.

Strip: 1360×136 at card x40, y744, in #362a20 with a 12 px radius. The label "Next week" sits at 20/700 gold with arrow-right at 24 px, top left.
Three hook cards: 420×76 each, 20 px gaps, in #2a2019 with a 1 px #362a20 border. Each has an icon in a 56 px circle on the left, a line at 20 px in #f6eddc, and a sub-line at 16 px in #b5a68c. Icons: hourglass (offer expiring, amber), swords (fight), user-plus (new scouting). Tooltips carry the detail.
Eye pull: the most urgent hook always sits in the middle, directly above the button. It gets a 2 px gold border and an amber countdown chip with timer ("1 week"). The hooks to its left and right are the other two. If there are fewer than three, the middle one stays and the others collapse.

The green button and the path to it. Replaces the wide grey-page pill.

Button: 560×80, centred at x680, y934. Fill #4fc46a, radius 40, text INK #1b1207 at 26/700, and chevron-right at 28 px on the right. The label is Kalli's. Gold is not used here, because gold is reserved for the main action on HOME, and this green is the Continue colour.
Path: a 2 px gold line, 24 px long, runs from the middle hook straight down to the button, so the eye falls from the urgent hook onto the button. Space or Enter both press it.
Hover and focus: the button lifts 2 px and gets a gold 2 px focus ring.

Reveal order and rules. Replaces everything appearing at once.

Sequence, 1.4 s total: card slides in at 240 ms, then NET counts up over 500 ms, then the IN and BILLS bars fill over 300 ms, then each gain bar fills over 400 ms, staggered by 120 ms. The hooks fade up over 200 ms, last. Any key or click jumps to the final state. A second visit to the same board shows the final state straight away.
No pulse and no loop. Everything happens once. Reduce-motion shows the final state.
Never colour alone. Every good or bad state carries a sign, an icon or a word. Every icon has a tooltip.
Bright and alive. The blurred gym stays visible around the card, and no surface goes darker than #2a2019.
No logos or brand names. All portraits are the fighters' own.
7:54 PM




