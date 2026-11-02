# TASK K27 — KALLI — THE STANCE WE NEVER MODELLED, AND WHETHER IT CHANGES THE PICTURE

Research only. One deliverable file. No code, no test, no repo commands.
Owner: kalli. Task id: K27.
Deliverable: `K27_STANCE_AND_THE_SOUTHPAW.md`

## Why you are being asked this now, before we need it

We are building a 3D view of the fight. To show a punch, the view has to pick a
**hand** — lead or rear. Lead and rear are defined by **stance**: an orthodox
fighter leads with the left, a southpaw with the right.

And we have just found this in our own code, which is what makes the question
urgent rather than academic:

- The game's athlete records **do** carry a stance. Our older fight code reads
  `athlete.get("stance", "ORTHODOX")` and defaults everyone to orthodox.
- The **new real-time fight engine never reads it at all.** Grep confirms it: the
  only "stance" the live engine knows is a grappling posture (standing / clinch /
  ground). Orthodox versus southpaw does not exist in the fight.

So we are about to draw a picture that asserts a handedness the simulation has
no opinion about. Before we spend anything on clips, we want to know what stance
actually is and what it costs to get wrong.

## The questions

**1. How common is southpaw, really?**
In professional boxing and in MMA, what share of fighters are southpaw? Give the
best sourced figures you can find and say what population each figure covers
(champions? ranked? all licensed pros? one era?). If the figures disagree between
sources or between eras, **report the disagreement rather than averaging it** —
we would rather have two honest numbers than one invented one.

**2. Is it the same across the divisions and the sexes?**
Does the southpaw share differ by weight class, by sex, or by discipline (boxing
vs MMA vs kickboxing vs muay thai)? This matters because our roster is built per
division, and if we assign stance we will assign it per division.

**3. What does stance actually change in a fight — and is any of it visible?**
Separate two things carefully, because we will act on them differently:
   - **What it changes in the RESULT** (matchup dynamics, who tends to beat whom,
     the open-stance vs closed-stance difference, the lead-hand and rear-hand
     exchanges each produces, the specific shots each stance opens up).
   - **What it changes in the PICTURE** — what a viewer can literally see that
     tells them a man is a southpaw, in a single still frame and in motion.
   The second list is the one that decides whether we need mirrored animation at
   all, so be concrete: name the visible cues.

**4. Switch-hitters.** How common are fighters who change stance mid-fight or
mid-round, and is it a real tactical thing or a rarity? If it is real, it is a
much bigger ask of an animation system than a fixed stance, so we need to know
before we assume stance is a constant per fighter.

**5. THE ONE WE WILL ACT ON FIRST — our twelve.**
Our roster is twelve generated fighters. **If we assign each one a stance, what
distribution is defensible?** Not "make them all orthodox", and not "make half of
them southpaw" — what share, and why, given your answer to Q1 and Q2. Say it as
a number of the twelve.

**Refuse anything you cannot source, by name.** In K26 you refused an invention
by name — there is no BKFC women's welterweight division — and that refusal was
worth more than the rest of the document, because we would have built it. Do the
same here: if a figure does not exist, say it does not exist.

## Explicitly out of scope

- Anything about our twelve fighters' faces, skin tones or model quality. That is
  a known prompt defect already queued; do not revisit it.
- The ground game and grappling.
- Any code, any file path in our repository, any test command.

## Format

One markdown document. Open with a **DECISIONS** block of at most eight lines —
the numbers we should act on and the things you refuse — then the evidence. We
read the top and build from it.

**Send the finished file back.** Name it `K27_STANCE_AND_THE_SOUTHPAW.md`.
