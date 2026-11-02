# D48 DIGEST - post-match screens that prove the plan mattered

**Owner:** Dola (Cici chat "Post-Match Feedback Design") | collected by Claude S102, 2026-09-27.
**Caution:** the per-game "exact element" copy below (FM, Motorsport Manager, F1 Manager, Punch Club 2, UFC 5) reads as
PARAPHRASED/ILLUSTRATIVE, not screenshots - treat those example strings as design patterns, not verified quotes.
Motorsport Manager's setup/strategy review is the one we have checked ourselves (S96/S97).

## What S102 takes from it (Claude)
- Every line = "I set this -> this is what it changed", with a DENOMINATOR and a comparison (vs opponent / vs the other zone).
- Show benefit AND cost on the same line (pace: more output, faster fade).
- Corner reads are judged in THEIR round only ("Round 2 read: TELL -> counters landed that round").
- Never: decimals on subjective scores, hidden numbers (edges, thresholds), "luck", "you should have...", blame for a valid choice.
- A loss still says where the plan worked and where it did not.

## Raw capture (visible text of Dola's reply, verbatim)

Would you like me to turn this into a mockup layout spec with exact label sizing, colour coding, and Godot‑ready scene structure for the screen?
Here’s the full design reference & analysis, structured exactly as requested.
1. Leader Game Post‑Match Decision→Result Elements
Table
Game	Pre‑match Decision	Exact Screen Element Tying Decision → Outcome
Football Manager	Tactical setup (formation, pressing line, passing style, focus down flanks/centre)	Tactical Analysis panel: "You chose Wide + High Press → 62% attacks down left wing; opposition fullback fatigued → 3 assists from that channel"; Match Stats side‑by‑side with your vs expected style; Manager Rating explicitly linked to tactical choices not just result
Motorsport Manager	Quali setup, tyre compound choice, pit stop timing plan	Strategy Review: "You chose Soft→Medium → gained 4s on opening stint but lost 7s on degradation"; Setup Impact bars: "More rear downforce = +0.3s/lap, less top speed = –0.2s/lap"; direct "Your call vs Recommended" comparison line
F1 Manager	Start strategy, fuel load, driver mode (defend/attack), pit windows	Strategy Summary timeline overlay: "Called lap 12 stop → gained 2 positions under VSC"; Key Decisions list with outcome delta: "Aggressive mode lap 8–18: +0.4s/lap average, tyre wear +12%"
Punch Club 2	Pre‑fight style allocation (aggressive/balanced/defensive), stat focus, ability loadout	Fight Breakdown: "You set Defensive → Counter stance → 4 successful counters vs opponent 2 misses"; Ability Usage: "Equipped Body Block → absorbed 3 heavy body shots"; Style Matchup: "Balanced vs Enemy Aggressive = damage taken –18%"
EA UFC / UFC 5	Camp focus (striking/wrestling/cardio), pre‑fight gameplan (head/body/leg focus, clinch preference)	Fight Stats → Gameplan tab: "Targeted Head → landed 18 of 42 significant head strikes (43%) vs body 9/31 (29%)"; "Focus Takedown Defence → opponent 2/10 success rate"; Corner Advice recap: "Round 2: 'Use Jab' → landed 12 jabs that round"
2. Patterns That Prove "My Choice Caused It" vs Decoration
✅ Builds belief — keep these
Direct named match: "You chose X → Y happened" — names the exact slider/option the player touched
Baseline comparison: "vs average / vs recommended / vs your opponent" — shows result is not just luck
Temporal alignment: decision made before event → measured during event; no retroactive re‑framing
Quantified delta: "+X% / –Y attempts / Z positions gained" — magnitude matches effort
Round‑by‑round continuity: corner tip given → stat changes that specific round; proves mid‑fight reads work
Consistency check: "You committed to outside range → 71% of time spent there; scored 65% of points from there" — shows execution and payoff
❌ Feels like decoration — cut these
Generic "You dominated" with no link to chosen settings
Percentages with no denominator (e.g. "80% effectiveness" — 80% of what?)
Only overall result (Win/Loss) without intermediate steps
Post‑hoc rationalisation: "You should have done X" when X wasn’t offered as a choice
Precision overload: 3 decimal places on subjective ratings
"Luck" or "momentum" as a stat — it hides cause behind noise
3. Our Five Core Elements (Matches Your Five Sliders + Corner Reads)
Each line answers: I set this → this is what it delivered
Table
#	Element	Example Copy	Why It Works
1	Range Choice	Outside range was your plan → spent 68% of fight there, scored 8/12 significant strikes from distance; inside range: opponent scored 7/9	Shows where you lived, where it paid, where it cost — clear tradeoff visible
2	Pace	You set High Pace → threw 112 strikes (+24 vs opponent); stamina dropped 18% faster → Round 4 output fell 30%	Benefit + penalty together; no one‑sided praise
3	Target Focus	Head priority → landed 19 head strikes (41% accuracy) vs Body 7 (22%) vs Leg 5 (20%)	Direct accuracy comparison; shows focus landed where aimed
4	Grappling	Grappling = Control → 11 takedown attempts (6 success); defended 7/9 opponent attempts; 4:12 total control time	Offence + defence + time controlled — full picture
5	Risk Level + Corner Reads	Risk: Aggressive → 3 knockdowns landed, but ate 1 counter that staggered you. Round 2 read: "Force clinch" → scored 2 takedowns that round	Reward + cost; ties between‑round advice to that round’s result
4. What Should Never Appear
❌ "You should have…" — options the player was never given are not feedback, it’s rewriting the fight
❌ Fake precision: "Your tactical score was 87.3%" — no player trusts decimals on subjective feeling
❌ Hidden mechanic reveals: never explain "opponent fatigue was at 0.42" or "AI difficulty was increased" — keep the system behind the curtain, show only player‑readable effects
❌ Disconnected praise: "Great fight!" with no link to their choices — feels hollow
❌ Only Win/Loss: the result is the end, not the learning — a loss should still show "Your plan worked here, didn’t work there"
❌ Retroactive blame: "You ignored advice" if they made a different valid choice — they chose, they didn’t ignore
❌ Luck as a stat: "Luck: 62%" — erases agency; bad execution should look different from bad luck
Summary principle: Every line must answer "I decided this → this is what it changed". If you can’t point to a slider or button the player touched to cause it, it doesn’t go on the screen.
Would you like me to turn this into a mockup layout spec with exact label sizing, colour coding, and Godot‑ready scene structure for the screen?
