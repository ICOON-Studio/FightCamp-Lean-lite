# CLAUDE_LAND_NOTE: HUD2 (no top bar), art direction pack

**Owner:** Maria (art direction) · **Date:** 2026-10-09 (Nicosia) · **Task:** TASK_HUD2_VARIANTS (S185)
**Status:** art direction only. **No code claim**: no .gd, .tscn, HANDOFF.md or game file was touched, and nothing was committed or pushed. Files were only added (untracked).

## Exact paths (repo root = C:\Users\user\OneDrive\Documents\ChatGPT\Game)
| File | Repo path | Delivery copy |
|---|---|---|
| Style sheet | `research/HUD2_STYLE.md` | `_maria_delivery/hud2/HUD2_STYLE.md` |
| Three directions | `research/HUD2_DIRECTIONS.md` | `_maria_delivery/hud2/HUD2_DIRECTIONS.md` |
| Placement table (every item → zone, Lucide icon, EXAMPLE tooltip) | `research/HUD2_PLACEMENT.md` | `_maria_delivery/hud2/HUD2_PLACEMENT.md` |
| Concept A, fight-poster brass | `research/previews/hud2/hud2_A.png` | `_maria_delivery/hud2/hud2_A.png` |
| Concept B, clean broadcast | `research/previews/hud2/hud2_B.png` | `_maria_delivery/hud2/hud2_B.png` |
| Concept C, gym chalkboard / corner card | `research/previews/hud2/hud2_C.png` | `_maria_delivery/hud2/hud2_C.png` |
| This note | `research/CLAUDE_LAND_NOTE_HUD2.md` | `_maria_delivery/CLAUDE_LAND_NOTE_HUD2.md` |

- PNGs are 1920×1080, built as HTML with the repo's own Lucide SVGs over a blurred `previews/ui_s184/bg_clean.jpg`. `docs/previews/s185_bout_walk/22_deadend.png`, named in the task, does not exist.
- Tokens are taken from `ui_s184/A_top_bar.html`, which is untracked.
- All strings are EXAMPLE (Kalli owns words).

## What Claude should do
1. Land (git add + commit on your branch, your call) or simply acknowledge the pack.
2. **Wait for the operator to pick a HUD direction.** Maria recommends **A as the base**, with **B's lower-third for fight week only** and **C's chalkboard as an optional skin for the objective stack**.
3. After the pick, write the implementation task yourself. This pack's placement table is the item list.

## Out of scope
- Any implementation (no Godot scenes or scripts from this pack).
- **Icon additions.** The repo Lucide set (`Godot/assets/icons/lucide/`, 93 SVGs) has no `mail`, `smartphone`, `menu` or towel glyph. The mocks use `bell` for MAIL and `hand` for the corner. Adding glyphs is a separate art request.

## NOT VERIFIED
- The action-ring glyphs.
- Tabular figures in Bebas Neue.
- Godot parity for the backdrop blur.
- The canonical brass: `#c9a24a` (A HTML) or `#c9a15a` (`ShellChrome.A_BRASS`).
