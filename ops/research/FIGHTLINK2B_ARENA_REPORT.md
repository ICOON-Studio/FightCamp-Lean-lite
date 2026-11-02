# S274 digest - FIGHTLINK2B: the drilled punch is thrown more (select_mult), camp sharpness measured, windup traced

Task: `research/TASK_FIGHTLINK2B.md`. Arena, cloud. Branch `arena/fd77ef10-fightcamp-lite`.

## 1. SELECT_MULT INTO THE PUNCH CHOICE - DONE

Operator S274 ("should not those be in the fight engine ?") - yes. `MoveMastery.effects()` has carried
`select_mult` since S250 and nothing read it. S253 dropped it, with the reason written into the module:
S251 applied the same weight **inside the role pick** and measured noise - jab share 25.4 % (M15) /
27.9 % (M90) / 29.0 % (M45).

**Why S251's placement could not work, measured here.** The role stage is where the mult has to land, but
the task's own trap names the reason it must NOT land there: stage 1's weight IS the plan's
PRIMARY/SECONDARY ratio (`FightPlans.FIT_WEIGHTS`, PRIMARY 3.0 / SECONDARY 1.0 / OPPORTUNISTIC 0.5), so a
mult on the role rewrites the plan. Measured in this task, stage-1 placement gave the jab share
**-7.9 % relative** at M90 (it went DOWN). Two reasons, both from the live-set census:

- `setup` holds 8 moves and only 3 are jabs, so lifting the role lifts five undrilled punches with them -
  the same dilution S251 saw, one stage up.
- The `boxing_out_boxer` plan already throws the jab family 58.5 % of the time (`setup` is PRIMARY and the
  usage prior favours jabs), so there is very little headroom above it.

**What shipped: stage 2, inside the chosen role, on the same roll.** `FightMoves._mastery_mult` reads one
entry per candidate exactly like `fit` and `usage` do, on both the ROLE_PRIORITY walk and the single-stage
walk. `FightRealtime._mastery_select_mults` builds the `{technique_id: mult}` table for the LIVE set only.

**Measured (24 seeded bouts per arm, `tests/mastery_select_wire_test.gd`, populations named in the output):**

| arm | baseline jab share | M90 jab share | relative |
|---|---|---|---|
| `boxing_counter_puncher` (jab SECONDARY, unsaturated) | 40.4 % | 42.7 % | **+5.7 %** |
| `boxing_out_boxer` (jab already 58.5 %, setup PRIMARY, saturated) | 58.5 % | 58.9 % | +0.6 % |

The lever's size is inversely proportional to how much the punch already dominates. That is a property of
"chosen more often", not a fit to a number, and the test records the saturated edge honestly
(`>= 0`, not `>= 5 %`) instead of demanding the engine do what the plan's ratio forbids.

**Mutant arm (the one that matters):** drilling the REAR hand at M90 leaves the jab share at 59.3 % vs a
58.5 % baseline - the lever moves the drilled punch, not the plan's ratio wholesale.

**Determinism tripwire:** a jab family at USABLE 45 and no mastery at all produce the SAME log hash
(419350120 over 24 bouts). The table is not even built in that case, so no second draw exists to spend.

## 2. CAMP SHARPNESS - MEASURED

`BoutWear.recovery_mult(100) = 1/1.10` is seated on the man as `bw_rec` and read twice (S251):
commit window (FightRealtime ~6303) and FightLink slip chance (~6713). The slip lever works (S251 shipped
it). The commit lever does not: at 20 Hz a throw commits `round(0.267 x 20)` = 5 ticks, and
`roundi(5 / 1.10)` = `roundi(4.545)` = 5 - the multiplication is lost in the quantisation on every throw.
That is why "+10 % execution speed" was on the switch list and did nothing to the output.

A/B: `tools/measure_camp_sharpness_ab.gd`, `gameplan_readiness` 0 vs 100, 120 seeds x 2 fighters x 2 arms
= 480 bouts, 3 rounds. Boxing, out-boxer (counter plan, 190 cm, orthodox) vs pressure fighter (175 cm,
southpaw, different stats). Numbers: see the PR body.

**Not fixed here.** The task says "fix it only if inert" and the inert lever is a quantisation artefact of
the COMMITMENT model, not the throw rate: `FightMoves.throw_share` reads `volume x combo_boost(since_s)`
and nothing about `bw_rec` - the thing that gates how often punches come out is the ATTEMPT GATE and the
combination window, neither of which is the "+10 % execution speed" Ludo wrote about. Fixing that is a change
to `FightCommitment`'s tick rounding, which reshapes every seeded bout's commitment window - a rebaseline
decision for Claude, not a lever swap in a wiring task.

## 3. WINDUP - TRACED, NOT BUILT

The engine has no windup phase. `MoveMastery.windup_mult` remains the one unread output, and that is the
correct answer, not a gap. The trace, per throw:

| quantity | where | already scaled by `telegraph`? |
|---|---|---|
| slip chance | FightRealtime ~6709 `FightLink.whiff_chance` | **YES** - FIGHTLINK2 adds `0.20 * (telegraph - 0.5)` |
| counter window (thrower's) | `_cw_contact_s` -> `CounterWindow.window` | no - but it is a DEFENCE window, not the punch's windup |
| counter window (defender's, on a whiff) | `FightLink.whiff_cost().counter_window_s` = 0.45 s | no - constant, not per-punch |
| commitment window | `Commit.commit_ticks` | no - already carries `recovery_mult` and `bw_rec` |
| control return after contact | `PunchTiming.CONTROL_OFFSET_S` | no - **this is the windup's true home**, and it is on the PLAYBACK timeline (FightStagePlayer), not the sim |

The candidate is `PunchTiming.CONTROL_OFFSET_S`: the per-punch seconds after contact before the boxer may
act again (jab 0.12 s, rear uppercut 0.16 s, overhand 0.17 s - Ludo r119). A shorter windup is exactly
that number getting shorter, and it is already per-technique, which is what a mastery-per-technique
contract wants. **It is not built, and it should not be built by this task:** it lives on the animation
playback timeline (PUNCHTIMING1, operator board Q-S249-4, S255), where `control_return_s` is derived from
the clip's own contact/recover/length and scaled to a body-punch contact target. Scaling it by `windup_mult`
in the rules module would make the sim disagree with the animation by construction. The proposal, for
whoever owns PUNCHTIMING follow-up:

    ## in PunchTiming.control_return_s, after `offset` is read:
    if windup_mult > 0.0 and windup_mult != 1.0:
        offset *= windup_mult

Expected effect: a SIGNATURE jab returns to control ~7 % sooner than a USABLE one at M90
(`windup_mult = _raw_windup(90, 50) / _raw_windup(45, 50)` = 0.622/0.711 = 0.875), so 0.12 s -> 0.105 s.
It would double-count against the commitment window's `recovery_mult` ONLY if applied to BOTH - the
commitment window is the sim's "he is in this punch" clock, the control offset is the animation's. One
place, one effect.

## Files

- `Godot/scripts/FightRealtime.gd` - `_mastery_select_mults` + the weights call site (`select_mults`).
- `Godot/scripts/FightMoves.gd` - `_mastery_mult`, applied at stage 2 of both walks.
- `Godot/scripts/rules/MoveMastery.gd` - the S253 "not read" note replaced with the S274 decision.
- `Godot/tests/mastery_select_wire_test.gd` - NEW (red on master, 9 checks).
- `Godot/tools/measure_camp_sharpness_ab.gd` - the sharpness A/B measurement tool.
