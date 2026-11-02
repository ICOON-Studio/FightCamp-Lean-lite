# Ludo (lead designer) - the stool and corner tables (S190, 2026-10-09) - APPROVED SET (D40)

Asked after the operator approved V1-V12 + Ludo's cast ("approve all, use ludo's cast"): TABLE 1 the stool state word + State x Tone
effects; TABLE 2 every corner action per lane at 2 AP (15 s per AP, careful 0% mistake; a 3rd rushed AP 15 s, 35% blunder). Verbatim
(browser-tool masks restored). These are the numbers for LUDO-CORNER1 (V1 + V2).

## TABLE 1: Stool State Diagnostic & Tone Matrix

### A. State Word Priority Evaluation
Evaluated top-to-bottom at the bell; first matching condition assigns the fighter's state.

| State | Evaluation Formula / Thresholds |
| :--- | :--- |
| GROGGY | Head Condition < 40 OR (Head Condition < 55 AND Composure < 30) |
| PANICKED | Heart Rate ≥ 175 BPM AND (Composure < 45 OR Current Round Score Deficit ≥ 2 pts) |
| COMPLACENT | Current Round Score Lead ≥ 2 pts AND Heart Rate < 145 BPM AND Head Condition ≥ 70 |
| STEADY | Default fallback (fails all above condition checks) |

### B. State × Tone Effect Matrix (Applied to Next Round)

| State | Tone Selected | Composure | BPM | Punch Vol | Plan Adherence | Power | Defence |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| GROGGY | Calm (Optimal) | +15 | -15 | -10% | +10% | 0% | +15% |
| GROGGY | Fire Him Up (Mismatch) | -15 | +20 | +15% | -30% | +5% | -25% |
| GROGGY | Tell Him the Truth | -5 | -5 | -5% | +5% | 0% | +5% |
| PANICKED | Calm (Optimal) | +20 | -25 | -5% | +20% | 0% | +10% |
| PANICKED | Fire Him Up (Backfire) | -25 | +30 | +25% | -40% | +10% | -30% |
| PANICKED | Tell Him the Truth | -10 | +10 | 0% | -10% | 0% | -5% |
| COMPLACENT | Calm | -5 | -10 | -15% | -10% | -5% | -5% |
| COMPLACENT | Fire Him Up | +10 | +15 | +15% | +5% | +5% | 0% |
| COMPLACENT | Tell Him Truth (Opt) | +15 | +10 | +10% | +25% | +5% | +10% |
| STEADY | Calm | +5 | -10 | -5% | +10% | 0% | +5% |
| STEADY | Fire Him Up | +5 | +15 | +15% | -5% | +10% | -5% |
| STEADY | Tell Him Truth | +10 | 0 | 0% | +15% | 0% | +5% |

## TABLE 2: Corner Action Matrix (3 Lanes × 2 AP Base)
Time Economy: Base budget = 45s. AP 1 = 15s (0% blunder), AP 2 = 15s (0% blunder).
Rushed 3rd AP: Consumes final 15s of the lane, triggers an immediate roll: 35% Blunder Risk.

| Lane | Action Name | Base Cost | Normal Resolution Effect | Blunder Effect (If 3rd Rushed AP Fails 35% Roll) |
| :--- | :--- | :---: | :--- | :--- |
| CUTMAN | Ice Enswell | 1 AP | Left/Right Eye Swelling -1 Pip (+15% visual tracking) | Slipped Iron: Eye Swelling +1 Pip, Composure -10 |
| CUTMAN | Adrenaline Swab | 1 AP | Active Bleed -1 Pip, Doctor Stoppage Risk -20% | Cotton Tear: Bleed +1 Pip, Doctor Risk +15% |
| CUTMAN | Grease Bridge/Cheek | 1 AP | Incoming Cut Probability -25% next round | Vaseline in Eye: Visual Tracking -20% for 60 seconds |
| CUTMAN | Deep Coagulant Pack | 2 AP | Bleed -2 Pips, Doctor Stoppage Risk -45% | Packed Wrong: Bleed unchanged, 1 AP forfeited next round |
| SECOND | Water Rinse & Spit | 1 AP | Stamina +6%, Heart Rate -8 BPM | Choke Reflex: Stamina 0%, Fighter coughs (-10 Composure) |
| SECOND | Neck Ice Collar | 1 AP | Heart Rate -15 BPM, Stamina +4% | Spilled Ice: Ring canvas slick warning, BPM unchanged |
| SECOND | Torso Aeration & Fan | 1 AP | Stamina +5%, Next Round Fatigue Burn Rate -10% | Dropped Towel: Zero stamina yield, wasted action |
| SECOND | Deep Body Rehydrate | 2 AP | Stamina +14%, Heart Rate -18 BPM | Water Bloat: Stamina +5%, Body Damage Taken +15% |
| CHIEF | Deliver Tone | 1 AP | Applies Table 1 Stool Tone matrix modifiers | Muddled Message: Composure -15, Plan Adherence -20% |
| CHIEF | Activate Sparring TELL | 1 AP | Perm read active: Opponent Counter Window +15% | Misread Tell: Opponent Counter Window -10% next round |
| CHIEF | Activate Film EXIT | 1 AP | Perm read active: Trap Defense +20%, Clinch Break +25% | Bad Exit: Fighter circles into opponent power side (+15% dmg) |
| CHIEF | Firm Tactical Shift | 2 AP | Overrides gameplan; Plan Adherence set to 95% | Tactical Confusion: Plan Adherence -35%, Hesitation +0.4s |

(Ludo's next suggestions: complete Table 1 / Table 2 further; a clean in-game stool UI mock-up with the four states, tones and AP.)

---

## COMPOSURE (Ludo, S190) - the live-engine state the stool table reads (V14, pending the operator's approval Q-S189-3), verbatim

Composure System Specification (Scale: 0 to 100)
[Start Value] = 30 + (Fight_IQ * 0.35) + (Chin * 0.20) + [Trait Modifier] (Hard Clamped: 20 to 90)

| Dimension | Mechanics & Trigger Conditions | Numeric Delta / Formula |
| :--- | :--- | :--- |
| Start Value | Base formula evaluation at first bell. Iron Will: +15; Gatekeeper Composure: +10; Fragile Confidence: -15 | Range: [20, 90]. Leo Vance: 30 + 15.75 + 16.4 + 15 = 77; Damian Cross: 30 + 13.65 + 7.0 = 51; Malik Adebayo: 30 + 21.35 + 8.8 - 15 = 45 |
| In-Round Drains | Negative ring events during live 3-min round. | Clean power head shot absorbed: -4; Rocked / Stagger state triggered: -12; Flash knockdown suffered: -25; Flesh cut / gash opened: -10; Trapped on ropes > 4 s: -1 / sec |
| In-Round Gains | Positive ring events during live 3-min round. | Drilled Pad-Chain successfully executed: +8; Clean knockdown scored on opponent: +15; Opponent whiff punished with counter: +3; 3 consecutive successful slips / guards: +4 |
| Round-End Audit | Evaluated at the final bell before corner actions. | Lost round on live judge cards: -6; Won round on live judge cards: +6; Hostile crowd boos (away bout): -3 |
| Corner Passive Recovery | Natural recovery on stool prior to Coach Tone. | Recovery = + (Conditioning * 0.15) (e.g., Leo Vance Cond 66 yields +10 Composure automatically before Tone input) |
| Bounds & Limits | Hard absolute bounds at all runtime ticks. | Floor: 0, Cap: 100 |

Low Composure Penalties (Live In-Round Tiers)

| Composure Band | State Level | Plan Adherence | Punch Selection Bias | Guard Integrity | Ring Behavior Penalty |
| :---: | :---: | :---: | :--- | :---: | :--- |
| 70 – 100 | Focused | 100% | Strict tactical adherence | 100% (Full) | None (optimal movement and rhythm) |
| 45 – 69 | Rattled | 75% | +15% single jab frequency | 85% | Hesitation: +0.15s counter reaction latency |
| 20 – 44 | Shaken | 40% | Abandons jabs; +30% wild hooks | 65% | Flinches on feints; backs up in straight lines |
| 0 – 19 | Broken | 10% | Panic swing or desperate clinch spam | 40% | Drops high guard; cannot trigger drilled Pad Chains |

(Claude note: Ludo's arithmetic for Leo uses chin 82 x 0.20 = 16.4 and fight_iq 45 x 0.35 = 15.75 - consistent with LUDO_CAST_S190.md.)
