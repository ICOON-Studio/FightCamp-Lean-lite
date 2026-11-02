# TASK_M22 — MARIA — TURN "AAA" INTO NAMED TOKENS

**Owner:** Maria, Art Director
**No checkout, no shell, no Godot.** Reply with the full text of the deliverable.
Do NOT send code, do not reference repo paths, do not ask to run anything.

## Why this exists, in the operator's own words

> *"i do not know how to give the prompts to make the game feel unique and AAA
> standard. you need to help with this our competition has some very nice layouts
> and menus"*

**"AAA" is an adjective, and an adjective does not survive contact with nine
agents** — each invents its own idea of it and you get nine different looks. Your
job is to replace the adjective with a NAMED SET OF VALUES that any agent can
apply without taste.

This is a management sim: menus, tables, rosters, stat rows, fight cards,
calendars. It is not a shooter HUD. The look that matters is **dense information
that reads instantly and feels expensive.**

## What to deliver — a visual language, as values

One document, `M22_VISUAL_LANGUAGE.md`. Every entry must be a NAME and a VALUE,
never a description. "Generous spacing" is unusable; `space_md = 16px` is usable.

1. **COLOUR.** 10–14 named tokens, each with a hex value and one sentence on what
   it is for. Cover: page background, raised surface, sunken surface, hairline,
   primary text, secondary text, disabled text, accent, positive, negative,
   warning. State the contrast ratio of every text token against the surface it
   sits on, and **keep body text at 4.5:1 or better** — this is a game people read
   tables in for hours.
2. **TYPE.** A scale of 5–7 named steps (`text_xs` … `text_3xl`) with px sizes and
   line-heights, plus which weight each step uses. Name TWO typefaces at most — a
   display face and a text face — and say which is which. Prefer faces that are
   free to ship.
3. **SPACING.** One rhythm, 5–7 steps, all multiples of a single base unit. Say
   what the base unit is and why.
4. **THE STAT ROW**, in numbers. This is the single most repeated element in the
   game. Give its height, its column structure, the gap between columns, the bar's
   height and corner radius, and where the number sits. The operator's own example
   of what a rule looks like: *"stat rows are three columns, label left, bar
   centre, number right, 28-32px rhythm."*
5. **ELEVATION AND BORDERS.** How a panel is separated from the page: hairline
   width, corner radius, and whether shadows are used at all. Pick one and be
   consistent — mixed elevation is the commonest cheap-looking tell.
6. **ONE PAGE OF "NEVER".** The five things that would immediately make this look
   like a hobby project. Be specific and mechanical (e.g. "never more than two
   type sizes in one row"), not stylistic advice.

## Ground it in what exists, not in taste

**Name at least four real management/sim games or apps you are drawing each
decision from**, and say what you took from each. A token set with no reference
behind it is your taste, and taste does not survive nine agents either. Football
Manager, Out of the Park Baseball, Frostpunk's management layers and modern
finance dashboards are all fair references — use whatever you actually know.

Where two references disagree, **say so and pick one, with the reason.** A
document that hedges cannot be implemented.

## THE TRAP THAT WOULD MAKE THIS UNUSABLE

**Do not design a screen.** A mock-up of one screen teaches nobody the rule, and
the next agent building a different screen is back to guessing. Every entry must
generalise. If you catch yourself describing a specific layout, extract the rule
from it and delete the layout.

**Second trap: do not invent tokens nobody needs.** Twelve colours that are all
used beats forty that are not. If you cannot say what an entry is for in one
sentence, cut it.

## What happens next, so you can aim it

Claude converts this into `UIKit` constants and a separate agent audits every
existing screen against them (that census is running now as U126). So the values
you choose will be applied mechanically by something with no judgement. **Write
for that reader.**

## Deliver

Reply in chat with the full text of `M22_VISUAL_LANGUAGE.md`. Claude lands it in
the repo and writes your HANDOFF block — you never edit `HANDOFF.md`.
