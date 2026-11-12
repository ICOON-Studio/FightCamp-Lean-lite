# R29JUDGES1 blind review (S443, 2026-11-12) - PR 238, branch qwen/r29judges1

Verdict: **COLLECT WITH FIXES** - the parts were nearly right; the scoring, the verdict and the card reason had real defects,
and the test could not catch three of the defects the brief names. Seat: the brief named Arena; the dispatcher gave it to Qwen
(qwen3-coder). Both files were rewritten at collect (module 207 -> 273 lines, test 223 -> 259 lines).

Read: ops/research/TASK_R29JUDGES1.md, FIGHT_LINK_MAP_S432.md M2 (lines 200-226), `gh pr diff 238`, and the game code the
module claims to read: scripts/state/LiveRound.gd 345-372 (the exchange record), scripts/state/RingDuel.gd 315-351
(`after` = state(), hurt flags, `perks`), LiveRound 97 and 430-436 (a round opens with `her_hurt` carried from the bell,
and the closed round holds `start`), LiveRound 332 (`setup` = su.used, "landed" / "missed"), scripts/rules/Duels.gd 9-12.

## a. Brief items (as delivered)
| Item | Status | Where (delivered Judges.gd) |
|---|---|---|
| 1 PARTS / leans / WEIGHTS / LEAN_MULT | DONE (WEIGHTS ints; no JUDGES1 comment) | :5-9 |
| 2 parts(): clean, big, ring, initiative, work | DONE, one hole | :15-64: a hurt carried over the bell (LiveRound keeps her_hurt into the next round) was counted as a fresh big shot in the first exchange of the round |
| 3 panel(seed, pro) | DONE | :66-73 |
| 4 score_round: totals, 10-9, level rule, counts | WRONG twice | :102-127: the reason always named the LEAN's part, even when another part decided the round (a ring judge's card that a won on clean punches read "Ring: ..."); the last level step gave the round to a always ("%s won the last exchange" with names[0]) instead of to the side that won the last exchange |
| 4 reason words | WRONG | :136 "Clean: %s landed %d to %d" printed a's and b's numbers in a/b order even when b was named ("Priya landed 10 to 11"); :140 "kept the fight where **they** wanted it" - a pronoun, which the brief forbids |
| 5 cards(): verdict | WRONG | :164-184: "majority" never produced; two cards one way and the third level read "split" |
| 6 card_reason(c, judge) | WRONG (dead) | :187-206 read c.rounds / c.leans / c.pro / c.names, keys cards() never returns, so it returned "" for every card |

| Required assert | Status (delivered test) |
|---|---|
| a lands more -> 10-9 on all cards | DONE (but the round also gave a ring and initiative, so "nothing else differs" was false) |
| close round: ring card a, clean card b | DONE |
| counts 10-8 / 10-7 / cancel | DONE |
| level total to the lean's side | WRONG: the round gave a an initiative point, so it was never level |
| forward exchanges only when won by the side that wanted the place | MISSING |
| big shots incl. held hurt adds nothing | DONE |
| panel same seed / never work / never initiative | WEAK: one seed each |
| cards over 3 rounds: running, split vs unanimous | WEAK: three identical rounds (the brief: never two identical rounds); the split check accepted "split OR unanimous" |
| reasons hold a name, no pronoun | WEAK: substring "they " - the ring reason's "they wanted" passed only because no ring reason was ever produced |
| MUTANTS fail the same asserts | WRONG: each mutant was compared on its own, different assert (not the asserts the module passes), and `MUTANT caught` was printed unconditionally |

## c. Mutants
On the DELIVERED source with the delivered test: initiative ignoring who won - **NOT caught**; card_reason returning "" -
**NOT caught**; a 2-1 split read as unanimous - **NOT caught**. (Its own two mutants were caught.)
On the FIXED source with the new test, 7 of 7 caught: initiative ignoring who won, no "majority", a carried hurt counted as
fresh, the last-exchange rule always a, card_reason ignoring the lean on a tie, an amateur panel drawing "work", work counted
for amateurs. The in-test mutants (no LEAN_MULT, counts ignored) now run through one `_score_ok(scorer)` that the real
scorer passes, and print `MUTANT caught: <name>` only when they fail it. The new test against the delivered module: parse
error (it calls the new `Judges.counted`); the defects above were each shown by the mutant runs.

## d. Words
Every round reason holds the winner's name first and no pronoun: "Clean: Priya landed 11 to 10.", "Ring: Lucy kept the
fight in the pocket, 4 exchanges.", "Initiative: Lucy came forward and won 3 exchanges to 1.", "Work: Lucy set the busier
pace, 70 to 50.", "Big shots: Lucy landed 1 to 0.", "Count: Lucy took a count." / "took 2 counts.", "Even round: Priya won
the last exchange." A card reason adds the rounds: "Ring: Lucy kept the fight in the pocket, 4 exchanges (round 3)".

## e. Files
Only the two OWNS files. No test deleted.

## Fixes made
scripts/rules/Judges.gd:
- parts(): reads the round's optional `start.hurt` (LiveRound's closed round carries it) so a hurt carried over the bell is
  not a fresh big shot; adds `ring_at` (which place each side kept), `pace` and `last` (who won the last exchange) for the
  reasons and the last level step. Places clamp to Duels LONG..INSIDE.
- score_round(): returns {a, b, reason, part, lean}; `part` = what decided it: the part that gave the winner most of the
  weighted margin (ties: the lean, then the PARTS order), "count", or "last"; the level steps are lean (only when the card
  counts that part), clean, then the last exchange's winner. Counts as before (net counts, every card).
- reason_of(): the winner's own numbers first, the place word for ring (Duels.PLACE_WORD), no pronoun; `_name` guards an
  empty names array.
- cards(): unanimous 3-0, split 2-1, majority 2-0 with one level card, draw otherwise (1-0 with two level = draw, winner "").
- card_reason(c, judge): reads cards()'s own output: the part that moved most points to that card's winner (tie -> the
  judge's lean), the round where it moved most, the rounds it decided; "" for a level card.
- `counted(pro)` and `points(p, part, lean)` helpers (the test's mutants use them); WEIGHTS floats with the JUDGES1 note.
tests/judges_test.gd rewritten: four hand-built rounds, all different (a lands 12-9 with nothing else; b lands 11-8; the
close round a keeps the pocket 4 of 6 while b out-lands 11-10; level rounds), every expected card summed in a comment; the
items above incl. forward exchanges, a carried hurt, work only pro, 60-seed panels, exact running cards, split / unanimous /
majority / draw, exact card reasons, whole-word pronoun check, mutants through the shared asserts.

## Test runs (main checkout, through godot_slot --who qwencollect)
- `JUDGES failures=0`, `MUTANT caught: _no_mult`, `MUTANT caught: _no_counts`.
- regression: `BOUT_RULES checks=65 failures=0`, `FIGHT_STATS failures=0`, `FILE_LIMITS failures=0` (Judges.gd 273 lines).

## Left for the wiring (Claude, later; not this module)
- BoutNight builds the round dict from LiveRound's closed round: `exs` = its "exchanges", `start` = its "start", `counts`
  from the knockdown record, `pace` = the two pace dials 0-100.
- The weights stay ESTIMATES until probe JUDGES1.
