# FLOW_PASS3_HUB_AND_HUD_WORDS — PASS 3

**NOT FINISHED.** Words and flow only. No geometry, colour, fonts. No chrome merge. Corner UI (Codex) and Maria's look are out of scope.

| Field | Value |
|---|---|
| Pass | **3** |
| Date | 2026-09-22 |
| Agent | Kalli |
| Prior | `research/FLOW_PASS2_ROUTE_WORDS.md` (Beast-verified land) |
| Honesty | `COMPUTED` = literal string or route on Beast this pass. `NOT COMPUTED` where wiring / live reachability is unclear. |
| Out of scope | `TASK_CORNER_UI` (Codex). `TASK_VFX_AND_PRESENTATION` (Maria). Implementing kills / merges. |

---

## Three lines first

1. **Hub golds / DayFeed verbs / FightNight HUD** — most loud buttons already exist in code; this pass **locks** them, fills the gaps, and puts a **character budget** on every line so nothing is silently clipped.
2. **`today` call-sites** — alias kill stands. Registries are COMPUTED. **No** `SceneRouter.push("today")` literal found in `.gd` this pass; treat that as **NOT COMPUTED complete** for dynamic callers, and give the implementer the list we can see.
3. **Strongest gold** — **ENTER FIGHT WEEK** on THE DAY. Kept after self-argue (below).

---

## Character budgets (do not silently cut)

| Kind | Budget | Rule |
|---|---|---|
| Hub gold (primary button) | **≤ 22** preferred, **≤ 28** hard | Longer must **WRAP** (two lines) or lose words — never ellipsis-clip a gold. |
| DayFeed action chip (`OPEN` / `ANSWER`) | **≤ 10** | One word. |
| Frame / section title | **≤ 28** | Caps line. |
| Eyebrow / subcopy | **≤ 42** | Soft wrap OK. |
| FightNight phase chip | **≤ 8** | `LIVE` / `CORNER` / `OVER`. |
| FightNight HUD meta line | **≤ 36** | Soft wrap OK. |
| Long instruction (corner / Contingency) | **≤ 60** | Must WRAP; never silent cut. |

`SIZE_MIN` in tokens is **12**. Budgets above are word budgets for authors, not px.

---

## 1. HUB GOLDS

One gold per board. Green stays the shell's **CONTINUE →** only.

| Hub (rail) | Route id (Pass 2 keep) | Gold (lock) | Chars | Status | When it shows |
|---|---|---|---|---|---|
| **THE DAY** | `day_feed` | **ENTER FIGHT WEEK** | 16 | COMPUTED (`UIKit.fight_week_banner`) | Fight-week card present |
| THE DAY (no fight week) | `day_feed` | Loudest attention drill's own CTA, else featured row **OPEN** | — | COMPUTED priority in `DayFeedPanel` | Attention > dated row |
| **GYM** | `gym` / floor tabs | **REPAIR · $…** when broken; else **EXPAND TRAINING ROOM · $…** when expand is the spend; else **no visit-gold** (row open is the act) | WRAP with money | COMPUTED | Situational |
| **TRAINING** | `training` | **OPEN THE CAMP** when a camp exists; else programming verbs are not gold (`COPY THIS DAY` / `PASTE` / `CLEAR THE WEEK`) | 13 | COMPUTED | Camp tab / booked bout |
| **SCHEDULE** | `calendar` | Context golds: **BOOK SELECTED** / **OPEN AGREEMENT** / **ENTER THE CARD** / **CONFIRM THE MATCH** / **TAKE SEAT** | ≤ 18 | COMPUTED | Cards / offers / seat |
| **SCOUTING** | `scouting` | Drawer gold: **SEND OFFER** → **SIGN CONTRACT**; row opens with **OPEN THE OFFER** / **TERMS AGREED - SIGN** / **BACK TO THE TABLE** | ≤ 18 | COMPUTED | Negotiation state |
| **RANKINGS** | `rankings` | **FIND OURS**; belt side **OPEN HOLDER** | ≤ 11 | COMPUTED | List / belt |
| **OFFICE** | `office_menu` | **OPEN THE BOOKS** | 14 | COMPUTED | Desk land |
| **STAFF** | `staff` | **ASSIGN FIGHTER** → armed **PICK A FIGHTER** (+ **CANCEL**) → **CLEAR ASSIGNMENT** | ≤ 17 | COMPUTED (`UIKit.assign_arm`) | Arm machine |

### Gaps still NEEDS WORDS (not invented)

| Surface | Gap | Note |
|---|---|---|
| GYM roster land | No single visit-gold when floor is healthy | **Keep none.** Selecting a row opens the card — do not invent ENTER FLOOR. |
| Attention strip on THE DAY | Per-item CTA text | **NOT COMPUTED** full catalogue this pass — items carry their own route; chip should stay the item's verb or **OPEN**. |
| Boot SLOTS / SETTINGS back | Pass 2 still NEEDS WORDS | Out of hub scope; still open. |

---

## 2. DAYFEED VERBS (THE DAY)

Voice already in panel/banner (COMPUTED):

| Slot | Words | Budget | Role |
|---|---|---|---|
| Fight-week eyebrow | `FIGHT WEEK  ·  THE GYM POINTS ONE WAY` | 42 | Teaches the mode name before the gold |
| Fight-week gold | `ENTER FIGHT WEEK` | 16 | Only gold when banner shows |
| Timing chips | `TODAY` / `TOMORROW` / `IN N DAYS` | ≤ 12 | Days-out |
| Dated frame | `TODAY  ·  WHAT IS DATED` | 22 | Content today, not the dead route |
| Dated empty | `NOTHING IS DATED TODAY` / sub `the week's calendar lives on SCHEDULE` | WRAP | Honest quiet |
| Wire empty | `NOTHING ELSE ON THE WIRE` / `the board is quiet this morning` | WRAP | |
| Asks frame | `MUST ANSWER  ·  N` | ≤ 18 | Gates shell Continue |
| Asks empty | `ALL CLEAR` / `nobody is waiting on you` | WRAP | |
| Dated row action | **OPEN** | 4 | Chip |
| Ask row action | **ANSWER** | 6 | Chip |
| Hero kind | `LIVE BRIEFING  ·  {KIND}` | ≤ 28 + kind | Briefing hero |

### Verbs locked this pass

1. **OPEN** — every dated event / offer row that drills in.
2. **ANSWER** — every open ask.
3. **ENTER FIGHT WEEK** — only fight-week banner gold.
4. Never put a second Continue on this board (Pass 2 / panel law). Shell owns **CONTINUE →**.

Content language may still say today inside THE DAY. That is **not** the route alias.

---

## 3. FIGHTNIGHT HUD

Live read words (COMPUTED from `FightHudPanel` / `FightNightScreen` / `UIKit` corner chrome):

| Slot | Words | Budget | Notes |
|---|---|---|---|
| Eyebrow | `LIVE READ` | 9 | |
| Phase | `LIVE` / `CORNER` / `OVER` | ≤ 6 | Resting → CORNER; finished → OVER |
| Round | `ROUND N / N` | ≤ 14 | Also `ROUND` clock cap |
| Clock sub (chrome) | `ROUND N / N` or method / `LIVE` | ≤ 16 | |
| Score | `A - B` numerals | — | |
| Scored | `N ROUNDS SCORED` | ≤ 18 | |
| KD line | `KD N THIS ROUND  /  N TOTAL` | ≤ 32 | |
| Heart | `N BPM` + zone | ≤ 8 + zone | Zones COMPUTED: `RED LINE`, `THRESHOLD`, `AEROBIC` (+ muted default) |
| Corner seat chip | `RED · {label}` / `BLUE · {label}` | ≤ 24 | `CORNER_WORDS` a/b |
| Watch chip | `AI CORNER  ·  WATCHING` | 22 | Spectator |
| Stakes (own bout) | `MAIN EVENT  ·  {RULESET}` | WRAP | |
| Stakes (watch) | `EVENT NIGHT  ·  AI CORNER  ·  {RULESET}` | WRAP | |
| Empty title | `FIGHT NIGHT` | 10 | |
| Empty back | `←  BACK` | 8 | |
| Advice title | `GIVE ADVICE` | 11 | Default |
| Contingency title | `THE CONTINGENCY CALL` | 20 | End of round |
| Chain title | `ANSWER THE CHAIN` | 16 | |
| Hurt title | (dynamic) | WRAP | |
| Context EOR | `END OF ROUND N  •  CORNER WINDOW OPEN` | ≤ 40 | WRAP if needed |
| Resume | `RESUME FIGHT  →` | 15 | |
| Final round kit | `FINAL ROUND` / `N OF N USED` | ≤ 14 | |

### HUD gaps (NOT OURS to invent look for)

| Gap | Honesty |
|---|---|
| Full corner-panel copy | Codex `TASK_CORNER_UI` — do not take |
| Maria presentation / VFX of the HUD | Out of scope |
| Whether every zone string is fed live in career bouts | **NOT COMPUTED** play trace this pass |

---

## 4. `today` CALL-SITE LIST

**Decision (Pass 2, stands):** kill route id `today` / label **TODAY'S BRIEFING**. Keep `day_feed` / **THE DAY**.

### COMPUTED registries (Beast this pass)

| File | What | Action for implementer |
|---|---|---|
| `Godot/scripts/SceneRouter.gd` ROUTES `today` | Alias → same panel as `day_feed`, label `TODAY'S BRIEFING` | **Delete** route entry |
| `Godot/scripts/CareerRoot.gd` panel map `today` | Hosts DayFeed, nav `day_feed` | **Delete** map entry |
| `Godot/scripts/ManagementChrome.gd` `DIRECT_SCENES["today"]` | Points at CareerRoot.tscn | **Delete** key (with Pass 2 DIRECT_SCENES DayFeed kill) |
| `Godot/scripts/ScheduleHubPanel.gd` hint copy | contains TODAY'S BRIEFING LIVES ON THE DAY | **Rewrite** to drop dead name |
| `Godot/tests/scene_router_test.gd` | expected career ids include today | **Remove** from expected set |
| `Godot/tests/office_hub_panel_test.gd` | `router.describe("today")` | **Retarget** assert to `day_feed` only / delete today describe |

### COMPUTED non-route today (KEEP)

These are **not** the alias. Do not purge blindly:

| Kind | Examples |
|---|---|
| DayFeed board-owner id | `_gold_owner == "today"` (dated-events board, not route) |
| Calendar cell flag | `day.today == true` → label `TODAY` vs `IN THE MONTH` |
| Shell week strip | `today: i == career_day` |
| Content frames | `TODAY  ·  WHAT IS DATED`, `NOTHING IS DATED TODAY` |
| Prose / comments | today in English |

### push("today") literals

**NOT COMPUTED complete.** Grep of `Godot/**/*.gd` found **zero** `push("today")` / `go("today")` literals this pass.

What that means: the alias may be dead at runtime except via `describe("today")`, tests, or **dynamic** route ids (saves, bookmarks, `navigate_to(module_id)` with a stored id). Implementer must still:

1. Delete the three registries above.
2. Grep again after delete for `"today"` as a **route argument**.
3. Check any save / analytics / deep-link tables outside `Godot/scripts` — **NOT COMPUTED** from this seat if they live off-tree.

**Plainly:** from Beast scripts + tests I can see the registries and I cannot claim the whole tree has no dynamic pusher.

---

## 5. ARGUE AGAINST MYSELF — ENTER FIGHT WEEK

**Claim I am most sure of:** THE DAY's gold, when a bout sits in this week, must be **ENTER FIGHT WEEK**.

### Best case it is the wrong word

1. **Mode name before teaching.** Fight Week is our setpiece label. A new player has not earned that noun. The banner eyebrow tries to teach it in the same breath the button demands it — that is two loads on one glance.
2. **ENTER is soft.** It does not say weigh-in, card, or corner. It says doorway. Soft doorways get clicked late.
3. **Competing clearer lines:** `OPEN THE CARD`, `GO TO THE BOUT`, `THIS WEEK'S FIGHT`, `START FIGHT WEEK`. Each names a thing the player already understands (card / bout / fight) better than a mode.
4. **Truncation risk is low here (16 chars) but metaphor risk is not.** Clever mode names have bitten this project when the wire was not ready.

### Why I still keep it

1. **COMPUTED and shipped in `UIKit.fight_week_banner`** — one gold, one banner, one string. Renaming without renaming the setpiece chain (`fight_week` route) splits voice.
2. The eyebrow **`FIGHT WEEK  ·  THE GYM POINTS ONE WAY`** is the teach; the button repeats the noun on purpose.
3. Pass 2 already locked leave copy to **THE DAY**; fight-week is the matching forward noun on the same loop.

**Keep: `ENTER FIGHT WEEK`.** If a later playtest shows blank stares, swap to **`OPEN THE CARD`** (14) without changing the route id `fight_week`.

---

## 6. WHAT IS STILL WRONG

1. Leave CTA / Setpiece fallback — words decided in Pass 2, **wire not landed**.
2. `today` registries still live; dynamic callers **NOT COMPUTED** complete.
3. Dual Continue not collapsed (blocked on week-stop ownership — Pass 2).
4. Attention-strip per-item verbs catalogue **NOT COMPUTED**.
5. Live ManagementChrome reachability in normal boot **NOT COMPUTED** (no play trace).
6. Lab egress UNKNOWN.
7. Corner UI still missing (Codex — not ours).
8. This pass does not implement.

---

## Acceptance for Pass 3

- [x] Hub golds locked with budgets (COMPUTED where present; gaps named)
- [x] DayFeed verbs locked (OPEN / ANSWER / ENTER FIGHT WEEK + frames)
- [x] FightNight HUD word sheet with budgets
- [x] `today` call-site list — registries COMPUTED; push literals none found; completeness NOT COMPUTED
- [x] Self-argue on ENTER FIGHT WEEK; keep decision
- [x] NOT COMPUTED preserved
- [x] No corner / no Maria look / no HANDOFF edit
