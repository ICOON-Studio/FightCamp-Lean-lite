# M30 — THE GYM FLOOR, COMPOSED

Maria Art Director · 2026-09-22 · **LOOK only** (no `.gd` / `.tscn` / `HANDOFF.md`)

One measurable layout for the existing `GymHubPanel` kit — Pass 3 KEEP direction made buildable. Not a second postcard world.

| Field | Value |
|---|---|
| Pass | **M30** |
| Prior | `M28_GYM_FLOOR_BOARDS.md` (KEEP/REJECT + filler + grade); Kalli K8 / `GYM_K8_*.png`; `FLOW_PASS4_CUTOVER.md` (words hers); M29 leave geometry hand |
| Honesty | `COMPUTED` = Beast / `GymHubPanel.gd` + `UIKit.gd` + `ShellChrome.gd` literals. `NEEDS WORDS` = Kalli owns string. Do not invent wire. |
| Out of scope | Code, HANDOFF, dual-Continue kill (M29 + Pass 4), blood, Gym Floor *landscape spend* beyond this kit compose |

---

## Three lines first

1. **Compose the kit, do not replace it.** Screen is **1920×1080** ShellChrome; hub body is `GymHubPanel` at origin `(402, 120)` size `1494×900`. Stations live as `floor_grid` tiles + station side panel — not leader-line callouts over a 3D room.
2. **Facility word is GYM, never camp.** Rail, title, tabs, and empty copy already say GYM / BUILDING. Any board or label that says camp is wrong on this surface.
3. **Filler = live `squad_row` only.** Density boards show **2** and **12** fighters on ROSTER; empty vertical space at 2 is honest (no decoy rows). Grade `int >= 2` stays a fight-surface rule — **nothing on this management surface carries blood or punch VFX**.

---

## Frame (COMPUTED)

| Piece | Rect (x, y, w, h) | Source |
|---|---|---|
| Screen | `0,0 1920×1080` | `ShellChrome.SCREEN` |
| Rail | `16,122 370×900` | `ShellChrome.RAIL_RECT` |
| Top bar | `402,16 1494×92` | `ShellChrome.TOP_RECT` |
| Content anchor | `402,210` | `ShellChrome.CONTENT_POSITION` |
| Hub root | `402,120 1494×900` | `GymHubPanel.ORIGIN` + `WIDTH`/`HEIGHT` |
| Hub free band | hub y `0…90` | Title + tabs sit in shell free band (comment: y 108–210) |
| Hub body | hub-local y `≥ BODY_Y (90)` | Roster / floor / store |

**Shell Continue (day clock):** GO unit in top bar — **one** green Continue on management chrome. Do not art a second CONTINUE here (M29 + Pass 4: Management twin → `NEXT STOP ▸` or die).

**Hand match to M29:** same measurable habit — named boxes, absolute numbers, GO reserved for Continue family only. Gold (if any) = fight-week banner only, not Continue.

---

## Regions — FLOOR tab (compose target)

Hub-local coordinates unless marked screen-absolute.

| Region | Hub-local box | What lives here |
|---|---|---|
| `TITLE` | `0,0 90×46` | Literal **GYM** (`SIZE_HEADLINE`) |
| `CAPTION` | `84,16 ~(WIDTH−84−270)×18` | Gym name · city · FAME n · ROSTER n · optional ON HOLD |
| `TABS` | `WIDTH−250,10 ~250×32` | Segmented **ROSTER / FLOOR / STORE** |
| `CAPACITY` | `0, BODY_Y (90)  grid_w×24` | `capacity_meter` — used/capacity/free + expand cost |
| `FLOOR_GRID` | `0, BODY_Y+36` size from cell×grid | `UIKit.floor_grid` — empty cells + `station_tile` footprints |
| `FLOOR_HINT` | `0, HEIGHT−44  grid_w×18` | Select / move-armed hint |
| `STATION_PANEL` | `WIDTH−SIDE_W (1150), BODY_Y  344×(HEIGHT−BODY_Y−10)` | Selected station detail + REPAIR / ROTATE / MOVE |
| `STATUS` (optional) | `0, HEIGHT−22` | Transient status line |

`grid_w = WIDTH − SIDE_W − 24 = 1126` when store closed; `WIDTH − DRAWER_W − 24 = 1040` when store open (`DRAWER_W=430`).

**Cell size (COMPUTED):** `clamp(floor(min(max_w/cols, max_h/rows)), 48, 150)` with `max_h = HEIGHT − BODY_Y − 84`. Board KEEP uses ~112 for an 8×6 example grid — **example only**; live grid w/h come from `get_gym_hub().floor.grid`.

**Store:** not a rail destination. Drawer `430` wide off the floor (`store_drawer`); tab STORE opens floor with drawer.

---

## Regions — ROSTER tab

| Region | Hub-local | Notes |
|---|---|---|
| `BANNER` | `0, BODY_Y  WIDTH×40` | Optional — fight week (gold×1), medical hold (bad), day-one slate |
| `FILTERS` | below banner | `filter_strip` — ALL / NEEDS YOU / BOOKED / OPEN BOOK + division chips |
| `SORT_CAPTION` | right of filters | `SORT · {COL} ↑/↓` |
| `HEAD` | below filters | `sort_header(SQUAD_COLUMNS)` height ~30 |
| `ROWS` | scroll `WIDTH × (HEIGHT − y − 28)` | `squad_row` @ **56px** height, **4px** gap |
| `EMPTY` | replaces rows | `NOBODY IN THE BUILDING` / filter empty — figure + way forward |
| `HINT` | `0, HEIGHT−22` | Select row / one flag |

### `SQUAD_COLUMNS` (COMPUTED — legal filler)

| id | label | x | width |
|---|---|---|---|
| fighter | FIGHTER | 44 | 300 |
| record | RECORD | 352 | 112 |
| cond | COND | 472 | 86 |
| morale | MORALE | 560 | 76 |
| weight | WEIGHT | 642 | 96 |
| plan | PLAN | 746 | 124 |
| next_bout | NEXT BOUT | 878 | 300 |
| flag | FLAG | 1186 | 220 |

Row also draws avatar initials (30px) at `(10,13)`. **Not** on row: wear texture, last-result stamp, purse, region doctor, HA dual-score jewellery (M28 audit).

---

## Slot table

`budget` = max characters for the **player-facing** string in that slot (Unicode; `·`/`▸` = 1). Where the string is already locked in code, budget = current length and ownership is COMPUTED. Where Kalli may still cut over, mark **NEEDS WORDS** and give a budget ceiling only.

| Slot | Box / region | Contents | Budget | Empty / missing data |
|---|---|---|---|---|
| Rail active | Rail row | **GYM** | 3 | — (always present) |
| Title | `TITLE` | **GYM** | 3 | — |
| Caption name | `CAPTION` | gym `name` | 24 | omit segment |
| Caption city | `CAPTION` | gym `city` | 18 | omit segment |
| Caption fame | `CAPTION` | `FAME {n}` | 10 | show `FAME 0` |
| Caption roster | `CAPTION` | `ROSTER {n}` | 12 | `ROSTER 0` |
| Caption hold | `CAPTION` | `{n} ON HOLD` | 14 | omit if 0 |
| Tab roster/floor/store | `TABS` | ROSTER / FLOOR / STORE | 6 / 5 / 5 | — |
| Capacity text | `CAPACITY` | `SPACE a / b USED · c FREE · EXPAND $…` | 56 | `SPACE 0 / b`; hide EXPAND if cost 0 |
| Station tile name | grid tile | equipment `name` | 22 (wrap 2 lines) | tile absent |
| Station tile cond | grid tile | `COND {n}` | 8 | show number even if 0 |
| Station occupants | grid tile | user names · or **OPEN** | 28 | **OPEN** |
| Floor hint idle | `FLOOR_HINT` | select-station hint | 28 | — |
| Floor hint move | `FLOOR_HINT` | move-armed hint | 64 | — |
| Station eyebrow | panel | SELECTED STATION | 16 | — |
| Station none | panel | NOTHING SELECTED + click hint | 22 + 28 | **this is the empty state** |
| Station name | panel | selected name | 28 | n/a when none |
| Occupancy line | panel | `OCCUPANCY u/c · names` | 40 | `… · OPEN` |
| Repair/Rotate/Move | panel buttons | REPAIR / ROTATE / MOVE | 6 / 6 / 4 | disabled look via kit — do not invent grey-only |
| Expand CTA | panel / drawer foot | expand purchase | 20 | omit if unavailable |
| Banner fight week | `BANNER` | FIGHT WEEK · name · org · days | 56 | omit banner |
| Banner hold | `BANNER` | MEDICAL HOLD · name · weeks | 48 | omit |
| Banner day one | `BANNER` | DAY ONE · ROSTER n · FLOOR … | 48 | omit when roster > 1 |
| Filter chips | `FILTERS` | ALL / NEEDS YOU / BOOKED / OPEN BOOK | 12 | counts may be 0 |
| Sort caption | | SORT · COL · arrow | 28 | — |
| Column headers | `HEAD` | per SQUAD_COLUMNS | ≤10 | — |
| Row name | fighter col | name upper | 22 | — |
| Row sub | fighter col | AGE · sex · discipline · division | 40 | drop missing parts |
| Row record | | W-L-D + KO/SUB | 14 | `0-0-0` |
| Row cond/morale | | int + gauge | 3 | `0` |
| Row weight | | status vs limit | 12 | muted placeholder — **NOT COMPUTED** invent |
| Row plan | | week plan short | 14 | empty → dim dash |
| Row next bout | | when · level | 22 | **—** |
| Row flag | | one FLAG_LABELS chip | 16 | **no chip** (empty = no invent) |
| Empty whole | `EMPTY` | NOBODY IN THE BUILDING + scouting hint | 22 + 40 | **required** at 0 fighters |
| Empty filter | `EMPTY` | NOBODY IN THIS FILTER + clear hint | 22 + 40 | **required** |
| Roster hint | foot | select / one flag | 56 | — |
| Shell Continue | top GO | `CONTINUE →` | 11 | gated subcopy Kalli/COMPUTED |
| Teach overlay (optional LOOK) | over stations | station teach labels | **≤12 each** | **NEEDS WORDS** — do not ship Pass 3 board copy; prefer tile names alone |

**Blood / punch VFX:** no slots. Doctor/stoppage blood deferred; grade≥2 dust is fight-night only.

---

## Density — two vs twelve

| | **2 fighters** | **12 fighters** |
|---|---|---|
| Board | `M30_board_density_two.png` | `M30_board_density_twelve.png` |
| Caption | `ROSTER 2` | `ROSTER 12` |
| Rows drawn | 2× `squad_row` | ~11 visible + scroll (+1 more) |
| Below rows | Honest empty band — **no fake filler** | Scroll; `+N MORE BELOW` cue |
| Banner | Usually none (roster > 1) | Fight-week / hold if data says so |
| Finding | **Layout works at both densities.** At 2 the kit does not need decoy rows or a postcard to feel “full.” At 12 the scroll is the density solution — do not shrink row height below 56 or drop legal columns to “fit.” |

Floor tab density is **equipment / capacity**, not fighter count. Occupancy chips on tiles show who trains where; a 2-fighter gym can still fill a ring tile.

---

## KEEP / REJECT (composed screen)

| File | Ruling |
|---|---|
| `M30_board_composed_keep.png` | **KEEP** — Shell + hub FLOOR with named pixel regions; three stations as tiles; one Shell GO Continue; gym language |
| `M30_board_composed_reject.png` | **REJECT** — postcard / camp word / deco callouts / dual Continue / no kit boxes |
| `M30_board_density_two.png` | Density proof — live rows only |
| `M30_board_density_twelve.png` | Density proof — scroll, not compressed rows |

**States (few, never hue-only, never continuous throb):**

| State | How it reads |
|---|---|
| Idle floor | Tiles + NOTHING SELECTED panel |
| Station selected | Gym-edge on tile + filled panel (not hue-only: edge width + copy change) |
| Move armed | Hint amber + copy change (existing) |
| Roster selected row | Panel_HI + gym edge bar (existing) |
| Empty roster | Figure block — not a blank table |
| Fight-week banner | Gold×1 on banner only |

---

## Self-attack — strongest board

**Strongest board:** `M30_board_composed_keep.png` (annotated kit FLOOR).

**Wrong reading of this layout:**

1. **“Documentation cosplay.”** A builder could say Maria only traced `GymHubPanel` and added yellow boxes — no art direction. If the KEEP is indistinguishable from a screenshot with labels, the pass failed to choose *emphasis* (which region is the eye, what empty looks like, what reject still means after Pass 3).
2. **“Postcard deferred, not killed.”** Someone could keep Pass 3’s 3D room as a future skin *under* the grid. That reopens the expense-without-verbs problem and the HA structural rhyme. Compose means the **grid is the floor**.
3. **“Camp by synonym.”** Caption or teach overlays that say camp / lot / pavilion while title says GYM would smuggle the banned word back.

**What would settle it:**

- Play or DevJump capture of live `GymHubPanel` FLOOR beside this KEEP — boxes match within a few pixels; no second art layer.
- Operator / Claude accept: **no landscape remaster** under the grid this season.
- Kalli Pass 4 cutover + empty-slot copy stay the only word path; Maria boards show budgets, not invented teach strings.

**What I still hold:** Pass 3 KEEP *job* (place + teach three stations) lands as **readable tiles + side panel**, not as a cinematic establishing shot. M30 is the build sheet for that landing.

---

## Alignments

| Topic | Status |
|---|---|
| M28 filler / grade / reject deco | Obeyed |
| M29 one Shell Continue | Obeyed on boards |
| Pass 4 `NEXT STOP ▸` / leave words | Not re-litigated; week twin not drawn as CONTINUE |
| Blood ACCEPTED fallback | No blood on this surface |
| Gym ≠ camp | Hard constraint on boards + copy |

---

## Still wrong / NOT COMPUTED

1. Live play proof of dual chrome reachability — still open (M29).
2. Exact live `floor.grid` w×h / starter equipment set — **NOT COMPUTED** this pass (boards use an 8×6 example).
3. Teach-overlay words if product still wants Pass 3 callouts — **NEEDS WORDS**.
4. Weight column empty presentation beyond muted dash — thin.
5. Beast vs mirror drift — constants checked against Beast path `Godot/scripts/GymHubPanel.gd` availability this turn; numbers match flow_pass3 mirror of R21 hub.

---

## Files to land

Under `_maria_delivery/` and `research/`:

- `M30_GYM_FLOOR_LAYOUT.md`
- `CLAUDE_LAND_NOTE_M30.md`
- `M30_board_composed_keep.png`
- `M30_board_composed_reject.png`
- `M30_board_density_two.png`
- `M30_board_density_twelve.png`

Claude writes HANDOFF block; Maria does not edit `HANDOFF.md`.
