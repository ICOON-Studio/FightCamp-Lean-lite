# R124 — HOW TO GET TO HUNDREDS OF CLIPS WITHOUT BUYING HUNDREDS OF CLIPS

Claude, 2026-09-12, answering the operator's "how we make them efficiently or we
get what it is needed to make them — research it and you can innovate."

**THE ONE-LINE ANSWER.** We do not need hundreds of authored clips. We need
hundreds of distinct **playbacks**, and the multiplier that gets us there is
**bone-masked upper/lower layering** — which we do not have, which costs nothing
to buy, and which simultaneously fixes the thing the operator watched go wrong
tonight: a man cannot walk and punch at the same time.

---

## 1. WHY THIS IS THE RIGHT FRAME

R121 measured a shipped boxing game at **~2,699 named fighter clips**, 333 of
them idle/stance alone. We have **41 clip files, 18 bound roles, 13 technique
ids**, and **14 of those 18 roles have exactly one take**.

Buying our way to 2,699 is not a plan. But the gap is not really 2,699 vs 13 —
**it is 2,699 vs 13 × (the multipliers we have turned on)**, and most of ours are
off.

---

## 2. THE MULTIPLIER LADDER, WITH WHAT IS ON AND WHAT IS NOT

| technique | on? | realistic distinct variants | honest ceiling |
|---|---|---|---|
| **Mirroring** (U41) | **on** | ×2 on any asymmetric clip | R121: Undisputed AUTHORED both stances 1,225/1,202 rather than mirror. A mirrored southpaw is subtly wrong — lead hand and hip mechanics differ. Fine at our scale, revisit if we go dense. |
| **Speed scale** (Q57, Q60) | **on** | ×3 perceptible | Beyond about ±15% it stops reading as a faster man and starts reading as fast-forward. Q57 flagged ±15% as INFERENCE, not measured. |
| **Slicing** (U40) | **on** | 1 combo file → 3 strikes | Only works where a combination clip exists. We have one. |
| **Phase offset** (R123, today) | **on** | continuous, on loops | Loops only. Fixes M18's "synchronised aerobics", does not add moves. |
| **Crossfade** (R120) | **on** | 0 new variants | Hides the seam; does not create anything. |
| **Sub-window variants** | **off** | idle is 4.667 s → ~4 usable 1 s windows | Only if the loop has internal variety. Our idle may not — unmeasured. |
| **Additive pose offset** | **off** | ×3–5 stances | Guard high/low, weight front/back. Cheap. Risk is breaking the rig's rest pose, which R108 already bit us on. |
| **BONE-MASKED LAYERING** | **off** | **×N per locomotion state** | **The big one. See below.** |

---

## 3. THE INNOVATION: BONE-MASKED UPPER/LOWER LAYERING

**The limitation as it stands.** Each body has ONE `AnimationPlayer`. On an
action beat the thrower plays a punch and the receiver plays a reaction, so
neither is free to play a walk cycle. R118 shipped movement anyway and the bodies
SLIDE during an exchange, because the punch clip owns the whole skeleton. The
operator's words: *"they move their legs but they do not move"*, then *"they just
appear at different place"*.

**The fix is not more clips. It is splitting the body.** Godot 4's
`AnimationNodeBlend2` carries a **filter** — a per-track allow list. Put
locomotion on the legs and hips, the action on the spine and arms, and the two
play at once on one skeleton.

**What that buys, arithmetically.** We own 4 usable locomotion cycles
(`WalkForward`, `WalkBack` bound; `WalkLeft`/`Right` measured but held back
because they carry 0.884 m of real travel and would fight the engine's driver)
and 13 bound technique ids plus 6 reaction/defence roles.

```
    4 lower-body states  ×  19 upper-body actions  =  76 distinct playbacks
    from 23 clips, with no purchase and no animator.
```

Add mirroring (×2 where asymmetric) and the speed band (×3) on top and the
countable space is in the hundreds — while the honest count of things a viewer
would call *different* is the 76.

**And it is not just variety — it is correctness.** A boxer throwing a jab while
stepping in is one movement, not two. Today we cannot draw it at all.

**THE RISKS, STATED UP FRONT:**
- **Hip ownership.** Both layers want the pelvis. Whichever layer owns it must be
  chosen deliberately, and the other must not fight it — this is where naive
  layering produces a man whose torso and legs disagree.
- **Our clips are not authored for it.** RamsterZ H2H strikes are whole-body
  takes with their own footwork. Masking the legs off a roundhouse will look
  wrong in a way masking the legs off a jab will not. **Expect this to work for
  punches and to need judgement for kicks.**
- **It must be WATCHED, not asserted.** Every failure this project has had in
  animation passed its own test first.

---

## 4. WHAT DERIVATION CANNOT MAKE, AND THEREFORE WHAT TO BUY

Derivation multiplies what you have. It cannot invent a motion that is not in the
set. Three things are in that category:

1. **Knockdowns.** You cannot derive a man falling over from a man punching. We
   have **2** takes; R121 measured 200 in a shipped boxing game. This is the one
   beat a player must not misread (G56).
2. **`boxing_slip_counter`** — 828 pooled fires, nothing owned, and it was
   watched degrading live on 2026-09-12. The single highest-demand unowned move.
3. **Genuinely new vocabulary** — muay thai knees and elbows from more than one
   angle (J23 is pricing this), and the ground game.

**Everything else on the "missing" list is a derivation or binding job, not a
purchase.** That is the finding that should sit beside J23 before Saturday.

---

## 5. ACQUISITION — ASSIGNED, NOT GUESSED

G58 is with Grok and covers: commercial text-to-motion services priced
(Cascadeur, DeepMotion, Plask, Move.ai, Rokoko, Kinetix), self-hosted models
(MDM, MotionGPT, T2M-GPT, MoMask) **with their licences**, video-to-motion from
footage we shoot, and what small teams actually did.

**THE LICENCE IS THE COLUMN THAT DECIDES IT and the reason this is a research
task rather than an afternoon.** Several open motion models are trained on AMASS
or academic mocap whose terms forbid commercial use of derived output. We ship
commercially. A generated clip we cannot legally ship is worth less than nothing,
because it looks like an asset until a lawyer reads it.

Credits on hand for the generated route: **Ludo 4**, **Motifect 60**, **Tripo
200 (expiring 2026-10-01)**. Tripo made the twelve fighters at 6 credits each
(Q63) — but Tripo is a MESH generator, not a motion one, so it does not answer
this question.

---

## 6. THE ORDER I WOULD DO IT IN

1. **Bone-masked layering.** Free, ×4 on the whole action set, and it fixes
   walk-while-punching. Biggest single win available.
2. **Sub-window and additive-pose variants of the idle.** Free, and idle is the
   worst ratio we have (333 vs 1) and the most-seen thing on screen.
3. **Bind the remaining locomotion.** 37 clips on disk, 2 bound. A binding job.
4. **Read G58, then buy knockdowns and `boxing_slip_counter`** — the things
   derivation provably cannot make.
5. **Only then** consider generated motion, and only with the licence in writing.

**Motion matching stays ruled out** (R121): it needs a dense database to select
well and would look worse than a crossfade at our scale.

---

## 7. "CAN WE BUILD OUR OWN MODEL, OR MASK THE RESULT?" — operator, 2026-09-12

### Masking: no, and it does not work mechanically either

A training-data licence attaches to the **provenance** of the output — the fact
that the model was trained on that data — not to how the motion looks after it is
retargeted, filtered or blended. Transforming it does not sever that, the
exposure lands on a shipped commercial product, and the project already has a
standing rule that no bought clip is ever passed to a generator. **Not pursued.**

The useful version of the question is the one below, and it has real answers.

### Why the open models are barred, verified

**AMASS is explicitly non-commercial and specifically bars TRAINING.** Its
licence "prohibits the use of the dataset to train methods/algorithms/neural
networks/etc. for commercial use of any kind" and directs commercial users to
`ps-license@tue.mpg.de`. **DOCUMENTED** — https://amass.is.tue.mpg.de/license.html

That is not a detail about one dataset. **HumanML3D is built on AMASS**, and
MDM, MotionGPT, T2M-GPT and MoMask are all trained on HumanML3D. So the entire
mainstream open text-to-motion line is barred to us at the root, whatever each
repository's own code licence says. **This is the single most important fact in
this document.**

### There IS a clean corpus, and it is not the one we need

**CMU Graphics Lab Motion Capture Database: free, and explicitly usable in
commercial products** — you may include the data in commercially-sold products;
you may not resell the data itself, even converted. **DOCUMENTED** —
https://mocap.cs.cmu.edu/ . 2,605 trials, 111 subjects.

**But its boxing is thin and not by boxers.** Counted from the published index:
**50 trials mention boxing or punching, of which 12 are labelled plainly
"boxing"** — subjects 13, 14, 15, 17, 79, 80. Those subjects' own headers read
*"various everyday behaviors"*, *"different walking styles"*, *"actor everyday
activities"*. It is people miming boxing, not boxers boxing. **Do not expect
shippable strikes from it.**

**Where CMU is genuinely strong is exactly our worst gap.** Hundreds of trials of
walking, running, turning, stopping, idling and everyday standing — and R121
measured our worst ratios as idle/stance **333 vs 1** and footwork **144 vs 2
bound**. CMU will not give us a jab. It may well give us the idles and the
footwork, free and commercially clear.

### Training our own: no, and the arithmetic says why

To train a generative motion model you need a corpus. The only corpus we can
legally train on is CMU at **2,605 trials** — against HumanML3D's ~14,600 — and
it contains almost no boxing. That is a weak model on the wrong data, plus GPU
weeks and ML expertise this team does not have. **The same time and money buys
far more through filming.**

### The clean route nobody can revoke: shoot it ourselves

Footage we record has **no licence question at all**. Provenance is entirely
ours, for training or for direct conversion. G58 is pricing monocular
video-to-motion and its failure modes (foot slide, depth ambiguity, fast limbs
motion-blurring) so this is costed rather than assumed.

**One commercial lead worth watching:** Rokoko's Text-to-Motion is reported to
run on **Rokoko's own proprietary dataset** rather than on AMASS, which would
make its provenance clean in a way the academic models are not. **NOT YET
VERIFIED — G58 carries it**, and the licence must be read before a euro is spent.

### Revised order, with this folded in

1. **Bone-masked layering** — free, ×4 on the action set, fixes walk-while-punch.
2. **Idle variants** from what we own — free.
3. **CMU for locomotion, idle and stance** — free, commercially clear, and aimed
   at our two worst ratios. Retarget cost only. **NEW, and it may be the best
   value on this list.**
4. **Buy what derivation cannot make**: knockdowns, `boxing_slip_counter`.
5. **Film our own boxing** if the vocabulary gap persists — clean provenance.
6. **Train a model: no.** Revisit only if a commercially-licensed boxing corpus
   appears.
