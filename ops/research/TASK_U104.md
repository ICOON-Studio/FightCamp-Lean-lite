# TASK U104 — CURSOR — THE "BEFORE" SHOT: A LANDED JAB IN TODAY'S LIVE ROOM, CUT BESIDE THE SCRIPTED PAIR

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u104-before-shot` (Claude creates it from `master`
before launch - do not switch branches). Push the BRANCH. Stage: S4a (THE MOVE SCRIPT).

**Test tier: DEV TOOLS ONLY** (`tools/` is not shipped). Parse gate on the `.gd` files, the runs below, then
`U104_check.py`. No suite.

## Owned files (these only)

- `Godot/tools/find_moment.gd` - NEW, `extends SceneTree`, headless, engine only.
- `Godot/tools/watch_live_room.gd` - EDIT: one new argument, `mark_s=<engine seconds>` (below). Nothing else changes.
- `Tools/compare_moment.py` - NEW: cuts two recordings around their contact frames and puts them side by side.

## Why this exists

The operator judges animation by eye, on the same picture, before and after (standing rule). Claude has authored the
first scripted exchange - a jab landing on the head, both fighters on one clock, authored in Blender - and your U103
viewer plays it. The operator must see it beside what the live room does TODAY for the same exchange: a landed jab to
the head, same two meshes (f01 gloved throws, f09 bare receives - `bare` in `watch_live_room.gd`), same camera style,
cut at the same instant - the moment of contact.

## `tools/find_moment.gd`

`-- seeds=94301,51227,77003,810039 first=3`
Drive the bout EXACTLY as the room does, without the room: read `Godot/tools/find_watch_seed.gd` (whole, it is short)
and `Godot/scripts/FightWorldLiveScreen.gd` lines 369-383 (the `_adapter.begin` options), 432-448 (`_pump_to`) and
915-975 (`demo_fighter`, `_fighter`); build both men exactly as the room's `_fighter(side)` does, with the boxing ruleset's `round_seconds` / `rest_seconds`,
`beat_ticks 1`, `FightBeatAdapter.begin` / `advance_beat`. For every action beat record `impact_s = tick / hz`,
`actor_side`, `technique`, `contact`, `target_region`. A MOMENT is an action beat with `technique == "boxing_jab"`,
`actor_side == "a"`, `contact` in `["clean", "glancing", "absorbed"]`, `target_region == "head_neck"`, and NO other
action beat by either man from 1.5 s before its impact to 1.5 s after. Print
`MOMENT seed=%d impact_s=%.2f round=%d contact=%s` for the first `first` per seed, then `MOMENTS_DONE`.

## `watch_live_room.gd`: `mark_s=<seconds>`

With `mark_s`, print `MOMENT_FRAME frame=%d show_s=%.3f` ONCE, on the first rendered frame (count frames from 0 in
`_process`) whose room clock `presented_seconds()` has reached `mark_s` (the room exposes it). Nothing else changes; without
`mark_s` the tool behaves byte-for-byte as before.

## `Tools/compare_moment.py`

`python Tools/compare_moment.py --before <room.avi> --before-frame <N> --after <pair.avi> --after-frame <M> --out <stem> [--half 1.5]`
Both inputs are 30 fps Movie Maker recordings. Cut each to `[contact - half, contact + half]` (frames), scale both to 720
px high, put them side by side (before on the LEFT), label the top `NOW: live room` and `SCRIPTED PAIR`, burn a clock
`t = -1.50 s ... +1.50 s` relative to contact under both, write `<stem>.mp4` (OpenCV `mp4v`) and `<stem>_sheet.png`
(a 2 x 5 grid: both sides at -0.30, -0.15, 0, +0.15, +0.30 s). Print `COMPARE frames=%d out=<stem>.mp4`.

## Gate, in order (Godot only through the wrapper `C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py`)

1. `python Godot/tools/check_scripts.py Godot/tools/find_moment.gd Godot/tools/watch_live_room.gd`
2. `godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tools/find_moment.gd --timeout 1200 -- seeds=94301,51227,77003,810039 first=3`
   -> save the log as `C:/Users/user/AppData/Local/Temp/u104_find.log`.
3. Pick the EARLIEST moment in any seed. Record the room with the windowed exe (never piped into PowerShell; redirect to
   a file): `Godot_v4.7.2-stable_win64.exe --path Godot --write-movie C:/Users/user/AppData/Local/Temp/u104_room.avi
   --fixed-fps 30 --quit-after <frames> --script tools/watch_live_room.gd -- seed=<seed> bare mark_s=<impact_s>` with
   `<frames> = 30 * (impact_s + 6)` (the walk-in takes about 3.3 s) -> log `C:/Users/user/AppData/Local/Temp/u104_room.log`.
4. Record the fixture pair with your U103 viewer: `... --write-movie C:/Users/user/AppData/Local/Temp/u104_pair.avi
   --fixed-fps 30 --quit-after 75 --script tools/watch_pair.gd -- pair=C:/Users/user/AppData/Local/Temp/u103_pair.json lead=0.8 tail=0.8`;
   its contact frame is `round(30 * (0.8 + contact_s))` with `contact_s` from that JSON.
5. `python Tools/compare_moment.py --before C:/Users/user/AppData/Local/Temp/u104_room.avi --before-frame <MOMENT_FRAME> --after C:/Users/user/AppData/Local/Temp/u104_pair.avi --after-frame <contact frame> --out C:/Users/user/AppData/Local/Temp/u104_compare`
6. OPEN `u104_compare_sheet.png` yourself and look: on the LEFT, at t = 0, does the thrower's jab reach toward the other
   man? If not, the MOMENT_FRAME is wrong - fix before sending.
7. `python research/U104_check.py C:/Users/user/AppData/Local/Temp/u104_find.log C:/Users/user/AppData/Local/Temp/u104_room.log C:/Users/user/AppData/Local/Temp/u104_compare.mp4`
   must print `U104_CHECK PASS`. **If it cannot, do not commit: send `U104 BLOCKED` with its FAIL lines.** Never edit the check.

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the three owned files with their paths on the commit
line, `git show --stat HEAD`, `git push -u origin cursor/u104-before-shot`, then
`python Tools/agent_comms.py send --from cursor --to claude --topic "U104 ready" --body "<the U104_CHECK line; the seed, impact_s and MOMENT_FRAME you used; what the sheet shows at t=0>"`.
Do not commit videos or logs. Do not edit HANDOFF.md or AgentComms/roadmap.json.

## The trap

The room's clock and the video's frames are different clocks: the walk-in plays before the fight starts, the engine is
pumped AHEAD of the picture, and a thrower's clip starts BEFORE the impact tick by its lead. `presented_seconds()` is the
room's own show clock - key the frame to it, never to `impact_s * 30 + a guessed walk-in`.
