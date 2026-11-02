# TASK_U112 — 38 minutes of two-fighter 3D motion is already on this machine. Make it usable.

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `Tools\cursor_task.cmd <this file> <workspace>` — NEVER `cursor-agent` directly (it
builds the global Claude Code hook as PowerShell and evaluates it with bash, which kills every
shell command including `echo test`).
**Branch:** `cursor/u112-video-motion` · **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## WHAT EXISTS, MEASURED TONIGHT, AND NOBODY HAS EVER USED IT

`Tools/footage/track_pairs.py` (Claude, 2026-09-14) tracks video with MediaPipe Pose and saves,
per video, an `.npz` holding:

```
t     (F,)          seconds
img   (F, 2, 33, 5) x, y (PIXELS), z, visibility, presence
world (F, 2, 33, 3) METRES, hip-centred, per person
n     (F,)          how many poses were found in that frame
fps, size
```

**`world` is real 3D, in metres, for TWO people, every frame.** It has only ever been used to
measure scalars — turn rates, kick commit times. Nobody has turned a single frame of it into
animation.

**The inventory, measured 2026-09-21 by Claude** over
`C:/Users/user/AppData/Local/Temp/FightCamp-footage/track/*.npz` — 17 videos:

| video | frames | 2-person frames | seconds | mean visibility |
|---|---:|---:|---:|---:|
| `-vPZqptk8jo` | 6,139 | 5,933 | 118.7 | **0.898** |
| `HL261oRyURE` | 5,738 | 5,292 | 105.8 | **0.882** |
| `FCM7m6TJWUQ` | 6,056 | 2,525 | 50.5 | **0.877** |
| `XIja1S9SXI4` | 8,024 | 5,859 | 195.5 | 0.873 |
| `kuABaA2PY0U` | 5,505 | 3,095 | 103.3 | 0.815 |
| `wzUWvsviqTM` | 33,651 | 14,092 | 470.2 | 0.807 |
| `_Fc7QLzbQlQ` | 9,946 | 6,094 | 243.8 | 0.792 |
| `vOFmsN3JROs` | 6,277 | 3,998 | 66.7 | 0.742 |
| `xaXXD-w45b0` | 49,449 | 26,372 | 440.9 | 0.730 |
| `d_PSlBJheZI` | 33,699 | 19,879 | 331.6 | 0.711 |
| (7 more) | | | | 0.480–0.732 |

**TOTAL: 98,136 two-person frames = 38.1 minutes of paired motion.**

**START WITH THE THREE CLEANEST** (`-vPZqptk8jo`, `HL261oRyURE`, `FCM7m6TJWUQ` — about 4.5 minutes
between them at 0.877–0.898 visibility). Proving the pipeline on the cleanest four minutes is worth
far more than a first pass over all 98k frames, and a low-visibility file will make you debug the
tracker instead of your own code.

---

## THE JOB, AND ITS ONE GENUINELY HARD PART

Produce a **paired joint stream**: for each frame, both fighters' joints **in one shared world
space, in metres**, ready for a retarget pass that someone else will write.

**THE HARD PART, AND IT IS THE WHOLE TASK:** `world` is **hip-centred per person**. Fighter A's
landmarks are relative to A's hips; fighter B's are relative to B's hips. **So you get each man's
pose and NOT where the two of them stand relative to each other.** Reconstructing that is U112.

The only information about their relative placement is in **`img`** — pixel x, y plus MediaPipe's
`z` (a rough depth, in units of roughly the subject's hip width) and per-landmark `visibility` and
`presence`. You will have to get from pixels to metres. Things that are true and may help:

- A person's own `world` landmarks give you their **real size in metres**, and the same person's
  `img` landmarks give you their **size in pixels**. The ratio is a per-person, per-frame scale
  that converts that person's pixel offsets to metres — which is a monocular depth estimate you do
  not have to invent.
- Two fighters are on the **same floor**. Ankle/foot landmarks sharing a ground plane is a strong
  constraint and it costs nothing to use.
- The camera moves in broadcast footage. Say whether you assume a fixed camera, and if you do, say
  which videos that assumption survives.

**STATE YOUR METHOD AND ITS ERROR.** A reconstruction with a named error bound is a result; one
without is a guess. If the depth is only good to ±0.3 m, say so — that is still useful for standing
work and fatal for ground work, and the next task needs to know which.

## WHAT TO DELIVER

1. **`Tools/footage/pair_world.py`** — reads one `.npz`, writes a paired joint stream for a named
   time window. Pure Python/numpy. **No Godot.** (Godot is hard-crashing on this machine tonight,
   which is exactly why this half is yours: it can be proven without it.)
2. **A named, documented output format.** Fixed joint order, units in metres, attacker first,
   one file per clip. Write the format down in the module docstring — **another agent will write
   the retarget half against it and cannot see your code.**
3. **`research/U112_VIDEO_MOTION.md`** (≤120 lines): the method, the error bound, a per-video
   quality table, and **which videos are usable for STANDING work and which for GROUND work** —
   they will not be the same list, and that is the most valuable row in the file.
4. **`research/U112_check.py`** — a gate that must exit 0. It has to re-derive the headline
   numbers from the `.npz` files rather than read your output, and it must include at least one
   check that FAILS if the reconstruction is degenerate (e.g. both fighters collapsing to the same
   position, or the inter-fighter distance being constant).

## THE TRAPS, EACH ONE ALREADY PAID FOR

- **`pair_events.py` writes segments as `{start_s, end_s}` in SECONDS, not `[frame_a, frame_b]`.**
  `U109_check.py` and `U110_check.py` were both written against the wrong shape and both died with
  `KeyError: 0` on the first real events file, within an hour of each other.
- **A GATE AUTHORED WHERE ITS INPUTS DO NOT EXIST HAS NEVER BEEN RUN.** Run `U112_check.py` against
  real `.npz` files as the FIRST step after you write it, not the last.
- **NEVER GATE AN EXTREMUM.** U109 failed any video whose yaw MAX exceeded 2000 deg/s; Cursor
  passed it by filtering out every step above 1200 and reporting 1196.9 — the number set by the
  filter. Gate a p50 or p90. Where an extremum is artefact-dominated, DECLARE it rather than
  bounding it.
- **Identity must not swap.** MediaPipe stores poses in detector order and `track_pairs.py` says so
  explicitly: *"identity across frames is assigned later, never here."* Two men in a clinch swap
  detector slots constantly. If you do not handle this, fighter A becomes fighter B mid-sequence
  and every downstream frame is wrong. `Tools/footage/pair_events.py` already assigns identity —
  read it before writing your own.
- **Paths on the commit line** (`git add -- <files>`), `git status -s` first, `git show --stat HEAD`
  after. A previous Cursor commit swept two staged files it did not own.

## GATE

This task touches **no `.gd` file**, so there is **no parse gate and no Godot test**. The gate is:

```
python research/U112_check.py     # must exit 0
python Tools/footage/pair_world.py <one clean npz> <out>   # must produce output
git status -s                            # before staging
```

## WHY THIS MATTERS, IN ONE PARAGRAPH

Every other route to paired ground animation has been measured and failed. Text-to-motion returned
**one body** in 8 of 8 generations and never reached the floor; composing two separately generated
halves scored **0 of 36**; authoring from nothing is animator hours this project has never spent;
and buying it depends on a SKU nobody has found. **This footage is two real fighters, tracked
together, already on disk.** The operator's ruling on 2026-09-20 was *"i dont mind too much if some
body parts intertwine but the movements need to be accurate"* — and motion taken from real footage
is accurate by construction. That is why this is worth doing properly rather than quickly.
