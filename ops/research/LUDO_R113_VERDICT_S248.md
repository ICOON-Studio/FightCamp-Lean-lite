# Ludo r113 verdict (S248) - floor HUD as a PC manager sim + coach walk timing

Raw answer (16,190 chars, verbatim): research/ludo_rx/LUDO_R113_raw.txt. Ask: research/LUDO_ASK_S248_HUD.md.
Why: operator on r112's mockup, "nope .ludo keeps considering that this is a mobile game .... thats not how sim/manager games look ,
its very simplestic no actual stats to make the player understand how good the fighter is , terrible design".

## Part 1 - the HUD (needs the operator's OK on the board before it is built)
- LEFT DOCK 380 x 976 px at (16, 52): header (name, age, record W-L-D (KOs), weight class, style, stance, reach); CURRENT ASSIGNMENT
  (station, coach chip "+25% GAINS" green / "UNCOACHED: BASE RATE" muted, time left + 4 px bar); CONDITION (stamina 82/100 with live
  -1.4/min, strain 24/100 +0.6/min, 6 px bars, TODAY: FRESH/WORKED/EXHAUSTED); CORE ATTRIBUTES table - 8 ratings in 3 groups
  (Physical: power, speed, conditioning; Technical: technique, defence, footwork; Mental & durability: chin, ring IQ) with columns
  CURRENT / TODAY (+0.4 green) / CEILING and a 2 px rule from current to ceiling; number colour by band (<50 grey, 50-69 white,
  70-84 gold, 85+ cyan); TRAITS chips.
- TOP BAR 1920 x 40 px: gym name, "WK 3, WED - 08:48", speed group (pause/1x/2x/5x), money "$14,250 +$420/wk", then right-aligned
  OFFICE PC (160 x 30, red count pill) - PLAN (P) - BUILD (B).
- GOAL CARDS 340 px wide at (740, 48): header with opponent + days left + ON TRACK / AT RISK pill; metric rows (name, value/target,
  4 px bar, velocity per day); TODAY'S FOCUS card.
- Type: Inter 12 px rows (22 px), mono tabular numbers, 10 px caps subheads; corners 0-2 px; 1 px LINE borders; row striping 2%.
- Attribute hover: 260 px breakdown - base + equipment + coach + trait = subtotal, - fatigue = in-ring value, ceiling.

## Part 2 - coach walk timing (inside the approved coach-walk feature: built, reported)
Ludo rejects all three of my options (keep 107 uncoached minutes / bonus on dispatch / full clock slow-down) and gives:
1. Long walks: the coach moves with urgency, 2.8 m/s (a jog, so the JOG clip at its own pace - never a sped-up walk, C105).
2. While he is in transit the clock runs at half speed (0.2 -> 0.4 s per game minute): a 32 m trip = 11.4 s = ~28 game minutes.
3. The fighter warms up alone at 90% of the standard gain until the coach arrives; the coach's bonus starts on arrival.

## Claude's verdict
- Part 2: BUILD 1 + 2 now (walk at 1.5 m/s under ~8 m, jog at 2.8 m/s beyond; half-speed clock during his transit). Rule 3 needs the
  current uncoached gain rate read first (TrainingMeters / DayLap) - checked before any number changes.
- Part 1: board question with this file attached; build after his OK.
