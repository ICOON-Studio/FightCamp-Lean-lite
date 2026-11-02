# U3 — THE BODY BY REGION: SIX CLOCKS, ONE FIGHTER (Cursor)

Cursor · Maria art-direction seat · 2026-09-07 · art only (no `.gd` under
`Godot/scripts/`, no `.tscn`, no `HANDOFF.md`, no `Godot/assets/data/`).

Rules how a **future per-region recovery stage** reads before anyone builds it.
Extends the R18 BODY lab (`ProfileRevampPanel._fill_regions`, M6 medical
family, M11 wear, U2 age-blind holds). Does **not** design the healing model.

## Call: six clocks on one person — not a wound chart, not six useless bars

The operator ruled per-body-part recovery is coming. Six regions already exist
in `BodyReadiness`; the BODY tab already draws them. Done badly this becomes
an anatomy diagram, a red-splattered wound map, or six identical bars that
repeat what one number already said. **This pack rules the read first.**

**Decision: keep the spatial lab sheet — six labelled region cells in one
cluster, identity by label + position + cage tick — and add a binding read for
the worst gate, a single badge truth, and a NOW/EVER split on each cell.**

Written reason:

1. **R18 already passed the bar.** `REGIONS` places six cells around a void
   on a lab sheet — not a bitmap body, not a stacked spreadsheet. M11 refusal
   #10 forbids anatomy overlays; the sheet layout satisfies it without reopen.
2. **Six identical rows add nothing.** A vertical list of six gauge bars is
   the failure mode this stage must avoid; spatial cluster lets the eye compare
   clocks at a glance while labels carry identity.
3. **M6 owns the medical family.** Region NOW states use `GOOD` / `AMBER` /
   `BAD` bands and the one clearance badge — never borrowed for wear or age.
4. **M11 owns history chrome.** Career hits on a region print as `TRACK`
   recess + `LINE_SOFT` + DIM micro-ticks — never scar-red, never HELD.
5. **U2 and J12 bind the clocks.** Training-load recovery and injury healing
   stay separate (D2); commission holds stay age-blind (D9); years and mileage
   are not interchangeable (D5). This pack rules surfaces only.

## Token map (existing tokens only)

| Role | UITokens | Notes |
| --- | --- | --- |
| Lab ground / frame | `GROUND`, `PANEL`, `LINE` | R18 BODY frame |
| Region label | `TEXT_2` | HEAD / NECK, LEFT ARM, … |
| NOW gauge (life band) | gauge `life` → `GOOD` / `AMBER` / `BAD` | M6 readiness bands |
| Cage threshold tick | `LINK` when short, `DIM` when met | M6 dual threshold |
| State chip SOUND/SORE/HURT | `standard` / `amber` / `bad` | M6 — not GO |
| Clearance badge HELD | solid `BAD` | M6 — time gate |
| Clearance badge NOT CLEARED | outline `AMBER` | M6 |
| Clearance badge CLEARED | outline `GOOD` | M6 — not GO |
| Hold banner / refusal hold row | `BAD` fill or ink | M6 |
| EVER micro-ticks | `DIM` on `TRACK` + `LINE_SOFT` edge | M11 wear — not wounds |
| Binding LOWEST pair | `MUTED` label + `TEXT_2` numeral | roster/overview only |
| Forecast weeks (recovery pane) | `TEXT` / `BAD` countdown | M6 — separate from EVER |
| Age / wear on avatar | M11 ink ladder | whole-fighter, not per-region NOW |
| Verdict / CONTINUE / belt | `GOLD`, `GO`, `SODIUM`, `ICE` | **Unused on BODY tab** |

## 1. One body or six rows?

**Question.** Figure/silhouette with regions marked, or six labelled rows?

**Options considered**

- A) **Bitmap or code-drawn anatomy** — silhouette with regions painted.
- B) **Six stacked identical rows** — spreadsheet of bars.
- C) **Spatial lab sheet** — six labelled cells in cluster around a void (R18).

**Ruling: C.**

- No anatomy art, no wound overlay, no body map (standing + M11 #10).
- Identity without a picture: **region caption** (`HEAD / NECK`, …) +
  **fixed position on the sheet** + **cage tick** (`LINK` when short of
  competition threshold).
- The void between cells is intentional — the fighter is one person, not six
  charts.

**Why.** A violates ripped-art and anatomy refusals. B is the six-useless-bars
failure mode. C is what R18 already ships and scales to six independent clocks.

## 2. Six clocks at a glance

**Question.** Hand at four weeks, leg at one, head clear — what reads first?
What becomes of `minimum_readiness`?

**Options considered**

- A) **Worst region only** — hide the other five; show one bar.
- B) **Soonest clear only** — optimistic single countdown.
- C) **All six visible** — binding region emphasised, rest present.
- D) **`minimum_readiness` stays the only roster number** — six clocks BODY-only.

**Ruling: C on BODY tab; D elsewhere with a renamed pair.**

| Surface | What the player sees first |
| --- | --- |
| **BODY tab** | All six cells. **Binding region** = lowest value relative to its **competition** threshold (same order `BodyReadiness.evaluate_competition_clearance()` uses). Binding cell gets the refusal-stack tone if it is the competition blocker; hold banner still wins when active. |
| **Profile overview strip / roster** | M6 clearance **badge** + one **`LOWEST · NN`** pair (the existing `minimum_readiness()` integer). Label is `LOWEST`, not "readiness" — it is the floor, not the story. |
| **Recovery pane (right frame)** | Per-activity **forecast weeks** for the whole body (M6 — one forecast, not six). Targeted recovery may name one region in copy when the engine passes `targeted_region`; still no sixth clock row. |

**Why.** A and B hide the normal case (multi-site damage). D repeats the
single-number failure this stage exists to fix. All six on BODY; one floor
number everywhere else preserves booking speed without lying about which limb
is short.

## 3. The badge cannot lie

**Question.** One region blocked, five green — what does the whole-fighter badge
say? How do region cells stay in agreement?

**Options considered**

- A) Per-region badges — six mini HELD/NOT CLEARED pills.
- B) Badge shows best region — optimistic lie.
- C) **One badge from one evaluation** — hold → HELD; else competition clear → CLEARED; else NOT CLEARED.

**Ruling: C.**

**Agreement rule (forever):** `clearance_state` is computed **once** from
`medical_hold_active` then `evaluate_competition_clearance()` — the same
fields `ProfileRevampPanel` already uses (`:212`). The badge, the hold banner,
and the training/competition pair blocks all read that verdict. Region cells
show **local NOW** bands; they never print CLEARED on the badge while the
hold banner is BAD. When one region is below cage threshold and there is no
hold: badge = **NOT CLEARED**, binding region named in the refusal stack.

**Why.** A explodes chrome and contradicts M6's one badge. B breaks booking
trust. C is M6 unchanged — this stage adds cells, not a second clearance language.

## 4. Now versus ever

**Question.** Hurt today vs hurt three times in a career — same cell or split?

**Options considered**

- A) **History tab** — second screen for past injuries.
- B) **Scar-red overlay** on the region — anatomy/wound chart.
- C) **NOW and EVER on the same cell** — gauge + chip for today; DIM
   micro-ticks on `TRACK` recess for career hits on that region.
- D) Drop M11 micro-ticks — history only in text log.

**Ruling: C.**

| Layer | Carries | Chrome |
| --- | --- | --- |
| **NOW** | Current region value 0–100, training/competition bands | M6 gauge + SOUND/SORE/HURT chip |
| **EVER** | Count of past meaningful hits on **this region** (implementation defines "hit"; art only counts ticks) | M11 `TRACK` recess + up to 5 `DIM` micro-ticks — **no BAD fill** |
| **Avatar ring wear** | Whole-fighter mileage / years (M11) | Stays on hero — **not** duplicated per cell |

- EVER ticks sit **under** the NOW bar, separated by `LINE_SOFT` — history,
  not the live wound.
- A region with NOW hurt and EVER ticks shows both; ticks do not turn red.
- **Wear never becomes HELD; injury never becomes wear** (M6 / M11 boundary).

**Why.** A hides history behind navigation. B is M11 refusal #10. D wastes the
existing wear grammar. C keeps one cell per region with two time depths.

## 5. Where this appears — and where it must NOT

**Allowed (by name)**

| Surface | Depth |
| --- | --- |
| `ProfileRevampPanel` **BODY** tab | Full six-cell lab + hold banner + refusal stack + recovery frame |
| Profile **overview** hero strip | Badge + `LOWEST · NN` pair only |
| `UIKit.squad_row` | M6 clearance badge only — **no region column, no limb icon** |
| Booking / fight-camp refuse copy | Named binding region from refusal stack when competition blocked |
| Medical hold banner / countdown | M6 — age-blind copy (U2 Q5, J12 D9) |

**Clean surfaces (regions stay off)**

- `UIKit.squad_row` — no per-region breakdown, no limb glyph, no `why` (K25).
- GYM hub roster / **training board** — no six-bar body map; fatigue/conditioning aggregates only.
- `ScheduleHubPanel`, fight card, weigh-in, bout sheet — no region chrome.
- News / attention headlines — no "torn hamstring" injury copy; desk refusals only.
- Fight camp / booking offer rows — badge or refuse reason, not a mini lab sheet.
- FORMER list / epilogue plate — career facts, not a wound chart.
- Scouting row — M6 badge at most; no region grid.
- Any new rail item / hub (K10) — **refused**.

## Refusals (stops re-proposal)

1. **Anatomy silhouette / body map / wound art** — lab sheet only; M11 #10.
2. **Six stacked identical rows** — spatial cluster or nothing.
3. **Per-region clearance badges** — M6 one badge only.
4. **Scar-red EVER overlay** — ticks on `TRACK`, not BAD fill.
5. **Wear ticks meaning injury** — injury = M6 gauge; wear = M11 recess.
6. **GO for cleared** — `GOOD` semantic green only (M6).
7. **Age on hold copy or region chrome** — U2 Q5 / J12 D9.
8. **Region column on `squad_row` or training board** — badge + LOWEST elsewhere.
9. **New token / new UIKit factory** — name the gap; do not invent (M11, K10).
10. **Training-load clock mixed into injury gauge** — D2 separate clocks.
11. **Minimum replaces six on BODY tab** — floor number is for glance surfaces.
12. **Female vs male bout art / veteran caricature** — standing rules.

## Standing constraints (held)

- M6 medical family: `BAD` / `AMBER` / `GOOD`, one badge, hold = BAD.
- M11 age/wear: ink weight on age; wear = `TRACK` + `LINE_SOFT` + DIM ticks.
- U2: medical hold and suspension copy age-blind; no age on readiness.
- J12: D2 separate clocks; D5 years ≠ mileage; D9 holds not age-scaled.
- No new token · no new factory · no new rail/hub.
- One figure once per screen · pair blocks never in header colour.
- Visual bar = R18 profile (`DesignLibrary/screens/profile_revamp/`).
- Females never fight males · veterans not caricatures · gym not camp.

## Boards → `DesignLibrary/screens/body_by_region/`

| File | Content |
| --- | --- |
| `u3_01_six_region_lab.png` | Spatial lab sheet · six clocks · mixed NOW values |
| `u3_02_one_held_five_good.png` | HELD badge + five green regions + one sore — badge truth |
| `u3_03_now_vs_ever.png` | NOW gauge vs EVER ticks on one cell · M6/M11 boundary |
| `u3_04_refusals.png` | Named refusals |
| `u3_05_minimum_glance.png` | Overview strip: badge + LOWEST pair — not six bars |

Render: `xvfb-run … godot --path Godot --script tools/CaptureU3BodyRegions.gd`
Harness: `Godot/tools/CaptureU3BodyRegions.gd` (engine-rendered, re-runnable).

## Engine anchors (read only)

- `BodyReadiness.gd:52-145` — regions, thresholds, clearances, refusals
- `BodyReadiness.gd:104-110` — `minimum_readiness()`
- `ProfileRevampPanel.gd:36-38` — `REGIONS` layout
- `ProfileRevampPanel.gd:1874-1980` — `_fill_regions()`
- `ProfileRevampPanel.gd:1790-1810` — `_clearance_badge()`
- `DesignLibrary/screens/profile_revamp/body_lab.png` — current bar
- `research/M6_THE_HOLD.md`, `M11_THE_LONG_CAREER.md`, `U2_WHAT_THE_YEARS_COST.md`

Claude writes the HANDOFF block when this pack lands.
