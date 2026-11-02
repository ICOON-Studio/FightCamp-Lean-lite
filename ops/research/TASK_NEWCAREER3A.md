# TASK NEWCAREER3A (S220) - New Career step 3 shows the player's REAL gym (live 3D club preview + zone inspector)

Model: cloud Cursor (label `cursor`). Branch `cursor/issue-<n>` from master. Never master. Open a PR. The cloud box has no Git LFS: models may load as placeholders - the preview code and the headless test must still run; Claude renders the stills on the PC.
Approved: operator board Q-S220-1 "Approve, and add resize/rotate" on research/LUDO_ROUND57_VERDICT_S220.md (read it whole).
Operator's own words on today's screen: "this screen is wrong ask ludo , it must represent the current gyms preview also ability to
move zones etc". This task = the preview + layout + click inspector. Moving / swapping / resize / rotate = NEWCAREER3B (next task).

## Owned files
- Godot/scripts/CreationFlowPanel.gd (843 lines): `_build_gym()` 303-411, `_draw_take()` 492-526, `_on_open_gym()` 527-560,
  `contract_for_test()` 755. You may move the step-3 body into a NEW file Godot/scripts/creation/GymStepPanel.gd (preferred - the
  file must not grow past ~1,000 lines).
- NEW Godot/scripts/creation/GymPreview.gd: a SubViewportContainer + SubViewport holding ONE GymClub3D built from the take's floor.
- Read-only: Godot/scripts/GymClub3D.gd (2,289 lines - `build(new_layout)` line 214, `thing_at()` 1094; read in windows, never whole),
  GymClubLayout.gd (481), club_zones/ClubZones.gd (274; `floor_zones` live in Godot/assets/data/gym_club.json), GymHallPanel.gd
  (how the game itself instantiates GymClub3D - copy that path), GameState.gd ONLY `sed -n '3580,3620p;3955,4050p'`
  (finalize_new_career 3586, generate_starter_boxing_floor 3959, get_floor 4045).
- Tests: extend Godot/tests/new_career_finished_test.gd or add Godot/tests/new_career_gym_preview_test.gd.

## Do (1920x1080, warm brown palette = decision D47; every number from the verdict items 1-3)
1. Layout: top bar stays (56 px). LEFT sidebar x16 y72 w444 h864 (#181310): GYM NAME, YOUR NAME, START chips (+ADVANCED), the 4 money
   tiles in a 2x2 grid (cash, weekly upkeep, runway + burn, floor used m2), ZONE INSPECTOR (fills on a zone click, else a one-line hint
   "Click a zone to see what it trains"), roster tile (story: Mara Solano + her 6 bars; sandbox: "EMPTY ROSTER - recruit after opening").
   CENTRE x476 y72 w1428 h864 = the live gym. BOTTOM strip y952 h112: RESET + UNDO (disabled in 3A, live in 3B), "FLOOR USED x / y m2",
   the start's one-line pitch, OPEN GYM (gold, x1540 w340 h64).
2. The centre is the GAME's OWN GymClub3D (same scene, same floor camera the player gets after OPEN GYM) built from the CURRENT take's
   floor - it rebuilds when the START chip or the gym name changes the take. Story = Calder House fully laid out with its worn kit;
   OPEN SANDBOX = the empty hall + ring (the sandbox rule: the player recruits and installs). One SubViewport, own World3D, stretch
   to the container; the HUD of the club scene (STEP IN, day strip, speed buttons) must NOT show in the preview.
3. CUT: the 10 equipment cards, the "+ install equipment" card, the abstract blueprint card.
4. Zones on the preview: each floor zone gets an outline (2 px dashed, idle #9E9284, hover/selected gold #E5B842) and a centre pill
   (label + m2). Left click a zone -> selected (gold) + the inspector shows: name, size "12 x 3 m - 36 m2", the equipment in it, what it
   trains (from the station data the station card already uses), average condition (only when switch station_wear is ON), upkeep $/wk.
   Hover = outline only. Use `thing_at()`/a floor-plane ray from the SubViewport camera (mouse coords mapped through the container).
5. OPEN GYM still commits exactly what it commits today (same finalize_new_career call, same floor) - the preview never writes state.
6. Test (headless, 1920x1080): the step builds with a SubViewport whose child is a GymClub3D; no node named like the old equipment
   cards / install card / blueprint remains; selecting a zone by id fills the inspector with that zone's m2 and equipment names; the
   story take shows Mara Solano, OPEN SANDBOX shows the empty-roster line and a floor with no equipment items; OPEN GYM after a zone
   click finalises the same floor as before (compare get_floor() item ids with master's behaviour); sidebar + centre + strip rects do
   not overlap. Control arm: master's new_career_finished_test still passes on what it checks outside step 3's body.
7. Parse gate `python Godot/tools/check_scripts.py <touched .gd>`; then
   `python Godot/tools/run_tests.py --jobs 2 --only new_career,creation,boot_root,playable_loop,first_hour,story,front_door,club`.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
UI + 3D: Claude renders step 3 at 1920x1080 for STORY and OPEN SANDBOX with one zone selected and opens both stills; Ludo reviews
the stills (upload screen); the operator closes it. Do not call it accepted.

## Prior research
LUDO_ROUND57_REPLY_S220.txt + LUDO_ROUND57B_REPLY_S220.txt (Ludo saw the rejected screen), LUDO_ROUND57_VERDICT_S220.md,
LUDO_ROUND53_VERDICT_S219.md / LUDO_ROUND55_VERDICT_S219.md (the screen being replaced), TASK_NEWCAREER2*.md.

## What would a human do?
Put the same club the game already shows into a SubViewport first and see it render, then build the sidebar around it, then add
outlines and clicks.

## Prefab check
Godot's SubViewportContainer/SubViewport is the built-in way; no addon.

## The one trap
The preview must be the SAME GymClub3D the game opens after OPEN GYM, built from the SAME floor - a second hand-made "preview" scene
would drift from the real gym on day one, which is exactly what the operator rejected.
