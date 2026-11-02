# TASK M8 — THE BOOKS: TWO WALLETS, AND A NUMBER THE GAME MADE UP (Maria)

**Status: OPEN, assigned 2026-09-06.** Art direction only. Depends on R43
(`d5c688a`) and J5, both on `master`.

Model: top tier, effort medium, Fast off.

## The call

R43 moved the money and nothing in the game looks any different. Until this
morning the gym banked one hundred percent of every fighter's purse; now the
athlete does, in their own wallet, and the gym's delta from a bout is **zero**
unless a filed manager share clears three legal gates. J5 then ruled what the
desk honestly lives on and the answer is: membership dues that no source
publishes, a manager share that is usually $0, nothing at all for corner work,
and one weekly sponsorship cheque **whose amount the game invented**.

So the money screen has to say three things it has never said: *this is
yours*, *this is the gym's*, and *this number is not real*.

## The hard board (do this one first)

**How does a game admit a number is invented without breaking its own
fiction?**

This is the pack. Every other board is ordinary. The sponsorship cheque
(`Sponsorship.gd:13` — 250 / 400 / 650 / 1000 by tier, plus a small roll) has
no source behind it and J5 G16 rules it stays *and gets labelled*. A ledger
line therefore needs a third state beyond "a number" and "nothing":

- **evidenced** — a real figure with a citation behind it.
- **invented** — the game authored it. Present, spendable, honest about itself.
- **absent** — a real line of a real gym's ledger that this game refuses to
  make up (membership dues, corner fees). Amount zero, and the zero is a
  *decision*, not a blank.

Find the treatment that makes `invented` read as candour rather than as a bug
badge or a debug overlay. It must survive at a ledger row's size, must not
turn every screen into a footnote, and must not look like an error state — M6
owns BAD for the medical hold and this is not that. The `absent` line is the
subtler half: a missing row reads as "gyms have no members", a present row
reading zero-by-refusal reads as the truth. Both states have to be legible
next to each other in one table.

## The other boards

1. **Two wallets, one settlement.** After a bout: the purse, the win bonus,
   the performance bonus, the gate share — all of it landing in the athlete's
   wallet, and the gym's line reading zero. The zero is the story. It must not
   read as a failed payment.
2. **The gym's week.** Inflow against outflow at the standing rate: payroll
   and floor upkeep out, one invented sponsorship cheque in, two absent lines,
   and a net that is negative. The office read today prints
   `weekly_projection: -(upkeep + payroll)` — a projection with no inflow term
   at all — so this board is also the fix for a number the game currently
   states wrongly.
3. **Runway, not bankruptcy.** R43 measured a starter gym: $25,000 float,
   twenty-six weeks, ending at **-$5,342**, with **nothing in the game
   reacting to negative cash**. Dress the approach to zero and the crossing of
   it. There is no bankruptcy system and you are not to imply one — no
   game-over plate, no red alarm. This is a desk watching a balance fall.
4. **The athlete's wallet on the fighter card.** Career earnings is a lifetime
   counter and already exists; the wallet is money *held now*. Two numbers
   that are not the same thing, on one card, without either looking like a
   typo of the other.
5. **A manager share that was not collected.** Three gates — contract on file,
   the combatant's approval, a manager licence in the event state — and if any
   fails the gym takes nothing while the fighter is paid in full. Dress the
   refusal so it reads as a rule working, not money lost.
6. **The honest empty.** A brand-new gym: no deals, no roster, no history. The
   ledger with almost nothing in it still has to be worth looking at.

## Tokens

Continue Cage Desk and the M5 / M6 / M7 spend. Constraints:

- **GOLD stays spent** on M5's verdict word. Money is not gold here.
- **SODIUM is M7's champion.** Do not let a cash figure borrow the belt's
  authority.
- **BAD is M6's medical hold.** Negative cash is not an injury and must not
  wear it. Find the treatment for a falling balance that is not an alarm.
- Name the token for each of `evidenced` / `invented` / `absent`, and write
  the reason. Verify every token you call exists in `UITokens.gd` before you
  ship, as M7 did.

## Rules

- Art and spec only. No `.gd`, no `.tscn`, no `HANDOFF.md`, no data edits.
- Boards are reference, never runtime bitmaps — everything ships code-drawn
  from UITokens.
- Invent no dollar figures on the boards beyond the ones named here; where you
  need a number for a layout, use these and label them.
- It is a **gym**, never a "camp".

## Deliverable

- `research/M8_THE_BOOKS.md`
- Boards in `DesignLibrary/screens/books/` (new folder), `m8_*` prefixed
- `research/CLAUDE_LAND_NOTE_M8.md`
- Staging zip in `_maria_delivery/`

Message Claude on the mailbox when it lands. Claude writes your HANDOFF block.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M8_THE_BOOKS.md
research/CLAUDE_LAND_NOTE_M8.md
```
