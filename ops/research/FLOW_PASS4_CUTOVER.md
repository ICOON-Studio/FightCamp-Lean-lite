# FLOW_PASS4_CUTOVER — PASS 4

**NOT FINISHED.** Words only. No `.gd` / `.tscn` / `HANDOFF.md` edits. Passes 1–3 are the map; this is the change list a build works down.

| Field | Value |
|---|---|
| Pass | **4** |
| Date | 2026-09-22 |
| Agent | Kalli |
| Prior | `FLOW_PASS2_ROUTE_WORDS.md`, `FLOW_PASS3_HUB_AND_HUD_WORDS.md`, Maria `M29_LEAVE_AND_CONTINUE.md` |
| Authority for *where* | Beast literals this pass (`Godot/scripts/…`) |
| Honesty | `COMPUTED` = literal/route on Beast. `NOT COMPUTED` where wiring or live reachability is unclear. |
| Out of scope | Corner UI (Codex). Maria's look. Implementing the wire. HANDOFF edit. |

---

## Three lines first

1. **Cutover table** = every player-facing string that must change. Pass 3 hub golds / DayFeed verbs / FightNight HUD that already match Beast are **not** rows.
2. **Dual Continue:** Shell `CONTINUE →` survives. ManagementChrome header `CONTINUE  ▸` dies as a Continue twin — interim word **`NEXT STOP ▸`** (Maria: different shape). No conflict with M29 (see §1).
3. **Leave CTA:** empty-card `CONTINUE TO OFFICE  ▸` → **`BACK TO THE DAY ▸`** → `day_feed`. Kept after self-argue (§2).

---

## CUTOVER TABLE

`chars` = character count of the **new** string (Unicode; `▸` / `→` / `·` = one each).

| current string | where it is | new string | chars | why |
|---|---|---|---|---|
| `CONTINUE TO OFFICE  ▸` | `FightResultPanel.continue_label_for` — empty-card / no-crowning branch (primary GO CTA, left foot) | `BACK TO THE DAY ▸` | 17 | empty card must name THE DAY, not OFFICE |
| `CONTINUE  ▸` | `ManagementChrome` header advance cell (week / schedule walk) | `NEXT STOP ▸` | 11 | must not share CONTINUE with Shell day clock |
| `CLICK A DAY FOR ITS OBLIGATIONS  ·  TODAY'S BRIEFING LIVES ON THE DAY` | `ScheduleHubPanel` calendar hint caps line | `CLICK A DAY FOR ITS OBLIGATIONS  ·  OPEN THE DAY FOR WHAT IS DATED` | 66 | drop dead route title TODAY'S BRIEFING |

### Not rows (say why)

| Item | Honesty | Note |
|---|---|---|
| `CONTINUE TO CARD  ▸` / `CONTINUE TO NEXT CARD  ▸` | COMPUTED — **keep** | Pass 2: card still working; destination honest |
| Shell `CONTINUE →` + subcopy | COMPUTED — **keep** | Surviving day clock (Maria M29) |
| Hub golds / DayFeed chips / FightNight HUD (Pass 3) | COMPUTED — **no change** | Already locked; cutover is deltas only |
| Setpiece / UIKit `WAY OUT` label | COMPUTED label — **keep string** | Fallback route `calendar` → `day_feed` is wire, not a rename; final chrome copy after wire **NOT COMPUTED** |
| `TODAY'S BRIEFING` as `SceneRouter` route `today` label | COMPUTED — **dies with route** | Under ROUTES THAT DIE — not renamed here (avoids table↔kill contradiction) |
| Dynamic `push("today")` callers | **NOT COMPUTED** complete | Pass 3: zero literals in `.gd`; saves / deep-links unsettled — do not invent sites |

---

## 1. THE DUAL CONTINUE

### Survives

| Control | Screen / chrome | Word | Job |
|---|---|---|---|
| **Shell Continue** | `ShellChrome` continue unit (career shell) | **`CONTINUE →`** (keep) | Day clock → advance day / gate copy |

Maria M29: one green Continue on the **fight-result left-foot GO seat** (card / leave CTAs), and separately **one Shell Continue** for the day clock. Shell word stays **`CONTINUE →`**.

### Dies (as a second CONTINUE)

| Control | Screen / chrome | Current word | Fate |
|---|---|---|---|
| ManagementChrome header advance | `ManagementChrome` header cell | `CONTINUE  ▸` | **Lose the word CONTINUE.** Until week-stop lives on Shell Continue: show **`NEXT STOP ▸`** (Maria: different label + different shape, not GO twin). After merge: **remove** the control. |

Live reachability of that header in normal boot: still **NOT COMPUTED** (no play trace). If both Continues appear, presentation treats it as a defect (Maria) — words agree.

### Agreement with Maria M29 — conflict check

| Topic | Maria | Kalli Pass 4 | Conflict? |
|---|---|---|---|
| Shell day clock | Keep one `CONTINUE →` | Keep | **No** |
| Header week twin saying CONTINUE | Do not art; defect | Rename to `NEXT STOP ▸` or delete after merge | **No** — she forbade CONTINUE twin; we fill the NEEDS WORDS interim |
| Empty-card leave seat | Left-foot GO eye-slot; label NEEDS WORDS | Same seat; freeze `BACK TO THE DAY ▸` | **No** — seat/colour hers; string ours |
| Empty-card wearing CONTINUE | Reject equal-weight same-word Continues | Leave string drops CONTINUE | **No** — strengthens her reject board |

**Explicit:** no placement-vs-word conflict to escalate. If a later art pass paints `NEXT STOP ▸` in GO green, that would conflict — words require muted / non-GO shape per M29.

---

## 2. THE LEAVE CTA

| Case | String | Route |
|---|---|---|
| Empty card, no crowning | **`BACK TO THE DAY ▸`** (17) | `day_feed` |
| Card still has work | keep `CONTINUE TO CARD  ▸` | `events` + id |
| Another bout tonight | keep `CONTINUE TO NEXT CARD  ▸` | `events` + next |
| Pending crowning | keep routing into crowning | `crowning` |

**Wire (not Kalli):** `FightResultPanel` empty branch + `SetpieceRoot.leave()` fallback `calendar` → `day_feed`.

### Why this word — and the two losers

**Keep: `BACK TO THE DAY ▸`.**

One sentence: it names the career loop surface the rail already calls **THE DAY**, points at `day_feed`, and refuses a bare Continue that hid the hole.

### Argue against myself

**Claim I am most sure of:** empty-card leave must read **`BACK TO THE DAY ▸`**.

**Best case it is wrong**

1. **BACK sounds like undo.** Post-fight can feel like retreat from the card, not return to the job. `OPEN THE DAY ▸` is forward.
2. **THE DAY is our jargon.** A player who never read the rail may not map it to the briefing board — `BACK TO CAMP ▸` uses a world noun.
3. **Maria's GO seat already screams primary.** `CONTINUE TO THE DAY ▸` would keep one verb family.

**Losers (rejected)**

| Reject | Why it loses |
|---|---|
| `CONTINUE TO OFFICE  ▸` (current) | Honest about a desk, wrong land for the career loop |
| Bare `CONTINUE ▸` | How the hole opened — destination silent |
| `OPEN THE DAY ▸` (strongest alt) | Clearer door verb, but breaks the loop pair with **ENTER FIGHT WEEK** forward / **BACK TO THE DAY** return |
| `CONTINUE TO THE DAY ▸` | Keeps CONTINUE on leave; fights Maria's equal-weight Continue reject |

**Keep `BACK TO THE DAY ▸`.** Playtest escape hatch without route change: **`OPEN THE DAY ▸`** (14).

---

## 3. ROUTES THAT DIE

Pass 2 dropped the unreproducible "~64" count and adopted **~31 player-facing SceneRouter routes**. Beast this pass: **33** router keys (31 player-facing + 2 fight-world preview/live). This section is **product kills**, not a recount of phantom screens.

### Router ids that die

| Route id | Current label (COMPUTED) | Why it dies |
|---|---|---|
| `today` | `TODAY'S BRIEFING` | Alias of `day_feed` / THE DAY — Pass 2/3 kill |

### Non-router kills (not SceneRouter rows)

| Thing | Why |
|---|---|
| `ManagementChrome.DIRECT_SCENES` remount of `DayFeedScreen.tscn` for players | Pass 2: one hosted THE DAY |
| `CareerRoot` panel map entry `today` | Pass 3 registry |
| `DIRECT_SCENES["today"]` key | Pass 3 registry |
| Tests expecting `today` (`scene_router_test`, `office_hub_panel_test`) | Retarget / delete |

### Contradiction check (required)

I checked: **`today` is on this die list and has no rename row in the cutover table** (its label dies with the route). Table rows touch `FightResultPanel`, `ManagementChrome` header label, and `ScheduleHubPanel` hint only — none of those are dying routes.

Hub routes that keep strings (`day_feed`, hubs, setpiece result path) are **not** on this die list.

### NOT COMPUTED

- Full dynamic callers that still push `today` after registry delete (Pass 3).
- Whether `main_menu` vs `boot` should die — **not** decided in Passes 1–3; **not** killed here.
- Lab egress — still UNKNOWN; not invented as kills.

---

## WHAT IS STILL WRONG

1. Cutover words locked — **wire not landed**.
2. Dual Continue interim `NEXT STOP ▸` still a second time control until week-stop merges into Shell Continue.
3. `today` registries still live; dynamic callers NOT COMPUTED complete.
4. WAY OUT string kept; leave **route** still SCHEDULE until wire.
5. Attention-strip verb catalogue still NOT COMPUTED (Pass 3).
6. ManagementChrome live reachability still NOT COMPUTED.
7. Corner UI still missing (Codex — not ours).
8. This pass does not implement.

---

## Acceptance for Pass 4

- [x] One cutover table with where / chars / why
- [x] Dual Continue survive/die named; Maria conflict checked explicitly
- [x] Leave CTA frozen + self-argue + losers shown
- [x] Routes that die listed; table↔kill contradiction checked
- [x] NOT COMPUTED preserved
- [x] No HANDOFF / no code / no corner / no Maria look
