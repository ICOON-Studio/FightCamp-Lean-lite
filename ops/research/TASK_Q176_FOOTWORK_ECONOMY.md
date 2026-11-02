# TASK Q176 - QWEN - FIGHTERS HOLD THEIR GROUND AND EXCHANGE (footwork economy)
Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S77, 2026-09-25. Engine lane.

## Why
Operator, 2026-09-25, verbatim: "usually fighters are a lot more static ... you are moving them too much, they will
drain out energy, stamina, the mostly stay in place and try to exchange" and "they need side stepping faking and all
this things while their body doesnt move much". Measured on master with `Godot/tools/s77_camera_probe.gd`
(60 s, `frames=1800`, shot=broadcast): boxing seed 4242 A 54 m/min moving 84% of frames, B 49 m/min 77%;
seed 777 A 56/81%, B 44/72%; MMA seed 4242 A 32/41%, B 35/47%. Real fighters mostly stand, then burst.

## What would a human do?
A coach tells a fighter to stay in the pocket, reset with small steps and pivots, and spend his legs on the burst -
step in, exchange, step out - not on walking. A sports scientist measures time stationary vs moving and the
burst/pause rhythm (G100, Grok, same day - read `research/G100_TIME_MOTION.md` if it has landed; until then
use the PROXY targets below and mark them PROXY in the code).

## Do
1. DECOMPOSE FIRST. Before changing anything, print where each man's root travel comes from on the same seeds:
   engine positions (`FightRealtime` intent / `RingSpace`), the room's strike warp, `_place_bodies` placement,
   `_correct_refused_overlap` separation, walk-at-body-speed. Metres/min per source, per man. The fix goes where the
   travel is made, not where it shows.
2. Behind a NEW option `footwork_economy`, default OFF (OFF = byte-identical; prove with
   `Godot/tools/s70_feint_off_hash.gd` on boxing, kickboxing and MMA): the default state is HOLD GROUND - small pivots
   and side steps (about 0.3 m or less) to keep the angle, and BURSTS for exchanges (step in, strike, step out) with a
   pause between. Style drives volume: an out-boxer moves more than a pressure fighter, both far less than now.
   Footwork costs stamina: the existing `Stamina.movement_drain` at `FightRealtime.gd:2951` - check it is charged for
   every metre the body actually travels.
3. PROXY targets until G100 lands: moving (> 0.25 m/s) in 25-45% of frames; 15-30 m/min in boxing. Replace with G100's.
4. Engine anchors must not move out of band: D1 pace, landed/min, clinch share, leg share - print all, ON vs OFF.

## Population
Out-boxer vs pressure fighter with DIFFERENT stats (e.g. technique 70/58, power 55/68, speed 64/52, conditioning
58/66), legal for the ruleset; MMA grappler vs striker, both able to do everything. Name the population in every
tool's output. NEVER identical fighters (CLAUDE.md, no exceptions).

## Owned files
`Godot/scripts/FightRealtime.gd` (5,627 lines - NEVER open whole; `grep -n "footwork\|movement_drain\|evade_step"`
then `sed -n 'A,Bp'` windows at :876, :2812-2840, :2951), `Godot/scripts/FightFootwork.gd` (193 lines, read whole),
`Godot/scripts/FightWorldLiveScreen.gd` ONLY if step 1 shows the room makes the travel (~4,300 lines, windows only),
`Godot/tools/s77_camera_probe.gd` (read whole; its `footwork` line is your instrument), new `Godot/tools/q176_*.gd`,
new test `Godot/tests/fight_footwork_economy_test.gd`, `research/Q176_DIGEST.md`.

## Gate (tier: script edited)
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`: `git fetch origin && git checkout -B qwen/q176-footwork
origin/master`. Parse gate FIRST (`python Godot/tools/check_scripts.py <files>`). Then
`python Godot/tools/run_tests.py --only fight_realtime,fight_pace,feint,fight_room_,judge,stamina,fight_footwork`.
Prove the new test with a mutant. Commit explicit paths, push the branch, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q176 --body "<decomposition, ON/OFF moving% and m/min, anchors, OFF hashes, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Freezing the feet is NOT the fix - a man who never moves is as unreal as one who never stops. The body stays alive
in the posture (Codex C204 builds that layer); your job is the TRAVEL: less of it, in bursts, paid for in stamina.
