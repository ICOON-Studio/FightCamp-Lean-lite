# CLAUDE_LAND_NOTE — J12 Recovery and the Years

**From:** John (research)
**Date:** 2026-09-07
**Status:** RESEARCH READY. No `.gd` / HANDOFF / data writes from John.

## Paths
- `research/J12_RECOVERY_AND_THE_YEARS.md` (canonical)
- `research/CLAUDE_LAND_NOTE_J12.md` (this note)
- Staging: `_john_delivery/J12_RECOVERY_AND_THE_YEARS.md`, `_john_delivery/CLAUDE_LAND_NOTE_J12.md`

## What finished
Live Grok pass on training-load recovery vs age, injury weeks-to-return vs age, thresholds, years vs mileage, commission holds/extra clearance, and anything that recovers better with age (R54 recovery half). Grades use J1 vocabulary (DIRECT / INHERITED / UNVERIFIED_SECONDARY / UNKNOWN). Includes lift-ready table for what `Aging.recovery_scale()` could honestly encode plus an explicit could-NOT-source / do-not-encode list. Cite J10; do not reopen peak windows.

## Decisions page (cut)
| # | Short |
|---|--------|
| **D1** | `recovery_scale()` is NOT researched — author UNKNOWN if needed |
| **D2** | Keep training-load recovery vs injury healing separate |
| **D3** | Extra clearance flags, not longer holds |
| **D4** | No 30/33 recovery cliff |
| **D5** | Years AND mileage both real (not interchangeable) |
| **D6** | No averaging (sex / sport / injury / amateur-pro) |
| **D7** | Do not encode older=more sore as law (literature conflicting) |
| **D8** | MMA RTS odds may fall with age; weeks-to-heal UNKNOWN |
| **D9** | Concussion hold days not age-scaled |
| **D10** | Cite J10; do not reopen peaks |

## Priority ruling
- **P0:** refuse a researched `recovery_scale()`; encode extra-clearance / high-risk flags (35/38/40/45 + mileage); keep Q1 and Q2 as separate clocks. **Do not block R54 on a missing sourced factor.**
- **P1:** if a placeholder slope is needed, store it `grade: UNKNOWN` in data, not as researched prose
- **P2:** nothing else

## Operator question
Should R54 **author** a labelled-UNKNOWN `recovery_scale()` so the veteran *feels* slower, **or** keep BodyReadiness age-blind on healing clocks and only add extra-clearance / high-risk flags (**desk recommends the latter**)?

## What Claude should do
1. Read Decisions + §2 lift-ready / do-not-encode + §3 could-NOT-source list.
2. Write John’s HANDOFF block (John never edits HANDOFF).
3. Act on R54: UNKNOWN multiplier if authored at all; DIRECT extra-clearance flags from ARP/NSAC/ABC-family. Do not lengthen hold days by age.
4. Do not invent a researched heal-slower-per-year number.

## Ack
Mailbox: RESEARCH READY J12.
