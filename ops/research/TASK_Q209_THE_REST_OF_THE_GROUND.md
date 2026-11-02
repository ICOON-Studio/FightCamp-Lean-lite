# TASK Q209 - QWEN - THE REST OF THE GROUND: GUARD, HALF, SIDE, MOUNT, SCALED BY SKILL (S114)
Owner: qwen (qwen3-coder, medium, `--yolo`). Assigned 2026-09-27 (S114). Branch `qwen/q209-ground-seats` from
`origin/master` AFTER Q208 (back control) is merged - Claude says which hash; own worktree. Claude merges.

## Why
Q208 calibrated the back seat on G142's two-stage pattern. The other four ground seats (guard, half, side, mount) still
run on uncalibrated odds. G143 section 7 (`research/G143_TOP_POSITIONS.md`, 102 lines - read it whole) gives the
same competing-risks table for all four; G144 (`research/G144_GROUND_SKILL_GAPS.md`, read whole) says how a
grappling skill gap and a fighter's style scale every row. Together they turn "the ground" from one average pair into
two real men.

Also owed from Q207: a fight-level check. Q207's census had KO/TKO given a knockdown at 81.5% against G140's ~63.5% -
most knockdowns end at once through `_go_down`. Measure it on the new graph and report it; retune the one-down
stoppage lambda only if it is still outside 55-72%.

## Prior research (checked S114 with `python Tools/prior_research.py`)
**BUILD ON THE GROUND GRAPH - DO NOT BUILD A SECOND MACHINE.** `Godot/scripts/GroundGraph.gd` (S57, wired S58 -
`S58_THE_GROUND_GRAPH_WIRED.md`) already holds the seat edge table, a skill-weighted chooser and hold decay, behind
`ground_arm` (default "current"; arms "decay", "graph", "both"). Traps sit on it behind `trap_arm` (`G72_TRAPS.md`,
`Q169_DIGEST.md`). G143's per-second hazards are WHEN and HOW OFTEN a seat exits; the graph is WHICH edge a man picks.
So: G143 Stage A rates set each edge family's per-second probability; the graph's chooser still picks the technique
inside a family; G144's skill scaling REPLACES the graph's `skill` term for those edges (read S58 section 1 - that term
once scored 0.000 silently; print it). Wire it under the graph arms, and state in the digest what `ground_arm=current`
does after your change. Also read: `G75_THE_MAN_UNDERNEATH.md` (bottom-man options), `G34_GRAPPLING_CONTRACT.md`,
`Q91_GROUND_PATHS.md`, `Q114_HOLD_CENSUS.md`, `Q26_LANDING_SEATS.md`, `G82_GRAPPLING_POSITION_TAXONOMY.md`,
`G142_BACK_CONTROL.md`, `G143_TOP_POSITIONS.md`, `G144_GROUND_SKILL_GAPS.md`. Takedown rates are already in
`J20_THE_VALIDATION_CORPUS.md` / `J33_WHAT_THE_SPORT_MEASURES.md` (G145 was cancelled as a duplicate).

## What would a human do?
A BJJ coach who corners MMA: from guard the bottom man sweeps, submits or stands (a wrestler stands, a BJJ player
sweeps); on top a wrestler passes and rides, a BJJ player passes to finish; in mount the top man punches or takes the
arm. A FightMetric coder counts each seat visit and codes how it ended. Build each seat as the coach describes it,
scale it by who the two men are, and measure it the way the coder counts it.

## Prefab check
None usable: this retunes our own engine. G143/G144 name the datasets (UFCStats, BJJ Heroes, Fares 2025, Stellpflug
2022; Sportradar per-seat control is commercial - not to be scraped). No Godot plugin models MMA ground seats.

## Build
1. For EACH of guard / half / side / mount, the Q208 two-stage pattern: Stage A one draw per second of competing risks
   from G143 section 7 exactly (per SECOND; convert once, named constants, cite G143), Stage B (locked) with
   lambda_finish / lambda_peel per seat; a peel returns to Stage A of the SAME seat. REPLACE the seat's old submission
   roll with Stage B - do not stack them (Q208's trap).
2. Flags from G143 section 7 (hw_power, light_pace, women, fence, hurt_bottom, posture_broken, crossface_on,
   high_mount, active_gnp, idle_top). `idle_top` (no strike, no pass for 6 s) is the stand-up rule; make the back seat
   use the same flag if Q208 did not.
3. G144 scaling on every Stage A row: `d20 = (actor_grapple - opponent_grapple)/20`, `clamp(base^d20, cap)`, then the
   style factor for the man's primary identity (bjj / wrestler / striker - derive it from the fighter's existing
   discipline and stats; no new stat), then the 55% seat-mass rule. Finish-given-lock is the SECOND roll of G144
   section 3 per hold. Apply the same scaling to Q208's back rows (G144 back table).
   **Regression: an equal 50/50 pair with neutral style must reproduce G143/G142 Stage A exactly** - a test asserts it.
4. G142 wiring from G143: back to_mount -> mount Stage A, esc_guard -> guard, esc_top -> 50% half / 35% side / 15% mount;
   every to_back enters Q208's back seat. Turtle (G141) is not side. Entry/exit events per seat:
   `{"type": "<seat>", "via": ...}` and `{"type": "<seat>_end", "to": <exit>, "t_s": ...}`.
5. Census tool `Godot/tools/q209_ground_census.gd`: forced-seat mode (10k visits per seat, clock off) for G143 7.5's
   visit bands, and a fight-level mode over real MMA bouts in THREE DIFFERENT populations (BJJ vs striker, wrestler vs
   BJJ, wrestler vs striker - never identical fighters, all MMA-legal and able to do everything). Name each population.
   Print achieved beside wanted for EVERY G143 7.5 band and every G144 section 5 gate, plus Q207's KO/TKO-given-KD.
6. `Godot/tests/fight_ground_seats_test.gd`: 20+ MMA seeds, each seat entered, reaches Stage B, exits by at least three
   routes, never resets silently; the 50/50 regression; a +40 BJJ bottom sweeps more than a +40 wrestler bottom, who
   stands more; boxing: zero ground-seat events.

## Acceptance (G143 7.5 and G144 section 5 - report hit/miss for each; a miss -> retune a lambda, never add a state)
Visit: guard median 10-15 s, mount 10-15, side 12-18, half 8-13; mount GnP stop 0.18-0.23; guard GnP <0.03; guard
stand+ref 0.30-0.38; side->mount 0.25-0.32; finish|lock mount > side > guard > half.
Fight: named-seat ground share 0.18-0.28; subs 0.17-0.21 of fights; KO/TKO 0.30-0.35; GnP KO/TKO 0.07-0.10; RNC
0.36-0.42 of subs; sub position back 0.40-0.50. G144: grappler beats striker 64-72%; BJJ winners by sub 35-55%;
wrestler winners by sub 8-18%; wrestler bottom stand-ups > sweeps > subs. KO/TKO given KD 55-72%.
If RNC overshoots, cut G142's finish lambda, not G143's; if arm-triangle undershoots raise side/mount lock_sub first.

## Gate (tier: script edited)
Check the PC first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1 means
stop and say so. Parse gate on every touched `.gd`: `python Godot/tools/check_scripts.py <files>`. Then
`python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,fight_knockdown_count,fight_stoppage_read,grapple,fight_scoring,fight_one_down,fight_back_control,fight_back_bands,fight_fence_pin,fight_ground_seats`
no worse than master at branch point (Claude names master's reds in that subset at launch). A pin your change moves:
list it with old/new and Claude re-pins. RUN THE WHOLE SUBSET. Never the full suite.

## Owned files
`Godot/scripts/FightRealtime.gd` (~7,000 lines after Q208 - NEVER open it whole; find anchors with
`grep -n "_grapple_ground\|_finish_submission\|_move_seat\|_near_wall\|SUBMISSION_OPEN_TICKS\|back_end" Godot/scripts/FightRealtime.gd`
and read `sed -n` windows), `Godot/scripts/GrappleSeat.gd` (small, read whole), `Godot/tools/q209_*.gd`, the new
test, `research/Q209_DIGEST.md`.

## Deliver
Commit and push AS YOU GO. Digest with the census tables (populations named, achieved beside wanted) first, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q209 --body "..."`. Do NOT edit HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md (logs). All research is open: root `RESEARCH_INDEX.md`.
**Trap:** G144's multipliers are per ACTOR of the row - a bottom-man row (sweep_rev, stand, bot_rec_*) takes the
bottom man's skill minus the top man's, not the other way round. Get the sign wrong and BJJ guard players stop sweeping
exactly when they should sweep most; the +40 BJJ-vs-wrestler test is there to catch it.
