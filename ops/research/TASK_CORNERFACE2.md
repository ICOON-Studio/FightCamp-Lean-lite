# TASK CORNERFACE2 - QWEN (qwen3-coder) - the corner minute keeps the boxer's face in the open part of the screen, measured on the real bodies

Status: OPEN (S433, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: CORNERFACE1 (PR 197) was REJECTED at S433 collect (review + verify in ops/tmp_s433/collect_review.json). Read
`ops/research/TASK_CORNERFACE1.md` for the operator's words (S430: "the camera cuts the face") and the five-point head test.
Main is c523b4ec; CornerShots.gd and CornerMinute.gd have not changed since PR 197's base. Nothing of PR 197 is kept.

## Contract
OWNS: scripts/fight3d/CornerShots.gd, scripts/fight3d/CornerMinute.gd, tests/corner_face_test.gd, tests/corner_face_scene.gd,
tests/fight_polish_test.gd:24-25 (only its CornerMinute text check, step 4)
RED_TEST: tests/corner_face_test.gd -> CORNER_FACE failures=0
REGRESSION: corner_lens_test, fight_polish_test, crowd_room_test
VISUAL: yes

## The job
1. THE SCENE, real bodies (tests/corner_face_scene.gd, a helper the test preloads): `root.size = Vector2i(1920, 1080)`; a
   FightStage built as tests/head_aim_test.gd `_make_stage` does (set_process(false) before setup, two DIFFERENT boxers:
   mh_boxer_10 red, mh_boxer_12 blue); `crew = FightCast.crew(stage, true)` (pro, so the cutman exists); `stage.scene_mode(true)`;
   `crew.set_shown(true)`; `Engine.max_fps = 30`. CornerMinute._process calls `crew.tick(delta)` in the game: the scene calls
   it itself every frame. Wait by real time (callout_pop_test `_secs`), never by a frame count.
   - Both boxers seated as cue_walk ends: `crew.place(a, crew.sit_spot(i, c), crew.yaw_to(Vector3.ZERO, c["d"]))`, then
     `crew.sit(i, done)`; wait for `done`. Print where the node landed and FAIL "sit" when it is more than 0.03 m from
     `c["seat"]` (crew.sit leaves the node on the seat: sit_spot less the clip's feet travel).
   - Then `m.cue_crew_in()` on `m := CornerMinute.new()` with `m.stage = stage`, `m.crew = crew`, `m.ui = <a CornerOverlay>`,
     `m.ctx = {"won": w, "pro": true, "round": 1, "card": {"call": "long"}}` (m stays out of the tree; free it at the end).
     `m.ui` is the plain overlay of step 2, built first (cue_face calls `ui.show_card(true)`; the ruler sets the card state
     it measures after the cues).
   For a side S (red = the game's case; blue = the mirror, the subject boxer is boxers[1] on the blue stool):
   - RED: the REAL cues, in the game's order: `m.cue_water()`, `m.cue_ice()`, `m.cue_face()`, `m.cue_blue_talk()`; for the
     cutman shot only `m.cue_cutman()` before it and `m.cue_cutman_off()` after (the game shows the cutman 30-34 s only).
     The coach keeps cue_water's `upright(-APRON_LEAN_DEG)` lean: cue_face never resets it.
   - BLUE (mirror, by hand, the same lines with `crew.corner("blue")`, boxers[1] and the blue team): the subject's coach
     (actors["blue_coach"]) as cue_water + cue_face leave a coach - `at` from `m._apron(c, CornerMinute.APRON_ALONG_M,
     CornerMinute.APRON_CROUCH_OUT_M)`, placed facing the boxer, `af_crouch_idle`, `ik.upright(-CornerMinute.APRON_LEAN_DEG)`,
     `crew.look(coach, boxer)`, `crew.look(boxer, coach)`, the boxer on `af_sit_talk` (lost) or `af_sit_idle` (won); the other
     coach (actors["coach"]) as cue_blue_talk (`m._apron(..., APRON_OUT_M, true)` on the red corner, `af_talk`, both look);
     the cutman as cue_cutman on the blue boxer's left.
   - MIRROR CHECK: run the hand-placement function for S = red too and compare it with what the real cues did: every placed
     node within 0.01 m and 1 degree of yaw, else FAIL "mirror <role>". The blue side is filmed by the code the red side proved.
   - Then >= 0.6 s of real time (CornerIK.EASE_S is 0.35), so the real CornerIK has turned the head toward the coach.
   - ctx exactly as CornerMinute._shot_ctx: `{her, opp, coach, blue_coach, red: crew.corner(S), blue: crew.corner(other), cam}`;
     for S = blue, `her` = boxers[1], `opp` = boxers[0], `coach` = actors["blue_coach"], `blue_coach` = actors["coach"].
     (CornerShots.frame reads `red` as the filmed corner and `blue` as the other one, so this is the whole mirror.)
   - TEN SEEDS: a RandomNumberGenerator seeded s varies both boxers' node scale in [0.92, 1.10] (FightCast clamps 0.88-1.12),
     won/lost, and where the seated loop starts (`crew.play(a, clip, 1.0, seek)`, seek 0-1.5 s). After a scale change place
     each boxer at `crew.corner(side)["seat"]` facing `c["d"]` and play the seated loop (no second sit), then place the crew
     again as above (seat_y and the apron spots follow the scale) and wait the 0.6 s again.
   - A face's forward = `skel.global_transform.basis * (skel.get_bone_global_pose(Head).basis.orthonormalized() * ik._face_local)`,
     normalised, READ INSIDE `skel.skeleton_updated` (connect a callable that stores it; CornerCrew._add_follow and the
     tests/guard_knee_test.gd read do the same). Outside that signal get_bone_global_pose is the clip's pose, before CornerIK
     (the S307 trap): read there, the turn does not exist. Never the body's forward.
     Check per seed: flattened to the floor, the subject's face forward is at least 20 degrees nearer the direction from
     its head to `CornerCrew.face(coach)` than `CornerShots.fwd(her)` is; if not, FAIL "the look did not turn the head".
2. THE RULER (tests/corner_face_test.gd). The card from a real CornerOverlay, built as tests/callout_pop_test.gd `_corner`
   builds it (added to root, root 1920x1080), twice: plain `{"worked":"","hurt":"","why":"","call":""}` and with
   `"body_map": BodyMap.fresh(), "body_glb": Faces.glb("mh_boxer_10")`, names ["Red", "Blue"]; `show_card(true)`, wait 0.4 s,
   read `ui._card.get_global_rect()` (left edge) and `ui.subject_x()`; the bars are `CornerOverlay.BAR` x 1080.
   Print both rects; FAIL "card rects" when the two left edges are equal (the two layouts must both be read).
   Card states: down, up-plain, up-body. Never type 0.40 / 0.33 / 0.20 / 0.165 / 0.128.
   Shots: ots, side2, reverse, corner_wide, cutman, other (the shots that can play while the card is up, 9-52 s; the card goes
   at "Seconds out", 52 s, before `push`).
   For each side x seed x card state x shot: `fr = CornerShots.inside(CornerShots.frame(name, ctx), CornerShots.body_points(ctx))`
   (CornerMinute._cut line 148), then at u = 0, 0.5, 1 the lens: after step 4, `CornerShots.call("lens", name, fr, u, ctx, card_x)`
   (card_x = `ui.subject_x()` card up, -1.0 card down; check the result has pos, look and fov - a wrong arity returns null);
   while CornerShots has no `lens` (main: find "lens" in `CornerShots.get_script_method_list()` names), main's lines
   CornerMinute.gd:127 and 130-135, copied with a comment "main c523b4ec" (with `_frame` = fr, `ctx_actor("her")` =
   `ctx["her"]`, `ui.card_up()` = card_x >= 0, `ui.subject_x()` = card_x). The ruler computes no lens of its own.
   Film it with the game's own lens: `stage.camera.film(pos, look, fov, focus)` (RingCamera.film: look_at_from_position, the
   fov), then on the same call, before any frame, `stage.camera.unproject_position` / `is_position_behind`.
   SUBJECT: ots, side2, corner_wide, cutman = the boxer (`her`); reverse = the boxer's coach; other = the other boxer (`opp`).
   Five points on the subject: head (`ik.head_world` when set), r = 0.12 x node scale: top, chin, both ears (along
   UP.cross(face forward)), nose = head + face forward x 0.10 x scale.
   PASS when (a) all five in front of the lens, x in [0, 1920], y between the bars; (b) card up: every x in [40, card left - 40];
   (c) dot((head - lens).normalized(), face forward) < -0.2 (side2 is a profile by design: (a), (b) and (d) only);
   (d) the boxer's shots: the coach's head (and the cutman's in cutman), projected as a circle of its 12 cm radius, holds none
   of the boxer's five points while that head is nearer the lens;
   (e) the lens at u = 0 and u = 1 is at least `CornerShots.KEEP_M` - 0.01 from every point of `CornerShots.body_points(ctx)`,
   unless `fr` has `blocked` (a lens left inside a body, as `inside(fr, [])` leaves it, fails here).
   Print one line per check that fails: `CF side= seed= card= shot= u= FAIL a|b|c|d|e <why> <five x,y>`; then a table shot x
   side x card state -> passes/30; then `CORNER_FACE failures=M checks=N`; quit(1) on any failure.
   The ruler can read worse: three built-in mutants, red side, seed 0, card up-body, each must FAIL its check (a mutant that
   passes counts as a failure, "ruler void"); print each: `MUTANT b|c|d FAIL ok` or `MUTANT ... PASSED ruler void`.
   (b) ots with card_x = 0.75; (c) a lens 1.0 m behind the boxer's head along minus the boxer's face forward, looking at that
   head, fov 30; (d) a lens on the line from the boxer's head through the coach's head, 0.8 m past the coach's head, looking
   at the boxer's head, fov 30. A mutant goes through the same check code as the real shots, never a copy of it.
3. RED ON MAIN FIRST: commit the two test files alone (no game change) and run the test. Paste the run. If it is green on main
   in every state, seed and side: change no game code, open the PR with the table and say "ruler green on main"; Claude decides.
   Nobody knows yet which check main fails (no run exists): never move a bar, a margin, a seed range or a mutant to make main
   red, and never to make the branch green.
4. THE FIX (only when 3 is red). Move CornerMinute._camera's lens lines (127, 130-135) into
   `static func lens(name: String, fr: Dictionary, u: float, ctx: Dictionary, card_x: float) -> Dictionary` in CornerShots
   ({pos, look, fov, focus}; card_x < 0 = card down); _camera calls it with `ui.subject_x()` when `ui.card_up()`, else -1.0.
   The `behind` lerp, track shots and broadcast stay in _camera. While the card is up the subject is the boxer's head for the
   boxer's shots; `other` keeps the other boxer (its look), `reverse` keeps the coach (its look). Then change ots and cutman in
   CornerShots.frame (distance, side, height, fov, and the face point from the turned head) until they pass; any other card-up
   shot that fails is fixed in its own branch of frame(), keeping its subject. Never the card, never CornerOverlay.gd.
   tests/fight_polish_test.gd:24-25 reads CornerMinute.gd for the text "frame_at(p, subject" and goes red once the lines move:
   change only those two lines (main's numbering; a line inserted between them is fine) so it reads CornerShots.gd for
   "static func lens(" and "frame_at(" and CornerMinute.gd for "CornerShots.lens(" (same message). Do not keep a dead copy of the old line in CornerMinute.gd to satisfy it.
5. Prove it: run 2 on the branch (green). Run 3: `git checkout main -- scripts/fight3d/CornerShots.gd scripts/fight3d/CornerMinute.gd`,
   run (red), `git checkout HEAD -- scripts/fight3d/CornerShots.gd scripts/fight3d/CornerMinute.gd`. Paste all three.
6. STILLS (one windowed run at a time, hidden desktop): `tools/corner_film.gd -- <out> pro` (`pro` gives the corner the
   cutman, else no c085; it picks at 12.5 s and the card stays up 6 s more, so c06_coach_card, c07_reverse_pick and
   c075_side2 are the card-up stills; c08b_ots, c085_cutman, c09_other_corner are card down), and `tools/fight3d_play.gd`
   twice: `-- <out> end=corner hold=6` and `-- <out2> end=corner hold=16` (p05_corner_card = ots with the card up;
   p05b_corner_card_held later in the minute - the minute runs at 2x there; the CORNER clock on the top bar says when).
   Before (main) and after, under E:/FightCamp/tmp/cornerface2/{main,branch}; list every path in the PR body. Claude opens
   them at collect.

## What the last round got wrong
- The ruler re-typed the shot formulas with the new distances: same answer on main and on the branch. Call CornerShots.
- The scene was invented: the coach inside the ring in front of the boxer, the face along the corner's d (inverted: d points
  INTO the ring, CornerCrew.corner), no head turn. Build the real stage, run the real cues on red; the coach crouches on the
  apron behind the boxer's right. Step 1's MIRROR CHECK fails a hand placement that differs from the cues.
- The head never turned toward the coach (CornerIK up to 65 degrees, cue_face `crew.look(her, coach)`): the back-of-head view
  the operator saw could not show. Read the turned head, inside skeleton_updated (step 1's 20 degree check).
- The card edge was typed (0.40); with the body map it is 0.33. Read the rect; both layouts ("card rects" check).
- The code aimed `other` and `reverse` at the red boxer's head while the card is up: `other` lost the blue corner, `reverse`
  lost the coach. Keep their subjects.
- "Both corners" printed a constant and rotated one made-up corner. Film the blue stool for real (step 1 mirror).
- The coach's head was never projected. Step 2 (d) and its mutant.
- keep_out never ran (`inside(fr, [])`). Pass `CornerShots.body_points(ctx)` as _cut does; step 2 (e) fails any lens left inside a body.
- `seed` as a loop variable shadows the global seed(): name it `s`.

## Prior research
`python ops/Tools/prior_research.py corner face camera`; ops/research/TASK_CORNERFACE1.md, TASK_CORNERLENS1.md, TASK_CORNERCAM1.md;
tests/corner_lens_test.gd (made-up Vector3s: why it stayed green while the face was cut); tests/head_aim_test.gd (a real stage
headless); tests/callout_pop_test.gd (a real CornerOverlay); ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A TV director puts the lens in front of the stool on the side the graphics leave free, the boxer's eyes on the upper third,
and checks the monitor with the graphics on, for both corners. Nobody shoots the back of a boxer's head while the coach talks.

## Prefab check
Nothing to fetch: Camera3D.unproject_position does the projection; the bodies, IK and card are the game's own.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC (never the _console.exe); windowed through `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py
run --timeout=420 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/<name>.gd -- <args>`.
Parse first with `--check-only --script res://<file>` (a parse error hangs a headless test). The test loads MetaHuman models: it
runs on the PC, not on CI. Line counts today: CornerShots.gd 279, CornerMinute.gd 403, fight_polish_test.gd 37 (lines 24-25
only), the two test files new. No file over 500 lines. Do not touch RingCamera.gd, CornerOverlay.gd, CornerCrew.gd (500 lines,
full), CornerIK.gd or tools/. No tools/ probe.
Traps (GDSCRIPT_TRAPS.md): `var x := <call>` fails on a Variant return - type it (`var p: Vector3 = fr["pos"]`); a variable
name reused in one function is a parse error; `callv`/`call` with the wrong arity returns null/{} silently - check the result;
a bone read from outside is the clip's pose before CornerIK and every other modifier: the turned head is read inside
`skel.skeleton_updated` only (`ik.head_world` is already the shown head); `%` in a format string is `%%`.
Never "he" or "she" in text or comments.

## Result lines (PR body)
RESULT: tests/corner_face_test.gd -> CORNER_FACE failures=0 checks=N
RESULT: tests/corner_lens_test.gd -> CORNER_LENS failures=0
RESULT: tests/fight_polish_test.gd -> FIGHT_POLISH checks=N failures=0
RESULT: tests/crowd_room_test.gd -> CROWD_ROOM checks=N failures=0
Paste: run 1 (main + test, red), run 2 (branch, green), run 3 (main's two files, red); both card rects; the sit and mirror
lines; the table before and after; every number changed in CornerShots with its before and after; the three mutant lines;
the still paths.
