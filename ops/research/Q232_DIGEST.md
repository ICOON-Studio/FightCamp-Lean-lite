# Q232 DIGEST - the eight gym rooms, bright and alive again (Qwen, S139)

Pass 2 (b0271915) gave every room real materials, props and people - and lit them all like an
evening. This pass lifts the whole building to one bright grade, measured, without losing the
pass-2 materials. Harness: `Godot/tools/q232_render.gd` (eight rooms, one still each, the same
cameras/fixtures q225/q227/q228/q229 used, club name "Nicosia Ironworks" so no task id lands on a
wall) and `Godot/tools/q232_luma.py` (mean L, share L<0.08, share L>0.97; the room-view column is
the 3D view inside the house shell, x 288..1920 / y 112..1080). Stills and sheets in
`previews/q232/` (`<room>_before.png`, `<room>_after.png`, `review_<room>_*.png`).

## BEFORE / AFTER (room view; whole-still in brackets)

| room   | before meanL / dark / clip | after meanL / dark / clip |
|--------|----------------------------|---------------------------|
| floor  | 0.203 / 25.6% / 0.00% (0.185 / 30.1%) | 0.261 / 3.4% / 0.00% (0.229 / 13.2%) |
| lobby  | 0.207 / 45.0% / 0.00% (0.188 / 44.9%) | 0.267 / 2.6% / 0.00% (0.233 / 12.6%) |
| office | 0.217 / 17.3% / 0.03% (0.196 / 23.8%) | 0.374 / 0.8% / 0.05% (0.314 / 11.3%) |
| locker | 0.272 / 45.0% / 0.01% (0.237 / 44.9%) | 0.366 / 0.5% / 0.40% (0.309 / 11.0%) |
| mat    | 0.272 / 27.7% / 0.00% (0.237 / 31.8%) | 0.346 / 3.4% / 0.00% (0.294 / 13.2%) |
| staff  | 0.323 / 20.3% / 0.00% (0.276 / 26.1%) | 0.410 / 4.6% / 0.05% (0.342 / 14.1%) |
| physio | 0.371 / 19.0% / 0.00% (0.312 / 25.1%) | 0.473 / 5.4% / 0.14% (0.391 / 14.7%) |
| film   | 0.256 / 14.9% / 0.20% (0.226 / 23.6%) | 0.368 / 6.4% / 0.89% (0.311 / 17.2%) |

Every room: mean luminance up, near-black share down, nothing clipped (worst 0.89%, gate is 2%).
Reference stills for calibration, whole-image meanL / dark: `training_floor_look.jpg` 0.262 / 9.4%,
`gym_with_ring.jpg` 0.394 / 1.8%, `gym_tier1_backroom_club.jpg` 0.328 / 2.8%, `room_lobby.jpg`
0.283 / 2.1%, `room_locker.jpg` 0.281 / 5.5%, `room_film.jpg` 0.159 / 34.0% (the dimmest target,
and even it is not dark). Our rooms now sit in that band.

## What changed, per script (line ranges as committed)

- `TrainingFloor3D.gd` - `_build_environment` 131-217: surround `background_color`
  (0.105,0.088,0.075) -> (0.17,0.145,0.125) - the concepts' corners measure L 0.12-0.14, ours
  rendered L 0.076, i.e. black; ambient 0.5 -> 0.62; exposure 1.12 -> 1.16; sun 1.7 -> 2.1 and
  recoloured (1.0,0.71,0.38) sunset-orange -> (1.0,0.87,0.68) warm-neutral daylight (the house
  family); fill 0.35 -> 0.45; the ceiling strips 1.0 -> 2.0 - the overhead fluorescents a real gym
  runs, which is what pass 2 was missing. `_c225_shell` GarageDaylight 318-327: 1.6 -> 2.4.
- `Lobby3D.gd` - `_practicals` 683-693: desk 1.1->1.5, sofa 0.8->1.1, trophy 1.6->2.0, photo
  1.3->1.7, board 0.7->1.0.
- `Office3D.gd` - `WALL_C` 31: (0.55,0.54,0.42) -> (0.66,0.64,0.50) (same sage, lighter); `_look`
  102-117 exposure 1.05 -> 1.12; `_practicals` 912-929: window 1.1->1.6, hall 1.2->1.6, shelf
  1.1->1.4, trophy 1.4->1.7, cabinet 1.2->1.5 (desk lamp stays the 13.0 key); `_daylight`
  931-955: sun 0.22 -> 0.65 dusk-blue, fill 0.12 -> 0.30, ambient 0.18 -> 0.36, ceiling fixture
  0.22 -> 1.0. First attempt (ambient 0.50 / strips 1.4 / sun 0.9 / exposure 1.14) measured 0.420
  and washed the lamp pool and the whiteboard ink out - pulled back to a LIT evening, not a day
  room; still 0.217 -> 0.374.
- `LockerRoom3D.gd` - wall albedo 96: (0.44,0.47,0.50) -> (0.56,0.59,0.62); `_daylight` 519-540:
  sun 0.5 -> 1.4, fill 0.25 -> 0.45, ambient 0.55 -> 0.75, and the ceiling strips now cool-white
  2.0 (pass 2 left them at the floor's warm 1.0 in a fluorescent room); `_practicals` 555-562:
  2.2/1.8/1.6/1.4 -> 3.0/2.5/2.2/1.9.
- `MatRoom3D.gd` - `_light_pass` 98-123: exposure 1.12 -> 1.15, ambient 0.26 -> 0.55 (the doorway
  wall was near-black), fill 0.22 -> 0.42, strips 0.35 -> 1.9; `_practicals` 396-397 MatWash
  0.9 -> 1.4.
- `PhysioRoom3D.gd` - wall albedo 173: (0.62,0.66,0.70) -> (0.72,0.76,0.80); `_light_pass`
  100-126: exposure 1.05 -> 1.14, ambient 0.30 -> 0.60, sun 2.2 -> 2.6, fill 0.22 -> 0.42, strips
  0.30 -> 1.9; `_practicals` 530-535: treatment 1.8 -> 2.2, plunge 0.8 -> 1.1.
- `StaffRoom3D.gd` - `_light_pass` 93-120: exposure 1.05 -> 1.14, ambient 0.28 -> 0.58, sun
  2.2 -> 2.6, fill 0.20 -> 0.42, strips 0.30 -> 1.9; `_practicals` 819-825: pendant 2.2 -> 2.6,
  kitchen 0.9 -> 1.3, sofa 0.7 -> 1.0.
- `FilmRoom3D.gd` - `FILM_WALL` 25 #2F353B -> #454C54 and `FLOOR_C` 26 #24282C -> #3A4046 (a
  screen room's slate, not a black hole); `_practicals` 921-929: downlights 1.1 -> 1.5, window
  1.4 -> 1.9; `_daylight` 931-944: sun 0.9 -> 1.5, ambient 0.5 -> 0.62, house overheads held at
  1.2 - the dimmest room in the building on purpose, and still not dark.

One look across the eight: exposure 1.12-1.16 everywhere; one warm-neutral daylight sun on the day
rooms, cool-white fluorescent in the wet room and the clinical rooms, dusk-blue only at the
office's window - a family, so walking room to room no longer flickers between moods. No helper
renamed or re-signed; the `_pbr` / `_office_pbr` / `_room_pbr` split S139 fixed is untouched.

## Rubric (review sheets, 1-5; LIGHT is this task's row)

| room   | LIGHT before -> after | evidence (after) | other rows |
|--------|----------------------|------------------|------------|
| floor  | 2 -> 4 | overhead strips + garage daylight read; brick and block texture legible; no black shadow side | MAT 3->4, BAR 2->3; LIFE 2 (unchanged, out of scope) |
| lobby  | 3 -> 4 | honours cabinet and photo wall lit as motivated practicals; surround is the concept's dim brown | MAT 4, BAR 3; none down |
| office | 2 -> 4 | desk-lamp pool on the desk, lit ceiling fixture, dusk at the glass; whiteboard ink legible | MAT 3->4, BAR 3->4; none down |
| locker | 3 -> 4 | cool fluorescent grade over bank, bench and scale; tile reads clean | BAR 3->4; none down |
| mat    | 2 -> 4 | sun through the clerestory plus ambient on the doorway wall; mats and dado keep their colour | BAR 3->4; none down |
| staff  | 2 -> 4 | pendant and window key, ambient fills the sofa corner; rota board legible | none down |
| physio | 3 -> 4 | clinical white grade, treatment light shadows the table; the window-less half is lit | MAT 3->4, BAR 3->4; none down |
| film   | 3 -> 4 | screen glow is the accent, not the only light; slate walls and carpet read | MAT 3->4, BAR 3->4; none down |

No row went down in any room; LIGHT went up 2 in all eight. On the floor the second-lowest before
row (LIFE 2, an almost-empty week-1 floor) is a population matter outside this brightness task and
did not move - flagged for the next floor task rather than claimed here.

## Gates

- Parse: `python Godot/tools/check_scripts.py` over the eight scripts + `tools/q232_render.gd` -
  8/8 and 1/1 clean.
- Tests: `python Godot/tools/run_tests.py --jobs 2 --only lobby,training_floor,front_door,gym_wing,office,locker,film_room,mat_room,staff,physio,smoke` - `SUITE total=15 fails=0`.
- Renders only through `Tools\godot_hidden.ps1`, watchdog GREEN before each heavy run, every still
  looked at with the file-read tool only.
- The worktree had no `.godot` cache: one `--headless --path Godot --import` rewrote ~2800
  `.import` files and added `.uid` files; none of those are staged - only the owned paths.
