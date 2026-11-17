# TASK FP2CHOREO1 - the choreographer: plan one exchange of the 3D fight before it plays (FIGHTPLAYER2 phase 2)

Status: OPEN (S512, Claude animation session). Discipline: boxing (demo path). Model: Goose (cloud), default.
A PURE module + its test. No scene, no node, no Godot window. Do not edit any existing file.

## Why
The 3D fight only SHOWS a round the rules already settled. Today it pins every clip on the spot, moves the bodies to
fit the clip and re-bends arms and heads with ~25 layers; three builds scored the same 4.5 / 10
(`ops/research/FIGHTPLAYER2_BASELINE_S510.md`). The rebuild (`ops/research/FIGHTPLAYER2_SCOPE_S510.md`, sections 3b-3d
and 8) does what shipped boxing games do: the feet make the distance, a take is CHOSEN to fit it, reactions are captured
takes. Because our round is already decided, the plan can see a whole 30-second exchange before it plays. This task is
that planner. A separate player (not this task) plays the timeline it returns.

## Read first
- `ops/research/FIGHTPLAYER2_SCOPE_S510.md` sections 3b, 3c, 3d, 3f, 8 (the rules below come from there).
- `ops/research/CLIP_CENSUS_S512.md` and `assets/data/clip_db.json` (every owned take, measured: your only clip data).
- `scripts/fight3d/v2/ClipCensus.gd` (pure: `takes_for`, `family`, `kind`, bars) - use it, do not copy it.
- `scripts/rules/RoundScript.gd` (what a beat is; `NOT_PUNCH`), `scripts/fight3d/BeatClips.gd` (`PUNCH`, `IMPACT_S`,
  `defence()`), `tests/round_script_test.gd` (how to build real beats in a test).

## Owned files (new; each under 500 lines)
- `scripts/fight3d/v2/Choreographer.gd` - `static func plan(beats: Array, db: Dictionary, opts: Dictionary) -> Dictionary`
- `scripts/fight3d/v2/ChoreoRules.gd` - the constants table and the small pure helpers (split further if a file nears 500)
- `tests/choreographer_test.gd` - prints `CHOREO failures=<n>` and exits 1 when n > 0
Test command (the only one): `<godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/choreographer_test.gd`

## The contract
### Input
- `beats`: the exchange's beats, time order. Each `{"t": s (when today's player starts the move), "who": "a"|"b", "move",
  "result": "lands"|"blocked"|"misses"|..., "def": ""|"slip"|"weave"|"pull"|"block", "big": bool, "knockback": bool,
  "combo": bool, "combo_id": String, ...}`. A punch = a move in `BeatClips.PUNCH`. Other moves (`RoundScript.NOT_PUNCH`:
  step_in, step_out, slip, clinch, tired, count, inside) are not punches. NEVER change, reorder, add or remove a beat;
  never write into the input (return copies).
- `db`: the parsed `clip_db.json`. A take may be used only if its row's `drop` list is empty.
- `opts`: `{"t0", "t1"` (the exchange's window, s), `"gap0"` (pelvis-to-pelvis gap at t0, m; default REST_M), `"seed": int,
  "south": {"a": bool, "b": bool}}`.
### Output
`{"beats": [...], "tracks": {"a": [...], "b": [...]}, "gap": [[t, gap_m, who_moves], ...], "counts": {...}, "log": [...]}`
- `beats`: one per input beat, same order: the input's keys plus `t_play` (when its take starts), `take` (clip name or ""),
  `from_s` (where in the take it starts), `contact_t`, `gap` (planned gap at contact), `ik_m` (what the arm IK has left to
  do: |gap - the take's contact_gap_m|, straights only), `react` + `react_part` ("upper"|"whole") for a landed punch,
  `defence` (the other man's take for a blocked / slipped punch), `cut` (bool), `why` (one plain line).
- `tracks`: per boxer, events in time order, no two overlapping in control: `{"t", "clip", "kind": "punch"|"reaction"|
  "block"|"defence"|"step"|"pivot"|"pass", "part": "whole"|"upper", "from_s", "join_s", "control_t"}` (control_t = when
  the next event of this boxer may start). `pass` = a non-punch beat handed to the old code unchanged (clinch, count, tired, inside).
- `gap`: the distance plan, piecewise linear, t ascending, first point `[t0, gap0, ""]`; `who_moves` = "a"|"b"|"both".
- `counts`: `{"a": {"thrown", "landed", "cut"}, "b": {...}}`. `log`: every slide, cut, misfit and fallback, one line each.

### Constants (put them in one table in ChoreoRules.gd, each with its source in a comment)
REST_M 1.7 (rest out of reach, 1.6-1.8) - CREEP_M 1.4 - MIN_GAP_M 0.45 - GAP_SPEED_MPS 1.6 (a step pair is 0.55-0.60 s) -
LEAVE_S 1.5 (back at rest within this after a burst's last contact) - FIT_M = ClipCensus.FIT_M (0.15) - IK_MAX_M 0.30 -
HOOK_FIT_M 0.05 (hooks, uppercuts, body shots get no IK) - SLIDE_MAX_S 0.25 - CONTROL_S 0.13 (control back after contact) -
WIND_MIN_S 0.12 (a take never starts later than this before its contact) - STUN_S {light 0.40, medium 0.60, heavy 0.80} -
HEADS_APART_M 0.25 - JOIN_S {punch 0.15, reaction 0.05, defence 0.15, block 0.05, guard 0.30} - PIVOT_EVERY_S 25 -
QUIET_MIN_S 1.2 - WHOLE_BODY_HIPS_M 0.15 (a reaction whose hips_max_m is this or more is whole-body).

### Rules (each one is a test)
R1 COUNTS. Landed punches per boxer = the input's `lands` beats, always. A punch may be `cut` only when its thrower is
   inside a stun (R7), it does NOT land, and it cannot slide out; thrown = input punches - cut. Each cut is logged.
R2 TIME. A punch's `contact_t` = its beat's `t` + `BeatClips.IMPACT_S[move]` (0.45 when the move has none), slid by at
   most SLIDE_MAX_S, never outside [t0, t1], and one boxer's contacts keep the input order. `t_play` = contact_t -
   (contact_s - from_s); `from_s` starts at the row's `start_s` and may grow (a combination's next punch starts while the
   last hand comes home) but never past contact_s - WIND_MIN_S.
R3 THE TAKE FITS. The take's `family` is the beat's move. Pick from `ClipCensus.takes_for(db, family, wanted gap)`: the
   wanted gap is where the plan already is at that moment if a take fits there, else the nearest take's own contact
   gap and the feet go there (R5). At contact: a straight (jab, cross) has |gap - contact_gap_m| <= FIT_M and never over
   IK_MAX_M; any other punch <= HOOK_FIT_M. A `misses` beat with no `def` is planned SHORT: gap = contact_gap_m + 0.15
   to 0.30 (the glove stops in the air in front of him). Prefer `form` "hard"/"hard_ft"/"special" for a `big` beat and
   "hurt"/"hurt_ft" never unless nothing else fits. Do not give one boxer the same take three times running when another
   take fits (use opts.seed for ties).
R4 THE DISTANCE PLAN. Continuous; |slope| <= GAP_SPEED_MPS; never under MIN_GAP_M; equals each punch's `gap` at its
   contact_t; when no contact is within 1.5 s either side it sits in 1.6-1.8 m. After a burst's last contact it is back
   at rest within LEAVE_S. `step_in` / `step_out` beats move it to CREEP_M / REST_M.
R5 A STEP YOU CAN COUNT. A punch whose plan was at CREEP_M or more 0.6 s before its contact gets a `step` event for the
   puncher that ends at or before the contact, and `who_moves` names him.
R6 THE REACTION. A landed punch gives the other man a reaction take (kind "reaction", not dropped): size by the punch -
   jab light; cross, hooks, uppercuts medium; `big` head shots heavy; body_hook one of the gutshot takes. Direction from
   the row's `head_dir` [back, his left, up]: a straight wants back >= 0.6; a punch from the thrower's LEFT hand that is
   a hook sends the head to the hit man's left (his left >= 0.5), from the RIGHT hand to his right (<= -0.5); when no
   take of that size and direction exists take the nearest size with the right direction, log it. It starts at
   contact_t with join 0.05. `react_part` = "whole" when the row's hips_max_m >= WHOLE_BODY_HIPS_M (and the gap plan
   grows by that travel from contact_t, who_moves = the hit man), else "upper".
R7 A HIT MAN DOES NOT PUNCH. From a landed contact the hit man is stunned STUN_S[size]. A punch of his whose take would
   start inside the stun slides later (R2) or, if it cannot and it does not land, is cut. A punch of his that DOES land
   is never cut: slide it as far as allowed and log the overlap that is left.
R8 BLOCK, SLIP, MISS LOOK DIFFERENT. `blocked`: the other man gets a block take (kind "block", `block_straight_hit_v2`
   today) at contact_t, and the punch is planned 0.05-0.10 m LONG of its contact gap (the glove meets the guard, not the
   face). `def` slip / weave / pull: the other man's take comes from `BeatClips.defence(kind, move, from_left, south, has)`
   with `has` = "in the db and not dropped", started so the row's `head_peak_s` falls on contact_t.
R9 HEADS APART. At every contact outside a clinch / inside spell: gap - the take's `head_fwd_m` -
   db.meta.head_from_hips_m >= HEADS_APART_M; else choose another take or a longer gap.
R10 CONTROL. After a punch's contact its thrower's control_t = contact_t + CONTROL_S; his next event may start then.
   No two events of one boxer overlap in control.
R11 PIVOTS. Every PIVOT_EVERY_S of the exchange holds at least one `pivot` event (either boxer) inside a quiet spell
   of QUIET_MIN_S or more, when such a spell exists.
R12 SAME IN, SAME OUT. Same beats + db + opts = the same plan (use only opts.seed for randomness); the input is not mutated.

## The test must hold all of this
- One check block per rule R1-R12, on hand-made beats that isolate it (a lone jab from rest; a jab-cross combination;
  a landed hook; a blocked cross; a slipped jab; a miss; a hit man with a punch due inside his stun, landing and not;
  a big shot; a body hook; step_in / step_out; a 30 s exchange with quiet spells).
- A sweep: 40 seeds of REAL beats built the way `tests/round_script_test.gd` builds them (`RoundScript.build`), each
  planned on [0, 30]; R1, R2, R3, R4, R7, R9, R10 and R12 hold on every one. Print one summary line:
  `CHOREO sweep seeds=40 punches=<n> landed=<n> cut=<n> slid=<n> misfit=<n> worst_ik=<m>`.
- Mutants: show the test can go red - at least three (e.g. a plan with one landed beat removed, a gap plan that jumps,
  a hit man punching inside his stun) built by editing a good plan in the test and running the checker over it. So
  write the rule checks as functions over a plan (`check_counts(plan, beats)` ...), used by both.
- The module loads the db with no scene: `JSON.parse_string(FileAccess.get_file_as_string(ClipCensus.DB_PATH))`.

## Prior research
`FIGHTPLAYER2_SCOPE_S510.md` (the design, two critics 7+), `FIGHTPLAYER2_BASELINE_S510.md` (why), `CLIP_CENSUS_S512.md`
(the takes: every punch lands from 0.53-1.03 m, none carries a step; hooks 0.76-0.90 m; uppercuts 0.53-0.86 m; 13 light,
8 medium, 5 heavy reactions may play), `UNDISPUTED_STUDY_S254.md` (control back 0.11-0.17 s), `REFERENCE_DISTANCES_S439.md`.

## What would a human do?
A fight choreographer blocks an exchange on paper first: where each man stands, who steps, which punch from which
distance, how the hit man goes and for how long he is out of it. Then the actors play it. This module is that paper.

## Prefab check
None fits: Godot has no fight choreography node and the motion-matching add-ons pick poses, not exchanges (scope 3e).

## The one trap
The census says no owned take lands from more than 1.03 m. Do not "fix" that by stretching a take's gap past its fit
bars: the feet close the distance (R5) or the plan logs a misfit. A plan that passes by widening FIT_M has failed.

## Deliverable
A PR that adds only the three owned files (more only if you split a file to stay under 500 lines; say so). In the PR body:
`RESULT: tests/choreographer_test.gd -> CHOREO failures=0` and the sweep line. Do not run or edit other tests.
