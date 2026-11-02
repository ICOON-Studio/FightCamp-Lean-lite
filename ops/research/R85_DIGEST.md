# R85 DIGEST — THE REBASELINE

**Claude, 2026-09-09.** Base `d788f53`, suite 203/0. `judge_panel_test.gd` only;
`FightRealtime.gd` was read, not changed.

## The ruling, and why it is not "striking versus grappling"

The task offered two defensible options. Neither is what shipped, because
measuring the three excluded rulesets showed the striking/grappling line is the
wrong cut. **The line is whether a ruleset's own `scoring_profile` weights
`damage` at all** — damage is the channel the real-time engine emits, and
`RealtimeRoundStats.fold` maps every impact to `head_hand`, `body_hand` or
`legs` and returns zero for every grappling counter.

| Ruleset | `weights.damage` | Verdict |
| --- | --- | --- |
| boxing, mma, kickboxing, muay_thai | 1.0 | **re-pinned against `FightRealtime`** |
| judo, taekwondo, freestyle_wrestling | 0.0 | **left on `FightSimulation`** |

**Taekwondo is why this matters, and it is the finding of the task.** It is a
striking sport, so the striking/grappling cut would have re-pinned it. Run
through the real-time engine it produces `16-9 / 13-6 / 7-11` — plausible
taekwondo numbers, and **wrong**. Its profile scores only from zones
(`head_foot` 3.0, `body_foot` 2.0, `body_hand` 1.0), and the two kick zones are
structurally unproducible, so every one of those points is a body *punch* at 1
— the least significant score in the sport. Judo's `0-0` and wrestling's
`0-0/0-0` are honestly empty; taekwondo's card is **worse than empty**, because
it looks right. Pinning it would have pinned a plausible lie, and nobody
reading a green suite would ever have found it.

The ruling is **machine-checked, not commented** (T10): every re-pinned ruleset
must weight damage above zero and every excluded one must weight it at exactly
zero. Give judo a damage weight, or take boxing's away, and the test fails
instead of silently mis-classifying. That is the part that keeps this from
rotting.

## What was pinned

Nine bouts, up from seven — the seven striking bouts of the original ten, plus
two new ones. Each entry pins the consensus card per round **and** the verdict
the commission announced, which is more gate than the old pin carried: it is
how `boxing_7` and `muay_thai_17` still assert something despite turning in no
cards at all (each is a round-one KO, and the empty card list is the
assertion). Rounds, round length and the rest come from the ruleset, not from
`FightRealtime`'s 3x5 defaults — a boxing card scored over three rounds is a
card for a fight that was never fought.

`PRE_R38_CARDS` is retired in the same commit that adds them. At no point does
the file run with no pinned cards.

## The bridge

In the test, not in `begin`. The ten specs take an athlete shape
(`discipline`, a learned-technique list, `corner_tactical`) that
`FightRealtime.begin` does not accept; teaching the engine to read it would put
a fixture's convenience into the shipping contract. `ta`/`tb` map onto
`fight_iq`, which `FightIntent.tolerance` actually reads, so the distinction the
old fixture encoded stays load-bearing. **The technique list is dropped** —
`FightRealtime` has no technique channel, which is LIM-U22-NO-TECHNIQUE one
level up. Knockdowns are folded from the log, because `_close_round` does not
carry them onto the scorecard entry.

## R84's split-decision finding is CLOSED, in the engine's own numbers

Not described, not swept — pinned. **kickboxing seed 14 is a SPLIT** (the three
judges hand in different cards on 2 of its 3 rounds) and **boxing seed 9 is a
MAJORITY**. Both stable across two runs. Also measured, seeds 1..60 per ruleset:

| Ruleset | Non-unanimous decisions in 60 | Rounds where the panel split |
| --- | --- | --- |
| boxing | 1 majority, 1 majority_draw, 3 unanimous_draw | 12 of 407 |
| mma | 1 majority_draw, 4 unanimous_draw | 8 of 160 |
| kickboxing | **1 split**, 1 majority, 1 majority_draw, 3 unanimous_draw | 9 of 164 |
| muay_thai | **1 split**, 1 majority_draw, 2 unanimous_draw | 16 of 261 |

The panel is not decorative. R84's report was a fact about the DEFAULT profile,
which is what all of its sweeps used, and it is corrected in
`CURRENT_STATUS.md` and `HANDOFF.md` as part of this task.

## The trap, and what the next person must expect

Every bout was run **twice** and pinned only where the two runs agreed; the
test asserts that stability on every re-pin, so a secretly non-deterministic
card cannot be pinned at all. All nine agreed first time.

**R86 moved every seeded fight.** Anybody re-pinning after a tuning change must
expect exactly that and **re-run**, not assume a defect — and must not "fix" a
red card by re-pinning it, which is R75 arriving slowly.

## Findings, reported not fixed

1. **`FightSimulation.gd` STAYS.** Three rulesets cannot be rebaselined, so the
   atomic engine keeps its three cards. The ruling anticipated this (step 5);
   one engine is not reachable until grappling lands. Those three cards are
   also the only end-to-end coverage of the `ippon` and `points` styles,
   `gap_win` and the one-judge federation path — dropping them to reach a
   tidier comment would have deleted a gate.
2. **Taekwondo cannot be scored by this engine at all** and needs
   `RealtimeRoundStats` to distinguish a kick from a punch before it can be.
   That is LIM-U22-NO-TECHNIQUE, and it now blocks a whole ruleset rather than
   two zone keys.
3. **Two of the nine pinned bouts turn in no cards** (`boxing_7`,
   `muay_thai_17` — round-one KOs). The method pin is what keeps them
   meaningful; if a future tuning pass makes them go the distance, they go red
   and should be re-pinned deliberately.
4. **`FightTrauma.gd` and `Cardio.gd` are still inert** — checked, nothing but
   their own tests loads either. That is now the sixth and seventh piece of
   correct, tested, unreachable code in this area, and R85 did not touch it.
5. **`fight_trauma_test.gd` is still untracked** in the shared checkout. It
   passes (210 checks) but it is Codex's commit to make, not mine.
