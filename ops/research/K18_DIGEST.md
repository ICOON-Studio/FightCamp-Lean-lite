# K18 DIGEST — THE DAY (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.
No HANDOFF.md edits from this study.

## A) Pick + two rejects

**PICK: Briefing surface.** THE DAY earns: attention strip (when loud) → briefing hero → thin ticker → **today-only** dated events → must-answer context (shell Continue subtitle + optional ask drill-ins). Shell owns the only green CONTINUE (`advance_day`). Body content area stays ~1494×846 under ShellChrome.

- **REJECT 1: Body Continue / action-card Continue unit** — current `DayFeedPanel` draws `UIKit.continue_unit` inside `UIKit.action_card`. Kill it; shell already owns the only advance.
- **REJECT 2: Hub badge dump** — training capacity, office payroll, scouting counts. Rail already owns those; duplicate = noise.
- **REJECT 3 (also locked): Full week calendar / books ledger** — SCHEDULE / OFFICE drill-ins, not this surface.

Lost if body Continue stays: two advances, grammar break. Lost if hub badges dump: briefing becomes a second rail. Lost if week calendar lands: THE DAY becomes a second SCHEDULE.

## B) Priority order (what earns a place)

1. **Attention strip** — only when `get_day_relationship_attention()` has items / `worst_tone != ok` (C16). Chips: loyalty strike/warn, rivalry HEATED+, open grudge offers. Drill via `route` / `route_args`. **Do not show COLD/SIMMERING.**
2. **Briefing hero** — top headline from `get_news`.
3. **Thin ticker** — next headlines (quiet state ok).
4. **Today's dated events** — only what happens TODAY (`get_fight_offers` / `continue_day_events` filtered to today), not the full SCHEDULE calendar.
5. **Must-answer context** — `get_open_requests` count feeds shell Continue subtitle (`N MUST ANSWER FIRST`); body may list open asks as drill-ins but **MUST NOT** draw a second Continue.

## C) Fight week board

When a bout is booked this week, the day is about the **set-piece path** (K7). Hero/stakes become fight-week oriented; gold ×1 on **ENTER FIGHT WEEK**. Attention strip still stacks above if loud. **Not a second SCHEDULE.**

## D) Gold ×1 per board

| Board | Gold |
|---|---|
| **DAY** | Featured TODAY event **OPEN** (or OPEN ASK if requests block and that is the one act) |
| **ATTENTION** | Worst attention chip drill (**VIEW FIGHTER** / VIEW RIVAL) |
| **FIGHT WEEK** | **ENTER FIGHT WEEK** |
| **STATES** | One gold on contact legend / first-career **OPEN GYM** (prefer legend chip + that cell primary) |

Green = shell CONTINUE only — never in body.

## E) Kit gaps

Reuse first: `briefing_hero`, `ticker_row`, `alert_strip`, `badge`, pair slate, silhouettes, ShellChrome rail/top/day strip/Continue.

| Instrument | Need |
|---|---|
| `day_attention_strip` | Chips from C16 items (tone · headline · drill from route) |
| `day_event_row` | Today-only event / ask row + OPEN |
| `fight_week_banner` | Booked-bout banner → ENTER FIGHT WEEK |
| `quiet_empty_state` | Honest empty (no news / no attention / no today) |

**Remove body `continue_unit` from this surface's kit use.**

## F) Reads relied on

| Read | Use |
|---|---|
| `get_news(limit)` | Hero + ticker |
| `get_day_relationship_attention()` | Strip; C16 shape: `items[{kind,athlete_id,athlete_name,rival_id,headline,detail,tone,urgency,route,route_args}]`, `counts`, `worst_tone` |
| `get_open_requests()` | Shell subtitle + ask drill-ins |
| `get_fight_offers` / `continue_day_events` | Today-only dated events |
| `get_weekly_objectives()` | **Only if claimable today** — else leave to OFFICE |

**Missing / name for build:** stable “bout booked this week” flag for fight-week dress (or derive from offers/calendar today+week); today-filter helper on `continue_day_events` (panel currently dumps whole week arrivals — that dump is Reject 3). C16 fields assumed present per TASK_C16; if `route`/`route_args` absent on any item, strip cannot drill safely — name in build.

## G) Boards (1920×1080, ShellChrome)

1. **DAY** — ordinary; strip hidden; gold OPEN
2. **ATTENTION** — loud strip above hero; gold VIEW FIGHTER
3. **FIGHT WEEK** — banner + stakes; gold ENTER FIGHT WEEK
4. **STATES** — (a) first career quiet (b) result hero (c) empty-inbox quiet (d) week boundary

Sample: Eastern Ring · Kian Sterling gym · plausible headlines only.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only on shell; pair = slate; facility is GYM; silhouettes; invent nothing beyond plausible sample labels consistent with prior Kian Sterling studies; ShellChrome rail + top + day strip + CONTINUE.

## Files

- `THE_DAY_K18.html`
- `THE_DAY_K18_day.png` / `_attention.png` / `_fight_week.png` / `_states.png`
- `K18_DIGEST.md` (this file)

## Blockers

Study unblocked. Build needs: kill body continue_unit; add attention strip on C16 read; today-only event filter; fight-week banner seam into K7. Confirm booked-this-week read. Parent owns HANDOFF.
