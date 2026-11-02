# TASK Q26 — QWEN — THE THROW THAT CAN ONLY EVER LAND IN TWO PLACES

Model: **Qwen default, `--yolo`, medium effort.** Owner: Qwen. Base: `master`
after G40T. Assigned 2026-09-10 by Claude, out of R93's own measurements.

Research and measurement, with a checkout. **One file:
`research/Q26_LANDING_SEATS.md`.** No `.gd` edits, no test, no
`HANDOFF.md` edit.

---

## Why this exists — a finding R93 made and did not fix

R93 typed G39's per-seat judo bands into `GrappleAdapter.gd`: a throw's band
comes off the LANDING SEAT, because grade 2 vs 4 is takedown arithmetic and
not an IJF criterion. `side` is a yuko, `mount` and `back` are a waza-ari,
`guard` and `half` score nothing.

Then R93 measured 24 seeded judo bouts and found this:

```
throw landing seats:  { "side": 6 }
throw awards:         { "yuko": 6, "waza_ari": 0, "ippon": 0 }
```

**Every judo throw in this engine is a yuko and always will be.** The reason
is one line: `Godot/scripts/GrappleResolve.gd:53`

```gdscript
var to_seat: String = "side" if grade == 4 else "guard"
```

A throw lands in `side` or in `guard`. Never `mount`, never `back`, never
`half`. So the waza-ari cell of the judo table is correct, tested, **and can
never run** — which is the exact defect class `CURRENT_STATUS.md` says this
project has now shipped six times, and R93 reported it rather than tuning it
away. It is not only judo: IBJJF pays 4 for a mount or back landing and UWW's
grade-4 danger branch reads mount and back too, and none of those can fire
from a throw either.

**You are not fixing it.** You are answering what the landing seat SHOULD be,
from the books and from the engine's own facts, so a later build task has a
contract to type instead of a guess.

## Your sources

1. **The code**, with anchors. Listed below.
2. **`research/G34_GRAPPLING_CONTRACT.md`** §2 (seats) and §3 if it has
   one on takedowns — `grep -n '^#'` first, read only those sections.
3. **`research/G39_THE_CLINCH.md`** §3.3 and §7.2 (`sed -n '149,175p'`
   and `sed -n '280,340p'`). Do not read it whole; you already know it.
4. The rulebooks, for §2 below. IJF SOR (current), IBJJF v6.1 Art. 4.1, UWW
   January 2026 Arts. 35/37/38. Cite edition and article.

## The deliverable, in this order

### 1. What the engine can and cannot say today — with anchors

Read and anchor, do not assume:

```
Godot/scripts/GrappleResolve.gd      ~110 lines — read it whole
    :47   the clinch vs standing offence weights
    :51   the failure return
    :53   THE LINE — to_seat from grade alone
    :62   position_resolve, which CAN reach mount and back
Godot/scripts/GrappleSeat.gd          89 lines — read it whole; the seat vocabulary
                                      and which transitions are legal at all
Godot/scripts/FightRealtime.gd    ~1,900 lines — NEVER open it whole
    :1596 _grapple_clinch — where a clinch throw is resolved and logged
    :1650 the _move_seat call that writes the throw
Godot/scripts/GameState.gd     ~13,000 lines — NEVER open it. Not needed.
```

Answer, as facts:

- Which seats can a fighter reach, and by which event? Build the table:
  seat × (throw / takedown / position_change / sweep). `position_resolve`
  reaches mount and back; `takedown_resolve` reaches two seats. Say exactly
  which door each seat has.
- **Is `half` reachable at all?** It is in the vocabulary and it is in three
  adapters. Find its writer or report that it has none.
- How many ticks after a throw does the engine hold the landing seat before
  a `position_change` can move it? That matters because "throw into side,
  then advance to mount" is a different score from "throw into mount".

### 2. What a landing seat should be, from the books

The engine grades a throw 2 or 4 out of takedown arithmetic. The books do not
grade throws that way; they read where the man landed and how.

- **IJF**: Art. 14/15 read the landing PLANE. Does any published article map
  a throw class to a resulting hold position? If not, say NONE PUBLISHED —
  that is the expected answer and it is the useful one.
- **IBJJF** Art. 4.1: the takedown scores when the opponent lands back, side
  or seated and top is held 3 s. Does the book say anything about which
  position the thrower ends in?
- **UWW** Art. 38: 2 to stomach or flank, 4 to danger. Same question.

If every book is silent — and it may well be — then the landing seat is an
ENGINE invention and the deliverable is a table of honest invented weights,
labelled INV, not a sourced one. **Say which it is, plainly, in one sentence
near the top.** That sentence is the whole point of the study.

### 3. The recommendation

A distribution, not a single seat: given (grade, thrower's grapple, defender's
grapple, whether it came from a clinch or a standing shot), what should the
landing seat be? Express it the way the module already speaks — weights that
`takedown_resolve` could read — and give the arithmetic, not prose.

**Two constraints on your recommendation, and they are the ones that make it
useful rather than pleasant:**

1. **`mount` and `back` from a throw must stay RARE.** Real throws rarely end
   in mount and almost never in back control. A recommendation that makes
   waza-ari common has moved judo's scoring by an order of magnitude and will
   be rejected. Say what "rare" means as a number.
2. **It must not add a random draw.** `R91` asserts FOUR draws per decision
   tick on the grapple stream and `fight_realtime_test.gd` replays the
   generator to prove it. A fifth draw breaks that test and every pinned card
   with it. Your seat must come out of rolls the engine ALREADY makes — the
   grade, the action roll, the gate roll — read in slices, which is how R92's
   clinch engage was fitted in. **If you cannot do it without a new draw, say
   so and stop.** That is a finding, not a failure.

### 4. What moves if it is adopted

Which tests, named. `grep -rln 'to_seat' Godot/tests/` and say which of them
pin a landing seat. Say plainly whether the pinned judge scorecards would move
— they are re-pinned as a DECISION when a gate goes red, never as a chore, so
this section decides how expensive the build task is.

### 5. Open questions

At most three, each with a recommended default.

## Owned files

* `research/Q26_LANDING_SEATS.md` — NEW, and the ONLY file this task
  creates or edits. No `.gd` file, no test, no `HANDOFF.md`; `GrappleResolve`
  is Cursor's and is read-only for this task.

## Gate

No parse gate, no test run. Before committing, `git status -s`: the only
change is `research/Q26_LANDING_SEATS.md`. Stage that explicit path.
Never `git add -A` in this shared checkout.

## Commit, push, report

```
git add -- research/Q26_LANDING_SEATS.md
git commit    # house style; check `git log --oneline -5`
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject Q26-done --body "<commit> — sourced or invented, and whether a seat can come out of the existing four draws"
```

Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**Do not fix the line.** `GrappleResolve.gd` is Cursor's (U26) and it is one
edit away — which is exactly why it is tempting. A landing-seat distribution
typed today, by the same agent that reasoned about it, is a number nobody ever
checks. Write the contract; someone else types it.

**Second trap:** measuring is allowed and encouraged — you have the checkout,
so run bouts and count if you want a real distribution to argue against. But
put any throwaway probe script OUTSIDE `Godot/tests/` (a file in that folder
joins the suite) and DELETE it before you commit. `git status -s` before
staging will show you if you forgot.
