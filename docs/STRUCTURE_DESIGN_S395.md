# FightCamp structure design (S395, 2026-11-07)

Written by Claude as designer. Paper only: no game code, assets or tests were changed, and no Godot job was run. It goes with docs/GAME_BIBLE.md and docs/PLAYER_PATH.md. Where this page differs from them it says so, and nothing here replaces them until the operator has answered section 9.

## The verdict, on one page

**Where we stand.** If a reviewer scored FightCamp today as a finished game, I estimate about **4.4 out of 10**. On the same scale, Football Manager 24 is 8.0, Corner King, our closest live rival, is 5.8, and World Championship Boxing Manager 2 is 3.1. This is my estimate from real reviews and our own critics, not a measurement: no stranger has played the game. An earlier critic gave us 6.5, but that was a preview, which judges promise and not length.

**The biggest gap is not the menus. The game stops.** A boxer who turns pro gets no more offers. Nobody ages or retires, and nobody new arrives in the pro ranks. Our audience plays for hundreds of hours; we run out in a few. Adding more fights is not enough either: "repetitive" is the reviewers' main verdict at 7 and under. Each stage of a club's life has to bring new problems.

**The second gap is the manager's real job.** In boxing, the manager's skill is choosing who to fight and when, and we cannot ask for a fight at all. The top-rated bad reviews of World Championship Boxing Manager 2 say the same thing: no rankings, no choice of opponent, "What's the point?"

**The third gap is size.** The game is built for one or two fighters. The coach already writes the week, but offers, camps, plans and fight nights all wait for you, and the pages do not work for eight.

**Corner King changes the picture.** We read its installed files. It already ships most of the long game this design proposes: about 1,450 pros, 15 organisations, title fights, asking for a fight, poaching, retirement, a hall of fame, seven starts and an editor. Those are the price of entry now, not selling points. We will not beat it on size.

**What we have that it lacks.** Across this kind of game, players' first complaint is that numbers do not visibly cause results. In Corner King nothing tells you why a fight went as it did, every boxer shares one brain with no styles, you cannot author a plan, the gym can never fail, and rival fighters appear never to improve. Our corner minute, our "what decided it" screen, our Playbook and a club that lives on members' dues and can really close are the answer. **So the game must be deeper, not wider.**

**The design in six moves.**
1. Make the plan matter more, make fighters fight differently, and show it working in the ring.
2. Add matchmaking: ask for a fight, see the whole road ahead, scout before you say yes.
3. Make the world live, on a smaller scale than Corner King's: boxers age, improve, retire and arrive, with a pro ladder and titles. The save never has to end.
4. Make it a stable of up to eight, where you choose what to run yourself and leave the rest to the coach.
5. Give each year a shape: fixed dates, a year review, awards, a record book.
6. Finish the agreed menu cut, with the first fight at about minute 25 and the "why" screen by minute 35.

Seventeen missing systems are proposed for your approval in section 5.7, each with a build size. Section 5.9 sets us against Corner King. `docs/STRUCTURE_MOCKUPS_S395.html` shows the main screens beside the real game.

**What we can honestly reach.** About 7 to 7.5 if all of this is built well. That is a ceiling, not a forecast, and plans always score better than games. Corner King is also improving every month. A 9 from a reviewer who loves this niche is possible. A broad 9 average is not a sensible target: of the games checked, only Crusader Kings III and Against the Storm reach 91 with a real panel of critics. The better target is what small sims reach on Steam: Football Coach: College Dynasty sits at 95% and Pro Wrestling Sim at 97%, both with plain looks.

**The cost.** My rough guess: 6 to 10 working sessions to reach the stranger test, then 30 to 45 more for the long game, before Early Access. I raised this after seeing how much Corner King needed. That delay is the biggest price in this document, and it is why question 1 is yours.

**Order.** Structure, then strangers, then the look. Your decisions are in section 9.

---

## 1. How this was made, and how far to trust it

- **Our side:** the bible, release plan, PLAYER_PATH, the current screens and the code. Also the S370 menus research, S388 menu research, S391 and S387 screen critics, S367 critic review, Dominus studies (S389, S390), Camp Board (S390), Blood & Canvas (S392), menu direction (S393), the S394 handover and the Two Point notes.
- **Note on sources:** there are no memory notes named S393, S394, S370, "Menus are the game" or Gladiatus. Those facts come from `ops/research`, NEXT_SESSION_PROMPT and the roadmap. I found no text with the words "Menus are the game" anywhere.
- **Real numbers:** Steam scores were read from each store page on 2026-11-07. They are English-language figures, which is why Punch Club shows 3,611 reviews here and about 12,000 in the bible.
- **Reviews:** about 170 pages were opened by two research passes, plus the top 20 reviews of each game from Steam's community pages.
- **Blocked:** Reddit, Grey Dog forums, OOTP forums, IGN, Eurogamer, Polygon, Rock Paper Shotgun and GameSpot could not be opened directly. Their scores are marked "via" where an aggregator carried them. Steam's top-rated pages show the loudest reviews, so complaints are a pattern, not a count.
- **Corner King:** read from the installed files (shipped interface and game code), with study notes kept outside the repo. Read-only: the game was not run or hooked, and nothing of theirs is copied. Its real feel and pacing are unknown, because nobody played it for this study. Rival fighters not improving is a strong inference from searching the code, not a proven fact.
- **Seats (our outside AI helpers):** Arena answered in full, but it used weak sources and mostly built on what the brief told it. My brief also carried a stale fact: it said 14 slots a week per fighter, when since S356 the coach writes the week and you edit exceptions. Their "cut the slots" ideas answer that stale fact. Grok Expert could not be reached: this browser's Grok account is on the free plan, and every model above Fast opens a subscription page. Grok bots failed with a 502 error, so Grok's free Fast model answered instead, and its reply was short. Treat both as light second opinions. Neither raised matchmaking or a living world.
- **Our game's scores:** no build was played for this document, so "today" rests on code reading and the critics up to S394.
- **Mock-ups:** `docs/STRUCTURE_MOCKUPS_S395.html`, 21 side-by-sides. A fresh blind reviewer scored the set 7/10 on the fifth round (6.3, 6.5, 6.5, 6.5, 7.0), which only just meets the bar of 7. Left sides are captures from 6 Nov, and the fight and corner frames come from this morning's film, because the corner changed. They were not re-shot, because a film render was running and two Godot jobs must never run together.
- **Critics:** all critic scores below are from before the Corner King study. A blind design critic scored the first draft 6/10. A fresh one scored the second draft 6/10 too: first page 7, rubric and gaps 5.5, loops and screen map 7, proposals 6, build order 5. Both sets of corrections and holes are worked in here, including rules 1 to 4 and the stable's budget. The third version and the Corner King changes have not been rescored.

## 2. The reference table

"Steam" is the share of positive English reviews and how many there are. MC is Metacritic. OC is OpenCritic. Full source lists are in section 11.

### Boxing and MMA

| Game | Score | You are, and the loop | Time | Screens and the fight | Praised | Punished |
| --- | --- | --- | --- | --- | --- | --- |
| Corner King: Boxing Tycoon (Early Access, Aug 2026; read from its files) | Steam 90% of 41 | Gym owner, or promoter, or both. Sign, pair trainers, set camps, take or request fights, negotiate, climb 15 organisations, retire, repeat | One day per Continue; Simulate Days runs to the next blocker; unanswered decisions stop time | 17 sidebar sections, 18 tabs, most decisions in email. Real-time 3D physics fight, watched: one pick per break, 3 shouts a round | The nearest rival to us. Good bones, RPG-style situations, active developer | Boxers interchangeable (code agrees: one brain, no styles), odds unexplained, little fight influence, cluttered, bugs, no height or reach |
| Boxing Club Manager (2022) | Steam 57% of 87 | Club owner. Training points, take fights | Calendar | 3D or instant sim; editor with Workshop | Fills an empty genre; the editor | Stats do not drive fights, sim feels like a coin flip, amateurs pointless, thin for $39.99 |
| World Championship Boxing Manager 2 (2023) | Steam 67% of 90; outlets 4 to 8 | Train, rest, book, pick a tactic | Monthly calendar, no skip of 20-second rounds | Facility backgrounds, real-time pixel fight | Easy to learn, pixel art, stress and rest balance | No rankings, titles or weight classes, opponent random, no feedback on tactics, monotonous |
| World Boxing Manager (2016) | Steam 58% of 135 | Gym manager. Spar to judge potential, negotiate with TV | Daily, skip empty days | Text rounds, cuts between rounds | Narration, cause and effect | Long empty start, boxers as stat lines, money stops mattering |
| Boxing School 1 and 2 | Steam 89% of 516; 80% of 45 | Run a boxer through equipment until tired | Daily | Real-time bout, corner talk between rounds | Light, charming | Idle-game feel, grind, defence useless, sequel near identical |
| Boxing World Simulator (Aug 2026) | Steam 100% of 46 | Promoter, eras from the 1950s | Not verified; four-week booking limit | 2D or text, editable fictional database | Called the missing boxing match for text-sim fans | Thin records, four-week booking cap |
| Pound for Pound (Early Access, Mar 2026) | Steam 96% of 155 | MMA promoter, procedural world, deals on promises | Not verified; praised for speed | Clean interface | Speed, stories, broken promises cost loyalty | No record book or hall of fame, late game like a clicker |
| MMA Team Manager (2019) | Steam 33% of 56 | Football-style leagues of fighters | Daily, three slots | 3D fights | Almost nothing | Cluttered, no tutorial, days skipped once set |
| World of Mixed Martial Arts 3 (2015) | Steam 80% of 77 | Owner of a promotion, no win or game over | Skip to next event or years | Text fights, editor, mods | 85+ stats, ageing, upsets in text | Clunky fixed window, easy money |
| Title Bout line (1990 to 2013) | No aggregate found | Promoter, stage fights and read them | Not verified | Blow-by-blow text, all officials editable | Atmosphere; 1,000-run pairings | Dated, launch bugs, abandoned |
| Punch Club 1 and 2 | Steam 72% of 3,611; 80% of 1,248; MC 73 | You are the fighter. Work, eat, sleep, train | Actions cost hours, stats decay | Automatic fights | Style, hook, programming your fight | Decay grind, luck over planning, passive fights |

### Wrestling and gladiators

| Game | Score | You are, and the loop | Time | Screens and the fight | Praised | Punished |
| --- | --- | --- | --- | --- | --- | --- |
| Total Extreme Wrestling (2020, IX) | Gaming Respawn 8; TEW 2013 Steam 92% of 75 | Owner or booker. Build shows, read ratings | Afternoon and evening each day | Left navigation, an Office, visible bonus breakdown | Depth, sandbox, thousands of hours, fictional world, mods | Spreadsheet look, too many clicks, slow start |
| Pro Wrestling Sim (2021) | Steam 97% of 672 | Booker. A simpler TEW | Not verified | Text | Easier than TEW, mods, hundreds of hours | Fewer stats |
| Believr Pro Wrestling (Early Access, Jan 2026) | Steam 73% of 26 | Beat-by-beat match plans, live show | Weekly mode not yet in | Clean text show | Clean interface, editor | AI art, missing contracts |
| Dominus Gladiatus (Nov 2026) | Steam 57% of 143 | Own a gladiator school | Real-time days with pause | Courtyard hub, auto-battler | The premise | Waiting and slow grind, gladiators alike, short |
| Gladiator Manager (2021) | Steam 76% of 108 | Hire, train, fight through five leagues and a cup | Seasons | Report shows every dice roll | Visible maths, mods | Luck in outcomes, wants more depth |

### The wider management games reviewers judge us against

| Game | Score | The loop | Time | Screens | Praised | Punished |
| --- | --- | --- | --- | --- | --- | --- |
| Football Manager 24 | MC 84; OC 83; Steam 92% of 11,683 | Squad, tactics, match, read | Runs between matches | Dense data pages | Tactics, delegation, yearly fixes | Daunting start |
| Football Manager 26 | MC 68; OC 71; Steam 38% of 9,464 | Same | Broken up by pop-ups | Tiles, cards, top bar | Match engine, tactics | Extra clicks on common jobs, mobile feel, bugs. Fell 16 points while its engine won praise |
| Out of the Park Baseball | MC 89 (OOTP 15, 8 critics); OOTP 26 Steam 82% of 825 | Run a club, control no player | Daily or sim a season | Side menu, nested pages | Development tools, delegation, content | Clutter, steep start, late-season repetition |
| Motorsport Manager | MC 81; OC 82; Steam 90% of 5,201 | Build parts, run race weekends | Live races, 30+ minutes | Tabbed departments | Risk shown as plain percentages, personal stories | Dead time, tutorial dump |
| F1 Manager 2024 | MC 81; OC 80; Steam 82% of 2,416 | Weekend, R&D, staff | Weekend is the unit, simulate option | Simple | Create a Team, morale links work to results | Chores with no clear effect, easy success |
| Crusader Kings III | MC 91; OC 90; Steam 90% of 50,500 | Rule a dynasty, die, play the heir | Clock with speeds | Map, sheets linked like a wiki | Own stories, tooltips inside tooltips, teaching in a real game | Crowded screen, learning cliff, late plateau |
| Two Point Museum / Hospital | MC 84 / 83; Steam 95% of 5,360 / 93% of 12,755 | Build, staff, hit star goals, move on | Not described in the reviews read | Many menus that flow | Systems layered in slowly, readable humour | Staff babysitting, opaque stars, late slog |
| Football Coach: College Dynasty | Operation Sports 4.8 (unlabelled); Steam 95% of 1,510 | Recruit, coach, weekly games, years | Weekly dashboard lists tasks and checks them | Plain tables | Recruiting suspense, visible consequences, gentle teaching, 1,000-hour players | Extra navigation, plain art |
| Hollywood Animal | Steam 79% of 1,654 | Run a film studio | Phases with unskippable transitions | Not described in the reviews read | Detail and amount of control | Hidden logic, tutorial leaves you unprepared |

**What the table says about the market.** The bible's market section is out of date. Corner King is a live direct rival, much fuller than its review count suggests, and is not named there. Promoter games now include PROMOTER, Boxing World Simulator, Boxing Tycoon, The Fight Business (two separate games), Pound for Pound and Cage Empire. Small samples flatter new releases, so Corner King's 90% and the 100% above are early scores, not settled ones. Dominus's real-time week drew "waiting" complaints within two days of release, which supports dropping our S390 live-week test.

## 3. The 9/10 rubric

Built from the patterns that three or more real reviews support. Weights are mine.

| # | Test | Weight | What reviewers reward | What they punish | Evidence |
| --- | --- | --- | --- | --- | --- |
| 1 | I can see why it happened | 15 | Cause on screen, plain percentages, outcome tied to work | Coin-flip sims, no feedback on tactics | F1 2024, Motorsport Manager, FCCD; against WCBM2, Boxing Club Manager, Hollywood Animal |
| 2 | My save tells its own stories | 15 | Different every run, people who feel like people | Identical opponents, choices that change nothing | CK3, Motorsport Manager players' tales; against WCBM2, Corner King |
| 3 | The long game never runs dry | 15 | Years of play, new problems late | Repetition, the main verdict at 7 and under | TEW, FCCD; against Punch Club, WCBM2, OOTP late seasons |
| 4 | Decisions, not chores | 10 | Few choices with real trade-offs | Tasks with no clear effect | Against F1 sponsors, FM26 notices, Hospital paperwork |
| 5 | Common jobs are fast | 10 | One click, sort, compare | Extra clicks; friction costs more than ugliness | FM26 fell 16 points, mainly on this, with bugs on top |
| 6 | Depth is optional | 7 | Delegation that works, slightly worse than you | Babysitting | FM24, OOTP, TEW; against Two Point Museum |
| 7 | The first hour lands | 10 | Real game from the start, one system at a time, early payoff | Dump, then early losses, or hours with no result | CK3, Two Point, FCCD; against Motorsport Manager, WCBM2 |
| 8 | It explains itself in place | 4 | Hover for why | Help that lives elsewhere | CK3; against FM26, OOTP |
| 9 | It can be trusted | 6 | No bugs, true numbers, saves safe | Bugs in a game played through menus | FM26, OOTP 26, WCBM2 |
| 10 | It is good to watch and hear, and I can skip it | 4 | Clear and readable; plain is forgiven | Unskippable waits | OOTP 15 at MC 89 with plain looks; against WCBM2, Motorsport Manager races |
| 11 | It lasts beyond us | 4 | Editors, mods, a developer who stays | Abandonment | TEW, Pro Wrestling Sim; against Title Bout 2013, Boxing School |

**What separates 9 from 7:** tests 2 and 3. Reviewers of a 7 say "good, but it repeats". Reviewers of a 9 tell you a story from their save.

**What looks matter for:** less than we have been spending on them. Plain looks were forgiven again and again; slow clicks and hidden causes were not. But our operator's rule stands: the game must not look broken.

**How realistic is 9?** Football Manager's best in the editions checked was 85, Motorsport Manager 81. OOTP's 96 and 89 rest on 5 and 8 critics. Indie sims rarely get enough reviews for a score at all, so what matters most is Steam players, then specialist sites.

## 4. Our game scored

Scores out of 10. Reference scores are my reading of their reviews, not measurements. As a check on the rubric, FM24 comes out at 8.0 against MC 84 and Motorsport Manager at 7.0 against MC 81, so it runs up to a point harsh. "After this design" is a ceiling for a plan that does not exist yet, so read it as 7 to 7.5, and do not read it as beating games that have shipped. The rubric does not predict Steam percentages: Corner King has 90% from 41 early reviews while scoring 5.8 here. It measures how a deep game would be judged by this audience over a long save, and Steam reviews weigh price, hope and a young game's promise too.

| Test | Weight | Today | After this design | FM24 | Motorsport Mgr | TEW | FCCD | Corner King | WCBM2 | Boxing Club Mgr |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 See why | 15 | 6 | 8 | 7 | 7 | 8 | 7 | 4 | 2 | 2 |
| 2 Own stories | 15 | 4 | 7.5 | 9 | 8 | 9 | 9 | 6 | 2 | 3 |
| 3 Long game | 15 | 2 | 7 | 10 | 7 | 10 | 9 | 7 | 2 | 4 |
| 4 Decisions | 10 | 6 | 8 | 8 | 8 | 8 | 8 | 6 | 3 | 4 |
| 5 Fast | 10 | 5 | 8 | 7 | 8 | 4 | 7 | 6 | 5 | 5 |
| 6 Optional depth | 7 | 5 | 7 | 9 | 3 | 7 | 7 | 6 | 2 | 3 |
| 7 First hour | 10 | 4 | 8 | 5 | 5 | 3 | 8 | 6 | 5 | 4 |
| 8 Explains itself | 4 | 6 | 8 | 7 | 6 | 6 | 6 | 6 | 3 | 3 |
| 9 Trust | 6 | 4 | 8 | 8 | 8 | 8 | 8 | 5 | 5 | 4 |
| 10 Watch and hear | 4 | 4.5 | 6 | 7 | 8 | 3 | 4 | 6 | 7 | 4 |
| 11 Lasts | 4 | 1 | 6 | 10 | 8 | 10 | 5 | 5 | 1 | 6 |
| **Total** | 100 | **4.4** | **7.5** | **8.0** | **7.0** | **7.3** | **7.6** | **5.8** | **3.1** | **3.6** |

Corner King is scored from its shipped files plus reviews, as it stands in Early Access (interface version 0.0.54 when dumped). Nobody here has played it, so its feel and bugs rest on reviews. An earlier draft scored it 4.4 from reviews alone: that was far too low, because reviews did not show how much exists.

### Why each low score

- **Long game, 2.** Pros get no offers (`scripts/state/Bouts.gd:115`). Age is used only to check who may enter a championship: nothing makes a fighter slow down or retire. The pro ladder ends at the debut. The world is a fixed list of rivals in each division with records that move.
- **Optional depth, 5.** The week is already delegated: the camp phase writes the coach's week, it repeats by itself, and an unanswered twist card is the coach's call. But offers, camps, plans and the corner all wait for you, and there is no per-fighter "coach runs it".
- **Own stories, 4.** The signing card is the best screen we have, and Records exists. But the ambition on the card does nothing, the opposition barely changes, and the world forgets.
- **First hour, 4.** Scored 3 before the guide; never rescored. See below.
- **Trust, 4.** No autosave in the code. Settings and Handbook are "not built yet" pop-ups (`scripts/ui/Main.gd:363`, `:365`). The release plan also lists a DEBUG window title and a camp bonus counted twice; I did not re-check those two today.

### What a reviewer hits in the first hour, in order

1. Opens Settings to set resolution or text size, and gets "not built yet". This happens before they have played.
2. Finds 24 named area tabs and 8 fighter tabs for one boxer (`scripts/state/Data.gd`; 4 of the 24 are Playbook's, now reached from the fighter page). The S386 line still fits: "FM-sized menus over Punch-Club content".
3. Thin list pages beside rich ones. S391 named staff, camps, record, deals, events and search; some have changed since. Facilities today is only a repair list: nothing to buy.
4. Must say yes to an offer before they can learn about the opponent (S369). Win chance reads "33-90%", which says almost nothing.
5. Wants to pick an opponent. Cannot.
6. Waits 2 to 4 weeks for the first fight. This is the hour's payoff, and it comes late.
7. Sees debug-like text or contradictions from the S391 list. MENUTEXT1 fixed some in S392, and the list needs checking again.
8. Watches the fight: motion 4.5 to 5, HUD 5, no commentary to carry it, every jab sounding the same. Nobody has heard the sound set in play.
9. Reads a very good corner and result screen. This is the moment they decide to carry on, and it must arrive sooner.
10. Loses the session if the game crashes: no autosave.

## 5. The structure design

### 5.1 What the game is

**You are the head coach and owner of a small boxing club.** You are not a promoter or a tycoon. The coaches you hire are your assistants, so "Coach runs it" means your assistant runs that fighter for you. You find unknowns, decide what they become and who they fight, stand in their corner, and read honestly why it went the way it did. Your club lives on the members who pay dues.

**What a reviewer must remember:** "the corner minute, and the screen that tells you why." Both seats kept the Why panel as the thing to remember, but my brief pointed them there, so that is agreement and not independent proof. The evidence is the niche's first complaint.

**Store line, for testing:** "Run a real boxing club. Pick the fights. Work the corner. See exactly why you won."

### 5.2 The loops by time scale

Times are targets until strangers are timed.

| Scale | What happens | What the player decides | Real time | Ends with |
| --- | --- | --- | --- | --- |
| **Day** | Sessions run, gauges move, the world fights. No daily job | Nothing, unless a red pin stops the clock (fight, weigh-in, injury, a last-day offer) | Seconds | The next stop, named on CONTINUE |
| **Week** | Monday page, then CONTINUE | Answer pins. Step in on any fighter. Quiet week: one click | 1-2 min quiet, 5 busy | A tease: what is next |
| **Fight cycle** | Offer or ask, scout, accept, camp, plan, weigh-in, fight, why | Who and when. Camp focus and cost. The plan. Corner calls. What to train next | 20-30 min for a fight that matters; 2-3 for one you simulate | What the result changed |
| **Fight night** | Tape, rounds, corner, result, why | Watch full, highlights, or sim. At each break, pick from the corner's few options | About 6 min for 3 rounds; about 20 for a 12-round title fight on highlights | Three lines on why, and one button to act |
| **Year** | Fixed dates: regional, nationals, title dates, new arrivals, member renewals, year review on the first Monday | Who to push, who to rest. What to spend on. Who to let go. Which three club goals to chase next | 3-5 hours with a full stable, if you play about 6 fights and simulate the rest (52 weeks at 1-2 min, 6 fights at 25 min, 18 at 3 min). Playing everything takes 10 or more | Awards, record book, new faces |
| **Career** | A boxer's whole road: unknown to title to decline to retirement | When to step up. When to stop. Who comes next. A retired boxer can join as a coach | First title about 15 hours (a guess); save never has to end | A place in the club's history |

**The rules that make this work:**
- **Days have no decisions.** S390 found a daily pick is a solved chore, and Dominus is now being marked down for waiting. Both seats wanted a daily step; I reject that below.
- **The clock keeps the agreed Monday stop.** One change: once a player has a stable, a setting lets CONTINUE run to the next pin and skip quiet Mondays. Reviewers punish slow seasons, and a player 200 hours in should not click 52 times a year.
- **The roster sets the pulse.** One boxer fights a few times a year. Eight fighters means a fight about every fortnight. This is the real answer to "nothing interesting between fights", and it only works if most of those fights can be run in minutes.
- **Not every fight is an event.** You write the plan in two minutes and simulate the night. Tests 4 and 5 punish forced watching. See the plan rule in 5.3a.

### 5.3 The six big changes

**1. The hook bites harder.** Measured: good plan 59%, no plan 45%, bad plan 41%, and it flips about one exchange a fight. Target: in a close match, at least 30 points between a good and a bad plan, with the better-trained fighter still usually winning. A bad plan must hurt. Ring position must show on screen, so the plan is seen working rather than read in a caption. Pressure as a score that cuts the opponent's output, and a stamina ceiling that shrinks with clean hits (both from S392) give the Why screen real things to report. Hints must stop giving the answer away.

**2. Matchmaking.** The manager's real job, and a loud complaint about World Championship Boxing Manager 2. The rules that stop it being a solved choice are in 5.3a.
- **The Road:** one picture of the whole ladder, club shows to world level, with your fighter on it. It shows on Fights and on the fighter's Overview.
- **Ask for a fight:** pick a fighter, see three to five opponents in reach, each with risk, money, rank effect and date. Promoters say no if you have not earned it. Offers still arrive by themselves.
- **Scout before you say yes:** a small cost in money or days narrows the range. Today the range only narrows after you accept.
- **One good number:** replace "33-90%" with a plain band plus what is unknown, for example "Likely, unless her power is real. Unscouted."
- **Few terms:** date, weight, purse. Deep contract screens are out: reviewers want trade-offs, not forms.

**3. A living world.** This needs rules and data, and almost no art, which is what we are best at producing.
- Generated boxers in every division, amateur and pro. They age, peak, decline, retire, and new ones arrive.
- Fictional organisations and belts: area, national, continental, world. Invented names keep us clear of real bodies, and many TEW players prefer a good fictional world. This includes clubs: `scripts/state/Data.gd` still names real English clubs, which the release plan's legal list does not yet cover.
- Careers end honestly: age, plus the lifetime damage ledger with a fights-left forecast (S392). This gives every fight a cost beyond the week.
- A record book that remembers: champions, title reigns, best fights, rivalries, your club's history.
- All of it held in plain data files, so fans can edit it later.

**4. A stable, not a planner.** The coach already writes each fighter's week from the phase, and the player edits exceptions. That stays. What is new is a per-fighter choice of **Coach runs it** or **I run it**, covering offers, camp choices and twist cards as well as the week. The S354 mechanics stay as the hands-on layer: mornings summing towards a goal, evenings on moves and combos, the plan. Coach-run training must be good, and slightly worse than a player who cares. Coach skill sets how much worse, so staff have a real value. Limit: 3 places at the start (two boxers and the BJJ athlete), up to 8 with staff and upgrades.

**5. A year with a shape.** Fixed dates everybody can see. A year review on the first Monday. Three visible club goals a year, chosen from a short list, such as "reach 40 members", "win an area title", "develop a national medallist". Club standing rises through named tiers, and better prospects and better offers come with it. Success is judged against your own size, so a small club can have a great year.

**6. Fighters as people.** Rolled traits as numbers on one sheet feeding one shared brain (S392). Habits you only discover by watching, which can improve (S390, the fresh part). **The goal agreed at signing is a promise**: keep it and loyalty grows; break it and they may leave. A named rival coach and gym that crosses your path for years. Age, injuries and a fighter who sometimes says no. Twist cards stay only where the choice changes something you can see.

### 5.3a Three rules that hold the design together

These answer the critic's three holes. Numbers are targets to test, not decided numbers.

**Rule 1: the plan beats the coach, and you can skip the fight and keep the plan.** Otherwise a good coach makes your plan pointless, or a bad one forces you to watch everything.
- A plan you write counts in full, whether you watch the fight or simulate it. Writing it takes two minutes and is the best value in the game.
- If you write nothing, the coach writes one. Its worth depends on coach skill: from close to no plan at all, up to about half of a well-read plan. It never reads an opponent as well as you can.
- Watching adds the corner, worth a little more on top. A simulated fight takes your assistant's corner.
- Note the two sizes: coach-run *training* is slightly worse than yours; a coach-written *plan* is clearly worse. Training is routine, and the plan is the star.
- So on any night: your plan and your corner is best, your plan and the coach's corner is close, and the coach's plan is clearly worse but safe.
- Test: bots on each of the three, over many bouts, in close matchups.

**Rule 2: the right fight is not simply the one you will win.** Today +5 stats wins 72% and +10 wins 95%, so most opponents are near-certain one way or the other. If win chance were the only thing, the answer would always be the easiest legal opponent. So every offer pulls in four directions:
- **Rank:** beat someone above you and you take their place; beat someone below you and nothing moves. Corner King's rankings work this way with no points table, and it is simple to read.
- **Growth:** soft fights teach little, hard fights teach more, and losses teach most. A padded record leaves a fighter unready.
- **Money and crowd:** purses follow rank and ticket sales. A dull mismatch sells fewer tickets and may cost interest.
- **The unknown:** an unscouted opponent's level is a range, so "+5" may really be level.
- Fights are limited by a promoter's rule: you can ask only within a band of your rank, and a promoter refuses if you are not selling or have ducked fights. A refusal always says why.
- Test: a bot that always takes the easiest fight must do clearly worse than one that steps up at the right time. An amateur version runs over two game years at rank 4; the full five-year version runs once the pro ladder exists. If it fails, matchmaking has failed, as the coach tokens did in S390.

**Rule 3: a career ends by choice and decline, never by a timer.** Boxing Gym Story's forced retirement of your best boxer is its most hated rule. Age and damage slow a fighter and raise the risk, and the ledger gives a forecast. You and the fighter decide when to stop. Only a medical refusal at the far end can force it, with plenty of warning.

**Rule 4: the plan must be a puzzle, not a lookup.** If scouting shows a weakness and the plan simply answers it, a 30-point swing is free, and that is a solved choice.
- Scouting shows part of the picture, never all of it. Habits stay hidden until seen.
- A plan can only use what your fighter has drilled. Camp time is short, so you cannot answer everything, and a line built on a raw move works less well.
- Opponents adjust. A line that works early loses its edge if you lean on it, so the corner has something to do.
- Lines compete: staying long costs you inside, and pressing costs energy for later rounds.
- Test: a bot that only reads the scouting report and answers it must fall clearly short of a bot that also weighs drills, energy and adjustment. If it does not, the plan is a lookup, and rank 3 is not done.

### 5.3b New problems at each stage

Endless is not the same as fresh. Long saves in Pocket Stables go stale, and late games in Pound for Pound and Boxing School turn into clicking. Mobile Boxing Manager's champions run out of opponents. So each stage of a club asks a different question.

| Stage | The question | What makes it hard |
| --- | --- | --- |
| Years 1-2: survive | Can we pay the rent? | Dues and classes are the income, and one fighter's stipend already costs more than they bring. First fights, first loss |
| Years 3-5: step up | Who is ready to turn pro, and when? | Too soon wrecks a career. Pros cost more than they earn at first. Two camps collide |
| Years 6-10: hold on | Can we keep what we built? | Bigger gyms poach at contract time; kept promises are your defence. Mandatory defences. A risky payday against a safe build-up |
| Years 10+: rebuild | Who comes next? | Your star declines, and one should stop but will not. Former boxers become coaches. Rival gyms have caught up |

**Three more rules for the late game:**
- **Members stay the heart of the club.** 40 members at $35 is $1,400 a month, which a title purse dwarfs, so dues alone cannot carry the identity late on. So members also become the talent pipeline: spending on classes and a youth section raises the chance your next unknown comes from your own club. The best prospects cost nothing if you built the club that grew them.
- **Stars earn less for the gym as they grow.** They renegotiate, and the gym's share falls from 35%. Big fighters also want better staff and camps. Money stays tight for longer.
- **The ladder never empties.** Challengers are generated to keep every ranking full, weight changes are possible, and rival gyms keep developing talent.

These must be checked in 20-year runs: a strong club should still have bad years, and a champion should always have a credible next fight.

**How eight fighters get paid for.** Today one amateur on a $250 stipend already costs more than the opening income of about $590 a week, and eight would cost $2,000. So the stable cannot be eight stipends:
- **Most fighters cost little.** Real amateurs pay dues and train; a stipend is a special deal for one or two top prospects.
- **Pros pay their way, or do not.** They live on purses, the gym takes its share, and a pro who cannot sell tickets is a decision to make.
- **Income grows with the club.** Members, evening classes, sponsors and ticket cuts all rise with club standing.
- **The roster limit is partly money.** Places open with staff and upgrades, so a big stable has to be earned.
- These are shapes, not numbers. The balance must come from real club figures and be checked in the 20-year runs before any screen shows eight fighters.

**First sizes to try** (starting guesses, to be checked against real boxing before any number goes in, by our real-world rule): four divisions at first; about 20 ranked pros in each, with more below; four belt levels; fighters from about 18 to 38; new arrivals each year to match retirements.

### 5.4 The screen map

The main screens are shown side by side in `docs/STRUCTURE_MOCKUPS_S395.html`: the real game on the left, a marked mock-up on the right, and what is missing underneath. Playbook, History, Find a fighter, News and Championships are not mocked up: they change little.

**Rail: Home, Fighters, Fights, Club, World.** This is the agreed map: 5 rail buttons, 8 tabs, 5 fighter tabs. The top bar keeps date, cash and CONTINUE.

| Screen | What it holds | What the player decides | Changes from today |
| --- | --- | --- | --- |
| **Home** (no tabs) | Cork board of needs, next fight, rows of fighters with something due, since last Monday with causes, coming up | Answer pins, then CONTINUE | Stands as built in S394. Rows collapse for a big roster. Year review shows here |
| **Fighters > Roster** | One sortable table: age, record, rank, condition, weight, goal, next bout, coach or me | Who needs attention. Compare two. Set Coach runs it | Replaces Training, Fight camps and Scouting tabs |
| **Fighters > Find a fighter** | Prospects, walk-ins, scouts' notes | Who to interview | "Scouting" now means opponents only |
| **Fighter > Overview** | Stats, goal and promise, Road position, body panel, contract, habits known | Change the goal, renew, let go | Body, Attributes and Contract fold in |
| **Fighter > Week** | The whiteboard | Step in on a morning or evening, intensity | Hands-on layer of the stable |
| **Fighter > Fight prep** | Camp focus and cost, tape, checklist | Spend on camp. Choose what to study | One home for camp |
| **Fighter > Playbook** | Moves, combos, the plan on one page | Write the plan, build combos | Moves, Game plan, Combos, Escapes become one page |
| **Fighter > History** | Bouts, milestones, damage ledger | Read; decide when to stop | New in part |
| **Fights** (no tabs) | The Road, offers, ask for a fight, dated timeline, results | Who and when | Offers, Calendar and Results become one page |
| **Bout page** | Tale of the tape, money, band, unknowns, scout, accept or decline | Scout, yes or no | Scout moves before accept |
| **Club > People** | Staff, members, classes, youth section | Hire, fire, set classes | Adds firing a coach and the talent pipeline |
| **Club > Money** | Bills, income, deals, repairs, upgrades | Spend | Income, Bills and Deals fold in. Upgrades join today's repair list (section 9, question 2) |
| **Club > Records** | The record book | Read | Stands, and grows |
| **World > Rankings** | All divisions, amateur and pro | Read; click anyone | Adds pro ladders |
| **World > News** | News, with your fighters first | Read | Stands |
| **World > Championships** | Calendar of titles and entries | Enter | Nationals, Events fold in |
| **Fight night** (full screen) | Tape, rounds, corner, result, why | Full, highlights or sim. Corner choices | Adds a commentary line |

BJJ: same shell, same week, same Why. The athlete has a fighter page with the same tabs, and a mat page inside Playbook. No separate area. Boxers come first in the first hour.

**Navigation rules, added to the Miro rules from S370:**
- Every name anywhere is a link, and hover shows a small card. CK3 is praised for exactly this, and it is cheap.
- Lists sort, and two fighters compare side by side.
- One page layout everywhere: list on the left, detail on the right. Learned once, as in the Dominus study.
- No pop-up for a weekly job. FM26 is the warning.
- Space is CONTINUE, keys 1 to 5 are the rail.
- Hover explains every number.

**How 2 and 8 fighters both work:**

| | Roster of 2 | Roster of 8 |
| --- | --- | --- |
| Home rows | Both, full | Only fighters with something due; "5 others fine" |
| Pins shown | All | Top three, then "and 2 more" |
| Week | Hands-on | Coach runs most; you step into one or two camps |
| Since last Monday | Everything | Exceptions only, grouped by fighter |
| Fight nights | Each one played | Choose: the big one played, the rest simulated |
| Busy Monday budget | Under 3 minutes | Under 5 minutes, at most 5 decisions |

### 5.5 The first hour

Goal: the first fight at about minute 25 and the first Why screen by minute 35, one system at a time, in a real game that is already running. PLAYER_PATH's short-notice first bout is the key.

| Minute | Player does | Teaches | Should feel |
| --- | --- | --- | --- |
| 0-2 | Name, coach and start, or Quick start (proposal P12). One card with the goal and the clock: keep the doors open; a bout on the 14th if you can find a boxer | The goal | I know what I'm doing |
| 2-6 | The walk-in. Sign, agree a goal | People, promise | She is interesting |
| 6-10 | Hire a coach. Open the coach's draft week and change one thing; see the goal line move | The week | That moved something |
| 10-12 | Run the week. Monday page: whole points, each with a cause | The Monday stop | Quick |
| 12-16 | Short-notice offer, with scouting first. She is 1.4 kg over. Accept | Bout page, weight | A real risk |
| 16-22 | Fight prep: spend on camp. Playbook: two plan lines against this opponent | The plan | I have an idea |
| 22-25 | Weeks pass. Weigh-in on one screen | The scale | Close call |
| 25-33 | Fight, three short rounds, two corner breaks | The corner | I'm in this |
| 33-37 | Result and Why: what the plan did, what went against you, what to train next, one button | **The hook** | I made that happen |
| 37-45 | Second boxer's interview. First bill. The Road appears, with both boxers on it | Stable, money | There's a long way to go |
| 45-55 | First Ask for a fight. A named rival appears in a news line (the full rival gym comes later) | Matchmaking | I can steer this |
| 55-60 | The BJJ athlete asks to join. CONTINUE names the next date | The club grows | One more week |

**Teaching rules:** goal first, one line per verb, a short card the first time a system bites, nothing forced, and the guide can be skipped. A first loss must not end anything. Losses should teach more than wins, as proposed in the S390 notes.

### 5.6 What stays, changes, goes

**Stays:** Monday stop. CONTINUE. Home and the cork board. Five rail buttons. Signing as an interview. S354's three mechanics. Playbook. Corner, result, Why. Dues and members. Eight weeks below $0 closes the gym (code and the S327 ruling; the project page still says four). 3D never decides. Fight motion bar: nothing visibly broken. Light look now, skin last.

**Changes:**
- Career: ends near the debut, becomes open-ended (question 1).
- Booking: offers only, becomes offers plus asking.
- Scouting: after accept, moves to before accept.
- The week: the coach's week with your edits stays. New: Coach runs it or I run it per fighter, covering offers, camps and twists too.
- Roster: small, becomes 3 places rising to 8.
- BJJ: joins after the first fight instead of after week 1, and shares every system.
- Facilities: a repair list, gains upgrades with plain effects (question 2).
- Fight: gains a commentary line, because niche players love text drama and it carries the fight while motion is weak.
- Win chance: wide numbers become a band plus named unknowns.
- Ring position: Q-S294-110 said "later". The release plan's Gate 1 already needs it, so it moves up. I will say so when it is built.

**Goes:**
- 16 area tabs (24 become 8), and 3 fighter tabs (8 become 5).
- Search tab, once names are links.
- Mail as a separate place.
- Coach tokens and the Camp Board loop: failed its own test (question 5).
- Real-time week: rejected on our test and on Dominus's reviews.
- Any twist card whose result you cannot see.
- Pad view stays parked.

**Two Point alignment:** that rule was written for the gym floor. Since the floor is out of the first release, it stays parked. What carries over is general: layer systems in one at a time and state goals plainly.

### 5.7 Missing systems: proposals for the operator's approval

Everything here is **a proposal**. New mechanics, scope and money are the operator's call, and nothing below is decided until he says so. Each has a mock-up in `docs/STRUCTURE_MOCKUPS_S395.html`, where the left side is marked "not in the game" if it is new.

**Sizes** are rough guesses in working sessions: S is about 1, M is 2 to 4, L is 5 to 10. Rank means the row in the build order in section 8.

| # | System | Why a reviewer expects it | Size | Rank |
| --- | --- | --- | --- | --- |
| P1 | Matchmaking: ask, the Road, scout first | The manager's real job; WCBM2 is marked down for lacking it | M | 4 |
| P2 | Living world: age, retire, arrive | Long saves are what this audience buys | L | 7 |
| P3 | Pro ladder and belts | Pros have no fights today | M | 8 |
| P4 | Coach runs it, per fighter | Depth must be optional (FM, OOTP) | M | 9 |
| P5 | Staff roles | F1 Manager, Boxing Club Manager and World Boxing Manager all have them | M | 9 |
| P6 | Year review, goals, club tiers | A long game needs a shape | M | 11 |
| P7 | Record book and wall of honour | Named gap in Pound for Pound and Boxing World Simulator | S | 11 |
| P8 | Promises, contracts, poaching | Praised in Pound for Pound; winning must bring problems | M | 12 |
| P9 | Rival gym | World Boxing Manager reviewers ask for rival managers | M | 12 |
| P10 | Career clock and retirement talk | A career needs an honest end | S to M | 12 |
| P11 | Upgrades and youth section | Money must keep mattering | M | 13 |
| P12 | Choose your coach, choose your start | Cheap, and fixes the coach we are ashamed of | S, plus M of art | 5 and 14 |
| P13 | Commentary line | Text drama is loved in WMMA and Title Bout | S to M | 14 |
| P14 | Press card in fight week | Corner King and TEW have it; World Boxing Manager reviewers ask for it | S | 14 |
| P15 | Settings, Handbook, autosave | The first things a reviewer opens | S | 1 |
| P16 | Open data, then an editor | TEW, WMMA and Pro Wrestling Sim live on this | M | 16 |
| P17 | Fighters who fight differently | The top complaint about Corner King; it has one brain and no styles | M | 3 |

**What Corner King changes here.** It already has P1, P2, P3, P5, P7, P8, P9, P10, P11, P12, P13, P15 and part of P4 and P16. So these are the price of entry: reviewers will expect them, and they will not sell the game. P17, with the plan and Why work, is what sells it. Press (P14) moves to the bottom: Corner King's press scene looks like theatre, because its results do not appear to be saved.

**P1 Matchmaking.** *Decisions:* who to fight, when, whether to pay to scout, how high to ask. *Data:* rank, opponent's stats as a range, promoter's band, tickets. *Ties in:* a booked bout starts Fight prep; a result moves the Road. Rules are in 5.3a, rule 2.

**P2 Living world.** *Decisions:* none directly; it makes every other decision matter. *Data:* generated boxers with age, peak, decline, retirement; yearly arrivals; simple results for bouts you are not in. *Ties in:* feeds offers, rankings, news and the record book. Runs in the background and needs no screen of its own. **Two lessons from Corner King:** rival fighters must improve too, or the world weakens as its first generation retires; and detail should follow the player. It ranks everyone by closeness to you, a cheap way to make a big world feel personal. We keep one country and a smaller cast, and spend the effort there.

**P3 Pro ladder and belts.** *Decisions:* when to turn pro, whether to take a title shot, mandatory defences. *Data:* four belt levels, pro rankings per division, purses by level. *Ties in:* extends the Road and the existing pro offer and debut.

**P4 Coach runs it.** *Decisions:* per fighter, Coach or Me. *Data:* coach skill sets how close coach-run gets to hands-on. *Ties in:* covers offers, camp choices and twists, on top of the week the coach already writes. Rule 1 in 5.3a says what happens on fight night.

**P5 Staff roles.** Trainer fit is the idea to take from Corner King: which coach you pair with which fighter is a real choice, shown as a plain score. Four jobs, each changing one number you can see: assistant coach (quality of coach-run weeks), cutman (cuts in the corner), strength and nutrition (weight cuts, recovery), scout (better prospects and tighter ranges). *Decisions:* hire, fire, pay. *Ties in:* money, Find a fighter, the corner. Also fixes "no way to fire a coach".

**P6 Year review, goals, club tiers.** *Decisions:* pick three goals for next year. *Data:* the year's results, awards, ladder changes, club standing in named tiers, judged against your own size. *Ties in:* better tiers bring better prospects and offers. Shows on Home on the first Monday.

**P7 Record book.** *Decisions:* none; this is the pride screen. *Data:* every bout, title, record and rivalry, which Records already logs in part. *Ties in:* builds on today's filtered log.

**P8 Promises, contracts, poaching.** *Decisions:* at contract time: match it, promise something, or let them go. *Data:* the goal agreed at signing, loyalty, gym share, contract end date. *Ties in:* makes the signing goal real, which fixes "the ambition does nothing".

**P9 Rival gym.** *Decisions:* whether to take the rivalry on, and when: rematches, signings, who to protect. *Data:* a generated gym with a coach, a style, fighters and money; a shared history with you. *Ties in:* fights, poaching, news, the record book.

**P10 Career clock.** *Decisions:* fight on or stop, and whether a retired boxer joins as a coach. *Data:* the lifetime damage ledger, age, a fights-left forecast. *Ties in:* every hard fight costs something; rule 3 in 5.3a means no forced timer.

**P11 Upgrades and youth section.** *Decisions:* what to buy, and how much to spend on juniors. *Data:* a list of upgrades with prices and plain effects; the youth section raises the chance of a home-grown prospect. *Ties in:* gives money a job late on and keeps members at the heart of the club. No gym floor needed.

**P13 Commentary line.** *Decisions:* none, but it shows the plan working. *Data:* the settled exchanges, in plain words. *Ties in:* works with 3D, highlights or text-only. The game's fight word lists are a start.

**P14 Press card.** *Decisions:* one short choice in fight week: talk it up, stay humble, or get under her skin. *Data:* ticket sales, the opponent's mood, your fighter's temper. *Ties in:* money and the Why screen. Keep it small: it must change something visible, or it goes. Lowest priority of the seventeen.

**P15 Settings, Handbook, autosave.** *Decisions:* text size, window, when CONTINUE stops. *Data:* the same words as the hover text. *Ties in:* trust.

**P16 Open data, then an editor.** *Decisions:* for fans, not in play. *Data:* names, clubs, belts and starting worlds in plain files, kept that way from the start. There is no screen until late; the first version is just editable files. Corner King has an in-game editor but no mods, so open files would pass it.

**P17 Fighters who fight differently.** *Decisions:* who to sign, which plan suits whom, which style beats which. *Data:* rolled traits as numbers on one sheet feeding the fight (S392), style, habits, reach and height that matter. *Ties in:* signing, Playbook, the Why screen. *Test:* two fighters with equal stats and different styles must produce visibly different fights and different best plans. This is where Corner King is weakest and players say so.

### 5.8 P12 in detail: the coach at the start

**The problem.** The operator finds the coach ugly, and the corner films show why: he fills the frame in the game's best moment. Today the corner coach is one fixed staff body, and "the coach" you hire is a name on a list. The player has no face and no past.

**A character generator is not the answer.** I agree with the verdict already given. Bodies are finished MetaHumans with no morphing at run time, and MetaHuman is the only allowed source. A generator would be a large job for something reviewers do not score.

**How other games handle it** (read this session; small sample, details in the research notes):

| Game | What you pick | Changes play? |
| --- | --- | --- |
| Football Manager | Look, past level, badges, styles, traits; can be skipped | Yes: reputation, attributes, job level |
| Motorsport Manager | Name, look, one of five backstories | Backstory only, though sources disagree on the numbers |
| NBA 2K25 MyGM | Five backstories or custom | Yes: attributes and a starting perk |
| College Football 27 | Three coach backstories | Yes |
| Boxing Club Manager | Ex-fighter or suit | "Different boosts"; values not found |
| Out of the Park Baseball | Name, nationality, role | Only the role was shown to change play |
| Corner King | Full face creator, 7 specialisations, 6 personalities, 7 scenarios (from its files; the store page does not show this) | Yes: the manager is also a trainer. Reviewers do not mention the creator; two like the scenarios |

**Does it matter to a 9/10?** Hardly. No review we opened scored a game up or down for this. Boxing Club Manager has the choice at 57%. Corner King has a full creator at 90%, and in the top reviews nobody mentions it. It is a minor nicety for the score, so our cards need not match its creator. It is worth doing for two other reasons: it costs little, and it replaces a character the owner dislikes in the scene that sells the game.

**The proposal.**
- First step of a new career, under 30 seconds, and skippable. Quick start takes the first card.
- Type a name. Pick one of four coaches on picture cards.
- Each background gives one clear edge, small enough not to decide a career: Ex-pro (one extra corner call a fight), Amateur coach (better walk-ins), Strength coach (slightly better training), Old hand (cheaper camps, closer weight cuts). No option without a bonus: a Motorsport Manager guide calls that one "stupid".
- Pick a start: small club, in debt with one good boxer, or rich with big expectations. This doubles as difficulty, which reviewers praised in Motorsport Manager's team choice. Corner King players mention the same thing.
- **You are the head coach in the corner.** Luke Reid becomes your first assistant, which also fits P5.

**Size.** The step itself is S and can go into the first hour (rank 5), using whatever pictures we have. The four well-made corner bodies are M of art: new or reworked MetaHumans, rendered through the existing pipeline, at rank 14 with the fight view. The coach cards in the mock-up use boxers' faces as stand-ins, and they are labelled so.

### 5.9 Corner King: our closest live rival

Read from its installed files, in our own words. It is in Early Access, sells for about the same as we plan to, and is updated often, so this list will age.

**What it does better than us today**

| Area | What it has |
| --- | --- |
| The whole career exists | 9 weight classes, about 1,450 pros, 75 rival gyms, 15 organisations from regional to world, 25 ranks a class, title fights, mandatories, unification |
| Booking | Request a fight, a named opponent can refuse with a reason, negotiate purse and share, lead times, rematches |
| Training | Trainer fit: pairing coach and fighter is a real choice, with personality, specialty and overload |
| People | Relationships that change training, contract acceptance shown as a percentage, poaching with a counter-offer and a buyout |
| A big world feels near | Everyone is scored by closeness to you, and rivals drift towards your divisions |
| First hour | 7 starts as difficulty, 11 coach-led tasks with cash rewards, 7 first-use tutorials |
| Trust basics | Autosave choice, text scale 75-200%, 6 languages, Handbook, named saves, global search, back and forward, Simulate Days, editor |
| Colour | Two voiced commentators, 3D press scene, face creator, 56 email types, story banners |

**What we do better**

| Area | Us | Corner King |
| --- | --- | --- |
| Why you won | Real causes, replayed from the dice | Facts and money only: no screen says why |
| Authoring a plan | Playbook, combos, plan lines against this opponent | One pick per break, 3 shouts a round. It owns the punches |
| Fighters differ in the ring | Traits, habits, signature moves, styles | 8 numbers, one shared brain, no styles |
| Stakes | The gym can close | No failure state in the code |
| Mood matters on the night | Morale is read in the fight | Happiness never reaches the fight |
| A real club | Members, dues, evening classes, grassroots | Income from fighters, reputation and purses; amateurs are a scouting feed |
| Amateur road | Played: bouts, nationals, a career | Simulated around you |
| Speed | Monday stop, one click for a quiet week | Continue per day, or Simulate Days |
| Fewer places | 5 rail buttons, one home per job | 17 sections, most decisions buried in email |
| Numbers explained | Hover for every number | Odds shown, never explained |

**Where we must surpass it**
1. **Why.** Make it undeniable. Their fight is a real-time physics sim, so causes are hard to replay. Ours is built from exchanges, so we can report true causes. A copy of our panel would be hard for them, and this is our longest lead.
2. **The plan.** They could add a Why screen, but authoring a plan means a new fight game. Keep this at the centre.
3. **Styles.** Their top complaint is our P17. Two equal fighters must look and fight differently.
4. **A world that grows.** Their rival fighters appear never to train, so divisions should weaken over years. Ours must develop, on a smaller, closer cast.
5. **Stakes.** Keep the closing gym, and keep money tight for longer than they do.
6. **Clarity.** Beat their clutter: every decision on the screen it belongs to, none hidden in a mailbox.

**What not to chase:** their size, their own-promotion mode (the promoter's seat is crowded and it is a big job), voiced commentary, the face creator, a 14-column table for every fighter in the world.

**Ideas to take, as shapes only:** trainer fit; take-their-place rankings; refusals that give a reason, as their sponsor page does; closeness to the player; a Simulate Days that stops at the next pin, which also backs our quiet-Monday skip; acceptance shown as a percentage. Hidden traits that show themselves over time are also in their game, so our habits are not as fresh as S390 thought: the fresh part is wearing them down.

**A risk I must name.** If they fix styles and add a Why screen within a year, our lead narrows to the plan and the club. That is why the plan and strangers come first: Gate 1 now also answers "is this worth playing instead of Corner King?" Each tester should play both if the operator agrees.

## 6. Where I reject the seats' ideas

| Idea | Seat | Verdict | Why |
| --- | --- | --- | --- |
| Why panel is the thing to be remembered for | Both | **Yes** | Matches the niche's first complaint |
| Autosave and handbook before release | Both | **Yes** | Test 9 |
| Extend the career past a fixed cliff | Arena | **Yes, further** | Arena proposes 20-40 hours. Evidence supports no ending at all |
| Test a 6-fighter Monday on strangers | Grok | **Yes, later** | Cheap and exact, but it needs the stable built first. Taken into rank 9 |
| Collapse quiet fighters to summary rows | Grok | **Yes** | In the roster table |
| Career of 10-15 hours | Grok | **No** | Our audience logs hundreds of hours; repetition and running dry are the main low-score verdicts |
| BJJ shares one system or is cut | Arena | **Half** | Shared systems, yes. Cutting is the operator's call, already made (question 3) |
| Cut slots to 6-8, or to focus plus 4-6 sessions | Both | **No** | They were answering my stale fact. The coach already writes the week. The real problem is everything else that waits for you |
| A separate Fight Prep screen on the rail | Arena | **No** | Bible section 9: camp lives with the fighter. A second home is what the critics punished |
| Daily step of 1-4 minutes | Both | **No** | Daily picks are a solved chore (S390), and at 365 days a year that is hours of nothing |
| Week of 8-15 minutes | Both | **No** | 52 weeks makes 7 to 13 hours a year of planning. Reviewers punish slow seasons. Keep 1-2 quiet, 5 busy |
| First fight at 38 to 60 minutes | Both | **No** | Late payoff is a named fault (WCBM2). Aim for minute 25, with the Why by 35 |
| Drop 3D for 2D, or build 2D first | Arena | **No, but cap it** | 3D exists and is approved. Boxing Club Manager shows 3D cannot rescue a sim, so motion stays behind structure. The commentary line is the cheap protection |
| Cut narrative branches | Arena | **Half** | Scripted story, yes. Short choices that change something are what people retell |
| Build Monday stop, Home and week planner first | Both | **No** | Already built. Both built on the brief, not the code |
| Cut anything that fails past 3-4 fighters | Grok | **No** | Fix it for 8 instead |
| Roster screens filter, never add tabs | Arena | **Yes** | In the map |

## 7. Decisions challenged, in the open

| Approved | Challenge | Evidence | Status |
| --- | --- | --- | --- |
| Bible 8: small roster. Career length is open: the bible calls ending at first pro fights too short | Open-ended career, roster to 8 | Pattern 3, TEW, FCCD, the `Bouts.gd:115` wall | **His call**, question 1 |
| PLAYER_PATH 9 (proposed, not approved): 6-8 generated pro bouts, area title, sign the next unknown | Same | A fixed end is a wall with a date on it | Follows question 1 |
| Bible 8: facility building out | A list of upgrades, no gym floor | Money stops mattering in World Boxing Manager and WMMA; "look what we built" needs something to show | **His call**, question 2 |
| BJJ in the first release | Keep, with a rule | No reference game is praised for a second sport; Arena warns of two rulebooks | **His call**, question 3 |
| Time stops every Monday | Optional skip of quiet Mondays for a big stable | Reviewers punish slow seasons; Corner King's Simulate Days works this way | My call, small |
| Bible 3: "the proven audience is small", rivals thin | Rewrite with Corner King: a full, live gym manager at our price | Its files, section 5.9 | My call to rewrite; positioning is his, question 7 |
| Q-S294-110 ring position "later" | Move to Gate 1 | Release plan Gate 1c already requires it | My call, order of work |
| Blood & Canvas "needs a design pass" on the damage ledger | In, as a forecast and not a hard limit (rule 3) | Fills the "when does it end" hole without forced retirement | My call, inside question 1 |
| Release plan: work outside the current gate waits | World rules start in parallel once question 1 is yes | Pure rules need no screens, and they are the longest job | **His call**, inside question 1 |
| Release plan: Gate 3 polish before Gate 5 content | Pro ladder and stable (ranks 8-9) come before the skin | They change the screens the skin must fit. Store page stays right after Gate 1 | My call, order of work |

**Kept without challenge:** five rail buttons, Home and the cork board, the S354 mechanics, the 3D rule, the motion bar, the stranger test after plain screens, no art director, skin last.

## 8. Ranked build order

Ranked by what it does to the score and what it unlocks. Bible gates still apply: **Gate 1 comes before anything marked "after Gate 1"**.

| Rank | Job | Why here | Who | Done when |
| --- | --- | --- | --- | --- |
| 1 | **Truth pass (P15):** autosave, real Settings, Handbook v1, fix the camp double count, take the ambition line off the card until P8 makes it real, clear debug text and contradictions | Cheap, and they are the first things a reviewer sees | Claude | No "not built yet" anywhere; S391 list closed |
| 2 | **Screen cut** to 5 / 8 / 5, links on every name, sortable roster | Agreed, and already queued in S395 | Claude | Blind critic 8/10 beside a reference game (bible bar) |
| 3 | **Plan bites (P17):** plan spread, fighters who fight differently, ring position, hints off, Why screen, coach's plan (rule 1) | The game's reason to exist | Claude | 30+ points good against bad in close fights; rule 1 and rule 4 bots pass |
| 4 | **Matchmaking (P1):** scout first, Ask for a fight, the Road, take-their-place rankings and promoter band (rule 2) | The manager's real job | Claude | Rule 2's two-year amateur bots pass; a blind walkthrough finds it clear |
| 5 | **First hour** to section 5.5, with the coach step (P12) | Bible bar | Claude | Fight by minute 25, Why by 35 in a timed run; critic 8/10 |
| 6 | **Gate 1: five strangers** | The bible's stop rule | Operator finds them | 3 of 5 keep playing and can say why; 4 of 5 reach the first fight unaided |
| 7 | **World rules (P2)**, once question 1 is yes: generated boxers, ageing, retirement, pro ladder, belts, as pure modules with tests. They can start alongside ranks 1-6 | No screens or art, so seats can run it | Qwen, Arena, Goose | Rankings stay full and believable for 20 game years |
| 8 | Pro ladder live (P3): offers for pros, title bouts, defences | Removes the wall | Claude, after Gate 1 | A boxer can go from unknown to world level |
| 9 | Stable (P4, P5): Coach runs it, staff roles, roster to 8, Home collapse. Then Grok's test: strangers run one Monday with six fighters, timed | Tests 5 and 6 | Claude, after Gate 1 | Busy Monday under 5 minutes at 8 fighters |
| 10 | BJJ on shared systems: same week, camp and Why | Bible decision; depends on question 3 | Claude, after Gate 1 | No separate rulebook in the shell |
| 11 | Year (P6, P7): fixed dates, review, goals, club tiers, record book | Gives the long game a shape | Claude, after Gate 1 | A year review a player wants to read |
| 12 | People (P8, P9, P10): promises, habits, loyalty, poaching, rival gym, damage ledger | Test 2, the difference between 7 and 9 | Claude and seats | Testers retell a story unprompted |
| 13 | Money (P11): upgrades, youth section, pro purses, falling gym share | Money stays a real choice late | Claude and seats | Cash still matters in a 20-year run |
| 14 | Fight view (P12 art, P13): commentary line, coach bodies, sound takes, HUD. Press card (P14) only if time allows | Cheap protection against weak motion | Claude and seats | Motion bar met |
| 15 | Skin pass | Bible order | After structure | Blind 8/10 |
| 16 | Open data files, then an editor (P16) | Test 11, cheap if planned from the start | Late | A fan can rename the world |

P1 to P17 are proposals (section 5.7): they stay in this order only if he approves them.

**Effort, as a rough guess:** ranks 1 to 6 about 6 to 10 working sessions, ranks 7 to 13 about 30 to 45, plus polish. Corner King's daily step runs about 40 systems, so treat this as the low end. No calendar date is promised, in line with the release plan.

Store page (Gate 2) comes after Gate 1 and needs the new line tested on strangers.

**What this does to the S395 queue.** The HUD corner bug is a visible fault and stays. Portraits, the tired read, fight motion and Home leftovers wait behind ranks 1 to 5, which matches the release plan's "paused until they matter".

**Cheap tests for the four biggest risks:**
1. **The plan stays invisible.** Five strangers explain a fight in their own words. Run a good-against-bad plan probe before they play.
2. **Matchmaking is a solved choice.** Rule 2's bot test, before any screen is built. S390 is the warning: if thinking does not beat the plain option, the mechanic fails.
3. **The world feels like noise.** Run 20 game years with no player and read the record book. If a human cannot find one good story in it, the rules are not ready.
4. **The stable turns into clicking.** Grok's six-fighter Monday, timed; plus bots comparing coach-run and hands-on. Hands-on must clearly win, and must not be required.

## 9. Questions for the operator

Each one is yours. My recommendation comes first.

1. **Should the career be open-ended?** I recommend yes: a living pro ladder, ageing and retirement, and a save that never has to end. It replaces "ends near first pro fights" and the proposed 10-15 hour arc. It costs rules and data more than art, but it is the biggest job here: my rough guess is 30 to 45 more working sessions before Early Access. Corner King makes this a requirement, not a nicety: a game that stops at the pro debut would be compared with one that does not. A yes also lets the cloud helpers start the world rules before the stranger test, an exception to the rule that work outside the current gate waits. If the strangers fail, that work may be wasted. The alternative is a fixed arc to an area title, which I expect to score no higher than 6 to 7.
2. **May we have a plain list of gym upgrades?** I recommend yes. Bible section 8 rules out facility building. This would be a list with prices and plain effects, with no gym floor and no 3D, so money stays a real choice.
3. **BJJ rule.** Your S389 decision stands: BJJ stays. I recommend one rule on top: it shares every system with boxing, and if it is not at the same bar when Early Access is ready, it ships in the first update rather than holding the game back. Yes or no?
4. **Roster limit of 8?** I recommend yes, growing from 3 places. The bible says "small roster". Eight is the most I believe a person can follow as people.
5. **Close the Camp Board card?** I recommend closing the token loop, which failed its own test, and keeping habits you discover. Its board look lives on in Home.
6. **Keep the world in open files so fans can edit it later?** I recommend yes. It costs little if done now, and TEW and Pro Wrestling Sim players value it highly.
7. **Is the positioning right?** "Deeper than Corner King, not bigger": a real club, fighters who fight differently, your plan, and the reason you won. This is taste, and it shapes the store page.
8. **Which proposals in section 5.7 do you want?** I recommend all of them, in the build order. The ones I would drop first are the press card (P14) and the editor (P16).
9. **Choose your coach (P12).** I recommend four picture cards and a choice of start, not a generator. It adds about 1 session, plus art for four new corner bodies.
10. **Budget**, still open from the bible: what will you spend in total on capsule, trailer and lawyer?

## 10. Changes the docs will need once answered

Nothing has been edited. If the answers go as recommended: bible sections 2, 3, 5, 8 and 9; PLAYER_PATH sections 3, 6, 7 and 9; release plan section 1 (first-hour and career rows) and Gate 5 ("three full careers" needs a new meaning).

## 11. Sources

**Research files**, with every link for each game (kept outside the repo, in the shared notes folder for this session group): critics_top_games.md, niche_fight_sims.md, player_identity.md, steam_summary_2026-11-07.json, seat_brief_S395.txt.

**Seat chats:** Arena https://arena.ai/agent/01a1b4b7-1ae2-72aa-b935-52d3c21cd014 and Grok (Fast) https://grok.com/c/f1946060-517b-4e7f-ad25-aa1be3fc8033

**Steam store pages** (scores read 2026-11-07): [Corner King](https://store.steampowered.com/app/4259990), [Boxing Club Manager](https://store.steampowered.com/app/1652490), [WCBM2](https://store.steampowered.com/app/1903970), [World Boxing Manager](https://store.steampowered.com/app/563750), [Boxing School](https://store.steampowered.com/app/939990), [Boxing School 2](https://store.steampowered.com/app/2627410), [Boxing World Simulator](https://store.steampowered.com/app/4986600), [Pound for Pound](https://store.steampowered.com/app/4289560), [MMA Team Manager](https://store.steampowered.com/app/914180), [WMMA3](https://store.steampowered.com/app/344800), [Punch Club](https://store.steampowered.com/app/394310), [Punch Club 2](https://store.steampowered.com/app/1161590), [TEW 2013](https://store.steampowered.com/app/529700), [Pro Wrestling Sim](https://store.steampowered.com/app/1157700), [Believr](https://store.steampowered.com/app/4174130), [Dominus Gladiatus](https://store.steampowered.com/app/3572090), [Gladiator Manager](https://store.steampowered.com/app/1251970), [FM24](https://store.steampowered.com/app/2252570), [FM26](https://store.steampowered.com/app/3551340), [OOTP 26](https://store.steampowered.com/app/3116890), [Motorsport Manager](https://store.steampowered.com/app/415200), [F1 Manager 2024](https://store.steampowered.com/app/2591280), [CK3](https://store.steampowered.com/app/1158310), [Two Point Museum](https://store.steampowered.com/app/2185060), [Two Point Hospital](https://store.steampowered.com/app/535930), [Football Coach: College Dynasty](https://store.steampowered.com/app/2151290), [Hollywood Animal](https://store.steampowered.com/app/2680550).

**Critic aggregates and reviews:** [FM24 MC](https://www.metacritic.com/game/football-manager-2024/), [FM24 OC](https://opencritic.com/game/15780/football-manager-2024), [FM26 MC](https://www.metacritic.com/game/football-manager-26/), [FM26 OC](https://opencritic.com/game/19479/football-manager-26), [FM21 MC](https://www.metacritic.com/game/football-manager-2021/), [FM26 round-up](https://www.planetfootball.com/latest/football-manager-26-reviews-verdict-critics), [OOTP 15 MC](https://www.metacritic.com/game/out-of-the-park-baseball-15/), [OOTP 2007 MC](https://www.metacritic.com/game/out-of-the-park-baseball-2007/), [Motorsport Manager MC](https://www.metacritic.com/game/motorsport-manager/), [F1 2024 MC](https://www.metacritic.com/game/f1-manager-2024/), [CK3 MC](https://www.metacritic.com/game/crusader-kings-iii/), [Against the Storm MC](https://www.metacritic.com/game/against-the-storm/), [Two Point Museum MC](https://www.metacritic.com/game/two-point-museum/), [TEW 2020, Gaming Respawn](https://gamingrespawn.com/?p=48625), [Punch Club MC](https://www.metacritic.com/game/punch-club/), [WCBM2 OC outlets](https://opencritic.com/game/14235/world-championship-boxing-manager-2/reviews), [WCBM2 ClutchPoints](https://clutchpoints.com/gaming/world-championship-boxing-manager-2-review-down-for-the-10-count), [FCCD Operation Sports](https://www.operationsports.com/football-coach-college-dynasty-review/).

**Player reviews:** Steam community top-rated pages for each game above, for example [Corner King](https://steamcommunity.com/app/4259990/reviews/?browsefilter=toprated&l=english) and [WCBM2](https://steamcommunity.com/app/1903970/reviews/?browsefilter=toprated&l=english).

Patterns only. Nothing here copies another game's names, art or text.
