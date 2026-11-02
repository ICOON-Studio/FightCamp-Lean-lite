# TASK K12 — KALLI — the OFFICE + STAFF hub

Model: top tier (Fable 5.1). Fast mode off. Decided at assignment; do not
self-escalate or downgrade.

Self-contained. Read this file and nothing else except the references at
the bottom. No code ships from this task: the deliverable is a study, the
same shape as K7, K8, K9, K10 and K11. START WHENEVER YOU HAVE CREDITS —
not gated on a date.

## Why this exists

GYM shipped on your K8 boards (R21). TRAINING shipped on your K9 boards
(R22). SCHEDULE ships on your K10 boards (R24, in progress). SCOUTING
ships on your K11 boards next. That leaves the two rail items nobody has
looked at: **OFFICE** and **STAFF** — and `OfficeHub.gd`, at **5764
lines** the largest screen in the game, which is discarded, not migrated.

## The question this study answers

OfficeHub was built as the whole game behind one desk: fifteen modules,
reached from a directory. The replacement programme has emptied most of
it. Its tenants have moved out —

| Module | Where it lives now |
|---|---|
| TODAY'S BRIEFING | THE DAY |
| FIGHTERS, GYM FLOOR | GYM (R21) |
| TRAINING | TRAINING (R22) |
| SCHEDULE, EVENTS | SCHEDULE (R24) |
| SCOUTING | SCOUTING (next) |
| MATCH SIMULATOR, LIVE FIGHT | FightNight (R20) |

— and six are still homeless: **STAFF**, **CONTRACTS**, **GYM
FINANCES**, **WEEKLY OBJECTIVES**, **WEIGHT CLASS**, **PHONE &
RELATIONSHIPS**.

**So: what is OFFICE now, and does STAFF stay beside it on the rail?**
Give a recommendation and the reason, the way K8 called the single GYM
item, K9 put the camp inside TRAINING, K10 folded EVENTS into SCHEDULE
and K11 made the offer a drawer. Consider at least:

- **OFFICE as the gym's business hub** (money, contracts, objectives)
  with STAFF as its own rail item, because staff are people you manage
  weekly, not paperwork;
- **one OFFICE holding all six** as tabs, and STAFF leaves the rail;
- **OFFICE dissolves** — the six go to the hubs that already own their
  subject (contracts to the fighter card, objectives to THE DAY, weight
  class to the fighter card) and only money keeps a rail item.

Say which and why. Claude decides in the build; this is the study pick.

Two smaller rulings, both real:

1. **Where does hiring end and managing begin?** SCOUTING signs a coach;
   STAFF lives with them afterwards. Write that boundary in one line, the
   way you drew FLOOR ÷ TRAINING (K9) and DAY ÷ SCHEDULE (K10). Neither
   surface may restate the other.
2. **WEIGHT CLASS is an action, not a place.** It moves one fighter one
   division. Say where it belongs — an action off a fighter, a drawer, or
   a set-piece — and draw it once.

## What the system actually does today

Ground the study in this. It is the real mechanical surface; nothing here
is invented.

- **Staff are coaches.** Each carries a weekly salary, a technical
  teaching rating, a tactical rating and a youth-development rating. The
  gym has a **coach capacity**; going over it is a real state.
- **Coaches are assigned.** A coach is responsible for a fighter's
  development and one is the **corner coach** on fight night.
- **RAPPORT is a live stat** (`CoachRapport.gd`): a fighter×coach value
  that drives training efficiency, how often the fighter listens to the
  corner mid-fight, and the between-rounds reset. It is not on any screen
  yet. This study is where it first becomes visible.
- **Money is weekly and real.** Cash on hand, athlete payroll, staff
  payroll, equipment upkeep, the projected balance one week out, and any
  purse on the books for a booked fight. A wage is recurring; a signing
  fee is once.
- **Contracts run out.** Athlete and staff terms have a length and expire;
  fight offers carry purse and win bonus splits.
- **Weekly objectives** are three deterministic gym goals per week,
  tracking real fights, programmed training and management actions, with a
  gold CLAIM paying cash and gym fame.
- **The weight-class move** is weeks of real body work: it vacates the
  belt of the division being left and most of that division's ranking
  points stay behind.
- **PHONE & RELATIONSHIPS is honestly unfinished** — attention items are
  real, relationship tracking is a future system. Do not dress it as a
  working feature; say what it is or leave it out and say why.

## Deliver

`research/OFFICE_HUB_K12.html` plus PNG renders at 1920×1080, one
per board, named `OFFICE_K12_<board>.png`.

Four boards:

1. **THE DESK.** Whatever OFFICE becomes under your recommendation, drawn
   as the hub's home. If it holds the money, it is a business board: cash,
   payroll both ways, upkeep, next week's projection, what is owed and
   what is coming. If it dissolves, draw what replaces it and where the
   six go.
2. **THE STAFF.** The coach room: who is contracted, what they teach, who
   they are assigned to, capacity used against capacity held, wages, and
   **rapport made visible for the first time** — a fighter×coach reading
   that a manager can act on rather than a matrix to admire.
3. **THE BOOKS.** Contracts and obligations: athlete and staff terms with
   what is expiring, fight purse and bonus on the books, and the weekly
   objectives with their CLAIM. If your recommendation splits these,
   draw the split instead and say so.
4. **STATES.** Contact sheet: no coaches at all; over capacity; a contract
   expiring this week; payroll the gym cannot cover next week; every
   objective claimed; a fighter with no assigned coach; and the
   weight-class move refused with its reason named.

## Constraints (these are rulings, not preferences)

- Kit only: colour, type and sizes come from `Godot/scripts/UITokens.gd`.
  Bebas Neue for display, IBM Plex Mono for everything else. Gold is the
  championship accent and is spent on ONE thing per board — on THE BOOKS
  it is almost certainly the CLAIM. Green is Continue and nothing else. A
  pair block is slate, never the header colour.
- **Reuse before minting.** The book is now **151 variants across 14
  families** — open `DesignLibrary/kit/index.html` for the live count. The
  gym family (`squad_row`, `action_flag`, `filter_strip`, `sort_header`,
  `affordability_reason`, `capacity_meter`) already covers a filtered list
  of people with wages and a capacity, and `capacity_meter` was built for
  exactly the over-capacity case. The training family adds `session_panel`
  (a drawer surface) and `illegal_refusal` (a named refusal). List genuine
  kit gaps in a table the way K8–K11 did, but only after you have tried
  what exists.
- **There is no drag primitive in the kit**, by your own K8 ruling. If
  assigning a coach to a fighter needs one, you are specifying a new
  primitive: say so and draw its states. R21 and R22 both shipped
  click-arm-click instead.
- 1920×1080, inside ShellChrome: the rail on the left, the top bar, and
  Continue. The gym, training and schedule hubs put the title, the line
  and the tab switch in the free band and start the body at 210 — match
  that rhythm.
- Nothing smaller than the kit's SIZE_MIN of 12. The user has ruled twice
  that text must be clearly readable.
- One figure once per board. Silhouette avatars only; assume no new
  character art exists.
- The facility is a GYM, never a "camp".
- Females never fight males; booking matches weight classes. Both bear on
  the weight-class move.
- Money is never invented: every number on a board must be one the list
  above says the game already computes.
- Ripped art never ships. Reference stays in the scratchpad; nothing from
  another game enters `Godot/`.

## Not this study

`CityScreen.gd` and `CountryMap.gd` are **career creation** — country,
city, gym, the rename that starts the save. They belong to the boot
stage. The K7 set-piece frame is already specified and is a later Claude
build. Leave both.

## What to look at first

- `Godot/scripts/UITokens.gd` — the whole palette and type scale, 160
  lines, read it all.
- `DesignLibrary/kit/index.html` — the Kit Book. Use what is there before
  drawing anything new.
- `research/GYM_HUB_K8.html`, `TRAINING_HUB_K9.html`,
  `SCHEDULE_HUB_K10.html`, `SCOUTING_HUB_K11.html` — your own hub
  pattern. OFFICE sits beside them and must look like the same game.
- `DesignLibrary/screens/gym_hub/` and
  `DesignLibrary/screens/training_hub/` — the shipped renders. That is
  the bar.
- `OFFICE_HUB_DESIGN.md` at the repo root — the original intent for the
  desk. Read it as history, not as a spec to honour.

Do not open `OfficeHub.gd` or `GameState.gd`. Everything you need from
them is written above.

## Rules

- Deliverables land in `research/` and nowhere else. Owned files:
  `OFFICE_HUB_K12.html`, the `OFFICE_K12_*.png` renders, and
  `research/K12_DIGEST.md`.
- **Do not edit `HANDOFF.md`.** Claude writes your block (standing rule).
- Previews are PNG or JPG. No code, no `.gd`, no `.tscn`.
- Commit with your Co-Authored-By line, push `master`, then END the
  session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/OFFICE_HUB_K12.html
research/K12_DIGEST.md
```
