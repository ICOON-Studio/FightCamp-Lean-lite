# R95 — THE TWELVE, LOOKED AT

Claude, 2026-09-10. The roster was **measured** by R76 and partly rebuilt by R77
(f06, f08) and R78 (f10's texture). Since those landed **nobody has looked at
the set as a set.** This is that pass: first-hand, off
`previews/fighters/contact_front.png` and `contact_faces.png`, both
rendered 2026-09-09 and therefore post-R77/R78.

It is a judgement, not a measurement, and it is deliberately separate from R76's
numbers — which were right, and which is exactly why they were not enough.

## Verdict in one line

**The bodies are shippable. The faces are not, and two of the twelve are
defects rather than weaknesses.**

## What is genuinely good, and should not be re-opened

- **All twelve read as athletes.** None looks like a base mesh with a texture on
  it. The musculature is credible under the stated girths.
- **The stature and girth pipeline works and is visible.** f03 (fly, 1.578 m,
  girth 0.942) beside f04 (middle, 1.739 m, 1.022) beside f02 (heavy, 1.930 m,
  1.184) reads as three different weight classes without a caption. That was the
  hard part of the whole pipeline and it is done.
- **R77's f06 fix HELD on the body.** Broad chest, thick arms, defined torso — it
  is no longer a lean lightweight wearing a light-heavyweight's label. R77
  claimed that and the render agrees.
- **Kit is discipline-correct**: boxers in trunks with wraps, MMA in shorts,
  bare-knuckle without wraps.
- **Twelve distinguishable people.** No two faces read as the same person.

## The defects, worst first

### 1. f10 is broken, and R78 did not fix him

He is chalk-grey where the other eleven are warm; the skin reads unlit and waxy,
the eyes are dead, the mouth is smeared. Beside f02 and f09 in the front sheet
he looks like a different render pass. **R78 spent a Ludo credit retexturing him
and the outcome is that he is now the palest of the twelve rather than the
waxiest** — the defect moved, it did not go. He is the one fighter that would be
noticed as wrong by a player.

### 2. f02 and f10 are THE SAME BODY

Both are **1.930 m, girth 1.184** — identical to three decimal places — and the
renders bear it out: same physique, same proportions, same silhouette. They are
differentiated only by head and shorts. Two identical bodies out of twelve is
visible on a roster screen, and the pair happens to include the fighter from
defect 1, so one regeneration could fix both.

### 3. Every one of the twelve is white or light-Mediterranean

No Black, East Asian, South Asian or dark-skinned fighter in a twelve-strong
boxing and MMA roster. This is not a stylistic choice we made; it is what the
generation prompts produced and nobody checked. It is a straightforward realism
failure about the two sports the game is actually about, and it is the finding
here with the widest reach — it is a PROMPT defect, so it costs nothing to fix
on the next generation and cannot be fixed by retexturing.

### 4. f08's face has a texture seam

Chalk-white face against a normally-toned neck, with a hard line where one ends
and the other begins, and eyes that do not sit in their sockets. f08 was one of
R77's two regenerations, so this survived a rebuild.

### 5. Eyes are the weakest feature across the roster

f03, f05, f06, f07, f10 and f11 all have unfocused, asymmetric or half-lidded
eyes. This matters more than its size suggests: the profile screen puts a face
in front of the player, and the eyes are what a person looks at first.

### 6. Hair is a shell, not hair

A solid form with painted highlights on all twelve. Because it is uniform it
reads as a style rather than a fault, and at gameplay camera distance it will
not be noticed — **listed so it is on the record, not proposed for work.**

### 7. Smaller, named, not urgent

- **f05** is softer and less defined than every other male, and sits next to f06
  in the sheet, which is the worst possible neighbour for him.
- **f02**'s bald scalp has a hard beige edge and the beard is a flat decal.
- **f06**'s bleached hair reads as a helmet; his face is one of the weaker ones
  even though his body is now one of the best.
- **Bare feet on the boxers.** Boxers wear boots. MMA is correctly barefoot.
  This is a kit gap, not a mesh defect, and it is a modelling job rather than a
  regeneration.

## The four that hold up unreservedly

**f01, f04, f09, f12.** If a screenshot is needed before this list is worked
through, use one of those.

## What I recommend, and what I did NOT do

**I spent nothing.** Regeneration costs Tripo and Ludo credits, the Ludo balance
is **4** after R94's spike, and R94 has just established that those same credits
buy 20 fight clips — which move the game further than a better face does. So
this is a record and a queue, not a work order.

When the roster is next touched, in this order:

1. **Regenerate f10** — it is the only entry that is actually broken, and it
   also breaks the f02/f10 duplication in the same pass.
2. **Fix the prompts before generating anything**, so defect 3 is corrected at
   the source rather than becoming twelve more retexture jobs.
3. **f08's face**, because a visible seam is a defect and not a preference.
4. Eyes, as a prompt/parameter change applied to whatever is being generated
   anyway — never as its own pass.

Everything below that line is preference, and preference does not get credits
while the animation library is the thing standing between us and a watchable
fight.

## The process finding

R76 measured chest-to-waist ratios, arm cross-sections, skin saturation and
warmth, and every one of those numbers was correct. **f10 still passed through
two rounds of work looking like a corpse, and nobody saw it, because nobody
looked.** R77 and R78 then each verified their own fix against the same kind of
metric that had missed the problem in the first place.

This is the same shape as the defect this project keeps finding in its code —
assertions that a thing is *permitted* rather than that it *occurs*, a green
suite over unreachable code. **A measurement is not a look.** Any future asset
pass ends with somebody opening the contact sheet.
