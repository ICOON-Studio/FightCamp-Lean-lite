# TASK U214 - the CREDITS board (title menu -> Credits), before the demo build

Model: Cline CLI, OpenRouter `stealth/space-bunny-alpha` (Tools/cline_task.cmd). Worktree: E:\FightCamp\wt\CLINE, branch cline/seat.
Tier: new script + small edits to 4 scripts -> parse gate, the new test, then the boot/router tests below.

## Why
The demo .exe ships a CC BY 4.0 boxing glove. CC BY REQUIRES a visible author credit. The game has no credits screen.
Fonts (SIL OFL 1.1), Lucide icons (ISC), flag-icons (MIT), Kenney props (CC0) and the Kickback addon also belong on it.

## Prior research
`python Tools/prior_research.py credits screen licence` returned no credits-screen study (M32 is menu look, J40 audio licences).
Existing credit sources (READ these, copy their facts, do not invent any):
- Godot/assets/models/gloves/CREDITS.md - the CC BY glove (author Incg5764, base by Gohar.Munir, links, changes made)
- Godot/assets/icons/CREDITS.md - Lucide + flag-icons
- Godot/assets/fonts/SOURCE.md + Inter-OFL.txt - fonts
- Godot/assets/models/props/kenney/LICENSE_Kenney_Furniture_Kit_CC0.txt
- Godot/addons/kickback/LICENSE
- Godot/assets/anim/**/SOURCE.md - list a credit ONLY if the SOURCE.md names a third-party author/licence that requires it.

## What would a human do?
A studio adds a "Credits" button on the title menu that opens a scrolling list: the team, then "Third-party assets", one entry
per asset: name, author, licence name, licence link, "changes made" where CC BY asks for it. Plain, readable, no animation.

## Prefab check
Godot has no built-in credits node. Reuse the game's own board system (BootRoot BOARDS + BootChrome BOARD_TITLES), the way
Settings is done. No new library.

## Spec
1. NEW `Godot/assets/data/credits.json`: `{"sections": [{"title": "...", "entries": [{"name", "author", "licence", "url", "note"}]}]}`.
   Sections: "FightCamp" (one entry: "Made by FightCamp Dev"), "Third-party assets" (glove, Lucide, flag-icons, Inter, Bebas/Oswald,
   IBM Plex Mono, Kenney Furniture Kit, Kickback addon, any anim SOURCE.md that requires credit). Facts copied from the files above.
2. NEW `Godot/scripts/CreditsBoardPanel.gd` - modelled on SettingsBoardPanel.gd (301 lines; read it whole, it is the template):
   a ScrollContainer of sections; section title in the gold caps style, each entry: name (bold), "author - licence", url, note.
   Reads credits.json with FileAccess; a missing/broken file shows "Credits file missing" (never a blank board).
3. `Godot/scripts/BootRoot.gd` (474 lines) - add `"credits": {"panel": "res://scripts/CreditsBoardPanel.gd"}` to BOARDS (line ~42).
4. `Godot/scripts/BootChrome.gd` (150 lines) - add a "credits" entry to BOARD_TITLES (lines ~40-65): title "CREDITS",
   sub "THE PEOPLE AND THE ASSETS", cue "", back true.
5. `Godot/scripts/SceneRouter.gd` (452 lines) - add `"boot_credits": {"tier": "boot", "scene": BOOT_ROOT_SCENE, "board": "credits", "label": "CREDITS"}`
   after "boot_settings" (line ~52).
6. `Godot/scripts/TitleBoardPanel.gd` (420 lines) - a "Credits" button between Settings and Quit (lines ~232-242), same
   `_a_button(...)` call as Settings, name "CreditsBoard", opens `_open_board("credits", {})`.
7. NEW `Godot/tests/credits_board_test.gd`: (a) credits.json parses and has >= 2 sections; (b) an entry whose licence contains
   "CC BY" exists AND its author is "Incg5764" (read from the json - the test must FAIL if the glove entry is removed);
   (c) every entry has non-empty name, author, licence; (d) CreditsBoardPanel mounts headless and contains a Label whose text
   contains "Incg5764"; (e) SceneRouter ROUTES has "boot_credits" with board "credits".

## Owned files
NEW: assets/data/credits.json, scripts/CreditsBoardPanel.gd, tests/credits_board_test.gd.
EDIT (only the anchors above): scripts/BootRoot.gd, scripts/BootChrome.gd, scripts/SceneRouter.gd, scripts/TitleBoardPanel.gd,
and tests/scene_router_test.gd ONLY if it lists boot routes exhaustively (add "boot_credits" there; change nothing else).

## Gates (run from E:\FightCamp\wt\CLINE)
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/CreditsBoardPanel.gd Godot/scripts/BootRoot.gd Godot/scripts/BootChrome.gd Godot/scripts/SceneRouter.gd Godot/scripts/TitleBoardPanel.gd Godot/tests/credits_board_test.gd`
  A parse error HANGS a headless test - parse first, always.
- The test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/credits_board_test.gd`
  Pass = exit 0 AND no "SCRIPT ERROR" AND no "FAIL" line.
- Then: `python Godot/tools/run_tests.py --only credits_board,boot_panels,boot_root,scene_router,smoke_test --jobs 2` -> fails=0.
- Commit on branch cline/seat with message "U214: credits board". Do NOT push to master, do NOT merge.

## Rules
- Work ONLY inside E:\FightCamp\wt\CLINE. Never open images or videos with an app (no start/explorer/browser).
- Never read GameState.gd or UIKit.gd whole (17k / 8.5k lines) - you do not need them; use `grep -n` if you must.
- GDScript traps: `var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`); a variable name reused
  in one function is a parse error; `%` in a format string is `%%`.

## The one trap
`credits.json` must be packed into the exported .pck. Check `Godot/export_presets.cfg` include_filter covers `*.json` under
assets/data (it does for the other data files - confirm, do not edit unless missing).
