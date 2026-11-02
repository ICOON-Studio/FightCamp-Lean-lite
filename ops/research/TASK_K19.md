# TASK K19 — THE LIVE FIGHT SCENE: HOW IT READS (Kalli)

Model: top tier, effort high, Fast off. **Study only**: no `.gd`, no
`.tscn`, no HANDOFF edit. Push your `research/` deliverables; Claude
writes your block.

## Why now

The operator wants the fight to become a **live, real-time isometric
scene** the coach watches and interrupts — a camera on the two fighters,
world-space instruments that travel with them, and a tactical action bar
that issues macro commands mid-round. Codex has the architecture half of
that question (C17: viewport, tick, intervention mechanics, market
comparison). **You have the half that decides whether it reads**: what the
scene looks like at 1920×912 and where every instrument lives.

Your own K16 ruled this surface four days ago and R31 shipped it
(`05c3131`, boards in `DesignLibrary/screens/ring/`, digest
`R31_DIGEST.md`): a 2.5D stage with a venue plate, a drawn floor, two
photo silhouettes, and kit instruments around it — condition rails over
the stage, move strips under it, ONE morphing corner dock, the 8-second
combo band, the verdict stamps. K16's rulings held. **This study asks
whether an isometric camera changes any of them**, and the answer is
allowed to be "it does not" for any instrument you defend.

## The question, precisely

An isometric world moves the fight from a flat proscenium picture to a
CAMERA on a floor. That breaks three things your K16 boards settled:

1. **The rails.** Today ours is top-left and theirs is top-right, fixed.
   In a camera scene the fighters move. Does condition stay pinned to the
   frame, or does it become a world-space billboard over each fighter's
   head — and what happens when they clinch and the two billboards
   collide?
2. **The read at a glance.** A coach has one or two seconds between
   exchanges. Isometric depth costs legibility: a fighter can be occluded,
   small, or facing away. What guarantees the player can always see who is
   hurt and who is gassing?
3. **The tactical action bar.** The operator's brief names live buttons —
   "Press Forward", "Go for Takedown", "Protect the Cut". Today those are
   the corner dock's pace and emphasis calls, pressed in a dock that never
   moves. Does the isometric scene want the same dock, or a different
   grammar — and if the call can be waved off by the fighter's own listen
   roll, how does the button SHOW that it was heard, half-heard, or
   ignored?

## Constraints you already own, and they still bind

Bebas / IBM Plex; `SIZE_MIN` 12; **gold ×1 per board**; green is CONTINUE
only; a doctor stoppage is semantic BAD; IPPON and TECHNICAL superiority
are not knockouts; the facility is a GYM; ♀ never fights ♂; silhouettes,
never portraits; invent nothing that is not in a read. The K7 set-piece
frame (not ShellChrome) owns the way out, the stakes line, the round digit
and the two names — the scene must not say them twice. The body is
**1920×912** inside a 1920×1080 board.

Two facts from the code that constrain the picture, both verified:

- The simulation has **no spatial state at all** — no positions, no
  distance, no facing. It emits discrete exchanges roughly every 14 fight-
  seconds, drawn at 1.4 s of wall clock. Any choreography is invented from
  the event, so do not design a board that depends on a real grappling
  position the model cannot supply.
- The one hard real-time beat is the **8-second incoming-combo window**.

## Deliver in `research/`

- `FIGHT_SCENE_K19.html` + boards at **1920×1080**, K7 set-piece chrome:
  1. **THE CAMERA** — the isometric round, live. Where the camera sits,
     what it frames, and every instrument in its place.
  2. **WORLD vs SCREEN** — the same moment drawn twice: once with
     condition as world-space billboards over the fighters, once with it
     pinned to the frame as R31 ships it. Pick one and say why; show the
     clinch case where the two fighters overlap.
  3. **THE CALL** — the tactical action bar mid-round: the command
     pressed, the fighter's answer (heard / waved off), and what the
     player sees in between. This is the board that decides whether the
     coach feels impactful without the fight feeling arcade.
  4. **STATES** — contact sheet: the ground phase, a hurt fighter, the
     8-second combo window over the live camera, the LAB dress, the AI
     CORNER watch, and the finish stamp.
- `K19_DIGEST.md`, in your usual shape: the PICK and the two rejects, the
  priority order while fighting, gold ×1 per board, the kit gaps named as
  instruments, what you KEEP from R31 unchanged and what you replace, the
  reads you relied on, and the blockers.

## Rule

Judge, do not restate. Every ruling here either survives K16 or replaces
it explicitly. If the honest answer is that the isometric camera buys
spectacle and costs legibility, say so with the board that proves it —
this decision is worth more than a comfortable one.

## Files you may read

`research/K16_DIGEST.md`, `RING_K16*.png`, `R31_DIGEST.md`,
`DesignLibrary/screens/ring/*.png`, `Godot/scripts/RingStagePanel.gd`,
`Godot/assets/data/ui_kit_manifest.json` (family "ring"),
`DesignLibrary/kit/renders/ring-*.png`. Do not open `FightSimulation.gd` —
the two facts you need from it are quoted above.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/RingStagePanel.gd
research/K19_DIGEST.md
```
