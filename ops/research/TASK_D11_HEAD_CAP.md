# TASK_D11 — DOLA — THREE AGENTS SAY YOUR NECK FIX TREATS THE SYMPTOM

**Owner:** Dola. **Fresh chat** (operator rule 2026-09-22: every assignment
starts a new chat). You have no memory of the earlier thread, so everything you
need is below. **No Godot, no checkout.** Run your own rig, reply in chat with
the full text and the tables.

## WHAT YOU TOLD US, AND WE SHIPPED IT

You measured your own nine-limb rig and found the neck **92.7% exposed** where
both of our rigs and an independent third build read **0.0%**. Your diagnosis
was that the difference is **endpoint stacking, not radius**, and your rule was

```
thorax.p1.y = neckBoneY - r_thorax    // pull the top endpoint in by its own radius
neck.p0.y   = neckBoneY + r_neck      // pull the bottom endpoint in by its own radius
```

On our rigs that takes the neck from 0.0% to **92.6% (f01) and 92.2% (f02)**
with **0.0000 m** of overlap. **Your prediction was then confirmed the hard
way:** we narrowed the thorax from 0.1909 m to 0.1418 m — a real radius fix,
which worked for its own defect — and the neck stayed at **0 of 128**. You said
radius alone would not fix it and you were right.

You also flagged the cost yourself: with our dimensions the neck segment is
0.0594 m, inset from both ends leaves **0.0044 m**, and the capsule becomes a
sphere at the base of the skull. You argued that is more accurate, not less:
the old capsule *"looked like a neck but was unreachable"*.

## WHAT THREE OTHER AGENTS SAID, BLIND OF YOU AND OF EACH OTHER

We put the same question to Codex, Cursor and Qwen with no sight of your answer
or of one another. **All three accept your measurement and reject your fix as
the primary one.** Their words, compressed but not softened:

- **Qwen:** *"Dola's fix is acceptable in outcome but wrong in diagnosis. The
  head capsule's lower cap reaching 0.0724 m below the neck bone is the actual
  defect. Shorten the head capsule so its lower cap sits at the jaw/occiput
  line, and let the neck capsule occupy the space from there to the thorax. It
  will be short — maybe 3–5 cm — but it will be a real capsule, not a
  degenerate sphere, and it will be reachable by grip directions that approach
  from above and behind, which is where collar-tie hands actually come from."*

- **Cursor:** *"Shrinking the neck to 4.4 mm is not acceptable as a persistent
  anatomical model — only as a grip anchor, if grips are TYPED and other
  techniques (rear naked choke, guillotine) use different anchors. I would
  shorten the head capsule's inferior extent before mutilating the neck
  segment."*

- **Codex:** *"Acceptable as a local grasp target, not as a replacement for the
  whole neck's collision representation — those are different
  responsibilities."* And the sharpest line of the three: **"92.7% exposed
  alone is insufficient: accessibility can improve by DELETING PROTECTIVE
  GEOMETRY."**

**Two of the three independently proposed the same alternative.** On this
project that pattern has been right five times this month, so it is not being
put to you as a vote — it is being put to you because it deserves your answer.

**One fact in your favour that they did not have:** your own D8 answer already
contained the head caveat. You wrote *"the head capsule's own bottom cap may
still reach below the Head bone. If so, apply the same rule to the head:
`head.p0.y = headBoneY + r_head`."* We measured exactly that at **0.0724 m** on
f01. So you may have been first to the head and we under-read you.

## WHAT WE WANT FROM YOU

**1. Take the strongest version of their objection and answer it.** Is the
4.4 mm neck the fix, or is it what is left over after the real fix — shortening
the head capsule — has not been done? If you now think the head is primary, say
so plainly; changing your mind on evidence is worth more here than defending a
position.

**2. Run both arms on your own rig and give us the numbers side by side.**

- ARM A: your endpoint-inset rule on thorax and neck, head untouched.
- ARM B: head capsule shortened so its lower cap sits at the jaw/occiput, neck
  left at its full authored length, thorax untouched.
- ARM C: both.

For each arm report **neck exposure %, head exposure %, thorax exposure %,
the resulting neck segment length in metres, and any new overlap** your rule
introduces elsewhere. **Name the stature you ran at and run it at two** — one
near 1.00 m and one near 1.85 m — because a rule that does not scale is not a
rule.

**3. Answer Codex's objection directly, because it is the one that would
invalidate all of this.** If exposure goes up because protective geometry was
deleted, then a rig that reads 100% exposed everywhere is a rig with no body.
**What is the control that distinguishes "the neck became reachable" from "the
head stopped existing"?** Propose the measurement. We will run it on our rigs.

**4. Typed grips.** Two of the three raised it unprompted: a collar tie, a rear
naked choke and a guillotine do not grip the same place. Is one neck capsule
ever going to serve all three, or is the right model a small set of named
anchor points on the head-and-neck surface with the capsule used only for
collision? Short answer is fine if you have no measurement behind it — **say
which it is.**

## CONSTRAINTS THAT BIND EVERY ANSWER

- **A capsule endpoint is a BONE POSITION we cannot move.** Say for each change
  whether it is a bone move (we cannot do it) or an OFFSET applied in the
  capsule builder (we can). Your D8 got this right; keep it.
- **It must scale with stature.** No hardcoded metres. `boneY ± r` scaled with
  the rig is the shape we want.
- **We will not widen a pass threshold to make this land.** If your arm makes
  the measured number worse, report it worse. A change that makes the measured
  thing worse does not ship here even when its failure is informative — we
  reverted a pelvis fix this week on exactly that rule.

## AND THE LINE WE ASK OF EVERY AGENT

**Argue against yourself.** Take whichever arm you end up recommending and make
the strongest case you can that it is the wrong call. That half of the brief
has repeatedly produced a better answer than the recommendation itself — on the
knee rule this month, your own counter-argument is the reason the shipped rule
reads the way it does.

**Say which part of your answer you are least sure about.**
