# What a critic can open (S403)

Operator: "giveaccess to miro board for the critics and everything else required". Read `ops/research/CRITIC_PACK.md` first, then use whatever here helps. All of it is read-only for a critic: change nothing.

## The Miro board
https://miro.com/app/board/uXjVEV03QWA=/ (the only board; never uXjVETf7la4=, it is archived).
Load the tools with ToolSearch, all in one call: `select:mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__canvas_read_as_svg,mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__canvas_search,mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__comment_list_comments,mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__image_get_data`
Read a frame with `canvas_read_as_svg`, `widget_ids: ["<id>"]`. The owner's notes are both yellow stickies and comments, so read comments too with `comment_list_comments`.

| Frame | Id | What it holds |
|---|---|---|
| MENUS FINAL (S402) | 3458764689777613662 | 17 menus: layout, Ludo's painted art, the owner's stickies |
| PAINTED MENUS (S401) | 3458764689772257568 | Painted version of each menu |
| MENUS FOR YOUR OK (S401) | 3458764689771007533 | The earlier round, with the owner's notes |
| MECHANICS LIST (S401) | 3458764689772104154 | 103 candidate mechanics and the owner's notes |
| P0 Where we are | 3458764689579200297 | What is done, being worked on, and next |

Some frames carry earlier critics' scores. Ignore them and reach your own verdict: they are there for the owner, not for you.

## The real game and the plans
- Real screens as the game draws them today, 1920x1080: `E:/FightCamp/critic_pack/screens/*_real.png`. Open them with the file tool.
- Approved menu layouts: `docs/mockups/s402/` (HTML and PNG), painted concepts: `docs/mockups/concepts/S402_*`, and `docs/mockups/s401/` for menus not redone in S402.
- The owner's answers to every design question: `ops/AgentComms/questions.json`.
- Design documents: `docs/GAME_BIBLE.md`, `docs/PLAYER_PATH.md`, `docs/STRUCTURE_DESIGN_S395.md`. In `ops/research/S400_REVIEW/` only YARDSTICK, MENU_STRUCTURE_S402, MECHANICS_DECISION_S402 and PRIMARY_ATTRIBUTES_S403: the rest carries earlier critics' scores.
- All code: `scripts/` (screens in `scripts/ui/areas` and `scripts/ui/modals`, rules in `scripts/rules`, game state in `scripts/state`). Never open `GameState.gd` or `FightRealtime.gd`.
- Research memory: `python ops/Tools/prior_research.py <terms>` lists what was already studied, `ops/research/`.
- Comparison games read from their files: the memory notes on Corner King and Two Point Museum, and `ops/research/TWOPOINT_ALIGNMENT.md`.

## The eight MMA fighters
Every menu is filled with the same eight MMA fighters so the screens are ready before the MMA release: `docs/mockups/s403/roster_mma8.json`, rules in `docs/mockups/s403/MOCKUP_RULES.md`. Grey means not usable right now, grey with the warning triangle means not built yet. Check a screen against the fighters who stress it most.

## How to judge a screen
Say which options it is missing, which ones are useless, and what each option changes in the game. Open images with the file tool only: never start an app or a window on the owner's monitors, and never run Godot.
