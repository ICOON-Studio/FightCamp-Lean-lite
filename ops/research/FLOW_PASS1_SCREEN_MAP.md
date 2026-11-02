# FLOW_PASS1_SCREEN_MAP — PASS 1

**NOT FINISHED.** Operator-judgeable inventory. Words and structure only — no geometry, colour, fonts. No `.gd` / `.tscn` feature edits by Kalli.

| Field | Value |
|---|---|
| Pass | **1** |
| Date | 2026-09-22 |
| Agent | Kalli |
| Source | **Beast verified** this pass (`SceneRouter.gd`, `CreationFlowPanel.gd`, `TitleBoardPanel.gd`, scene dir). Earlier GitHub-only draft corrected. |
| Honesty | `COMPUTED` = found on disk. `NOT COMPUTED` / `UNKNOWN` where wiring unclear. |
| Sibling tasks (do not steal) | `TASK_CORNER_UI.md` (corner — in flight). `TASK_VFX_AND_PRESENTATION.md` (Maria owns look). |

---

## Three lines first

1. **Load-bearing:** Career play is **panels hosted inside CareerRoot** via `SceneRouter` — not twelve independent full-scene swaps.
2. **Keep:** Fight chain already named: `fight_week` → `weigh_in` → `fight_night` → `fight_result` → optional `crowning` → leave → `day_feed`.
3. **Least sure:** Whether `ManagementChrome` + `DIRECT_SCENES` still opens in normal boot beside `ShellChrome` + `SceneRouter`. Still referenced from ShellChrome and several hubs — dual Continue (day vs week) risk is **NOT COMPUTED** without a play trace.

---

## Inventory — 12 named scenes (Beast `Godot/scenes/`)

| # | Scene | Path | Role | Status |
|---|---|---|---|---|
| 1 | BootRoot | `Godot/scenes/BootRoot.tscn` | TITLE / SLOTS / SETTINGS | LIVE — project main |
| 2 | CreationRoot | `Godot/scenes/CreationRoot.tscn` | Market → city → gym | LIVE |
| 3 | CareerRoot | `Godot/scenes/CareerRoot.tscn` | Persistent shell; hosts panels | LIVE — default `day_feed` |
| 4 | DayFeedScreen | `Godot/scenes/DayFeedScreen.tscn` | THE DAY body | **DUAL** — standalone + hosted |
| 5 | AthleteProfileShellScreen | `Godot/scenes/AthleteProfileShellScreen.tscn` | Fighter card | **DUAL** — standalone + `fighter_card` |
| 6 | FightContractScreen | `Godot/scenes/FightContractScreen.tscn` | Bout agreement | LIVE — overlay, not rail |
| 7 | FightNight | `Godot/scenes/FightNight.tscn` | Ring body in SetpieceRoot | LIVE — phase `fight_night` |
| 8 | FightWorldLive | `Godot/scenes/FightWorldLive.tscn` | Dev seeded bout | DEV |
| 9 | FightWorldPreview | `Godot/scenes/FightWorldPreview.tscn` | Dev/test mount | DEV |
| 10 | SetpieceRoot | `Godot/scenes/SetpieceRoot.tscn` | Fight set-piece host | LIVE |
| 11 | FightAnimLab | `Godot/scenes/FightAnimLab.tscn` | Animation lab | DEV — no player route found |
| 12 | UIKitGallery | `Godot/scenes/UIKitGallery.tscn` | UI kit gallery | DEV — no player route found |

Autoload hub: **`SceneRouter`**.

---

## Screen / panel script count vs claimed ~64

| Claim | This pass (Beast) |
|---|---|
| Sibling TASK_VFX ~64 | Citation only |
| `*Screen*.gd` | **7** |
| `*Panel*.gd` | **25** |
| Screen+Panel | **32** |
| Broader hubs/boards/roots | ~39 Control surfaces touched |
| Exact “64” | **NOT COMPUTED** — claim does not match these globs; pass 2 must define the counting rule |

---

## FLOW MAP (adjacency) — COMPUTED from SceneRouter

```
[BOOT] BootRoot
  TITLE --"NEW CAREER"--> CreationRoot (country / market)
  TITLE --CONTINUE (if save)--> CareerRoot day_feed     [COPY: NOT COMPUTED this pass — green CONTINUE exists in comments; button inventory incomplete]
  TITLE --"LOAD"--> SLOTS board
  TITLE --"SETTINGS"--> SETTINGS board
  SLOTS / SETTINGS --back--> TITLE
  CreationRoot @ country back --> BootRoot TITLE

[CREATION] CreationRoot + CreationFlowPanel
  market --"CHOOSE MARKET"--> city --"ENTER CITY"--> gym
  gym --"OPEN GYM"--> CareerRoot day_feed  (seam into THE DAY)

[CAREER] CareerRoot + ShellChrome rail (SceneRouter labels)
  day_feed (THE DAY) | today alias (TODAY'S BRIEFING)
  gym / gym_floor / roster | fighter_card | training
  calendar / events / event_detail | scouting | rankings
  office_menu / contracts / finances / objectives / weight_class | staff
  fight_test (dev Match Simulator)
  Continue → GameState.advance_day; may push crowning

[SETPIECE] SetpieceRoot
  fight_week → weigh_in → fight_night → fight_result → leave
  crowning (optional) → leave
  leave → back_or(day_feed)

[OVERLAY] FightContractScreen — present() from booking; ESC / CLOSE

[DEV] fight_world_live / fight_world_preview
      FightAnimLab / UIKitGallery — entry UNKNOWN; egress UNKNOWN
```

### Career loop (week / fight)

1. Day advance via Shell Continue (`GameState.advance_day`) — “week” is chrome language, not its own scene.
2. THE DAY → gym / training / fighter card → book contract → setpiece chain → leave → THE DAY.
3. Legacy ManagementChrome may still speak **week** CONTINUE — dual clock risk. **NOT COMPUTED** (code still loads ManagementChrome from ShellChrome).

---

## Dead ends / multi-route problems

**Dead ends (no clear player back):** FightAnimLab, UIKitGallery, fight_world_* (exit UNKNOWN). Fight result has `leave()` but leave CTA **NEEDS WORDS**.

**Dual routes that should not both ship long-term:**

1. DayFeedScreen.tscn **and** CareerRoot-hosted panel
2. AthleteProfileShellScreen.tscn **and** `fighter_card` panel
3. `today` vs `day_feed` (two labels, one panel)
4. ShellChrome+SceneRouter vs ManagementChrome+DIRECT_SCENES
5. FightWorldPreview vs FightWorldLive vs FightNight
6. gym / gym_floor / roster aliases; calendar / events / event_detail aliases

---

## Missing screens (named — do not invent)

1. **Corner instruction UI between rounds** — `TASK_CORNER_UI.md` (engine ready, screen missing)
2. Unified post-fight “what now” title + CTA (result phase exists; words incomplete)
3. Dedicated Week Planning scene — only if design wants one; currently chrome only
4. Player-facing menus into FightAnimLab / UIKitGallery (or strip the scenes from player builds)
5. Save overwrite confirm words on slots board — **NOT INVENTORIED**
6. Hub gold action words — mostly **NEEDS WORDS**

---

## Redundant pairs (merge candidates)

1. ManagementChrome ↔ ShellChrome (keep one Continue clock)
2. Standalone DayFeed / Profile `.tscn` ↔ CareerRoot hosting
3. `today` ↔ `day_feed` (one label)
4. FightWorldPreview ↔ FightWorldLive (dev only — collapse or quarantine)
5. Office aliases as rail peers — already folded under OFFICE; keep as tabs, not separate destinations

---

## WORDS ON THE ROUTES (partial)

Status: **COMPUTED** = literal on Beast; **NEEDS WORDS**; **UNKNOWN**.

### Boot TITLE (`TitleBoardPanel.gd`) — COMPUTED

| Element | Copy |
|---|---|
| Brand | `FIGHTCAMP` |
| Primary | `NEW CAREER` |
| Secondary | `LOAD` |
| Tertiary | `SETTINGS` |
| Full slots cue | `EVERY SLOT IS TAKEN  ·  NEW CAREER ASKS WHICH LIFE TO REPLACE` |

CONTINUE-on-title (resume save) — referenced in comments; button build **NOT fully inventoried this pass**.

### Creation golds (`CreationFlowPanel.gd`) — COMPUTED

| Step | Gold |
|---|---|
| Market | `CHOOSE MARKET` |
| City | `ENTER CITY` |
| Gym | `OPEN GYM` |

Headers (not golds): `CHOOSE THE MARKET`, `CHOOSE THE CITY`, `NAME THE GYM`.

### Career rail labels (`SceneRouter`) — COMPUTED

THE DAY · GYM · MY GYM · FIGHTERS · FIGHTER CARD · TRAINING · SCHEDULE · EVENTS · EVENT · SCOUTING · RANKINGS · OFFICE · STAFF · CONTRACTS · FINANCES · OBJECTIVES · WEIGHT CLASS · TODAY'S BRIEFING · MATCH SIMULATOR

Continue strip copy — prior hub read claimed `CONTINUE →` / `%d MUST ANSWER FIRST` / `ALL CLEAR · NEXT DAY` — **re-verify ShellChrome on pass 2**.

### FightContractScreen footer — prior read, re-verify pass 2

WALK AWAY / PROPOSE TERMS / ACCEPT AS OFFERED — treat as **UNVERIFIED_THIS_PASS** until re-grep.

### Setpiece phase labels — COMPUTED

FIGHT WEEK · WEIGH-IN · FIGHT NIGHT · RESULT · CROWNING

### Unfinished (~80% of word inventory)

Hub golds, DayFeed card verbs, FightNight HUD, FightResult leave CTA, Slots/Settings boards, DevJump menus.

---

## First run: Boot → first meaningful decision

| Step | What | Action |
|---:|---|---|
| 0 | BootRoot loads | (optional intro — UNKNOWN) |
| 1 | TITLE board | **First meaningful decision** |

**Steps to first choice: 1** (NEW CAREER / LOAD / SETTINGS).

Empty disk forward: NEW CAREER → CHOOSE MARKET → ENTER CITY → OPEN GYM → THE DAY ≈ **4 gold decisions** after title.

---

## What this pass did NOT finish

- Full hub panel button inventory
- Live dual-chrome reachability proof (play / DevJump)
- FightContract + FightResult CTA re-grep
- RESEARCH_INDEX deep pass for flow/nav/K70–K75
- Pass 2 route-words sheet
- Defining the “64 scripts” counting rule

---

## WHAT IS STILL WRONG

1. **Two navigation systems** (SceneRouter+ShellChrome vs ManagementChrome+DIRECT_SCENES) — dual Continue risk.
2. **Standalone `.tscn` beside hosted panels** — DayFeed / Profile dual routes.
3. **Corner UI missing** in the fight chain (`TASK_CORNER_UI`).
4. **Word inventory ~20%** — hubs / HUD / result leave mostly NEEDS WORDS.
5. **~64 script claim does not match** Screen(7)+Panel(25)=32 under those globs.
6. **Lab/dev scenes lack documented egress.**
7. **today vs day_feed** — two labels for one surface.
8. **Fight result leave CTA** unnamed — player may not know how to return to THE DAY.
