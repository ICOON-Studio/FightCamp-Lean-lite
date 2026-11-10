# R37 - Asking for a fight: the design map (S428, Claude; sourced by John's J_MATCH1, ops/research/J_AMATEUR_ASK_S424_BRIEF_JOHN.md)

TODAY the game hands the player offers that arrive on their own (Bouts.offers: accept, decline, swap for a tougher one, a lead of 2 to 4 weeks from
AmateurBooking). The player never ASKS. In the real sport the coach does: England Boxing bouts are made coach to coach, the host club's matchmaker builds the
card by phone, WhatsApp and apps; the region only issues the permit; the Supervisor has the last word; the real blocker is scarcity at the boxer's weight, age
and experience, worst for women and the extreme weights (J_MATCH1 Q1, Q3). This map makes the ask a decision with a reply, a wait and a price.

## The idea in three lines
1. You ask a CHANNEL for a KIND of fight in a WINDOW; the reply comes days later and may be yes, a counter, or nobody.
2. Each channel is fast or wide or cheap, never all three; each kind of fight trades safety for growth and money.
3. Scarcity is real: the fewer fighters of her weight and experience in reach, the longer and worse the replies; a good name and favours widen the reach.

## The decisions, in order

### 1. When to ask (readiness)
A boxer may be put forward only when: her medical is current, 30 days of sparring done (England Boxing 2026 5.7.1(f), OFFICIAL), no suspension, 12 h rest
(6.6.8), season cap not reached (recommended 18 a senior season). The coach's READINESS READ is shown as a band (not ready / nearly / ready) from her sparring
rounds and stats. Asking early gets a worse match (the Supervisor refuses a mismatch); asking late wastes camp weeks. Trade: weeks of waiting against a risky
bout. Screen: Fighters > her page > "Ask for a fight" button, greyed with the reason when a rule blocks it.

### 2. Which channel (who you call)
| Channel | Reach | Speed | Cost | Catch |
|---|---|---|---|---|
| Your own network (coach to coach calls) | the clubs you know, 3 to 6 rivals | 1 to 3 days | free, uses a FAVOUR with that club | each club only has what it has; favours run out |
| The next show's matchmaker | one card of about 15 bouts, 8 to 12 weeks of lead | 1 week; slot not guaranteed | free, you must be on the show's date | a full card says no; short lead |
| A bout-finding app (Brawlr, BoutMatch style) | the whole region, anonymous | same day | $10 a month | no history with them: more no-shows and late pull-outs; opponents you do not know |
Numbers are INVENTED (speed, favours); the channels and the app prices are OFFICIAL / OPINION from J_MATCH1.

### 3. What kind of fight (the ask)
Each ask names a kind, a weight gap she will accept and a window (Saturdays within N weeks) and home or away:
- LIKE FOR LIKE: equal experience, the hard limits only (age, weight gap inside the smaller class). Safe, the club's usual bout.
- STEP UP: a heavier or more experienced opponent (the coach's judgment: "double the fights" is the real example). Win chance down, growth and purse up; the
  Supervisor can refuse it.
- DEBUT / SKILLS: an evenly matched first bout or a skills bout (no decision, for the young and green). No stake, no risk, a little experience (a skills bout counts
  0.5 of a bout).
Home shows pay the club a ticket cut ($450); away shows pay travel and the club's cut is lower. The window trades date against pool.

### 4. The wait and the reply
A request stays OPEN (a card on Home and in Mail) for up to 3 weeks; the reply is drawn from the pool: the fighters in reach of her weight class, sex, age and
experience (the game's world roster, Region), reduced by who is booked, injured or suspended. Outcomes: YES (an offer card, as today); A COUNTER (heavier by
1 kg, 2 more bouts, a later date; accept or ask again); NOBODY NOW (the reason in words: "no one at her weight in reach"; widen the window, the weight gap
or the channel); NO REPLY (the app). Scarcity: women and the extreme weights have a thin pool (the 2019 title belts had no opponent at 3 of 8 women's
weights, 37.5%, DERIVED); the player sees the thinness as a word before asking ("few women at 57 kg near you").

### 5. When it falls through (pulling out and short notice)
An opponent withdrew at the last minute is ordinary ("that's boxing"). A late replacement gives away age, weight or experience (J_MATCH1 Q4). Existing:
Bouts.short_notice. New: the PLAYER decides on a replacement: take it (a worse match, the purse stays) or pull her (nothing lost but the camp's weeks).
Pull-outs happen more from app opponents and less from clubs you hold a favour with.

### 6. What it leaves behind
Favours: a clean show with a club earns a favour with it; a pull-out by you costs one. Reputation widens the pool and the speed of replies. The Why names the
ask: "You asked for a step-up through the app and got a heavier girl with five more bouts."

## Wiring (the menus this lives on) and the build
| Screen | Shows | Wired to |
|---|---|---|
| Fighters > her page | "Ask for a fight": readiness read, channel, kind, window, a thin-pool word | Bouts, AmateurBooking, Region, FighterProfile |
| Home | the open request card (days waiting, channel) | the request state on Career |
| Mail | replies: yes / counter / nobody (reason) / no reply | the reply draw |
| Club > People / Network | rival clubs, favours owed, the app subscription | favours ledger, money |
| Fight prep | unchanged (the offer card as today) | Bouts.accept |
| After-bout Why | the ask that led to this fight | the request record |
Pure module AskForFight.gd (readiness rules, channel table, pool and reply draw, counter generator, favours) with unit tests; then the three screens; one
golden-path test walks ask > reply > accept > camp. Probe first: over 300 asks per weight class and sex the share of YES, COUNTER, NOBODY and the days waited; bars:
no channel is best more than 60% of asks; a thin pool (women, extreme weights) says nobody in 30 to 50% of asks, a thick pool in under 10%.

## INVENTED (to the probe, for John to check where he can)
Channel speeds (1 to 3 days / 1 week / same day), favour counts, the app's no-show and pull-out lifts, the 3 week open limit, the ticket and travel numbers, the
step-up win chance shifts. OFFICIAL: the rules in 1, the lead (8 to 12 weeks permit, bout sheet 24 h to 3 days), the weight and age limits, skills bouts.
