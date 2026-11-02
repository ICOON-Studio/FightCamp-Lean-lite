# R130 — THE 55 UNREAD EFFECTS: WHAT EACH SHOULD DO

**This is a decision sheet for the operator, not a research document.** U59
measured the problem; this states what each mechanic would do if wired, so the
answer can be "yes", "no" or "change it" rather than composed from nothing.

**They are NOT inert, and that is the reframe that makes this urgent.**
`FightSimulation._technique_magnitude` sums the absolute value of EVERY effect
regardless of its name, and `_apply_landed_effect` pays that sum out according to
the technique's ROLE — `damage` and `counter` become health loss at ×0.55.

So **every one of these 55 keys is currently being spent as extra punching
power.** The catalogue's whole counter-and-rhythm layer is already affecting
fights — just not as the thing it is named after.

**Wiring any of these MOVES SEEDED VERDICTS BY DESIGN.** That is why it has sat
open, and why it must not ship in the same commit as anything presentational.

---

## THE FIVE MECHANICS, ranked by how much of the catalogue they cover

### 1. COUNTER / INTERCEPT — 9 keys, 40 authored entries

| key | techniques | values |
|---|---:|---|
| `counter_damage` | 12 | 6–13 |
| `stop_hit` | 10 | 6–11 |
| `counter_accuracy` | 5 | 5–13 |
| `counter_ready` | 4 | 5–7 |
| `counter_chain` | 3 | 15–18 |
| `intercept` | 2 | 7–10 |
| `kick_counter` | 2 | 9–11 |
| `counter_timing` | 1 | 8 |
| `reaction_punish` | 1 | 15 |

**THIS IS THE OPERATOR'S OWN CHALLENGE, ALREADY ANSWERED BY THE DATA.** Pushing
back on the takedown model, they said it should be contested by *"counters, like
knees or dodge"*. `stop_hit` on ten techniques IS exactly that — authored, and
unimplemented. Today a takedown is resolved as pure grappling: **nothing can
strike a man as he shoots.**

**PROPOSED:** when the defender holds a technique with `stop_hit`/`intercept` and
the attacker commits to an entry (a shoot, a chain opening, a blitz), the
defender gets a roll to land FIRST. On success the attacker's action is aborted
and the defender's technique resolves as a `counter` at its own magnitude.
`counter_damage` raises the damage of a counter that lands; `counter_accuracy`
raises the chance; `counter_ready` shortens the window needed;
`counter_chain` lets a successful counter open a chain.

---

### 2. RHYTHM / TEMPO — 5 keys, 29 entries

| key | techniques | values |
|---|---:|---|
| `combo_speed` | 14 | 5–15 |
| `combo_accuracy` | 5 | 9–15 |
| `rhythm_control` | 4 | 6–18 |
| `tempo` | 3 | 5–8 |
| `precision` | 3 | 6–11 |

**PROPOSED:** `combo_speed` shortens the gap between links in a chain (which the
presenter already models as beat spacing); `combo_accuracy` raises the hit chance
of links AFTER the first; `rhythm_control`/`tempo` bias who initiates the next
exchange; `precision` raises accuracy but not damage.

**This is the group that currently distorts the fight most**, because
`combo_speed` on 14 techniques is silently paid out as damage.

---

### 3. BALANCE — 3 keys, 18 entries

| key | techniques | values |
|---|---:|---|
| `balance_break` | 16 | 5–11 |
| `balance` | 1 | 5 |
| `kick_balance` | 1 | 5 |

**THE OPEN DESIGN QUESTION, and it was ranked but never decided:** is balance an
eighth ATTRIBUTE (some men are permanently harder to take down) or a per-tick
STATE (a man just teeped is briefly easier to shoot on)?

**U59 ranked STATE as cheaper and the authored data supports it** — a teep is
`balance_break: 5` and a throw is `balance_break: 14`. That reads as a transient
deficit, not a permanent attribute point. The ATTRIBUTE version is a save-format
bump plus every stat strip in the UI.

**PROPOSED (STATE):** `balance_break` applies a decaying penalty to the target's
takedown defence and kick-check ability for a few ticks. This is what makes
"teep him, then shoot" a real sequence.

---

### 4. FINISH / ATTRITION — 3 keys, 22 entries

| key | techniques | values |
|---|---:|---|
| `finish_chance` | 10 | 6–12 |
| `cut_chance` | 6 | 6–13 |
| `opponent_stamina` | 6 | **−10 to −5** |

`opponent_stamina` is the only NEGATIVE-valued group in the catalogue, and
because magnitude takes the ABSOLUTE value, a −10 stamina drain currently reads
as +10 damage. **That one is arguably a bug rather than a design gap.**

**PROPOSED:** `finish_chance` raises the stoppage roll against an already-hurt
opponent (not a fresh one); `cut_chance` opens a cut that bleeds score and can
trigger a doctor stoppage — elbows carry it, which is correct; `opponent_stamina`
drains the target's stamina rather than their health.

---

### 5. DECEPTION — 2 keys, 14 entries

| key | techniques | values |
|---|---:|---|
| `feint` | 7 | 4–9 |
| `surprise` | 7 | 6–10 |

**PROPOSED:** both lower the defender's chance to read the NEXT technique;
`surprise` additionally suppresses the counter roll from group 1.

---

## THE REMAINING 33 KEYS ARE MOSTLY NOT DESIGN WORK

They appear once or twice each. U59 triaged 23 of the 55 as **DUPLICATES** —
synonyms of keys that ARE read: `angle_read` for `angle_attack`, `angle_reset`
for `angle_exit`, `straight_damage` for `damage`, `close_damage`, `counter_score`,
`kick_speed`. **Those need a rename in the data, not new code**, and the rename
is safe only because magnitude ignores the name — the fight does not change.

Three are suspected authoring errors worth flagging rather than wiring:
`head_route` (4) and `body_score` (1) read like a route and a score rather than
damage, and both are mis-bucketed today by
`FightSimulation._technique_target_region`, which matches by SUBSTRING — so does
the named grapple effect `front_headlock_open`, which is pushed toward a HEAD
target as if it were a strike.

---

## WHAT IS BEING ASKED

For each of the five groups: **is the proposed behaviour right?** Change anything
that is wrong; the values are already authored and do not need inventing.

Then it is three pieces of work, in this order:
1. **The rename pass** — 23 duplicate keys onto their read equivalents. No
   behaviour change, no verdict movement, safe to do immediately.
2. **The counter layer** (group 1) — the biggest, and the operator's own ask.
3. **Balance-as-state** (group 3) — small, and it makes teep-then-shoot real.

Groups 2, 4 and 5 follow once those land.

---

## ANSWERED — OPERATOR RULING, 2026-09-12

**ALL FIVE GROUPS ARE APPROVED AS PROPOSED ABOVE.** Nothing in the proposed
behaviour was changed. The operator was offered two alternatives and declined
both: pulling `opponent_stamina` forward into the safe rename pass as a bug fix,
and approving only the rename plus the counter layer.

**The order below is part of the ruling, not a suggestion:**

1. **The rename pass** — 23 duplicate keys onto their read equivalents. No
   behaviour change, no verdict movement.
2. **The counter layer** (group 1).
3. **Balance-as-state** (group 3) — and its scope is settled separately by R131:
   scalar plus stance for the first pass, no 8-direction vector.
4. Groups 4 and 5 follow. `opponent_stamina`'s sign bug is fixed **there**, with
   its own group, and not earlier.

**Wiring any of groups 2-5 moves seeded verdicts by design.** That was stated
when the ruling was given and is accepted. It must not ship in the same commit as
anything presentational.
