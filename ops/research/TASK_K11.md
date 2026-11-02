# TASK K11 — KALLI — the SCOUTING hub

Model: top tier (Fable 5.1). Fast mode off. Decided at assignment; do not
self-escalate or downgrade.

Self-contained. Read this file and nothing else except the six references
at the bottom. No code ships from this task: the deliverable is a study,
the same shape as K7, K8, K9 and K10. START WHENEVER YOU HAVE CREDITS —
not gated on a date.

## Why this exists

GYM shipped on your K8 boards (R21). TRAINING shipped on your K9 boards
(R22) — one rail item holding the week and the camp, exactly as you
called it. SCHEDULE will ship on your K10 boards. **SCOUTING is the next
hub**, and it replaces `RecruitmentScreen.gd` (1108 lines), which is
discarded, not migrated.

## The question this study answers

SCOUTING is one rail item today pointing at one screen that does two
genuinely different jobs: **finding fighters** and **finding staff**.
Hanging off both is a third thing — **CONTRACT OFFERS**, a real
negotiation, since the instant-sign path was deliberately removed.

**How does one hub hold all three?** Tabs, a mode switch, or a board with
a drawer. Give a recommendation and the reason, the way K8 called the
single GYM rail item, K9 put the camp inside TRAINING, and K10 folded
EVENTS into SCHEDULE. Consider at least: two tabs (FIGHTERS / STAFF) with
the offer as a drawer off a row — the store-drawer pattern from K8 and
the session-drawer pattern from K9 are both already in the kit — against
three tabs, against one list with a kind filter. Claude decides in the
build; this is the study pick.

The second question, smaller but real: **a scouting board is a funnel.**
Say in one line how a manager keeps a candidate they are interested in
but not ready to sign, and where that shortlist lives — because right now
nothing in the game remembers "come back to this one".

## What the system actually does today

Ground the study in this. It is the real mechanical surface.

- **Candidates are references to the saved world.** Nobody joins the gym
  until GameState atomically transfers them; until then a candidate is a
  world fighter you are looking at, not an asset you hold.
- **Fighters and staff are both recruited here.** A coach carries a
  salary, a teaching rating and a tactical rating; a fighter carries the
  stats, record and division the rest of the game already shows.
- **There is no instant sign.** An offer opens a negotiation. The money
  axis is real and a candidate can refuse.
- **Weight class and sex are hard rules everywhere** — they matter here
  because who you sign decides who you can ever book.
- The gym's cash is finite and a wage is a recurring cost, so
  affordability is part of every row, not a surprise at the end.

## Deliver

`research/SCOUTING_HUB_K11.html` plus PNG renders at 1920x1080, one
per board, named `SCOUTING_K11_<board>.png`.

Four boards:

1. **THE PROSPECTS.** The hub's home: candidates readable at a glance —
   who they are, what they cost, what they would add. Density is the
   problem, the same one THE WEEK solved. Show the filters, the sort,
   which rows are affordable and which are not, and how fighters and
   staff live on the same hub without becoming two screens.
2. **THE CANDIDATE.** One prospect opened: the stats and record that
   decide whether they are worth it, what the gym already has in that
   division or that coaching slot, and the honest downside. This is where
   a manager decides, so make the comparison legible rather than a wall.
3. **THE OFFER.** The negotiation: the money axis, what has been offered
   against what is wanted, the candidate's answer, and the refusal said
   in its own words. Show the affordability consequence — a wage is
   forever, not a one-off.
4. **STATES.** Contact sheet: nobody in the filter, a candidate the gym
   cannot afford, an offer refused, a shortlist with one name on it, and
   an empty world.

## Constraints (these are rulings, not preferences)

- Kit only: colour, type and sizes come from `Godot/scripts/UITokens.gd`.
  Bebas Neue for display, IBM Plex Mono for everything else. Gold is the
  championship accent and is spent on ONE thing per board. Green is
  Continue and nothing else. A pair block is slate, never the header
  colour.
- **Reuse before minting.** The book is now **151 variants across 14
  families** — open `DesignLibrary/kit/index.html` for the live count.
  The gym family (`squad_row`, `action_flag`, `filter_strip`,
  `sort_header`, `store_drawer`, `catalog_row`, `affordability_reason`)
  already covers most of a filtered list of things you buy, and
  `affordability_reason` was built for exactly the "cannot afford" case.
  The training family adds `session_panel` (a drawer surface) and
  `illegal_refusal` (a named refusal). List genuine kit gaps in a table
  the way K8, K9 and K10 did, but only after you have tried what exists.
- **There is no drag primitive in the kit**, by your own K8 ruling, and
  R21 and R22 both shipped click-arm-click instead. If a board needs one
  you are specifying a new primitive: say so and draw its states.
- 1920x1080, inside ShellChrome: the rail on the left, the top bar, and
  Continue. The gym and training hubs put the title, the line and the tab
  switch in the free band and start the body at 210 — match that rhythm.
- Nothing smaller than the kit's SIZE_MIN of 12. The user has ruled twice
  that text must be clearly readable.
- One figure once per board. Silhouette avatars only; assume no new
  character art exists.
- The facility is a GYM, never a "camp".
- Females never fight males; booking matches weight classes. Both bear on
  who is worth signing.
- Ripped art never ships. Reference stays in the scratchpad; nothing from
  another game enters `Godot/`.

## Not this study

`CityScreen.gd` and `CountryMap.gd` look like scouting and are not: they
are the **career creation** flow — country, then city, then gym, then the
rename that starts the save. They belong to the boot stage. Leave them.

## What to look at first

- `Godot/scripts/UITokens.gd` — the whole palette and type scale, 160
  lines, read it all.
- `DesignLibrary/kit/index.html` — the Kit Book. Use what is there before
  drawing anything new.
- `research/GYM_HUB_K8.html`, `TRAINING_HUB_K9.html` and
  `SCHEDULE_HUB_K10.html` — your own hub pattern. SCOUTING sits beside
  them and must look like the same game.
- `DesignLibrary/screens/gym_hub/` and
  `DesignLibrary/screens/training_hub/` — the shipped renders. That is
  the bar.

Do not open `RecruitmentScreen.gd` or `GameState.gd`. Everything you need
from them is written above.

## Rules

- Deliverables land in `research/` and nowhere else. Owned files:
  `SCOUTING_HUB_K11.html`, the `SCOUTING_K11_*.png` renders, and
  `research/K11_DIGEST.md`.
- **Do not edit `HANDOFF.md`.** Claude writes your block (standing rule).
- Previews are PNG or JPG. No code, no `.gd`, no `.tscn`.
- Commit with your Co-Authored-By line, push `master`, then END the
  session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/SCOUTING_HUB_K11.html
research/K11_DIGEST.md
```
