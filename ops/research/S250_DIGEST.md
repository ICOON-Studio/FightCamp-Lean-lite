# S250 digest (2026-10-18) - FIGHTLINK step 2: punch mastery in the game

## Operator answers acted on
- Q-S249-1 "Delete them" (333 agent branches fully on master): NOT done. The batched `git push origin --delete` and a fresh
  `git fetch --prune` were both refused by the session's permission classifier. Needs the operator to allow it (or run the deletion).
- Q-S248-2 "i raised to 50": the Actions hard stop is now $50/month (memory reference_actions_budget updated).

## What now works (pushed)
- FIGHTLINK2 COLLECTED 6c5ad2ff (Arena #255, fast lane): rules/MoveMastery.gd + tests/move_mastery_test.gd (MOVE_MASTERY failures=0).
- FIGHTLINK step 2 WIRED bd50b9fb behind `move_mastery` (GAME_ON + DEMO_SWITCHES, boxing only):
  - rules/MasteryTraining.gd: Ludo r115's station -> punch matrix; a station's minutes drill every punch it covers; gain via
    MoveMastery.gain to the technique + fight_iq cap. Mastery is stored on `athlete.move_mastery`. It is NOT stored in
    `technique_progress`, because that map gates learning and the palette.
  - GameState.file_visit applies the club day.
  - FightRealtime applies each punch's effects at BASELINE attributes: technique and speed already act on the ladder and the force,
    so no double count. The effects are: commit window x recovery, force x power, whiff chance + 0.20 x (telegraph - 0.5), drain x stamina.
    The log carries `mastery_note` away from USABLE.
  - No new RNG draw. USABLE 45 = today's bout, punch for punch.
  - Gate tests/mastery_wire_test.gd went 4 -> 0 failures:
    - 5 pad days take the jab from M45 to M48.2; the uppercut is untouched.
    - Jab family RAW M18: 38.3% connect, 8.2% slipped. SHARP M80: 44.2% connect, 5.2% slipped (20 bouts each).
  - Regression, 15 tests green: game_switches (engine-key list + move_mastery), fightlink_wire, boxing_output, jab_share,
    area_wear_persist, career_mornings_path, coach_day_drawer, floor_gain, game_training_split, station_wear_day, station_wear_risk,
    fight_identity, certified_palette, move_mastery, mastery_wire.
  - Not wired yet: windup (the engine has no windup phase), select_mult (Moves.select), weekly decay.
- Ludo r116 COLLECTED:
  - The first ask came back as only a mockup image (saved LUDO_R116_postfight_mock.webp; its text is unreadable). It was re-asked TEXT ONLY.
  - Part A + B1 + start of B2: 22,504 chars. B2 continuation: 21,966 chars.
  - Verdict FIGHTLINK_WEAR_VERDICT_S250.md -> board Q-S249-2.
- Ludo r117 COLLECTED (the operator's corner-shout idea): 25,919 + 10,543 chars.
  - Verdict CORNER_SHOUTS_VERDICT_S250.md -> board Q-S249-3: 12 learned shouts, execution roll, 25 s rhythm, 4 live reads.
  - Cut: crit lever, counter-shout window, audio.
- TASK_FIGHTLINK4A (FightWhy + CornerLines pure modules from r116 Part B) -> Arena, running:
  https://arena.ai/agent/01a14cda-c010-7959-83a5-f067a8e1ed7f
- TASK_TPMSCREEN1 got its Contract + VISUAL GATE blocks (start's two defects cleared).
- Pagefile check after the reboot (05:09): E:\pagefile.sys 32 GB allocated (this is why E: free fell 113.6 -> 70.8 GB).
  Commit limit is 78.8 GB now and grows to ~95 GB as the E: pagefile expands to 48 GB.

## Ziva playtest - not done, and why
- wt/ZIVA was fast-forwarded a3a35897 -> bd50b9fb (5,145 editor-made dirty files kept), and the editor was started on the hidden desktop.
- run_scene on BootRoot captures fine (371 frames in 8 s).
- FightWorldLive.tscn never draws a frame inside the Hobby plan's 30 s cap, twice. Its `_ready()` runs `setup()` synchronously and
  loads both bodies + clips. This is a property of that measurement room, not a FIGHTLINK defect.
- The editor was stopped by PID. Next time: playtest a bout through record_room as_game.

## Lessons
- PowerShell 5.1 + a here-string commit message with inner double quotes splits the argument list. Use `git commit -F <file>`.
- Ask Ludo: the right-most button in the box's 5th ancestor is "Start New Chat", not send. Click send by its coordinate from a fresh screenshot.
- An ask that asks for mockups gets an image-only answer. Ask TEXT ONLY, and ask for images separately.

## Next (roadmap now)
1. Collect FIGHTLINK4A and wire FightWhy -> FightCausation (recalibrate the consts on real bouts) and CornerLines -> the corner minute.
2. The board answers on wear (Q-S249-2) and shouts (Q-S249-3).
3. Profile repertoire grid (Cursor).
4. Mastery select_mult + weekly decay.

## HANDOVER
Working commit bd50b9fb (+ this digest). In flight: Arena FIGHTLINK4A. Board: Q-S249-2, Q-S249-3 open; Q-S249-1 needs a permission.
