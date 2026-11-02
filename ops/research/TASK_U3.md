# TASK U3 — CURSOR — THE BODY BY REGION: SIX CLOCKS, ONE FIGHTER

**Status: COMPLETE (2026-09-07, `f03c13f`).** Cursor holds **Maria's art-direction
seat** this cycle. Runs ahead of the implementation, the way M11 ran ahead of
R53. Blocks nothing; the stage it rules is not written yet.

Model: mid tier, effort medium, Fast off. One session.

## Why this exists

The operator ruled on 2026-09-07 (HANDOFF, standing):

> **The game will model recovery and healing per BODY PART, realistically.**
> Not a single readiness clock with an age multiplier on top — the six regions
> `BodyReadiness` already tracks heal on their own terms, and a torn hamstring,
> a broken hand and a concussion are not the same injury slowed down by the
> same factor. This is a FUTURE stage: it needs its own research pass and its
> own implementation.

That stage has no visual language, and it is the single most dangerous screen
this project has left to draw. Six regions, each with its own injury, its own
healing clock and its own history, on one human being — done badly it becomes a
wound chart, a red-splattered anatomy diagram, or a spreadsheet of six
identical bars that says nothing a single number did not already say.

**This pack rules how it reads, before anyone builds it.** You are not writing
the system and you are not designing the healing model.

## What already exists, and is not yours to reopen

- **The six regions are real and already drawn.** `BodyReadiness` tracks
  `head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`, `right_leg`.
  `ProfileRevampPanel._fill_regions()` (`:1874`) already renders one cell per
  region with its value and the cage's own threshold tick; `_fill_recovery()`
  (`:1984`) draws the recovery options. Look at what is there before you rule
  on it — `DesignLibrary/screens/profile_revamp/body_lab.png` is the current
  bar.
- **M6 owns the medical family** and is not reopened: `BAD` / `AMBER` / `GOOD`,
  and the one badge `HELD` / `NOT CLEARED` / `CLEARED`. A hold is a solid `BAD`
  plate; `INJURED` is a status and a separate chip; `GO` is never borrowed for
  cleared.
- **M11 owns age and wear** and is not reopened: age is ink weight, never hue;
  **wear is `TRACK` recess plus `LINE_SOFT` and DIM micro-ticks — history, not
  wounds**; wear never becomes `HELD`; and M11 refusal #10 forbids "wear =
  scar-red overlay — wear is recess/edge, **not anatomy**".
- **U2 (yours, landed) rules age cost off this surface entirely**: medical hold
  and suspension copy stays age-blind; wear chrome never means years.
- **J12's findings the per-region system inherits**, which your pack must not
  contradict: training-load recovery and injury healing are **separate clocks**
  (D2); concussion hold days are **not** age-scaled in any rulebook (D9); years
  and mileage are both real and **not interchangeable** (D5).

## The questions this pack must answer

Maria's form: options considered → ruling → written why → refusals. Rule at
least these five.

1. **One body or six rows?** Does a per-region state read as a figure/silhouette
   with regions marked, or as six labelled rows? M11 refusal #10 and the
   standing "ripped art never ships" rule both press on the first answer; the
   second risks six identical bars that add nothing. Rule it, and say what
   carries the region's IDENTITY if there is no anatomy picture.
2. **Six clocks at a glance.** A fighter with a hand at four weeks, a leg at one
   and a head clear is the normal case. What does the player see first — the
   worst region, the soonest clear, or all six? What does the ONE number the
   rest of the game already uses (`minimum_readiness`) become once six clocks
   exist behind it?
3. **The badge cannot lie.** M6 gives the fighter one clearance badge. When one
   region is `HELD` and five are `GOOD`, what does the whole-fighter badge say,
   and how does the region view avoid contradicting it? Name the rule that keeps
   them in agreement forever.
4. **Now versus ever.** A region hurt today and a region hurt three times over a
   career are different facts. M11 gives history DIM micro-ticks; does that
   survive contact with six regions, or does history need its own place?
5. **Where this appears, and where it must NOT.** The BODY tab is certain. Does
   `UIKit.squad_row` or the training board ever need a region? U2 Q5's clean
   surfaces list is the precedent — write the equivalent for regions, by name.

## Deliverables

1. **`research/U3_THE_BODY_BY_REGION.md`** — the pack. Maria's structure:
   the call up front with the written reason, a token map (existing tokens
   only), the rulings, the refusals list that stops re-proposal, and the
   standing constraints you are holding.
2. **Engine-rendered boards** to `DesignLibrary/screens/body_by_region/`
   (`u3_01_*.png` …). **This is the part Maria could not do and you can**: you
   have the repo, Godot 4.7.2 and a shell, so your boards are the real kit
   rendering real state, not mock-ups. Follow the existing harness pattern —
   `Godot/tools/Capture*.gd` extends `SceneTree`, builds an isolated career,
   renders at 1920x1080 and saves the viewport (see
   `tools/CaptureStage4DRecoveryPreviews.gd`). Add your capture script under
   `Godot/tools/`, name it for U3, and leave it in the repo so the boards can be
   re-rendered when the kit moves.
   Cover at minimum: the six-region view as you rule it; the "one HELD, five
   GOOD" case from question 3; a history-versus-now case; and one refusals
   board.

## Settled — do not spend a ruling reopening these

- **No new token and no new UIKit factory** (M11, K10 standing). If a board
  needs something the kit cannot draw, name the gap in words; do not invent it.
- **No new rail item and no new hub.** The BODY tab exists.
- No anatomy art, no wound art, no ripped assets, no bitmap body map. Code-drawn
  or kit-drawn only.
- Females never fight males; veterans are never caricatures.
- One figure once per screen; pair blocks never in the header colour.
- The visual bar is the R18 profile (`DesignLibrary/screens/profile_revamp/`).

## Owned files

- `research/U3_THE_BODY_BY_REGION.md` (new)
- `DesignLibrary/screens/body_by_region/` (new)
- `Godot/tools/CaptureU3BodyRegions.gd` (new, or your own name)

**Do not touch:** any `.gd` under `Godot/scripts/`, any `.tscn`,
`Godot/assets/data/`, `HANDOFF.md`, or the tests. In particular **Claude owns
`GameState.gd` and `BodyReadiness.gd` on R55 this same cycle**, Codex owns
`OfficeHubPanel.gd` on C38, and Grok owns the new `RegionHistory.gd` on G13.
Your capture script may READ those scripts; it may not edit them.

## Landed since this task was written (2026-09-07, R54)

Two things now exist that your question 5 must account for by name:

- **A `commission_battery` flag** rides the same alert strip and the same GYM
  chip column as the medical hold — level `info`, icon `clipboard-pen`, text
  "EXTRA CLEARANCE REQUIRED · NSAC, NYSAC". It is a licensing errand, **not a
  hold and not a wound**: it blocks nothing and it must never read as either.
  Your six-region view shares a surface with it; rule how they sit together.
- **`Aging.commission_battery()` and `Mileage.gd`** mean the game now carries
  mileage triggers as well as years. U3 does not rule those, but a region view
  that quietly implies "this leg is old" would contradict M11 and U2 at once.

Neither changes a ruling you were already asked for; they widen question 5.

## Parse gate

Only if you add the capture script:

```
python Godot/tools/check_scripts.py Godot/tools/CaptureU3BodyRegions.gd
```

## Test

You add no test. Prove the boards instead: state in the digest the exact
command you ran to render them and confirm the files exist. Then run the full
suite ONCE in the background before the commit to prove you broke nothing.

## Done

Commit and push `master`, write `research/U3_DIGEST.md` (short), send one
line with `python Tools/agent_comms.py send`. **Do not edit `HANDOFF.md`** —
Claude writes your block.
