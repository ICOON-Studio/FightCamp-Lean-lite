# TASK K17 — KALLI — THE PHONE / RELATIONSHIPS STUDY

Model: top tier, Fast off. Study only; Kalli pushes its `research/`
deliverables (HTML + PNGs + digest) and Claude writes the HANDOFF block.
Blocks nothing; not on the critical path of R28 or the RING build - start
whenever, no rush.

## Why now

K12's OFFICE + STAFF study named PHONE a real gap and explicitly kept it
off the shipped hub: "relationships are unfinished and must not be
dressed as a feature" (`research/K12_DIGEST.md`). Every other
pre-kit screen this programme is replacing now has a study behind it
(K8/K9/K10/K11/K12/K13/K15/K16); PHONE is the one named system with no
study and no build - not because it does not matter, but because nobody
has settled what it actually is yet.

## What exists today (read before drawing anything)

`CoachRapport.gd` gives a fighter x coach RAPPORT stat that already drives
training efficiency, the in-fight corner listen rate, and the between-
rounds corner reset - it surfaced on THE STAFF for the first time in R26.
Loyalty (`get_loyalty_summary` or similar - grep `loyalty` in
`GameState.gd`) already exists on the profile's CONTRACT tab. Check
whether there is a fighter-to-fighter relationship concept anywhere
(gym rivalries, locker-room dynamics) or whether "relationships" so far
means only fighter<->coach and fighter<->gym. Do not assume a system
exists that the code does not have; if there is nothing beyond rapport
and loyalty, say so plainly rather than inventing a richer state to
justify a screen.

## Questions this study settles

- **Does PHONE need to exist at all**, or is rapport (STAFF) + loyalty
  (profile CONTRACT) already the whole system, and "PHONE" was only ever
  a placeholder label from the legacy OfficeHub for a destination that
  should stay dissolved? Naming that verdict is a legitimate answer.
- If it should exist: **what does it add that rapport/loyalty do not**
  (a fighter's opinion of teammates, notable relationship events, a way
  the player reads "who is unhappy and why" in one place) - and where
  does it live (own rail item, a tab of STAFF, a tab of the profile, a
  drawer off a roster row)?
- **What would invent nothing look like here** - this is the system most
  at risk of turning into flavour text with no save-backed state behind
  it. Every instrument this study proposes must name the exact
  GameState read it would come from, the way every other K-study has.
- If the honest answer is "there is not enough real state to draw a
  screen yet," say what minimal GameState work (a Claude/Codex follow-up)
  would need to land FIRST before a second study could draw one.

## Kit rulings to obey (standing, same as every prior study)

Bebas / Plex; SIZE_MIN 12; gold ×1 per board if a board ships at all;
green = CONTINUE only; pair = slate; facility is GYM, never "camp";
females never fight males; silhouettes, never ripped art; invent nothing.

## Deliverables

`PHONE_K17.html` + PNGs for whatever boards/states the verdict actually
supports (a one-board "this is dissolved, here is why" verdict is a
complete and acceptable deliverable if that is the honest answer) +
`K17_DIGEST.md` in `research/`, matching the shape of every prior
K-digest (verdict, kit gaps if any, blockers).

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K17_DIGEST.md
```
