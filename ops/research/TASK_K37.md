# TASK K37 — KALLI — ABSOLVER'S MOVES IN FRAMES: HOW LONG AN ATTACK TAKES, HOW IT CHAINS, HOW A HIT IS RECOVERED FROM

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (the joins, R5) - forecast research for a capture.

**Research only.** No code, no downloads, no game files, no datamined or decrypted data. Prose, numbers, citations.
One pass. Reply in this chat.

## Why this exists

Our fighters' animations are correct one at a time, but the JOINS between clips move faster than real motion.
The operator owns Absolver (Sloclap, 2017), a melee martial-arts game praised for how its attacks flow into each
other, and we plan to measure its transitions from screen captures of offline play. Before we capture, we want
the timings its developers and its community have PUBLISHED, so the capture has an independent number to agree
or disagree with.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Absolver's design principle: every attack begins in one of four stances and ends in one (often a different one),
  so the next attack starts from the pose the last one ended in (our J19, via Eurogamer).
- Real boxing punch timings (our K32/K33) and what NBA 2K published about transitions (your K34: no timings).

## What to find - one table row per finding

1. **Attack frame data**: startup (input to hit), active, recovery (hit to next input or back to guard), total -
   in frames or milliseconds, and the frame rate the numbers assume. Per attack where a table exists (e.g. the
   Absolver wiki, community spreadsheets, Reddit / Steam guides with measured data), with the attack's name, style
   and its start and end stance. If the game exposes a speed stat (e.g. "speed" / "fast / medium / slow"), give
   the ranges per class.
2. **Chaining**: the window in which the next attack of a combo can be input; how an alternate (the second attack
   bound to a slot) or a stance change alters timing; what the game calls the rules (combat deck, stances,
   alternates, "combo"), with any numbers.
3. **Defence and hit timings**: block, parry, dodge / avoid, absorb (Forsaken) and the Windfall / Stagger timings -
   active and recovery frames; how long a hit stun / stagger lasts; the time from being hit to being able to act
   (the recovery a hit reaction imposes).
4. **Sloclap's own words** on the animation system: talks (GDC, Unreal Fest, Unreal Engine livestream), developer
   interviews or blog posts about how attack animations were authored, blended or chained - with any numbers.
5. **Whether Absolver has an OFFLINE mode** a solo player can use without an account, and what it requires.

## Rules

- Label every row: **DOCUMENTED** (the developer's own words, patch notes or the game's own UI text),
  **SECONDARY** (a community wiki, guide or measurement - say who measured and how), or **NOT FOUND**. Never fill a
  cell with a guess. No datamined or decrypted game files.
- Every row: the finding, the source (title, author, date, URL).

## Deliverable

One markdown table per section (1-5), columns: Finding | Number or rule | Label | Source. Then a short **GAPS**
list, and one closing paragraph: the three timings a screen capture of offline Absolver play could check most
reliably, and why.

## Owned files

- `research/K37_ABSOLVER_FRAMES.md` - Claude writes it from the reply; Kalli pushes nothing.
