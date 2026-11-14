# TASK SOUNDWIRE2 - wire the 11 sounds the operator kept (boards S473 + S474) (clinch, corner minute, pads, gym room tone)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Seat role: sound engineer.

## Why now
Operator comment C401 (S474) kept 8 of the 30 S473 Ludo sounds. assets/audio/sounds.json already marks them
`heard: true, verdict: keep` (files section) but NO event plays them yet. Kept files (sounds.json "files" keys):
- clinch_grapple: assets/audio/fight/clinch_grapple_3.ogg
- corner_stool: assets/audio/fight/corner_stool_3.ogg
- corner_towel: assets/audio/fight/corner_towel_3.ogg
- corner_water_spray: assets/audio/fight/corner_water_spray_2.ogg
- gym_ambience_loop: assets/audio/gym/gym_ambience_loop_3.ogg (a loop)
- pads_mitt_combo: assets/audio/gym/pads_mitt_combo_2.ogg
- pads_mitt_power: assets/audio/gym/pads_mitt_power_1.ogg and pads_mitt_power_3.ogg (two takes, the event picks either)
Kept later the same day from the redo board (operator "2,6,8"):
- clinch_break: assets/audio/fight/clinch_break_5.ogg
- pads_coach_clap: assets/audio/gym/pads_coach_clap_6.ogg
- pads_mitt_jab: assets/audio/gym/pads_mitt_jab_5.ogg
Every other clinch_break / pads_coach_clap / pads_mitt_jab file is dropped: do not wire it.

## What to do
1. sounds.json "events": add one event per id above, same keys as the existing events (bus, group, kind, tier, files as
   res:// paths, volume_db, pitch, volume_spread, pre_fire_s, loop, priority). Buses: fight sounds "SFX"; gym_ambience_loop
   "Ambience" if that bus exists in default_bus_layout.tres, else "SFX"; loop true only for gym_ambience_loop. Volumes:
   set each so its loudness lands near the kept punch sounds (use the file's lufs in sounds.json; target about -18 LUFS
   after volume_db, never above +6 dB).
2. Import sidecars: each kept .ogg needs its `.ogg.import` committed (tests/sound_bank_test.gd checks it). Produce them
   with one headless import in YOUR worktree: `<godot> --headless --path . --import` through godot_slot (it is heavy:
   only once, PC GREEN). Commit only the 11 new `.ogg.import` files, nothing else the import touches.
3. Hooks (docs/audio/FIGHT_HOOKS.md "Not wired" table names the places; update that table: move the wired rows up):
   - clinch_grapple: scripts/fight3d/BeatFire.gd `fire`, right after `stage.clinch.start(...)` -> a new
     `FightSfx.clinch()` that plays "clinch_grapple"; where the referee parts them (grep `clinch.stop` / `break` in
     scripts/fight3d/BeatFire.gd and Clinch*.gd) a `FightSfx.clinch_break()` that plays "clinch_break".
   - corner minute: scripts/audio/FightSfx.gd `corner_minute(start)`: on start play "corner_stool" at once,
     "corner_water_spray" with {"delay": 6.0}, "corner_towel" with {"delay": 14.0} (Sfx.play takes {"delay": s}).
   - pads: scripts/fight3d/PadWork.gd `_pop_mitt(i)`: play "pads_mitt_jab" for a jab, "pads_mitt_power" for a cross, hook
     or uppercut, and "pads_mitt_combo" at most once every 3 s on the first pop of a combination; "pads_coach_clap" when a
     new drill starts (grep the drill change in PadWork.gd) (read how _pop_mitt knows the punch; if it does not, play
     "pads_mitt_power" for every pop and say so in the PR body).
   - gym room tone: start "gym_ambience_loop" when a gym screen opens and stop it when the fight view opens. Find the one
     place screens switch (grep `func show_area` / `func go(` in scripts/ui/Main*.gd); if there is no single place, wire only
     the Home screen and say so.
4. tests/sound_bank_test.gd: add the 10 new event ids with their kept files to its FINAL set (pads_mitt_power has two files:
   check it plays exactly those two). Never weaken an existing check.

## Pass lines
RESULT: tests/sound_bank_test.gd -> SOUND_BANK checks=<n> failures=0

## Contract
OWNS: assets/audio/sounds.json, assets/audio/fight/clinch_grapple_3.ogg.import, assets/audio/fight/corner_stool_3.ogg.import, assets/audio/fight/corner_towel_3.ogg.import, assets/audio/fight/corner_water_spray_2.ogg.import, assets/audio/gym/gym_ambience_loop_3.ogg.import, assets/audio/gym/pads_mitt_combo_2.ogg.import, assets/audio/gym/pads_mitt_power_1.ogg.import, assets/audio/gym/pads_mitt_power_3.ogg.import, assets/audio/fight/clinch_break_5.ogg.import, assets/audio/gym/pads_coach_clap_6.ogg.import, assets/audio/gym/pads_mitt_jab_5.ogg.import, scripts/audio/FightSfx.gd, scripts/fight3d/BeatFire.gd, scripts/fight3d/PadWork.gd, tests/sound_bank_test.gd, docs/audio/FIGHT_HOOKS.md, scripts/ui/Main.gd
RED_TEST: tests/sound_bank_test.gd -> SOUND_BANK failures=0 (red once the 10 ids are in FINAL and not yet in sounds.json)
REGRESSION: tests/sound_bank_test.gd, tests/pad_view_test.gd, tests/corner_warm_test.gd (each unchanged and green)
VISUAL: no
NOT YOURS: every other file. No new sound is generated. Never `git add -A`; stage the files above by name.
Runs only through `python ops/Tools/godot_slot.py run --who soundwire2 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/<test>.gd`.
Never the _console exe, never a window, never wrapped in `timeout`. Every script stays under 500 lines. Read
ops/research/GDSCRIPT_TRAPS.md first.

## Prior research
docs/audio/FIGHT_HOOKS.md (where each sound goes), docs/audio/SOUND_LIST.md, scripts/audio/Sfx.gd (play options),
memory: every sound unheard until the operator keeps it (all 8 here are kept, C401).
## What would a human do?
A sound designer drops each approved take onto its moment and checks the levels against the punches already in.
## Prefab check
None: the sounds are ours (Ludo, his Pro plan).
