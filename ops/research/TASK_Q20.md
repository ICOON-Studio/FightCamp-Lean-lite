# TASK Q20 — QWEN — THE SCALE AND THE MAN: DOES WEIGHT BELONG TO PERSONALITY?

Model: Qwen default, `--yolo`. Owner: Qwen. **Research only** — two markdown
files, no `.gd`, no JSON, no tests, no `HANDOFF.md` edit.
**QUEUED BEHIND Q19** (`GrappleSeat.gd`). Finish Q19 first; one task per
session. Assigned 2026-09-10.

---

## Why this is being asked

The operator asked on 2026-09-10 to "connect weight to personality". In the
game today, personality is a real field that **five** systems already read —
`CareerGoals.gd`, `CoachRapport.gd`, `FighterRequests.gd`, `Retention.gd` and
`WorldPopulation.gd` — and **nothing about weight reads it at all**. Weight is
pure physiology: a walk-around figure, a class limit, a diet plan, a
projection.

So the question is not "should we add a slider". It is: **is there anything
real to connect, and what is the ONE honest field that would connect it?**

You have the checkout, which the research specialists who normally take this
kind of study do not. **Use it** — question 5 wants real `file:line` anchors,
not a guess about how the game is put together.

## What to answer

Sources for each, and **UNKNOWN is a finding** — studies here have come back
thin before and been better for it. Never turn one fighter's story into a rate.

1. **Is weight-class choice documented as a disposition, or only as physiology
   and money?** What the published record says about *why* fighters sit where
   they sit — natural size, division depth, title availability, purse,
   matchmaker pressure. Separate documented fact from commentary.

2. **Missed weight: what actually happens, and how often?** Published penalty
   structures — percentage forfeits, bout cancellation, title ineligibility,
   commission action — and any published *rate*. If no rate is published, say
   so instead of estimating one.

3. **What is documented about a fighter refusing or abandoning a cut?** Moves
   up a division, retirements attributed to the cut, medical advice on record,
   any regulator or promotion rule that forces a move. This is the closest
   thing to a "personality" signal with a paper trail.

4. **Is there ANY published link between temperament and weight discipline?**
   Sports-science literature on weight-making behaviour, adherence and
   risk-taking in combat sports. If the link is not established, that is the
   answer and it settles the question.

5. **THE RECOMMENDATION, with anchors.** Read how personality is actually
   stored and consumed in this repo before recommending anything — start from
   `grep -n "personality" Godot/scripts/FighterRequests.gd
   Godot/scripts/CareerGoals.gd Godot/scripts/Retention.gd` and follow it.
   Then name **ONE field** that would connect weight to it honestly, say what
   it costs, and cite the `file:line` it would attach to. Price at least these,
   and propose another if you find a better one:
   * a **weight discipline** trait moving adherence to a `WeightCut` diet plan;
   * a **division ambition** that makes a fighter *ask* to move, riding the
     existing `FighterRequests` seam rather than adding a new one;
   * **nothing** — weight stays physiology, and the operator's instinct is not
     supportable on the evidence.

   Write the recommendation so it survives its evidence coming back UNKNOWN.

## Rules

* **Label authored invention as invention**, in as many words. That is how
  C31's corner rule is recorded and it is the standard here.
* Do not propose a second personality system. The game has one; this connects
  to it or concludes that it should not be connected.
* Do not re-derive what C52 settled about grades or what C54 settled about
  federation money. Cite them.

## Owned files

| File | Note |
| --- | --- |
| `research/Q20_THE_SCALE_AND_THE_MAN.md` | new. The study, with sources. |
| `research/Q20_DIGEST.md` | new. Short: decisions, explicit non-decisions, the one recommended field. |

**Read-only, and only what you need:** `Godot/scripts/WeightCut.gd` (248,
small, read whole) and targeted `grep -n` into the five personality consumers
named above. **`GameState.gd` is 14,386 lines — never open it whole**; grep it
and read `sed -n` windows only.

**Do NOT read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
digest, and do not explore to get oriented.

## Tests

**None.** This task changes no code, so there is nothing to parse-gate and
nothing to run. Do not run the suite.

## Done

Commit both files, push `master`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic "Q20-done" --body "<commit> <the one recommended field> <what came back UNKNOWN>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

**Report ambiguities rather than resolving them silently**, and say plainly if
the honest answer to question 4 is that there is no established link.
