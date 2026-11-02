# TASK_C189 - the control arm: a clip we own, played WHOLE on our fighter, beside the vendor's video and our fight (Codex, full branch)

Model: gpt-6-astra, medium (motion on a skeleton - CODEX_MODEL=gpt-6-astra). Owner: codex. LAUNCHED S65 in parallel
with C187, 2026-09-24, on the operator's ruling (verbatim): "We are not buying other clips unless I see the quality
that I see on the YouTube preview videos. In our game, ask other agents why this is happening. Where, why is our
pipeline doesn't handle it like in the preview videos? I want this fixed." Grok G87 answers the same question from
shipped games; Cursor U158 fixes the kicks. Yours is the MEASUREMENT on our own tree.

## Why
The operator, 2026-09-24: "look how much smoother are the animation in these videos" - two RamsterZ Unity showcase
reels: `Hand to Hand attack animations set for Unity` (youtube.com/watch?v=bbJSJQ6dssw, 74 s) and `Martial Arts
Master Animations for Unity` (youtube.com/watch?v=duxvpZyNRdg, 11:29). **We OWN the first pack** (`Hand To Hand Set`,
124 FBX, `assets/anim/audition/ramsterz_h2h`, bound ~295 times in `FightClipBinding.gd`). So the SAME clips look
smooth in the vendor's reel and rough in our fight. The reel differs from our room in four ways, and nobody has
measured which one costs the most:
1. the reel plays each clip START TO END at native speed - our room enters strikes part-way (`seek_s`), changes
   tempo (`_tempo`) and cuts at the next engine beat;
2. the reel lets the clip's ROOT MOTION move the body - our engine owns position and a separate walk layer is
   spliced onto the legs (`FightBodyLayers`);
3. the reel is on the UE4 Mannequin the clips were captured on - ours are retargeted (`FightClipRetarget.gd`,
   `UE4_TO_OURS`) onto generated fighter meshes;
4. the reel pairs attack and reaction as captured - ours choose them separately.

## The experiment - four arms, one clip sequence, same camera
Pick 6-8 Hand to Hand clips that make a readable sequence (strike, strike, reaction). Record 10-15 s each arm:
- **A - the reel's conditions on OUR fighter**: each clip whole, native speed, its own root motion, no engine, no
  walk layer, no IK (a new `tools/c189_clip_whole.gd`).
- **B - A plus our retarget only** (if A already includes it, say so and split: vendor mannequin if we have its
  mesh, else document that A == B).
- **C - A plus the room's entry and tempo rules** (seek into the clip as the room would, `_tempo`, cut at a beat).
- **D - the live room on seed 92012** at a moment one of these clips plays.
Per arm print: per-frame max joint speed of wrists/ankles/hips, count of frames above a human ceiling (hand 12 m/s,
foot - ground it), foot skating (planted-foot drift), and the clip's played fraction. Then a 2x2 side-by-side
video (`research/_captures/c189_control_arm.mp4`, MP4 <50 MB) and a sheet. OPEN both.

## The answer it must give
Which of the four differences makes our fight look rough, ranked by the numbers AND by the video. If arm A already
looks rough, the retarget/rig is the problem and no pipeline fix will help; if A looks like the reel and D does
not, the room's playback is the problem. Name the population and the clips.

## Owned files
New files only: `Godot/tools/c189_clip_whole.gd`, `Godot/tools/c189_control_arm.py` (sheet/video), the mp4, the
sheet `previews/c189_control_arm.png`, `research/C189_DIGEST.md`. Read-only everywhere else.

## Gate (tier: new tool only)
`python Godot/tools/check_scripts.py Godot/tools/c189_clip_whole.gd`; no suite. Windowed runs through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.
Branch `codex/c189-control-arm`, worktree off `origin/master`, `--headless --import` once first. Commit, push, one
`agent_comms.py send --from codex --to claude --topic C189` per part. Do NOT edit HANDOFF.md.
Trap: an arm that differs in TWO ways at once answers nothing - change one thing per arm.
