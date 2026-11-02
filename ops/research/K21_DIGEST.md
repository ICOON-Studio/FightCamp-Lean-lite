# K21 DIGEST — THE FIGHT CAMP, HOW IT READS (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.
No HANDOFF.md edits from this study.

## A) Pick + rejects

**PICK: SETUP is a set-piece over the profile CAMP tab (booking-shaped).**
Profile CAMP tab = **THE SEAM** — read-only summary + START/OPEN CAMP. SETUP itself is a full-bleed set-piece committed once, weeks ahead — closer to R33 BOUT AGREEMENT than a weekly hub board.

- **REJECT 1: Full profile tab as the whole SETUP surface.** Lost: isolation for a weeks-ahead commit; profile chrome crowds the projection.
- **REJECT 2: Weekly GYM/SCHEDULE-style hub board.** Lost: wrong cadence (camp is one commit then runs).
- **REJECT 3: Orphan panel with no seam.** Lost: status quo — unreachable (FightCampPanel mounted by nothing).

**Projection instrument PICK: single moving PROJECTION DOCK + last-pick DELTA CHIPS (C20).**
Absolutes always in one dock: `edge_lines`, tightness, fatigue_on_the_night, film_depth, cash/cost, fight_iq_gain.
When choices include `_compare_against`, show only CHANGED keys as tone chips (good/warn/bad/flat) beside the figure — not a wall of arrows.
**Injury risk:** own RISK band / meter — not in the edge column. Rising injury = bad tone from API; never edge-like.
Empty choices → empty projection / empty deltas (C20).

**People vs settings PICK: two zones on SETUP.**
SETTINGS (left/center): focus, protocol, cut plan, counter — chip rows (ids from data).
PEOPLE (right/lower): person cards (silhouette + name + role/fee or specialist slot) — partner_role then partner; coach on earned slot. Never dropdown. Roster free (lose their week) vs world fee on card.

**Week log PICK:** one row per completed week — week #, taper flag, short built line (edge/film), cost, injury tick. Header: weeks_left, film depth, counter open at depth 3. No full projection re-dump per row.

**Report card PICK:** grade as gold×1 verdict; projected vs built as paired `lines` rows; injuries dock; cost footnote. Verdict on decisions, not a receipt.

## B) Priority order (SETUP glance)

1. Opponent / weeks available
2. Projection dock (absolutes)
3. Last-pick delta chips (when comparing)
4. Injury RISK band
5. Focus + protocol chips
6. People cards (partner → coach)
7. Cut plan
8. START CAMP (+ blocked_reason)

## C) Gold ×1 per board

| Board | Gold |
|---|---|
| **SETUP** | **START CAMP** |
| **PROJECTION** | last-pick **protocol · hard_sparring** delta chip |
| **PROGRESS** | **SET COUNTER** (when film depth 3) |
| **REPORT** | grade mark (**A** · FightCamp.grade bands) |
| **SEAM** | **START CAMP** on profile CAMP tab |

Green = CONTINUE only (shell way-out). PULL OUT / CLOSE / BACK = slate. Pair blocks = slate.

## D) KEEP vs REPLACE

**KEEP**
- FightCamp maths: focus_tracks, protocols, partner_roles, counters, projection, edge_lines, film_report, grade, week_effects, injury_chance
- WeightCut diet plans (none / moderate / aggressive) chosen inside SETUP
- Specialist slots (`slots_for_gym`), roster free vs `world_partner_fee`, taper rules, film max_depth 3
- C20 states: setup | progress | report | unavailable
- Silhouette language; ShellChrome on SEAM; set-piece frame on SETUP/REPORT

**REPLACE**
- FightCampPanel private palette (`C_TEXT`…`C_DANGER` :24-32) → UIKit / UITokens + kit
- Orphan mount (nothing mounts FightCampPanel) → route from profile CAMP tab
- Dead `_want("camp")` START A CAMP → opens set-piece SETUP
- Four separate reads per rebuild → one `get_camp_board` (C20)
- Eye-diff of full projections → deltas for last pick

## E) Kit gaps

Reuse first: K7 set-piece frame, ShellChrome (SEAM), slate `pair`, silhouette cards, CONTINUE green, K20 `verdict_chip` / `reason_chip` / `counter_strip` spirit (counter-open strip on PROGRESS).

| Instrument | Need |
|---|---|
| `camp_projection_dock` | Absolutes block: edge_lines + tightness / fatigue_on_the_night / film_depth / cash / fight_iq_gain |
| `delta_chip` | Changed-key only; tone good/warn/bad/flat from C20; not arrow wall |
| `injury_risk_band` | Separate meter; never in edge column; bad when rising |
| `settings_chip_row` | focus / protocol / cut / counter option chips by data id |
| `person_card` | Silhouette + name + role/fee or slot; roster free vs world fee; no dropdown |
| `camp_week_row` | week # · taper? · short built line · cost · injury tick |
| `camp_grade_mark` | A–F from FightCamp.grade bands; gold×1 on REPORT |
| `camp_lines_table` | Projected vs built paired rows from report.lines |
| `camp_seam_summary` | Profile CAMP read-only summary + START/OPEN |

Do not mint near-duplicates of verdict_chip / reason_chip / counter_strip — dress camp tones with those where they fit; name the above as the gaps.

## F) Reads relied on

| Read / fact | Use |
|---|---|
| `FightCamp.gd` focus_tracks / protocols / partner_roles / counters | SETUP chip ids + names |
| `FightCamp.projection` / `edge_lines` / `film_report` / `grade` | Dock keys, report grade bands A–F |
| `fight_camp.json` | Labels, world_partner_fee, specialist_coach, film_study.max_depth 3, taper, slots |
| `WeightCut.diet` (none/moderate/aggressive) | Cut plan chips |
| `TASK_C20` `get_camp_board` | state, setup.projection/deltas/blocked_reason, progress.weeks, report.lines |
| K20 / R33 kit | set-piece over seam; verdict/reason/counter_strip spirit |
| FightCampPanel.gd :24-32 | Private palette to kill; three states to keep |

**Missing / name for build:** C20 may still be in flight — UI binds to TASK_C20 dictionary shape. Boards show key names and data ids; live absolute figures come from `FightCamp.projection()` at runtime — study invents no athlete maths.

## G) Blockers

- C20 in flight for deltas — OK; rules against TASK_C20 shape.
- R34 implements kit + route from profile CAMP (`START A CAMP` → set-piece).
- Study unblocked. Parent owns HANDOFF. This study did not edit `.gd` / `.tscn` / `HANDOFF.md`.

## Boards (1920×1080)

1. **SETUP** (`board-setup`) — picks + live dock + START CAMP
2. **PROJECTION** (`board-projection`) — empty / deltas after protocol / injury-risk warn
3. **PROGRESS** (`board-progress`) — mid-camp week log + counter open
4. **REPORT** (`board-report`) — grade + projected vs built
5. **SEAM** (`board-seam`) — profile CAMP summary → OPEN/START set-piece

## Files

- `CAMP_K21.html`
- `CAMP_K21_SETUP.png` / `_PROJECTION.png` / `_PROGRESS.png` / `_REPORT.png` / `_SEAM.png`
- `K21_DIGEST.md` (this file)
