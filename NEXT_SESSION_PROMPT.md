# S499 handover (written 2026-11-16 at the end of S498)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.

## The one thing: FIGHT MOTION WEEK, day 4 (to about 2026-11-23)
The owner (S496): "The fight looks terrible should we stop this project ?" -> "One week code push". The deal told to him:
two fresh blind critics score the whole fight before and after; under 5/10 = no 3D in the first release.
Memory: project_fight_motion_week_s496. Baseline r0 (`E:/FightCamp/tmp/fightweek/r0`): coach 4/10, animator 4/10.

### On main since S498 (commit a65d80b4f)
- `scripts/fight3d/HeadClear.gd` (pure rule, `tests/head_clear_test.gd` 39 lines green) + `GloveClear._lean_head`: the
  heads' TRUE centres keep 0.28 m (was 0.19 straight above the bone), each lean worked out from both heads as the clips
  put them (half each, a quarter for the boxer whose punch is landing), sideways as much as back, a side once taken kept,
  eased 2.4 m/s up / 0.7 down. The thrower of a body punch dips his head 11 cm to his side from the start of the clip.
  Clinch sets `gclear.tie` so a tie-up keeps the old touch. Control arm `-- noheadside`, trace `-- headtrace`.
- Why: every "head inside the other's body" frame on the film was ONE pair of clips: `pro_body_shot` against the
  `pro_hit_by_gutshot` fold (heads 15-19 cm apart, hips 0.8-1.0 m). The fold starts on the contact frame and closes the
  last 15 cm in ONE frame, so a lean that only reacts cannot be in time: hence the dip before the punch.
- Films of the same bout on today's main (`E:/FightCamp/tmp/fightweek/`): `r3ctl` (old lean, `noheadside`) vs `r3d` (new):
  a head inside the other's body 9 -> 5 frames, heads closer than 25 cm 0.22 % -> 0.13 %, the second overlap gone, the
  first 15 -> 21 cm at its worst. Every other ruler the same.
- **THE BASELINE CHANGED: r2b's "39 head jumps" does NOT repeat on main.** Four films today read 49-51 (new rule, old
  rule, and `nocamhold`: `r3nocam` 50). So r2b was not main's state. Compare against `r3ctl` / `r3d`, not r2b.
  WHAT_TO_TRY tells him so.

### FOUND, not fixed: the contact-frame head jumps (was item 4)
`python E:/FightCamp/tmp/fightweek/s498_tools/trace.py r3d/shown.csv 1711 1721 1` (and `1013 1019 0`; `close.py` lists overlap frames, `jumps.py a.csv b.csv` the head jumps): on a jab's
contact frame (clip_t 0.200, hold=1) the PUNCHER's head-minus-hips moves 19-24 cm in one frame while his root and hips
move 2-3 cm. It is his TRUNK: `PunchReach._reach` -> `ReachLimit.lean` (chest lean up to LEAN_MAX 0.30 rad, "what the arm
cannot reach, the chest leans in") arriving in one frame, and PopCap leaves the trunk alone while the reach holds a
glove (S497). Fix to build first: rate-limit the chest lean's angle inside PunchReach (about 4 rad/s; keep the last
angle per armed punch), leave the forced pass in `HitImpact.hit` free so the graze check still reads the full reach,
re-solve the arm from the eased shoulder as line 451 already does. Expect the 11-12 contact-frame jumps and most of the
"inside a clip" ones at clip_t = contact to go. Then film and compare with r3d.

### Then
2. Arms home: `git apply ops/research/FIGHTWEEK2_WIP_S497.patch` (still applies), release the glove along the clip's own
   path at a capped ~6 m/s so `join_return_test`'s cross passes (bar 9.0 m/s).
3. Reaction size on the small ones (5-8 cm) AND a step back on a body shot: a hit does not move the hit boxer's root
   today (no knock-back anywhere in HitImpact/RangeLive); 15-20 cm over 6 frames would also end the last head overlap.
4. Misses with no defence; nobody steps. Film r1 + two NEW blind critics only when 1-3 have moved on the rulers.
Ruler: `python tools/fight_motion_rulers.py --compare E:/FightCamp/tmp/fightweek/r3ctl/shown.csv <new>/shown.csv`.
Film (3 min): `python ops/Tools/godot_slot.py run --who <S> -- python tools/hidden_desktop.py run --timeout=900
--log=<out>/godot.log <godot.exe> --path . --windowed --resolution 1280x720 --fixed-fps 30 --audio-driver Dummy
--script res://tools/human_fight_film.gd -- <out> secs=75 seed=7`. rule_guard refuses any Godot start outside godot_slot.

## His two answers (both acted on)
- Q-S294-260 "full pads, no sharing , thats for forcing more coaches to be hired ?": the Training K session took the
  sharing out (71c58eec6, 7494fd9b6). It was asked to say what still makes a second coach worth his wage; read its
  last report and put a design gap on the list if nothing does. It also has the 6 `no_pronoun_test` lines in
  TrainCards/TrainGrid/TrainSide.
- Q-S294-261 "i do not like the wooden panels , some pictures ahve some dont , how do you call this consistent ?":
  ONELOOK1 is NOT merged. The "One consistent UI" session is taking the wood out, proving with a test that every page
  uses one panel, and will put new before/after sheets on his board. ONELOOK2 (PR 327) is its to collect.

## Seats
- Ziva ZIVAKNEE1 (knees stop jerking; brief `ops/research/TASK_ZIVAKNEE1.md`): running since 12:44 in chat "Fight Film
  Analysis" on http://127.0.0.1:7012/ (the built-in browser pane), branch `ziva/knee1`, PR when done. She was told not to
  touch GloveClear/Clinch/HeadClear. Collect: knee ruler before/after + look at the film yourself.
- Grok Dev PRESSFLASH1: sent 10:44, no reply and no branch by 13:00. `python ops/Tools/gbot.py thread --to dev`.
- COACHNECK1 (PR 329): rendered before/after on the game camera (`E:/FightCamp/tmp/coachneck/`), NOT merged: the neck
  moves under 1 degree and looks the same; its probe reads neck_vs_chest 131 deg because the chest's +Y is not "up" on
  this rig. The PR comment says what round 2 needs. Give round 2 to Ziva after the knees (she can render).
- Collected: CAMHOLD1 (8fd718ed6; PR 330 can be closed), FILMCOUNT1 (561bf6b62, FilmCount split into FilmCount +
  FilmMoments). `tests/film_count_test.gd` is RED on purpose: five film-night claims pass by chance over the 8 % bar
  (it names them; worst "their jab -> a wild swing" 26.5 %). FIGHTFILM1 settles those before the film night is wired.
- Arena, Dola, John, Maria, Kalli got nothing from this session (no pure module was ready). Arena first thing: the
  body-shot step-back as a pure rule, or the stricter bar for the five claims.

## Nightly (2026-11-16: 374 pass, 8 fail lines)
Fixed: gauges_test, camp_cards_test, the film word "That's it" (5fd3fcd34); film_seat_wire_test was already green.
Left: no_pronoun_test (6 Training lines, with the Training K session), block_meet (known), film_count_test (new, red on
purpose, above).

## PC
AMBER all session: memory 92 % (he was playing ArcheAge, 8.5 GB). One windowed render at a time; the Godot queue showed
0 slots for a few minutes once.
