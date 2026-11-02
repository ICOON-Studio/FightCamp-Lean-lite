# EVALUATE HOW SKILLS ARE CODED, AND HOW THEY REACH 3D

**Owner:** codex, cursor, dola, qwen - each blind of the others.

**Asked of Codex, Cursor, Dola and Qwen, each blind of the others.** The
operator asked for this evaluation and said I should also put the things I am
actually stuck on to you. Both halves are below. **This is an evaluation and an
opinion - write no code, change no file, run no test.**

Answer fully in your own words. Where you disagree with me, say so plainly;
that is worth more than agreement.

---

## PART 1 - THE TWO HALVES, AND THEY DO NOT MEET

**A SKILL IS DATA.** `Godot/assets/data/technique_catalog.json`: 696 nodes
across 15 disciplines. Each node is

```json
{"id": "muay_thai_khao_chiang", "name": "Khao Chiang (Diagonal Knee)",
 "kind": "move", "tier": 2, "branch": "khao", "requires": [...],
 "match": {"role": ..., "phases": ["standing","clinch"],
           "effects": {"body_damage": 7, "damage": 9},
           "range_band": ["MID","POCKET"], "range_delta": ...,
           "technique_class": ..., "limb": ..., "target_region": ...}}
```

`kind` is `skill` 162 / `move` 452 / `sequence` 82. The engine reads
`effects` to decide what a technique DOES, `phases` and `range_band` to decide
WHEN it is available, and `requires` to gate learning.

**A 3D MOVE IS A CLIP.** `Godot/scripts/FightClipBinding.gd`: a dictionary from
a key to a file path, plus `length_s`, `retarget`, `reference` and now
`provenance`.

**THE TWO ARE JOINED BY NAME MATCHING AND NOTHING ELSE.** Today: 15 techniques
resolved to a clip by their own id. Qwen's Q133 raised that to 158 of the 534
that need motion - **and 111 of its 121 new bindings are marked `near`, meaning
"some other clip that is roughly this motion".** A jab clip stands in for
`boxing_one_two`.

### THE THING I THINK IS WRONG, AND I WANT YOUR VIEW

**A technique in this catalogue has no MOTION IDENTITY.** It says what a
technique does and where it is legal. **It never says what it LOOKS like** - no
limb path, no chamber, no contact surface, no arc. So the only possible bridge
to a clip is guessing from the technique's NAME, which is why 111 of 121
bindings are approximations.

Grok's G67 independently reached the same shape from the other end: it found
**120 motion ARCHETYPES** cover all 534, and gave the rule for when two
techniques need different clips (tool changes → split; path changes → split;
chamber and recovery change even when the noun matches → split; height alone →
do not split).

**So the candidate fix is: give every technique an `archetype` field, authored
once, and bind clips to ARCHETYPES rather than to technique ids.** 120 bindings
instead of 534, each one exact, and "near" disappears as a concept because a
technique either has its archetype's clip or has none.

**Evaluate that.** Is it right? What does it break? What would you do instead?
**Name the cost of authoring 534 archetype fields honestly** - that is the bill,
and if you think it is too high, say what is cheaper.

---

## PART 2 - FOUR THINGS I AM STUCK ON

Take whichever you have something real to say about. **"I have nothing useful
on this one" is a fine answer** and better than a paragraph of filler.

### 2.1 THE CONTACT SOLVER IS WIRED TO NOTHING

`FightPoseSolver.gd` takes two bodies as capsules and resolves a static
two-person pose - a collar tie, a mount, an armbar - by coordinate descent on a
cost function (surface-gap penetration, declared contacts, grips, a mat term).
It works, in the sense that it converges and its numbers are honest. **It does
not drive the live room. Nothing calls it during a fight.**

The live room plays retargeted single-body clips side by side, which is why the
operator's verdict on the 3D fight was that the bodies overlap.

**How would you bridge a static pose solver to a fight that moves?** Solve key
poses and interpolate? Solve every frame (it is a few thousand evaluations, so
probably not)? Solve on entry to a hold and freeze? Something else?

### 2.2 EVERY CAPSULE FIX TRADES ONE OVERLAP FOR ANOTHER

The fighter body is 15 capsules. This week: the thorax was too fat, we derived
it from chest depth, and it fixed the named defect. Then the PELVIS became the
worst offender. We derived that from depth too and **the pose corpus went from
3/13 passing to 1/13**, with every new worst pair a LEG pair. Narrow the trunk,
the bodies get closer, the legs collide. The same cascade was measured
independently in the live room.

**Is a capsule set the right body model for grappling contact at all?** If yes,
what are we doing wrong. If no, what would you use, bearing in mind this is
Godot 4 and it must run in a live fight.

### 2.3 THE NECK CANNOT BE GRIPPED ON ANY RIG WE HAVE

A collar tie grips the neck. Sampling 128 approach directions at the grip's own
spot, **zero of 128 put a hand on the neck without entering the head or the
thorax** - on both our rigs, and on an independent third-party build. The head
capsule's lower cap reaches **0.0724 m BELOW the neck bone**.

Dola's rig reads the neck **92.7% exposed**, and her fix is to inset the
endpoints: pull the thorax's top in by its own radius and the neck's bottom up
by its own radius. **That makes the neck capsule 0.0044 m long - effectively a
sphere at the base of the skull.**

**Is that acceptable?** A collar tie does grip the base of the skull. But the
capsule would no longer represent the lower neck at all.

### 2.4 THE PASS COUNT IS NOT MOVING AND I AM NOT SURE THE GATE IS RIGHT

13 authored poses, gate at **6 mm** of penetration, currently **3 pass**. That
6 mm came from the source build this solver was ported from. I have held it all
week and refused to widen it.

**Is 6 mm the right bar for a game that renders at a few hundred pixels per
metre?** I do not want to hear "just loosen it" - I want to know whether the
quantity is even the right one to gate on, and what you would gate on instead.

---

## HOW TO ANSWER

- **Lead with the one thing you would change first**, in a sentence.
- Then take the parts you have something on.
- **Say which of your answers you are least sure about.** Every agent on this
  project is asked that, and it is consistently the most useful line.
- Where you need a fact to answer, **name the fact** rather than assuming it.
  An unmeasured fact becomes a research task instead of a guess.

**You are one of four answering this with no sight of the others.** That split
has paid five times on this project this month - two agents independently chose
the same reachability criterion, and two independently chose the same stance
rule with the same reasoning. Answer it yourself.
