# TASK C233 - build Kalli's K82: the training floor and the lobby look like their concept art (3D rooms, Codex)
Model: qwen3-coder (S138 reassigned: Codex is on C231B; Qwen built the S105-S111 rooms). Owner: Qwen. Worktree D:/FightCamp/wt/C233, branch qwen/c233-floor-lobby (from master).
Operator 2026-10-01: "use grokbots mostly for visual refining our rooms and the arena" (Kalli specified it; you build it),
"AAA game level". House rule: bright and alive, never dark or empty.

## The spec
`research/K82_FLOOR_LOBBY_TO_CONCEPT.md` (Kalli, S137) - ranked changes with sizes, positions and hex for each room,
plus "keep unchanged" lines. Concepts: `previews/concepts/gym_tier1_backroom_club.jpg`, `room_lobby.jpg`.
Today's renders: `previews/c225/final.png` (floor tier 1), `previews/s107/lobby.png`.
Kalli's own flag: she guessed room sizes (~10x8 m floor, ~8x6 m lobby) - READ the real sizes in the scripts first and
scale her numbers; keep the relationships.

- S138: the operator PICKED `Godot/assets/ui/bot_art/training_floor_look.jpg` (bot art #47) as the training floor's
  target look - read it beside Kalli's concept; where they disagree, the operator's pick wins.

## Owned files
- `Godot/scripts/TrainingFloor3D.gd` (`_build_environment` and the tier-1 dressing only; U204 added RoomFx dust/light -
  keep it) and `Godot/scripts/Lobby3D.gd`. Kenney kit pieces (`Godot/assets/models/props/kenney/`) where Kalli names one
  that exists; boxes/cylinders otherwise. New props never sit on a station's click area or a door.
- Kalli's floor item 2 ("pull the zone rectangles back", hover-only labels) touches the station overlay - do it only if
  the station still reads as clickable (hover shows it); say what you did.
- Lobby fight board: dates/venues come from real booked bouts (GameState), never fixed text (Kalli's own rule).
- Before/after stills of both rooms from the game camera (`Tools\godot_hidden.ps1`, the s105-s111 render tools) ->
  `previews/c233/`. OPEN THEM against the concept. NEW `research/C233_DIGEST.md` (each K82 item: done /
  adapted / skipped + why). Never edit HANDOFF.md.

## Tests
Parse gate; `python Godot/tools/run_tests.py --jobs 2 --only training_floor,lobby,gym_floor_layout,room,smoke,ui_fx`
(room tests count stations/doors - they must stay green). Watchdog before heavy runs.

## The one trap
Godot's first import in a fresh worktree rewrites thousands of .import files - never `git add -A`; add by explicit path.

## Finish
git add by explicit path, commit, git push -u origin codex/c233-floor-lobby. Do not stop at "written".
