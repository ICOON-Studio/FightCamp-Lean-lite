# FightCamp - the game on paper (S159, 2026-10-04)

Written as the lead designer, from a blank page, at the operator's request: "think how the game should be in paper
first ignoring what we have done so far". Only the agreed product frame is kept: a boxing gym management game, boxing
first, Steam Early Access, MMA later. Everything else here is designed fresh. Comparing it with what we have built
comes AFTER you have read this and changed what you disagree with.

---

## 1. The game in one sentence

**You run a small boxing gym, you turn ordinary kids into fighters, and on fight night you stand in their corner -
every win on their record is a decision you made.**

The player is the **head coach who owns the gym**: not a promoter, not a god. You cannot throw the punches. You can
choose who fights, how they train, what the plan is, and what you say in the 60 seconds between rounds.

## 2. Who it is for

- People who play Football Manager, Motorsport Manager, Out of the Park Baseball: they want a deep sim, but they want
  to SEE the result of their work.
- Boxing fans who know what a jab-and-move plan is and why a southpaw is awkward.
- Players of Punch Club and Boxing Club Manager who wanted those games to be deeper and the fight to look like a fight.

What they all share: **they will forgive simple menus, they will not forgive a result they cannot explain.**

## 3. The four pillars

Every feature must serve at least one. If it serves none, it is cut, however nice it is.

| Pillar | What it means | The test a feature must pass |
|---|---|---|
| **1. The corner is where you play** | Fight night is the payoff of everything. Your decisions between rounds visibly change the next round. | Does the player see the effect of this decision inside the next 3 minutes of fight? |
| **2. The week prepares the fight** | Training is not "+1 strength". It is a camp built against ONE opponent: you scout him, pick a plan, drill it. | Does this choice change how a SPECIFIC upcoming fight goes? |
| **3. Every fighter is a person** | Fighters have a style, a temper, ambitions, a rival, a body that wears out. You get attached and you lose some. | Would the player tell a friend a story about this fighter? |
| **4. Honest, readable outcomes** | After every fight the game tells you WHY: the three moments that decided it, the scorecards, the stats. No dice you cannot see. | Can the player name the reason they won or lost? |

## 4. The three loops

### The moment (one round, ~3 minutes watching + 60 seconds deciding)
1. Watch the round in the 3D ring (1x / 2x / 4x speed, or skip to the bell).
2. While watching, the broadcast shows what matters: punches landed, stamina bars, a cut opening, who is winning the round.
3. The bell rings. **The corner screen** (the heart of the game, see section 5).
4. Next round starts. The effect of your call is visible: he steps in behind the jab, he goes to the body, he stops
   trading.

### The week (5-8 minutes of play)
A week is **three to five real decisions**, never twenty small ones:
1. **The fight card**: who has a fight coming, who needs one, offers on the table (accept / decline / counter).
2. **The camp**: for a fighter with a booked fight, set the camp focus against that opponent (section 6).
3. **The gym**: one money or people decision (hire a coach, fix the ring, take a sponsor, sign a kid who walked in).
4. **Press Continue**: the week plays out; a short report says what changed and why.

### The career (hours)
- Your gym rises from a garage gym with two amateurs to a known gym with a champion.
- Your fighters rise: amateur bouts -> pro debut -> local title -> regional title -> a world title shot.
- Your reputation grows: better kids walk in, better fights are offered, sponsors call.
- **The long goal**: a world champion who came through your door as a beginner.

## 5. Fight night - the heart

The fight is a **broadcast you are part of**, not a debug view and not an arcade game.

### What you see while the round runs
- The 3D ring with TV camera angles; the camera finds the action (close on exchanges, wide on movement).
- A slim broadcast bar: round, clock, punches landed this round, a stamina bar for each fighter, a damage marker on
  the face (cut, swelling).
- A one-line commentary ticker: "Big right hand! Jones is hurt!" - short, factual, never more than one line.
- Big moments get a beat: a knockdown slows to a replay, the referee counts, the crowd rises.

### The corner screen (60 seconds, the main decision of the game)
You see your fighter on the stool. Three things to read, three things to choose.

**Read:**
- **How he is**: stamina, damage (eye closing, cut), confidence (is he rattled?).
- **How the round went**: who won it, what landed, what the opponent is doing (e.g. "he drops his right after the jab").
- **The scorecards** (your coach's guess, not the judges' secret cards).

**Choose (pick one of each):**
1. **The plan for next round**: stick to the plan / box and move / pressure / go to the body / take a breather round /
   go for the finish. Each is one button with a one-line consequence ("Pressure: wins rounds, burns stamina fast").
2. **The cut man**: work the cut / ice the swelling / nothing (a bad cut can end the fight).
3. **What you say**: calm him / fire him up / tell him the truth ("you are losing, you need a knockdown"). His
   temper decides if it works.

**And the hard one:** **Stop the fight.** Throw the towel. Saving a fighter costs the loss; not saving him can cost
his career. This is the most important decision in the game and it must feel heavy.

### After the fight - the honest result
- The verdict and how: KO round 7, split decision, cut stoppage.
- **Three moments that decided it**: "Round 4 - you switched to body work; his output dropped 30% after it."
- Scorecards of all three judges, round by round.
- A punch stats table (thrown, landed, power, jab).
- What happens next: injury weeks, ranking movement, purse, fans, his mood.

## 6. The week - the camp is the link

The single design idea that ties the game together: **scout -> plan -> camp -> fight -> corner.**

1. **Scout the opponent**: a report with his style, his best weapon, his weakness ("slow to come back after the jab",
   "fades after round 6", "cuts easily"). Better scouts (staff, money) reveal more.
2. **Pick the game plan** for that fight: e.g. "outbox him behind the jab", "take him late", "body work early".
3. **Set the camp** (4-8 weeks): split the weeks between the plan's drills, fitness and sparring. Too hard = injury
   risk and a fighter who peaks too early. Too soft = he fades.
4. **On fight night**, the plan is his default. If the camp drilled it, he executes it well. Your corner calls can
   change it, but a plan he did not drill is executed worse.

That makes a week of training a bet on a specific fight, and the fight the payoff of that bet. No abstract grinding.

## 7. Fighters

Few numbers, all visible, all mattering. A player should hold a fighter in their head.

- **Six attributes**: Power, Speed, Defence, Stamina, Chin, Ring IQ.
- **One style**: out-boxer, swarmer, slugger, counter-puncher, boxer-puncher. Style decides how attributes become
  behaviour in the ring.
- **Two traits** from a short list: "slow starter", "cuts easily", "big-fight nerves", "iron will", "lazy in camp".
- **Body**: height, reach, stance, weight class - visible in the 3D model, they matter (reach wins the jab battle).
- **Condition and mood**: fitness, damage carried over, motivation, his opinion of you.
- **Potential is hidden**, revealed slowly by fights and good coaches. Finding a gem is the dream.
- **Wear**: every war leaves damage. A fighter who has been in too many hard fights fades. Careers end.

## 8. The gym (the management layer, kept small)

- **Money in**: member dues (the gym is also a business), your share of purses, sponsors.
- **Money out**: rent, staff wages, equipment, travel, camp costs.
- **Staff**: assistant coach (more fighters in camp at once), cut man (better corner), scout (better reports),
  conditioning coach (fewer injuries). Four roles, no more.
- **Facility**: ring, bags, sparring partners, recovery room. Each upgrade does ONE clear thing.
- **The gym is a place you can see**: a bright, lived-in 3D gym that fills with people as you grow. It is the home
  screen, not a menu.

## 9. The first hour (this IS the demo)

A AAA team designs the first hour minute by minute, because that hour decides reviews and refunds.

| Minute | What happens | What the player feels |
|---|---|---|
| 0-3 | Pick your city and name the gym. One screen. | "This is mine." |
| 3-8 | Meet your first fighter, a raw amateur with one clear strength and one flaw. | "I know this kid." |
| 8-15 | First fight is offered: an easy amateur bout. Scout, pick a plan, a short camp (the tutorial lives here). | "I am preparing him." |
| 15-25 | **First fight night**, 3 short amateur rounds. First corner call. He wins - and the result says why. | "My call worked." |
| 25-40 | A harder fight: an opponent with a dangerous weapon. Real scouting matters. Second fighter walks in. | "Now it is a puzzle." |
| 40-55 | The hard fight. He gets cut. First towel decision is possible. Win or lose, the story is told. | "That was tense." |
| 55-70 | Pro debut offered. Money gets real: a staff hire or an upgrade, not both. | "I want one more week." |

**Demo ends** after the pro debut, with a teaser of the next rung (the local title). Everything outside this hour is
not in the demo.

## 10. Feel targets (how it should look and sound)

- **Punches have weight**: a short impact pause on clean power shots, the head snaps, the crowd reacts.
- **The fighters look like boxers**: guard up, bouncing, breathing harder in later rounds, a hurt man stumbles.
- **The camera is TV**: no free camera by default, no camera through bodies, no long static shots.
- **Readability beats realism** where they fight: a stamina bar on screen is better than guessing from breathing.
- **Sound**: thuds, crowd swell, the bell, the corner voice. Silence is worse than simple sound.
- **UI**: icons with tooltips, one clear button per decision, broadcast style on fight night.

## 11. What is NOT in the game (for the demo and Early Access)

Saying no is the job. These are cut until the core is fun:
- Controlling the punches yourself (we are a management game).
- MMA, kickboxing, grappling, clinch depth (the MMA update, after Early Access launch).
- Promoting your own fight cards, TV deals, pay-per-view.
- Women's division and multiple weight-class ladders beyond what the first hour needs (Early Access, not demo).
- Real-world countries beyond a few, deep regional economies.
- Staff as walking 3D characters, press conferences, rivalries between gyms (Early Access content, not demo).

## 12. How a AAA studio would build this from here

1. **Paper prototype of the corner** (one day): play a fight with cards and dice - round summaries, a corner choice,
   the result. If deciding in the corner is not interesting on paper, no 3D will save it.
2. **Grey-box vertical slice**: the first hour above, end to end, ugly but complete. One fighter, one opponent, one
   ring, the corner screen, the result screen. Played every day.
3. **Fun check with players**: you play it cold, then two strangers. Measure: where they get confused, where they
   want "one more week", where they quit.
4. **Only then polish**: animation, gloves, rooms, venues, sound - in the order the first hour shows them.
5. **Then widen**: more fighters, more rungs, more gym. Early Access content comes last.

The rule through all of it: **a build anyone can play, every day, and every task judged by "does the first hour get
better?"**

## 13. Decisions - SETTLED by the operator 2026-10-04 ("go with your picks"), DECISION_LEDGER D35

1. **The player's role**: head coach who owns the gym (my pick) - or owner who hires a coach?
2. **The corner screen**: three choices per break (plan, cut man, words) plus the towel (my pick) - or simpler, one
   choice per break?
3. **The camp**: tied to one specific opponent (my pick) - or general training between fights?
4. **The demo**: ends after the pro debut, about one hour (my pick) - or longer, to the first title?
5. **Watching**: every round is watchable, with speed-up and skip (my pick) - or highlights only by default?

## Inputs used

Genre knowledge (Football Manager, Motorsport Manager, OOTP, Total Extreme Wrestling, Punch Club, Boxing Club Manager,
Fight Night, Undisputed) and our own research, used as evidence only: K70 (what makes a fight result feel honest),
K69 (unmet demand in fight-management games), G74 (the gym market), M34 (pitch presentation), S148 (schedule and
tutorial design).
