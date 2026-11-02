# TASK_J35 — JOHN — HOW THE GENRE MODELS A LIVING RIVAL PROMOTION

**Owner:** John, research specialist
**No checkout, no shell, no Godot.** Reply with the full text. Do NOT reference
repo paths and do not ask to run anything.

## Why this exists

K69 measured what buyers of fight-management sims actually ask for, and the
single most-requested missing feature is **a LIVING RIVAL-PROMOTION WORLD** —
other promotions that sign fighters, poach yours, run their own cards and have
their own fortunes. K68 went further and challenged the whole project:
*"buyers of fight-management sims pay for management depth and honest fight
outcomes, not 3D."*

We have spent a week on the 3D fight. Before the next big 3D spend, we need to
know what the depth half actually costs. **This is that question.**

## The question, narrowly

**How do shipped management sims model rival organisations, mechanically?** Not
"they have AI teams" — the mechanism. For each game you cover:

1. **What state does a rival hold?** Money, roster, prestige, a region, a TV deal,
   a champion? List the fields, as far as they are documented or observable.
2. **What decisions does a rival take, and on what clock?** Weekly? Per event?
   Does it bid against the player for a free agent, and is that bid a number or a
   dice roll?
3. **How does the player FEEL the rival exist?** This is the part that decides
   whether it is worth building. A rival that quietly simulates in a spreadsheet
   the player never sees is wasted work. Name the specific surfaces — a news feed,
   a poached-fighter notification, a rankings table that includes their champions,
   a bidding war screen.
4. **What breaks?** Every one of these systems has a known failure the community
   complains about — runaway AI promotions, rivals going bankrupt in year three,
   the player being unable to compete after year five. Name them, with the
   symptom.

## Cover these, and say which you could not source

Football Manager (rival clubs are the closest mature analogue), Out of the Park
Baseball, Wrestling Empire / TEW (Total Extreme Wrestling — the deepest rival-
promotion model in any sim, and the nearest thing to our domain), Promoter, MMA
Sim King, and Believr Pro Wrestling. TEW matters most: it has modelled rival
promotions for twenty years and its mechanics are documented in detail by its own
community.

## THE TRAP, AND IT HAS BITTEN THIS PROJECT FOUR TIMES

**IF A NUMBER IS NOT PUBLISHED, SAY NOT FOUND.** J34 is the model to follow: all
five of its targets came back NOT FOUND and that WAS the answer, delivered
cleanly. What is forbidden is deriving a figure from something that is not that
figure — J34's own warning was *"do not invent from Miarka's 11.4-12.6 s, which is
a PER-ROUND CUMULATIVE phase total, not an episode."*

So: where a mechanism is documented, cite where. Where it is only inferred from
play, **say INFERRED FROM PLAY and say by whom.** Where it is unknown, say NOT
FOUND. A confident number with no source behind it costs us more than a gap does,
because we build on it.

## Second trap — separate the mechanism from the marketing

A store page saying "a living world that reacts to you" is not a mechanism. If
your only source for a claim is promotional copy, mark it MARKETING CLAIM,
UNVERIFIED. Half of what is written about this feature in this genre is that.

## The one judgement I want from you

At the end, **one ranked list: the three cheapest mechanisms that would make a
rival promotion FELT**, cheapest first, with what each needs to exist. Cheapest
means least new state and fewest new screens, not least interesting. You have seen
what the genre does; tell us where the leverage is.

## Deliver

Reply in chat with the full text of `J35_RIVAL_PROMOTIONS.md`. Claude lands it and
writes your HANDOFF block — you never edit `HANDOFF.md`.
