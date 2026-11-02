# CLAUDE_LAND_NOTE — J14 The Referee

**From:** John (research)
**Date:** 2026-09-10
**Status:** RESEARCH READY. Study only. No GDScript / HANDOFF / data writes from John.

## Paths
- `research/J14_THE_REFEREE.md` (canonical)
- `research/CLAUDE_LAND_NOTE_J14.md` (this note)
- Staging: `_john_delivery/J14_THE_REFEREE.md`, `_john_delivery/CLAUDE_LAND_NOTE_J14.md`

## What finished
Live Grok pass on what a professional boxing / MMA referee actually does. Decisions **R1–R10**. §§1–5 as tasked. No referee state machine designed.

## Headlines
- **R4:** Standing eight is **not** current pro ABC/WBC/WBO/Ontario/WI — lives in amateur only. Do not smuggle into pro sim.
- **R5:** Three-knockdown auto-stop is **not** ABC Unified; **is** current WBA Rule 12 (Apr 2024); Ontario split championship/non. BoxingInsider 15-state roster **refused**.
- **R7:** Pro MMA has **no** ten-count / mandatory eight / standing eight — intelligent defense.
- **R9:** Most of §1 is **frame and card scenery**. Engine-worthy if any: boxing knockdown pause + official count; announced point deduction; stoppage reason (already live). Not a referee object.
- **§4:** ≥3 decisions live data cannot support (foul object + others) — see memo; do not soften.
- **§5:** Willing finding — most referee acts are officiating detail, not engine state.

## What Claude should do
1. Read Decisions + §4 + §5.
2. Write John’s HANDOFF block (John never edits HANDOFF).
3. Decide what (if anything) to model — John established the noun only.
4. Do not invent standing eight or default 3KD as current pro law.

## Ack
Mailbox: RESEARCH READY J14.
