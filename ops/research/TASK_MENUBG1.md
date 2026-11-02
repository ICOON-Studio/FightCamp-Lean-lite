# TASK MENUBG1 (S222) - our own 3D gym, moving slowly, behind the New Career country + city steps (art and motion, no pictures)

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: tests build the club with `load_models = false` (the pattern in `creation/GymPreview.gd` `_rebuild_club`).
Do not delete or shorten any existing test. New features ship ON (operator S221) - no opt-in switch.
APPROVED: operator board Q-S221-1 "Approve, build it" on `research/LUDO_ROUND60_VERDICT_S222.md` section 3 (read it whole), then
section C of `research/LUDO_ROUND60_REPLY_S222.txt`. The VERDICT wins where they differ. Operator, verbatim: "fix the bakcgrounds
put some art and motion"; "i do not want random generated pictures i want pictures we can use in the game".

## Prior research
- `Godot/scripts/CreationRoot.gd` (364 lines; `_ready` 82, `_build_chrome` 103, `show_step` 151, `set_transitions` 74 - tests turn
  transitions off) + `Godot/scripts/CreationChrome.gd` (181) build the flat brown frame you put the backdrop behind.
- `Godot/scripts/creation/GymPreview.gd` (step 3, merged S222): how to put `GymClub3D` in a SubViewport with `load_models` off/on,
  force a camera and hide the club HUD (`_rebuild_club`, `_force_floor_camera`, `_hide_club_hud`). Reuse that, do not copy-paste it -
  extract a small shared helper if both need it.
- Step 3 already shows the live club in its centre: it only gets the dust layer + vignette, not a second club.

## What would a human do?
Football Manager / Two Point menus: the real world sits behind the UI, slowly alive, darkened at the edges so the panels read.

## Prefab check
Godot built-ins only: SubViewport + Camera3D + Tween, GPUParticles3D (or CPUParticles3D) for dust, a ColorRect shader for vignette.

## Owned files
- NEW `Godot/scripts/creation/CreationBackdrop.gd` (< 300 lines): a Control holding a SubViewportContainer with our GymClub3D
  (default layout, models ON in the game, OFF in tests), one Camera3D with two stops (verdict: step "country" = wide on the ring,
  morning window light; step "city" = slow dolly along the heavy-bag row), `go_to_step(id)` tweens between stops over 2.5 s;
  idle drift: +-0.15 m over 20 s loop; one heavy bag sways +-1.8 degrees, 4.2 s period (rotate the bag prop node - find it in the
  club by its instance id); dust motes <= 120 particles drifting 0.04 m/s in the light; vignette ColorRect shader darkening the edges and
  the panel zones to #100D0A at 65%; 60 fps cap on the SubViewport.
- `Godot/scripts/CreationRoot.gd`: add the backdrop as the first child (behind the chrome), call `go_to_step` from `show_step`;
  the chrome's opaque background becomes transparent where the backdrop shows (panels keep their own backgrounds).
- Motion rules: everything freezes while a LineEdit has focus; a `reduce_motion` user setting (add it to `UserSettings.gd` next to the
  existing settings, default false, saved like the others) makes the camera cut instead of tween and stops bag + dust.
- NEW test `Godot/tests/creation_backdrop_test.gd`.

## Acceptance - `creation_backdrop_test.gd`
(a) CreationRoot on "country" has a CreationBackdrop child drawn BEHIND the chrome (lower index) with a GymClub3D inside a SubViewport;
(b) `show_step("city")` moves the camera to the city stop (transitions off -> immediately); (c) the bag sway angle changes over 1 s of
process frames and stays within +-1.8 degrees; (d) with `reduce_motion` true it does not change; (e) with a LineEdit focused it does not
change; (f) particle amount <= 120; (g) existing new_career_* and creation_* tests still pass. Parse gate:
`python Godot/tools/check_scripts.py <touched .gd>`. Claude takes the game-camera stills on the PC after it lands.

## The one trap
CreationRoot tests run headless with transitions OFF and no models: the backdrop must build without models and never await a tween
in a test, or every creation test hangs.
