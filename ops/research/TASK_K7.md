# TASK K7 — KALLI — the set-piece frame and the way in and out

Self-contained. Read this file and nothing else. No code ships from this
task: the deliverable is a study, the same shape as K4 and K5. START
WHENEVER YOU HAVE CREDITS — not gated on a date.

## Why this exists

Stage R20 splits the game into two kinds of screen and they need to LOOK
like two kinds of screen.

A SCREEN lives inside the persistent shell: the rail on the left, the top
bar with the day strip and Continue above it. The Day, My Gym, Fighters,
Training, Schedule, Events, Scouting, Rankings, Office. The shell never
unloads; the body swaps beneath it. That frame is built and shipped —
`ShellChrome.gd`, Stage R17.

A SET-PIECE takes the whole screen and the shell goes away: Fight Week,
the Weigh-in, Fight Night, the Result, the Crowning. These have their own
pacing and their own way back. Right now they have no visual language at
all — Fight Night is literally a widget drawn inside the office desk
screen — so the moment the game should feel biggest is the moment it
looks smallest.

Design that language.

## Deliver

`research/SETPIECE_FRAME_K7.html` plus PNG renders at 1920x1080,
one per board, named `SETPIECE_K7_<board>.png`.

Four boards:

1. **THE HANDOFF.** Four to six frames of the transition from a shell
   screen into a set-piece and back. What the rail does as it leaves,
   what covers the seam, how long it takes. It must read as the game
   changing gear, not as a scene load. Say the durations in
   milliseconds — the router will play exactly what you draw.
2. **THE SET-PIECE FRAME.** The empty frame itself: what replaces the
   rail and the top bar, where the way out lives, where the clock or the
   round counter goes, how the fighter's name and the stakes are carried
   when there is no breadcrumb any more. One frame, reusable by all five.
3. **THE FIVE, DRESSED.** The same frame wearing each set-piece: Fight
   Week, Weigh-in, Fight Night, Result, Crowning. Show what changes
   between them and — this is the point — how little should.
4. **THE INTERRUPT.** A set-piece is where the game says something
   final. Show the treatment for a stoppage, a decision being read, and
   the belt changing hands. One of these three is the single most
   important frame in the game; pick it and make it the one you spend
   your best work on.

## Constraints (these are rulings, not preferences)

- Kit only: colour, type and sizes come from `Godot/scripts/UITokens.gd`.
  Bebas Neue for display, IBM Plex Mono for everything else. Gold is the
  championship accent and is spent on ONE thing per frame. Green is
  Continue and nothing else.
- 1920x1080. Nothing smaller than the kit's SIZE_MIN — the user has
  ruled twice that text must be clearly readable.
- One figure once per screen. Pair blocks never in the header colour.
- The facility is a GYM, never a "camp". A fight camp is only the
  pre-bout preparation — which is exactly what board 3's FIGHT WEEK is,
  so that one word is correct there and nowhere else.
- Ripped art never ships. Reference is fine in the scratchpad; nothing
  from another game enters `Godot/`.
- Assume no new character art exists. If a frame needs a fighter, it gets
  a silhouette or the portrait system that already ships.

## What to look at first

- `Godot/scripts/UITokens.gd` — the whole palette and type scale, 160
  lines, read it all.
- `DesignLibrary/kit/index.html` — the Kit Book, 102 built variants. Use
  what is there before drawing anything new.
- `DesignLibrary/screens/profile_revamp/` — your K4/K5 work already in
  the shipped style; match that bar.
- `DesignLibrary/teardowns/` — MMA Arena and Corner King in particular
  for how a broadcast moment is framed.

## Rules

- Deliverables land in `research/` and nowhere else. Owned files:
  `SETPIECE_FRAME_K7.html`, the `SETPIECE_K7_*.png` renders,
  `research/K7_DIGEST.md`, and your own block in `HANDOFF.md`
  (max 8 lines; never touch another agent's block).
- Previews are PNG or JPG. No code, no `.gd`, no `.tscn`.
- Commit with your Co-Authored-By line, push `master`, then END the session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/SETPIECE_FRAME_K7.html
research/K7_DIGEST.md
```
