# TASK_C191 - "They're still clipping": what passes through what, with C190 and U159 ON (Codex, full branch)

Model: `gpt-6-astra`, medium (3D animation work - operator ruling 2026-09-21). Owner: codex. Assigned S66, 2026-09-24.

## Why - the operator's verdict on take three, VERBATIM (2026-09-24)
"This video is much better I see still some moves are being executed extremely fast like uh, elbows I think and when
the hands like class but not uh, during the moving animation there is some uh, weird uh, hand movement let's say
They're still clipping, but it's much, much better than everything else. I've seen so far. Keep working on it."
Item 3 is yours: **clipping**. Items 1-2 (too fast, hands while moving) are Cursor U160, running in parallel.
Your C190 is merged (`strikes_play_whole`, default OFF); U159's `reactions_play_whole` is merged (default OFF). Take
four will be recorded with BOTH ON, so measure with both ON. G86 (`research/G86_PHYSICS_HIT_REACTIONS.md`):
physics does NOT fix clipping - so this goes ahead of C188.

## Part 1 - a census, not an extremum
Seed 92012 MMA, 60 s, the S65 demo pair (grappler 175 cm vs striker 185 cm - print it), `strikes_play_whole` and
`reactions_play_whole` ON; then the same with both OFF as the control. For every frame: the deepest interpenetration
between the two bodies, by PART PAIR (fist/forearm vs head, fist vs torso, shin vs thigh, torso vs torso, glove vs
glove, ...), measured on the POSED skinned bodies (the S57 lesson: a skinned mesh reports its import AABB - measure
the posed thing, e.g. bone-segment capsules at the rig's real radii, or sampled skin vertices). Then: share of frames
with any overlap > 3 cm, the longest run, and a table of which part pairs own the overlap-seconds, with the moment
(tick, what each man was playing) of the ten worst. Count what no owner covers (a strike past its target, bodies
in the clinch, a step into the other man) - an overlap nobody owns is the finding.

## Part 2 - fix the biggest owner in PLAYBACK / PLACEMENT
The likely families, in the order to check: (a) a landed strike that travels THROUGH its target - contact should
stop the fist at the surface it hits (your C190 targets Head/Chest/thigh - does the clip's reach exceed the gap at
contact?); (b) the two roots closer than the bodies allow while both play whole clips with source root motion (the
S62 `separation_floor` holds hips, not arms/heads); (c) the clinch. Fix the owner of the most overlap-seconds, behind
a room switch `contact_stop` (default OFF). Do not solve it by pushing the men apart until they never touch: a real
exchange lands at contact distance, and a fix that removes landed volume or widens the gap past J20's anchors is a
second defect (the S62 lesson: `separation_strip_velocity` cost 20% of landed volume and shipped OFF).

## Part 3 - evidence
The Part 1 table before/after. A 10 s side-by-side OFF | ON at the worst moment
(`research/_captures/watch_loop/c191_clipping_ab.mp4`, MP4 <50 MB, via `Tools\godot_hidden.ps1` and
`tools/record_room.gd`). OPEN it as a contact sheet before reporting.

## Owned files
`scripts/FightStagePlayer.gd` and `scripts/FightWorldLiveScreen.gd` (the switch, contact stop and placement only - Cursor
U160 edits strike-speed caps and the hand writer in the same files: keep to your functions; whoever lands second
merges), `scripts/FightSeparation.gd` only if Part 1 convicts placement, a new `Godot/tools/c191_clip_census.gd`, a new
`tests/fight_contact_stop_test.gd` (ON: a landed blow's effector stops within N cm of the struck surface, N justified
from the rig; OFF byte-identical; mutants caught), the mp4, `research/C191_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; `fight_contact_stop_test` with mutants; then
`python Godot/tools/run_tests.py --only fight_stage`, then `--only fight_world`, then `--only fight_separation`,
then `--only fight_strike_whole` (ONE `--only` per invocation; read `total=`). `fight_stage_realism_test` is a
documented CEILING red. Branch `codex/c191-what-still-clips` off `origin/master`. Commit, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C191 --body "..."` per part. Do NOT edit HANDOFF.md.
READ SCOPE: read any script/tool/test you need (large files in `sed -n` windows); EDIT only the owned files above.
Trap: an unchanged control proves nothing unless the instrument COULD have moved - run the census on a frame you know
overlaps (a clinch) first, and print it, before believing a zero.
