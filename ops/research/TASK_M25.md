# TASK_M25 - MARIA - HOW "RECOMMENDED" READS WITHOUT COLOUR

**Owner:** maria
**Delivery:** reply in chat, and drop `_maria_delivery/M25_RECOMMENDED_STATE.md`
plus a land note. You never edit `HANDOFF.md`. **NO geometry** - G65 owns every
pixel here.

## Why you, and why now

G65 landed the between-round surface. Its section 3 is a corner instruction tray:
**one recommended slot at 560x44**, then **four alternate chips at 128x36**, then
a confirm line. The geometry is fixed and it is not yours.

What is not specified, and is exactly the channel you own after M22 and M23, is
**how a viewer knows which one is recommended** - and then how they know the tray
has LOCKED at REST 0:10 and can no longer be changed.

M23 did this job for the region rows: state -> fill% -> hatch, a second channel
beside colour, no hue-only stops. M24 did it for the GAS ring. This is the same
discipline applied to a control's *state* rather than a readout's.

## What to specify

1. **RECOMMENDED vs ALTERNATE.** How does the 560x44 slot read as the
   recommendation without relying on hue alone? Name the channels in priority
   order and say what each carries. At least one must survive a greyscale print
   and at least one must survive a viewer who cannot distinguish red from green.
2. **FOCUSED vs ACCEPTED.** Focus lands on recommended at 1:00; the manager may
   accept it or pick an alternate; the accepted one is what runs next round.
   **Three states, not two** - focused, accepted, neither - and a viewer must tell
   accepted from merely focused at a glance. This is where most UIs fail.
3. **THE LOCK AT 0:10.** At REST 0:10 the tray locks on the last accepted id and
   stops taking input. How does locked read as *different from disabled*? A
   locked control that looks broken makes the manager think he missed something.
4. **THE DANGER CASE.** When `FightStoppageRead.severity` is high, K72's danger
   sentence goes in the recommended slot. G65 explicitly says the slot does NOT
   change size and does NOT move the towel. So the *qualitative* difference has
   to be carried entirely by your channels. Say how - and say what you would
   refuse to do here even though it would be legible, and why.
5. **NEVER.** A short list, as you did in M24. Name the treatments that would be
   wrong for this control and the reason for each.

## The rules

- **No geometry.** No positions, no widths, no row heights. G65 owns those and
  the three specs stay un-collided precisely because nobody crosses.
- **Never hue-only.** M23's rule and it holds here.
- **Never continuous throbbing** on the danger state - M24's rule, same reason.
- **Reuse M22's tokens** where they already say the thing. A new token is a cost;
  say why each one is needed.

## Deliverable shape

Lead with three lines: the one state you would fight hardest to make
unmistakable, the channel you would keep if you could keep only one, and the one
thing you are least sure about. Then the numbered spec.

## THE TRAP

**Specifying what the corner SAYS.** That is K72 and the forthcoming K73,
specified to the sentence. You specify how the CONTAINER reads - recommended,
focused, accepted, locked, dangerous - and nothing about the text inside it.
