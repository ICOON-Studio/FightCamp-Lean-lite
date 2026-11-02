# Ludo round 38 (animation) - Claude's verdict, S204 (for the operator's OK on the board)

Sources (Ludo verbatim): LUDO_ROUND38_S204_reply1.txt (24.2k chars: s1 intent bus, s2 punch S-curve, s3 balance, s4 start),
LUDO_ROUND38_S204_reply2.txt (24.6k: s4 fatigue posture, s5 glove springs, s6 inside uppercut + gate, s7 build order, s8 cut mid scene
tree). Section 8 (scene tree / gym plan follow-ups) is NOT animation - continued next session.

## TAKE - built in Ludo's order, each behind its own switch (default OFF), each closes on a game-camera still + your OK
1. INTENT BUS (s1) first: one data record per exchange from the fight sim to the animation (strike phases, miss offset, damage band,
   clinch times, slip/pivot sizes, composure). Missing field = today's animation exactly. Unlocks benchmark step 6 and the 5 "intents
   the sim cannot express yet". Pure data + test -> Arena/Qwen.
2. Then three in parallel: PUNCH S-CURVE (s2, step 6: snap into the punch, the contact frame never moves), BALANCE (s3, step 7: centre
   of mass kept 3+ cm inside the feet during slips, by the hips only), FATIGUE + GLOVE SPRINGS (s4+s5, steps 8-9: hands drop 8-14 cm
   when tired, gloves bounce 1-1.8 cm after a stop).
3. Last: the INSIDE UPPERCUT fixed by IK (s6) with Ludo's new gate "C224" that fails an arm going over the opponent's head - the move
   comes back into the demo only after your OK on video.

## CORRECTIONS (Claude) - why
- Our rules stay above Ludo's code: nothing moves the root or feet inside a certified contact window; OFF = byte-identical pose;
  every test uses two different fighters. Ludo's code is a starting spec, not merged as-is - each agent proves it on our C223 gate.
- Constants Ludo cites (Dempster/de Leva segment masses, punch speeds) are kept only with the source named in the code.
- The inside-uppercut fix also adds C224 to the certified-move gate, so a "numbers green, looks wrong" move cannot pass again.

## Build order after your OK
ANIMBUS1 (intent bus, pure) -> ANIMSCURVE1 + ANIMBALANCE1 + ANIMFATIGUE1 (parallel) -> ANIMUPPERCUT1 (+ C224 gate). Benchmark steps
6-9 must go green one by one; nothing else in the benchmark may get worse.
