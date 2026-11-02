# Corner shouts the fighter LEARNS - verdict S250 (your idea, Ludo r117)

**Your idea (S249, verbatim):** "during the corner at a fight you can shout a command every 25s (stay behind the jab e.g) these things you complete for your during the trainiing bars feeling in real time as the fighter learns them , also being able to see(hear) what the opponent does and prepare your next command(shout) options that are not fully learned by the fighter might be risky etc"

**Sources:**
- Ludo r117, verbatim: `research/ludo_rx/LUDO_R117_raw.txt` (25,919 chars) and `LUDO_R117_cont_raw.txt` (10,543 chars).
- It extends today's apron shouts (`rules/ApronShouts.gd`: 5 shouts, 22 s cooldown, 3 per round).
- It reuses the move-mastery bar that went live this session.

## What gets built
1. **12 shouts.** The 5 we have stay:
   - Off the Ropes
   - Go to the Body
   - Tie Him Up
   - Box and Move
   - Step on the Gas

   Seven are new:
   - "Stay behind the jab!"
   - "Make him miss! Make him pay!" (time the counter)
   - "Tuck your chin! Walk him down!"
   - "Double it up! Two jabs!"
   - "Left hook to the body! Dig it in!"
   - "Head-body-head! Mix it up!"
   - "Take a breather! Move and clinch!" (last 30 s)

   Each one lasts 10-20 s. It moves only levers the fight already has: head/body target, punch-family weights, guard, distance, pace, clinch, counter window, accuracy/evasion. Each also has a counter-risk. For example, "go to the body" lowers head defence and makes the opponent's uppercut more dangerous.
2. **Each shout is learned like a punch.** It gets a 0-100 bar with tiers Raw / Usable / Sharp / Drilled-in (30 / 60 / 85).
   - Each shout has its own primary station: pads with the coach, sparring, heavy bag or speed bag, at 1.8-2.5 points per hour. A secondary station gives about 1.0 per hour.
   - The coach standing at the station gives x1.35.
   - One hour of office film study gives +6 to up to 2 shouts, but film alone stops at 60.
   - Cap = 35 + 0.4 x fight IQ + 0.25 x technique. A smart fighter can drill more shouts in.
   - An undrilled shout loses 0.85 a week, never below 30 once it has passed 30.
3. **An unlearned call is risky.** Chance he does it = 0.55 x shout bar + 0.25 x trust + 0.20 x composure, held between 5% and 98%.
   - 70 or more: clean.
   - 40-69: late by 3.5-5 s. While he "thinks", evasion is -15% for 2.5 s.
   - Under 40: it fails. The failure is mostly "tunes it out" (nothing happens). Sometimes it is late. Rarely it is a **blunder**: guard down for 1.8 s, the opponent gets a clean counter chance at +30% accuracy.
   - A blunder never auto-knocks him out: the counter still rolls the normal chin/damage.
   - Blunders: 20% of failures at Raw, 5% at Usable, never at Sharp or Drilled-in.
   - A loyal fighter (trust > 75) never blunders; he just ignores the call.
4. **Rhythm: one shout every 25 s** (your number; today it is 22 s).
   - 3 per round.
   - +1 with a coach rated 70 or more, so 4 at most.
   - A broken fighter (composure < 20) takes only 1.
5. **What you see of the opponent: 4 live reads**, refreshed every 8 s. Each read names its two best shouts:
   - "Reading your lead" -> double the jab / mix the levels
   - "Shelling tight" -> body / liver hook
   - "Telegraphing power" -> time the counter / stay behind the jab
   - "Gasping" -> step on the gas / liver hook

   The opponent's corner shouts too, and its calls appear in the fight log.
6. **HUD at 1920x1080.**
   - A read ticker: 960 x 44 at the bottom centre.
   - A shout dock: 1400 x 146 with 6 loadout buttons. Each button shows its tier colour and %.
   - A cooldown tray showing "calls left 2/3".
   - A Raw shout carries a red (!) and a tooltip with its odds ("RISK: 20% BLUNDER / 50% IGNORE").
7. **In the gym, the bar fills while you watch.**
   - A 340 x 16 bar ticks up every drill cycle (about 1.8 s), with "+0.08 STAY BEHIND THE JAB" floating over the fighter.
   - Crossing 30, 60 or 85 flashes "TACTIC LEVEL UP ... SHARP" for 2.5 s.

## Balance target (tested before it ships)
- Two identical fighters: a corner that calls Sharp/Drilled shouts on the right reads wins about 62.5% against a silent corner (accepted 60-65%).
- A silent player is never broken: the fighter fights his own plan at full strength, and the stool between rounds stays the main lever.
- 30 Raw calls over 10 rounds: about 2 blunders (1.8-2.4) and 15-18 ignored.
- Drilled-in calls: 0 blunders.

## Left out of Ludo's answer
- "+40% critical power" and "+24% crit rate": we have no critical-hit lever. The counter uses the normal clean/chin maths instead.
- The 4-second counter-shout reaction to the opponent's corner: parked for after the demo.
- Shout and training audio cues: parked, not in the demo.
- "-8% trust per call with no matching read" (the anti-spam rule): kept but halved to -4%. A first-time player must not be punished hard for exploring.

## Order
1. Pure rules module and test (Arena): shout list, learning, execution roll, rhythm, reads.
2. Wire it into ApronShouts + the training day (Claude).
3. HUD dock and the training-bar UI (Cursor).
4. Balance batch (100 bouts).
