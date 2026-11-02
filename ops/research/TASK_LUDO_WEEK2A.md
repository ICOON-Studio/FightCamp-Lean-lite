# TASK LUDO-WEEK2A - the Mon-Sat fight week as six day cards in Ludo's gym screen (V6, D40; Ludo round-8 item 4, UI half)

Model: Cursor composer-2.5. Worktree E:/FightCamp/wt/LUDOWEEK2A, branch cursor/ludo-week2a from master (LUDO-GYMUI1 is merged:
9ab38483). Push the branch; never master. Never open a window, image viewer or browser; windowed Godot only via
`Tools\godot_hidden.ps1`; look at stills with your file tool.

Ludo's acceptance (round 8, `research/LUDO_ROUND8_NEXT_S191.md` ~line 30): "Advancing into Week 4 transitions the right HUD
panel into 6 daily cards; confirming Tuesday locks a permanent +15% power badge onto Leo's cross and dims his hook guard."
THIS TASK = the cards, the choices, the saved state and the Tuesday badge. What the choices DO inside the fight engine is WEEK2B
(Codex, later) - do not touch FightRealtime.

## Owned files
- `Godot/scripts/LudoGymHud.gd` (~500 lines) - the right rail `_rebuild_week` ~297 / `week_rows` ~312 / `_week_row` ~344.
- `Godot/scripts/state/GameFightWeek.gd` (NEW) - a small state helper (pattern: `Godot/scripts/state/GameMoney.gd`, SPLIT1):
  `is_fight_week(gs, athlete_id)`, `choice(gs, athlete_id, day_id)`, `choose(gs, athlete_id, day_id, choice_id, extra := {})`,
  storing under `gs.career["fight_week"][athlete_id] = {day_id: {choice, ...}}` (create keys on first write; never a new
  GameState field). Tuesday stores `FightWeek.apply_tuesday(lock_drill, sacrifice_vs)` and adds a permanent badge to the athlete:
  `athlete["fight_week_badges"]` append {"kind":"lock","drill":..,"speed_crit":0.15} and {"kind":"sacrifice","vs":..,"guard":-0.10}.
- `Godot/tests/ludo_week2a_test.gd` (NEW), `Godot/tools/ludo_gym_stills.gd` (extend: a `week4=1` arg puts the fighter in a camp's
  last week), `previews/ludo_week2a/*.png`.
- READ ONLY: `Godot/scripts/FightWeek.gd` (101 lines, read whole) + `Godot/assets/data/fight_week.json`, `Godot/scripts/WeighInCut.gd`
  (Friday's three options by id), `Godot/scripts/GameState.gd` (17k lines - NEVER read whole; `get_fight_camp` / camp `weeks` +
  `weeks_done` ~16320 give camp_week = weeks_done + 1).

## Prior research
- Design of record: `research/LUDO_ROUND4_S190.md` section A (the six days), approved D40 / V6 ("camp weeks 1-3 run our macro
  system, week 4 is Ludo's Mon-Sat fight week"). Weigh-in: `LUDO_CUT*` + WeighInCut.gd (V9). Tells at Thursday film: Tells.gd.
- UI rules: icons with tooltips (`UIKit.tip`, never tooltip_text), Labels outside Containers break lines with `\n`, full-rect Controls
  never get `size` on mount, `remove_child` before `queue_free` (CLAUDE.md s9).

## What would a human do?
When the fighter's camp reaches its last week, swap the right rail's plan list for six day cards (Mon..Sat) showing each day's title +
decision; today's card has its choice buttons; a picked card shows the pick; Tuesday asks for one weapon to lock and one defence to
sacrifice, then shows the two badges on the fighter.

## Spec
1. Only when `GameFightWeek.is_fight_week` (FightWeek.is_fight_week(camp_week, camp_weeks)) for the active fighter AND the
   `ludo_gym` switch is ON; otherwise the rail is unchanged (prove with a test).
2. Six cards (MON..SAT): title, mechanic word, one-line decision (text from fight_week.json), state done/today/locked like week_rows.
   Today's card shows its choices as buttons (Mon: 2, Wed: 2, Fri: the 3 WeighInCut options by id with their labels from
   weigh_in_cut.json; Thu: "Load tells" (coach 3 h); Sat: "Fight night" - no choice). Each button has a UIKit tip.
3. Tuesday: two pickers - LOCK one of the fighter's drilled weapons (his known techniques; jab/cross/hook ids are enough), SACRIFICE
   one of the opponent's secondary weapons (from the camp's opponent if known, else "hook"/"body" defaults). Confirm -> choose() +
   badges. The active fighter strip (bottom) shows the badges as two small icons with tips ("Cross locked: +15% speed/crit",
   "Hook guard -10%").
4. Choices persist (save/load: they live in career) and a done day is read-only.

## Done = (tier: script edited)
- Parse gate on every touched .gd.
- `ludo_week2a_test.gd`: switch OFF or not fight week -> the old rail; fight week -> 6 cards; Monday choose -> stored; Tuesday lock
  cross + sacrifice hook -> both badges on the athlete with 0.15 / -0.10 (numbers read from FightWeek, never typed); done day refuses
  a second choice. Write it RED first (paste the count).
- `python Godot/tools/run_tests.py --only ludo_gym --jobs 2`, `--only gym_hall --jobs 2`, `--only hud2 --jobs 2` -> 0 fails.
- Stills through `ludo_gym_stills.gd -- as_game gym3d_main gym4_club ludo_gym week4=1 out=docs/previews/ludo_week2a`:
  `01_monday.png` (6 cards, Monday's two buttons), `02_tuesday_locked.png` (after lock cross / sacrifice hook: badges visible),
  captured from the WINDOW (not the 3D subviewport - the GYMUI1 send-back). Open each with your file tool and list what you see.
Commit + push cursor/ludo-week2a. Final message: red count, green results, what each still shows.

## The one trap
The fight-week state lives in `career` via the new helper - do not add fields or functions to GameState.gd (it is being split; SPLIT1/2).
