# TASK M12 — THE BEAT: THE MOMENT THE GYM SAYS YES (Maria)

**Status: COMPLETE (2026-09-07).** Delivered: `research/M12_THE_BEAT.md` + six boards. Art direction, boards only. No `.gd`.

Model: top tier, effort medium, Fast off.

Deliverables: `research/M12_THE_BEAT.md` plus boards under
`DesignLibrary/screens/the_beat/m12_01..NN`. **Push only your own
deliverables. Never edit `HANDOFF.md`** — Claude writes your block.

## What this is

M11 (yours, 2026-09-07) art-directed THE LONG CAREER — age as ink weight,
the phase chip, wear as `TRACK` recess, RETIRED as `MUTED`, the epitaph on a
record plate. That covered the STATE.

This covers the **MOMENT**. R51b shipped the mechanic on 2026-09-07: a
fighter over the pressure line asks to retire, and the player answers GRANT
or DECLINE on the existing request card. Today, GRANT returns `ok` and the
fighter is simply gone from the roster. **A career ends with no beat at
all.**

K24 (Kalli) already ruled the shape and you are directing inside it, not
reopening it:

> Retirement is the ask plus room: the attention strip and the ACTION ROW,
> then on YES a beat with space in the spirit of R45. **A vanish is
> dishonest and a modal breaks THE DAY's grammar.**

## Board it

1. **The ask, in place.** The request card as it will really look with a
   RETIREMENT on it — GRANT / DECLINE, the fighter's own words, and the age
   ink M11 already ruled. Show it beside an ordinary PAY RAISE ask so the
   difference in weight is visible and defensible.
2. **The beat on YES.** The room K24 asked for, in R45's spirit. What holds
   the screen for a moment, what it says, and how it ends. Not a modal, not
   a vanish, not a fade to nothing.
3. **The beat on NO.** The gym asks for one more run. This is a real answer
   with a real cost — the fighter stays, and the ask returns later. It
   deserves a mark, not silence.
4. **The record plate, closed.** M11 boarded the epitaph plate on a living
   career. Board it as the LAST thing on the screen: the epilogue G9's
   module writes (`debut_week`, `final_week`, `years_active`, `peak_year`,
   `defining_win`, `why_defining`, `epitaph`, `unfinished`), on a career
   that is now over.
5. **A rejects board.** Name what you refused and why, the way M11 did.

## The rules that already bind

- **No new token.** `SELECT` does not exist in `UITokens.gd` — you found
  that in M11. Use `GYM_DEFAULT` / `LINK`.
- Age is INK WEIGHT, never hue. RETIRED is `MUTED`, **not BAD and not
  GOLD**. Wear is `TRACK` + `LINE_SOFT` + DIM ticks; BAD / AMBER / GOOD
  belong to the medical family and stay there.
- **Decline is never a word** (K24): never "declining", never "past peak",
  never "washed", on any board.
- No new rail item, no new factory (K10 standing).
- **Careers only run forward from Monday 5 January 2026.** M11's hero mock
  read "peak 2019", which no save can produce. Every year, age and date on
  these boards must be one a real career could reach.
- The epitaph is candour, not an obituary. A gym that made a career end
  well should not read like a funeral home.

## The bar

Hold it to the commercial visual bar the R18 profile renders set. A board
that could not be built from `UIKit.gd` as it stands is a board that will
not ship — say which factory draws each element.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M12_THE_BEAT.md
```
