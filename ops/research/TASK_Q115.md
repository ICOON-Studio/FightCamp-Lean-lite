# TASK_Q115 — QWEN — HOW FAR APART ARE TWO MEN IN A CLINCH? THE MEASUREMENT NOBODY HAS PUBLISHED

**Agent:** Qwen · **Model:** its CLI default · **Effort:** medium · **Fast:** off
**Launch:** `qwen --yolo` from the repo root — NEVER `--approval-mode auto`, which leaves it with
no shell tool at all.
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest other than the two named below.

**Test tier: a MEASUREMENT plus its own check script. NO `.gd` is edited, so NO parse gate and NO
Godot test run.** `git status -s` before staging is the whole check.

---

## WHY THIS EXISTS

We are authoring a clinch as a held position and the engine will gate it on distance, exactly as
every existing pair record gates on `min_gap_m` / `max_gap_m`. **We went looking for a published
figure for how far apart two men stand in a clinch and there is none.** John's J32 memo
(`research/J32_WHAT_A_REAL_CLINCH_IS.md`) searched and recorded, in those words, **NO
STUDY** — while documenting plenty else, so the gap is real and not a failure of searching.

**So we measure it ourselves, and we already have the instrument.** U112 built
`Tools/footage/pair_world.py`, which puts both tracked fighters from broadcast footage into ONE
metric space. Read `research/U112_VIDEO_MOTION.md` first — it is short and it tells you
exactly what the tool is and is not good for.

## THE QUESTION

**In real footage, when two men are clinched, what is the distance between them — and how does
that compare to the same two men at range?** The comparison is the point. A single clinch number
with nothing beside it cannot tell us whether our authored 0.557 m hip separation is close or
absurd.

Report, in METRES:

1. **Hip-to-hip separation while clinched** — p10, p50, p90, and the sample size in frames.
2. **Hip-to-hip separation while at range**, same clips, same method, as the control arm.
3. **The ratio or difference between them**, which is the finding.
4. **Chest-to-chest and head-to-head** if the tracked landmarks support it — say so if they do
   not rather than deriving them from the hips.

## THE HARD PART, AND YOU MUST SOLVE IT EXPLICITLY

**Nothing in the data labels a frame "clinched".** You have to define it, and your definition is
the most important thing in the deliverable.

- **Derive the definition from the data, not from your intuition.** Look at the distribution of
  inter-fighter distance across whole clips first; a clinch should show up as a mode, not as a
  threshold you picked.
- **Whatever you choose, state it as a rule a stranger could re-apply**, and show what happens to
  your numbers when you move it — if p50 clinch separation swings wildly as the threshold moves
  10 cm, say so loudly, because then the answer is a range and not a number.
- **U112's digest says its method is NOT usable for "clinch with heavy occlusion"** and is
  side-on only. Take that seriously: pick the cleanest side-on clips it names
  (`-vPZqptk8jo`, `HL261oRyURE`, `FCM7m6TJWUQ` are the three with the highest visibility), say
  how many frames survived your filtering, and do not quietly include the clips it warns off.

**If the honest answer is that the footage cannot resolve a clinch, say that in one line at the
top and deliver the range-distance distribution anyway.** A clean NO with the control arm is
worth far more than a clinch number the method cannot support.

## THE GATE

Write `research/Q115_check.py` and **it must exit 0 on a real run**. It recomputes the
headline p50 from the raw tracks, asserts the clinch sample and the range sample are both
non-empty and DIFFERENT (if clinch p50 equals range p50 your separation rule did nothing — fail
loudly), and pins at least one literal a later reader can check by eye. Print `Q115_CHECK ...`
lines and `Q115_CHECK PASS`.

## DELIVERABLES

- `research/Q115_CLINCH_DISTANCE.md` — the four answers, your clinch definition stated as a
  rule, its sensitivity, the frame counts, and the clips used by name.
- `research/Q115_distance.json` — the same as data.
- `research/Q115_check.py` — exits 0.

Commit with explicit paths (`git add -- <files>`), push `qwen/q115-clinch-distance`, then:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q115-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. Do NOT edit any `.gd`.

## THE TRAP SPECIFIC TO THIS TASK

**`world` in the raw `.npz` is HIP-CENTRED PER PERSON**, so fighter 0's hips and fighter 1's hips
are both at their own origin. **Any distance you compute straight out of `world` is exactly zero
and completely meaningless.** That is the whole reason `pair_world.py` exists — use it, and say
in your digest that you did.

Second: U112 reports depth error at **±0.19 m on clean clips and ±0.35 m on noisy ones**, against
a clinch separation that is likely well under a metre. **That error is a large fraction of the
thing you are measuring.** Carry it into your answer explicitly — if your clinch p50 and your
range p50 differ by less than the depth error, your finding is that the method cannot separate
them, and you should say so rather than reporting the difference as real.
