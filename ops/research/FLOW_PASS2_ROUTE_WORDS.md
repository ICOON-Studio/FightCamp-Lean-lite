# FLOW_PASS2_ROUTE_WORDS — PASS 2

**NOT FINISHED.** Words and flow decisions only. No geometry, colour, fonts. No SceneRouter cleanup implementation. Corner UI and Maria's look are out of scope.

| Field | Value |
|---|---|
| Pass | **2** |
| Date | 2026-09-22 |
| Agent | Kalli |
| Prior | `research/FLOW_PASS1_SCREEN_MAP.md` (Beast-verified land) |
| Honesty | `COMPUTED` = literal/route on Beast this pass. `NOT COMPUTED` where wiring or live reachability is unclear. |
| Out of scope | `TASK_CORNER_UI` (Codex). `TASK_VFX_AND_PRESENTATION` (Maria). Implementing chrome merges. |

---

## Three lines first

1. **Load-bearing defect:** After a fight, Continue never returns to **THE DAY**. Labels are COMPUTED (`CONTINUE TO OFFICE ▸` / `…CARD…`) and route to `office_menu` or `events`; SetpieceRoot.leave() falls back to **`calendar` (SCHEDULE)**. That is the cheap player-facing hole.
2. **Keep / kill:** Keep **SceneRouter + ShellChrome + hosted CareerRoot panels**. Kill **ManagementChrome DIRECT_SCENES remount of `DayFeedScreen.tscn`** and the **`today` route alias**. (Self-argue against this below.)
3. **Name:** One surface, one name — **`day_feed` / THE DAY**. Drop `today` / TODAY'S BRIEFING.

---

## 1. ROUTE-WORDS SHEET

Every player route found in `SceneRouter.ROUTES` (player tiers) plus the controls that move them. Dev routes listed last, not for shipping copy.

### Boot

| From | Control (COMPUTED) | To | Notes |
|---|---|---|---|
| TITLE | `NEW CAREER` | creation `country_map` | TitleBoardPanel |
| TITLE | `LOAD` | `boot_slots` | |
| TITLE | `SETTINGS` | `boot_settings` | |
| TITLE | brand `FIGHTCAMP` | — | not a route |
| SLOTS / SETTINGS | back (NEEDS WORDS if unlabeled) | TITLE | **NOT COMPUTED** exact back string this pass |

### Creation

| From | Control (COMPUTED) | To |
|---|---|---|
| Market step | gold `CHOOSE MARKET` | city |
| City step | gold `ENTER CITY` | gym_pick |
| Gym step | gold `OPEN GYM` | CareerRoot `day_feed` (THE DAY) |
| Country step | back | Boot TITLE |

### Career rail (SceneRouter labels — COMPUTED)

| Route id | Rail / title label | Panel |
|---|---|---|
| day_feed | **THE DAY** | DayFeedScreen.gd |
| today | **TODAY'S BRIEFING** | same panel — **KILL alias** (see §3) |
| gym | GYM | GymHubPanel |
| gym_floor | MY GYM | GymHubPanel tab |
| roster | FIGHTERS | GymHubPanel tab |
| fighter_card | FIGHTER CARD | AthleteProfileShellScreen |
| training | TRAINING | TrainingHubPanel |
| calendar | SCHEDULE | ScheduleHubPanel |
| events | EVENTS | ScheduleHubPanel tab |
| event_detail | EVENT | ScheduleHubPanel tab |
| scouting | SCOUTING | ScoutingHubPanel |
| rankings | RANKINGS | RankingsHubPanel |
| office_menu | OFFICE | OfficeHubPanel |
| staff | STAFF | StaffHubPanel |
| contracts | CONTRACTS | OfficeHubPanel tab |
| finances | FINANCES | OfficeHubPanel tab |
| objectives | OBJECTIVES | OfficeHubPanel tab |
| weight_class | WEIGHT CLASS | OfficeHubPanel tab |

### Shell Continue (time — COMPUTED)

| Control | Subcopy | Effect |
|---|---|---|
| `CONTINUE →` | `N MUST ANSWER FIRST` or `ALL CLEAR  ·  NEXT DAY` | ShellChrome → day advance via caller |

ManagementChrome header Continue (COMPUTED): `CONTINUE  ▸` — tooltip says advance to next **weekly** decision; opens schedule progression. **This is the dual-Continue.**

### Fight contract overlay (COMPUTED)

| Control | Role |
|---|---|
| `WALK AWAY` | leave without deal (never gold) |
| `PROPOSE TERMS` | gold decision |
| `ACCEPT AS OFFERED` | slate sign-as-written |
| `◂  RETURN TO THE AGREEMENT` | back from clause editor |

### Setpiece chain (COMPUTED phase labels)

FIGHT WEEK → WEIGH-IN → FIGHT NIGHT → RESULT → (CROWNING)

| On RESULT | Control (COMPUTED) | Routes to (COMPUTED) |
|---|---|---|
| Pending crowning | same Continue button | `crowning` |
| Same card still has work | `CONTINUE TO CARD ▸` | `events` + event_id |
| Another bout tonight | `CONTINUE TO NEXT CARD ▸` | `events` + next id |
| Card done, no crowning | `CONTINUE TO OFFICE ▸` | **`office_menu`** — **not THE DAY** |

SetpieceRoot.leave() fallback (COMPUTED): `back_or("calendar")` → **SCHEDULE**, not THE DAY.

### Hub golds / DayFeed card verbs / FightNight HUD

**NEEDS WORDS** — not closed this pass. Pass 3 material. Do not invent.

### Dev (no player copy owed)

| Route | Label |
|---|---|
| fight_test | MATCH SIMULATOR |
| fight_world_preview / fight_world_live | FIGHT WORLD PREVIEW / LIVE |
| FightAnimLab / UIKitGallery | entry/egress **UNKNOWN** |

---

## 2. FIGHT-RESULT LEAVE CTA — the cheap fix

### What exists (COMPUTED)

Three strings, all honest about *tonight's card*, none about returning to the career day:

- `CONTINUE TO OFFICE ▸`
- `CONTINUE TO CARD ▸`
- `CONTINUE TO NEXT CARD ▸`

When the card is finished, the player is sent to **OFFICE**. Setpiece chrome leave falls back to **SCHEDULE**. A player who thinks in “day → fight → day” will not find THE DAY on that button.

### Decision (words only)

| Case | Keep / change | Copy |
|---|---|---|
| Next bout / same card | **Keep** COMPUTED strings | `CONTINUE TO CARD ▸` / `CONTINUE TO NEXT CARD ▸` |
| Pending crowning | **Keep** routing | crowning board (label already CROWNING) |
| Card done, no crowning | **Replace** `CONTINUE TO OFFICE ▸` | **`BACK TO THE DAY ▸`** |

**One sentence for the empty-card case:** the button should say **`BACK TO THE DAY ▸`** and mean the `day_feed` route (THE DAY), not OFFICE and not SCHEDULE.

**Why not OFFICE:** OFFICE is a desk. THE DAY is where the career loop breathes. Post-fight should land on the loop, not a side hub. Player can open OFFICE from the rail.

**Why not invent “CONTINUE” alone:** Continue without a destination is how this hole opened.

**Implementation:** out of scope for Kalli. Wire owners change `FightResultPanel.continue_label_for` empty branch + `_on_continue` empty branch to `day_feed`, and should change SetpieceRoot.leave fallback from `calendar` to `day_feed`. Flagged here so it is not “inferred.”

---

## 3. `today` vs `day_feed` — one name

| | |
|---|---|
| **Keep** | Route id `day_feed`, label **THE DAY** |
| **Kill** | Route id `today`, label **TODAY'S BRIEFING** |

**Why THE DAY wins**

1. Rail already stamps **THE DAY** (`SceneRouter` + ManagementChrome `NAV_ITEMS`).
2. Creation seam lands on `day_feed` after `OPEN GYM`.
3. Schedule copy already points people at THE DAY (“TODAY'S BRIEFING LIVES ON THE DAY” — that sentence is proof the two names fight).
4. `today` is the same panel script and the same `nav: day_feed` — a second name for one surface.

**What “today” still means as English:** dated rows *inside* THE DAY (“TODAY”, “NOTHING DATED TODAY”) stay. That is content language, not a route title.

**Do not present both.** Call sites using `SceneRouter.push("today")` should push `day_feed`. **NOT COMPUTED:** full call-site list this pass — grep debt for implementer.

---

## 4. DUAL-NAVIGATION WRITE-UP — which route survives

### The two systems (COMPUTED)

| System | Continue meaning | How it opens THE DAY |
|---|---|---|
| **SceneRouter + ShellChrome + CareerRoot hosted panels** | `CONTINUE →` / NEXT DAY (day clock) | Host `DayFeedScreen.gd` inside CareerRoot |
| **ManagementChrome + DIRECT_SCENES** | `CONTINUE ▸` (week / schedule walk) | **Remount** `res://scenes/DayFeedScreen.tscn` as its own scene |

Standalone `.tscn` still on disk for DayFeed (and profile shell exists as scene). DIRECT_SCENES maps almost every hub to CareerRoot **except** `day_feed` → full DayFeedScreen.tscn. Tests/tools also load that `.tscn` directly.

### Per dual surface — keep / kill

| Surface | Route A (keep) | Route B (kill for players) | What a player sees today on B (**partially NOT COMPUTED**) |
|---|---|---|---|
| THE DAY | SceneRouter `day_feed` hosted in CareerRoot | ManagementChrome DIRECT_SCENES → DayFeedScreen.tscn | Full scene remount; own chrome path; can desync from CareerRoot rail state |
| FIGHTER CARD | SceneRouter `fighter_card` hosted | Opening AthleteProfileShellScreen.tscn as standalone (if still reachable) | Own ShellChrome build; dual furniture |
| Hubs (gym/training/…) | SceneRouter panel ids | ManagementChrome navigate remounting CareerRoot with pending module | Often same building; still two *entry APIs* — keep one API |
| Time Continue | ShellChrome day Continue | ManagementChrome week Continue | **Two clocks** — player can advance day on one chrome and week on the other |

### Surviving system (recommendation)

**Keep: SceneRouter + ShellChrome + hosted panels.**  
**Kill for players: ManagementChrome DIRECT_SCENES remount of DayFeedScreen.tscn; dual Continue header; `today` alias.**

ManagementChrome may remain as a **library** of header/day-strip helpers called by ShellChrome (already true in code comments) — but it must not own a second navigation map.

### What this pass does *not* do

Does not delete ManagementChrome.gd. Does not edit SceneRouter. Decision only.

---

## 5. ARGUE AGAINST YOURSELF — why SceneRouter should *not* win

Strongest case that **ManagementChrome + DIRECT_SCENES** is the one to keep:

1. **Week Continue is the career verb.** ManagementChrome’s `CONTINUE ▸` walks the schedule and stops on fights. ShellChrome’s NEXT DAY may advance a thinner day clock. If the sim’s obligations are week-shaped, killing ManagementChrome Continue strands the booking model behind a day button that does not know the card.
2. **Remount clears lies.** Hosted panels inside CareerRoot can keep stale child state. DIRECT_SCENES remounting DayFeedScreen.tscn is brutal and honest — a fresh tree every visit. The dual-state bug may be *caused* by hosting, not by DIRECT_SCENES.
3. **DayFeedScreen.tscn is the tested object.** Tests and render tools load the standalone scene. Making hosted-only THE DAY means the test surface and the player surface diverge unless someone rewrites the harness.
4. **ShellChrome already depends on ManagementChrome.** Comments say ShellChrome builds from ManagementChrome.NAV_ITEMS and navigate_to. “Kill ManagementChrome” is a slogan that understates the knot — you may only be renaming the survivor.
5. **Leave already thinks OFFICE/SCHEDULE.** FightResult → office_menu and Setpiece leave → calendar match an older ManagementChrome world where the desk/schedule were the post-fight spine. Forcing THE DAY may fight years of route gravity.

**Converged answer after the argument:** Still keep SceneRouter as the *map*, but **do not casually delete ManagementChrome Continue** until one Continue owns both day obligations and week stops. Pass 2 product call: **one map (SceneRouter), one Continue (must absorb week-stop behaviour before ManagementChrome header dies), one THE DAY (hosted), no DIRECT_SCENES remount for players.** If week-stop cannot move to Shell Continue, ManagementChrome Continue stays until that lands — dual map still dies first.

---

## 6. COUNTING RULE — drop “~64”

| Rule | Count this pass |
|---|---|
| `*Screen*.gd` | 7 |
| `*Panel*.gd` | 25–26 |
| Screen+Panel | ~32 |
| SceneRouter routes (all tiers) | **33** |
| SceneRouter player-facing (boot+creation+career+setpiece) | **31** |
| Dev routes | 2 (+ lab scenes not in router) |

**Adopted figure for flow work:** **31 player-facing SceneRouter routes** (plus overlays like FightContract that are not router rows).  

**Drop “~64”.** It is not reproducible from Screen+Panel globs or from the router table. Sibling TASK_VFX may recount under its own art rule — that is Maria’s document, not this one.

---

## 7. WHAT IS STILL WRONG

1. Fight-result empty-card CTA still says OFFICE; Setpiece leave fallback still SCHEDULE — words decided, wire not landed.
2. `today` alias still in SceneRouter — kill decided, call-sites **NOT COMPUTED** complete.
3. Dual Continue (day vs week) not collapsed — map survivor chosen; Continue merge **blocked** on week-stop behaviour ownership.
4. Hub golds / DayFeed verbs / FightNight HUD still **NEEDS WORDS** (~pass 3).
5. Live reachability of ManagementChrome header in normal boot still **NOT COMPUTED** (no play trace this pass).
6. Lab/dev egress still UNKNOWN.
7. Corner UI still missing — correctly owned elsewhere; still a hole in the fight chain.
8. This pass does not implement — decisions only.

---

## Acceptance for Pass 2

- [x] Route-words sheet for router player routes + contract + result CTAs
- [x] Fight-result leave named: `BACK TO THE DAY ▸` for empty-card case
- [x] today vs day_feed decided (keep THE DAY)
- [x] Dual-nav keep/kill per surface + self-argue
- [x] Counting rule: 31 player-facing routes; drop ~64
- [x] NOT COMPUTED preserved where due
- [x] No corner / no Maria look / no HANDOFF edit
