# TASK K9 — KALLI — the TRAINING hub

Model: top tier (Fable 5.1). Fast mode off. Decided at assignment; do not
self-escalate or downgrade.

Self-contained. Read this file and nothing else except the four references
at the bottom. No code ships from this task: the deliverable is a study,
the same shape as K7 and K8. START WHENEVER YOU HAVE CREDITS — not gated
on a date.

## Why this exists

The GYM hub shipped (R21) on your K8 boards. It answers *who is in the
building* and *what floor they train on*. TRAINING is the next hub and it
answers the other half: **what each fighter actually does with their
week.**

The legacy `TrainingScreen` is 2176 lines and is being discarded, not
migrated — that is a standing user decision. You are not restyling it.
You are deciding what the hub is.

## The question this study answers

TRAINING today is one rail item pointing at one legacy screen. FIGHT CAMP
— the pre-bout preparation for a booked fighter — currently lives under
SCHEDULE and has its own panel. They are the same act at two intensities:
one is the ordinary week, the other is the eight weeks that decide a bout.

**Does the TRAINING hub hold both, and if so how?** Tab, drawer, or a mode
the hub enters when a fighter is booked. Give a recommendation and the
reason, the way K8 called the single GYM rail item. Claude decides in R22;
this is the study pick.

The second question, smaller but real: the FLOOR board already shows who
occupies which station this week. TRAINING must not restate it. Say in one
line how the two boards divide that fact.

## What the system actually does today

Ground the study in this. It is the real mechanical surface.

- **A week is seven day chips per fighter.** Each day carries a focus:
  STRENGTH, CARDIO, RECOVERY, FIGHT, or OFF DAY. Week totals sit at the
  end of the band. An event night is marked on the band.
- **A day opens an editor.** Pick the focus, then pick equipment from the
  stations the gym owns. The editor shows how the focus hits the body
  across six regions — HEAD/NECK, TORSO/CORE, LEFT ARM, RIGHT ARM, LEFT
  LEG, RIGHT LEG — plus FATIGUE, as a before/after comparison. Some
  choices are ILLEGAL FOR THIS DISCIPLINE and say so.
- **Days copy.** PASTE and CLEAR exist so a week can be built fast.
- **Equipment matters.** A station trains particular things; condition and
  rating below a safety floor make a session unsafe.
- **Fight camp is richer:** THE OPPONENT, a sparring partner, a visiting
  coach, WEEK BY WEEK, BODY & FATIGUE, a FILM STUDY counter, INJURIES, and
  PULL OUT OF CAMP.

## Deliver

`research/TRAINING_HUB_K9.html` plus PNG renders at 1920x1080, one
per board, named `TRAINING_K9_<board>.png`.

Four boards:

1. **THE WEEK.** The hub's home: every fighter's week readable at once,
   the seven days, the focus of each, the load and the event nights. This
   is the board the manager lives on, so density is the whole problem.
   Show the sort, the filters, and how one fighter is selected.
2. **THE SESSION.** One day, opened. Focus, equipment, the six body
   regions before and after, fatigue, and the refusal when a choice is
   illegal for the discipline. Show PASTE and CLEAR where they belong.
   This is where a manager learns the game's body model, so make the
   before/after legible at a glance, not a table to be studied.
3. **FIGHT CAMP.** The pre-bout mode: the opponent, the weeks out, the
   sparring partner, the visiting coach, film study, fatigue and injury.
   Show what the hub looks like when a fighter is in camp and how it
   differs from an ordinary week.
4. **STATES.** Contact sheet: nobody booked, a fighter overtrained or
   injured, camp week one against fight week, a plan with unsafe
   equipment, and an empty gym.

## Constraints (these are rulings, not preferences)

- Kit only: colour, type and sizes come from `Godot/scripts/UITokens.gd`.
  Bebas Neue for display, IBM Plex Mono for everything else. Gold is the
  championship accent and is spent on ONE thing per board. Green is
  Continue and nothing else. A pair block is slate, never the header
  colour.
- **Reuse the gym family before minting anything.** R21 shipped 11
  factories and 18 variants under family "gym" — `squad_row`,
  `action_flag`, `filter_strip`, `sort_header`, `capacity_meter`,
  `station_tile`, `occupancy_chip`, `floor_grid`, `store_drawer`,
  `catalog_row`, `affordability_reason`. The book is at 135 variants
  across 13 families. List genuine kit gaps in a table the way K8 did,
  but only after you have tried what exists.
- **There is no drag primitive in the kit.** The floor's MOVE is
  click-arm-click because K8 asked for no drag. A week planner invites
  drag-and-drop: if you want it, you are specifying a new primitive and
  you must say so and draw its states. Otherwise plan for click-arm-click.
- 1920x1080, inside ShellChrome: the rail on the left, the top bar, and
  Continue. The gym hub puts its title, its line and its tab switch in
  the free band and starts the body at 210 — match that rhythm.
- Nothing smaller than the kit's SIZE_MIN of 12. The user has ruled twice
  that text must be clearly readable.
- One figure once per board. Silhouette avatars only; assume no new
  character art exists.
- The facility is a GYM, never a "camp". A fight camp is only the pre-bout
  preparation — which is exactly board 3, so that word is correct there
  and nowhere else.
- Females never fight males. It applies to sparring partners on board 3.
- Ripped art never ships. Reference stays in the scratchpad; nothing from
  another game enters `Godot/`.

## What to look at first

- `Godot/scripts/UITokens.gd` — the whole palette and type scale, 160
  lines, read it all.
- `DesignLibrary/kit/index.html` — the Kit Book. Use what is there before
  drawing anything new.
- `research/GYM_HUB_K8.html` — your own hub pattern. TRAINING sits
  beside it and must look like the same game.
- `DesignLibrary/screens/gym_hub/` — the shipped renders. That is the bar.

Do not open `TrainingScreen.gd`, `FightCampPanel.gd` or `GameState.gd`.
Everything you need from them is written above.

## Rules

- Deliverables land in `research/` and nowhere else. Owned files:
  `TRAINING_HUB_K9.html`, the `TRAINING_K9_*.png` renders,
  `research/K9_DIGEST.md`, and your own block in `HANDOFF.md`
  (max 8 lines; never touch another agent's block).
- Previews are PNG or JPG. No code, no `.gd`, no `.tscn`.
- Commit with your Co-Authored-By line, push `master`, then END the
  session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/TRAINING_HUB_K9.html
research/K9_DIGEST.md
```
