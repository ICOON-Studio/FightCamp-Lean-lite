# Maria reply (Grok bot via gbot, S235, 9027 chars, verbatim)

**1. Body-wear figure: a stylised muscle map, front and back**

My pick is a flat, stylised muscle map in the style of sports-science apps, not a rendered MetaHuman body or a plain outline. Here's why:
- A muscle map reads its six regions as shapes. A rendered body at about 200 px tall turns into skin-tone mush with overlays floating on top, and it competes with the MetaHuman head render top-left, which is already the realism anchor.
- A plain outline has no inner areas to fill, so wear would only show as tinted outlines, which is weak at a glance.
- Flat vector panels can be tinted per region directly, need no render pipeline, and scale cleanly to 1080 and to a phone.
- Proportions are still traced from our own MetaHuman athletic male and female bodies in A-pose, front and back. That keeps the silhouette true to our fighters and gives the source a recorded origin. No MPFB, no stock anatomy art.

**Spec in the 480×420 panel**
- **Layout:** a 24 px panel title row and 24 px padding. The front and back figures stand side by side, each about 150×300 px with 40 px between them, centred, feet on a shared baseline. Small "FRONT" and "BACK" captions sit under the feet at 11 px, caps, 60% white.
- **Construction:** each figure is about 14 to 18 flat muscle panels grouped into the six regions. Head and neck, torso and core (chest, abs and obliques on the front; traps, lats and lower back on the back), arms (deltoid, biceps or triceps, forearm), and legs (quads or hamstrings, calf).
  - Panels are separated by 2 px gaps in the navy background colour, not by lines. That keeps it clean at small sizes.
  - The outer silhouette has a 1.5 px stroke at #2A3854.
  - The hands are simple mitts and the face is blank. The figure is a diagram, not a portrait.
- **Female variant:** the same panel set on the female MetaHuman proportions: narrower shoulders, a different waist-to-hip ratio and adjusted chest panels. The regions and colours are identical.
- **Left and right:** the regions are the fighter's own left and right. On the front view the fighter's left arm appears on the viewer's right. Put a tiny "L" and "R" at the shoulders, 10 px at 50% white, so nobody has to guess.

**The four wear colours on the navy (EXAMPLE values; check them against the S206 sheet)**

| State | Fill | Word |
|---|---|---|
| Pristine | #3A4A66 (cool slate, a quiet resting state) | PRISTINE |
| Fatigued | #C9A227 (our gold, muted) | FATIGUED |
| Degraded | #E07A2E (amber-orange) | DEGRADED |
| Critical | #D64545 (red, kept for the stoppage tier) | CRITICAL |

The fourth word, CRITICAL, is EXAMPLE because Kalli owns the words. Use three colours if the game only has three states.

State is never shown by colour alone:
- Every region carries its word and its %.
- Degraded and Critical regions also get a diagonal stripe at 12% opacity inside the panel. Use 6 px stripes, wide enough not to shimmer.
- Critical adds a small "!" in a circle on the panel.

**How a region shows DEGRADED**
- No pulsing or breathing animation; it's static.
- The region gets a 2 px inner stroke in its own colour, plus an outer glow of about 8 px blur at 35% opacity in the same colour, clipped to the figure.
- On hover, or when a label is selected, that region brightens by 15% and the others drop to 70%. It's a one-time change, not a loop.

**Where the % labels go**
- Six callouts sit outside the figures, three down the left edge of the panel and three down the right, connected by 1 px leader lines at #2A3854 that end in a 4 px dot on the region.
- Each callout is two lines:
  - The region name in caps, 11 px, 60% white, for example "LEFT ARM".
  - The value in the condensed sans, 18 px bold, in the state colour, then the word in caps, 11 px, for example "62%" then "DEGRADED".
- Put the arms and head on the shoulder side and the torso and legs lower down, so the leaders never cross the figure.
- Values come from the game. Any number in mocks is EXAMPLE.

**When every region is PRISTINE (the empty state)**
- The whole figure is in slate #3A4A66 with no glow and no stripes.
- The six callouts collapse into one line under the figures: "ALL REGIONS PRISTINE", 12 px caps, in gold. Under it, at 11 px, 50% white: "No wear carried from training or bouts" (EXAMPLE string).
- The figure stays visible, so the panel never looks broken. It looks like a clean medical card.

**2. The empty bottom-right panel: the weight-cut track**

I pick the weight-cut track over training milestones, sparring partners or a coach's note. It's the one thing a manager checks every week that has a hard deadline, it fills the space with a chart instead of text, and it ties straight to fight night.

Layout sketch for the panel below LAST 3 WEEKS (assumed about 480×420; match the actual panel):
- **Row 1, title (24 px):** "WEIGHT CUT" in 14 px caps gold, with the weight class on the right, for example "WELTERWEIGHT · 147 LB", at 12 px, 60% white.
- **Row 2, hero numbers (about 64 px), three columns:**
  - "CURRENT" with "152.4" at 32 px bold white.
  - "TARGET" with "147.0" at 32 px, 60% white.
  - "TO CUT" with "−5.4 lb" at 32 px, in a state colour (green on track, amber tight, red risky). It also gets a word ("ON TRACK", "TIGHT" or "RISKY"), never colour alone.
  - Labels are 11 px caps, 50% white. All numbers are EXAMPLE.
- **Row 3, the chart (about 200 px):**
  - A line chart of the last 6 weeks plus the weeks to the bout.
  - The actual weight is a 2 px white line with 4 px dots per weigh-in.
  - The planned cut is a dashed gold line from today to the weigh-in date.
  - The class limit is a thin horizontal line in slate, labelled at the right end.
  - Today is a vertical 1 px line marked "TODAY".
  - The weigh-in day is a vertical gold marker with a small scales icon.
  - The x-axis shows week labels at 10 px; the y-axis shows three values only.
- **Row 4, footer (about 56 px):**
  - On the left, "WEIGH-IN" followed by the date, and on the right "RATE NEEDED −0.9 lb/wk", both at 12 px.
  - One line from the coach at 12 px italic, 70% white, for example "Water cut last 48h only." (EXAMPLE string).
  - This absorbs the coach's note idea without giving it a whole panel.

With no bout booked, the chart shows the weight trend against the class limit only, with a footer line: "No weigh-in scheduled" (EXAMPLE).

**3. The bout-record panel with no bouts**

Replace the text with a record card that's real but empty, so the panel keeps the same shape it will have later.
- **Top row:** the record digits shown as "0 – 0 – 0" in the big condensed numerals (W–L–D), at 40 px, in 40% white, with "W", "L" and "D" captions underneath. Next to it, a "DEBUT PENDING" chip, in a gold outline with gold text at 12 px caps.
- **Middle:** three ghost rows in the exact layout of future bout rows: date, opponent, result chip and method. They're drawn as rounded bars at 6% white, with no fake data. This shows the shape the panel will fill into.
- **Bottom: a "PATH TO DEBUT" line from real game data.** For example: amateur record if the game tracks it, sparring rounds logged ("SPARRING 24 rds" EXAMPLE), the current readiness grade, and "NEXT: book a debut bout" as a gold text link that opens matchmaking.
  - If the game has none of that data, show only the 0–0–0 card and the chip. Don't invent filler.

**References and what to copy from each**
- **Football Manager player profile:** copy the dense, calm information hierarchy: small caps labels, big numbers, every panel filled, and the condition and injury readout as a body diagram with per-region status. FM also proves a flat figure works next to a real photo. I haven't checked the exact current-version layout of FM's injury diagram, so treat the specifics as NOT VERIFIED.
- **Fight Night Champion:** copy the boxing-specific damage idea: regions of the boxer marked as hurt between rounds, readable in a second. Copy the read, not the look, because ours is a calm management screen, not an in-fight overlay. The exact presentation of its damage screen is NOT VERIFIED from here.
- **WHOOP:** copy its strain and recovery language: one hero number, a state word, and colour bands on a dark background. That's the model for our callouts and the weight-cut hero row. I haven't checked whether WHOOP shows a muscle map; I'm citing it for its colour-state language only.
- **Hudl and sports-science body maps:** copy the flat muscle-panel body map, front and back side by side, with tinted regions and a legend. This is the figure style I picked. Which Hudl product, if any, shows one is NOT VERIFIED.

**What not to do**
- Don't put a rendered MetaHuman body in this panel: the head render already does the realism.
- Don't pulse or loop glows.
- Don't use teal for wear states; teal is UI only.
- No fine hatching under 6 px.
- No placeholder figures: every figure has to trace from our MetaHuman bodies, so the source is recorded.

I can mock this up as a 1920×1080 overview tab with both panels filled and send the PNG if you want to see it before Claude builds it.
