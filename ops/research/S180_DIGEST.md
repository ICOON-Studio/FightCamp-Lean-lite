# S180 DIGEST - the new club in 3D built and reviewed (25cf9f06), the click ring + goals HUD merged, the Grok bots fixed for good

Date 2026-10-08. Model Opus (ultracode on for most of the session). Operator present.

## What now works (evidence)
1. **The club in 3D - GYM4E, 25cf9f06 (switch `gym4_club`, OFF).** Codex's run stopped uncommitted (its workspace-write
   sandbox cannot start Godot; its draft replaced the hall's builders with greyboxes), so Claude rebuilt it on master from
   TASK_GYM4E. GymClub3D extends GymHall3D (hook `_layout()`; a bare static call from parent instance code dispatches to
   the subclass's static - probed), so the day lap, skinned fighter/coach, HUD, mornings and interview panels all run on
   gym_club.json. On top: the building from the data (walls with door/window gaps, four furnished rooms, roof, street,
   neighbours), zoom far/mid/close (roof at far only; close on the fighter, follows him; walls in the way CUT to a stub),
   walk-ins from WalkIns (interviews held at the reception desk), click a thing -> ClubActionRing (holds the day without
   touching `running`), DayGoalsHud (day goal, "Jab usable by Friday", auto-pause at the stamina floor, Space resumes,
   the bell). GymHallPanel opens the club when `gym4_club` is on inside `gym3d_main`.
   Tests: gym_club_3d_test **154/0, 10 mutants red**; thing_actions 52/0; club_action_ring 79/0; gym_club_layout 69/0;
   walk_ins 138/0; neighbours 26/0. Stills from the club's game camera, opened and sent: docs/previews/gym4_club/01-03.
2. **The click ring - GYM4F (Cursor c937524e) merged 5759c3cf** + fixes: its test ran in `_init` (tree not running ->
   8 SCRIPT ERRORs behind a printed PASS); buttons now draw Lucide icons (thing_actions.json `glyphs`).
3. **The goals HUD - GYM4G (Cursor 6a536bfa) merged 4408f6d0.** 61/0; a tooltip_text spot-check mutant red (NOTE: that
   spot-check was run AFTER the commit whose message already claimed it - the first attempt silently did not run).
4. **Grok bots fixed for good (operator: "fix it once and for all").** The 417 was `x-anyrun-failure-reason:
   pod_hibernated`: the Grok Bot app (0.66) parks its cloud pod when its window is unfocused (server gates
   sand_desktop_away_park/present_park); gbot has no wake and its own fallback sends client 0.20.0, refused by the backend.
   `Tools/gbot_wake.mjs` (EnsureSandBox wake=true with this PC's Cursor login + the app's client version, 1.6 s) +
   `Tools/gbot.py` (wakes, retries; --to/--file/--out; pinned gbot auto-installed into E:/FightCamp/tools/gbot because
   Claude-shell npm installs live in a sandbox overlay the runner cannot see) + `start` wakes the pod + pc.yml job=agent
   tool `gbot` (proven on the PC runner, run 37836459340). J65 collected: research/J65_CLUB_PROP_MODELS.md
   (29/37 props have a free model, 6 NOT FOUND -> image-to-3D).

## The review (workflow gym4e-review: 3 lenses + 1 refuting skeptic per finding, 41 agents)
37 confirmed, 1 refuted; 4 high, all fixed: the ring/auto-pause stopped `running`, which END DAY reads (the lived day
would be thrown away); a click before any fighter is signed crashed send_to (also guarded in GymHall3D); walk-ins skated
at up to 3.8x walking speed; the mid zoom cut off the front rooms (reception desk, your office). Medium/low: dead ring
buttons (now greyed 'Not in this build yet' via ThingActions ctx.blocked), tooltips invisible in the SubViewport, the
ring clamped to the window not its viewport, floor seen through the office window picked as the window, Rest walking on
the spot, every weekday replaying Monday's walk-ins, a body built mid-frame per arrival, uncapped fame, chair inside
the manager, reception desk through a wall, office TV screen misplaced, close not following him, data rows not winning
over drawn shapes, missing locker_in, wall/prop/pose checks that read the subject.

## Delegation this session
GYM4F (Cursor) and GYM4G (Cursor) merged; GYM4E (Codex) died on its sandbox; STORY4A (Arena chat 01a11d16, brief reworked
to a new StoryWall.gd so the diff-copy works) STALLED compiling Godot in its sandbox, no files after 33 min.

## Open / next
- **Operator: OK on the three stills** (far/mid/close). Known and named when sent: visitors/coach barefoot in plain
  tracksuits (no clothes/shoes for the generated body - STAFF1 note), the fighter in a guard on the treadmill (the hall's
  station clip), the left-wall mirror has no glints.
- On his OK: all stills + a 30 s video, then gym3d_main + gym4_club ON + an exe walk to the first club bout.
- Ring rows still greyed (office window, walk-ins, profile/day plan/talk, queue next): wire them one by one.
- STORY4A: reassign (Cursor - local Godot) or write it (~20 lines).
- NIGHTLY: checked, same run as S177 (1bd09b94, 571/5) - nothing new.
