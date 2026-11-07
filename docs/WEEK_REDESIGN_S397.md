# Week page redesign (S397)

Why: four fresh blind critics scored the Week page 5.5 in a row (r7-r9 stills, E:/FightCamp/tmp/s397). Polish stopped
moving it; the faults are structural (bars without numbers, three load words, picture-led day cards, invisible drag).
Process (operator S397): a free designer seat writes the 8/10 version, Claude owns the design, two fresh blind critics
must score it 8 before it is built, and the built stills are scored again.

## Designer seat: Cline 3.0.74, plan mode (design only), brief = the critics' merged faults + limits
Kept (Claude's verdict YES): numbers on every bar; a load meter with zones; a tiredness strip per day; L / N / H on each
morning; the morning card led by the session and its effect; PADS nights glowing on drag; locks in grey with "+ drill it"
as a normal button; one word set.
Not kept (NO): its sizes (7 x 280 px columns do not fit the 1640 px board; 520 px day columns push the week off screen);
"Intensity: Hard controls all sessions" (a second master control, the fault we are removing); a 4-colour bar key (numbers
replace the key); dropping tooltips (they stay for decimals).

## The design (Claude), v2 - after two critics at 6.5
Board 1640 px wide inside the page; everything down to the seven days fits 1080 without scrolling.

1. HEAD (one line, 56 px).
   "NEXT WEEK  Mon 9 - Sun 15 Feb, base week" on a weekend ("THIS WEEK" otherwise).
   EVENINGS, a read-out (no buttons): "3 pads, 1 sparring, 3 rest". The evenings are changed where they are, on the
   evening cards (5). "Coach's week" puts the coach's evenings and mornings back.
   Right: the WEEK LOAD meter, 260 x 14 px, counted in SESSIONS (a morning = 1, Hard = 2, a pads night = 1, sparring = 2):
   three zones on the track (easy to 8, steady to 13, full to 16, the coach's limit; past it the bar runs red), the fill
   to this week's count and the words beside it: "12 / 16 sessions - steady". Under it one muted line: "More sessions:
   the goal climbs faster, the fighter ends the days more tired."

2. LEARN tray (170 px cards, 4 + Build; more than four drillable cards adds "+2 more in the Playbook" under Build).
   Card: 72 px picture, name 22 px bold, tier word ("New", "Usable"). ONE text line over a clean 10 px bar:
   "24 -> 31 this week (usable at 30)"; the bar shows the same two parts (learned, this week) and one tick, unlabelled.
   One line under it, in plain words: "usable Wed" / "Not on a PADS night - drag it onto one" (grey, not red).
   A capped card: a grey chip "Capped by the cross (38)" and a normal outline "+ drill it" button.
   A card that reaches its tier this week keeps the gold border and a "★ Usable Wed" badge; the name still leads.

3. GOAL row (32 px). "GOAL  <attribute> 65, up a little by Sunday" and a 400 px bar from now to Sunday (decimals on
   hover). The attribute's name and numbers come from the week preview (data-driven: whatever named attribute the
   preview reports). Every morning that feeds the goal wears a small gold dot beside its session name.

4. COACH row (44 px), as now: his one line naming the day, "Do it", "Coach's week".

5. THE SEVEN DAYS (columns 226 px, gap 10). Row labels at the left edge, 14 px caps: MORNING, LOAD / TIRED, EVENING.
   Head: "MON  9 Feb".
   MORNING card, 88 px: a 56 px square crop of the station picture; the session name (18 px bold, the gold goal dot)
   and its effect in words from the preview ("Conditioning, up a little"; two lines when it trains two). A click opens
   the session picker (as now).
   LOAD / TIRED line, 28 px, under the card and outside it: on the left one chip with the full word, "Normal ▸"; a click
   steps it Light -> Normal -> Hard -> Light. Hovering the chip ghosts the tiredness the next word would give. On the
   right the day's end tiredness: a 10 px bar (green to 60, amber to 80, red past) and its number printed ("42"); a red
   day prints "in the red".
   EVENING card, 120 px, the same height for every kind. A click on any evening steps it Rest -> Pads -> Sparring -> Rest
   (a film night stays film); the head's read-out and the WEEK LOAD meter update at once, and the changed card flashes.
     PADS - the drilled card's name (20 px bold), "+7 -> 31" and its tier badge; a small 40 px picture; an empty PADS
     night reads "Drop a drill card here" inside a dashed edge.
     SPARRING - icon, the word, one line ("spars Uppercut").
     REST - "Rest" in grey on a flat card, and in small text "click: pads night".
   Drag: when a card is picked up (drag or click), every PADS night turns gold-edged and lifts its background; REST,
   SPARRING and FILM dim to 50 %. Dropping on a non-PADS night shows "Only PADS nights take a drill".

6. THIS CAMP stays below the week; its weight line and goals unchanged.

Removed: the bar key; the Light / Standard / Hard and Sparring 0 / 1 / 2 buttons (the evenings are edited in place);
the "Luke holds the pads, good kit" line (into the PADS tooltip); the LIGHT / NORMAL / HARD picture tags (the load
chip); the big station pictures on the days; the AM / PM corner labels (row labels instead).

Sizes: page head 180 + board head 56 + tray 200 + goal 32 + coach 44 + day heads 22 + mornings 88 + load line 28 +
evenings 120 + gaps 90 = 860 px, under 1080 with the top bar.

Rules this needs (no new mechanic, the evenings already exist): the week's exceptions gain per-evening kinds beside the
per-morning cards (WeekPhase edits); the pad-night count follows the evenings the player set (PadWeek.lay) instead of
the Light / Standard / Hard step; a camp keeps its own protocol until the player edits an evening.

## Scores
- v1 (Claude, from the Cline draft): critic A 6.5, critic B 6.5. Shared faults: head counts change evenings you cannot see; L/N/H too small on a clickable card; tiredness unlabelled; load has no unit; tiny decimals. v2 answers each.
- v2: critic C 6.5, critic D 6.5. Shared faults: evening click-cycling can drop a drill (a small Rest / Pads / Spar control on each evening head instead); the load chip wraps (use segmented L / N / H); four ways to edit (one grammar: popovers with previews); sessions /16 and tiredness /100 not linked (show each day's cost "+2"); gold means three things (drop targets in blue); no way to take a drill off; the goal needs an end point ("65 -> 67" with a target tick); lock wording ("Can't pass 38 until the cross improves"). Next: v3 (hand-over: ops/research/MENUS_STATE_S397.md).

## S398 rounds v3-v8 (menus side session 2, 2026-11-07)
Designer seat for v3: Cline 3.0.74 plan mode (`cline -p`, brief = v2 + the eight faults). Its draft kept three click-cycles,
12 px buttons, an invented "Mastered" tier and a goal-bar jump; Claude kept its x-off, blue drop targets, ladder-once and
cost chips, and wrote v3. From v5 on the design went to critics as a 1920x1080 HTML mock-up (Edge headless, the game's
fonts and colours, numbers from the game's own tiredness model) instead of text.
Decisions taken on the way: ONE effort scale = the model's tiredness 0-100 (the "16 blocks" was display-only and is gone);
every number carries its name; one edit grammar (click a card -> popover with the segment row + the list, previews on
hover); gold = goal only, blue = what you set, green = gains; attribute icon tiles (colours used for nothing else) instead
of the near-identical station photos; per-evening kinds (the approved rule change, now in PadWeek.with_evenings /
WeekPhase.edit_eve); the calendar first, plan totals under the head, the tray under the week.
| version | form | critic scores (fresh, blind) |
|---|---|---|
| v3 | text | 7.0 / 7.0 |
| v4 | text | 6.8 / 6.8 |
| v5 | mock-up | 6.8 / 6.9 |
| v6 | mock-up + popover still | 7.0 / 7.0 |
| v7 | mock-up + popover still | 6.8 / 7.0 |
| v8 | mock-up + popover still (docs/week_mock/) | 6.8 / 7.0 |
Stalled: every critic says "the structure is right, it reaches 8 with my fixes", and the fixes now contradict each other
(one decimal vs two, row labels vs none, visible segments vs hidden). Asked the operator (via the S398 main session)
whether to build at 7 and judge the built stills. Open faults several critics share: the popover must not cover what it
previews (open in the card's own column, keep the goal + meter strip pinned); one time span per row (the coach's Do it
says this week's change); the effort tag means effort only; THIS CAMP hidden when no fight is booked; the x at least 20 px.
