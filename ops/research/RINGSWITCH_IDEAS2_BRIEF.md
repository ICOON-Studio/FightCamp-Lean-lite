# Ideas wanted: Ring Switches as it plays today - what would you change first?

You are a game designer who knows boxing. We want your own ideas, ranked. This is not a review of a proposal: below is
the game exactly as built, what we measured, and three problems. Plain words, no jargon, no reflex or timing mechanics
(the owner rejected those).

## The game (a small boxing prototype the owner loves: "this can become a beautiful game")
- One man against one man. Three rounds of six beats. BOTH MEN ACT AT ONCE each beat; then the beat is shown, punch by
  punch, with pictures.
- Each beat you set switches:
  - LEAD HAND: one of Jab, Lead hook, Lead uppercut, Body hook, Feint, Push off - or hold it HIGH or LOW.
  - REAR HAND: one of Cross, Overhand, Rear uppercut, Body cross - or hold it HIGH or LOW.
  - FEET: step in, hold your ground, back off. Or CLINCH (no punch lands, you get stamina back, not twice running).
- "A hand left off defends": lead hand high blocks straight head punches (jab, cross); lead hand low blocks body punches;
  rear hand high blocks hooks and the overhand; rear hand low blocks uppercuts. A hand that punches blocks nothing.
- Three ranges: Long, Mid, Inside. Jab reaches Long and Mid; cross and body cross reach Mid only; hooks, overhand and the
  body hook reach Mid and Inside; uppercuts Inside only. At Long ONLY THE JAB REACHES.
- The fast punch lands first (jab, then cross / hooks / body punches, then overhand / uppercuts). A big punch that lands
  stops his slower punch of that beat. A punch of his that is blocked or misses makes your later punch that beat a
  counter (+1 damage).
- Stamina 8: punches cost 1 to 3, a step costs 1; 1 comes back a beat, +1 for each hand held. Body punches shorten his
  stamina bar. Health 22; at 0 he is down (three knockdowns stop it); otherwise the round goes to points (a big punch
  landed 2 points, a small one 1).
- Backing off at Long gives up ground (two squares behind each man, then he is on the ropes and cannot back off).
- The machine reads a habit: the same plan in two of your last three punching beats and it picks the best answer.
- Three opponents: the Jabber (stays at Long, backs off, crosses at Mid), the Slugger (walks in, overhands, hooks,
  uppercuts), the Body Snatcher (walks in and digs to the body).
- NEW this week: a jab that LANDS keeps him out - he cannot step in on the next beat.

## What we measured (bots, 400 bouts each)
- A sensible player (he answers what the man did last beat) beats the Jabber 96%, the Slugger 78%, the Body Snatcher 82%.
  Almost every bout goes the distance; stoppages are rare.
- That player throws his own JAB in 5% of beats. He steps in on half of them.
- At Long there is one question only: he jabs, you hold the lead hand high and walk in. The Jabber cannot stop a man who
  walks in behind a high lead hand.
- A fixed "jab and move" player wins 57% against the Jabber, 42% against the Slugger, 5% against the Body Snatcher.
- The guard bar (a block wears it) never breaks in 1,800 bouts.

## The three problems
1. LONG RANGE HAS NO GUESS. One punch reaches, one hold stops it.
2. THE JABBER IS TOO EASY and out-boxing is not a winning way to play.
3. BOUTS RARELY END EARLY and the three opponents do not ask clearly different questions.

## What we ask you for
FIVE changes, most important first. Each must be small enough to build in a day on this prototype (a new switch, a
changed number, a new rule for an existing switch, a change to an opponent). For each:
1. THE RULE in at most four plain sentences.
2. ONE BEAT walked through: what both men set, what happens.
3. WHAT IT ADDS: the decision the player now has, and when each choice is right.
4. HOW IT CAN BREAK: the lazy plan that would win too often, and the cap you would put on it.
5. THE REAL BOXING it stands for (one line; name a fighter or a fight if one fits).
At least one of the five must fix problem 1 without adding a timing or reflex element, and at least one must be about
the three opponents. Then say which ONE you would build first and why, and which of our existing switches or rules you
would CUT.
