# S435 digest (2026-11-11, late evening)

## What happened
- START: the three S434 workflows the handover called dead were ALIVE (the S434 session was still open): training v2 on
  its final redraw (critics clarity 6, depth 7, look 7; both found "Normal 82% of a usual week's work" unclear), the
  weight map in research, the foundation on PUNCHSTART1 round 1 (CARDIO1 and NOCAMP1 still "fix_again"). Nothing was
  re-run. Their results belong to that session; pick the files up from disk when its journals show the end.
- Q-190 acted on: "paid seat" -> "gym sponsorship" in CLUBWEEK_MAP_V41, CORE_LOOP_MAP, TRAINING_MAP, FOURSTART1_MAP_V2
  (a NAME note at the top of each; never to be mixed with Sponsors). It was never in the game code.
- GYMLIFE1 (Cursor) collected by cherry-pick after reading its three stills: people at the bags in different workouts,
  the club's fighters at the kit of today's session. Seven tests green on main. GYMLIFE2 briefed and launched (the shadow
  strip's pop, walks that cut corners, a person under a hub button).
- PR 211 CALLSPREAD1 read: its change makes a wrong call cost less (mult 0.6-1.0 between 56 and 62), so exchanges_test
  "wrong calls lose clearly more" and golden_path "corner call: calm" go red. Not collected; after the foundation, with a
  fix at collect (the wrong-call cost must keep its bar).
- INTROCORNER1 (Qwen) landed (IntroStyle, IntroEntry, FightIntro 428 lines); no stills in the branch: Claude renders
  tools/intro_still.gd at collect.
- DUESSUMS3B re-issued as DUESSUMS3C for Qwen (a re-run needs a new id).

## Animation audit (ops/research/ANIM_AUDIT_S435.md) and D0
Why two rounds stalled: the seat wrote its own ruler each time; no test on main plays a real bout for punches; human_feet
forces the route the game no longer plays; head_aim and block_meet were not in the daily list; `short_m` dropped from
clip_contact.json at S342; `reach_m` is a miss, not a reach; the 2B brief contradicted itself on the knee; no fallback
counter; no layer-order guard.
D0 done this session (Claude):
- scripts/fight3d/BeatTally.gd + BeatFire wiring + tests/beat_tally_test.gd. On the tables: 35 cases, 7 plain, 15
  context, 13 fallback (rear_uppercut x3, body_hook x3, cross x2, lead_uppercut x2, jab, lead_hook, rear_hook x1);
  pro_left_uppercut has no measured contact.
- tools/human_fight_film.gd prints BEAT_TALLY / BEAT_FALLBACKS for a real bout (windowed on the hidden desktop only).
- head_aim_test and block_meet_test: SKIP / VOID / missing clip now FAIL; both and beat_tally_test join tools/run_tests.sh.
- tools/clip_contact.gd keeps the keys it does not measure (short_m survives a re-run).
D0 still open: restore short_m (punch_reach.gd write=1) with a hit_gap_probe before / after; pro_left_uppercut's contact;
human_feet on the default route; a layer-order test; tests/fight_bout_test.gd (the frozen real-bout ruler, 3 seeds); the
corner-face scene and ruler. Then the seat tasks CONTACT1, POPS1, REACH1, KNEE1 (audit section G).

## Traps
- The 3D fight has no stage headless: fight tools run through godot_slot + hidden_desktop, never --headless.
- rule_guard: every Godot start in a session goes through `python ops/Tools/godot_slot.py run --who <s> -- ...`.
- Miro "Where we are": the frame could not shrink because 24 old surplus cards still sit in it (a delete needs his yes).
- idle_guard reads a seat as idle while its runner is still testing and pushing; the dispatcher says "running".

## D0 measurements (late)
- Real bout, seed 7, 70 s, 48 punch beats: take_plain 26, take_context 2, take_fallback 20, refused 0; aim: land 16,
  block 3, height 26, none 3. 20 of the 22 beats that wanted a special take (miss / big / tired / step) played a plain
  one: a missed or big punch looks like any other. Fallbacks: jab x6, cross x9, lead_hook x4, body_hook x1.
- head_aim_test on main: 9 failures, all VOID rows (the gap moves more than GAP_TOL between the no-aim and the aim pass);
  only 3 of 12 rows are read. block_meet_test: 21 failures, 20 of them VOID (gap about 0.73 to 0.79, under GAP_LO 0.80):
  it was reading ONE row. Both rulers must hold their gap before any seat is measured with them (next D0 step).
- clip_contact.json is stale against today's clips: a full re-measure shortens every length_s by about 0.33-0.37 s and
  moves reach_m by 0.01-0.08 (ops/research/CLIP_CONTACT_REMEASURED_S435.json). Only pro_left_uppercut's row was taken
  now (contact 0.0 -> 0.733 s: no guessed contact left). The full file goes in with a hit_gap_probe before / after.
- tools/human_fight_film.gd `seed=` does NOT change the bout: seeds 7 and 8 gave the same 48 beats, the same tally and
  the same 2700 frames (TestJump's bout is settled before the seed is applied to anything the beats read). "Three seeds"
  is one bout three times. A real second sample today is the `women` bout; the frozen real-bout ruler needs a way to
  play different settled rounds (a TestJump variant or a bout seed that reaches the round script).

## INTROCORNER1 not collected
Read in the real game with the new tools/intro_shots.gd (a still every 0.5 s + each boxer's clip): the branch did not
compile (FightIntro.gd:81, IntroEntry.new() without its two arguments: Main.gd failed to load; the seat's tests never
load the game), its still tool did not parse, and with the line fixed the intro ran 6 s (main: over 9 s before the
warm-up), no name-call clip ever played, both boxers walked on the same clip with the arms out, the tale-of-the-tape
card covered them. Stills: docs/mockups/s435/introcorner1/. Re-briefed as INTROCORNER2 (Qwen) with a test that loads
Main.tscn and steps the real intro timeline.
