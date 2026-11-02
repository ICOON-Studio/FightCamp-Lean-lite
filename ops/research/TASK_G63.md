# TASK_G63 — Tear down their menus into RULES, not adjectives

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.**
**No checkout. Reply in chat with the full text — do NOT attach a file.**
**Run this AFTER G62 lands. It reuses the same six titles.**

## Why this exists, in the operator's own words

> *"i do not know how to give the prompts to make the game feel unique and AAA
> standard. you need to help with this our competition has some very nice
> layouts and menus"*

**"AAA" is an adjective, and an adjective does not survive contact with nine
agents** — each one invents its own idea of it and you get nine different looks.
What survives is a **reference plus a rule**. Your job is to turn their menus
into rules specific enough that an agent who has never seen the screenshot can
build to them.

## The six titles

MMA Sim King (4534230) · Believr Pro Wrestling (4174130) · PROMOTER: The Fight
Game (4448300) · THE FIGHT BUSINESS: BOXING MANAGER (5249680) · Boxing Club
Manager (2022, MIXED, €34.99) · **MMA Career Simulator (4465410)** — the only
one with a 3D fight.

Their Steam store screenshots and trailers are the source. Look at the actual
images.

## What a RULE looks like, and what it does not

**NOT a rule:** "clean layout", "good use of space", "modern feel", "polished".
Those are the adjectives that got us here.

**A rule:**
> Fighter stat rows are three columns — label left, bar centre, number right.
> The bar is ~55% of row width. Row rhythm is even and tight, roughly 28–32 px
> at 1080p. The number is tabular and right-aligned so digits line up down the
> column.

If an agent could build it from your sentence without seeing the picture, it is
a rule. If not, keep going.

## What to tear down, per screen type

For each title, for whichever of these you can actually see:

1. **Roster / fighter list** — how many rows on screen at once, what is on a
   row, how they handle a long name, how selection is shown.
2. **Fighter profile** — how stats are shown (bars, numbers, radar, grades),
   what is above the fold, where the photo/portrait sits and how big.
3. **Booking / matchmaking** — how two fighters are compared side by side.
4. **Calendar / day feed** — how a week or month is shown, how much fits.
5. **The fight screen itself** — what surrounds the fight, what HUD is present,
   what the player can do while it runs.

## Then, the things that actually separate AAA from indie

These matter more than colour, and almost nobody names them:

- **Information density.** How much is on one screen? Indie UI is usually too
  sparse — big buttons, few rows, lots of dead space. Count real rows visible.
- **Hierarchy.** What is biggest, what is dimmest, what is one colour away from
  the background. How many levels of emphasis do they actually use?
- **Type scale.** How many distinct text sizes? Name their approximate ratio.
- **Rhythm.** Is spacing consistent, and on roughly what base unit?
- **Numbers.** Tabular alignment, decimal places, units, how a 4-digit value is
  handled.
- **State handling** — the real indie tell. Long names, empty lists, zero
  values, a fighter with no record. If a screenshot shows one, say what they do.
- **Motion**, if a trailer shows it: do panels transition or hard-cut?

## Deliverable

**A numbered list of rules**, grouped by screen type, each one buildable. Then:

1. **The three rules that would most change FightCamp**, given it currently has
   six screens (day feed, athlete profile, fight contract, fight night, fight
   world live, anim lab) and a `UIKit.gd` component kit.
2. **What ALL of them do that we do not.** The parity gap in layout terms.
3. **One thing they all do badly** that we could beat them on. Be honest if
   there isn't one.

Label DOCUMENTED (you saw it in a screenshot/trailer — say which) or INFERENCE.
Under 400 lines. Lead with three lines: the single biggest layout difference,
the one rule to adopt first, and whether any of them is genuinely well designed
or merely competent.
