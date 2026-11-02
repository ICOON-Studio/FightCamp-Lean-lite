# M42 Hub mockups

*Maria, art direction. Pictures + redlines. No code. All player-facing strings are EXAMPLE (Kalli owns words). Always "the gym", never "camp" for the building. A fight camp is the pre-bout prep only. J62 / K86 have NOT landed — mocks follow Football Manager 24 and Motorsport Manager logic from knowledge; marked NOT VERIFIED against those transcripts.*

**NAV1 addendum (operator 2026-10-05):** go Option B (gym is the menu + timeline bar, hard pause on every decision, the week review and every dated gate). The Option A recommendation in §0 / §7 becomes acceptance criteria for **TIMELINE1** (what the timeline must still protect: week unit, week review, fight-camp countdown).

## 0. Answer first

Shipped five 1920×1080 hub mocks (coach candidate, fighter candidate, HOME booked, FIGHTS offers, FINANCE) plus one optional Option B board (gym-as-menu + timeline), all under `previews/`, dressed in the M32 palette and M33 type at the M40 quality bar. Every attribute is a labelled bar on a stated 0–100 scale with a band word; every card has one GOLD primary, one quiet secondary, and a tip dock that never covers the buttons. **Recommend Option A now** (rail + hubs, repaired): the week unit, the week review, and the fight-camp countdown need a discrete week, which Option B's continuous clock fights. Keep Option B as a pitched "live gym" mode for later, not the Early Access spine. [J]

---

## 1. Reference logic used

**Sources:** Football Manager 24 (staff / player shortlist panels, offer inbox, finances overview) and Motorsport Manager (race-weekend timeline, staff hire card, HQ as place) — from Maria's own knowledge. **J62_HUB_REFERENCE_LOGIC.md and K86_SCREEN_GAP_AUDIT.md have NOT landed.** Treat every field order below as a design proposal, not a verified transcript. NOT VERIFIED.

**What was copied as LOGIC (never as look):**

| Reference | Logic borrowed | Where it lands |
|---|---|---|
| FM24 staff / player shortlist | Identity strip → attributes on a stated scale with labels → one verdict / recommendation → wage ask → confirm / reject | Candidate coach + fighter |
| FM24 transfer / offer inbox | Filter strip → opponent identity → financial terms → date / venue → match-up sentence → Accept / Decline | FIGHTS — Offers |
| FM24 finances | Balance hero → weekly net with sign → next obligation → situation sentence → period bars | FINANCE |
| Motorsport Manager HQ | Building as place; click a room, a panel opens | HOME gym floor + Option B |
| Motorsport Manager race-day timeline | Dated chips ahead of a playhead; time controls | Option B only |
| M40 week review (operator-liked) | Hierarchy: one hero, then obligations, then list; brass warmth only where it fits the M32 shell | HOME right column, FINANCE heroes |

**What was NOT copied:** any FM / MM colour, type, icon, or layout pixel. House style is M32 lit blue-grey + M33 Inter + Lucide-named line icons drawn in Pillow.

---

## 2. Redlines per screen

Colour tokens used everywhere: `GROUND #1c2230`, `PANEL #2a3347`, `PANEL_HI #34405a`, `TRACK #111621`, `TEXT #f3f5fa`, `TEXT_2 #c9d1e0`, `MUTED #a3afc4`, `DIM #6d7688` (disabled only), `INK #1b1207`, `GOLD #f0c233` (one primary per board), `GO #22c55e` (Continue only, text INK), `GYM #2f6fb0`, `GOOD #4fc46a`, `AMBER #f0a020`, `BAD #e5433a`, `BAD_TEXT #f2766f`, `LINK #7fb6ee`. Type: Inter Variable — Label 15/600 CAPS ≤24ch tracked, Meta 15/450, Body 18/400, Group 22/600, Screen 30/650, Hero 44/650 + tnum. Sentence case except eyebrows.

### 2.1 Candidate — coach (`m42_candidate_coach.png`)

**Shell:** left rail 72px (Staff active), top bar 64px (gym name, week, cash labelled, Continue GO).

**Modal** 1000×820, centred over dimmed gym. Level-2 surface, r=14.

| Region | Words (EXAMPLE) | Size / weight | Token | Notes |
|---|---|---|---|---|
| Eyebrow | `COACH CANDIDATE` | Label 15/600 CAPS | MUTED | ≤24ch |
| Name | `Elena Vos` | Screen 30/650 | TEXT | |
| Flag | `CY` + tiny flag rect | Meta 14/600 | TEXT_2 | |
| Age / role | `Age 44 · Head coach` | Meta 15/450 | MUTED / TEXT_2 | |
| Availability | `29 weeks available` | Meta 15/450 | MUTED | right-aligned |
| Scale legend | `ATTRIBUTES · 0–100` + Poor / Average / Good / Strong / Elite | Label + 13/500 | band colours | stated scale, always |
| Attr rows | `Teaching 59 Good` · `Tactics 50 Average` · `Rating 55 Good` | Meta label + 18/650 number + 15/600 word | band colour on fill + word | never bare coloured boxes |
| Verdict eyebrow | `VERDICT` | Label | MUTED | |
| Verdict body | `Solid teacher for a regional gym; tactics will need a film partner.` | Body 18 | TEXT | one sentence |
| Ask label | `The ask` | Meta | MUTED | |
| Ask value | `$1,800 / week` | Group 22/600 | GOLD | unit always |
| Changes label | `What changes in your gym` | Meta | MUTED | |
| Changes body | `Adds a teaching focus on the training floor; wages +$1,800 / week.` | Body | TEXT_2 | one line |
| Primary | `Hire Elena` | 18/600 | INK on GOLD | bottom-right |
| Secondary | `Not now` | 17/600 | TEXT_2, PANEL_HI outline | left of primary |
| Tip dock | `TIP` / `Bars show band and number. Hire only if wages fit the week.` | Label + Meta | GOLD icon, TEXT_2 | bottom-left of modal; never over buttons |

**Tooltips (EXAMPLE):**
- Teaching bar: `Teaching · 0–100 · Good band starts at 55.`
- Hire Elena: `Confirm hire. Wages start this Monday.`
- Not now: `Close. Candidate stays on the shortlist for 2 weeks.`

**Empty state (no candidates):** modal replaced by a plate — `No coaches waiting.` / `Open Staff → Scout when a shortlist lands.` Primary becomes `Open Staff` (quiet).

**Guide home:** `guide_dock` component, docked bottom-left of the modal, never floating over the action row.

### 2.2 Candidate — fighter (`m42_candidate_fighter.png`)

Same shell and modal chrome as coach. Roster rail active.

| Region | Words (EXAMPLE) | Notes |
|---|---|---|
| Eyebrow | `FIGHTER CANDIDATE` | |
| Name / meta | `Kit Navarro` · `Age 19 · Light-welter` · `Amateur · Level 2` | |
| Attrs | `Power 62 Good` · `Speed 71 Strong` · `Chin 48 Average` · `Stamina 66 Good` | same `band_bar` |
| Verdict | `Fast hands, green chin — a craft programme first.` | |
| Ask | `$420 / week dues` | GOLD |
| Changes | `Opens a locker; dues +$420 / week; first fight bookable.` | |
| Primary / secondary | `Sign Kit` / `Pass` | |
| Tip | `Bars show band and number. Sign only if dues fit the week.` | |

**Tooltips (EXAMPLE):** `Sign Kit` → `Confirm signing. Dues start this Monday.` · `Chin` → `Chin · 0–100 · Average band is 40–54.`

### 2.3 HOME — one booked fighter (`m42_home_booked.png`)

**Shell:** Home rail active. Centre = stylized gym floor (warm light, RING gold outline, 6 pin discs: Train / Office / Locker / Staff / Ladder / Scout). Right column hierarchy is the fix.

| Block | Order | Words (EXAMPLE) | Type | Token |
|---|---|---|---|---|
| NEXT UP hero | 1 | eyebrow `NEXT UP` · `Kit Navarro` · `Fight in 3 weeks` · gold pill `Booked` · `vs Soren Haldane` · `Harbour Arena · Sat 15 Feb` · countdown `21 days` | Group / Body / Meta / 22 tnum | surface level 3 (gym wash); pill INK on GOLD |
| Obligations | 2 | eyebrow `OBLIGATIONS` · three chips: `Lease Due Fri $2,400` · `Wages Due Mon $3,200` · `Bills Due Wed $480` | Meta + 18/650 | surface level 1; icons building / users / clipboard |
| Your fighters | 3 | eyebrow `YOUR FIGHTERS` · meta `1 booked · 1 on roster` · row Kit + `Booked` pill · empty slot `Scout a second fighter` / `Empty locker — open scouting` | Body / Meta | level 2 row; empty = outline only |
| Floor tip | — | `Click a pin to open that room` | Meta | LINK info icon |

**Tooltips (EXAMPLE):**
- Booked pill: `Fight booked. Opens the fight-camp countdown on Schedule.`
- Lease chip: `Lease due Friday · $2,400.`
- Scout pin: `Open scouting. Find a second fighter.`
- Continue: `Advance one week. Bills and calls land on Monday.`

**Empty state (no booked fight):** NEXT UP becomes `No fight booked` / `Open Fights to take an offer.` Primary quiet button `Open Fights`.

### 2.4 FIGHTS — Offers (`m42_fights_offers.png`)

**Shell:** Fights rail active. Title `Fight offers` (Screen 30/650). Meta `3 open · sorted by date`.

**Filter strip** (`filter_strip`): `All` (active, GYM fill) / `Regional` / `Title` — pill height 36, 16/600.

**Offer row** (`offer_row`) — one per card, 168px tall:

| Field | Words (EXAMPLE) | Type | Token |
|---|---|---|---|
| Opponent | silhouette + `Soren Haldane` | Group 22/600 | TEXT |
| Record / div | `12–2 · Light-welter · Regional` | 18/650 + Meta | TEXT_2 / MUTED |
| Match-up | `Even on paper — his pressure vs your reach.` | Body | TEXT_2 |
| Purse eyebrow | `PURSE` | Label | MUTED |
| Purse | `$8,400` | 26/650 | GOLD |
| Date / venue | `Sat 15 Feb` · `Harbour Arena` + map-pin | Meta | TEXT_2 / MUTED |
| Primary | `Accept` | 18/600 | INK on GOLD, top-right of row |
| Secondary | `Decline` | 16/600 | quiet, under Accept |

Featured (first) row uses surface level 2; others level 1. Same pattern for Marco Vellin and Ilya Petrov (see mock).

**Tooltips (EXAMPLE):** `Accept` → `Book this fight. Opens the fight-camp countdown.` · `Decline` → `Remove offer. Promoter may not return this card.` · filter `Title` → `Show title fights only.`

**Empty state:** `No offers waiting.` / `Promoters call when a fighter is sharp and free.` Quiet `Open Roster`.

### 2.5 FINANCE overview (`m42_finance.png`)

**Shell:** Finance rail active. Title `Finance`. Meta `Week 4 · cash on hand`.

| Block | Words (EXAMPLE) | Type | Token |
|---|---|---|---|
| Balance hero | eyebrow `BALANCE` · `$24,180` · pill `Cash on hand` | Hero 44/650 tnum | surface level 3 |
| Weekly net | eyebrow `WEEKLY NET` · `−$312` + trending-down · pill `Loss week` | Hero | BAD_TEXT; glyph + word (never hue alone) |
| Next bill | eyebrow `NEXT BILL` · `Wages due Mon` · `$3,200` · `Lease chip still on the calendar` | Group + 28/650 | AMBER value |
| Situation | `Two profitable weeks would clear the lease chip.` | Body | TEXT on sunk plate; LINK info icon |
| Last four weeks | `W1 +$840` · `W2 −$210` · `W3 +$420` · `W4 −$312` | 16/650 tnum | GOOD / BAD_TEXT bars around a zero line |
| This week | `Dues in +$420` · `Purse (none) $0` · `Wages −$3,200` · `Lease −$2,400` · `Bills −$480` | Body + 18/650 | sign + colour + icon each row |

M40 brass warmth was considered and **cut** here in favour of M32 shell consistency; hierarchy (NET hero, IN vs BILLS, next hooks) is what was borrowed. [J]

**Tooltips (EXAMPLE):** `Loss week` → `Outgoings beat income this week by $312.` · `Wages due Mon` → `Staff and fighter wages clear every Monday.`

**Empty / first week:** bars show a single `W1` with `No history yet`; situation becomes `Your first week sets the baseline.`

### 2.6 Option B board (`m42_option_b_timeline.png`) — optional

No left rail. Timeline bar 72px across the top: Pause (active) / 1× / 3×, date, track with playhead, dated chips (`Wages`, `Weigh-in`, `Fight night`, `Offer ends`), cash right. Full-bleed gym floor. Office pin flashing gold. Decision panel over the 3D view with gold edge, `Time paused` pill, Vale offer, Sign / Decline, tip dock. Footer legend: `Option B · gym is the menu · timeline across top`.

**Decision-due rule (picked):** time **stops** and a **card opens** over the gym; the triggering pin flashes gold until the card is resolved. No silent auto-resolve. [J]

## 3. New components (named once)

| Component | What it is | Used on |
|---|---|---|
| `candidate_card` | Modal: identity strip + band attrs + verdict + ask + changes + primary/secondary | Coach, Fighter |
| `band_bar` | Label · track 0–100 · fill in band colour · number · band word | Candidate cards |
| `guide_dock` | Tip plate docked bottom-left of a modal; never covers actions | Candidates, Option B |
| `offer_row` | Opponent card · purse · date · venue · match-up · Accept / Decline | FIGHTS offers |
| `next_up_hero` | Level-3 right-column hero: portrait, countdown, Booked pill | HOME |
| `obligation_chip` | Icon + label + due date + amount | HOME |
| `timeline_bar` | Speed controls + playhead + dated chips + cash | Option B |
| `gym_floor_stage` | Warm-lit floor, RING, pin discs | HOME, Option B |

---

## 4. UIKit reuse

Existing (`Godot/scripts/UIKit.gd`) — design with what exists:

| UIKit | How M42 uses it |
|---|---|
| `pair` | Ask label/value, obligation label/amount, finance row label/amount |
| `plate` | Verdict sunk plate, situation sentence, tip dock body |
| `button` | Primary GOLD, quiet outline, Continue GO — map to existing kinds |
| `filter_strip` | FIGHTS All / Regional / Title |
| `tip` | Becomes the visual content inside `guide_dock` (new home, same words) |

New components above are **named once** for engineering; they compose UIKit primitives where they fit. No `.gd` in this pack.

---

## 5. OPTION A — rail + hubs, repaired (one page)

**Spine:** left rail stays. Each hub is a screen. Time advances in **weeks** via Continue (GO). Story cards and bills land on Monday. Fight-camp countdown is a visible week chip on NEXT UP and Schedule.

**First hour, minute by minute (Chapter 1 — The Keys):**

| Min | What the player sees (Option A) |
|---|---|
| 0–2 | Title → New Career (3 screens: division, gym name, Story on/off) |
| 2–5 | HOME loads. NEXT UP empty. Tip: `Sign your first boxer.` Office pin pulses once. |
| 5–12 | Scout from Roster / Scout pin → fighter `candidate_card` (Kit). Sign. |
| 12–18 | Training floor via Train pin / rail. Pick a station for Kit. |
| 18–22 | Staff → coach `candidate_card` (Elena or Rafi). Hire or pass. |
| 22–28 | FIGHTS → Offers (or a first amateur card). Accept one. NEXT UP becomes the hero. |
| 28–35 | Continue ×2. Week review (M40). Lease chip appears on Obligations. |
| 35–48 | Fight night from Schedule / Continue. Ring, corner, scorebug, result. |
| 48–55 | Result → HOME. Clipping on the Wall (story). NEXT UP clears or shows rematch hook. |
| 55–60 | Chapter card. Demo ends on `Someone left a card at the front door.` |

**What A keeps:** one-decision-a-day rhythm, M40 week review, fight-camp countdown in weeks, rail as a map of verbs, guide tips that have a fixed home.

**What A costs:** the gym floor is a stage behind hubs, not the menu itself; some players will still feel "menu-y". [J]

---

## 6. OPTION B — gym-as-menu + timeline (one page)

**Spine:** no left rail. The 3D gym **is** Home. Click a room, a person, or the ring → a panel opens **over** the 3D view. A **timeline bar** across the top runs time continuously (Pause / 1× / 3×) and **pauses whenever any panel is open**. Dated chips sit on the bar ahead of the playhead: weigh-in, fight night, bills, offers expiring.

**Reference behaviours (from knowledge — NOT VERIFIED against transcripts):**

| Game | When a decision is due |
|---|---|
| Two Point Hospital | Clock runs; a flashing queue / alert icon appears; opening the panel does not always hard-pause unless you pause. |
| Planet Coaster / Prison Architect | Click object → panel over world; time keeps running unless the player pauses — urgency is soft. |
| Motorsport Manager (race day) | Timeline chips; session phases pause for setup decisions; race itself runs with limited intervention. |
| Football Manager | No real-time clock — **continue-until-next-event**. Interruptions are cards between continues, not a live playhead. |

**FightCamp Option B pick:** hard-pause + card (Motorsport session decision × FM card). A flashing pin marks the room. Time does not crawl behind a half-read offer. [J]

**What a boxing-gym manager gains:**
- The gym feels like a place, not a spreadsheet with a wallpaper.
- Dated chips make fight night, weigh-in and bills *visible ahead of the playhead*.
- Panels-over-world matches how the operator asked to "pose in menus".

**What a boxing-gym manager loses:**
- **One-decision-a-day rhythm** dissolves into continuous time; the player can overspeed past a lease chip.
- **Week review (M40)** has no natural home — a week is no longer a unit unless we fake week boundaries on the bar.
- **Fight-camp countdown** (3 weeks out) becomes a distance on a scrubber, easier to miss than a NEXT UP hero with `21 days`.
- Teaching / guide cards compete with a live clock; pause discipline becomes a skill.

**First hour, same walkthrough (Option B):**

| Min | What the player sees (Option B) |
|---|---|
| 0–2 | Title → New Career. Drops into the gym with timeline on Pause. |
| 2–5 | Locker pin flashes. Tip dock: `Sign your first boxer.` Open locker → scout list panel. |
| 5–12 | Fighter candidate panel over gym. Sign Kit. Pin stops flashing. |
| 12–18 | Click Train pin → training panel. Assign Kit. Close panel. |
| 18–22 | Staff pin flashes (coach card). Hire or pass. |
| 22–28 | Ring pin / Fights chip on timeline → offers panel. Accept. `Fight night` chip appears ~21 days ahead. |
| 28–35 | Set speed 1×. Playhead moves. `Wages` chip arrives → auto-pause + wages panel. Resolve. |
| 35–48 | Playhead hits `Fight night` → hard pause, walkout panel, then fight. |
| 48–55 | Aftermath panel over gym. Wall updates. |
| 55–60 | Chapter card. Same demo hook. |

---

## 7. Same first hour — A vs B

| Beat | Option A (rail + hubs) | Option B (gym + timeline) |
|---|---|---|
| Sign first fighter | Roster / Scout rail → candidate modal | Flashing Locker pin → panel over gym |
| Hire coach | Staff rail → candidate modal | Flashing Staff pin → panel over gym |
| Book first fight | Fights hub → offer_row Accept | Timeline chip or Ring pin → offers panel |
| Feel time pass | Continue (week) | Playhead + speed; Pause on panels |
| See the lease | Obligations on HOME; week review | `Wages` / bill chips on the bar |
| Fight-camp countdown | NEXT UP `Fight in 3 weeks` + `21 days` | Distance to `Fight night` chip |
| Guide / tip home | `guide_dock` on modal; handbook pages | Same dock; must not fight the clock |
| Demo end | Chapter card on HOME | Chapter card over gym, timeline paused |

**Recommendation [J]:** Ship **Option A** for Early Access. It protects the M40 week-review quality bar, the one-decision-a-day teaching loop, and the fight-camp countdown the operator already understands. Build Option B as a design pitch / later "Live Gym" mode once the hubs are repaired and the week loop is loved. Do not rip the rail out before the candidate card and HOME hierarchy ship.

---

## 8. Cut list / open flags

**Cut first if scope slips:**
1. Option B board (keep the page in this MD; drop the PNG from the land if needed).
2. Featured vs normal offer_row elevation (one surface level is enough).
3. Four-week finance bars (keep Balance / Net / Next bill / situation sentence).

**Open flags:**
- J62 / K86 not landed — re-check field order when John / Kalli ship. NOT VERIFIED.
- Fighter vs coach candidate share one `candidate_card` layout; confirm with engineering that one scene + data swap is enough.
- HOME gym floor is a **stylized stand-in**; final art uses the real 3D gym (M41 tree). Pins must match live room names.
- Continue GO stays the only green button; never reuse GO for Accept.
- Story Wall / chapter card not mocked here (see STORY1_MARIA / M34) — HOME only shows the hook line in NEXT UP empty state.
- MMA hooks: offer filters gain `MMA` later; band_bar and candidate_card stay sport-agnostic.

---

## 9. Self-attack

- **These are still panels.** A player who hates management UIs will still see a modal. Option B is the honest answer to that hate, and we are recommending A — that is a tradeoff, not a dodge. [J]
- **Band words can lie.** "Good" at 55 and "Good" at 69 feel different; if playtests confuse them, split Good into two bands or show the numeric range in the tooltip only — do not add more colours. [J]
- **HOME right column is dense.** Obligations + fighters under NEXT UP may still feel like a stack on small laptops; if so, collapse Obligations to a single `3 due this week` chip that opens a plate. [J]
- **Reference logic is from memory.** When J62 lands, any field John transcribed that we missed should win over this pack. NOT VERIFIED.
- **Silhouette portraits are honest placeholders.** Shipping them as final would look cheap next to a 3D fighter; they are the M33 rule until photo / render portraits exist.
- **Option B hard-pause may feel stop-start** in a long week with many chips; if we ever build it, cap to one auto-pause per day and queue the rest. [J]

---

*Pack paths (Beast staging targets): `research/M42_HUB_MOCKUPS.md`, `research/previews/m42/*.png`. Renderer: `render_m42.py` (Pillow, 2× supersample, LANCZOS). No `.gd` / `.tscn` / git commits in this pack.*

---

### Component redline extract (for TIMELINE1 / Claude land)

**Colour tokens (all screens):** `GROUND #1c2230` · `PANEL #2a3347` · `PANEL_HI #34405a` · `TRACK #111621` · `TEXT #f3f5fa` · `TEXT_2 #c9d1e0` · `MUTED #a3afc4` · `DIM #6d7688` (disabled only) · `INK #1b1207` · `GOLD #f0c233` (one primary per board) · `GO #22c55e` (Continue only, text INK) · `GYM #2f6fb0` · `GOOD #4fc46a` · `AMBER #f0a020` · `BAD #e5433a` · `BAD_TEXT #f2766f` · `LINK #7fb6ee`.

**`band_bar` bands (0–100):** Poor 0–39 `BAD_TEXT` · Average 40–54 `MUTED` · Good 55–69 `GOOD` · Strong 70–84 `LINK` · Elite 85–100 `GOLD`. Always: label + fill + number + band word (never hue alone).

**`candidate_card` tooltips (EXAMPLE):** Teaching `Teaching · 0–100 · Good band starts at 55.` · Hire `Confirm hire. Wages start this Monday.` · Not now `Close. Candidate stays on the shortlist for 2 weeks.` · Sign Kit `Confirm signing. Dues start this Monday.` · Chin `Chin · 0–100 · Average band is 40–54.`

**`offer_row` tooltips (EXAMPLE):** Accept `Book this fight. Opens the fight-camp countdown.` · Decline `Remove offer. Promoter may not return this card.` · Title filter `Show title fights only.`

**`timeline_bar` (Option B / NAV1 go):** height 72px · Pause / 1× / 3× · date · track + playhead · dated chips ahead (`Wages`, `Weigh-in`, `Fight night`, `Offer ends`) · cash right. **Hard pause on every decision** (panel open, week review, every dated gate). Triggering pin flashes GOLD until resolved. No silent auto-resolve.

**TIMELINE1 acceptance (from my A recommendation):** the timeline must still protect (1) a discrete week unit, (2) the M40 week review as a gate, (3) a fight-camp countdown readable as weeks/`21 days`, not only as scrubber distance.