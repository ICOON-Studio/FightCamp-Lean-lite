# THE LOGICAL FLOW: WHAT SCREENS EXIST, IN WHAT ORDER, AND WHAT THEY SAY

**LONG-RUNNING TASK - it does not finish in one pass.** Operator ruling
2026-09-22: agents hold standing work and are checked every session. Claude
re-cuts this brief from what landed; it is never restarted from scratch.

**EVERY PASS ENDS WITH AN ARTEFACT THE OPERATOR CAN JUDGE, and with a line
saying WHAT IS STILL WRONG.** A pass reporting everything finished is the one
checked hardest.

**Owner:** kalli. **Words and structure - no geometry, no colour, no fonts.**
Stage to `_kalli_delivery/`. Operator, 2026-09-22: *"use kalli and maria for
special effects logical menu presentation based on game flow."* Kalli takes the
FLOW; Maria takes the LOOK (`TASK_VFX_AND_PRESENTATION.md`).

## Where this starts, measured

**12 scenes and 64 screen/panel scripts.** The scenes are: BootRoot,
CreationRoot, CareerRoot, DayFeedScreen, AthleteProfileShellScreen,
FightContractScreen, FightNight, FightWorldLive, FightWorldPreview,
SetpieceRoot, FightAnimLab, UIKitGallery.

**Nobody has ever laid out the ORDER.** They were each built for their own
stage. The question this task answers is whether they add up to a game a player
can move through without being lost.

## The standing questions, in priority order

1. **DRAW THE FLOW.** Every screen, every route in and out, and the loop a
   career actually repeats - week to week, fight to fight. **Name every screen
   that has no way back, and every one reachable by more than one route that
   should not be.** A flow diagram in text or a table is fine; it does not need
   to be pretty, it needs to be complete.
2. **WHAT IS MISSING?** Compare the loop against what a career game needs. The
   corner between rounds is being built now (`TASK_CORNER_UI.md`), which was
   missing until today - find the rest. Name each gap and what it costs.
3. **WHAT IS REDUNDANT?** Two screens doing one job is worse than one. Say
   which to merge.
4. **THE WORDS ON THE ROUTES.** Every button that moves the player somewhere,
   and every title that tells them where they are. This is your strongest
   suit: your K74 modal states and K73 region sentences are the standard.
   **A screen the player cannot name is a screen they will not return to.**
5. **WHAT DOES THE PLAYER DO FIRST?** Boot to first meaningful decision. Count
   the steps and say which earn their place.

## RULES

- **Say NOT COMPUTED rather than inventing wiring that does not exist.** You
  marked the NEAR state NOT COMPUTED in K74 when the field was not landed yet,
  and that judgement is why your work is trusted here.
- **No geometry, no colour, no fonts** - those are Maria's and the kit's.
- Where your flow needs a screen that does not exist, **say so and name it**
  rather than assuming someone will infer it.
- **Say what is still wrong** at the end of every pass.
