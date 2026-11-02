# Ziva playtest log - S237 (operator: "use ziva to playtest the game", "ask step by step correction from the beginning")

Ziva plugin in E:/FightCamp/wt/ZIVA, editor visible on the Samsung (operator: "run it on the other monitor so i can watch it", "on samsung
monitor"). Each step = `python Tools/ziva_mcp.py run_scene E:/FightCamp/tmp/ziva_play/stepN.json` (the game from boot + a growing input list;
a still + the delivery report + the console). Saves go to user://saves_ziva (fightcamp/dev/save_dir) - his real slots are never touched.

| # | Step | Found (as a management-sim player) | Fix | Commit |
|---|------|------------------------------------|-----|--------|
| 1 | Boot | Intro film plays, "click or press any key to skip" works; ~8.7 s from launch to first frame | - (watch) | - |
| 2 | Title | LAST SAVE card: "1 fighters" | plural | a979d672 |
| 3 | New career, slots full | Board says "pick one to replace" but every row offers LOAD; note line cut off; footer build stamp says S151 vs v0.80 | REPLACE label, shorter note | a979d672 |
| 3b | - | A scripted playtest would overwrite his real save slot 1 | saves_ziva dir via fightcamp/dev/save_dir | (GameState) |
| 4 | New career -> country | **9-12 s freeze**: a full 3D club (~1,180 nodes) was built behind the globe that covers it | club built only on the city step: 11.8 s -> 2.3 s | S237 creation commit |
| 5 | Market list | The globe sat ON the list (Albania/Algeria half hidden), its hint over the cards | globe right of the open list | S237 |
| 6 | Search "Arg" + Enter | Works: globe turns, Argentina card fills. "1 HUBS" plural | plural | S237 |
| 6b | Market card | "Top 5 boxers now": #1 is 8-8-0, #5 is 0-0-0 - not a believable national top five | OPEN - ranking rule question (design) | - |

Club build cost per screen that shows a gym (profile `-- profile_build`): building/rooms ~1.65 s, GymLook2 dressing 1.0-1.65 s, zones
0.65 s, base 0.25-0.5 s = ~4-5 s; only ~1.4 s is file loading. Follow-up: make the room modules and the dressing cheap (rooms = Codex's
area), then one shared club per session.

Ziva harness trap: a `key` input with `target` set paused the game in the editor debugger at ziva_input_harness.gd:793 (no frame captured).
Click the field with a `target` input, then send keys without `target`.
