# Boxing Manager (Steam 1605370) against FightCamp - read-only study, S425

Marks: SEEN = read in the installed files or the public store page. INFERRED = reasoned from what was seen (says from what).
UNKNOWN = static files cannot show it. Everything below is in our words; no asset, code, data table or text passage was taken.
Files were only read. Nothing was launched, hooked or changed. Scratch notes live outside the repo.

## 1. What it is, in ten lines, and how it was inspected
1. Boxing Manager, Sport and Financial, released 10 Nov 2026, EUR 19.49, Windows and macOS, English only, no user reviews yet (SEEN, store page).
2. You are manager, gym owner and promoter at once: sign boxers, train them, pick every opponent, run the corner, put on your own shows (SEEN).
3. Engine: Godot (a modified build) with game logic written in Swift and loaded as a native library (SEEN: a Swift runtime and a Swift-to-Godot bridge beside the exe).
4. 1.16 GB on disk. 1.0 GB is the exe, which carries an encrypted data pack. 0.02 GB is the game-logic library. The rest is runtimes.
5. Data lives in a SQLite database with about 90 tables, whose layout is written into the logic library (SEEN). Tables cover boxers, amateurs, promoters, trainers, gyms, shows, venues, titles, rankings, news, betting, contracts and a ledger.
6. The in-game manual (about 25 pages, with glossary and a first-hour guide of ten triggered beats) is also stored as plain text in the library (SEEN). This is the richest source.
7. The time unit is one week. "Advance Week" plays the whole world; only your own fight stops the clock (SEEN).
8. The world is generated fresh per career, 17 weight divisions, four world sanctioning bodies plus regional, continental and national belts (SEEN).
9. It began as a phone game: code talks of taps, phone sticks, save slots 3 to 6 and corner shouts as "Ringside subscriber" features, and says "watch an ad" to try a plan (SEEN). The Steam page mentions no subscription. Whether the PC build locks them is UNKNOWN.
10. Could not see: the encrypted data pack (art, 3D fight scenes, the seeded world, UI layouts), anything about how it feels, the real fight maths. The files hold the rules' shape, not their numbers.

Method: directory listing, PE and pack header, string extraction on the logic library, schema and manual read as data, one read of the store page. No decompiler was needed; the REA tools were not used because strings and schema answered the questions cheaply. The pack directory is encrypted and was not touched.

## 2. Their game

### a) The player's loop
- SEEN: the player is a manager with a promotion company, one or more gyms, and a stable of boxers. A second mode, "Boxer Career", lets you be one boxer, with a day job, lifestyle level, ambition, weight and cognitive health tracked (table of career state). No separate boxer mode is on the store page, so whether PC has it is UNKNOWN.
- SEEN: a week is: look at "Action Needed" (offers, warnings, contract ends), make fights in the Matchmaker, set training plans, run shows, press Advance Week. "Advance to my next fight" and "to the next news" skip quiet weeks.
- SEEN: the first-hour guide says plainly that nothing happens to a boxer who is not booked. Booking fights is the core verb.
- INFERRED: real decisions per week are few and chunky (one to four): whom to book, which offer to answer, who to sign, which show to build. Training is set once and left. Quiet weeks are one click.
- What he waits for: offers (a body calling after a ranking), a camp ending on a fight date, a contract running out, ticket sales climbing week by week toward a show.

### b) The boxer model
- SEEN (schema, about 126 columns): roughly 30 rating numbers: ability, punch power, cross power, accuracy, speed, jab, hook, uppercut, body punching, combination punching, counter punching, feinting, defence, head movement, footwork, ring movement, inside fighting, clinching, chin, resistance to punishment, recovery from a knockdown, stamina, conditioning, aggression, plus mind and person values (ring IQ, dedication, potential, charisma, dirtiness, cut tendency, law-abiding, a personality type code).
- SEEN: hidden against visible: an amateur's ratings stay hidden until signed. Potential is a visible shared pool: every gain, from the gym or bought with experience, spends some of it.
- SEEN: natural fitness is fixed for life. Weight drifts with habits. Form and a manager-relationship number (it sets contract price and renewal) exist.
- SEEN: styles: a stored style plus five preference columns (pressure fighter, boxer, brawler, counter puncher, boxer-puncher). Style words in files: swarmer, slugger, counter specialist, and so on.
- SEEN: training: five areas (Strength, Ringcraft, Physical, Resilience, Strategy), each set from none to intensive, with a total cap of 100 percent and slow decay in neglected areas. Camp rows track change in power, chin, defence and stamina, injury chance a week, and three intensity numbers (boxing, conditioning, strength).
- SEEN: experience points are earned in the ring (a win pays more) and spent on single ratings at a price set by trainer and rapport. Manager points raise potential or sign amateurs.
- SEEN: age drives retirement, trainer-in-waiting and decline. Injuries are typed (nose, hand and others) with a duration; an injured man cannot train or be matched; only time cures. Cut tendency is a rating. Damage and long-term brain health are tracked.
- SEEN: weight is a game of its own: walk-around weight, current kilos, diet plan, water cut in camp, a rapid-cut risk warning, missed-weight count, weight-class moves up and down with stated penalties.

### c) The fight
- SEEN: simulated punch by punch with round-by-round commentary and full statistics (store). Per fighter per bout: thrown and landed for jab, cross, hook, uppercut, overhand and body; knockdowns; counters; combos; and seconds spent at long, medium, close and clinch range.
- INFERRED: resolution is per punch inside a time-sliced simulation (the stat set implies punch events and range tracking). Cuts, doctor checks, referee breaks, corner stoppages and the towel are events.
- SEEN: result types KO, TKO, referee stop, corner retirement, disqualification, unanimous, majority, split. Three judges, each with a written scoring personality (rewards output, clean punching, ring control, aggression, or a mix); the manual says panels lean one way and affect close rounds.
- Shown: the store says a "fully customised 3D" fight exists and you can watch any fight. Files say you may watch in full, in highlights, or "let it run", with an extended highlights option. Whether it looks good is UNKNOWN.
- What the player steers (SEEN): before the bell a fight plan sets a "gameplan" (outbox and move, pressure, counter and similar) and up to two "focus areas" (the jab, the body and similar), or lets the trainer pick, better for a sharper trainer. Between rounds the corner says what the round showed and you pick the instruction for the next. "Shouts" during a round take effect next round. You can throw in the towel (a stoppage loss).
- SEEN: spoken corner lines are generic coaching sentences ("keep it simple", "get to the body", "clear your head").
- SEEN, boxer mode only: three control modes: Fighter (you move and throw), Captain (you move and set target, counter or guard), Coach. A stamina strip, a damage bar and the other man's stamina are shown. Every input is a request the engine may turn down.
- INFERRED: a plan is expressed as a choice of one style label plus two emphasis tags, not lines or rules. Its effect on the result is UNKNOWN.

### d) World and career
- SEEN: 17 weight divisions; four world bodies, each with own points ranking; a lineal "magazine" belt; regional rankings that feed continental belts; national, continental, intercontinental and world rungs; mandatory challengers, final eliminators, vacant belts, stripping, unification, deadlines. A body's standing with you rises with fees paid and belts held. Pound-for-pound, GOAT board, Hall of Fame, fighter of the year, record books.
- SEEN: amateurs run alongside (nationals, world championships, Games). Amateurs are signed with influence points, not cash, and a gym in their country is required. A medal raises the signing fee. They turn pro on a contract.
- SEEN: matchmaking is classed for you: tune-up, stay-busy, competitive, step-up, high risk, title fight. The table shows power of the opponent, an edge colour comparison, a win chance "from running the fight over and over", weeks to the date, last result, and whether a rival promoter protects him. The other camp answers at once, yes or no with a reason; a camp wants a bigger purse when it is not keen.
- SEEN: contracts are counted in fights, with fee, signing fee, your percentage; renewal depends on mood, last fight and ranking. Rival stables bid for a champion's trainer. Promoters offer deals at set milestones. Boxers get approached; a mood toward you depends on wins and losses.
- SEEN: money: your cut only on a win; shows pay gate week by week and TV by tier (free web to pay-per-view); venue fees; sponsorship; sanctioning fees; trainer wages; gym running costs. Betting with odds exists. Going below zero blocks purchases but does not close the doors.
- SEEN: your own shows: pick type, venue (fee, likely crowd, break-even shown), build the card, set the TV deal, design the poster (templates, colours, fonts).
- SEEN: database size is not stated. Name lists hold hundreds of surnames for dozens of countries (INFERRED: a generated world of thousands). Real size UNKNOWN.

### e) Progression and reward
- SEEN: grows: boxers' ratings, your reputation (decides how far from home a prospect will join), a gym's size and facilities, sponsors, a bodies' standing, manager influence points, achievements (off in custom worlds), award cards to share, a world editor, custom fighters.
- Unlocks: bigger venues and TV tiers tied to the headliner's following; better prospects at higher reputation; premium weights and slots tied to purchases.
- INFERRED: the long pull is climbing a ladder with real politics (get ranked, wait for the call) and watching a world age, retire and be inducted around you.
- UNKNOWN: whether ten hours in feels like a loop or a chore. A long weekly sim with few choices per week risks the second.

### f) Presentation
- SEEN: dense tables with a glossary of short codes (POT, DED, RES, OTC, DRT, EXTD), tabs on a fighter page, a rail of buttons, a Dashboard with Action Needed first. Graphics appear in posters, faces, 3D fight, share cards. Many sentence-style scorer and trainer descriptions.
- INFERRED: a text-and-table manager in the classic mould, with pictures at the edges. Our owner's "no sentences on a screen" rule is the opposite of their style.

### g) Depth in numbers
- About 90 tables; about 126 boxer columns, 30 or so ratings; 48 trainer columns (about 20 abilities: for example ringcraft, strategy, nutrition, motivation, dark arts, youth development); 31 gym columns; 87 fight columns; 24 bout-stat columns.
- 5 training areas; 4 gameplan kinds listed in the manual (more in files); 2 focus slots; 17 divisions; 4 world bodies; 4 belt rungs; 6 fight kinds; about 7 result methods; 3 judges with about 8 scoring temperaments; 5 TV tiers plus 3 pay-per-view grades; staff: one trainer per gym, plus a manager, promoter, cutman and conditioning slots in the gym table (INFERRED from column names).
- Boxers and venues in the world: UNKNOWN.

## 3. Ratings (0 to 10)
Theirs is rated from files and the store page, not from play. Ours is the game as CRITIC_PACK describes it today, then what the week design would add.

| Aspect | Boxing Manager | FightCamp today | FightCamp with week design v2 |
|---|---|---|---|
| Things to do in a week | 5: a few big choices, training set once | 6: seven mornings and evenings, offers, twist card, camp, but many are repeated or dead | 8: each day has a job, Thursday change, Friday claim, Saturday ringside |
| Depth of decisions | 7: matchmaking with classed risk, contracts, shows, titles politics, weight, many levers but loosely linked | 7: week, pads, plan lines, camp, weight; each decision measurably linked to fights | 8.5: more linked choices, own rules, scarce coach hands |
| The fight as a thing to watch | 6: 3D and highlights claimed, punch-level stats; looks unknown | 5: 3D only replays a settled round, never decides | 5: unchanged |
| The fight as a thing to steer | 5: one style, two focuses, between-round pick; sets and forgets | 8: plan lines, 30-second calls, corner minute, set-up, measured 21 points of wins | 8.5: firing by drilling, plates, rules of own |
| How readable the screens are | 6: classic tables with a code glossary, learnable but heavy | 6: warm pictures, still some text; not many screens rebuilt | 7.5: if the pictures keep their promise |
| World and career | 9: 17 divisions, four bodies, amateur road, shows, TV, contracts, hall of fame | 3: one gym, four pro divisions, an early amateur road | 3.5: draw and ringside add little scale |
| Progression and reward | 7: long ladder, unlocks by reputation, achievements | 5: perks, belts, members; rewards sparse after the first fights | 7: "Opens next", house line, new places, each seen coming |
| Realism | 8: weigh-ins, judges with tastes, sanctioning rules, contract and purse logic, brain health | 7: real club fees, weight, plans, damage; small world | 7 |
| Overall | 7 | 5.9 | 7 |

Reasons in plain words: they are far wider; we are far deeper per fighter and per fight. Our weakest marks are the fight as a show and the size of the world. The owner's focus is things to do in a week, anticipation, choices and reward for continued play, and there their sim is the weaker of the two and ours the more promising.

## 4. WHAT TO TAKE (most valuable first)
1. Classed fights: tune-up, stay-busy, competitive, step-up, high risk, title. What they do: label every offer by how risky it is for this boxer and teach the player a ladder rule (build on easy fights, step up when ready). Helps: a named, anticipated decision each time an offer arrives. Strengthens: Fights card and the Thursday answer. Size: small. Caution: ours already has TUNE-UP, STEP UP, PAYDAY; make the label drive a visible consequence (mood, ranking, next offers), not only a word.
2. "Why was this refused" on every ask. What they do: the other camp answers at once with its reason under a badge; a camp wants more purse when not keen. Helps: the player learns the world and plans the next ask. Strengthens: the named ask and Thursday's answer in week v2. Size: small. Caution: our design already says "list of what is missing"; keep it free of dice.
3. A shared win-chance read "from running the fight many times". What they do: the matchmaker shows a win percentage from a repeated simulation plus a power column and a green/red edge. Helps: decisions get faster and richer. Strengthens: the card in pictures. Size: small to medium. Caution: ours shows a band and how sure; keep the band, add the one-glance edge.
4. Action Needed as a single landing place with deadlines and consequences ("turn a body down and they remember"). Helps: tells the player what ends this week and what it costs to ignore. Strengthens: Home's board. Size: small. Caution: ours uses flags that stop the clock; do not add pop-ups.
5. Skip-to-next-event controls. What they do: advance to the next fight, or to the next news about my stable, or after a month. Helps: quiet weeks cost one click, so the busy weeks feel dense. Strengthens: the Continue button and Thursday's no-stop rule. Size: small. Caution: ours already stops by reason; just add the "to my next fight" shortcut.
6. Standing with each body and a ladder of rungs (national, continental, intercontinental, world, with mandatories and eliminators). Helps: a long reward line with politics and anticipation ("wait for the call"). Strengthens: World, the pro ladder after the debut. Size: large. Caution: boxing-only scope; take the shape (a few rungs, one mandatory, one stripped-for-ducking) not four bodies.
7. A world that moves without you: others age, retire, are inducted, rivals win belts. Helps: reason to look at the news and anticipate. Strengthens: World and rivals. Size: medium to large (ours already ages pros; the screens lag). Caution: show only what touches your boxers.
8. Judges with taste. What they do: each judge favours output, clean work or control, and a panel's lean is shown. Helps: a reason to fight a different round, and a use for the plan. Strengthens: the fight plan and the Why. Size: medium. Caution: the owner held back R29 (rules on scorecards the player cannot see): only add if the lean is visible before the bout.
9. Weight as its own small game: walk-around weight, diet plan, water cut, a clear risk warning a week ahead. Helps: tension each week. Strengthens: Thursday's scale change. Size: small (ours has most of it). Caution: keep the rapid-cut risk readable in a picture, not a sentence.
10. Own shows with a poster and TV tier ladder as late-game reward. Helps: a goal after the club is stable. Strengthens: Club and reward. Size: large. Caution: outside "head coach of one club"; park it as a later promoter reward, not now.

## 5. Where we are ahead, and what not to copy
Ahead:
- The fight plan. Theirs is one style plus two focus tags. Ours is written lines whose worth is measured (about 21 wins in 100) and graded in the Why. This is the best thing we have.
- Preparation that matters: undrilled answers cost 2 to 14 in 100; camp lines, pads, tape, sparring. Their training sliders are set and forget.
- Live steering and honest feedback: calls every 30 seconds, a corner minute, "why you won". Theirs is a pick between rounds.
- Readable screens by owner rule: icons, meters, no sentences.
- A coherent small world: one gym, one boxer's story, each choice with a visible price.

Do not copy:
- Many tables with short codes; it fights the owner's graphics-over-text rule.
- Sentence-heavy judge and trainer flavour text.
- Subscription and ad gates on core play, and phone tap controls; against our "no timers, ads, gacha" rule.
- Four world bodies and 17 divisions; scope is boxing, one gym, amateur to first pro.
- Controlling every boxer's punches live; our rule is that the 3D never decides.
- Set-and-forget training sliders; the opposite of a week with things to do.

## 6. Open questions only play will answer (an hour)
1. How many things does one week really ask once you have three boxers? Count clicks between two Advance presses.
2. Does the 3D fight look worth watching, and does the highlights mode make fights feel short?
3. Do the gameplan and the two focus tags visibly change a fight, or are they decoration?
4. What does a between-round instruction change, and does the commentary say so?
5. Are the tables readable at 1080p, and how long before the codes (POT, RES, OTC) stop slowing you?
6. How fast does the matchmaker accept a fight, and does a refusal teach anything?
7. Is the Boxer Career mode on the PC build, and are plan and shouts locked behind a purchase?
8. How big is the world: boxers, venues, countries, at the first screen?
9. Does anything stop you for a month at a time? How long between two interesting choices?
10. After an hour, what would you open next, and what pulls you back tomorrow?
