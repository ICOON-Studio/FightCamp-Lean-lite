# TASK_U159 - the receiver's reaction: entered at its first real motion, played whole, landing ON the blow (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S65, 2026-09-24.

## Why - the operator's priority
Verbatim, 2026-09-24: "We are not buying other clips unless I see the quality that I see on the YouTube preview videos.
... Where, why is our pipeline doesn't handle it like in the preview videos? I want this fixed." We OWN the reel's
RamsterZ Hand to Hand Set. Grok G87 (`research/G87_PREVIEW_QUALITY.md`) ranks the causes; Codex C190 fixes the
ATTACKER (a strike plays whole, hit on its contact frame). **Yours is the RECEIVER - G87 item D:** "Prefer vendor pairs
for attack + reaction. If no pair, still start both at t=0 and align on contact tags, not on independent beats."
Codex C189 measured the owned reaction clips: `H2H_HitReaction01/02` have **2.5 s / 3.1 s of leading unkeyed time** -
a reaction started at frame 0 moves seconds after the blow, and one seeked by a guessed offset can start mid-flinch.

## Part 1 - measure how reactions are played now
Seed 92012, MMA (the S65 demo pair: grappler 175 cm vs striker 185 cm - print it). For every landed blow in 60 s:
the attacker's contact time on screen, the reaction clip chosen, its native length, the offset it was entered at,
its FIRST KEYED MOTION time (the first frame any bone moves > 1 cm from frame 0 - measure it), the tempo, when the
receiver's head/torso actually starts to move, and whether the reaction was cut before it returned to guard.
Report: the lag from blow to visible reaction (median, p90) and the share of reactions cut before recovery.

## Part 2 - fix it in PLAYBACK (never in clip data)
A reaction is entered at its first keyed motion (or its own impact frame if it has one), timed so its onset lands
on the attacker's contact frame (use Qwen Q167's `assets/data/clip_phases.json` when it merges; until then your own
Part 1 measurement), played at speed 1.0, and never cut before it returns to guard unless the receiver is hit
again. Where the attacker's clip has a vendor PAIR partner (`PairedStagePlayer` / `FightClipBinding` paired
bindings), prefer the pair. Behind a room switch `reactions_play_whole`, default OFF until the operator's A/B.
Coordinate with Codex C190 (it owns the attacker's strike timing and the `strikes_play_whole` switch) - merge
whichever lands first and build on it.

## Part 3 - evidence
Blow-to-reaction lag before/after; a 10 s side-by-side OFF | ON on seed 92012 at a moment with 3+ landed blows
(`research/_captures/watch_loop/u159_reactions_ab.mp4`, MP4 <50 MB). OPEN it before reporting.

## Owned files
`scripts/FightStagePlayer.gd` (reaction playback only - C190 edits strike playback in the same file; keep to
reaction functions), `scripts/FightWorldLiveScreen.gd` (the switch and the reaction call site only), a new
`Godot/tools/u159_reaction_probe.gd`, a new `tests/fight_reaction_whole_test.gd` (switch ON: no reaction starts before
its first keyed motion or after the blow + 1 frame; none cut before recovery unless re-hit; OFF byte-identical - prove
with mutants), the mp4, `research/U159_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; `fight_reaction_whole_test` with mutants caught; then
`python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,fight_reaction`.
`fight_stage_realism_test` is red at baseline with 8 fails - a CEILING. Windowed runs through `Tools\godot_hidden.ps1`.
Branch `cursor/u159-reactions-whole`, worktree off `origin/master`, `--headless --import` once first. Commit, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U159 --body "..."` per part. Do NOT edit HANDOFF.md.
READ SCOPE: read any script/tool/test you need (large files in `sed -n` windows); EDIT only the owned files above.
Trap: a reaction that is on time but starts already mid-flinch is still a bullet - check the first keyed motion, not the clip start.
