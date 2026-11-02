# TASK_M24 — MARIA — HOW THE GAS INSTRUMENT READS

**Owner:** Maria, art director
**No checkout, no shell, no Godot.** Reply in chat with the full text, then drop
`M24_GAS_INSTRUMENT.md` + `CLAUDE_LAND_NOTE_M24.md` into `_maria_delivery/` the
way M23 went, and send the mailbox ping.

## Why this, and it is the one instrument nobody has drawn

M23 landed and it held its boundary exactly — *"no positions, widths, or row
heights (layout owns geometry)"* — so it did not collide with G64, which is why
both could be assigned at once. This is the same arrangement again.

G64 changed one rule and only one. Verbatim, from its §4:

> **F.2 changes on this screen: two INSTRUMENTS, not two bars.** Health / damage
> is 1 bar + number. **Gas is a heart-rate integer + 20 px ring. No bar.**
>
> Why F.2 changes: R85R documented Undisputed as one health bar + one BPM
> integer, not two tanks; M13 refuses a stamina bar here. Two bars fight; bar +
> number does not.

So the fight-night HUD now carries a **3-digit heart-rate numeral at 18 px and a
20 px ring**, in a 220 × 24 box, and **no one has said what it looks like when a
man is fresh, working, gassed, or in danger.** G64 gave the box. You give the
states and the treatment inside it.

## What to deliver — art only, states and treatment, NO geometry

G64 §4 owns the box, the numeral size, the ring diameter and the stack order.
**You own:** what the ring's fill MEANS, which direction it fills, the named
stops, the second channel beside colour (M23's rule: *"never hue-only severity"*),
and the one qualitatively different state that says "this ends the fight".

1. **THE STATES.** Name them. How many discrete stops does gas have on this
   surface — M23 argued for *few named stops* over gradients, and the aviation
   reference (master caution ≠ yellow caution) applies here more than anywhere.
   For each stop: the BPM band it covers (John's J20 and the engine's stamina →
   BPM map in `FightHudRead` are the sources — ask by name if you need a
   number), the ring treatment, and the numeral treatment.
2. **THE RING.** Fills clockwise from 12? Depletes? Is it a fraction of max HR
   or of the fighter's own reserve? Pick one and say why the other misreads at
   a glance. What the ring does at each stop — fill %, hatch, rim.
3. **THE SECOND CHANNEL.** Per M23, hue alone fails CVD. What carries "gassed"
   beside colour — hatch, rim pulse, numeral weight? Give the rule.
4. **THE DANGER STATE.** The one that is *qualitatively* different: the state a
   corner reads as "consider the towel". Not a redder red. What is it?
5. **RIM TIMING.** M23 specified rim timing for region damage. Does gas pulse?
   If yes, the rate and what triggers it; if no, why a steady instrument reads
   better under a live clock.
6. **REFERENCES — what was taken and from where.** Same discipline as M23: name
   the game or instrument and the shot, and say what was taken versus what was
   refused. Bedside monitors and cycling head-units both show a live HR; say
   which reads better at 20 px and why.

## THE TRAP

**Geometry.** If you write a width, a height or a position, you have drifted
into G64's file. Your unit is the STATE and its TREATMENT.
**Second trap:** a bar. G64 removed it on purpose and gave the reason; a ring
that behaves like a horizontal bar bent round is the same instrument twice.

## Deliverable shape

Lead with three lines: the number of named stops, the one treatment you would
fight hardest to keep, and the one thing you are least sure about. Then the
numbered spec. Under 150 lines — this is one instrument.
