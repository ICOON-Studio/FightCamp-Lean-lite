# TASK K_COMBOPLAN1 - Kalli (design review) - what a signature combination should be worth (S375)
Kind: research

New, built and waiting on your numbers (operator S375: "the longer the combination the better to become a signature
move (good success rate), but long combos cost energy (can be thrown limited times)"). A boxer writes his own
combinations on his Training tab (jab, jab, step in, lead hook ...), drills one a week on the pads, and at 85 pad
mastery it becomes his SIGNATURE. Drilling, not length, makes the signature; longer chains take longer to own (pad
minutes split over every move) and cost more gas a throw (1-2 = 0.55, 3 punches 0.9, 4 punches 1.2 of a 100 tank).

The ring: his hand speed caps a run at 1-3 punches (speed 58 / 66 thresholds) and tiredness shortens it (-30 % by
energy 30). A signature may run ONE punch past the speed cap - the only way a 4-punch run is thrown whole.
The numbers (Claude's ESTIMATES): a drilled combination is worth 3 power points in the exchange it is thrown
(PlanFight "works"); +2 if it flows (ComboFlow 70+); +5 more as a signature. It decides ~1 exchange in 3
(USE_SHARE 0.33), so the bout adds (flow + signature) x 0.33 = 2.3 a round fresh. In an even exchange a usable flowing
combination lands whole 57 %, a signature 64 %. For scale: a corner's best shout is 15, a plan line that beats the
opponent's game 9, a round on Push 6.

Q1. Is +5 for a signature (64 % whole) right for "a good success rate" without making one signature win fights alone?
Q2. Is "one punch past the hand-speed cap" the right reward for length, or should a long signature also hit harder?
Q3. USE_SHARE 0.33 - how many exchanges of 6 does a boxer's favourite combination really decide?
Short verdict per question; the exact numbers you would use.
