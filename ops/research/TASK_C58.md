# TASK C58 — CODEX — THE TWELVE, SEEN BY SOMEONE ELSE

**Owner:** codex
**Model:** the strongest **vision-capable** model your CLI offers, effort
**medium**, Fast **off**.
Reason: this is a looking-and-judging pass, not a build. If the model you are
on cannot open an image, it cannot do this task at all — see **The trap**.

## Why this exists

Twelve fighters were generated and rigged on 2026-09-08/09. Every claim about
them so far is **measured, never seen**: 22 Godot-profile bones each, T-pose
bind with arms 0.987–1.000 horizontal, stature 1.578–1.930 m by division,
girth 0.942–1.184, and a `walk_relaxed` clip proven to drive the skeleton.

None of that says whether they LOOK right. Numbers cannot tell you whether a
face is acceptable, whether the boxing four read differently from the MMA four,
or whether a 1.18 girth reads as a powerful heavyweight or as a barrel.

A bad fighter costs 5 credits to regenerate now, and much more once scenes are
built on it. **You are the second pair of eyes.** Claude is rendering the same
twelve under R76 and writing its own verdict in parallel. Two independent
verdicts on one roster is the entire point of this task.

**So do NOT read `research/R76_DIGEST.md`, any other `R76_*` file,
`HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, or any digest.** You
have a checkout and could read all of them; that is exactly why this is
written down. A second opinion that has read the first is not a second
opinion — it is an echo, and it is worthless here. Judge from the images and
from this file, nothing else.

## Order of work — this matters

**Section 1 is written BEFORE you look at a single render.** This is the same
discipline the project uses for a module and its test: a standard written
against the thing it grades only ever agrees with it. Fix your bar first, then
hold the roster to it.

**Start Section 1 immediately — it needs no images.** The renders are Claude's
job under R76 and may not exist when you begin. When Section 1 is written,
`git pull` and look in `previews/fighters/`. If the folder is not
there yet, Section 1 is still real work and is not blocked; wait for the
renders only for Section 2.

## What to produce

**ONE file**, `research/C58_THE_TWELVE_SEEN.md`. Two sections, in order.

### Section 1 — the bar (written first, no images open)

What does a fighter roster have to look like to ship in a commercial
management game in 2026? Be specific and testable, not adjectival. Name the
things you will check per fighter and say what a PASS looks like for each.
Cover at least: face, silhouette, kit read, hands, and whether two fighters in
the same division look like different people. Say what you would reject
outright. Six to twelve criteria is the right size; a list of thirty is not a
bar, it is a wish.

### Section 2 — the verdict (images open)

For **each of the twelve**, by filename, one line: **KEEP**, **BORDERLINE** or
**REGENERATE**, plus the single reason that decided it. Then answer these:

1. Do the four **boxing** fighters read as boxers and the four **MMA** as MMA
   fighters, or is the kit generic across the roster?
2. The four **bare-hand** fighters have NO finger bones by design — a gloved
   fighter never needs them — and the generation prompt asked for fingers held
   together. **This is the group most likely to have failed.** Are the hands
   acceptable at roster-screen size? Say it plainly if they are not.
3. Do the six **women** read as athletes, or as one body type reused?
4. The girth range is rendered for you at **0.94 / 1.00 / 1.18** on one
   fighter. Is `apply_girth` a shippable effect or a distortion? This single
   image is the most consequential one in the set — a distortion here means the
   physique system, not the meshes, is what needs work.
5. Does the stature spread (1.578–1.930 m by division) actually READ as
   different sizes, or do they look like one man scaled?

Close with **the regenerate list**: the filenames you would spend 5 credits
each on, in priority order, and an explicit "none" if that is the answer. This
list is the deliverable everything else supports.

Naming is `f<NN>_<sex>_<glove>_<weight>`: `box` boxing gloves, `mma`
open-finger, `bare` bare hands. Two male and two female per glove group.

## Owned files

- `research/C58_THE_TWELVE_SEEN.md` — the only file you create or edit.

Write no code. Do not edit `HANDOFF.md`. Do not touch the renders in
`previews/fighters/` — they are R76's output, read-only to you. If
you notice something that needs building, name it in one line at the end of
your document as a follow-up and stop there.

## Gate

**No suite run and no parse gate** — this task ships one markdown document and
no code. If you find yourself writing a `.gd` or `.py` file, that is scope
creep: stop and write it up as a follow-up instead.

## The trap

**If you cannot actually open and see the PNGs, say so in your report and
STOP.** Do not write a verdict from the filenames, from the measured numbers
quoted above, or from what this brief says was intended. A fabricated verdict
would falsely clear twelve fighters that nobody has looked at — worse than no
verdict, and exactly the failure this task exists to prevent. "I cannot see
these" is a complete and useful answer, delivered fast.

Second trap: **do not grade the RENDER.** Flat lighting, a plain background or
a dull camera angle are Claude's problem, not the mesh's. Judge the fighter. If
a render is too dark or too small to judge a face, name that file and say what
you need — do not guess.

## When you are done

Commit and push `research/C58_THE_TWELVE_SEEN.md` to `master`, then send
one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic C58-verdict --body "<one line: the regenerate count and the girth answer>"
```

Do not edit `HANDOFF.md` — Claude writes your block.

---

## RESUME (2026-09-09) — THE RENDERS ARE THERE NOW

You did this right the first time. Section 1 was written before any image
existed, and when the folder was missing you refused to invent a verdict.
**Keep Section 1 exactly as it stands — do not reword, re-order or 'improve'
it.** It is the bar, it was fixed before you looked, and rewriting it after
seeing the roster destroys the only property that makes it worth anything.

Replace ONLY the Section 2 body (the `STOPPED — renders unavailable` paragraph
and the regenerate line under it) with the real verdict.

`git pull` first. 94 PNGs are now in `previews/fighters/`.

### A NEW CONTAMINATION HAZARD — READ THIS ONE

The first verdict now exists and it leaks in three places you would hit by
accident. **All three are off limits:**

1. `research/R76_FIGHTER_REVIEW.md` — the other verdict. Do not open it.
2. `HANDOFF.md` — now carries an R76 block with the conclusions in it.
3. **`git log` / `git show` / the commit messages.** This is the new one. The
   commit subjects on master state the verdict outright. Pull with
   `git pull -q --ff-only` and do NOT read the log, and do not run
   `git show`, `git diff HEAD~n` or a GUI history over these commits.

If you see any of it by accident, say so in one line at the top of Section 2.
An echo that admits it is an echo is still useful; a silent one is not.

### What is in the folder

Six contact sheets, best entry points, each captioned per cell:

- `contact_front.png`, `contact_three_quarter.png`, `contact_back.png` — all
  twelve in T-pose, 4 or 6 across.
- `contact_posed.png` — all twelve on one held frame of `walk_relaxed`. This is
  the closest thing to a roster-screen look.
- `contact_faces.png`, `contact_hands.png` — head and hand close-ups.

Then the full-resolution per-fighter files, which is where a verdict should
actually be made — sheet cells are downscaled to 320-440 px and will make a
face look worse than it is:

- `f<NN>_<...>_front.png`, `_3q.png`, `_side.png`, `_back.png`, `_posed.png`,
  `_face.png`, `_hand.png` — 720x1080 or 1080x1080 each.

For question 4, the girth question:

- `girth_range_f01.png` — f01 at **0.94 / 1.00 / 1.18**, left to right, same
  camera and same light. This is the consequential image.
- `girth_range_f01_trunk.png` — the same three cropped to the trunk. Note the
  three stand at different distances from a 26-34 degrees lens, so compare
  each figure against its own proportions, not across the frame edge-to-edge.
- `girth_heavy_f02.png` and `_trunk.png` — f02 at 1.00 vs its shipping 1.184,
  which asks whether an already-heavy mesh doubles up.

And `lineup.png` — all twelve side by side at their own statures, for question 5.

### How they were rendered, so you can tell render from mesh

Neutral three-point directional light with a rim, mid-grey ground plane,
vertical FOV 26 degrees, each fighter loaded with `GLTFDocument`, scaled by
`FighterPhysique.describe` and stood on y=0. The four static views are the
T-pose bind; `_posed` and `_hand` are one held frame of `walk_relaxed`.
Every capture was luma-checked, so nothing here is a black or half-drawn frame.
**The second trap in the original brief still stands: judge the fighter, not
the lighting.** If a specific file is genuinely unjudgeable, name that file.

### Gate, unchanged

One file, `research/C58_THE_TWELVE_SEEN.md`. No code, no parse gate, no
suite, no edit to `HANDOFF.md`, and do not touch the renders. Commit, push,
then send the one-line report exactly as the original brief specifies.
