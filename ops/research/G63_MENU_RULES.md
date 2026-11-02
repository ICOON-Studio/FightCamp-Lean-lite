# G63 — COMPETITOR MENUS, TORN DOWN INTO BUILDABLE RULES

**Owner:** grok. **Collected 2026-09-22 from the in-app browser**, conversation
`grok.com/c/2960b05e-0166-454f-9889-02bebb9af3f8`, Expert mode. Worked 53m 54s
over 113 sources. Grok has no checkout and cannot push, so this was read off the
page and landed by Claude; the text below is its reply, not a summary of it.

Every claim carries DOCUMENTED (it saw it in a screenshot or trailer, and says
which) or INFERENCE.

---

## Its own three-line lead

**Biggest layout difference:** the games that look "AAA" are **master-detail +
density machines** (8–12 roster rows + a live pane on one 1080p frame). The rest
are one portrait, four buttons, and dead space.

**Adopt first:** every athlete screen is a split — tight list left, selected body
right. **Never navigate to a new page just to see who you clicked.**

**Quality:** FM24's attribute grid is actually designed. Believr and Pound for
Pound are competent skins of that contract. Boxing Club Manager, World Boxing
Manager, Taekwondo Grand Prix and the unreleased Steam pages are **not** well
designed — they are decorated spreadsheets or 3D toys. MMA Sim King / PROMOTER /
THE FIGHT BUSINESS have almost no public UI; claims about them are marked.

**Coverage:** DOCUMENTED = Believr Steam shots (Locker Room, Business week grid,
promotion select), Pound for Pound Steam/community shots (bout compare, profile,
card, history), FM24/FM26 shots (squad planner, player profile, tactics, match
tiles), Pro Wrestling Sim awards/nav, World Boxing Manager fight + summary,
Boxing Club Manager store/review layout notes, Undisputed corner HUD (fight-HUD
analogue only). INFERENCE where a listed title has no usable screenshot.

## A. Persistent chrome (all mature UIs)

- A **40–56 px top bar** is always on: date, cash or equivalent, one world-status
  metric, search, primary advance control. Believr: date + $250,000 + "61% Pulse"
  + Search + SKIP TO SHOW + ADVANCE DAY. P4P: date + gold + ADVANCE WEEK. FM26:
  date-time + Continue. DOCUMENTED
- **Advance is one fat control**, right-aligned, highest chroma on the bar.
  Everything else is quieter. DOCUMENTED (Believr purple ADVANCE DAY; P4P yellow
  ADVANCE WEEK; FM26 gradient Continue)
- A **28–36 px footer** carries roster count, champions, prestige/save and
  keybinds. P4P: `Roster 80 | Champions 3 | Prestige 41` plus `[1] Main Event
  [Esc] Cancel`. DOCUMENTED
- **Left rail is 7±2 destinations**, icon + label, ~56–64 px collapsed / ~200 px
  open. Active item is fill + accent, **not a new colour system**. DOCUMENTED
- **Keyboard shortcuts are printed in the chrome**, not hidden in a help overlay.
  DOCUMENTED (P4P footer)

## B. Roster / fighter list

- **Master-detail, not page-per-fighter.** List is 28–34% of width, selected
  athlete fills the rest, changing selection does not change route. DOCUMENTED
- **Visible rows at 1080p: 8–10** in a card list (Believr), **16–22** in a data
  table (FM squad planner). **The indie tell is 4–5 huge cards.** DOCUMENTED
- Row, card style: 40–48 px square thumb | stacked name + handle/role | status
  chip | overall number right-aligned. DOCUMENTED
- Row, table style: colour swatch/flag | name | role | wage or rank | expiry |
  value-or-grade pill | stars. DOCUMENTED
- **Row height 36–44 px (table) or 52–64 px (card), rhythm even.** No alternating
  circus colours — selected row gets a **3–4 px left accent + slight fill**.
  DOCUMENTED
- **Long names:** one line, ellipsis after ~18–22 characters. Secondary line is
  70–80% type size and dimmer. **Never wrap to three lines.** DOCUMENTED
- Sort/filter live **above** the list: 4–6 compact dropdowns. Search is a single
  field, list-width. DOCUMENTED (Believr six filters + SEARCH ROSTER)
- **Pagination or virtual scroll.** Believr: `25 PER PAGE` + `1 / 2`. **Do not
  dump 80 faces.** DOCUMENTED
- **Empty list: one sentence in the pane, not a blank void.** FM: "No players in
  shortlist can play this position" + Add Players. DOCUMENTED
- **0-0 / no record still occupies the record slot** (`0-0` or `0W-0L`), never
  "N/A" and never hidden. INFERENCE from P4P records always present

## C. Fighter profile

- **Portrait is a column, not a stamp.** Believr/P4P ~28–36% width, head-to-waist
  or 3/4 body. FM uses a ~96 px headshot because the attribute grid is the
  product. **Pick one contract and keep it.** DOCUMENTED
- **Identity header is one strip, not five widgets:** GIVEN FAMILY | rank badge |
  ownership chip | one-line tape. P4P: `JOSE AUGUSTO 2 [YOUR ROSTER]` then
  `HEAVYWEIGHT · 6-1-0 · W1 · 20 years · 6'3" · 80" reach · 300 lbs · BR ·
  Submission Hunters · BJJ / Wrestling`. DOCUMENTED
- **Tape units are real units, not flavour.** Height with mark, reach with mark,
  weight with lbs/kg. Rank is a token (`W1`, `#2 Contender`), never a paragraph.
- **One primary grade top-right**, larger than body type: letter + modifier (`A-`)
  or CA/PA stars. **Never a second competing hero number** (Believr's 64 pop / 75
  overall pair is the exception — two heroes max). DOCUMENTED
- **Stats are a grid, not adjectives.** Two legal patterns:
  - *Number grid:* label left, optional thin bar, integer right, two columns.
  - *Bar grid:* label | bar **55–65% of cell** | number 1–20, grouped
    (Technical / Mental / Physical), key attributes get a fill behind the row.
- **Do not mix letter grades and 0–100 on one row** without a mapped key.
- **Type scale on a profile: FOUR SIZES ONLY**, ratio ~1 : 1.25 : 1.6 : 2.4 —
  at 1080p that is **11 / 14 / 18 / 28–32**. DOCUMENTED (counted off shots)
- **Tabs sit under the identity strip, not above the portrait.** Active tab =
  underline + weight, **not a new palette**. DOCUMENTED
- **Above the fold (first 700 px):** portrait + identity + primary grade + one
  status chip + first tab's summary. History and relationships scroll.
- **Status chips are short and coloured by state**, one chip row, not a paragraph.
- **Zero and empty are WRITTEN.** P4P: "No active rivalries." FM: "0 traits".
  **Never collapse the section.** DOCUMENTED
- **Numbers:** tabular lining figures; integers for ratings; money with currency
  and unit (`€8,500 p/w`); records `W-L-D`; times `R2 4:42`; four-digit money may
  compact (`€1.1M`). DOCUMENTED
- FM-style profile bottom: **5–7 equal tiles**, title dim, value loud.

## D. Booking / matchmaking / comparison

- **Two fighters compare as MIRRORED COLUMNS, not a paragraph** — left portrait +
  plate, right portrait + plate, stat axis down the middle. DOCUMENTED (P4P)
- Centre stack order: bout title → two hero grades → tab row → mirrored skill
  rows `grade | label | grade`. DOCUMENTED
- **Card list is a vertical stack of bout rows, not a poster wall.** Main Event
  row taller (~160 px), prelims shorter (~96 px). DOCUMENTED
- Slot chrome: colour pip + `MAIN EVENT · 5 ROUNDS`, fill count on the section
  (`3/3` green). DOCUMENTED
- **Confirm is one primary button centre-bottom**; destructive is red and
  smaller; Swap Corners is ghost. DOCUMENTED

## E. Calendar / day feed

- **A week is a GRID: 7 day columns × 4–5 dayparts.** Empty = `NO SHOW` or dashed
  `SELECT SLOT`. Occupied = one compact chip, **not a poster**. DOCUMENTED
- Month/year exist as alternate views, but **the working surface is week +
  agenda**. Year is dots only. DOCUMENTED
- **KPI strip above the grid:** 5–6 identical cards, value size 3, label size 1.
- **How much fits at 1080p:** week grid = **35 cells**; history = **6 event
  cards**; FM portal mixes 4–8 tiles. **"If your day feed shows 2 cards and a
  motivational quote, it is sparse."**

## F. Fight screen / HUD

- **Surround the bout with chrome that does not cover the bodies:** names + flags
  in the bottom third, clock centre, two resource bars. DOCUMENTED
- **Resource bars are two, stacked:** health/damage and gas. Undisputed adds a
  **10-row region panel per corner** (L.Head … R.Swell). DOCUMENTED
- If you show regions, they are **a compact labelled list with thin bars, not a
  full anatomy painting** — Undisputed: ~10 rows, ~180 px wide, both corners.
- **Player verbs while it runs:** skip/step, speed, throw-towel / corner, change
  tactic. Boxing Club Manager: style + intensity mid-fight, skip after 1:30,
  speed 0.5–2.5×. DOCUMENTED
- **FM match-day is the density ceiling:** two formation cards, dual stat bars,
  event list, mini-map, dugout decision, commentary ticker, full XI strip with
  ratings. **Tiles, not one canvas.** DOCUMENTED
- **Post-fight is a table, not a speech.** WBM: `Jabs 24/45` vs `14/37`, both
  columns, then the XP list. DOCUMENTED
- **Motion:** hard-cuts are the indie default. If you animate, **slide the detail
  pane 160–240 ms; do not fade the whole screen.** DOCUMENTED (notes) /
  INFERENCE (timing)

## G. Hierarchy, type, rhythm, state (cross-cutting)

- **FOUR emphasis levels, no more:** (1) advance/confirm, (2) name + primary
  grade, (3) numbers, (4) labels/chrome. **Level 4 is one step off the
  background, not a second accent colour.** DOCUMENTED
- **ONE accent.** Believr violet/gold, P4P yellow/blue, FM26 purple. **A second
  accent is only for danger.** DOCUMENTED
- **Spacing base 8 px.** Card padding 16. Section gap 16–24. **If padding exceeds
  32 between related numbers, you have dead space.** INFERENCE, measured off shots
- **Tabular numbers always.** Decimals only where the unit needs them. Ratings
  are integers or one decimal, **never `72.0`**. DOCUMENTED
- **Long name, empty list, zero value, no record each have a SPECIFIED
  rendering. That set is the AAA/indie split.** DOCUMENTED
- Letter grades use a **fixed ladder with modifiers** and a colour, not a unique
  swatch per grade. DOCUMENTED
- **Selection is never "make the whole card neon"** — accent bar + fill + maybe a
  check. DOCUMENTED

## Titles it could NOT tear down from pixels

- **MMA Sim King (4534230), PROMOTER (4448300), THE FIGHT BUSINESS (5249680)** —
  store pages exist, screenshot carousels yielded no buildable UI. **Treat as
  unproven.** DOCUMENTED (absence)
- **MMA Career Simulator (4465410)** — unreleased; shorts show health/stamina bars
  and a gameplan pane. Too little for row math.
- **Boxing Club Manager** — dashboard = upcoming fights + champions + finance +
  inbox; roster → profile → Arrange Fight; 3D bout with cardio/durability +
  tactic sliders. **Sparse list density vs FM.** Layout metrics INFERENCE.
- **Taekwondo Grand Prix** — a 3D fighter, not a manager. **Do not copy its menus.**
- **Pound for Pound is NOT on the title list** and is the only current MMA promo
  with a complete readable UI contract. Used as the combat-sport peer, labelled.

## 1. The three rules that would most change FightCamp

1. **Master-detail roster on the day feed and any athlete picker.** 9 rows left
   (thumb, name, record, one readiness number), selected athlete's body + tape +
   6-region readiness on the right. **Kills the "open a new screen to see the
   person you clicked" loop.** Maps to day feed + athlete profile + fight contract.
2. **Stat rows are `label | bar 55% | tabular number`, 28–32 px pitch, four type
   sizes only.** Apply in athlete profile and contract comparison. **UIKit owns
   this as ONE component.** FM already solved it; Believr almost did (numbers, no
   bars); **do not invent a third pattern.**
3. **Fight-night HUD is FM tiles, not a theatre poster:** region bars both
   corners, clock, two resources, one decision cluster (corner / pace / skip),
   ticker. Fight world live and fight night share that chrome. **You already have
   body regions; they are currently a feature without a density contract.**

## 2. The parity gap, in layout terms

- Persistent date/cash/advance chrome on every screen
- List + detail on one frame (8+ rows visible)
- Comparison as mirrored portraits + mirrored stat column, not two sequential profiles
- Calendar as a week grid with empty cells labelled, not only a vertical day feed
- Empty / zero / long-name recipes
- Printed keybinds and a count strip (`Roster n`)
- Four-size type scale and one accent

## 3. What they ALL do badly, and we can beat them on it

**Fight presentation.** Managers either hide the bout in a text log (WBM, PWS,
Believr show-runner) or wrap a videogame health bar around a 3D toy (BCM, TGP).
**Nobody puts region-level damage + live corner verbs + readable numbers on screen
at FM match-day density. That is the hole.** If FightCamp's fight night / fight
world live treats the six body regions as first-class HUD rows — same pitch as
profile stats, both corners, tabular, no flavour adjectives — **you are not
matching them. You are ahead of them.**

**Honest limit:** Believr's locker room already looks "expensive". Matching its
chrome without matching its 8-row list will still read indie. **Density first,
skin second.**

---

## CLAUDE'S NOTE — ONE CONFLICT TO SETTLE BEFORE EITHER IS WIRED

G63 and M22 disagree on the spacing base: **G63 says 8 px** ("card padding 16,
section gap 16–24", measured off competitor screenshots as INFERENCE) and **M22
says 4 px** with every step a multiple of 4. They are not reconcilable as
written, and whichever is chosen goes into `UITokens` once.

They AGREE on the stat row, which is the most-repeated element in the game:
**M22 says 30 px tall, three columns (label | bar | number); G63 says 28–32 px
pitch, bar at 55% of the cell, tabular number right.** 30 px sits inside G63's
band and the column contract is identical, so **that component is settled by two
independent sources** and should be built first.

They also agree on four type sizes and one accent. M22 supplies the hex values
and contrast ratios G63 does not, so the two are complementary: **M22 is the
palette and scale, G63 is the layout and density.**
