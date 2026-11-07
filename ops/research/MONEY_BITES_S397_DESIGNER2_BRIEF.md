You are a game designer for FightCamp, a boxing (+ no-gi BJJ) gym-management game for PC (Godot 4). One small club,
amateurs then pros, open-ended careers.

READ ONLY (do not edit, move or overwrite ANY file):
- ops/research/MONEY_BITES_S397_V22_BRIEF.md - the money design v2.2 as built.
- ops/research/MONEY_BITES_S397_R2_REVIEWS.md - two blind critics, both 6/10, with the faults.
- Code if you need it: scripts/state/GymSpend.gd, scripts/rules/GymUpgrades.gd, scripts/rules/StaffRoles.gd,
  scripts/rules/ClubShow.gd, scripts/rules/StarDeal.gd, scripts/rules/Membership.gd, scripts/rules/GymBills.gd,
  scripts/rules/Matchmaking.gd (pro purses: pay_of).

WRITE your answer to exactly one NEW file: ops/research/MONEY_BITES_S397_V23_QWEN.md (create it; touch nothing else).

Task: the version of v2.2 that would score 8/10 against shipped Steam management games on: "does money keep mattering for
a sensible player in year 1, year 2 and year 5, with real choices, without punishing success, and does it feel like a
real boxing club?" Fix the critics' faults with the SMALLEST changes; keep what they praised.

Hard limits: plain lists (no gym floor, no 3D); the fight itself cannot change (no fight-night rating edges); one gym, at
most 8 on the roster; no rival gym (a later system); at most 3 new mechanics, prefer number and rule changes; every number
has a real-world anchor or is marked GAME; game dollars = GBP x 1.25; no he/she/his/her for fighters in player text.

Output, plain text under 1400 words, no code: 1) the changes, each "from -> to, why, which fault, the number it moves";
2) the new mechanics (at most 3) with every number; 3) a year-1 / year-2 / year-5 money sketch for a sensible gym
(weekly in, weekly out, what it is saving for); 4) the bounds a 260-week simulation must meet.
