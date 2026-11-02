# TASK R102 — CLAUDE — THE EXCHANGE HAS TWO SIDES, AND A DISTANCE

Model: Opus, **high** effort, Fast OFF. The engine's decision core again.
Owner: claude. Tier: **THE FULL SUITE, ONCE, AT INTEGRATION.** This moves every
seeded fight and every pinned card. **ONE rebaseline, at the end, deliberately.**

## The operator's ruling that defines this stage

> "dodge is a defender's ability, miss is the attacker's inability — these 2
> different things"

and

> "movement should be able to be measured, distance judgement before executing
> is fundamental"

Both are corrections to how the engine works today, and both are right.

## The defect, in the code, today

`FightRealtime._run_impact` rolls the contact word off the **attacker's**
technique and nothing else:

```gdscript
var contact_roll: float = rng.randf()
if contact_roll < 0.20 + 0.30 * technique:   contact = CONTACT_CLEAN
elif contact_roll < 0.55 + 0.20 * technique: contact = CONTACT_GLANCING
elif contact_roll < 0.75:                    contact = CONTACT_BLOCKED
# else                                       CONTACT_MISSED
```

**`blocked` is on the wrong side of the ledger.** A block is something the
defender DID, and here it falls out of the attacker's own technique roll at a
flat ~7.6% — the defender has no say in whether one happens. The defender's own
roll, further down, can only ever DOWNGRADE WEAR (clean → `absorbed`,
glancing → `slipped`). It can never produce a block and it can never cause a
miss.

**U20's six contact words already encode the operator's split.** The vocabulary
was right from the start; the causation drifted:

| word | whose doing | comes from now |
|---|---|---|
| `clean` | neither — he landed it | attacker — correct |
| `glancing` | **attacker's inability** | attacker — correct |
| `missed` | **attacker's inability** | attacker — correct |
| `blocked` | **defender's ability** | attacker — **WRONG** |
| `absorbed` | **defender's ability** | defender — correct |
| `slipped` | **defender's ability** | defender — correct |

## The second defect: nobody judges distance before throwing

R101 filters the live technique set by the band the fighter **happens to be at**.
He never moves in order to throw something, and he never declines to throw
because the gap is wrong for what he wants to throw. And `FightIntent.decide`
picks CLOSE / HOLD / RETREAT / CIRCLE from **his own** preferred range, **his
own** stamina and whether his back is to the ropes — signature:

```gdscript
static func decide(stats, distance, preferred, stamina, place, roll) -> String
```

**No opponent anywhere in it.** A fighter does not know he is standing inside a
longer man's jab, and `preferred_range(stats, reach_cm)` reads only his own
reach. Kiting and sidestep exist in shape and are blind.

**Throwing a hook at jab range is the purest form of "the attacker's
inability", and the engine cannot currently express it.**

## THE BACKBONE IS ALREADY MEASURED — do not commission it again

`J21_THE_MOVE_PALETTE.md` §1.1 and §2.1 carry Hristovski, Davids, Araújo &
Button (*J Sports Sci Med* 2006), graded DIRECT:

- scaled distance **D = X / arm length** is the control parameter;
- availability changes **abruptly**: **0, 2, 4 or 6** named punches live;
- **peak flexibility at D ≈ 0.6**;
- **boxers spend time at the jab-reach edge, D ≈ 1.2, because that is where the
  OPPONENT's diversity is minimised** — a coordination result in the same paper.

That last line is a measured statement about distance judgement as a *tactic*,
and it is what the movement half should reproduce. **R101 already computes D**
(`FightMoves.scaled_distance`, separation over the thrower's own arm length),
so the quantity exists in the engine for the first time.

**Do NOT re-invoke G50 against this.** G50 refused *pressure* as a predictor of
round SCORES. That is a different claim from "movement is not measurable", and
reaching for it here was a mistake made once already in this project.

## What to build — three channels, separately attributed

**1. DISTANCE JUDGEMENT, before he throws.**
A technique thrown outside the band it works at should fail far more often, and
`fight_iq` should govern how well a man judges it — which finally makes
`fight_iq` do something inside the exchange rather than only setting movement
tolerance. Hristovski's D gates are the shape. Label the coefficients AUTHORED;
the *shape* is measured, the *magnitudes* are not.

**2. THE ATTACKER'S INABILITY — the miss.**
`clean` / `glancing` / `missed` off his technique, his fatigue, and now the
range-fit from (1). This closes G51: our accuracy is **57.1%**, against boxing's
~30–32% of punches thrown and MMA's ~40–42% of significant attempts, and it is
**identical across both rulesets** — because nothing in the engine can make a
man miss for a *reason*.

**3. THE DEFENDER'S ABILITY — the dodge, the block, the check.**
`blocked` moves off the attacker's roll onto the defender's. The defender
CHOOSES a defensive technique from the **26 `defense` and 28 `adaptation`
catalogue nodes R101 deliberately left unread** (`FightMoves.STRIKE_ROLES` is
`setup / damage / counter` — the other half is untouched and already written):

```
boxing_shoulder_roll      evasion, counter_ready               dodge
boxing_slip_counter       evasion, counter_accuracy            slip
boxing_pivot_footwork     mobility, angle_attack               sidestep
boxing_cutoff_ring        boundary_control, opponent_mobility  anti-kite
kickboxing_teep_stop      range_control, opponent_mobility     kite
muay_thai_ringcraft_walk  boundary_control, tempo              kite
kickboxing_kick_check     low_kick_defense, return_damage      check
```

`absorbed` and `slipped` stay his. His defence should read his `defense` stat,
his stamina, his position (cornered men cannot slip out), and the technique he
picked.

**4. FOOTWORK READS THE OTHER MAN.**
`FightIntent` gains the opponent: his reach, his preferred range, and where he
is. Kiting is holding the gap at the edge of your own reach and outside his;
sidestepping is changing the angle rather than the distance; cutting off is
denying him the room to do either. **This is in scope** — the operator ruled
distance judgement fundamental, and Hristovski's D ≈ 1.2 result is what it
should reproduce.

## The rules that govern it

- **DRAW DISCIPLINE, and it will change.** `_run_impact` takes exactly SEVEN
  unconditional draws per built impact. A defender choice and a miss roll add
  draws. That is allowed — but the new count must be **FIXED, UNCONDITIONAL,
  taken at the top before any `if`, and asserted by replaying the stream**,
  exactly as R86 did when it swapped two draws. A conditional draw makes the
  stream position depend on the fight's content, and the next person to add a
  rule then shifts every seeded fight without touching a number.
- **ONE MODULE PRICES EVERY BLOW.** C63's ruling. The defence channel feeds
  `ImpactModel.make_impact`; it never prices anything itself.
- **ASSERT BY OCCURRENCE, WITH A FLOOR.** Every defensive word must be shown to
  actually occur in real bouts, per ruleset, and every defensive technique the
  palette can reach must be shown to be reachable. This area has shipped SIX
  pieces of correct, tested, unreachable code. Permitted is not occurred.
- **RE-FIND, NEVER RE-PIN GREEN.** `Godot/tools/find_r101_seeds.gd` already
  sweeps the four occurrence pins and the non-unanimous panel verdicts. Run it;
  do not rewrite it. T11 is NOT a pin.
- **ONE REBASELINE, at the end, in one commit**, saying which pins moved and why.

## The measurements that must move

`Godot/tools/measure_r101.gd` is the before-picture and it runs per ruleset:

| quantity | R101 (before this stage) | what R102 should do to it |
|---|---|---|
| accuracy | 57.1%, identical across rulesets | fall, and DIFFER by ruleset |
| `significant` share of impacts | **100%** everywhere | fall below 100% |
| throws per boxer per round | 81.7 | this is the denominator behind the Davis trap |
| contact word mix | `blocked` flat ~7.6% off the attacker | `blocked` earned by the defender |
| two-punch combos / boxer / round | 11.79 vs Davis 9–11 | watch it; see the trap below |

**THE DENOMINATOR TRAP, and it is R101's own finding.** Our two-punch
combinations sit inside Davis 2015's 9–11 band — but we throw 81.7 times per
boxer per round against an elite amateur's far lower output, so per throw we
combine LESS. Two errors pointing opposite ways. **If this stage lowers the
throw rate, that band comparison changes meaning. Do not report it as a pass
without naming the denominator.**

## Research in flight

**G54** (Grok, Expert, sent 2026-09-11) — is defence counted at all; is UFC
"striking defence %" a skill or an artefact of who you fought; can a slip be
told from a block in any research-grade dataset; is movement measured; does
defence cost anything measurably; the one gradeable quantity. **G54 informs
channel 3 and channel 4's magnitudes. It does NOT gate channel 1** — Hristovski
already settled that shape.

Collect it from the Grok tab before writing the defence channel, and commit it
yourself: Grok has no checkout.

## The trap most likely to cost this stage

**Do not let the defender's roll become a second miss roll.** A miss is the
attacker failing; a dodge is the defender succeeding. If both channels end up
reading mostly the same inputs and producing mostly the same word, the split the
operator asked for exists in the comments and not in the numbers. The test for
this is blunt: **hold one fighter's defence at floor and ceiling and show the
contact mix moves; hold the attacker's technique at floor and ceiling and show
it moves differently.** If the two sweeps look alike, the channels are not
separate and the stage has not been done.

## Owned files

- `Godot/scripts/FightMoves.gd` — the guard palette, the range-fit selection.
- `Godot/scripts/FightRealtime.gd` — `_run_impact`: the ladder, the draw order,
  the defender's channel.
- `Godot/tests/fight_realtime_test.gd` — the eight-draw assertion, the
  occurrence floor, the channel-separation test, the re-found pins.
- `Godot/tests/fight_guard_contract_test.gd` — C86's blind test; touched ONLY to
  fix the one cell where Claude's contract was wrong.
- `Godot/tests/judge_panel_test.gd` — the one rebaseline.
- `Godot/tools/find_r102_seeds.gd` — the liver, guard-kind and stoppage sweeps.
- `Godot/tools/repin_r102_cards.gd` — the card capture, run twice per bout.
- `research/R102_DIGEST.md` — the digest.

`Godot/scripts/FightIntent.gd` is channel 4 and belongs to **U44 (Cursor)**, not
to this task.
