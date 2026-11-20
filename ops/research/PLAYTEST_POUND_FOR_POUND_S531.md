# Playtest: Pound for Pound (Demo) vs FightCamp, S531 (2026-11-20)

Playtester seat: management-sim player (Football Manager, OOTP, Boxing Manager, Two Point, Motorsport Manager habits).
Method: the installed demo (`E:\SteamLibrary\steamapps\common\Pound for Pound Demo`) played ONLY through `tools/hidden_play.py`
on the never-shown desktop, ~330 clicks, ~110 screenshots, all looked at by me. Nothing of theirs was opened, copied or
hooked; nothing on the owner's monitors (`wins` said "none" every time); the game was stopped through its keeper and no
`mma.exe` is left. Everything below is our words and our numbers. Play log with every step:
`C:\Users\user\AppData\Local\Claude-Data\claude_pzs8sxrjxfjjc\side-session-notes\local_1cfc1d74-83bd-4964-964e-e7523ed63516\p4p_playlog.md`.
Pictures: `ops/previews/s531_p4p/` (referenced by number).

## 0. What I did NOT do (read this first)
- **I did not reach 3-5 in-game years.** I played Jan 29 to Aug 6 2026 (week 31, **5 shows**), after a 3-year generated world
  history. The demo did NOT cap me: nothing said "demo ends". What capped me was the cost of driving it blind through posted
  clicks: one show is about 60-100 clicks (book, fill, venue, weigh-in, 5 fights, ~12 result screens, signing window) and the
  card builder moves its buttons with the state (the Fill button was at y=280, 408, 504 or 560), so my macros broke on the 6th
  card. The 6th card also could not be scheduled: with 10 signed fighters only 5-6 were bookable (medical clearance), the
  card needed 5 bouts AND a paid main event, and smart fill only fills from free agents. That friction is itself a finding (4.3).
- Not reached because of that: TV deals, pay-per-view, championships (gated behind a 500+ sellout), rematches/rivalry
  rematches, a second year, the "clicker" late game, contract renewals, injuries on my own roster. I report only what I saw.
- The 2D viewer would not auto-play under posted input (only the step button advanced it). I stepped it by hand.
- I did not play FightCamp; FightCamp scores below come from `CRITIC_PACK.md`, `WHAT_TO_TRY`, our previews and the S531
  review read, not from my hands.

## 1. What it is, and the loop
A promoter sim for MMA. You are not a fighter and not a gym: you run a PROMOTION ("Iron Ring Fight League" in my game) in a
procedurally generated US world (about 650 fighters, ~80 rival promotions, 76 TV networks, 150+ towns). The currency is ONE
number, Promotional Capital ("P", the review's "tokens"): shows earn 5-6, every exclusive signing costs 1, upgrades 5-10.

**Minute to minute (one show, about 8 minutes if you click it by hand):**
1. Book a week (4 weeks notice, rival shows shown on the calendar, holidays marked).
2. Card builder: 5 bouts minimum + a main event (1 P). Pick bouts by hand on the matchup page or "Smart Fill" with preferences.
3. Pick a venue from a map (town demand grade, your followers, the top rival's share, rooms gated by upgrades, projected fill %).
4. Sim to the event: weigh-in ceremony (with a decision when somebody misses), pre-fight hype, then each bout: WATCH (2D
   octagon) or SIM, result card with a letter grade and a one-word "kind of fight".
5. Post-show chain: card recap, bonus awards, fan verdict (FLAT / MIXED / RESTLESS), your following per market, fan rankings,
   ladder changes, **an exclusive signing window** (fighters from your own card, 1 P each, before others can bid), rivalry board.
6. Back to the dashboard, advance weeks (a prompt offers "sim to event").

**Season to season (what I could see):** a ladder of promotion tiers per market (Startup I -> Upstart -> Proving Ground ->
Fixture -> Major -> Challenger -> Empire), measured in FOLLOWERS per town/state/region/nation. Markets, TV tiers, venue sizes
and championships open when you reach a tier or a goal (skill tree + a four-goal "Getting started" list). The pull is
"my little local show grows into a national brand".

## 2. Mechanics I touched (depth 1-10, fun, why)
| # | Mechanic | How it works | Depth | Fun | Note |
|---|---|---|---|---|---|
| 1 | New-world wizard (pic 01) | 9 steps: division preset (5/7/11/14 classes), 1-10 years of history, HQ state on a map, name + scorebug, art pack, two starting divisions, start mode (guided / no tutorials / fast) | 7 | 8 | The 3-year generated history gives a world with champions and rankings on day 1. Excellent first 10 minutes. |
| 2 | Talent hub + signing (pic 02, 04) | 655 free fighters, filters (source/state/division/age), archetype tag, record, chin grade, recent fights; overall hidden ("??") until you pay 1 P to scout; sign = 3-fight deal for 1 P | 6 | 8 | Cheap, fast, readable. The hidden overall plus a visible chin grade and a one-line quote is a good "who is this guy" hook. |
| 3 | Roster card (pic 04) | overall letter, 5 stat bars, scouting bullets ("Elite boxing", "High fight IQ"), morale scale with a cause line, form dots, contract fights left | 6 | 6 | Pleasant, but I never *managed* a fighter: no training, no plan. People are cards, not characters. |
| 4 | Card builder + bout editor (pic 07, 12b) | weight class, rounds, belt/stakes (locked early), position; "suggested for this slot" and "fights worth making"; **matchup page** with split portraits, tale of the tape, public line (-155/+155), letter-graded "read" (striking, grappling, defense, physical, mental), predicted hype with plus and minus reasons | 8 | 9 | The best screen in the game. It answers "should I make this fight?" in one glance and teaches the matchmaking skill. |
| 5 | Smart Fill | preferences (contenders, ranked, prospects, fresh, longest wait, rivalries, free agents, reluctant) books the rest | 5 | 4 | Fills only from free agents when my roster is resting; reported "No fight found" with 4 slots open. Then manual work. |
| 6 | Venue map (no pic; seen at Cleveland/Columbus/Cincinnati) | state map, town table (you, top rival, demand A-F, last show), rooms 300 to 19,000 seats with "projected fill %" and a bar | 8 | 8 | Great at telling a story: demand decays after a show (Cleveland A to B- a week later), a small room can "sell out", a big one only "moderate". Rooms are gated by paid upgrades. |
| 7 | Weigh-in + missed weight (pic 08, 12) | ceremony list; some "made weight but looked drained"; a miss opens a 4-option decision (cover it yourself 1 P / dock his purse / catchweight / cancel), each with a stated consequence; a miss can seed a rivalry ("grudge after a missed weight", settled in the cage) | 7 | 6 | The decision is good. The frequency is not: at least one miss on **all 4 shows I weighed in** (1 of 10 fighters, then 1 per card). |
| 8 | Fight viewer (2D top-down; pics 05, 06) | octagon from above, two round portrait tokens that slide around the cage, state tag (STANDING / CLINCH / STANDING OVER), red HURT/ROCKED badge, stat columns on both sides (sig strikes %, takedowns, control timer, sub attempts), MOMENTUM bar, CROWD meter, narration line with coloured names, momentum timeline strip, play/step/speed, SIM TO END | 5 | 8 | The words carry it: "digs an underhook, stays upright and grazes a short right off the ear". The tokens only slide, but the stat boards, the momentum bar and the line make a 90-second fight feel like a story. See 4.4. |
| 9 | Fight result card (pics 10, 11) | winner, method + time, **fight grade** (D- to B+) and a one-word kind ("clinch fight", "submission heavy", "striking battle", "one-sided"), stats with round tabs, star-power change ("newcomer: a KO win built recognition"), **medical clearance date** ("9 weeks, back Aug 6 or later"), streak, contract fights left | 7 | 7 | Dense and readable. The grade is the weak part (4.5). |
| 10 | Post-show chain: bonus awards, fan verdict, your following, fan rankings, ladder | 10-12 full-screen steps, each one click | 6 | 6 | Rewarding the first 2 times, a toll by the 5th. No "skip all". |
| 11 | **Exclusive signing window** (pic 09) | after the show, the free agents who fought on YOUR card can be signed at base cost (1 P) before the rest of the world can bid | 6 | **9** | The stickiest moment in the loop: a nobody wins a debut on my show and I can keep him for 1 P. It turns every card into a scouting event and fills the roster with people I have seen. |
| 12 | Following per market + fan rankings (no pic) | each show moves dots on a ring per town/state/region/nation, with "Gained ground / #22 in Columbus"; the ladder of promotions shows you at #41 of 43 | 7 | 8 | Excellent "numbers go up" feedback. The same circles animate at each level. Prestige was replaced by followers per market (their Update 3). |
| 13 | Skill tree / milestones (no pic kept; seen in the play log) | one line of nodes: Exclusive Contracts 5 P, Main Events 5 P, Championships 10 P (locked until a 500+ sellout), each with a tutorial bubble; "Getting started": First Event, Building the Roster (sign 10), Sellout Show (500+), Crown a Champion | 4 | 4 | A linear checklist. Fine for 30 minutes; it is exactly the review's "forced checklist" complaint. |
| 14 | Broadcast / TV (no pic) | 76 networks unlocked by market tier, "full rate" in P per show, PPV tab | 6 (on paper) | n/a | Seen only as a locked list (Local TV needs "Upstart", Regional "Proving Ground"...). Not reached. |
| 15 | Finances page | earned / spent / net per week + a transaction history | 3 | 3 | Because P is one number, there is no money drama. Fast, but the early economy is thin: after Main Events I sat at net -3 P/week until the first sellout. |
| 16 | HQ inbox | tabs Needs action, Camp, Training, Medical, Contracts, Rivalries, Rankings, Business, Locker room; "Roster too small -> Free Agency" | 6 | 6 | Good structure. In the demo most tabs were empty (no camps or training in a promotion sim). |
| 17 | Rivalries | missed weight / bad blood become a "Rivalry board" entry that is "settled in the cage" after a bout | 4 (seen) | 7 | One short, sharp moment. Not seen again. |
| 18 | Tutorials | a dim overlay with a bubble, 2-3 cards per new screen, "Skip tutorial" always visible | 5 | 6 | Pushy for the first hour (each unlocked node triggers another). Skippable. |

## 3. Why people like it, and where it became a chore (store: 96% of 159 positive)
**Moments that delivered the "I like this" feeling in my play:**
- Minute 15: the first card builds itself, the matchup page says "C+ ... two unfamiliar names" and I want to change it. A real
  decision with a real reason in under a minute.
- The signing window after my first show: the guy who won his debut on MY card is mine for 1 P. (This single mechanic is
  worth the 19.50 EUR for a lot of players, I would guess.)
- The following rings and "UP FROM STARTUP I" after one small show. A town feels earned.
- A 90-second fight with a story (rocked fighter, momentum bar swinging, crowd word going Murmur -> Roaring) that I chose to
  watch instead of sim.
- Venue choice with a projected-fill bar: pick the 300 seat room and sell it out, or the 750 seat room and "sell 70%".
- The world feels alive from day one (a ladder, rival promotions, a "chief rival" who books the same weekend).

**Where it turned into a chore (and the reviews' complaints, did I see them?):**
| Review complaint | Seen? | What I saw |
|---|---|---|
| Late game is a clicker | **Partly, and already at show 5** | Each show is a long fixed click chain (4.3). 10 roster fighters gave only 5-6 bookable (clearance timers), so the card needed manual work. Imagine 150 fighters. The 150-fighter, four-weekly-TV-card late game was not reachable. |
| Checklist gates | **Yes** | Skill tree is one line; Championships needs a 500+ sellout; broadcast tiers need market tiers; "Getting started" lists four goals with P rewards and a pop-up for each. The gates are on rails at the start. |
| Labels ignore the record | **Yes, three times** | A 4-4-0 boxer shown as "#2 CONTENDER" in the result card; a 1-0-0 fighter shown as "#6 contender" in a main event beside a 5-2-0 "#1 contender"; my dashboard "Pound for Pound" list ranked a freshly signed 5-3-0 free agent #1 of my roster by record alone. In a tiny division rank labels mean nothing. |
| Fight ratings detached from the fight | **Yes** | Fight of the Night was a 16-second TKO graded C ("clinch fight", with 0 of 3 takedowns); a 5-round main event with 33 vs 30 significant strikes, a knockdown and a TKO also C+ "clinch fight". The grade and the "kind" label do not read the fight. |
| Rematch timer | Not reached | Weeks-out and "hasn't fought in 17 weeks" appear on the matchmaking board, but I never tried a rematch. |
| Weight misses too common | **Yes** | One per show on every show I weighed in on (4 of 4). The decision modal makes each one a click and a tax. |
| Scouting is a workaround / potential unseen | Partly | Overall is "??" until paid; there is no potential or growth shown; a 1 P "Scout" button just reveals the letter. |
| Impossible world history | Not reached | |

**The honest read:** the first two hours are excellent: fast, clear, clever, one decision at a time. By show 5 the loop
is mostly *clearing a ceremony*, and the person who made the first 10 minutes good (a matchmaker) is replaced by someone
clicking Continue through 12 screens. That is the clicker problem arriving early.

## 4. FightCamp compared, in depth
Seats differ: they are a PROMOTER (the event is the unit; fighters are cards), we are a GYM OWNER/COACH (the person is the
unit; the week is the unit; the fight is the exam). So the comparison is about shared moments, not shared genre.

### 4.1 Table: mechanic -> theirs / ours / who is deeper / what we should take
| Area | Pound for Pound (demo) | FightCamp (from docs + previews) | Deeper | Take |
|---|---|---|---|---|
| Person depth | A card: overall letter, five bars, chin grade, a quote | Three layers: stats and ceilings, traits, habits, ambition, goal talks; training weeks per person | **Ours, by a mile** | Nothing; this is our moat |
| Weekly decisions | Book, fill, venue, then click | Week plan, mornings/evenings, pads, camp, weight | **Ours** | Nothing |
| Matchmaking / "should I take it" | Matchup page with public line, read, hype +/- reasons | Offer card: win chance band, win/loss stakes, scout $250, ask for a fight | Theirs is **clearer**, ours is deeper (chance + what a win gives) | The matchup page layout: hype with 2 reasons, a "line" line, graded read (4.3 #2) |
| Venue / demand | Map + projected-fill bar, demand decays after a show | Club show, ticket cut ($450), no venue choice at amateur level | **Theirs** | A tiny version for the HOSTED CLUB SHOW only (4.3 #8) |
| Fight presentation | 2D top-down with momentum bar, crowd word, stat boards, coloured narration | Settled round shown in 3D; T key = top-down ring over the fight (pics s531c/s531d) | Theirs reads faster; ours is **truthful** (the Why) | The momentum strip, the crowd word and the state tag (4.3 #3) |
| Result explanation | Grade + one word + stats + star power | The Why: your plan graded vs having none, what the opponent's habits cost, next action | **Ours, by far** | Keep; add their "one-word kind of fight" only if it reads the fight |
| After-fight reward | Exclusive signing window (cheap, you choose) | Walk-in at reception; opponent who impressed is not offered | **Theirs** | Biggest single take (4.3 #1) |
| Rank / labels | Ranks by promotion rank among tiny pools: "#2 contender" at 4-4-0 | Ladder points, HotStreak, DUCKED/OWED, "pts" table | Ours, as long as labels follow points | Add a label test (4.3 #5) |
| Progression gates | Checklist tree + milestone list | Goals the player sets; no unlock tree | **Ours (sandbox)** | Keep sandbox; borrow only the "reward flash" (4.3 #9) |
| Clarity of screens | Clean, dark, consistent top bar; one primary yellow button; tutorials | Warm brown + gold; many tabs; Largest-text pass done | Theirs is cleaner at first sight | A "this week" header like their dashboard (4.3 #10) |
| Pacing | One CONTINUE-style "Advance week" with a "sim to event" prompt | CONTINUE stops by itself on Mondays/offers | Even | Keep our stops; never add a 12-screen chain (4.3 #4) |
| World / long game | 650 fighters, 80 promotions, ladders, history; but a clicker by show 5 | One region, small roster, a small living world after the week | **Theirs for breadth, ours for people** | Pre-generated recent history for our regional ladder (4.3 #7) |
| Money | One token P, no drama | Dues, rent, bills, 8 weeks below zero closes the gym | **Ours** | Keep; give the tokens' *speed* only to the club show |
| Rivalries | Weight miss -> grudge -> settled on the card | Rival gym/coach (Frank Doyle), rematches, duck rule | Even | Link weight-miss events to the rival story (4.3 #6) |

### 4.2 Depth, fun, pacing, clarity, viewer, progression, the long game - plain words
- **Depth.** Theirs is wide and shallow (a lot of surfaces, one decision per surface). Ours is narrow and deep (one person's whole week).
  If FightCamp ever feels thin, it is not for lack of mechanics; it is that depth is hidden behind unread screens. Theirs
  is the reverse: everything is legible and almost nothing is hidden.
- **Fun.** They sell fast, clear status growth (followers, tiers) and a matchmaker's eye. We sell "my plan beat their plan".
  The owner's own words (the Playbook is "really fun") are in a different league from anything in the demo, **if** the
  player ever gets there. The risk is the first 20 minutes: theirs delivers three small wins in 15 minutes; we need to
  prove ours do (the owner plays it).
- **Pacing.** Theirs asks for a LOT of clicks per unit of story (60-100 per card). Ours asks for one big CONTINUE. Keep
  that. Do not copy the post-show chain.
- **Clarity.** Their matchup page is the clearest "why this fight" screen I have used in a sim. Our offer card carries
  the same facts but not the one-line verdict. Their labels (fight grade, kind) are clear and wrong; ours must be right.
- **The viewer.** See 4.4.
- **Progression.** Theirs is a rail. Ours is a sandbox with goals; the long game is the reviews' complaint about them
  and our advantage. But their "reward flash" (a milestone card with a star row, "+5 P", and "put this reward toward X")
  is a nice 3-second payoff that we have no match for.
- **Long game.** They solve the beginning with generated history and lose the end to volume. Our scope rules (4 fighters
  for the test club, normal start 0, one gym) already avoid the volume problem. Our risk is the opposite: an empty world
  at the start.

### 4.3 What they get right that we do not have yet (items feed section 5)
1. Pay-off for the person you just saw: an opponent or a club-mate who impressed can be taken on for a token before others can.
2. A single verdict line with two reasons for each decision ("Promotion rankings on the line" / "Two unfamiliar names").
3. A visible reason a fighter is NOT available (clearance date on the card).
4. The cost of a ceremony: they show the chain once per show and never remember "skip".
5. The grade readable from the fight itself.
(Where they are weak and we must not copy: labels, grades, weight-miss frequency, checklist gates.)

### 4.4 Their 2D viewer vs our top-down (T) view
Look at `ops/previews/s531d/topdown_in_game.png` beside pics 05 and 06.
- **Theirs**: the whole screen is a schematic. Large portraits as tokens, a cage drawn in perspective, a heavy HUD (names,
  records, sig strikes %, takedowns, control timer, sub attempts, MOMENTUM, CROWD, state tag, narration, timeline strip),
  hurt = red glow + word badge, finish = a bold result line over the cage. Every second tells you who is winning and why.
- **Ours**: a bare square ring, two dots and a line, the exchange chips 1-6 ("3-3 Outside ... 2-4 Clinch"), over the 3D
  scene with two X-ray figures; the "Jab and move changed nothing" line sits above. It is correct and truthful, and it is
  *quiet*: no momentum, no crowd, no hurt badge on the dot, no coloured names, no state tag on the fighters.
- What to take (fits our rule "the 3D fight never decides, it shows the settled round"): colour the two names in every line;
  a thin MOMENTUM strip that grows per exchange chip; a CROWD word; a state tag (CLINCH / ROPES / STANDING) under the dots;
  a HURT badge on the dot when damage crosses the "hurt" band; portrait faces on the dots; keep the chips (they are ours).
  All of it reads fields we already settle; no new simulation.
- What NOT to take: their autoplay-by-seconds pacing (we play settled rounds), and any stat column that does not come from our
  rules.

### 4.5 A thing to guard in our own game (their failures are our tripwires)
Our `REF_POUND_FOR_POUND_S531.md` already lists them; here is what I saw on screen:
- Rank words must read the record AND the ladder size: a "#2 contender" with 4 fights is a lie. Test: no "contender"
  word until a ladder has 8+ real names and the boxer has beaten one.
- The fight grade must read what happened: finish, time, knockdowns, who landed, stakes. A 16-second finish cannot be
  Fight of the Night at grade C.
- Weight misses should be rare (we target a cause the player can see). If a miss is ever frequent, it stops being a story.
- Gates: any "locked until X" that is not a rule of boxing (e.g. rooms) is a checklist.

## 5. Proposed improvements for FightCamp (most valuable first)
Scope: boxing (+ one BJJ test fighter), one gym, small roster, amateur to the first pro fights. Each item names its screen.

1. **"He caught my eye" after a bout: take the impressive person for the gym.** After a bout at a club show, one of the
   boxers on the card (the opponent who lost well, or a club-mate who won his debut) is offered to the gym once, at a base
   price, on the RESULT page, with a one-line reason ("Lost on points, never stopped"). The player has until the next
   Monday. Why: this is their best mechanic (the exclusive signing window) and fits our "normal game starts with 0 fighters,
   walk-in at reception". It makes every bout a scouting event and fills the roster with people the player has seen.
   Screen: Fights > result page (below "the Why"), then the roster. Needs: a rule module (who is offered, base price from
   ability and age), no new system. (Scope: no widening; it is a source of walk-ins.)
2. **A verdict line with two reasons on every offer (the "hype" idea).** On the offer card, one grade or word for the bout's
   interest and two short reasons, one plus and one minus ("A step up: his rank is above yours" / "Neither known in the
   region"). Add a "line" (their words: the public line) as a plain word: "they expect you to lose" or "even". Why: it
   makes the offer card answer "should I take this?" in one look. Our offer card already carries the numbers; this is
   a sentence on top. Screen: Fights > offers.
3. **Fight viewer: momentum, crowd and hurt on the top-down ring.** Colour the names; add a momentum strip under the
   ring (one tick per exchange chip, which side led); a crowd word (a murmur in a club, a roar in a pro hall); a state tag
   under the dots; a hurt badge on the dot; the boxers' faces on the dots. All from fields we already settle.
   Screen: the 3D round with T on. This makes the quiet view the one the owner wants to watch (his previous note: "one broadcast camera + 1.5 s close-up").
4. **Never add a long post-bout ceremony.** Our result is one page (the fight and what it decided, S440) and one goal talk.
   Keep it. Add a single "next" button that opens the next needed thing (goal, ask, camp) and a remembered "skip" for the
   rest. Why: their 12-step chain is the first complaint a reviewer will make by show 5.
5. **Label tripwires in tests.** A `labels_follow_record` test: after any unbeaten run, HotStreak must say so; no
   "contender" with fewer than 8 ladder names; rank text uses the table, not an order of signing. And a "fight grade"
   (if we ever add one) built from the round log, with a unit test where a quick KO of a top boxer cannot grade low.
   Why: two of the reviews' loudest complaints. Screen: Fights, World > Rankings, the result page.
6. **A visible "available again" date on the roster row.** Their clearance date ("Sep 3 or later") explains why the man cannot
   fight. Ours has rest and a suspension; put the date on the Fighters > Roster row and in the offer card ("fit on 18 Jan").
   Screen: Fighters > Roster, Fights.
7. **A lived-in region at day 1 for the amateur ladder.** A pre-generated 6-month history (names, records, a few unbeaten
   boxers, one rival coach) so the first regional table is not empty. Why: their 3-year world history is what makes their
   first 10 minutes feel real; we start empty by design (0 fighters), but the *region* does not have to. Screen: World >
   Rankings and the Records tab. (Not widening: it is data for the same ladder.)
8. **Show-night as a small matchmaker's job, only for the HOSTED CLUB SHOW.** When the owner's club hosts a small show
   (scope S428), give it the venue/projected-fill idea in miniature: three halls (the gym floor, a local hall, a hired
   hotel room) with a projected fill, and a card builder that suggests pairings with a hype line. Why: this is the place
   our game *is* a promoter; they do that well. Screen: Club > show, after the three mechanics in S428.
9. **A 3-second reward card for a milestone, not a gate.** When a goal is met (the goal talk, a title, 5 wins) show a short
   card ("+1 star, +reputation, put it toward: a coach day / a second ring slot"). No locks, no tree. Why: their "Milestone
   complete" is a pleasing beat at zero risk. Screen: Home, after the goal talk.
10. **A clean "this week" strip on Home.** Their dashboard has five quick actions with counts ("HQ 2 new", "Schedule: full",
    "Sign fighter: 289"). Ours stops at Mondays; a strip that reads "1 offer, 2 tired, 1 weigh-in, 0 questions" is
    the same job in one line. Screen: Home.
**Flag as a scope question (do not build without a ruling):** a market/followers ladder (nation > region > town) for the *gym*
(widening the "one gym" rule); TV and pay-per-view; a weight-miss rivalry system beyond the existing rival coach;
more than 6 rostered boxers. The first of those is the thing their game does best and ours should not copy until the small
living world is built.

## 6. Scores and what takes FightCamp to 10/10
| | Depth | Fun | One-line why |
|---|---|---|---|
| Pound for Pound demo (5 shows, 7 in-game months) | **6/10** | **7/10** | A clean, fast, legible promoter sim; the matchup page and the signing window are 9s; the rest is checklist and ceremony. |
| FightCamp (from docs and previews, not played by me) | **8/10** | **6/10 until the owner's build proves the loop** | Far deeper per person (week, camp, plan, the Why). The first 20 minutes have to deliver three small wins as quickly as theirs; I can only say the design does, not that the build does. |

**To take FightCamp to 10/10** (most important first):
1. The first 15 minutes contain three clear, earned wins (a walk-in signed, a first plan the Why lights up, a first
   town reaction) with no pop-up lecture. This is a playtest question, not a code question.
2. Items 1, 2 and 3 above: a person you saw becomes yours; every offer has a verdict and two reasons; the quiet ring view
   gets momentum, crowd and hurt.
3. Every word of rank, label and grade is checked against the record by a test (item 5), so we never repeat their reviews.
4. The result page stays one page and the clock stays one button (item 4).
5. A lived-in region at day 1 (item 7) and the small living world after the week, so the ladder has names and stories.
6. The home page tells the week in a single line (item 10), and the fighter's *availability* is always a visible date (item 6).
7. Then, and only then, a small hosted show with a matchmaker's venue/hype job (item 8).

## 7. Method notes (for the next playtester)
- The game uses the OpenGL compatibility renderer, so the window comes back grey under `PrintWindow`. Launch it with
  `--rendering-method mobile --rendering-driver vulkan --audio-driver Dummy` (command line only; no game files touched).
- The 2D viewer's PLAY button did not autoplay under posted input; use the step button (x=392, y=683).
- The universal "continue" for post-show screens is a click at (1222, 683); the weigh-in miss modal needs (640,344) then (805,530).
- The card builder moves its buttons (Fill is at y=280 / 408 / 504 / 560 depending on rows); take a shot before clicking.
