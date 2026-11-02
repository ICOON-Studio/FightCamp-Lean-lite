# CLAUDE_LAND_NOTE_FLOW_PASS4

**What finished:** FLOW Pass 4 cutover sheet — every player-facing string that changes (old → new), dual Continue survive/die, leave CTA freeze + self-argue, routes that die. Words only. No `.gd` / `.tscn`. Kalli did **not** edit `HANDOFF.md`.

**Prior:** `FLOW_PASS2_ROUTE_WORDS.md`, `FLOW_PASS3_HUB_AND_HUD_WORDS.md`, Maria `M29_LEAVE_AND_CONTINUE.md` (independent Continue/leave look; NEEDS WORDS filled here).

## Paths to land

Stage both `_kalli_delivery/` and `research/`:

1. `FLOW_PASS4_CUTOVER.md` — **real body** (not a placeholder)
2. `CLAUDE_LAND_NOTE_FLOW_PASS4.md` (this file)

## Decisions Claude should treat as locked for build

| Item | Lock |
|---|---|
| Empty-card leave | `CONTINUE TO OFFICE  ▸` → **`BACK TO THE DAY ▸`** (17) → route `day_feed` |
| Card Continues | keep `CONTINUE TO CARD  ▸` / `CONTINUE TO NEXT CARD  ▸` |
| Shell day clock | keep **`CONTINUE →`** |
| Week twin | `CONTINUE  ▸` → **`NEXT STOP ▸`** (11) until week-stop merges into Shell; then delete control |
| Schedule hint | drop TODAY'S BRIEFING; use **OPEN THE DAY FOR WHAT IS DATED** clause |
| Route kill | **`today`** / TODAY'S BRIEFING dies (no rename row — avoids table↔kill contradiction) |
| Maria M29 | **No conflict** — seat/colour hers; leave + week words ours |

## What Claude should do

- Land / acknowledge the pack.
- HANDOFF Kalli block is Claude's when operator says.
- Build from the cutover table top-down; do not re-derive Pass 2/3.
- Setpiece leave fallback `calendar` → `day_feed` is **wire**, not a string row.
- Preserve **NOT COMPUTED** (dynamic `today` callers; ManagementChrome live reachability).

## Out of scope

- Implementing cutover / SceneRouter cleanup
- Corner UI (Codex)
- Maria look / M29 board paint
- HANDOFF edit by Kalli
