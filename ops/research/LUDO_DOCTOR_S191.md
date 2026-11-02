# Ludo (lead designer) - round 7: DOCTOR STOPPAGE + CUT-PRONE SCAR numbers (S191, 2026-10-10)

Asked in the project's Ask Ludo chat (https://app.ludo.ai/project/6ac93f6894905495ba8795db), text only, one request (credits 227 shown
after). Operator S191: "ask ludo the doctor question now". Read with the browser JS tool; "=" "&" "?" "%" were masked by the tool's
filter and are restored here. Feeds LUDO-DOC1 (V10, approved D40).

## The question (verbatim)
FightCamp round 7 - DOCTOR STOPPAGE + CUT-PRONE SCAR numbers (your approved V10 + the cutman table you gave: Adrenaline Swab Bleed -1 Pip,
Doctor Risk -20%; Deep Coagulant Pack Bleed -2 Pips, Doctor Risk -45%; first hour minute 56-58 the referee pauses round 3 and calls the
doctor; towel = loss but the eye heals clean; push on = permanent Cut-Prone scar). We are building it as a pure data table now and need
YOUR exact numbers, short, as a table: 1) the cut model ... 2) when the referee calls the doctor ... 3) the doctor's verdict ... 4) the
player's choice after the inspection ... 5) the Cut-Prone scar ... 6) one acceptance test we can run headless. Keep it to these 6, numbers
only, no new systems.

## Ludo's answer, verbatim

Doctor Stoppage, Cut Severity & Cut-Prone Scar System

1) The Cut Model & Bleed Progression (Per Eye / Brow)

| Parameter | Value / Trigger Formula | Notes |
| :--- | :--- | :--- |
| Max Bleed Pips | 5 Pips (0 = Intact, 1 = Nick, 2 = Seeping, 3 = Heavy Stream, 4 = Gash, 5 = Torn Arterial) | Tracked separately for Left Brow and Right Brow. |
| Cut Open Triggers | • Head clash in clinch: 35% base check<br>• Clean Lead Hook / Rear Hook to head: (Punch Power - Defense) * 0.40%<br>• Clean Elbow / Accidental Thumb: 25% flat check | Opening roll fires only if punch lands clean (guard = 0). Minimum threshold to open Pip 1: 12 net damage. |
| Worsening Rate | Clean shot to damaged side: +1 Pip (100% on hooks), +0.5 Pip (jabs/crosses) | Glancing/blocked shots add 0 Pips. |

2) Referee Doctor Call Thresholds

Evaluated at every punch landed on the damaged side, plus once during round transitions.

| Current Bleed | Doctor Inspection Trigger Check |
| :---: | :--- |
| 0 – 2 Pips | 0% (Referee ignores / warns corner verbally) |
| 3 Pips | 15% check on next clean shot to that eye, or if active bleed duration $>45\text{ s}$ |
| 4 Pips | 50% check on any clean shot to head; mandatory inspection at next break |
| 5 Pips | 100% instant stoppage: Referee steps in immediately and escorts fighter to ringside doctor |

3) Doctor Stoppage Verdict & Cutman Mitigation
Calculation: Effective Stoppage Chance (%) = Base Doctor Stoppage Chance - Cutman Doctor Risk Reduction (Additive subtraction; floor = 0%)

| Bleed Level | Base Stoppage Chance | With Adrenaline Swab (-20%) | With Deep Coagulant (-45%) |
| :---: | :---: | :---: | :---: |
| 1 – 2 Pips | 0% | 0% | 0% |
| 3 Pips | 35% | 15% | 0% |
| 4 Pips | 70% | 50% | 25% |
| 5 Pips | 100% | 80% | 55% |

4) Post-Inspection Player Decision Matrix (If Doctor Permits Continuation)

| Dimension | Throw in the Towel (Surrender) | Wave Him On (Push Through) |
| :--- | :--- | :--- |
| Purse Payout | 100% loser share ($150) | 100% winner share ($350) if decision/KO held; $150 if stopped later |
| Official Record | Loss via TKO (Corner Retirement - RTD) | Bout continues to live finish (Decision or KO/TKO) |
| Eye Tissue | Heals clean: 0 permanent scar tissue accrued | Scar Tissue locks in: If Bleed $\ge 3$ at final bell, gain permanent Scar |
| Composure | Leo: -10 (Gym Trust: +15 for protecting health) | Leo: +15 (Iron Will trait triggers; Gym Trust: -10) |

5) The Cut-Prone Scar System (Permanent Trait)

| Scar Level | Requirement to Accrue | Cut Probability Multiplier | Starting Bleed in Future Bouts | Permanent Healing |
| :---: | :--- | :---: | :---: | :--- |
| Level 1 (Faint Scar) | Pushed through fight ending at 3 Pips | $\times 1.35$ to that eye | 0 Pips | Fades after 6 calendar months with zero head cuts |
| Level 2 (Dense Scar) | Pushed through fight ending at 4 Pips | $\times 1.75$ to that eye | 0 Pips | Permanent (Never fades; surgery costs $1,200 to demote to L1) |
| Level 3 (Torn Grasp) | Pushed through fight ending at 5 Pips | $\times 2.50$ to that eye | Starts at 1 Pip | Permanent (Irreversible; career-long liability) |

6) Headless Acceptance Test (CLI / Unit Test)
func test_doctor_stoppage_and_scar_headless() -> void:
    var fighter = Fighter.new("Leo Vance", {chin = 82, defense = 31})
    fighter.apply_cut(Side.RIGHT_EYE, 4) # Bleed = 4 Pips
    var ref_called_doc: bool = RefereeSystem.check_doctor_call(fighter.cuts[Side.RIGHT_EYE])
    assert(ref_called_doc == true, "Ref failed to call doc at 4 pips")

    # Cutman swab test (-20% additive)
    var stop_chance: float = DoctorSystem.get_stoppage_chance(fighter.cuts[Side.RIGHT_EYE], -20)
    assert(stop_chance == 50.0, "Expected 70 - 20 = 50% stoppage chance")

    # Player wave-on path at 4 pips finish
    FightManager.resolve_towel_decision(fighter, TowelDecision.WAVE_ON)
    assert(fighter.has_trait("Cut-Prone Scar (Level 2)"), "Failed to assign Level 2 Scar")
    assert(fighter.get_cut_multiplier(Side.RIGHT_EYE) == 1.75, "Multiplier != 1.75x")

## Claude's reading (for the verdict)
- Self-consistent with Ludo's own cutman table (Swab -20, Coagulant -45 additive) and the first-hour script (minute 56-58 doctor in
  round 3; towel $150 loser share vs wave on $350 - matches the first-hour purse).
- 5 = instant stoppage even after wave-on; wave-on is offered only when the doctor lets him continue (3-4 pips).
- "(Punch Power - Defense) * 0.40%" reads as percentage points per point of net power; with the 12-net-damage floor.
- "Torn Grasp" (L3) is Ludo's name, kept. Scar fade = 6 in-game calendar months with zero head cuts.
- Open point we resolve without Ludo: the live engine has no elbows/thumbs in boxing EA (REFEREE1: no dirty fighting) -> the 25% flat
  check is data only, never fired in the demo.
