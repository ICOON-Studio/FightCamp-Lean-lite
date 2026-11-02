# TASK_K73 - KALLI - WHAT THE CORNER SAYS WHEN A REGION CROSSES

**Owner:** kalli
**Delivery:** reply in chat, and drop
`_kalli_delivery/K73_REGION_SENTENCES.md` plus a land note. You never edit
`HANDOFF.md`.

## Why this completes a triangle three agents have already built

Three specs landed this week and they fit together without any of the three
authors seeing the others:

- **G64 / G65 (Grok)** own the GEOMETRY: six unmirrored region rows at 24 px, and
  a corner line that holds **60 characters hard at 14 px** with four alternate
  chips of **14 characters each**.
- **M23 (Maria)** owns the STATE: `fine / hurt / critical / doctor` with a second
  channel beside colour, and the thresholds `<=15 doctor, <=35 critical,
  <=55 hurt, else fine`.
- **K71 / K72 (you)** own the WORDS.

What nobody owns yet is the sentence for **the moment a region CROSSES a
boundary**. The region rows are live all fight; M23 says what state a region is
in; nothing says what the corner tells the fighter when his left leg goes from
`hurt` to `critical` between rounds.

## What to write

For each of the **six regions** (HEAD, TORSO, L ARM, R ARM, L LEG, R LEG) and each
of the **three downward crossings** (fine->hurt, hurt->critical,
critical->doctor):

1. **The corner line**, at most **60 characters**, that goes in G65's recommended
   slot. It is what the corner SAYS to the fighter, in a corner's voice, not a
   UI string.
2. **The alternate chip token**, at most **14 characters**, that would sit beside
   it - the verb the manager picks instead.
3. **COMPUTED or NOT COMPUTED**, per line, exactly as you labelled K72. If the
   engine cannot currently know the thing the sentence asserts, the sentence
   still gets written and it gets marked NOT COMPUTED - so nobody wires a line
   that lies about what the engine knows.

Then the **upward** crossing (a region recovering across a boundary between
rounds) - one line per boundary, not per region, unless a region genuinely needs
its own.

## The rules that govern the words

- **Under 60 characters a line.** G65's box does not grow; text over budget
  ellipsises. Count them.
- **A corner does not read out a number.** "Left leg at 34" is a HUD string, not a
  corner. The number is already on the row beside it.
- **Management sim.** The corner talks to the fighter. No "press X", no move
  names the player cannot select.
- **Do not lie about wiring.** That was the judgement K72 got right and it is the
  one that matters most here: a sentence that promises the fighter something the
  engine does not model is worse than a duller true one.
- **HEAD is not like the others.** A head crossing to `doctor` is the towel
  conversation. Say so in its own voice and flag it.

## Deliverable shape

Lead with three lines: the one crossing you think changes the fight most, the one
sentence you would fight hardest to keep, and the one thing you are least sure
about. Then the table - 18 downward rows plus the upward set.

## THE TRAP

**Writing the box instead of the words.** G65 already fixed 560x44 and 128x36 and
60/14 characters. You fill them. **Second trap:** re-deriving M23's thresholds -
they are `<=15 / <=35 / <=55` and they are settled; write to them, do not adjust
them.
