# S14 — THE SUBSTITUTE COLUMN: A MISLABEL CORRECTED, AND A COUNTER THE CLOCK CANNOT AFFORD

Claude, 2026-09-18. Greenlit by the operator: "Go B with A folded in then c".
Numbers: `research/S14_PRESENTATION_SPLIT.md` (after) against
`research/S13_PRESENTATION_SPLIT.md` (before). Instrument for Part B:
`Godot/tools/probe_counter_budget.gd`.

## DECISIONS

1. **PART A LANDED, AND IT IS A MISLABEL CORRECTED — NOT A PRESENTATION WIN.**
   `boxing_rear_hook` now resolves through `FightBeatAdapter.TECHNIQUE_CLIP_ALIASES`
   instead of `FightStagePlayer.NEAREST_CLIP`. **The picture was already right and
   the measurement was wrong about it.** 14,368 beats — 4.28% of every action beat —
   were being published as "shows a move that was never thrown" when the room was
   playing a rear hook for a rear hook the whole time. **No pixel moved.**
2. **PART B IS OUTCOME 2: THE MECHANISM EXISTS AND THE BEAT CANNOT AFFORD IT.
   NOTHING WAS BOUND.** A slip→cross chain is 1.503 s. The median budget on a
   counter beat is **0.30 s**. Measured over 612 counter beats, the chain fits
   **11.9%** of them — and that figure is a CEILING, not an estimate (below).
   On the other 88.1% the queue cuts, which plays the slip and **never reaches the
   cross the engine scored** — strictly worse than the bare cross shown today.
3. **THE OBSTACLE IS THE CLOCK, NOT THE SEQUENCER.** Both halves of the mechanism
   already exist: `FightStagePlayer.play_role:366-373` blends and `queue()`s a
   second clip behind the first, and `_queue_decide:714-718` already PRICES such a
   pair as one clip by summing the lengths. A counter could be built on that
   tomorrow. It would not show, because `FightPresentationQueue.decide` rule 5
   plays a clip only while `clip_len_s <= budget_s`.
4. **THE TASK FILE'S FILM TABLE IS STALE, AND THREE OF THE SEVEN ARE ALREADY
   BOUND.** `H2H_SlipRight` and `H2H_FadeBack` are listed as unbound; both are
   `slip` variants today (`FightClipBinding.gd:347-354`), alongside `H2H_SlipLeft`.
   `slip` does NOT play one direction only. The genuinely unbound four are the
   `H2H_Dodge_*` films.
5. **NO CONTACT SHEETS WERE RENDERED, AND THAT IS DELIBERATE.** The render exists
   to inform a binding. Part B binds nothing, so the sheets belong to the stage
   that would — named at the bottom of this file. Saying so beats rendering seven
   films for a decision this stage does not take.

## PART A — THE ARITHMETIC, AND IT IS EXACT

One line moved. `boxing_rear_hook: "hook_rear"` left `NEAREST_CLIP` and joined the
alias table beside its own mirror `boxing_lead_hook`, which had been aliased since
S13 with no reason recorded anywhere for the asymmetry.

| | S13 (before) | S14 (after) | move |
|---|---:|---:|---:|
| EXACT | 158,731 (47.3%) | 173,099 (51.6%) | **+14,368** |
| SUBSTITUTE | 66,543 (19.8%) | 52,175 (15.6%) | **−14,368** |
| DEGRADE | 77,677 (23.2%) | 77,677 (23.2%) | 0 |
| GENERIC | 16,894 (5.0%) | 16,894 (5.0%) | 0 |

**The two moved figures are the same number to the beat, and the other two did not
move at all.** That is the signature of a relabel: nothing was bound, nothing was
routed, and no clip changed. `boxing_rear_hook -> hook_rear` has left the substitute
ranking entirely; `boxing_catch_counter -> cross` is now rank 1.

`tests/fight_clip_alias_test.gd` passes at 168 checks, 0 fails — check 7 (an id may
not sit in both tables) stayed green because the `NEAREST_CLIP` row was deleted in
the same edit.

## PART B — WHY THE COUNTER STAYS A BARE CROSS

`boxing_catch_counter` (10,369) and `boxing_slip_counter` (6,258) are 16,627 beats
where the engine scored a DEFENSIVE counter and the room shows a bare cross.

### The mechanism was never the problem

- `FightStagePlayer.play_role:366-373` — a knockdown blends and `queue()`s the
  get-up behind it, then queues the stance behind that. A two-clip beat exists.
- `_queue_decide:714-718` — that pair is PRICED as one clip: `clip_len` becomes
  the fall plus the get-up, precisely so "the first blow after it would [not] cut
  the man down mid-rise". The pricing exists too.

### The clock is

`FightPresentationQueue.decide` rule 5 plays a clip only while
`clip_len_s <= budget_s`; rule 6 otherwise CUTS to the readable peak. `budget_s` is
the gap to that same body's next scheduled action (`FightLiveSchedule.budget_for`).

`Godot/tools/probe_counter_budget.gd`, 5 seeds, 3 rounds, boxing:

| | counter beats | chain 1.503 s | cross alone 0.833 s | slip alone 0.670 s | p50 budget |
|---|---:|---:|---:|---:|---:|
| pooled | 612 | **73 (11.9%)** | 117 (19.1%) | 137 (22.4%) | **0.30 s** |

**And the control row, which is the finding** (S10's rule — tally the whole
population beside the subset): across all **7,546** scheduled action entries the
median budget is **0.30 s**, the same as the counters'. Counter beats are not
starved relative to the room; **the whole room runs on a 0.30 s median beat**, and a
1.503 s chain is five times that.

Note what the cross column says: the bare cross played TODAY already fits only
19.1% of these beats. The room is cutting this row before anything is changed.

### Why the number is a ceiling and not an estimate

`budget_s` is not stored on a queued entry — `take_due:249` computes it as the entry
is taken. The probe calls the same pure `budget_for` on the queued schedule, and
`budget_for` only looks FORWARD, so the earlier entries `take_due` removes cannot
change the answer. The room keeps the schedule filled `HORIZON_S` = 3.5 s ahead
(`FightWorldLiveScreen:606`), so **every gap below 3.5 s is priced identically live
and here**. Where the true gap EXCEEDS the horizon, live falls back to
`known_to_s - lead_cap_s`, which is smaller. **Live can only price a beat the same
or lower than this probe — never higher.**

### The change it would take, named

A counter cannot be afforded inside the present budget rule, so any real fix is one
of these, and each is its own stage:

1. **Make a counter a SET PIECE.** Rule 2 lets a set piece own the clock outright,
   which is exactly how the knockdown chain escapes the budget. It is also why this
   is not a free move: rule 1 says a set piece in flight drops everything else, and
   16,627 beats promoted to set pieces would take the pacing apart.
2. **Give the schedule a longer gap after a counter.** That is an engine change to
   `FightLiveSchedule`, it moves the beat density every calibrated number rests on,
   and it needs its own re-baseline.
3. **Author a single counter clip** — one film that is the slip and the return in
   one performance, so it is one clip against one budget. We own no such film, and
   `H2H_*` has none. This is a purchase or an authoring job, and `R144_LINE3` says
   what authoring costs.

**Option 3 is the only one that does not disturb something already calibrated**, and
it is the one to put to the operator when this row is reopened.

## WHAT THE NEXT STAGE ON THIS ROW WOULD DO

Render `H2H_Dodge_Back/Forward/Left/Right` (the four genuinely unbound films;
`Q47_INVENTORY.csv` has them all at 0.67 s) and decide whether any is a counter's
defensive half worth a single-clip binding — then take option 3 above, or refuse
the row on content the way R127 refused the uppercut. Windows come from
`C92_STRIKING_CONTENT.md`, never copied off a neighbour.

## NOT TOUCHED, AND ON PURPOSE

Both uppercut rows (R127's watched refusal), the four PARTIAL combination and body
rows (incomplete is not false), the route row (S15's), and whether footwork carries
the man (ruled 2026-09-18).
