# AAA Profile Art Brief — Cage Desk

Status: **PROFILE ART KICKOFF COMPLETE** · 2026-09-06 · boards 01–10 · Version A working target  
Owner: Maria Art Director · Game: FightCamp · Godot 4.7.2  
Scope: **art boards + visual rules only.** No `.gd` / `.tscn` / `HANDOFF.md` edits.  
Claude implements UI later when the operator says go. Kalli may run study boards in parallel.

Sources: `STYLE_GUIDE_CAGE_DESK.md`, `ART_DIRECTION_CAGE_DESK.md`, `PROFILE_DESIGN_BRIEF.md`, `PROFILE_IA_THREE_VERSIONS.md`, M2 Cage Desk delivery, AAA HTML previews in `fightcamp-design/`.

---

## 1. Recommended IA (Maria art recommendation — not product-locked)

**Pick: Version A — Command Deck.**

**Why (one line):** A’s Overview→Alerts / Next Bout / Form / Attributes desk matches Cage Desk’s “desk first, drama second” instrument chrome better than B’s Tonight broadcast hero or C’s ten-tab console hop.

**Working art target:** Version A Command Deck (operator skipped formal IA lock — proceed on A; not product-locked). All profile art studies target A’s landing hierarchy and persistent identity strip. Do not invent tab names beyond the brief / IA doc.

| If operator later picks… | Art impact |
| --- | --- |
| **A** (this rec) | Boards already match; deepen Alerts+Next Bout instruments |
| **B** Broadcast | Reuse identity strip; compose a Tonight surface — keep sodium/ice drama *on plates*, not gold spam on chrome |
| **C** Athlete OS | Same strip + empty states; more shallow door posters, less dense Overview |

Keep Version A’s Career Desk Deal packing (loyalty + clauses + promotion) as the depth pattern wherever Business/Deal lands.

---

## 2. What fights Cage Desk in existing AAA HTML

Reviewed: `PROFILE_AAA_TOPURIA.html`, `PROFILE_ORIGINAL_AAA.html`, `PROFILE_PREVIEW_2026-09-04.html`, design assets `fighter-hero-plate.png` vs M2 `plate_fighter_identity.png`.

| Conflict | Where | Cage Desk fix |
| --- | --- | --- |
| Photoreal hero (pores / sweat cinema) | `fighter-hero-plate.png`, circular portrait glow in AAA idcard | Use graphic sil poster `plate_fighter_identity` only |
| CONTINUE painted gold | Header `.continue` uses gold gradient | CONTINUE = `#2ECC71` only |
| Gold spam | Multiple gold chips, gold overall numbers, gold glow buttons, gold rail ticks | Gold ×1 primary CTA per board |
| Soft neon / glow dots | `.dot` box-shadow blooms | Flat semantic fills; rim colour yes, outline glow no |
| Lit ground `#1c2230` + gym-blue heavy chrome | AAA CSS `--ground` / `--gym` washes | Canvas `#0B1220`; select `#3A6FD8`; condition cyan separate from gym accent |
| Animated gold motes / shaft | AAA backdrop | No decorative gold motion on shipping desk |
| Heat ramp on attribute bars as default | `.gb .fill` red→gold | Attributes = cool/condition instrument language; heat only for rivalry/hype |

**Blocker note:** Headless Chromium on this box illegal-instruction’d before writing a PNG of the AAA HTML. CSS + asset read still sufficient for rules above. Optional later: re-render on a machine with working Chrome.

---

## 3. Profile visual rules (locked under Cage Desk)

### Persistent identity strip (all tabs)
- Left: graphic fighter plate (sil / sodium key + ice rim) — never photoreal.
- Centre: name (Bebas display), discipline + division **chips** (select/slate, not gold), country · age · record, status chips.
- Right instruments: **overall dial** (current letter vs potential tick), fame/rank medal slot, **belt/trophy shelf** (graphic metal, transparent props).
- Strip chrome = `panel` / `panel_edge`; strip never changes between tabs.

### Left nav rail
- Always present, collapsible. Active row = `select` wash + hairline — not gold.
- Breadcrumb: `OFFICE › FIGHTERS › NAME › TAB`.

### Decide-first alerts
- Open ask / presser / doctor hold / poach surfaces **above** vanity stats on Overview → Alerts.
- Alert strip: `danger` for medical/TRAP/hold; `warn` for short notice / weight / deadline; slate for informational.
- One primary CTA in the alert context (Promise / Answer / Send to camp) — that CTA may spend the board’s **gold ×1**.

### Next bout
- Active only when `booked_fight` set; otherwise honest empty (“No booking — book a fight”).
- Treatment: instrument card with opponent link, event, weeks out, heat band, plan line — **not** a second photoreal hero.
- Weight line uses `warn` when off-track; Tape / Fight Plan / Fight Camp actions — only one gold.

### Condition
- Readiness / fatigue / morale / clearances use **condition** `#3DB8D4` (and ice on plates).
- Never paint condition with gold or CONTINUE green.

### Gold ×1 / green rule
- Gold `#E8B84A` (sodium `#F2C14E` on world plates only): **one** primary action per board.
- Green `#2ECC71`: CONTINUE / result way-out only — never on profile CTAs that are not CONTINUE.

### Body / attributes
- Body map = anatomical diagram + region masks (already Cage Desk); region heat uses condition→warn→danger, not beauty gradients.
- Six STAT_ORDER bars: current→ceiling; cool/condition fill language; potential tick muted.

### Honest empties
- Keep chrome frames; copy states why empty (no chains, unsigned, no camp). Empty shelf = `belt_empty_outline` + muted label.

---

## 4. UITokens / colour role map (profile instruments)

Cage Desk style-guide hexes are the **art target**. Live `UITokens.gd` / `render_m1.py` still carry the older lit-ground kit — Claude remaps when implementing. Profile art boards use Cage Desk roles below.

| Profile instrument | Cage Desk role | Hex | Legacy UITokens cousin (do not invent new engine consts here) |
| --- | --- | --- | --- |
| Canvas | bg_deep | `#0B1220` | GROUND → deepen |
| Cards / strip / docks | panel | `#162033` | PANEL |
| Hairlines | panel_edge | `#24324A` | LINE / EDGE |
| Primary type | text | `#E8EEF8` | TEXT |
| Labels | muted | `#8B97AD` | MUTED |
| Overall dial accent / primary CTA | gold | `#E8B84A` | GOLD (×1 only) |
| CONTINUE (shell only) | continue | `#2ECC71` | GO |
| Condition / readiness / body OK | condition | `#3DB8D4` | COOL family |
| Active chip / rail / selected row | select | `#3A6FD8` | GYM ladder / LINK-adjacent |
| Weight / fatigue / short notice | warn | `#E89A3C` | AMBER |
| Medical / hold / TRAP / ask danger | danger | `#E24B4B` | BAD |
| Plate key light | sodium | `#F2C14E` | (plates only) |
| Plate rim | ice | `#5EC8E0` | (plates only) |

**Instrument mapping**
- **Overall dial:** track = panel_edge/bg; fill toward gold only at elite band; potential tick = muted; letter = text.
- **Attribute bars:** track dark; fill cool→condition; ceiling ghost = muted hairline.
- **Body regions:** mask overlays; healthy = condition tint; stressed = warn; injured/hold = danger.
- **Alert strip:** header bar slate by default; escalate warn/danger; never gold header unless that strip owns the board’s single gold CTA.

---

## 5. Shot list — DONE vs TODO

Tabs stay: ATHLETE LAB · DEVELOPMENT · SKILLS & MOVES · FIGHT RECORD · FIGHT CAMP (brief names). Art does not invent new primary tab labels.

| Asset / board | Status | Notes |
| --- | --- | --- |
| `plate_fighter_identity` | **DONE** (M2 P1) | Replace photoreal `fighter-hero-plate`; use in identity strip |
| `body_muscle_map_front` + 6 `body_region_*` | **DONE** (M2 P4 / runtime_pack) | Masks exist — SHOT_LIST_STATUS lag; treat as shipped for art |
| Belts / trophies / `medal_rank` / `belt_empty_outline` | **DONE** (M2 P2) | Compose as shelf row on strip |
| Discipline `glyph_*` ×11 | **DONE** (M2 P3) | Chips use glyphs + select/slate chrome |
| `plate_locked_cage` | **DONE** (M2) | Camp empty / locked plate when needed |
| Identity strip anatomy board | **DONE** | `boards/01_identity_strip.png` |
| Overview command wire (Alerts+Next Bout+Attributes) | **DONE** | `boards/02_overview_command.png` |
| Profile token map board | **DONE** | `boards/03_token_map_profile.png` |
| Belt/trophy shelf composition (3–5 slot) | **DONE** | `boards/04_shelf_and_chips.png` — M2 props + empty outline |
| Discipline chip states (idle / selected / locked) | **DONE** | Same board 04 — select/slate/locked chrome |
| Alert strip variants (ask / medical / none) | **DONE** | `boards/05_alerts_and_empties.png` — danger/warn/slate |
| Empty states pack (no booking, no presser, no poach, unsigned) | **DONE** | Same board 05 — chrome stays, copy says why |
| Next-bout empty vs live states | **DONE** | `boards/06_next_bout_and_condition.png` — side-by-side |
| Condition instrument cluster | **DONE** | Same board 06 — ready/fatigue/morale/clearance cyan |
| Attribute bar ceiling treatment | **DONE** | Same board 06 — ceiling ghost + potential tick; no heat ramp |
| Hero plate *in-strip crop / safe margins* study | **DONE** | `boards/07_hero_strip_crop.png` — native 384×512 reads at 118/140/160px strip; safe margins |
| Body map region heat study (condition→warn→danger) | **DONE** | `boards/08_body_region_heat.png` — six regions + legend; M2 masks |
| Career Desk Deal packing art (loyalty + clauses) | **DONE** | `boards/09_career_desk_deal.png` — dense instrument cards; gold ×1 RENEW |
| Camp empty / locked plate in-profile crop | **DONE** | `boards/10_camp_empty_locked.png` — empty/locked/setup/progress/report; `plate_locked_cage` |
| *(remaining)* | — | **Profile art beat complete for kickoff** — no open shot-list TODOs |

---

## 6. Boards delivered

| File | Purpose |
| --- | --- |
| `profile/boards/01_identity_strip.png` | Persistent identity strip anatomy in Cage Desk tokens |
| `profile/boards/02_overview_command.png` | Overview / Alerts + Next Bout + Attributes wire @ 1920×1080 |
| `profile/boards/03_token_map_profile.png` | Profile-only colour roles |
| `profile/boards/04_shelf_and_chips.png` | Belt/trophy shelf (filled + empty) + discipline chip idle/selected/locked |
| `profile/boards/05_alerts_and_empties.png` | Alert-strip danger/warn/slate + honest empties (booking/presser/poach/unsigned) |
| `profile/boards/06_next_bout_and_condition.png` | Next Bout live vs empty; condition cluster; attribute ceiling/potential |
| `profile/boards/07_hero_strip_crop.png` | Hero plate in-strip crop / safe-margin study @ 1920 |
| `profile/boards/08_body_region_heat.png` | Body-map region heat (condition→warn→danger) + legend |
| `profile/boards/09_career_desk_deal.png` | Career Desk Deal packing — loyalty/clauses/promotion; gold ×1 RENEW |
| `profile/boards/10_camp_empty_locked.png` | Fight Camp empty/locked/setup/progress/report; plate_locked_cage |

Render scripts: `render_profile_boards.py` (01–03), `render_profile_boards_2.py` (04–06), `render_profile_boards_3.py` (07–10).

**Kickoff status:** Profile art beat complete for kickoff (boards 01–10). Claude implements when operator says go.

---

## 7. Process / handoff

- **Maria:** art boards + plate treatments under this brief.
- **Kalli:** may produce parallel study boards; keep Cage Desk hexes; no product lock claims.
- **Claude:** implements `AthleteProfileScreen` restyle **only when operator says go** — bind existing getters; no new systems.
- Do not edit `.gd` / `.tscn` / `HANDOFF.md` in this beat.

---

## 8. Sample bind (art content only)

Topuria sample from design brief: 17-1-0 · LW · MMA · stats 94/95/90/91/90/94 · potential 98 · morale 78 · fatigue 12 — use for board labels, not as locked live data.
