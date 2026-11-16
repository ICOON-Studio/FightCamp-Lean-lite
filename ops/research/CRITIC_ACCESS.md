# What a critic can open (S403)

Operator S403: "giveaccess to miro board for the critics and everything else required" (S499: the board is now our own map page). Read `ops/research/CRITIC_PACK.md` first, then use whatever here helps. All of it is read-only for a critic: change nothing.

## The map (S499: our own page, Miro is no longer used)
The owner's map is http://127.0.0.1:8787/map. A critic reads it from its files, no browser and no Miro tool needed:
- `ops/AgentComms/map/frames.json`: every frame on the map (rows, titles, which pictures each shows as file globs).
- `ops/AgentComms/map/notes.json`: the owner's sticky notes (`who: operator`), each with the frame it sits on. Read them all.
- Where we are (done, now, next): `python ops/Tools/where_we_are.py` prints the cards.

| Frame id | What it holds | Files |
|---|---|---|
| screens | Every screen as the game draws it today | `E:/FightCamp/critic_pack/screens/*_real.png` |
| menus402 / painted402 | Menus final (S402): layouts and Ludo's painted art | `docs/mockups/s402/*.png`, `docs/mockups/concepts/S402_*.png` |
| menus401 / painted401 | The earlier round | `docs/mockups/s401/*.png`, `docs/mockups/concepts/S401_*.png` |
| where | What is done, being worked on, and next | roadmap.json `plan.map` |

The old Miro board (MENUS FINAL, MECHANICS LIST, the owner's stickies up to S498) is a view-only archive; what could be copied
from it is in `ops/AgentComms/map/miro_export.json` (empty until Miro allows a read: see `ops/research/MIRO_EXPORT_S499.md`).

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
Every menu is filled with the same eight MMA fighters so the screens are ready before the MMA release: `docs/mockups/s403/roster_mma8.json`, rules in `docs/mockups/s403/MOCKUP_RULES.md`. Grey with a reason means not usable right now; full colour with the warning triangle means not built yet, drawn as it will work. Check a screen against the fighters who stress it most.

## How to judge a screen
Say which options it is missing, which ones are useless, and what each option changes in the game. Open images with the file tool only: never start an app or a window on the owner's monitors, and never run Godot.
