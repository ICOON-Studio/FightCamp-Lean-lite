# Q31 — THE STOPPAGE READ

Qwen, 2026-09-10. Research only. `tools/probe_stoppage.gd` ran 300 seeded 3×5
boxing bouts (seeds 7000–7299, the standard boxer-vs-wrestler fixtures) and
snapshotted both fighters' state at every tick. Numbers below come from that
run, not from reading the code.

---

## 1 — What the engine can say at an arbitrary tick

| Fact | Available | Source |
|---|---|---|
| `body_condition` — six regions, each 0–100 | **at every tick** | `fighter["body_condition"]` via `body_condition_of()` |
| `stamina` — 0–100 tank | **at every tick** | `fighter["stamina"]` |
| `shocked` — flash hurt flag | **per impact event only** | `ev["shocked"]` on the action returned by `advance_tick`; not cumulative |
| `knockdown` — per impact | **per impact event only** | `ev["knockdown"]` on the action |
| `flash_knockdown` — per impact | **per impact event only** | `ev["flash_knockdown"]` on the action |
| `knockdowns_round` — this round | **at every tick** | `fighter["knockdowns_round"]`, resets at each bell |
| `knockdowns_total` — whole bout | **at every tick** | `fighter["knockdowns_total"]` |
| `trauma` — six sites × two kinds, 0–4 pips each | **at every tick** | `fighter["trauma"]`, `FightTrauma.total_pips()` |
| Round number | **at every tick** | `Clock.round_number()` |
| Fight seconds | **at every tick** | `fight_seconds(state)` |
| Scorecards so far | **at round boundary only** | `state["scorecards"]`, appended by `_close_round` |
| Corner advice | **at round boundary only** | `state["corner"]`, appended by `_close_round` |
| `stoppage` — the engine's own end state | **at end of fight only** | `state["stoppage"]`, empty until `_stop()` |

**What is NOT on the fighter at a tick:** any cumulative shock count, any
rolling damage window, any "able to defend" read, any punch absorption rate.
The engine tracks shocks and knockdowns as **events on impacts**, not as
accumulated state on the man.

---

## 2 — Is there a cumulative "he is finished" signal?

**No.** There are only instantaneous ones.

- `shocked` is a flash on one impact. The fighter carries no shock count.
- `knockdown` is a flash on one impact. The fighter carries `knockdowns_round`
  (resets at each bell) and `knockdowns_total` (whole bout). These are the only
  cumulative damage counters on the man.
- `body_condition` is a one-way tank that recovers only at the corner (flat
  4.0/min × conditioning scale). It does not carry history.
- `trauma` accumulates pips but never heals mid-bout. It is the only truly
  cumulative damage record, and it lives on the face — not the body that is
  being asked about.

The corner's read — "has he been taking too much for the last two rounds" — is
not a quantity the engine carries. The verb would have to accumulate it itself
from the impact log or from a rolling counter it maintains.

---

## 3 — The two distributions

300 bouts. 52 stopped (50 KO, 2 TKO, 0 doctor). 248 went to decision.

### Stopped fights — loser's state at the instant of stoppage

| Quantity | min | median | max |
|---|---|---|---|
| head_neck | 72.1 | 88.5 | 99.1 |
| torso_core | 91.4 | 96.6 | 99.3 |
| stamina | 68.2 | 79.5 | 98.5 |
| trauma (total pips) | 0 | 0 | 5 |
| knockdowns_total | 1 | 1 | 3 |
| shocks (total suffered) | 1 | 2 | 6 |

### Decision fights — loser's state at the final bell

| Quantity | min | median | max |
|---|---|---|---|
| head_neck | 67.0 | 75.3 | 84.5 |
| torso_core | 86.9 | 93.8 | 98.2 |
| stamina | 59.4 | 66.4 | 69.1 |
| trauma (total pips) | 0 | 2 | 9 |
| knockdowns_total | 0 | 0 | 3 |
| shocks (total suffered) | 0 | 3 | 9 |

### Overlap

| Threshold | Stopped ≤ / ≥ | Decision ≤ / ≥ |
|---|---|---|
| head ≤ 25 | 0.0% | 0.0% |
| head ≤ 15 | 0.0% | 0.0% |
| torso ≤ 50 | 0.0% | 0.0% |
| trauma ≥ 3 pips | 3.8% | 18.1% |
| knockdowns ≥ 2 | 17.3% | 8.1% |

**The head_neck distributions do NOT overlap at the low end.** The lowest
stopped-fight head is 72.1; the lowest decision-fight head is 67.0. The
stopped-fight MEDIAN head (88.5) is HIGHER than the decision-fight median
(75.3). The men who get stopped are the men whose heads are still mostly
intact — they are stopped by a single acute event (a knockdown from one clean
punch), not by accumulated head damage.

**The distributions that DO separate the two populations are knockdowns and
trauma, but in opposite directions:**
- Knockdowns: stopped median 1, decision median 0. A stopped man was knocked
  down; a decision man usually was not.
- Trauma: stopped median 0, decision median 2. A decision man has MORE face
  damage than a stopped man, because he stayed in long enough to accumulate it.

---

## 4 — The warning window

**The doctor threshold (head ≤ 15) was never reached during active ticks in
any of the 52 stopped fights.** Zero. The engine's own doctor stoppage is
unreachable for these fighter profiles, which is consistent with R86's report
that it "no longer fires between two ordinary men over 12 rounds."

Because no stopped fight crossed the doctor threshold, there is no warning
window to measure against that threshold. The stoppage mechanism for these
bout profiles is the KO (one knockdown, failed recovery roll) and the TKO
(three knockdowns in one round) — both are **instantaneous events**, not
threshold crossings on a cumulative quantity.

**If the corner's threshold is knockdown-based instead:**
- 50 of 52 stopped fights had the loser with ≥ 1 knockdown at stoppage.
- But 20 of 248 decision fights (8.1%) also had the loser with ≥ 2 knockdowns.
- The first knockdown in a stopped fight happens at a range of fight times;
  there is no "early warning" because the knockdown IS the stoppage.

**The warning window is effectively zero seconds for the mechanism that
actually stops these fights.** A corner threshold on knockdowns fires at the
same instant as the engine's own KO. A corner threshold on head condition
never fires at all.

---

## 5 — The doctor stoppage

`_maybe_doctor_stoppage` (line 937) reads ONE thing:
`body_condition["head_neck"]` for each fighter. If it is ≤ 15.0, the fight
ends as `DOCTOR STOPPAGE`. It runs only between rounds (called from
`_close_round_at_bell`), never during active ticks.

In 300 bouts of 3×5, it fires **zero times**. The head never drops to 15
because `ImpactModel`'s wear coefficients (head 1.0, WEAR_SCALE 0.6) and
`corner_recovery` (4.0/min) produce a steady state well above 15 for these
fighter profiles. R86 measured 10.5 points of head per round; over 3 rounds
that is ~31 points of wear, but the two corners (at 4.0/min × 1.0 conditioning
scale ≈ 4 points each) bring back ~8, netting ~23 points of loss from a
starting 100 — landing around 77, which matches the decision-fight median of
75.3.

**Should the corner's read be the same quantity at a lower threshold, or a
different quantity?** A different quantity entirely. The doctor reads the
head as a structural-integrity measure (is the skull still protecting the
brain?). The corner's read is about **capacity** (can he still defend
himself?). These are different questions. The head number alone does not
answer the capacity question — a man with head 85 who just took a knockdown
and two shocks in the last minute has less capacity than a man with head 70
who has been trading clean blows steadily.

---

## 6 — What is MISSING

| Fact the verb wants | Engine has it? | Derivable? |
|---|---|---|
| Cumulative shock count (how many times he was hurt this fight) | **No** — `shocked` is per-impact, not on the fighter | Yes: walk the log, count `shocked == true` for this target |
| Recent-window shock count (last N seconds / last round) | **No** | Yes: walk the log filtered by tick range |
| "Able to defend" read (the ref's own quantity) | **No** | Not directly. The ref uses recovery_chance (conditioning + IQ + head) on a knockdown. No continuous version exists. |
| Punch volume absorbed in recent window | **No** | Yes: walk the log, count impacts targeting this side |
| Clean-head shots in recent window | **No** | Yes: walk the log filtered by region + contact |
| Cumulative trauma (already exists) | **Yes** | N/A — `FightTrauma.total_pips()` |
| Knockdowns total (already exists) | **Yes** | N/A — `fighter["knockdowns_total"]` |
| Body condition (already exists) | **Yes** | N/A — `fighter["body_condition"]` |
| Stamina / heart rate (already exists) | **Yes** | N/A — `Cardio.from_stamina()` |

Everything the verb wants that is not already on the fighter is derivable from
the impact log, which `state_view()` already exposes by reference. No new
engine surface is needed to compute a cumulative read — only a function that
folds the log into a rolling window, which is the same shape as
`RealtimeRoundStats.fold` and `BroadcastRead`.

---

## Verdict

**Yes-with-a-named-addition.** "Ask for the stoppage" is buildable on today's
engine, but NOT on a simple body-condition threshold — the distributions prove
that no head/torso/stamina threshold separates stopped from decision fights.
The addition required is a **cumulative shock / recent-window fold** that the
verb maintains itself from the impact log. The raw materials (the log, the
per-impact shock and knockdown flags, the body condition, the trauma pips) are
all present and accessible at every tick via `state_view()`. The missing piece
is the accumulation, and it is a pure function of data the engine already
emits — no new engine surface, no new state on the fighter, no rewrite of the
seed.

The one number that matters: **the warning window is zero seconds against the
engine's own stoppage mechanism (KO/TKO), because the mechanism is an
instantaneous event, not a threshold crossing.** A corner verb that fires on
the same signal (knockdown) is decorative — it adds nothing the engine does
not already do. A corner verb that fires on a CUMULATIVE signal (e.g. "three
shocks in the last 60 seconds" or "head below 70 AND two knockdowns") is a
genuinely new decision that the engine does not make, and that is where the
verb's value lives.
