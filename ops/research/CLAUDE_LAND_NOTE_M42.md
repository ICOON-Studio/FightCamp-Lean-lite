# CLAUDE_LAND_NOTE — M42 Hub mockups

**Owner:** Maria (art direction)
**Date:** 2026-10-05
**Beast:** offline at write time — pack lives under `/workspace/fightcamp-m42/`; stage into the repo when Beast is back.

## Land targets (repo paths)

| Local (this pack) | Repo destination |
|---|---|
| `M42_HUB_MOCKUPS.md` | `research/M42_HUB_MOCKUPS.md` |
| `previews/m42_candidate_coach.png` | `research/previews/m42/m42_candidate_coach.png` |
| `previews/m42_candidate_fighter.png` | `research/previews/m42/m42_candidate_fighter.png` |
| `previews/m42_home_booked.png` | `research/previews/m42/m42_home_booked.png` |
| `previews/m42_fights_offers.png` | `research/previews/m42/m42_fights_offers.png` |
| `previews/m42_finance.png` | `research/previews/m42/m42_finance.png` |
| `previews/m42_option_b_timeline.png` | `research/previews/m42/m42_option_b_timeline.png` (optional Option B board) |
| `render_m42.py` | keep as research tool only — do **not** land into `Godot/scripts/` |

## What this is

Art-only Acceptance for TASK M42: five 1920×1080 hub mocks + redline spec + Option A/B paper choice. No `.gd`, no `.tscn`, no commits from this pack.

## What to do on Beast

```bash
git fetch origin && git rebase origin/master
mkdir -p research/previews/m42
cp /path/to/fightcamp-m42/M42_HUB_MOCKUPS.md research/
cp /path/to/fightcamp-m42/previews/*.png research/previews/m42/
# do not copy render_m42.py into Godot/scripts
```

## Do not

- Edit UIKit / panels from this note (pictures + MD only).
- Treat EXAMPLE strings as final copy (Kalli).
- Ship Option B as the EA spine — MD recommends Option A; B is a pitch direction.
- Reuse GO green for Accept (GOLD only for one primary per board).

## Depends on / blocked by

- J62 / K86 not landed at write time — re-check field order when they arrive.
- Live 3D gym replaces the stylized `gym_floor_stage` stand-in (M41 tree).

## Acceptance checklist

- [x] Five PNGs at exactly 1920×1080
- [x] `M42_HUB_MOCKUPS.md` with redlines + Option A + Option B + first-hour table
- [x] Guide dock never covers candidate buttons
- [x] Attributes on stated 0–100 scale with band colour AND band word
- [x] One GOLD primary per board; Continue is the only GO
