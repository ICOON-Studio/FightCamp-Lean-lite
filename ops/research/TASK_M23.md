# TASK_M23 — MARIA — HOW SIX DAMAGED REGIONS SHOULD READ ON SCREEN

**Owner:** Maria, Art Director
**No checkout, no shell, no Godot.** Reply in chat with the full text.

## Why this, and M22 is why it can be specific

M22 was exactly right — named values, contrast ratios computed, no adjectives. It
is being turned into `UITokens` constants now. **This is the one place those
tokens are not enough**, and it is the most valuable screen in the game.

A competitor teardown (G63, 113 sources) found the hole we can beat everyone on:

> Nobody puts region-level damage + live corner verbs + readable numbers on screen
> at FM match-day density. **That is the hole.**

We have six body regions as an engine feature with no visual contract. A separate
task has Grok speccing the HUD's **layout** in pixels. **You own how a damaged
region READS** — and the two must not collide, so stay off geometry.

## The question

**How does a viewer tell, at a glance and at speed, that a region is fine,
hurting, or about to end the fight?**

Six regions, two corners, a fight moving in real time. The player is a manager
deciding whether to throw in the towel, not a fighter.

## What to deliver — `M23_REGION_READOUT.md`

1. **THE DAMAGE RAMP, AS NAMED STOPS.** Not a gradient description — a list of
   states with a token per state, drawn from M22's palette where it fits and
   extending it where it does not. How many stops? Three (fine / hurt / critical)
   or five? **Pick a number and defend it** — more stops read as noise at speed,
   fewer lose the warning.
2. **COLOUR IS NOT ENOUGH AND YOU KNOW WHY.** Roughly 8% of men have some red-green
   deficiency, and this is a game about two men in a cage. **Give a second channel
   that carries the same information** — fill height, hatching, a glyph, weight.
   Say which, and say what a colour-blind viewer sees.
3. **CONTRAST, COMPUTED, AS IN M22.** Each damage stop against `color_panel` and
   against `color_sunken`. The critical state must not be the only one that fails.
4. **WHAT CHANGES WHEN IT CHANGES.** A region taking a heavy shot needs to be
   noticed without a full-screen effect. Specify the transition: what animates,
   by how much, for how long in milliseconds. G63's measured house rule is **slide
   160–240 ms, never fade the whole screen** — work inside that.
5. **THE TWO CORNERS MUST NOT BE CONFUSABLE.** Six rows on the left and six on the
   right, mirrored. Say how a viewer knows instantly whose head that is. Mirroring
   the layout is not enough on its own.
6. **THE ONE THAT ENDS THE FIGHT.** A region at the doctor-stoppage threshold is
   qualitatively different from one that is merely bad. Does it get its own
   treatment, or is it the top of the ramp? **Decide.**
7. **WHAT NOT TO DO.** Five specific things that would make this read as a hobby
   project — mechanical, not stylistic. Anatomy illustrations, blood, pulsing
   glows, and per-region portraits are candidates; say which and why.

## Ground it

Name at least three real references — Undisputed's corner damage panel is the
closest shipped analogue (roughly ten rows, ~180 px, both corners); FM's match-day
tiles for density; anything from medical or aviation displays where a small status
list must be read under time pressure. Say what you took from each.

## THE TRAP

**Do not specify positions, widths or row heights.** Grok's task owns the pixel
layout and will publish row height and panel width; if you also publish them they
will disagree, and the person building it will pick one at random. **Your unit is
the STATE and its treatment**, not the geometry. If you catch yourself writing a
pixel position, hand it to the layout and describe the state instead.

**Second trap, and it is the one that would waste this:** do not design a
beautiful damage visualisation. It has to be legible in a 30 px row while two
bodies move in the centre of the screen. **Legibility at small size and speed is
the whole brief** — if a treatment only works large, it does not work.

## Deliver

Reply in chat with the full text of `M23_REGION_READOUT.md`. Claude lands it and
writes your HANDOFF block — you never edit `HANDOFF.md`.
