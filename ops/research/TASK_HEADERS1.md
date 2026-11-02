# TASK HEADERS1 - census: which player-visible headers have no mechanic behind them (S198)

## Owned files
- `research/HEADERS1_CENSUS.md`

Model: Qwen (qwen3-coder) - READ-ONLY census, one report file, no game code changed.
Worktree E:/FightCamp/wt/NIGHTLY2 (reuse it). NEW branch qwen/headers1 from master:
`git fetch && git checkout -b qwen/headers1 origin/master`.

Operator S198 board answer (Q-S196-3, verbatim): "approve all and check if we have any headers that are not wired to mechanics
and ask ludo how to implement as mechanics". Claude takes your list to Ludo; you only build the list.

## Prior research
`python Tools/prior_research.py header placeholder dock route` -> research/K_HUD2_KALLI.md (live SceneRouter.ROUTES,
ShellChrome.RAIL_GROUPS census, 2026-10-02), M32_MENU_ART_DIRECTION.md, TELEVISED_MMA_GAP_ASSESSMENT.md (route tiers).
Read K_HUD2_KALLI.md's route table first - your census replaces it for "is it wired", it does not redo the look.

## What would a human do?
A QA lead walks every menu, tab, dock icon, panel title and stat label the player can reach, and for each one asks: if I use it,
does a number in the save change, or does it show a number the simulation really computes? Anything that is only text, a
fixed/hard-coded value, a "coming soon", an empty list, or a button that does nothing is UNWIRED.

## Prefab check
None needed - this is a census of our own code.

## What to census (source files, read in windows with sed -n, never GameState.gd / FightRealtime.gd whole)
1. Godot/scripts/SceneRouter.gd `ROUTES` - every route id.
2. Godot/scripts/ShellChrome.gd `RAIL_GROUPS`, and the HUD2 dock / top time bar (grep `hud2` in Godot/scripts; files under
   Godot/scripts/hud2/ if present) - every icon / tab / button.
3. Every `_build_header(`, `_section(`, `header_bar(`, `header_caption(`, `sort_header(` call in Godot/scripts (grep -rn) -
   the literal header text passed in.
4. Each drawer / panel title in the club (GymClub3D.gd, TrainingFloor3D.gd, club_zones/, FightWeekPanel.gd, FightCampPanel.gd).
5. Strings "coming soon", "COMING SOON", "placeholder", "TODO", "not yet" in Godot/scripts that reach a Label/Button text.

For each header decide WIRED / PARTIAL / UNWIRED with ONE line of evidence: the GameState (or rules/ module) function it reads or
writes (file:line), or why none exists (hard-coded literal at file:line, empty list, button with no pressed handler, switch OFF and
never ON as_game - check Godot/scripts/GameSwitches.gd or grep the switch name).

## Deliverable (the one file)
research/HEADERS1_CENSUS.md:
- a table: header text | where (file:line) | route/screen | WIRED/PARTIAL/UNWIRED | evidence (file:line) | what mechanic it implies
- then a list of ONLY the UNWIRED + PARTIAL rows, grouped by screen, each with one plain sentence "the player sees X but nothing
  computes Y".
- totals per verdict at the top. Expect 60-200 rows; do not stop at 20.

## Gate
`python -c "import re;t=open('research/HEADERS1_CENSUS.md',encoding='utf-8').read();n=len(re.findall(r'^\|.*\|(\s*(WIRED|PARTIAL|UNWIRED)\s*)\|',t,re.M));print('ROWS',n);assert n>=40"`
must print ROWS >= 40. Every evidence cell names a real file:line (Claude spot-checks 10).

## The one trap
Do NOT mark something WIRED because a function with a similar name exists - follow the actual call from the button/label to the
state it reads/writes. A label that shows GameState data but whose button only changes the label is PARTIAL.

Commit only HEADERS1_CENSUS.md on qwen/headers1, push; never master; open no windows, no images, no browser.
