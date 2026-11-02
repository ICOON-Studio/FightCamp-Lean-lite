# S4e (3) — STANCE: WHAT THE ENGINE HAD, WHAT IT HAS NOW, AND WHAT IS STILL OPEN

Claude, 2026-09-15. Stage S4e (ENGINE FIRST, operator ruling 2026-09-14 night), the third of the five behaviours the
operator named. Measured with `Godot/tools/measure_stance.gd` through the production path (`FightRealtime.begin` /
`advance_tick`); gated by `Godot/tests/fight_stance_test.gd`. The model is `Godot/scripts/FightStance.gd` and BOTH
engines call it.

## POPULATION

The SAME two bouts S4e (1) and S4e (2) measured, so all three parts of the stage are comparable line for line. Both
pairs NON-IDENTICAL, both men LEGAL for the ruleset they fight under — differentiated by style and attributes inside
it, never by removing a technique the ruleset permits (operator rules 2026-09-12). **The only thing that moves between
rows is which foot a man leads with.**

| bout | floor | A | B |
|---|---|---|---|
| BOXING, 8x180 s | ring, half_width 3.00 m (6 m square) | Out-boxer: reach 190, 188 cm, 79 kg, speed 72, power 48, defense 68 | Pressure fighter: reach 175, 177 cm, 80 kg, speed 52, power 70, defense 50 |
| MMA, 3x300 s | cage, half_width 4.55 m (9.1 m flat to flat) | Striker: reach 188, 185 cm, 84 kg, speed 68, grapple 35, defense 60 | Grappler: reach 180, 180 cm, 84 kg, speed 55, grapple 78, defense 58 |

30 seeds per variant per bout (seeds 810000-810029), round time only, rest excluded. Catalogue: the shipped
`combat_rulesets.json` boxing and mma entries, tier 1-2 fundamentals for men with no `technique_progress`.

## WHAT WAS THERE BEFORE — C133 Q3, verbatim: "The real-time engine has none"

1. **A LABEL NOTHING READ.** `TaleOfTape.gd:75` backfills `ORTHODOX`/`SOUTHPAW` off a hash of the athlete id, the UI
   panels print it, and `FightRealtime` had never once looked at it.
2. **A DEFERRED NOTE.** `BalanceState.gd:8`: stance "will define weak lines when the vector lands; it is not consumed
   here."
3. **TICK PARITY IN THE PRESENTER.** `FightStageDirector.hand_for` picked lead or rear from `tick % 2`, and said so in
   its own comment: *"Orthodox and southpaw do not exist in the real-time engine at all."* A jab was shown with the rear
   glove about half the time.
4. **ONE REAL MODEL, IN THE ENGINE BEING REPLACED.** `FightSimulation._stance_matchup` (`:3453`) derives OPEN/CLOSED
   from the two athletes and `_stance_draw_factor` spends it on what a man reaches for (`:461`, U18 D3).

C133 Open 4 named the answer: *"The atomic engine's open/closed matchup is the only stance work already done — reuse it
rather than inventing a second."*

## WHAT CHANGED

**The model MOVED rather than being rewritten.** `FightStance.gd` now holds the matchup, the three marker lists, the
family test and the draw factor; `FightSimulation`'s four functions are one-line delegations to it, so every seeded
atomic bout is byte-identical. There is one stance model in the project and two callers.

- `FightRealtime._build_fighter` carries `stance` (ORTHODOX unless the record says otherwise — `TaleOfTape`'s own
  default, so a fixture that never mentions stance is CLOSED rather than a silent third state).
- `FightRealtime.begin` settles `stance_matchup` ONCE, beside the arena shape, off the ATHLETE records. U18 D3 refuses
  switch-hitting until a fighter owns an authored switch skill, so it cannot change inside a bout.
- `FightMoves.move_from_node` settles each move's `stance_family` once, where the arsenal is settled.
- `FightMoves.select` multiplies the matchup's factor into R101's joint walk — **a third weight, not a third draw.**
  Seven draws per built impact still holds and no stream position moves.
- `FightRealtime`'s action event now carries `stance_matchup` and `hand`.
- `FightStageDirector.hand_for` takes the engine's hand where there is one and keeps tick parity where there is not.
- `FightBeatAdapter._present` carries both fields onto the beat.

### THE INVARIANCE THAT MAKES THIS STAGE CHEAP

`FightStance.draw_factor` is **exactly 1.0 on every closed matchup**, which is how U18 D3 wrote it: closed is the
posture every fight in this project has silently assumed and been balanced around. Every existing fixture omits
`stance`, so every existing fixture is CLOSED, so **no seeded pin moves.** The test proves it from the other side: two
SOUTHPAWS are also a closed matchup, and their whole seeded log checksums identically to two orthodox men's —
`sha256=96ec0eb0...` for both boxing rows, `3c6a64ea...` for both MMA rows, over 30 bouts each. The engine spends the
MATCHUP, not the LABEL.

S4e (1) moved four recorded sweeps and ten judge cards; S4e (2) left two reds. This stage moves none.

## THE MEASUREMENT

**The realism rule is a PREVALENCE, and it is DOCUMENTED.** K27 (Kalli, 2026-09-10, ten sourced samples) puts pure
southpaw at ~16-20% of broad pro boxing/MMA and ~20-25% at elite level, and refused BY NAME to ship a single "southpaw
win advantage %". Under random pairing a southpaw share p makes 2p(1-p) of BOUTS open-stance: **26.9-32.0% broad,
32.0-37.5% elite.**

**The engine's own roster reads 24.2% southpaw over a 2,000-id census of `TaleOfTape.migrate_athlete` → 36.7% of bouts
open.** That is inside K27's ELITE band and above its broad-pro band, for every athlete in the game. Reported, not
tuned — see Open 1.

**The SIZE of the open-stance effect has NO STUDY.** `EDGE` (0.08), `DRAG` (0.06) and `JAB_SHARE_SHIFT` (0.08) are U18
D3's authored numbers and are reused UNCHANGED. TASK_K63 Q4 is the assigned research and asks for exactly this.

### What the engine delivers

The two ratios U18 D3 actually predicts, each with its own denominator. A share of NAMED throws is the wrong reading
here: in MMA a submission sends the bout to the floor, every ground technique lands in `other`, and all three family
shares fall together with no draw having changed (the 2026-09-15 lesson, re-earned in the 2-bout calibration).

| bout | variant | LEAD share of the two hands | BODY share of kicks | connect% | endings |
|---|---|---|---|---|---|
| BOXING | closed | **32.22%** (n=7,206) | — (no kicks) | 46.1% | 11 KO / 19 DEC |
| BOXING | closed_southpaw | 32.22% (n=7,206) | — | 46.1% | 11 KO / 19 DEC |
| BOXING | open | **29.29%** (n=7,539) | — | 46.2% | 11 KO / 19 DEC |
| MMA | closed | **37.11%** (n=3,942) | **48.64%** (n=5,707) | 46.4% | 5 KO / 23 DEC / 2 SUB |
| MMA | closed_southpaw | 37.11% (n=3,942) | 48.64% (n=5,707) | 46.4% | 5 KO / 23 DEC / 2 SUB |
| MMA | open | **35.02%** (n=3,698) | **49.06%** (n=5,316) | 46.5% | 4 KO / 20 DEC / 6 SUB |

The direction is U18 D3's in both bouts: the jab's share of the two hands falls when the matchup opens (-2.93 pp
boxing, -2.09 pp MMA) and the body kick's share of the kicks rises (+0.42 pp). **Connect% does not move** (46.1 -> 46.2,
46.4 -> 46.5), which is the check that stance stayed what U18 D3 said it was — a change to what a man REACHES FOR, never
a damage multiplier.

The draw arithmetic itself is gated exactly rather than sampled: swept over 10,000 rolls, one jab against one cross,
the jab's share is 0.5000 closed and 0.4654 open against the 0.94/1.08 odds ratio's 0.4653.

### The MMA endings moved, and this measurement cannot say stance did it

Submissions went 2/30 to 6/30 and round minutes 401.8 to 374.6. **Stance touches no grappling code**; what moved is
every seeded MMA trajectory, because changing any draw changes the fight from that tick on — the same thing S4e (1) and
(2) saw. But 2-in-30 is exactly the one-in-twenty rarity class that has already fooled this project once
(`fight_beat_grapple`, 2026-09-15), and 30 seeds cannot separate a trajectory shuffle from an effect. **Not a finding.**
The boxing endings are identical both ways (11 KO / 19 DEC), which is the cleaner read.

## WHAT THE ROOM SHOWS NOW

`hand_for` was tick parity; it is now the technique's own hand where the catalogue names one — a jab is the LEAD hand
and a cross the REAR hand, **in both stances**, which is exactly why the hand is answerable without a second clip set.
Over 30 boxing bouts the engine names a hand on 7,206 of 30,877 throws (23.3%); the rest are kicks, hooks, uppercuts and
unnamed fallbacks, and they keep the parity they had.

**The room still mounts ONE stance.** K27 and G46 both say a southpaw is a mirrored CLIP SET rather than a flag — G46
found an indie title that shipped the pose-only mirror and had a man standing southpaw throwing orthodox punches until
the studio duplicated the whole clip set. So "lead" and "rear" still name the near and far hand of whatever stance the
caller mounts. The engine says which hand THREW it; the room shows the hand it has.

## OPEN

1. **The generator is at ELITE southpaw prevalence for everybody.** 24.2% measured; K27's broad-pro band is 16-20%.
   That is a ROSTER decision, not an engine one, and K27's own ruling was "2 southpaws of the twelve (3 if the roster is
   elite-skewed)" — worth putting to the operator with the number in hand rather than retuning a hash quietly.
2. **`FightMoves._chosen` never returns `fit`, so `FightRealtime.gd:2016`'s `range_fit` is ALWAYS 1.0 and
   `RANGE_FIT_PENALTY` has never once fired.** R102's channel 1 is half dead: `live_set_with_reach` really does let a
   man reach for the wrong tool (the weight half works), and he is then never punished for it on the contact ladder.
   Found while adding a key to that same function. NOT fixed here — it moves every seeded fight and it is its own slice
   with its own switch and its own re-baseline, exactly as "a merge is not its branches" requires.
3. **No switch-hitting, by U18 D3's own refusal**, until a fighter owns an authored switch skill. `mma_stance_switch`
   exists as a catalogue node and nothing consumes it.
4. **The defence half of stance is untouched.** U18 D3's open-stance list includes the lead feet fighting for the
   outside line; the engine has no notion of an outside foot, and `FightStance` deliberately does not invent one.
5. **`JAB_SHARE_SHIFT` still has exactly one consumer** — the atomic engine's burst texture. The real-time engine has
   no burst, so the closed half of U18 D3's ruling ("closed fights are jab-and-step") is not expressed live.

## Re-running it

```
godot --headless --path Godot --script tools/measure_stance.gd          # 30 bouts, ~4.5 min here
godot --headless --path Godot --script tools/measure_stance.gd -- bouts=4
godot --headless --path Godot --script tests/fight_stance_test.gd       # the gate, ~20 s
```
