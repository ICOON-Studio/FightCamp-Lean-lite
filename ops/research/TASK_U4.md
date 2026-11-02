# TASK U4 — CURSOR — HOW AN AMATEUR FIGHT IS ACTUALLY MADE

**Status: COMPLETE (2026-09-07, `ee41d4e`).** A research + ruling pass that runs
AHEAD of the implementation, the way U3 ran ahead of R55. It blocks nothing on
day one and everything on day two: C39 builds the plumbing this pass does not
have to rule, and R56 builds the surface that consumes every D-number below.

Model: mid tier, effort **high**, Fast off. One session.

## Why this exists

The game books professional fights only, and it books them out of thin air.

- `GameState.get_fight_offers()` (`GameState.gd:5300`) is a synthetic board:
  for every weight class on the roster times every `FIGHT_TIERS` tier
  (`GameState.gd:155`) it invents one offer whose opponent NAME, RATING and
  RECORD come from `RandomNumberGenerator` seeded on
  `"fight_offer|<gym>|<tier>|<class>|<week>"`. That opponent is not a person in
  the simulated world. The purse comes from a hardcoded tier table. The only
  gate is `fame_required`.
- A pool of REAL people exists — `_promotion_opponent_pool()`
  (`GameState.gd:5718`) filters the world's athletes by discipline, sex,
  retired status and weight class and sorts by rating gap — but it is reachable
  **only by a fighter already signed to a promotion**. Everyone else fights
  ghosts.
- The amateur circuit is half-built and never walked. `EntityPathway`
  (`EntityPathway.gd`, 203 lines, read it whole) already knows what an amateur
  body is (`is_amateur:117`), what entry costs (`entry_fee_cents:131`), what a
  placing pays (`prize_cents:145`), and that a purse or a promotion contract
  ends amateur eligibility (`ends_amateur_eligibility:195`).
  **`ends_amateur_eligibility()` has ZERO production callers** — grep it: the
  only callers in the repository are five assertions in
  `tests/entity_pathways_test.gd:116-120`. The one-way door is built, tested,
  and has never been walked through.
- `turned_pro` is written in exactly ONE place, `accept_signing_offer()`
  (`GameState.gd:5484`). So signing a promotion turns a fighter pro, and a paid
  bout at a non-signing organization does not — which directly contradicts P15,
  the rule the test file at `:118` already asserts.
- `GAME_DESIGN.md:72` promises "Amateur and professional records by ruleset."
  There is one record on an athlete and it is not labelled.

So: **a debut fighter with an 0-0 record is offered paid professional bouts
against invented people in week one, and there is no such thing as an amateur
fight.** That is the gap. This pass rules how the real thing works before
anybody writes a line of it.

## What you deliver

`research/U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md` — one file, and optionally
engine boards under `DesignLibrary/screens/u4_amateur/` captured by your own
`Godot/tools/CaptureU4*.gd` harness (the U3 pattern: the real kit rendering
real state, never a mock-up). **Write no file under `Godot/scripts/`.**

Structure it as: the research, then a numbered **D-list** (`D1`, `D2`, …) of
rulings in the voice of J2's D5 — each one a sentence another agent can cite
and obey without reading your prose. C39 and R56 will cite them by number.

## The six questions

**Q1 — the channels. How does an amateur fight actually reach a fighter?**
Not "how would a game do it" — how it happens. Name every real channel and say
which belong in a management game and which are noise: the coach's standing
relationship with a matchmaker or promoter; the gym-to-gym match ("my 145er
for your 145er"); the open registration card where you enter and are paired;
the interclub / smoker that has no official record; the ticket quota ("sell 20
and you're on"); the short-notice call when someone's opponent falls out; the
tournament you pay to enter and might fight three times in a day. Rule which of
these the player's DESK sees, and which happen to them.

**Q2 — who is the agent of the booking.** In the pro game the promotion offers
and the manager accepts. In the amateur game the person doing the work is
usually the coach, and the fighter's own willingness to take a bad match is
part of it. Rule who the player IS at this level and what verb the button
carries — is the player hunting bouts, approving them, or being told about
them after the fact? This decides whether the amateur board is an offer list at
all.

**Q3 — the record, and what happens to it.** What IS an amateur record — where
is it kept in the real world, how reliable is it, what does "3-1 amateur" mean
next to "3-1 pro"? Then rule for us: two separate records or one with a flag;
whether the amateur record is still shown after the fighter turns pro; whether
an amateur loss costs the same reputation as a pro loss. Cite
`GAME_DESIGN.md:72`, and hold R49 (the decision types the same outside the ring)
and R53's record surfaces — do not reopen either.

**Q4 — what gates a bout.** The real gates: registration/licensing with a
sanctioning body, an annual physical and blood work, the passbook or record
book, gender and weight, and the one that matters most —
**mandatory rest and medical suspension after a stoppage** (the ABC/IMMAF-style
suspension a fighter cannot fight through). We already have a suspension
mechanic: `body_state.medical_hold_until_week` read through `_body_hold_read()`
(`GameState.gd:7642`), R48's hold, R55's six regions. Rule whether an amateur
suspension is the SAME object or a second clock, and which real gates we ship
versus which we deliberately refuse to model. **A gate you cannot source is
UNKNOWN and UNKNOWN never gates anything** (J2 6.3, held).

**Q5 — the money, and the honest empties.** Amateurs are not paid. Rule what
moves instead: entry fee (we have `entry_fee_cents` and a `FEE_UNKNOWN`
sentinel — use them, never invent a number), travel and corner costs out of the
gym's wallet (R46's desk, `GymLedgerRead.gd`), a ticket quota if Q1 keeps it,
and prize money only where an authored `prize_table` names the division
(`prize_cents:145`, P8). Say explicitly which figures the game must show as
UNKNOWN rather than fake.

**Q6 — the door.** Rule the exact moment a fighter is professional, and make it
consistent with the P15 assertions that already exist. Today `turned_pro` moves
only on `accept_signing_offer` (`:5484`) while `ends_amateur_eligibility`
(`:195`) says a purse alone does it, whoever staged the card. That is a live
contradiction in shipped code: rule which side wins, whether the player is
warned BEFORE the irreversible step, and what the game does with the amateur
record and the amateur suspension clock at the moment the door shuts.

## Rules for this pass

- Cite sources. Where a figure is not sourced, write UNKNOWN and say what would
  settle it — the J-series house style. Do not invent a number to be helpful.
- Every ruling must be checkable against the anchors above. If you find one of
  my claims about the code is wrong, say so in the deliverable with the line
  you read; that correction is worth more than agreement.
- Hold, do not reopen: R40's pathways, J2's D3/D5, R48's hold, R49's decision,
  R55's six regions, U1/U2/U3.
- Do not design the screen. R56 draws it; your job is to rule what it must be
  true to.

## Owned files

- `research/U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md` (new)
- `research/U4_DIGEST.md` (new, short)
- ~~`Godot/tools/CaptureU4Amateur.gd`~~ (was conditional on capturing
  boards; no board was captured, so this file was never written and is
  not owned)
- `DesignLibrary/screens/u4_amateur/` (new, only if you capture boards)

Nothing else. **Do not edit `HANDOFF.md`** — Claude writes your block.

## Gate

Boards only: parse gate on your capture harness before you run it —
`python Godot/tools/check_scripts.py Godot/tools/CaptureU4Amateur.gd` — and the
full suite once before the commit if you touched anything under `Godot/`.
A pure research file needs neither.

## When you are done

Commit, push, write `U4_DIGEST.md`, then one line:

```bash
python Tools/agent_comms.py send --from cursor --to claude --subject "U4 landed" --body "<commit> — D-list has N rulings; the ones C39 and R56 must obey are D<x>..D<y>."
```

## The one trap

**The pass is worthless if the D-list is prose.** U3 worked because R55 could
open it, read a numbered ruling, and implement exactly that. If a ruling cannot
be written as "the game does X, never Y", it is not a ruling — it is a section
of the research, and it belongs above the D-list, not in it.
