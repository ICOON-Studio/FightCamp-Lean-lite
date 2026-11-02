# ATTRIBUTES S259 - verdict for approval (Ludo S259, research/ludo_rx/LUDO_ATTRIBUTES_S259.txt, 19,907 chars)
Operator S259: "ask again what attributes we need and trained to make the fight as much human-like as possible".

## What we have today (code, read S259)
Stored 0-100: technique, power, speed (hands AND feet), defense, conditioning, fight_iq, chin, aggression, grapple (MMA).
Derived in FightLink.derive_stats: accuracy = technique; evasion = (speed + defense) / 2. Composure exists only as an in-fight state.
The watched fight: every boxer's punch plays at the same speed (no stat changes the animation).

## Ludo's answer -> Claude's verdict (approve to build)
11 canonical attributes, 0-100, each with its own gym training (stations, points/hour, cap, decay in Ludo section 2):
| attribute | type | from today's stats | shows in the 3D fight (Ludo section 3) |
|---|---|---|---|
| hand_speed | trained | SPLIT from speed | jab extension 0.28 s (20) -> 0.23 (50) -> 0.19-0.20 (80, never below our 0.20 floor) |
| footwork | trained | SPLIT from speed | step length / frequency, pivot snap, no flat-footed shuffle |
| guard | trained | SPLIT from defense | glove height, elbow tuck, how fast the guard returns after a punch |
| head_movement | trained | SPLIT from defense | slips, rolls, pull-counters |
| technique | trained | keep (offence only) | straight lines, fist turned over at impact |
| power | trained | keep | weight transfer, impact |
| conditioning | trained | keep | hands drop and stance narrows as the tank empties |
| fight_iq | trained | keep | range choice, adapting |
| composure | trained | NEW (was a state) | flinch size, posture when hurt, panic vs clinch |
| recovery | trained | NEW | between-round reset (heart rate, lactate, swelling) |
| chin | innate ceiling | keep | cannot be trained up; decays with career damage |
aggression stays as a mental trait; grapple parked (boxing demo). Derived on the fly: accuracy, evasion, KO leverage, damage
mitigation (formulas in Ludo section 1). Saved fighters migrate by Ludo's formula (section 5) so nobody changes identity.
Build order = Ludo's top 4 for a human-looking fight: 1 footwork, 2 guard, 3 composure, 4 hand_speed.
Fits the CLIPREVIEW1 verdict: spacing first (footwork + fight_iq choose range), feet, then hips.
