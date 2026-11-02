# S277 - GYM EMPIRE benchmark: the gym-builder we must be way better than

Operator S277, verbatim: "https://store.steampowered.com/app/756300/Gym_Empire__Idle_Gym_Tycoon_Management/  our game must be way better than this"

Sources read (2026-10-20): the Steam store page (app 756300); the Steam top-rated reviews page (10 visible reviews); a web search
(the developer's ModDB post-launch write-up, quoted in search results - moddb.com returned 403 to a direct fetch).

## What Gym Empire is
- Chronik Spartan (solo dev). Early Access 21 Jul 2023, full release 24 Apr 2026. 5.19 EUR. 14 Steam reviews, 71% positive.
- Developer's write-up: ~450 units in ~2 years of EA, ~$7,300 gross / ~$4,600 net, an above-average refund rate early; a player
  called it "more like a mobile game"; the developer frames it as an idle incremental game at heart, not a tycoon sim.
- Loop: start in a small storage closet -> free-form floors and walls -> equipment -> clients walk in, use kit, train with staff ->
  hire staff (cuts injuries) -> memberships and fees -> sponsorships, gym celebrities, "roiders" -> yearly competitions against
  rival gyms -> more properties (Beach Front, Zen). Sport areas: boxing, basketball, swimming, wrestling, football.

## What players praised (keep these - we need them too)
- Free-form gym design with floors and walls; zoom; cute animations; an approachable tutorial; "very addicting" first hour;
  staff that take micromanagement away; the radio as a fun touch; unlocking better equipment for better clients.

## What players hated (each is a bar we must clear)
1. A progress-blocking bug six minutes in ("not yet playable").
2. Dated graphics; menus that look like "Windows Paint".
3. "Fun for the first hour", then tedious; looks abandoned.
4. Raising membership fees means cancelling old memberships one by one; no way to tell which fee makes sense.
5. Upkeep and injuries micromanaged client by client - fails as an idler AND the active play is not fun.

## Where FightCamp must be way better (the bar every GYMBUILD step is judged against)
| Gym Empire | FightCamp bar | How we prove it |
|---|---|---|
| Competitions are a yearly abstract event | The gym's whole point is FIGHTERS: you build the gym, train a boxer in it, book him and WATCH the bout (3D, MetaHuman, real punch clips) | the loop probe plays gym -> bout -> back; the operator plays the .exe |
| Closet start, free-form walls | MGT2 empty shell on a real plot + DRAW a room (walls + door generated), Two Point item palette by room, key item per room | GYMBUILD A-C stills on the game camera + .exe |
| Progress-blocking bugs | Nothing can block the loop: real-route loop probe + .exe gate every step (S276 rule), nightly cloud suite | probe + nightly |
| "Windows Paint" menus | One top bar + modals, icons + tooltips, ONE UI bible, Ludo checks every screen (S227/S268/S275) | Ludo screen census + stills |
| Tedious after hour 1 | Hour-2+ depth: locked room types open with reputation, fighters' careers, rivals that spend (G74), attributes trained by what you built | design round to Ludo (D39) before build |
| Fee changes one by one, unclear value | Membership TIERS edited once, applied to every member at renewal, with the predicted members/income shown before you commit | a test: one change moves every member |
| Per-client injury/upkeep clicks | Rooms and staff carry the work: a physio room treats, a cleaner/maintenance rule upkeeps; the player sets policy, never clicks a person | a test: injured members walk to physio with no player input |
| Five shallow sports | One sport done deep for the demo (boxing), MMA as the first update | Discipline: line in every brief |
| Dated low-poly look | Bright, alive gym at Two Point camera numbers (TWOPOINT_ALIGNMENT.md), MetaHuman people | visual gate |

## Decision
This table is added to GYMBUILD_PLAN_S276.md as its acceptance bar. The two systems Gym Empire got wrong that GYMBUILD will touch
(membership tiers, physio/upkeep without per-person clicks) go to Ludo as part of the GYMBUILD design round, then to the board for the
operator's verdict before they are built (D39 LUDO FIRST).
