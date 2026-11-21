# TASK CARDPROTO2 - card-game prototype, round 2 (Arena, repo FightCamp-Lean-lite, branch main)

Round 1 is merged: `proto/cardgame/` (rules.js, ui.js, index.html, rules.test.mjs, balance.mjs, README.md). Read `ops/research/TASK_CARDPROTO1.md` for the frame, then `ops/research/CARDPROTO1_CRITIC_ARENA.md` (a code-checked critic: DEPTH 5, PLAY 6; bar is 8 and 8). Read `ops/research/REF_MMC_DEMO_S536.md` (ideas from a reference game, our own words). Boxing only. You own only `proto/cardgame/`. Never delete or weaken a test; add tests for every fix. Keep each file under 500 lines (split rules.js into modules if needed; keep `node proto/cardgame/rules.test.mjs` and `node proto/cardgame/balance.mjs` working). Update README (rules in plain words, no numbers the code does not produce).

## Part A - make the existing promises true (small, do first, each with a test)
1. `contextOf.selfAhead` compares damage TAKEN backwards: fix it (ahead = he has dealt more).
2. Corner "Gloves high" stores `mods.punch = -0.15` that nothing reads: apply x0.85 to his punch damage next round.
3. Corner "Change the plan": opponent corner must get the same extra draw (the `key === 'player'` skip is a bug) - or drop the card.
4. "Study his corner" must not be offered when both habits are already known (offer a free alternative).
5. README says each habit is drilled twice into the deck; `makeSide` does not do it. Make the code do it (a habit's signature card is always in the deck) and the test prove it.
6. The fight AI (`chooseAiCard`) must use scouting/habit knowledge like a player would (public info only, never the hidden hand); then re-measure scouting's value honestly and put the real number in the README.

## Part B - depth (the critic's ordered list, most important first)
1. SCOUTING MUST BE A PREDICTION DECISION. Show, per exchange, what the film says he does in this situation and how sure it is (the habit's condition + the chance the card is in his hand). The opponent AI adapts to the player's last 3 cards, so repeating a card has a price. Target: a reading player beats a random player by 15+ points over 10,000 bouts (balance.mjs prints it).
2. PREDICT / REACT every exchange (from the reference): predicting your read wins cleanly but costs wind or exposes you if wrong; reacting is safe but needs Speed. This is the core new decision; keep it to one extra tap, not a menu.
3. PUNCH SHAPES as the resolution key: each punch is straight / looping / uppercut; each defence answers some shapes and is weak to others (slip beats straight, roll beats looping/hook, block beats everything for less, clinch beats uppercut inside). Habits name a shape ("when hurt he throws the looping body shot"). The README card table shows who beats whom.
4. HEAD and BODY kept apart: body damage drains wind for later rounds, head damage drives knockdowns; show both on the HUD. A body-hunter plan vs a head-hunter plan should differ.
5. Movement rules: only a won exchange moves range (Cut off beats Step back; Pivot beats Cut off). Losing chip damage stays at 30% and the UI says so. A lost Jab does not grant the setup.
6. Resource choices: a few COMMITTED cards (a feint costs 2, no damage, next punch +accuracy, cancelled by a clean hit; catch-breath restores 6 wind once a round, vulnerable to body shots) and ONE instant per round as the corner's shout.
7. CAMP as construction: drills may REPLACE up to 2 cards, plus one removal per menu, deck cap 16; show what each drill does to the deck. Balance so an informed camp beats a random one.
8. Corner cards with honest costs and at least two competitive picks in most offers.
9. Referee: warning after 2 consecutive clinches, point deduction on the 3rd.
10. Separate RNG streams (hit, knockdown, shuffle, judging) so tests can be paired.

## Acceptance (print every number in balance.mjs)
- All old tests still pass (no fewer checks) plus new ones for every item above.
- 2,000-bout table: no card over 65% win-when-played, none under 1% of plays, no one-card strategy over 45%, reading beats random by 15+ pp, bouts end by stoppage 10-20%.
- index.html plays a full bout with the new decisions, readable on a phone width.
- RESULT lines in the PR body: the exact pass line of each command. Note in the PR body which Part B items you did and which you did not.

## Part C - variant to test AFTER Part A and the Part B items you manage (do not replace v1)
Read the sections "Played on the hidden desktop" and "What this changes" in `ops/research/REF_MMC_DEMO_S536.md`. Build a switchable variant `rules.variant = 'shown'` (default stays the blind reveal): the attacker's card is SHOWN and only its MODE (normal / full power / feint) is hidden; the defender answers; a good defence passes the INITIATIVE to the defender. Add free basic block cards that return every turn, and a full-power trade (countered = double damage + dazed). Run balance.mjs for both variants side by side and put the two tables in the README; say which one reads better and why. If Part A/B leave no room, say so in the PR body and skip.

## Part D - second critic (Kalli: DEPTH 4, PLAY 4, GENERAL 5; `ops/research/CARDPROTO1_CRITIC_KALLI_KALLI.md`, read it). It agrees with Part B and adds, most important first:
1. DEFENCE PAYS IN ITS OWN CURRENCY, defence cards deal NO damage (also fixes lines like "his block lands" - words become "slips it", "blocks it", "takes you out of range"). A winning Slip/Roll = an opening (next punch this round +30% damage, +15 accuracy); winning Block refunds 1 wind; winning Step back moves range out and costs him 1 wind; winning Pivot out resets range to mid and you see his card first next exchange. Bar: every defence card wins 45-55% when played, Block played in 8%+ of exchanges. (This replaces the critic-1 note that defensive damage is "intended".)
2. TELLS: before each reveal the opponent shows one tell chip ("loading the right", "head low, walking in"), true 55% blind / 70% with one habit known / 85% with both; he tracks your last 3 cards and a card you repeat twice is twice as likely to draw its counter. Bar: perfect reading beats blind play by 15+ points (today 3.4).
3. TABLE HOLES: Uppercut is overloaded (beats jab, cross, lead hook, block, roll) - give it 50% accuracy at out range, make Slip vs Uppercut an X (slipping into it), Jab vs Uppercut a w at out/mid; Pivot out never loses (add a card that beats it: Lead hook vs Pivot = w); Cross should beat Jab at mid. Keep the table anti-symmetric. Bar: every card beats 2+ cards and loses to 2+, none over 55% when played.
4. COMBINATIONS: up to 3 cards in one exchange, cost = sum + 1 wind per extra card, resolved one by one against his card (jab-cross, jab-cross-hook, slip-cross counter). Biggest single gain for PLAY - do it if you do only one big thing.
5. NEW CARDS: Feint, Cross counter, Check hook (beats Cut off / Clinch / pressure), Pull counter (beats jab and cross at range, loses to body hook), Breathe. Write each one's counter first in the table.
6. RANGE costs: each exchange spent inside costs the boxer who does not want it 1 wind (by style); a "ropes" state after two Cut-off wins in a row (Step back off the table, Pivot out the only exit). Bar: no range holds more than 60% of exchanges in out-boxer v pressure.
7. HABITS: the habit's card is in the deck 3 times and fires 70% when its situation is true; the player can create the situation (hurt him and he clinches, the Lead hook that beats a clinch is the payoff). Each known habit worth 5+ points.
8. KNOCKDOWNS ~0.6 a bout (now 1.68), stoppages 8-10%; no knockdown on a fresh boxer in R1.1.
9. AMATEUR BOUT: no draws (a split decision decides), five judges, round scores shown after each round with a one-line why per judge.
10. CAMP costs fatigue; one of four weeks may be rest/taper.
11. HOUSE RULES, tests for each: same-sex bouts only (women never fight men); opponents come from OTHER clubs, never your own boxers; never the same pairing twice in a row; no fixed "he" - say "your boxer", "the opponent", her/him by the boxer's data; names only in headers/titles, never in body text.
