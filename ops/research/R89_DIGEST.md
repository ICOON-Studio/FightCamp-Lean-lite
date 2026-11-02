# R89 — THE GRADE THAT MEANS SOMETHING

Owner: Claude. Base `ad40468` (`SUITE total=211 fails=1`, the one failure
Codex's `grapple_contract_test.gd`, red by design until the grapple modules
land). Touched: `GameState.gd`, new `Godot/tests/grade_progression_test.gd`.
**`GradeLadder.gd` was not edited** — said here so the next reader does not go
looking for the change.

---

## What shipped

`GradeLadder.gd` was the **eighth** piece of correct, tested, unreachable code
in this project: 181 lines, a passing blind contract test (Q9T), no `.uid`
because it had never once been opened in the editor, and not a single loader
anywhere but that test. It now has a caller in the game's own weekly pass.

C52 settled what a grade **is** (decision 5: independent, issuer-scoped,
awarded by an issuer, never won from an opponent, never derived from the seven
stats) and C55 recorded that it had **no consequence**. Neither is re-derived
below. What is new is that the clock runs, the gym is told, the gym decides,
the money moves, the record keeps it, and the ladder **stops at** the
professional door instead of walking through it.

* `_ensure_grade` makes a grade record on first sight, keyed **by
  discipline** — C55 ruled portability is never assumed, so crossing to judo
  does not carry a BJJ blue belt across and the belt is still there if he
  crosses back.
* `_advance_grades(career_week, overrides)` runs from `advance_week` beside
  `_advance_aging`, for the same reason: time at a rung is a week, not a
  seventh of one, and the pass draws no dice for the daily scale to spread.
* `_grade_verdict` is the only place eligibility is decided. It is a policy
  layer **over** `GradeLadder`, never a replacement for it.
* `award_grade(athlete_id)` is the gym's decision (C55 rec 1). It re-derives
  eligibility and never trusts the weekly pass's flag — the flag is a notice,
  not an authorisation.
* `get_grade_read` / `get_career_path_read`, both spliced onto
  `get_amateur_read`, which a live screen already calls.

## The defect this stage existed to find, and it was real

**Every ladder's FIRST rung is a dead end, and wired naively the whole feature
is a wall.** IBJJF publishes no adult minimum at white, the IJF none below 1st
kyu, IMMAF none at all, so `MINIMUM_WEEKS` holds five pairs and every other
transition answers `unknown` — and `GradeLadder` is **right** to refuse: an
unknown rule must never grant a promotion. But the first rung is where every
fighter in the game starts. Wired straight through, `white -> blue`,
`6th kyu -> 5th kyu` and `novice -> amateur` are all unknown and **nobody in
the game can ever take one step**. That is a "clear path of evolution" that is
a locked door, and it would have passed a green suite exactly the way U20's
`absorbed`/`slipped` and the unreachable flash knockdown did: every function
correct in isolation, the pieces unable to line up.

The fix keeps the sourced module honest. `GradeLadder` still refuses to
invent; the **game** authors one interval, in `GameState`, labelled, and it
fills exactly one case:

* `GRADE_AUTHORED_WEEKS := 52`, used **only** where the answer was `unknown`.
  A sourced minimum always wins, and the read's `evidence` field names which
  one answered — `sourced` or `authored`.
* 52 is the **shortest** interval C52 actually sourced (IBJJF brown → black,
  IJF 1st dan), so an authored step can never undercut a real one.
* The sourced **age** gate is honoured inside the authored branch too.
  `GradeLadder` returns `unknown` before it ever reaches age, so skipping it
  there would let an authored interval walk past a real rule rather than
  around a missing one.

Same standing as R44's membership rate and C32's corner rule: the game's own
number, authored once, labelled `invented` wherever it is read.

## The consequence, which is what C55 said was missing

1. **It costs money.** `GRADE_FEE := 150` leaves the gym's cash and appears in
   the ledger as its own outflow row, `source: "invented"` and never
   `evidenced` — C52 explicitly refused to guess a grading fee, so the ledger
   says whose number it is.
2. **It stops at the one-way door.** IMMAF's last rung is literally
   `professional`. Awarding it to an amateur would turn him professional
   through a side entrance nobody was ever asked about — the automatic
   conversion C52/C55 (J2 D5) refused. `_grade_verdict` returns
   `pro_door` and `award_grade` refuses it. Walk the real door (`_turn_pro`,
   two production callers since C39/C50) and the rung opens. **The grade
   ladder now names the door rather than bypassing it.**
3. **It is on the record.** Every award appends a dated entry to
   `career_path`, and it is carried on the amateur read beside the amateur
   record: what he has done, and where he stands.

## The two rulings the task asked for

### C55 rec 3, the dated `career_path` — **IN R89**

A grade award is exactly the kind of dated event it exists to hold, and
without it an award leaves no trace that survives the next award: the record
holds only the current rung, so a man who went white → blue → purple looks
identical to one who was handed purple. That is R88's rule again — **store
what cannot be recovered, project what can** — and the rung he is on today
cannot recover the ones he passed.

It is also cheap *because* it is appended at seams that already exist rather
than by a system that would have to go and find them later: `award_grade`
writes the grade entries and `_turn_pro` writes the one-way door, three lines.
Shipping it here means it arrives holding **two kinds** of event, which is a
history; shipped alone with one kind it would have been a grade log wearing a
general name.

### C55 rec 2, the turning-pro confirmation — **BEHIND R89**

It is a *refusal flow* on two existing callers plus the screen that shows the
warning and takes the answer. It changes no data the grade strand needs, and
`career_path` — which is the part of it that outlives the dialog — has shipped
here already. Shipped now it would put a confirmation nothing can display into
the game: an unreachable dialog, the exact condition R87, R88 and this stage
exist to end, arriving through the front door. It ships **with its screen**,
the same ruling R88 made about the punch/kick tag.

## Findings — reported, not tuned away

**F1. The screen is not in this stage, and that is U17's lesson, not laziness.**
`award_grade` is the one function of the six with no UI caller. The natural
home is `DevelopmentPanel`'s discipline frame, which already has the exact
pattern to copy (caption → chip → detail → action button, as the MMA
transition block does). It was **not** wedged in: that frame is fixed-height
(`DISC_H := 532`) with its footer pinned at `body.size.y - 92.0`, and the
transition block above it already grows from data — up to four blocker rows.
Adding a block sized from data to a fixed-height frame is precisely the defect
U16 shipped and U17 had to repair, where Godot clamps the negative size at
zero and the bottom of the panel vanishes *silently*. It is assigned as
**C69** with a stated layout budget, not left as an intention. Note the
feature still **occurs** without it: the clock runs, eligibility is decided,
the news line is pushed and the read is carried every week of play. What is
missing is the button, not the mechanism.

**F2. `bjj` and `brazilian_jiu_jitsu` are the same art in eleven files and two
different ones to `GradeLadder`.** `DISCIPLINE_TAG_ALIASES` already resolves
one to the other to decide whether a man may use a mat, but `GradeLadder._key`
only lower-cases what it is handed, so the short form answers "no ladder" —
and it does not fail loudly. It hands a black belt a fresh white one, or no
belt at all, and says nothing. This is **R88's F1 one level up**: two correct
modules with passing tests that do not speak the same vocabulary. Translated
at the call site (`_grade_discipline`) because `GradeLadder` is not this
stage's file, **reusing the shipped alias table rather than a second one** —
a third alias list is how the two drift apart again. Asserted, so removing the
translation fails the suite. The permanent fix is one vocabulary and it
belongs to whoever owns `GradeLadder` next.

**F3. `entry_fee_cents` is compared against a cash figure in whole dollars.**
`gym["cash"]` starts at `STARTING_CASH := 25000` and `_money` renders it
`$25,000`, but `_book_fight` tests `entry_fee_cents > cash` directly. No
organization in the data carries the field today — which is why every amateur
fee reads `fee_unknown` — so this is latent, not live. It will bite by a
factor of 100 the day someone adds a real fee. `GRADE_FEE` deliberately does
not join the confusion: it is named for what it is and is in the same unit as
cash. Not fixed here; not mine this cycle.

**F4. The starter gym is one-third graded, and that is the honest number.**
Of the three fighters a new career begins with, only the MMA fighter has a
ladder. Boxing and wrestling get **no** grade record at all — C52 found no
universal practitioner grade in either — and the test asserts the absence
rather than letting a well-meaning later change invent one. A gym that trained
BJJ, judo, karate, taekwondo, muay thai or kickboxing would see six.

## Gates

1. **The ladder is climbable, asserted by occurrence.** A fighter starts at
   BJJ white and is driven to black through the shipped weekly pass and the
   shipped award call: four awards, `["blue", "purple", "brown", "black"]`,
   with evidence `["authored", "sourced", "sourced", "sourced"]` — one rung
   the game authored, three the IBJJF did. Not "is a promotion permitted": can
   a man actually cross a whole ladder, and what answered at each rung.
2. **A sourced rule is never overridden.** 103 weeks a blue belt is refused
   with `weeks_required 104` and `evidence: sourced`, even though the rung
   below it was answered by the authored 52. A 14-year-old is refused his 1st
   dan on the IJF's own age rule and the same fighter at 15 is eligible.
3. **The pro door holds and then opens.** An amateur at IMMAF `amateur` with
   52 weeks is refused with `pro_door`; `_turn_pro` runs; the same read is
   eligible; the rung is awarded; nothing exists above it.
4. **The money moved and a refusal moved nothing.** Cash falls by exactly 150
   per award and the ledger row is labelled `invented`. A gym with $10 is
   refused and afterwards holds $10, the same rung and the same history — half
   a promotion is worse than none.
5. **The weekly pass is wired, not merely callable.** One real
   `advance_week()` moves the grade clock by exactly one week, and still
   writes nothing for the fighters with no ladder.
6. **The reads are copies.** Neither the grade read nor the career path can be
   written through, and history cannot be forged by appending to the read.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grade_progression_test.gd
```

`GRADE PROGRESSION checks=79 failures=0`.
