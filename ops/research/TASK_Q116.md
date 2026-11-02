# TASK_Q116 — QWEN — A CLINCH IS NOT A STATUE: HOW MUCH DOES IT MOVE, AND HOW FAST?

**Agent:** Qwen · **Model:** qwen3-coder · **Effort:** medium · **Fast:** off
**Launch:** from worktree `FightCamp-Q81`:
`Set-Location <wt>; Get-Content <this file> -Raw | qwen.cmd --yolo -m qwen3-coder`
(PowerShell reports exit 1 on the yolo warning — read the `.out` file, never the rc.)
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest other than your own
`research/Q115_CLINCH_DISTANCE.md`.

**Test tier — RESEARCH, no `.gd` touched: NO GATE AT ALL.** Not the parse gate, not a test.
`git status -s` before staging is the whole check. Your gate is your own check script.

---

## WHY THIS EXISTS

You measured in Q115 **how far apart** two men in a clinch are: hip-to-hip p50 **0.719 m**,
p10 0.709, p90 0.777, against a range control arm of 1.050 m, over 57 clinch frames from
13,542. That number is now being used to author a clinch pose.

**The next question is the one the authoring actually stalls on, and no study answers it.**
J32 (the clinch research memo, 2026-09-21) reports *"Grip changes / position switches per
clinch: **NOT FOUND**"* and *"Torso/hip separation in metres: **NO STUDY**"*. So there is no
published number for how much a clinch MOVES, and a hold authored without one is a statue —
two men frozen in contact, which is exactly what the game must not show.

**Our own footage can answer it**, with the instrument you already used.

---

## THE QUESTION, IN FIVE PARTS

Same method as Q115 — `Tools/footage/pair_world.py` (PAIR_WORLD v1) on the raw `track/*.npz`,
same clips, **same ≤ 0.80 m clinch rule you derived and published**. Do not re-derive the
threshold; cite it and apply it.

First, segment: a **clinch RUN** is a maximal set of consecutive frames classified clinch.
Report how many runs there are and their lengths. Then, **per run** and then pooled:

1. **Hip-separation excursion.** Within a run, the separation is not constant. Report
   `max − min` per run, and pooled p50 / p10 / p90, in metres. *This is the number that says
   how far the two men breathe in and out of each other.*
2. **Vertical excursion of each man's hips** (the bob) within a run — `max − min` of the hip
   midpoint's vertical coordinate, per fighter, in metres, pooled p50 / p90.
3. **Lateral excursion** — displacement perpendicular to the line joining the two hip
   midpoints, per fighter, in metres, pooled p50 / p90. *Weight shifting side to side.*
4. **Rate.** The dominant period of the hip-separation signal within a run, in seconds — zero
   crossings of the mean-removed signal, or an FFT peak; say which, and say plainly if the runs
   are too short to resolve a period at all. **"Too short to say" is an acceptable and valuable
   answer here; a fabricated period is not.**
5. **Run duration in seconds.** J32 says the MMA per-clinch episode median is NOT FOUND in any
   published study. Yours is a MEASURED number from our own footage — **label it exactly that
   way**: it is not a study, it is 3 clips of tracked video. Compare it to J32's boxing
   inference of 5.0–6.0 s mean per clinch (Davis et al., Olympic 2012, total clinch time ÷
   frequency) and say whether they agree.

## THE CONTROL ARM — NOT OPTIONAL

**Compute every one of 1–4 identically on RANGE frames** (> 0.80 m), segmented into runs the
same way. A clinch excursion of 0.06 m means nothing until you know what the same quantity is
when the two men are NOT clinched. A finding with no control arm is a fixture, not a
measurement. Put the two columns side by side in the headline table exactly as Q115 did.

## SAY WHAT THE SAMPLE CANNOT SUPPORT

Q115's 57 clinch frames are **0.4% of the corpus** and you already reported that moving the
threshold ±10 cm swings the p50 by 0.15 m. Sixty frames at 30 fps is about two seconds, and
it may be **one or two runs, not a population**. Report the run count FIRST, before any
statistic, and if it is under five runs say so at the top of the digest in bold and give every
figure as a RANGE, not a point — the way Q115 gave 0.72–0.87 m rather than 0.719.

**If widening the clinch threshold to 0.90 m buys materially more runs, report BOTH bands as
separate columns** and say which you would author against. Do not silently widen it.

**Name your population in the output** (which clips, how many frames, how many runs, what
threshold, what error bound). A measurement that does not name its population cannot be told
from a fixture later.

## OWNED FILES

- `research/Q116_CLINCH_MOTION.md` (new, the digest)
- `research/Q116_analyse.py` (new)
- `research/Q116_check.py` (new, the gate)
- `research/Q116_motion.json` (new, the numbers)

**Touch NOTHING else.** Do not edit `pair_world.py`, any `.gd`, or any Q115 file.

## THE GATE

`python research/Q116_check.py` **must exit 0**, and it must RECOMPUTE from the raw
`track/*.npz` — not read `Q116_motion.json` and agree with it. A gate that learns its answer
from the thing it is gating cannot fail. It must independently:

- re-segment the runs and assert the run count matches the digest;
- re-derive at least the pooled hip-separation excursion p50 and assert it against a **literal
  pinned to 3 decimal places** in the check script;
- assert the control-arm column exists and is a different number from the clinch column;
- assert a degenerate case: with the threshold set to 0.0 m the run count is 0 and the script
  reports "no runs" rather than dividing by zero.

## THE ONE TRAP

**A "run" of length 1 frame has zero excursion and a period of nothing.** If you pool
single-frame runs into the excursion statistics you will pull every figure toward zero and
report a clinch that does not move — which is the exact wrong answer, arrived at by arithmetic.
**Set a minimum run length, state it, and report how many runs you discarded to reach it.**

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push, then one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q116-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. Unstage `AgentComms/messages` before any commit that is not the mail.
