# TASK Q123 — QWEN — WHERE THE HANDS ACTUALLY ARE IN A CLINCH, MEASURED FROM THE PAIRED CORPUS

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch `qwen/q123-clinch-arms`
(Claude creates it from `origin/master` before launch — do not switch branches).
Push the BRANCH. Stage: S4e (ENGINE FIRST) support.

**Test tier: RESEARCH, PYTHON ONLY. NO `.gd` TOUCHED, SO NO PARSE GATE AND NO
GODOT AND NO TEST SUITE.** `python research/Q123_check.py` is the WHOLE
gate and must print `Q123_CHECK PASS`. **If it does not, do NOT commit and do
NOT push** — send the BLOCKED mail with its FAIL lines instead.

## Owned files

- `research/Q123_clinch_arms.json` — NEW. The machine-readable figures.
- `research/Q123_CLINCH_ARM_GEOMETRY.md` — NEW, **70 lines at most**.
- `research/Q123_measure.py` — NEW. The script that produces the JSON.

**Never edit `research/Q123_check.py`, `Tools/footage/pair_world.py`, or
any other existing file.** Read them; do not change them.

## Why this exists

Three times now an authored clinch pose has been built by a chat model that
cannot run Blender, and three times it has failed its own assertion. The latest
revision asserts the two fighters' hands finish **0.10–0.30 m apart** and it
lands at 0.693 m. **Nobody has ever checked whether 0.10–0.30 m is what a real
clinch looks like.** That is the gap this task closes.

Q115 already settled the BODY: at clinch range the hip midpoints are
**0.719 m** apart (p50), and that is a published, reproduced number. What Q115
did not measure is the **ARMS** — where the hands go, and how high. Without it
every clinch pose in this project is authored against intuition.

## The population, and it is FIXED

Three clean side-on standing clips, the same ones Q115 used, named here so the
result can never be mistaken for a fixture:

    -vPZqptk8jo    HL261oRyURE    FCM7m6TJWUQ

A frame counts as CLINCH when the two hip midpoints are **≤ 0.80 m** apart in
3D, after discarding anything **< 0.40 m** as physically implausible. That is
Q115's published rule and you do NOT re-derive it — this task measures arms
INSIDE that definition. There are **57 such frames**. That is a small sample and
the digest must say so plainly.

## Contract — exact key names, because an unseen gate reads them

`Q123_clinch_arms.json` is a flat object. For each of these six quantities emit
`_p10`, `_p50` and `_p90`:

| key | what it is |
|---|---|
| `hand_to_opp_neck_m` | every wrist to the OTHER man's neck, all four pairings pooled |
| `nearest_hand_to_opp_neck_m` | per man per frame, the CLOSER of his two wrists to the other man's neck |
| `hand_minus_neck_height_m` | wrist y minus opponent-neck y. **See the sign trap below.** |
| `hip_sep_m` | hip-midpoint 3D separation (reproduces Q115) |
| `stature_m` | nose-to-ankle height per tracked man — the ABSOLUTE control |
| `hand_to_opp_hand_m` | every wrist to each of the other man's wrists |

Plus `clinch_frames` — an integer, the pooled count.

**The neck is the SHOULDER MIDPOINT.** MediaPipe has no neck landmark. The
digest must SAY this in those words or the gate fails you — a reader will
otherwise assume a real neck joint.

## THE THREE TRAPS, and the gate checks all three

**1. Y RUNS DOWN, AND `Tools/footage/pair_world.py:41` SAYS IT RUNS UP.**
Measured on `-vPZqptk8jo` frame 0: nose y = **-1.272**, left ankle y = **+0.042**.
The floor at y ≈ 0 is right; "y — up" is WRONG. More negative is higher. So
`wrist_y - neck_y` POSITIVE means the hand is **below** the neck. Get this
backwards and every vertical conclusion inverts. Do not fix the docstring — it
is not your file; record the discrepancy in your digest.

**2. A RELATIVE FIGURE NEEDS AN ABSOLUTE ONE BESIDE IT.** A delivered clinch
pose was once reported with "hip separation exactly 0.72 m" while both men were
0.596 m tall and one had his head below his feet — because a separation is a
DIFFERENCE, and common-mode error cancels inside it. That is why `stature_m` is
in the contract and why the gate refuses a non-human value.

**3. THE SCALE ITSELF IS SUSPECT, AND YOU MUST REPORT IT.** Nose-to-ankle in
this corpus reads **1.31–1.37 m**. A 1.80 m man should read about 1.61 m (the
crown sits ~0.12 m above the nose, the ankle ~0.07 m above the floor). So this
reconstruction appears to under-read metric scale by roughly **15–20%**, and
**every metre figure in the corpus inherits that — including Q115's published
0.719 m**. Your digest must carry this caveat explicitly; the gate fails you if
the word "scale" never appears. Do NOT attempt to correct the scale — report it.

## What the digest must contain

`Q123_CLINCH_ARM_GEOMETRY.md`, 70 lines maximum:

- `## POPULATION` — the three clip ids, the 57 frames, the per-clip split, and
  one sentence saying this is a small sample of side-on boxing/sparring footage,
  not Muay Thai.
- `## RESULTS` — one table, one row per contract key, columns p10 / p50 / p90.
- `## WHAT THIS SAYS ABOUT AN AUTHORED CLINCH` — at most 15 lines. Answer one
  question with the numbers: **is 0.10–0.30 m between the two men's hands what
  the corpus shows, or not?** State the measured `hand_to_opp_hand_m` p50 and
  say plainly whether that assertion is supported. Do not soften it.
- `## CAVEATS` — the scale under-read, the ±0.15 m horizontal error Q115
  published, the 57-frame sample, and the shoulder-midpoint neck proxy.

## Gate

    python research/Q123_check.py

Must print `Q123_CHECK PASS`. It re-runs `pair_world` on all three tracks and
recomputes every percentile itself, so a figure you did not actually measure
will not survive it. A full run takes a few minutes.

## Commit

Stage ONLY your three owned paths with `git add -- <path>`; never `git add .`.
The worktree shows hundreds of modified `.import` files — Godot's churn, not
yours. Unstage `AgentComms/messages` before you commit. Never `git stash`,
`reset --hard`, `checkout .` or `clean` in this tree.

Then push the branch and send one line:

    python Tools/agent_comms.py send --from qwen --to claude --subject q123-ready \
      --body "<the branch, the sha, hand_to_opp_hand_m p50, and whether 0.10-0.30 m holds>"

Do NOT edit `HANDOFF.md`.
