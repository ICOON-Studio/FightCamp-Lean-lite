# TASK PLAYUI1 - the camp setup screen: no bleed-through, nothing cut off (S187 playtest D3)

Model: Cursor (Godot UI). Worktree E:/FightCamp/wt/PLAYUI1, branch cursor/playui1 (from master). Commit + push the branch; never master.
NEVER open a window, image viewer or browser on the operator's screens. Godot only through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>` (hidden desktop) or the NON-console exe headless.
Read your stills with your file tool only.

## The defect (operator's own playtest stills, open them first)
`previews/s187_play_a/50_technical_flow.png` and `52_camp_started.png` (1920x1080, the game camera):
1. The screen BEHIND the camp board shows through: a ghost "BASTIEN TORRES" across the middle, a ghost "START A CAMP" button at the
   bottom centre, faint text behind the right column. The camp board must be fully opaque over whatever opened it.
2. The top-right Continue button and the bottom-right GUIDE pill are cut in half by the board's right edge (x ~1730).
3. Card texts are truncated: "STAMINA DISCOUNT +4%/WK (CAP 12%) · ROU...", "DEFENSE BONUS +2%/WK (CAP 5%) · HEAD · D...",
   "PAST THE SAFE LINE, IT WILL COST ON" (right column runs off), "SOUTHPAW. BOX BEHIND THE JAB, ..." under an icon.
   Every sentence must be readable in full: wrap to a second line or shorten the words - never clip.
4. Two titles say the same thing: the chrome "CAMP SETUP" and the panel's own "FIGHT CAMP" header. Keep one.
(Already fixed on master by Claude, do not redo: the chrome footer phase word and the clock sub-label.)

## Owned files
- `Godot/scripts/FightCampPanel.gd` (1751 lines) - the board; layout constants at the top, `_build` ~line 200-560.
- `Godot/scripts/ProfileRevampPanel.gd` - ONLY `_camp_frame()` (~line 3651) and the code that mounts the camp panel
  (`rg -n "FightCampPanel|_mount_panel" Godot/scripts/ProfileRevampPanel.gd`). Never read this file whole (big).

## How to see it
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- as_game hud2 plan=res://research/s186_hud2_hover_rail.plan out=res://docs/previews/playui1`
-> stills `previews/playui1/47..52_*.png`. Shoot BEFORE (on the untouched branch) and AFTER, open both.

## Prior research
S187_PLAYTEST_UI.md (D3); CLAUDE.md s9 traps: full-rect Controls never assign size on mount; a Label outside a Container breaks lines
with `\n`; `remove_child` before `queue_free` on rebuilds.

## What would a human do?
Give the board an opaque full-screen backdrop, lay the three columns inside the 1920 safe width, and let each card's body autowrap.

## Prefab check
N/A - our own UIKit.

## Tests
Parse gate `python Godot/tools/check_scripts.py <file>` on each touched .gd, then
`python Godot/tools/run_tests.py --jobs 2 --only fight_camp` and `--only camp` (one --only per run; the last flag wins).

## Done =
Pushed branch; AFTER stills 50 and 52 show no ghost text, no cut button, no "..." or clipped sentence; the tests green;
your last message lists the before/after still paths.
