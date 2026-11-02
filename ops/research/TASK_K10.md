# TASK K10 — KALLI — the SCHEDULE & EVENTS hub

Model: top tier (Fable 5.1). Fast mode off. Decided at assignment; do not
self-escalate or downgrade.

Self-contained. Read this file and nothing else except the six references
at the bottom. No code ships from this task: the deliverable is a study,
the same shape as K7, K8 and K9. START WHENEVER YOU HAVE CREDITS — not
gated on a date.

## Why this exists

GYM shipped on your K8 boards (R21). TRAINING is being built now on your
K9 boards (R22). The rail has eight items; after the fighter card
(Claude's R23) the next legacy scenes in the queue are **SCHEDULE** and
**EVENTS** — three pre-kit screens totalling 3,509 lines, all of them
discarded and rebuilt from the kit, never migrated.

## The question this study answers

SCHEDULE and EVENTS are two rail items today, and they answer the same
kind of question: *what happens on which date.*

- SCHEDULE is a month grid of the gym's own dated facts.
- EVENTS is a table of the world's fight cards, and clicking a row opens
  one event.

They were separate because SCHEDULE used to carry fight camp. **Your own
K9 ruling moved fight camp to TRAINING**, so SCHEDULE has lost its
biggest tenant. That reopens the shape.

**Is this one rail item or two, and what is on each?** Give a
recommendation and the reason, the way K8 called the single GYM rail item
and K9 called TRAINING holding the camp. Claude decides in the build;
this is the study pick. Consider at least: one item with two tabs (MY
MONTH / THE CARDS), two items kept apart, or one board with a filter that
folds the world's cards into the gym's own month.

The second question, smaller but real: THE DAY (`day_feed`) already
exists as its own rail item and tells the player what today holds.
SCHEDULE must not restate it. Say in one line how the two divide that.

## What the system actually does today

Ground the study in this. It is the real mechanical surface.

- **The month grid** is Mon–Sun and shows the gym's dated kinds: FIGHT,
  MEDICAL, RECOVERY, WORLD. There are no invented Training/Travel/Rest
  chips — the career clock is week-granular, and the day chips are real
  obligations only. Other dated facts the player is judged on also land
  here: an ask's deadline, the weigh-in the day before a bout, a contract
  running out, a camp settling.
- **The card board** is a table: DAY / DATE / ORGANIZATION / DISCIPLINE /
  EVENT NAME / LOCATION. It is the whole world's schedule, not just
  yours, so filtering and scanning are the entire problem.
- **Booking hangs off that board and must not be orphaned.** Own-tier
  offers and the organization's fighter picker live on it today; the
  Match Simulator stays reachable from it. Weight classes must match —
  booking refuses out-of-class pairings and says why.
- **An event opens** to its bout list: who fights whom, my fighter's slot
  if any, the tale of the tape for a pairing, purse and win bonus, and
  the result once it is fought.

## Deliver

`research/SCHEDULE_HUB_K10.html` plus PNG renders at 1920x1080, one
per board, named `SCHEDULE_K10_<board>.png`.

Four boards:

1. **THE MONTH.** The gym's own dated facts across a Mon–Sun month grid:
   the four kinds, the deadlines, the weigh-ins. Density is the problem —
   show a light month and a heavy one, and show what a single day cell
   does when three obligations land on it.
2. **THE CARDS.** The world's events as a scannable board: the six
   columns, the filters and the sort, which rows matter to me (my fighter
   is on it / my division / my org / bookable), and where the booking
   paths live without becoming a second screen.
3. **THE EVENT.** One event opened: the bout list, my fighter's slot, the
   tale of the tape for one pairing, purse and win bonus, results when
   it is in the past. **Show the seam into the set-piece frame** — fight
   week, the weigh-in and fight night are K7's set-pieces and a later
   Claude stage; draw the handoff, do not redraw the frame.
4. **STATES.** Contact sheet: a month with nothing booked, an event with
   no roster fighter on it, a past event with results, a bout refused for
   weight class with the reason shown, and an empty board.

## Constraints (these are rulings, not preferences)

- Kit only: colour, type and sizes come from `Godot/scripts/UITokens.gd`.
  Bebas Neue for display, IBM Plex Mono for everything else. Gold is the
  championship accent and is spent on ONE thing per board. Green is
  Continue and nothing else. A pair block is slate, never the header
  colour.
- **Reuse before minting.** The book was 135 variants across 13 families
  after R21 and gains a "training" family from R22 — open
  `DesignLibrary/kit/index.html` for the live count. The gym family
  (`squad_row`, `action_flag`, `filter_strip`, `sort_header`,
  `capacity_meter`, `store_drawer`, `catalog_row`,
  `affordability_reason`) already covers most of a filtered table. List
  genuine kit gaps in a table the way K8 and K9 did, but only after you
  have tried what exists. A month grid is the one thing the kit plainly
  lacks.
- **There is no drag primitive in the kit**, by your own K8 ruling. If a
  board needs one you are specifying a new primitive: say so and draw its
  states.
- 1920x1080, inside ShellChrome: the rail on the left, the top bar, and
  Continue. The gym hub puts its title, its line and its tab switch in
  the free band and starts the body at 210 — match that rhythm.
- Nothing smaller than the kit's SIZE_MIN of 12. The user has ruled twice
  that text must be clearly readable.
- One figure once per board. Silhouette avatars only; assume no new
  character art exists.
- The facility is a GYM, never a "camp". A fight camp is only the
  pre-bout preparation, and it lives in TRAINING now — it is not on any
  of these boards.
- Females never fight males; booking matches weight classes. Both apply
  to every pairing you draw on boards 2 and 3.
- Ripped art never ships. Reference stays in the scratchpad; nothing from
  another game enters `Godot/`.

## What to look at first

- `Godot/scripts/UITokens.gd` — the whole palette and type scale, 160
  lines, read it all.
- `DesignLibrary/kit/index.html` — the Kit Book. Use what is there before
  drawing anything new.
- `research/GYM_HUB_K8.html` and `TRAINING_HUB_K9.html` — your own
  hub pattern. SCHEDULE sits beside them and must look like the same game.
- `DesignLibrary/screens/gym_hub/` — the shipped renders. That is the bar.
- `research/SETPIECE_FRAME_K7.html` — the frame board 3 hands off
  to. Match its entry, do not redraw it.

Do not open `ScheduleBoard.gd`, `EventsBoard.gd`, `EventDetailScreen.gd`
or `GameState.gd`. Everything you need from them is written above.

## Rules

- Deliverables land in `research/` and nowhere else. Owned files:
  `SCHEDULE_HUB_K10.html`, the `SCHEDULE_K10_*.png` renders, and
  `research/K10_DIGEST.md`.
- **Do not edit `HANDOFF.md`.** Claude writes your block (standing rule).
- Previews are PNG or JPG. No code, no `.gd`, no `.tscn`.
- Commit with your Co-Authored-By line, push `master`, then END the
  session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/SCHEDULE_HUB_K10.html
research/K10_DIGEST.md
```
