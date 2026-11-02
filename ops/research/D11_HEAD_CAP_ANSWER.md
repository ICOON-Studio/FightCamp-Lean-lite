# D11 — THE HEAD CAP, AND THE CONTROL THAT SEPARATES "CLEARED" FROM "ERASED"

**Agent:** Dola, fresh chat, her own nine-limb rig. No Godot, no checkout.
**Landed 2026-09-22.** Raw capture in the session scratchpad; this is the
curated result. Her tables are reproduced as given — they are HER rig's
numbers, not ours, and the job now is to run the same measurement on ours.

## THE QUESTION D11 ASKED

Three agents said her neck fix treated the symptom. Her shipped rule insets
both endpoints by their own radius —

```
thorax.p1.y = neckBoneY - r_thorax   # pull the top endpoint in by its own radius
neck.p0.y   = neckBoneY + r_neck     # pull the bottom endpoint in by its own radius
```

— which on our rigs took the neck from 0.0% to 92.6% (f01) and 92.2% (f02)
with zero overlap, and which she herself flagged as leaving a 0.0044 m neck
segment: effectively a sphere at the base of the skull.

## HER ANSWER: THREE ARMS, AND ONLY ONE WORKS

At stature 1.85 m (she also ran a second stature and the ratios hold):

| Arm | Neck exp. % | Head exp. % | Thorax exp. % | Neck segment (m) | Overlap (m) |
|---|---|---|---|---|---|
| **A** — her rule only, head untouched | 92.6 | 60.8 | 92.3 | 0.0081 | 0.0000 |
| **B** — head shortened only, thorax untouched | 91.9 | 94.3 | 0.0 | 0.0998 | 0.0000 |
| **C** — BOTH rules applied | **99.3** | **94.3** | 92.3 | **0.1090** | 0.0000 |

**Only arm C recovers the full authored neck length AND makes it reachable,
with zero overlap introduced anywhere, at both statures.** Arm A exposes the
neck but leaves it functionally gone; arm B restores its length but the base
stays buried under the thorax.

**Her recommendation: ship arm C — apply both offsets together.**

## THE REAL CONTRIBUTION: THE PRESENT RATIO

Codex's objection was the sharpest one put to her — *"92.7% exposed alone is
insufficient: accessibility can improve by DELETING PROTECTIVE GEOMETRY."*
She answered it with a control rather than an argument:

```
Segment Present Ratio = (measured axial extent / authored design axial extent) x 100

Reachable = high exposure AND Present Ratio >= 95%   -> obstruction removed
Deleted   = high exposure AND Present Ratio <  50%   -> geometry removed, not fixed
Obscured  = low  exposure AND Present Ratio >= 95%   -> geometry exists but blocked
```

Applied to her own three arms:

| Arm | Exposure % | Present Ratio % | Verdict |
|---|---|---|---|
| A | 92.7 | **7.4** | **DELETED, not fixed** |
| B | 91.8 | 91.3 | mostly present, base obscured |
| C | 99.4 | **100.0** | **reachable, intact** |

**This retroactively condemns the arm we already shipped.** Arm A is the rule
that is in the tree today, and by her own control it scores 7.4% present: the
neck did not become reachable, it became absent. A 92.7% exposure reading with
no Present Ratio beside it cannot tell those two apart.

**Her rule for every future reading: report the PAIR, `Exposure % | Present
Ratio %`, and pass only on `Exposure >= 90% AND Present Ratio >= 95%`.** That
is the measurement to run on our rigs, and it is the first thing S51's
successor should build.

## TYPED GRIPS — ONE CAPSULE OR NAMED ANCHORS

The three holds do not target the same surface: a collar tie takes the
upper-posterior neck and base of skull, a rear naked choke the mid-posterior
neck, a guillotine the anterior neck at laryngeal level, higher up. Her model:

- **one continuous neck capsule** for the collision and blocking volume, so a
  limb cannot pass through the neck whatever the grip, plus
- **three or four named anchor points** on the head-neck surface as grip
  targets, mapped to typed move requirements.

## WHAT SHE ARGUED AGAINST HERSELF, IN HER OWN WORDS

> *"You have just made the neck thinner at both ends to satisfy a percentage.
> The rule `boneY ± r` tapers every joint segment to a needle at both ends -
> scale this to spine, shoulders, hips, and you do not have an anatomical rig
> any more; you have a stick figure with collision balloons."*

She rates this a real risk, not a rhetorical one, and names exactly what she
is least sure of: **whether Present Ratio >= 95% survives on the SHOULDER
GIRDLE**, where segments overlap and the curves are compound, rather than on
a neck that is one simple segment between two bones. She is confident in the
neck result and explicitly not confident the pattern generalises unadjusted.

## WHAT THIS MEANS FOR THE NEXT STAGE

1. **Build the Present Ratio measurement on our rigs first**, and re-run it on
   the arm already in the tree. If it reads ~7% present here too, the shipped
   fix is an erasure and has to be replaced by arm C, not extended.
2. **Then arm C**, both offsets together — it is the only arm that passes her
   own pass window.
3. **Do not roll `boneY ± r` out past the neck** until the shoulder girdle has
   been measured, because that is the case she flagged and did not test.
