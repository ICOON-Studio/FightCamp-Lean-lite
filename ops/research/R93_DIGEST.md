# R93 DIGEST — G39's PER-SEAT BANDS, THE CLINCH FOLD, AND THE STALL DECIDED (2026-09-10)

**Owner:** Claude. **Contract:** `R92_DIGEST.md` §5 and `G39_THE_CLINCH.md`.
Nothing in R92 was re-derived. G39's two open questions are both closed as
their stated defaults.

Touched: `GrappleAdapter.gd`, `RealtimeRoundStats.gd`, `FightRealtime.gd`,
`fight_realtime_test.gd`, `grapple_adapter_test.gd`, and — as the reconciler
of two blind tests written in parallel — `grapple_clinch_contract_test.gd`
(C73, Codex) and `judo_board_test.gd` (G40T, Qwen). Both reconciliations are
commented in place with the reason.

---

## 1. The band comes off the landing seat, and the grade is ignored

R92 read a grade-4 throw as waza-ari and a grade-2 as yuko, and said in the
file that it was INTERIM until G39. **G39 §3.3 settles it the other way.**
Grade 2 vs 4 is takedown arithmetic and is not an IJF criterion at all, while
Arts. 14 and 15 ask about the landing PLANE — which is the only thing the seat
can honestly suggest.

| Landing seat | Band | Why |
| --- | --- | --- |
| `side` | yuko | Art. 15's side landing at 90° or more |
| `mount` / `back` | waza-ari | more on the back than side; still not the four ippon criteria |
| `guard` / `half` | nothing | Art. 15: no yuko if the stomach, the front of both hips or both knees touch first |
| any, any grade | **never ippon** | Art. 14 wants speed, force, on the back AND control to the end of the landing. The engine sees none of the four. |

`use_grade_for_score` is false for judo and asserted as such: the same event
dictionary fed to `award("ijf", …)` and `award("uww", …)` now disagrees about
whether the grade mattered. Every cell is an INVENTION and G39 marks each one
INV — the IJF publishes no seat-to-score table because no referee has ever
been handed a seat instead of a throw.

An explicitly STATED band still wins. A hand-built record saying `ippon` is a
fact given, not a fact derived, and is honoured; the engine never states one.

## 2. R92 finding 1 is closed, and closed by OCCURRENCE

Judo osaekomi required an explicit `back_on_tatami` — **a fact the engine
cannot emit** — so judo's entire hold-down ladder was dead code behind a green
test. That is the sixth instance of the defect class `CURRENT_STATUS.md` names,
and it was found by reading the finding rather than by a failure.

G39 §3.3's gate replaces it: hold ticks may become osaekomi "only if the seat
is a real osaekomi-waza (side / kesa-like / mount)". **The seat is the
back-on-tatami proxy** — INV, and a narrow one. `back_on_tatami` is still read
where a caller states it; it is simply no longer required.

**BACK IS NOW EXCLUDED and that is a change from R92.** Back control is not one
of the osaekomi-waza — tori is behind uke, not across him — so it starts no
clock at any duration. Guard and half were already out (G37 REFUSE #8).

Measured, 24 seeded judo bouts: **11 rounds now score position points.** Before
R93 the number was zero and could only ever have been zero.

## 3. The `_norm` INTERIM came due

G39 §7.2's uww table settles the seat list the R92 derivation guessed at, and
it is `side | mount | BACK`. Back was the omission — the defender's back is to
the mat in all three. Grade 4 into guard or half stays 2, "the landing is not
danger", which falls out of the same boolean. 5 is still refused (§6 item 1).

## 4. The clinch stall — G39 Q2, decided

**Judo is the one ruleset with a published clinch clock.** New
`GrappleAdapter.clinch_break_ticks(ruleset)` answers **900** for `ijf` (SOR
18.1.1.4's 45 s at 20 Hz) and **-1, NONE PUBLISHED**, for everything else:
ABC has no clock at all, IFMA and WMC publish none (the "5 seconds" in
circulation is a primer, refused by name in G39 §6 item 6), UWW's 30 s is the
passivity procedure and IBJJF runs on the match clock.

R92 broke a stalled clinch on `STALL_FIRE_TICKS`, which read as though the 20
seconds came from G35 — **G35 wrote that number about the GROUND.** So the
number stays 400 and its NAME changes: `CLINCH_STALL_TICKS`, AUTHORED, in
`FightRealtime`, overridden only where a rulebook publishes one.

`-1` does not mean a clinch runs forever. It means this module has no rulebook
number to hand out and the engine's own referee decides. **MMA and boxing are
byte-identical** — `judge_panel_test` passes with the pin file UNEDITED.

The engine asks `RealtimeRoundStats.clinch_break_ticks`, not `GrappleAdapter`
directly, so a game ruleset id is never mapped to an adapter id in two places.

## 5. IBJJF

A throw scores only when the landing seat is one Art. 4.1 recognises — guard,
half, side, mount, back. A "throw" ending standing or in the clinch put nobody
on the mat. An ABSENT seat is still allowed through, on R92's own precedent
for `from_seat`. The turtle fork (Art. 4.1.2) stays REFUSED: no seat for it.

## 6. Findings, reported rather than fixed

1. **WAZA-ARI FROM A THROW IS UNREACHABLE.** `GrappleResolve.gd:53` lands a
   throw in `side` when the grade is 4 and `guard` otherwise — never mount,
   never back. So **every judo throw in this engine is a yuko and always will
   be**, and G39's waza-ari cell is correct, tested and can never run. Note the
   direction: R93 *lowers* a grade-4 throw from waza-ari to yuko, because the
   grade is not an IJF criterion. Measured over 24 bouts:
   `throw_seats={"side": 6} bands={"yuko": 6}`. The occurrence test asserts
   this **as a fact about the ENGINE**, so a later stage that gives a throw a
   real landing seat turns it red on purpose — the right response then is to
   change the line, not to revert the seat. **Q26 owns the question and has
   already landed** (`a608fca`): all three books are silent on the thrower's
   landing position, so it is an invention; a seat can come out of the four
   draws R91 already asserts, with no fifth; and `half` has no writer at all.
2. **Two blind tests disagree about the UWW 5, and both are right about
   different things.** C67's contract test (from G37) and Q22's own test both
   pin that a caller STATING grand amplitude in danger gets 5, which is UWW's
   published Art. 37/38 band. C73's new blind test (from G39) asserts no throw
   ever returns 5. G39 refuses 5 **from the engine**, where amplitude is a fact
   never emitted — not from a caller that states it. Reconciled in favour of
   keeping the published band, with the refusal asserted where it belongs: an
   event with no amplitude flag never reaches 5. See §7.
3. **A `clinch_break` is not a `kind`, it is a `via`.** The engine writes clinch
   engage and break as `seat` events with `via: "clinch_engage"` /
   `"clinch_break"`, and the stall's second fire as `via: "stall"`. G39 §7.1
   asks for a `reason` field on `clinch_break`; the distinction it wants
   already exists as `via`, so no redundant field was added. The adapter's
   `clinch_engage` / `clinch_break` kinds are fed only by hand-built records.

## 7. Both blind tests were reconciled, and both were worth having

C73 (Codex, from G39) came back 137 checks / 13 red and G40T (Qwen, from
TASK_G40's contract) 93 / 1. **Every one of the fourteen was informative.**

* **Twelve were R93's own subject** — C73's osaekomi bands — and they exposed
  a real ambiguity rather than a defect: C73 read G39 §7.2's "hold ticks on
  side/mount after throw" as a `control` event. The engine's osaekomi carrier
  is `position_change`; `RealtimeRoundStats._fold_grapple_ruleset` returns
  EARLY on `kind == "control"` and never calls `award()` at all, so an
  osaekomi asserted on `control` pins a path no real bout takes — and making
  the module answer there would be one more piece of correct, tested,
  unreachable code. **The event changed; every band, boundary and refusal C73
  wrote is untouched.**
* **The thirteenth found two blind tests disagreeing with each other.** C67
  (from G37) and Q22's own test both pin that a caller STATING grand amplitude
  in danger gets 5 — UWW's published Art. 37/38 band. C73 (from G39 §6.1)
  asserts no throw ever returns 5. Both are right about different things: G39
  refuses 5 **from the engine**, where amplitude is never emitted, not from a
  caller that states it. **Reconciled in the module, not in a test**: a 5 now
  needs BOTH facts STATED, because the derived danger is this project's own
  invention and an invention must not promote a published 4 to a published 5.
* **The fourteenth was a defect in the test.** G40T's `score_line` case is
  labelled `shido=2` and applied one shido. Fixed by applying the second
  rather than lowering the expectation, so it now also proves shidos
  accumulate. **Grok's `JudoBoard.gd` passed a test its author never saw,
  first run, with nothing else wrong** — the fifth time on this arc.

Both are green: `grapple_clinch_contract_test` 137/0, `judo_board_test` 94/0.

## 8. The two assertions that moved in Q22's own test

Both moves are on G39's authority and both carry the citation in the test.

* `grapple_adapter_test.gd`: osaekomi from **back** is now `not_scored`
  (G39 §3.3), and **side without `back_on_tatami`** now scores (the seat is the
  gate). A mount-at-25 s assertion was added so the ippon that used to be
  asserted on `back` is still asserted somewhere.

## Gate

Parse: `CHECK total=5 fails=0`. Focused: `grapple_adapter_test` 94/0;
`grapple_adapter_contract_test` PASS (215); `realtime_round_stats_test` PASS
(131); `fight_realtime_test` **PASS (349)**, including the new R93 occurrence
block; `judge_panel_test` 0 failures **with the pin file unedited**.

Full suite: see the HANDOFF block for the number at the push.

## Next

* **Q26's contract is ready to type**: one line in `GrappleResolve.gd:53` plus
  two re-pinned assertions. It is a build task, not a study, and it must not
  add a fifth draw.
* **`half` has no writer** (Q26). It is in the seat vocabulary and in three
  adapters and nothing ever reaches it.
* **Q26 also reports a hold-tick bug at `FightRealtime.gd:1684`** — unverified
  by R93 and not touched here. Verify before assigning.
* Q24's muay thai contract is landed and unwired: `RealtimeRoundStats.gd`'s
  `ADAPTER_FOR` still has no `muay_thai` entry, so MT still folds engine units.
