# The card game - pre-production plan (CARDPREPROD1, S540)

Owner S540: "i want strategic planning for later arts implementation and everything what a AAA studio does to prepare at
this stage". And: "it doesn have to be strickly cards, it can combine any genr that fable thinks has the best potential to
success"; then "why i think we did that already and i also made propositions". So this page does NOT study the genre again.
It gathers what his interview and the S537-S538 studies settled, places each of his proposals, and plans the build.

**Opened for this page (primary sources):** OWNER_CARDGAME_INTERVIEW_S537.md (whole), CARDGAME_PLAN_S539.md (whole),
DESIGN_CARDGAME_SCOPE.md (status blocks, 3T, bars 4d-4f, results 6d-6f, sections 7-8), TASK_CARDFIX6B.md, TASK_GRAPPLEMAP1.md,
JOHN_CARDGAME_MARKET_S538_JOHN.md (whole), JOHN_CARDGAMES_RESEARCH_JOHN.md, CARDREF1 (section 11), CARDREF2 (sections 1, 4, 5,
6, 8), docs/PICS2D1_RESULT.md, proto/cardgame (ui.js, career.mjs, cards.mjs, plan.mjs, engine.mjs export lists),
live_runs.json, prior_research.py "card game" and "deckbuilder". DOLA_CARDSET_IDEAS_DOLA.md holds only the brief and Dola's
menu text, no answer: nothing is taken from it. Numbers carry their source; my own are marked ESTIMATE.

---

## The two-minute page

**Where we are.** Six rounds in three days, about 160 card commits (CARDGAME_PLAN_S539), and you have not played one bout.
Round 6 is one code line with boxing + BJJ, a ladder and a training turn; its page does not open and four of its bars
fail. Two Arena jobs run now: CARDFIX6B (make the page play) and GRAPPLEMAP1 (BJJ pictures from the public-domain map).

**Why it did not reach you (section 1).** Not one defect: the method. Bots judged every round and you judged none; every
failing round got bigger (one art, then six, then seven, then a ladder) instead of smaller; your play waited behind a sheet
of balance bars that a search over about 110 numbers could not clear. That stops.

**What the game is (section 2).** A fast card fight between real martial arts that play differently, wrapped in a
fighter's career: climb a ladder, train between bouts, learn skills, win and defend a belt. Your interview and the two
studies already settled this; the evidence says keep it and add the career layer John found players praise most. It is a
card fight plus a small career manager, not a new genre.

**Your proposals, placed (section 2c).** Ladders and championships, learning skills, training decisions: in the first
slice. Animated cards and GrappleMap pictures: stills in the slice, short clips from the second milestone. Ghost battles
with other players: beta, free. The Expedition 33 reaction: tried once as an optional bonus on a guard at the three-art
build, never the core. Limb points: measured in round 4 and lost on every clause; the hurt-leg status stays, and the idea
gets its home in kickboxing.

**The arts, in order (section 4).** Boxing and BJJ now. Then wrestling, kickboxing, judo, karate, sambo, and MMA last as
the mode where a fighter mixes two arts. One art a step; each must play differently from every art already in, keep the
table balanced, and pass your play.

**Milestones (section 5), all ESTIMATES.** Play link this week. Vertical slice (2 arts, you play a whole ladder) in 1 to 2
weeks. First playable run (3 arts) about 3 weeks later. Alpha (4 launch arts) 6 to 8 weeks after that. Beta 6 weeks.
Early Access on Steam about 5 to 6 months from now, premium, no packs.

**What changes this week.** You play every build that opens and plays, even with balance bars still red. One new thing a
round. No new card round starts until you have signed this page.

**I need five answers (section 11):** play early builds? this art order? Early Access with four arts? may an art have a bad
matchup? try the timed reaction?

---

## 1. Diagnosis: why six rounds did not reach him

| # | What happened | Evidence | Kind |
|---|---|---|---|
| 1 | Nobody played. Every round was scored by bots; the owner got no link in six rounds | Scope rounds 1-5 were rule engines with a mock picture only; Arena's earlier playable page (CARDPROTO1-4) was scored by critics at 4-5 of 10 and replaced (CARDGAME_PLAN_S539 s1; scope top). Round 6's page cannot load: ui.js line 2 imports `actions` from engine.mjs, which does not export it (it is exported at plan.mjs:73). Round 6 itself wrote "Visual gate: not verified" (scope 6f) | method |
| 2 | Each failing round grew | R1-R2 boxing, three-beat exchange (FAIL) -> R3 new form, the rally (FAIL, 18 of 24) -> R4 six arts on a strip (FAIL, 5 of 7) -> R5 seven arts (FAIL, 4 of 7) -> R6 two arts + ladder + training (FAIL) | method |
| 3 | His play sat behind the whole bar sheet | Plan S539 s3: a round goes out "that passes the probe". No round has passed, so no link | method |
| 4 | The numbers came from a search, not a designer | Scope 6e: "about 110 numbers"; a Front kick costs 3 wind for 1 damage, the 5-point Shoulder throw costs 1; BJJ swings from 47 to 75 on one price. "A number that helps one pairing hurts the next" | method |
| 5 | Bars were measured on things not in the build | R6 P1 was measured on boxing v wrestling; wrestling is not in the slice (scope 6f). L2 used 4 hand-made states repeated to 10 (TASK_CARDFIX6B item 4) | method |
| 6 | One bot is the opponent and the ruler | Scope 6e: "one pilot is the measure and the opponent at once". Ladder: 100 of 100 titles because `rivalFighter` ignores the rung (career.mjs:54) | defect of method |
| 7 | No outside eye after round 3 | "No critic is queued: the brief asks for one only on a pass" (scope, R4 and R5 status). Earlier critics: 6/5/6 and 5/5/5 | method |
| 8 | Two code lines until S539, and no plan beyond the next round | Plan S539 s1; the owner's S540 question found no session had scoped the whole game | method |

Single defects (the broken import, the title awarded one rung late at ui.js:63 and career.mjs:87) are CARDFIX6B's job. The
table above is what repeats if only those are fixed.

**STOP doing:**
1. Stop bot-only rounds. A round with no build the owner can open is not a round.
2. Stop adding an art or a layer while the build under it fails or is unplayed.
3. Stop holding his play behind balance. Two gates from now on (section 7): a PLAY gate (it opens, it plays, it is fast)
   and a SHIP gate (the full bar sheet). He plays at the play gate.
4. Stop letting a search set prices. A search may suggest; every shipped number has a one-line reason a person can say.
5. Stop measuring on arts that are not in the build, and on made-up states.
6. Stop changing the form. The rally on the four-range strip with the wind pool is the form (three rounds have kept it).
7. Stop waiting for a pass to ask a critic. One free critic reads every round's build; the 8/8 bar still decides what stays.

Under CLAUDE.md rule 8 this page is the scoped plan for the area: until he signs it, no new card round is briefed beyond
the two already running.

## 2. Vision

### 2a. What is already settled (his answers and the studies; not reopened)
| Question | Settled answer | Source |
|---|---|---|
| How a bout feels | "Fast and punchy": quick turns, a bout under about 5 minutes | interview S537 |
| Help on screen | "Show me everything": every result previewed; the skill is the choice, never the sum | interview S537 |
| Where it lives | "its standalone prototype": its own game; a crossover with the gym game is marketing, not a system | interview S537; plan S539 s5 |
| Which arts | Boxing, BJJ, wrestling, judo, karate, sambo, kickboxing; MMA as the meeting ground | interview S537 + S538 |
| What makes an art feel different | One own mechanic on a shared core; the position gates the cards; an own way to win | CARDREF2 s1 "the pattern" (Kungfu Card, MMA Arena, Mixed Martial Cards read from files) |
| The form of a turn | He throws face up, you answer with one guard and throw back; four ranges KICK - PUNCH - CLINCH - GROUND; one wind pool; three ways to win (knockout, points lead, hold) | scope 2b, 3S, 3T; nearest references also answer a card you can see (CARDREF1 s11) |
| Length | 24.7 decisions = 3.3 minutes by the bots | scope 6e, D1 |
| What the genre lacks | No combat-sport card game has broken out (about 60 found); the three closest launched in the last six weeks | John S538 s1 |
| What players praise around the fight | A climb they can see with floors; a few training choices with a visible cost; rivals who return | John S538 s2, s3, s5 |
| What they punish | Paid random packs, paid add-ons during Early Access, stat decay, animations they cannot skip, forced timing | John S538 s1, s3, s4; CARDREF2 s4 |
| How it earns | Premium on Steam, no packs; free web demo; expansions later | plan S539 s5, his "ok" |
| Who writes it | Arena codes, Dola and Kalli critique, Ludo makes art, Claude coordinates | owner S539 |

### 2b. Should it combine with another genre? Keep the core, add one layer
**Recommendation: keep the card fight as the core and build the career around it as a small manager game. Add nothing else
to the core.** Reasons, all from evidence already in the repo:
- **The career layer is where the open ground is.** John's top gaps (s5, items 1, 3, 4, 5) are all career: a visible ladder
  with floors and title defences, a training turn with a visible cost, rivals with a readable "Edge", skills learned along
  belt paths. The games with it and a fight (Punch to Glory 92% of 40, Submission Saga 100% of 39, MMA Arena's leagues) are
  praised for the loop and are all small: nobody has done it well at size. It is also the owner's S538 ask word for word.
- **It is what this studio already knows.** The gym game's ladder, training and rival rules exist as tested modules; the
  card game takes the ideas and the real-sport numbers, not the code.
- **The Expedition 33 reaction is a seasoning, not the meal.** For: boxing defence is timing; "a parry gives wind" is
  counter-punching in one rule; it keeps a bout loud. Against: it breaks "Show me everything" (reflexes decide), reviewers
  call forced timing a "mandatory distraction" (PC Gamer on E33, GameSpot on WrestleQuest), it cannot run in ghost battles,
  grappling is position not reflex, and it is the largest animation bill (every move needs a readable wind-up). John's
  verdict, which I keep: an OPTIONAL timed bonus on the guard you already picked; the card works if you miss; automatic
  setting; off against ghosts; never on the ground. Tried once at milestone 2, kept only if he likes it in his hands.
- **Not taken:** a grid or movement board (Fights in Tight Spaces: the strip already is our board, in one line); hidden
  simultaneous picks as the core (Yomi: he chose shown cards); a roguelike run where one loss ends everything (Clutchtime's
  praised season lets you lose a game and still qualify; a fighter's career has losses on the record).

So the genre in one phrase: **a card fight with a fighter's career** (card battler + light sports manager).

### 2c. His proposals, each placed
| His proposal | Where it goes | Gate | Why there |
|---|---|---|---|
| Ladders and championships | M1 slice: Club - Area - National - Title shot - defences, rank number, floors. M3: a belt per art and a second ladder per weight. M4: seasons with a partial reset | L1: 30 to 70 titles in 100 bot runs; his play | Top of John's list; round 6 already has the rungs (career.mjs:5) |
| Fighters learning skills | M1: training adds or upgrades a card. M3: belt paths; learning a second art opens MMA | L2 measured on real ladder states; a new card must be best in 1+ and at most 6 of 10 states | John s5 items 3 and 5; MMA as a reward, not a menu |
| Training decisions between bouts | M1: one pick of four, energy cost and failure % printed, no decay. M2: a fight date to train toward, rest as a real choice, "pick 2 camp stops" before a title | His play: he can say what he gave up | John s3: one pick, one visible cost, a date; the hated design takes away what you built |
| Action points per limb | Not the resource. Kept: the hurt leg as a status. M3: re-tried inside kickboxing only (a leg kick dims a leg; a dimmed leg cannot kick or step that turn) | Kickboxing's P6 and the cheap-deck bar R-C8; his overrule after he has played stands open | Round 4 measured it first: skill edge 65.2 with wind v 54.1 with limbs, cheap decks 18/24/20 v 61/67/35 (scope 6d): a limb is free every turn, so cheap decks never run short. As one art's own rule it cannot open that door |
| Asynchronous "ghost" battles | M2: a deck + fighter saves as a short code two people can swap (no server). M4: ghost ladder through Steam leaderboards, free | P10 (the pilot plays any deck within 5 points of the hand-written one); a tamper check: the bout is replayed from its seed | Needs a pilot that flies every art and a full roster to be worth it; both exist by beta. The pilot and the 15-card deck file exist already (scope 8) |
| Expedition 33 reactions | M2: one greybox toggle on guards, standing only | His play of 3 bouts with it on and 3 off; no loss of bout speed (D1) | 2b above |
| Animated cards, short move clips | M1: a picture of both bodies on every card. M2: 0.6 to 1.0 s strips when a card lands. M3: 2 to 3 s only for the moment that changes the bout; speed setting. M4: end-of-bout replay | A bout still under 5 minutes with animations on; an off switch | CARDREF2 s4: long animations get skipped; a clip on every card at 2.5 s adds about 90 s a bout; "never a blocker for the rules" (owner) |
| GrappleMap for grappling positions | M1: BJJ card pictures and the position strip (GRAPPLEMAP1, running). M2 wrestling, M3 judo, post-launch sambo | Every card has a picture with two whole figures in frame | Public domain; 601 positions and 1,485 moves; already played on our bodies in the gym game (CARDREF2 s5) |

### 2d. Pitch, pillars, player
**One line:** Pick a martial art, fight fast card bouts where every art plays by its own real rules, and take one fighter
from the club to the belt.

**Pillars** (every feature is checked against them; a feature that serves none is cut):
1. **Fast and punchy.** A bout in 3 to 5 minutes, a turn in seconds, nothing to wait for.
2. **Everything shown.** No hidden sums. You lose to your choice, never to arithmetic or a secret roll.
3. **Seven arts, seven games.** An art is one own rule taken from the real sport, not a colour on the same cards.
4. **A career you can see.** A rung, a rank, a belt, a rival, a skill learned: something moves after every bout.

**Target player:** plays Slay the Spire-style card games or sports managers on PC, 25 to 45, follows or trains a combat
sport, wants a 20-minute session. Second ring: card players with no fight interest, won by pillars 1 and 2 (ESTIMATE; no
audience data in the repo beyond John's review counts).

**Comparable games** (what we take and avoid, in our own words; nothing copied):
| Game | Take | Avoid |
|---|---|---|
| Mixed Martial Cards (demo; his list) | Answer a card you can see; several ways to win; sound carries the hit with no move animation | 20-minute matches; a hidden mode on each attack |
| MMA Arena (his list) | Leagues up to a belt; training unlocks moves | Arts as labels on one rule; 2.5 s clips on every move; grind |
| Kungfu Card (his list) | A style is one small rules twist on a shared core | In-app purchases |
| Clutchtime (his list) | A season you can lose a game in and still make | "Harder" meaning fewer cards |
| Monster Train, Hearthstone (his list) | Full previews; rungs that each add one rule; floors on the ladder | Ladder fatigue, a few best decks |
| Rune Coliseum (his list) | Train, fight, retire, legacy; rivals | Predictions that lie |
| Fights in Tight Spaces (92% of 2,471) | A short full-body move per card and a replay at the end | - |
| Yomi 2 (92% of 105) | Every option has a counter with uneven rewards | Paid add-ons during Early Access |
| Punch to Glory, Submission Saga | Cards from training; belts as ranks people already know; authenticity praised | Too few fights; thin explanations |
| Cagebound, Underdog, Neon Knucklez (all new) | Title defences after the title; a corner between rounds; a ghost-deck board | They show the space is filling: speed and one hook beat breadth |

**What makes it ours:** real martial arts whose real scoring already writes fast endings (karate and sambo end on an
8-point lead, wrestling on 10, judo on one perfect throw: CARDREF2 s1), each measured to play differently (P6); real
positions drawn from a public-domain map; and the gym game's world and research behind it.

## 3. The loops

**Core loop (one turn, about 8 seconds a decision):** see his volley face up -> pick one answer -> lay your own cards from
5 in hand with 3 to 6 wind -> the table shows what each will do before you commit -> range and position change -> his turn.
A bout is two rounds of five turns and ends early on a knockout, a points lead or a hold.

**Meta loop (one rung, about 5 minutes):** read the next opponent (his art, his Edge) -> one training pick with a printed
cost -> the bout -> the rung, rank and record move -> a new card or an upgrade.

**Long-term loop (one career, 20 to 40 minutes; then again):** climb to the title shot -> win the belt -> defend it, each
defence adding one rule -> retire the fighter into the hall with his record -> a new fighter in another art, later a
second art for the same fighter and the MMA ladder -> (beta) your champions fight other players' as ghosts.

**The first 10 minutes (the onboarding spec for M1):**
| Minute | What the player does | What he learns |
|---|---|---|
| 0:00 | Picks one of two fighters: a boxer, a BJJ man. Two lines each: where he wins, his one rule | An art is a way to play |
| 0:30 | First bout, club level, against the other art. His first volley is one card; the table says what each answer does | Answer what you see |
| 2:00 | He is taken down (or takes down). The strip shows GROUND; half his hand greys out | The position gates the cards |
| 3:30 | The bout ends early on a knockout or a tap. One line says why | Three ways to win |
| 4:00 | Result: rung, rank number, record. The next opponent is shown with one Edge | The climb |
| 4:30 | Training: four options, each with its cost and its failure chance. He picks one; a card joins his deck | Skills are cards |
| 5:00 | Second bout with the new card in hand | The loop closes |
| 9:00 | He stands at Area level, or lost once and saw that a loss drops one rung and never below the floor | Losing is part of a career |

## 4. The art-by-art roadmap

### 4a. The order, and why
| # | Art | Kind | Why this place |
|---|---|---|---|
| 1 | Boxing | striker | In. The house art; 180 baked clips and the 2D picture method exist |
| 2 | BJJ | ground | In. Round 5's most distinct art (mechanic changes 95.8% of turns; blind judge 99.7%), picked over judo in round 6 |
| 3 | **Wrestling** | takedown, top | Closes the real triangle: the striker wins standing, the wrestler decides where the bout is, the submission man wins from underneath (CARDREF2 s1). Its two pairings were already inside the band in round 5 (v boxing 56.5, v BJJ 47.5). Pictures ready today: GrappleMap has 21 single-leg and 20 double-leg takes |
| 4 | **Kickboxing** | striker | The first kicks and knees: the biggest visible change, and his own S538 ask. Placed after wrestling because it broke round 5's table (64.8 v BJJ, 38.5 v sambo): it needs an answer to the ground, which is cheaper to design against two grapplers than five. Home of the limb idea |
| 5 | **Judo** | clinch, throws | Unmistakable in round 5 (99.2%). After wrestling, because the judge took the wrestler for a judo man (80.7): wrestling must own "takedown then top" first, judo then owns the grip and the one perfect throw. About 37 no-jacket throws in GrappleMap |
| 6 | **Karate** | striker, long range | In-and-out point fighting, the 8-point lead. After kickboxing, because it must prove it is not kickboxing (both kick from PUNCH range). Weakest in owned pictures: no karate punches, stances or blocks |
| 7 | **Sambo** | hybrid | Last single art: its rule (punch, throw, lock in one volley) borrows from three others, so it can only be judged against all of them; nothing of its own on disk; the current sport rule book could not be opened (CARDREF2 s8) |
| 8 | **MMA** | the meeting ground | Not an eighth deck: a rule set and a ladder where a fighter who has learned two arts mixes them (12 cards from two arts). Needs 4+ arts to mean anything; it is the long-term reward |

Launch (Early Access) = arts 1 to 4 and the MMA ladder in its first form. Judo and karate arrive as free updates during
Early Access, sambo at 1.0 (question 3 in section 11). This follows John's finding that paid add-ons in Early Access are
punished and the plan's "speed and one clear hook beat breadth".

### 4b. Each art's sheet
Mechanic and signature cards are round 5's as measured (scope 3T); they are the starting point, re-sized by hand when the
art joins. "Rounds" = Arena rounds of about a day each, ESTIMATE from six rounds in three days, including one fix round.

| Art | Its own rule | Signature cards | Wins by | Real-world source | Pictures needed | Rounds |
|---|---|---|---|---|---|---|
| Boxing | Combinations: a punch behind a punch costs 1 less; the jab steps in; short punches work in the clinch | Jab, Cross, Lead hook, Uppercut (cannot be blocked), Slip | Knockout, cards | Unified rules (10-point must); our own boxing research | About 40 to 50 pair pictures for a full set, 1.5 to 2 days (PICS2D1); 14 made | in |
| BJJ | The guard: pull guard from standing; holds and sweeps work from underneath | Triangle, Armbar, Sweep, Guard pass, Rear choke | The tap; pass points | IBJJF rule book v6.0 (our BeltRoad.gd); GrappleMap positions | GrappleMap: every card (GRAPPLEMAP1) + the position strip | in |
| Wrestling | Chain wrestling: the shot travels from any range; a stuffed shot makes the next unstoppable; the ride keeps him down | Single leg, Double leg, Body lock slam, The fall, Front headlock | Pin points, a 10-point lead, ground strikes | UWW rules Jan 2026 (takedown 2, big throw 4-5, 10-point lead) | GrappleMap takedowns, rides, stand-ups: ready. One paired Mixamo double leg as the hero clip | 3 |
| Kickboxing | Hands and feet: a strike of another kind than the last costs 1 less and carries him to its range | Low kick (hurts the leg), Body kick, High kick, Knee, Check | Knockout, leg damage, cards | A rule set to pick and read (K-1 style or Glory: no takedowns, limited clinch) - NOT YET READ, John's brief | About 18 usable Mixamo kicks + 12 knees and elbows on disk, one retarget pass first | 4 |
| Judo | The grip: no throw without it; a grip that stands a turn makes the throw unstoppable | Grip, Hip throw, Shoulder throw (the ippon), Hold-down, Armlock | One perfect throw; hold-down points | IJF 2025 rules (ippon, waza-ari, yuko; 20 s hold); our G131 (about 10% of attacks score) | GrappleMap's 37 throws (no jacket) + the paired Mixamo shoulder throw. A jacket look is a Ludo ask | 4 |
| Karate | In-and-out: blitz in from kick range and back out; a grip does not hold him | Reverse punch, Roundhouse, Head kick (3 points), Step off | An 8-point lead; first score breaks a tie | WKF kumite rules 2024 (1 / 2 / 3 points, 8-point lead, senshu) | Kicks shared with kickboxing; karate punches, stances and blocks do not exist on disk: Ludo or a small Mixamo set | 4 |
| Sambo | Punch, throw, lock: a throw behind his own punch cannot be stopped; a lock may follow in the same volley; leg locks from anywhere | Overhand, Sambo throw, Knee bar, Ankle lock, Catch the kick | Total victory throw, an 8-point lead, leg locks | FIAS combat rules 2022 (read); sport rules from secondary pages only - to confirm | GrappleMap throws + thin leg locks (knee bar 2, toehold 1) | 5 |
| MMA | Two arts in one deck; cage and referee rules (stand-ups, rounds start standing) | No new cards: the mix is the content | Any | Unified Rules of MMA; the real triangle numbers (CARDREF2 s1) | Nothing new | 5 |

### 4c. The gate every art passes to join (in this order; a failure at any step stops the art, not the game)
1. **Paper:** a one-page sheet (the row above, the real rule set read and cited, 12 cards with a one-line reason for each
   price) reviewed by one free critic who knows the sport question: "is this how the sport is won?"
2. **Greybox probe on the bots:** P6 "plays differently" against ALL arts already in (mechanic switched off changes over
   50% of its turns; the blind judge names it from ten turns 90%+, read with each action at the range it is laid and a
   kick as its own kind - the reading round 5 showed was the honest one, fixed here before any run). P4 balance (4d).
   P10 the pilot flies it. D1 a bout stays under 5 minutes.
3. **The build:** it is in the page with a picture on every card and a first-bout lesson for its one rule.
4. **The beginner:** a new player with the art's lesson wins 25 to 40% against the pilot (round 5's R-C11 failed at 20.5%
   because each art's rule was never taught).
5. **His play:** three bouts with the art and three against it. He can say in a sentence how it plays differently.
6. **Two critics, 8+ on depth and 8+ on play** (one code-checked), each ending with its list to reach 10 and its drawing.
   Under 8 goes to him as "cut it or keep it".

### 4d. The matchup matrix: how balance is kept as arts join
The table grows fast: 2 arts = 1 pairing, 3 = 3, 4 = 6, 5 = 10, 6 = 15, 7 = 21. Round 5 showed what happens when all 21
are tuned at once. The rules from now on:
1. **Arts already in are frozen.** When an art joins, only its own cards, and "pair cards" (rule 2), may change. A cell
   between two older arts that moves more than 3 points fails the round (ESTIMATE of noise at 400 bouts a pairing; the
   harness prints its own spread and the number is set from that before the first run).
2. **Fix a pairing with a card, never with a pass over all numbers** (round 5's own conclusion: "the table needs
   pair-specific cards"). Every art carries one answer for its weak place (the boxer's Get up, the kickboxer's answer to a
   caught leg), and at most 2 of its 12 cards may be written against one named opponent.
3. **The band:** every pairing inside 40 to 60. With three or more arts, every art's average inside 47 to 53. With two
   arts the average IS the one pairing, so the slice's ship gate is 47 to 53 (round 6: 56.5 / 43.5, fails).
4. **One matrix file in the repo** (probe output, each cell with its bout count and seed), re-run by the test job on every
   pull request that touches a card. A change in it is visible in the diff.
5. **Bots first, people second.** The bot table is a tripwire, not the truth. From M2 the build logs each bout's arts and
   winner locally; from beta, the human table is read beside the bot table and wins any disagreement.
6. **The player's own answer.** A bad matchup inside the band is a reason to train: the cross-training card (M3) is how a
   boxer buys his answer to the wrestler. Whether arts may have bad matchups at all is his call (question 4).

## 5. Milestones (dates are ESTIMATES; a "round" is about a day of Arena work plus Claude's check)

| Milestone | In | Out | Definition of done | ESTIMATE |
|---|---|---|---|---|
| **M0 Play link** | Round 6b: the page opens, a whole bout and a ladder step play; title at the title shot; rivals harder by rung | Everything else | Claude plays a bout through the page by script; the link is in his hands; he plays 10 minutes and says what he felt | This week (CARDFIX6B running) |
| **M1 Vertical slice** | Boxing + BJJ; ladder with floors and 3 defences; training pick; a picture on every card; position strip; the 10-minute onboarding; first sounds; the restyle look; play log | Other arts, ghosts, timing, move clips | He plays one whole career (20 to 40 min) and calls a bout fast and punchy; SHIP gate passes on the slice; two critics 8/8; he answers "would you play another career?" | 4 to 6 rounds, 1 to 2 weeks |
| **M2 First playable run** | + wrestling; rivals who return with a visible Edge; a corner pick between rounds; a fight date to train toward; saves; 0.6 to 1.0 s strips; deck code to swap with a friend; the timed-guard trial; desktop wrapper spike | Kickboxing on, belts per art, online | He plays three careers across a week, unprompted for the third; 3-art matrix in band; nothing from M1 regressed | about 3 weeks after M1 |
| **M3 Alpha (all launch arts)** | + kickboxing; MMA ladder and learning a second art; belts; difficulty rungs after the title; hero clips; all screens exist; code moves to a private repo; Steam page up; free web demo (2 arts) on itch | Judo, karate, sambo; ghost ladder | Every launch feature is in and playable start to finish with no dead end; 6-pairing matrix in band; 5 outside players finish a career without help | 6 to 8 weeks after M2 |
| **M4 Beta** | Content locked; ghost ladder; daily fight card; settings, speed, colour-blind check, controller; replay; full sound; Steam demo in a Next Fest | New mechanics | 20 outside players; no crash in 200 logged careers; median first session over 20 minutes (ESTIMATE of a healthy number, to set from the first 5 players); he signs the store page | about 6 weeks after M3 |
| **M5 Early Access** | Steam, premium, 4 arts + MMA | Paid add-ons | One full ladder at 8/10 by his play and the critics (plan S539); the launch checklist in section 9 done | about 5 to 6 months from today |
| After | Judo, karate (free updates), sambo and 1.0; then paid expansions, mobile | | Each art through gate 4c | one art about every 4 to 6 weeks |

**What each milestone needs from each seat:**
| Seat | M1 | M2 | M3 | M4 |
|---|---|---|---|---|
| Arena (code) | Slice fixes, data format, play log, pictures wired | Wrestling, rivals, saves, strips | Kickboxing, MMA, belts, wrapper | Ghosts, settings, replay |
| Arena, fresh chat (code check) | Every round | Every round | Every round | Every round |
| Dola (design, critic) | First-10-minutes script; critic | Rival Edges; critic | MMA mixing rules; critic | Store text review |
| Kalli (numbers, critic) | Hand-sizing the 2 decks with reasons | Wrestling sheet; training costs | Kickboxing sheet; ladder numbers | Daily card rules |
| John (research) | Kickboxing rule set; comp prices | Next Fest and wishlist numbers for small card games | Judo / karate sources check; sport sambo rules | Launch timing |
| Ludo (art, sound) | Card frame, icons, table look, 10 sounds | Fighter portraits, rival faces | Key art, logo, capsule, music | Trailer pieces |
| Maria (art review) | Stills of the slice | Each new screen | Store page | Trailer |
| Claude | Briefs, checks, the link, his notes | + PC renders (strips) | + private repo, Steam setup | + demo build |
| Owner | Plays weekly; 5 answers | Plays; timing verdict | Plays; name and price | Signs the page |

## 6. Pipelines

**Rules.** One engine (proto/cardgame/engine.mjs), one pilot (plan.mjs), one bar sheet (section 7), one harness
(probe.mjs) with two commands: `probe.mjs gate=play` and `gate=ship`. Every round is a tag `card-r<N>`. The engine is
seeded: the same seed and the same picks give the same bout (needed for replays, ghosts and the tamper check).

**Content.** Cards move out of code into data: one file per art, each card a row (id, art, kind, wind, where it may be
played, what it does as numbers, picture id, sound id, the one-line reason for its price). The card's text on screen is
written by the game from those numbers, so the words can never disagree with the rules. **Adding an art is a checklist,
not a design session:** (1) the art sheet (4b) with its sources, (2) its data file of 12 cards, (3) its one rule as one
small module with an off switch (P6 needs it), (4) a hand-written pilot script (P10 needs it), (5) its tests, (6) its
pictures, (7) its lesson bout, (8) its row and column in the matrix, (9) the gate in 4c, (10) the board row closed.

**Art.**
| What | Route | State |
|---|---|---|
| Grappling card pictures (BJJ, wrestling, judo, sambo) | GrappleMap position or move -> two figures, red and blue, side view. Prototype: flat 2D drawings (GRAPPLEMAP1). Product: the same poses on our own bodies with the toon look (tools/grapple_pose_sheet.gd, move_pic_bjj.gd; 44 pictures exist) | running; tools exist |
| Striking card pictures (boxing, then kicks) | The 2D picture method: both bodies frozen at the contact frame, fixed side camera, transparent (PICS2D1: 14 pairs in 25 minutes; the full boxing set is PICS2D2, which he approved as "Keep, build the full set") | boxing proven; kicks need one retarget pass |
| Card lands (0.6 to 1.0 s) | The sprite baker (tools/bake_hub_sprites.gd; 304 strips exist): 12 to 16 frames a card | proven for the gym menu |
| Hero moments (2 to 3 s) | Paired clips we hold: Mixamo double leg and shoulder throw; knockdowns | on disk, not retargeted |
| Card frames, icons, table, portraits, logo, key art | Ludo, after the rules settle (plan S539), reviewed by Maria | not started |
PC renders (Claude, hidden desktop, watchdog green) are the only work on his machine; never while he plays.
One rule from the 2D test: a picture's range is set by the picture tool, not by the 3D fight (PICS2D1), which is fine here.

**UI and feel.** One table screen at 1920x1080 and one phone layout from the start. The look follows the restyle style
sheet Dola wrote for the gym game (Q-309, his pick pending): the card game takes his pick, not a second look. House rules
carry over: tooltips explain and never repeat the label; only what he can act on is on screen; bars move when they change.
Every animation has a speed setting and an off switch.

**Audio.** Sound does half the work (Mixed Martial Cards ships 2,540 voice clips and no move animation). M1 reuses our 27
fight sounds; then Ludo by art (mat, throw, tap, kick). Qwen holds the sound seat; a sound is "unheard" until he hears it.

**Saves.** A career is one small versioned file (fighter, deck as card ids, rung, record, seed). Browser storage in the
prototype; Steam Cloud at M4. Every save carries the rules version; an old save opens or says plainly why not.

**Platform and tech. Recommendation: the browser build IS the product, shipped on Steam inside a desktop wrapper; no
Godot port.** Why: (1) one engine: the rules that are measured are the rules that ship, and the probe harness shares the
code; a port to Godot would be a second engine to keep equal; (2) the free seats write and test it today with no PC cost;
(3) the weekly play link, the itch demo and the Steam build are the same build; (4) a later phone version is the same
page; (5) the game is cards, pictures and short strips: nothing needs a 3D engine at run time (the 3D is used on the PC to
bake pictures). What must be proven first, in a one-day spike at M2 (ESTIMATE): the wrapper with Steam's overlay,
achievements, cloud saves and leaderboards. If the spike fails, the fallback is Godot for the shell with the same rules
engine kept in one place. I have not verified wrapper support this session; the spike is the check.

## 7. QA and balance

**The bar sheet, in two gates** (bars are those of scope 4d-4f, not loosened; only the order of his play changes):
| Gate | Bars | Who may see the build |
|---|---|---|
| **PLAY** | The page's module graph links (a test fails on a broken import); a scripted player finishes a bout and a ladder step through the page's own calls; printed numbers equal the engine's; D1 (22.5 to 45 decisions, 95% under 52); every pairing inside 40 to 60; no crash in 1,000 bot bouts | The owner, every week |
| **SHIP** | PLAY, plus P2 (each way to win ends 15%+; a pilot blind to any one loses 5+), P4 averages 47 to 53, P5 (the hold is a readable race), P6 (each art plays differently), P10, L1 (30 to 70 titles in 100), L2, the beginner at 25 to 40% | Critics; the next art; outside players |

**Regression.** `node --test` on every pull request (CI on the mirror); the matrix file (4d rule 4); a count of tests that may
only grow (Arena has deleted tests to go green: ci_arena.py guard); the page smoke test; from M2 a saved-career test (an
old save still opens).

**The code-checked critic.** A second, fresh Arena chat reads each round's diff against the brief and the bar table against
the raw probe output (round 3's check found 6 bugs in Arena's own rules; round 6's said DO NOT MERGE AS IS and was right).

**Playtest protocol with the owner.** Weekly, 10 to 20 minutes, a private link. Before: one line on what is new, nothing on
how to play. During: nobody explains. After: three questions only - was a bout fast and punchy; why did you win or lose
the last one; what would you do next if you kept playing? His words are quoted verbatim at the top of the next brief. The
page keeps a play log (each decision, its seconds, where he stopped) and one button copies it, so "where it dragged" is
read from the log, not asked.

**Outside players (M3 on).** 5, then 20, people from fight and card communities; the same three questions and the log.

**Telemetry later (M4).** Opt-in, anonymous, four numbers: bouts started and finished, art against art results, where a
career was abandoned, seconds a decision. Nothing personal.

## 8. Production

**Who does what** (CLAUDE.md roles; owner S539: the free seats write it, Claude coordinates): Arena all code and tests,
one new chat a round; a second Arena chat checks it; Dola design and critic; Kalli numbers and critic; John research; Ludo
assets; Maria art review; Qwen sound. No Claude worker writes card code. The owner approves taste, scope and money.

**Cadence.** One round = one brief = one pull request = one tag, about a day. **One new thing a round** (a mechanic, an
art, a layer or a look - never two). Two lanes may run side by side when they own different folders: the rules lane and
the picture lane. One play link a week, the same day each week. One board row (CARDGAME1) with the weekly line: "did this
week's build play better?" Two weeks in a row of "no" goes to him as stop-or-keep.

**How a round is briefed.** His last play notes verbatim; the one thing; owned files; the bars this round must move and
those it must not; the exact test and probe commands; "open the page first"; RESULT lines for the pull request body.
Before the brief: prior_research.py on the topic.

**What Claude checks before a merge (15 minutes):** the CI log itself, not the summary; the test count did not fall;
`node --test` once on the PC; the page opened and a bout played by script, a still looked at; the bar table against the raw
output; the diff touches only owned files. Then merge, tag, publish the link, post his three questions.

**Budget.** Seats are free. The PC only bakes pictures. Money appears at: the Steam fee (ESTIMATE about $100, to confirm on
Steamworks), a trademark check for the name, any Ludo credits beyond the subscription, and later capsule art if Ludo's is
not good enough. Each comes to him as a question when it is real.

## 9. Business

**Price and store.** Premium on Steam, one price, no packs, no loot boxes (plan S539, his "ok"). Price band ESTIMATE $10 to
15, set at M3 after John reads the closest comps' prices and review counts. A regional price table from Steam's own tool.

**Free and paid.**
| Free | Paid |
|---|---|
| Web demo on itch from M3: boxing + BJJ, the ladder up to National | The full game: 4 arts at Early Access, the title, defences, MMA |
| Steam demo for a Next Fest (same content) | After 1.0: new arts or ladders as expansions |
| Ghost battles, the daily card, judo and karate during Early Access, sambo at 1.0 | Never: packs, energy timers, paid cards |

**Legal.**
- Art names (boxing, judo, karate, sambo, wrestling, kickboxing, Brazilian jiu-jitsu, mixed martial arts) are names of
  sports. Bodies and brands (UFC, IBJJF, ADCC, IJF, WKF, Glory, K-1, Kodokan) are not used in the game or the store page;
  rule sets are described in our words. A lawyer's or a paid check before launch is a money question for later.
- Fighters, gyms and events are fictional. The game's own name needs a search for taken names before the store page.
- GrappleMap: public domain by its licence file (quoted in TASK_GRAPPLEMAP1); credited anyway. Mixamo: royalty free in
  games. Bought boxing clips: CLIP_LICENCE_LIST_S392 lists MoCap Online as commercial use allowed under 1M end users and
  $1M revenue (flag 5) and RamsterZ as allowed when embedded; whether still pictures rendered from a clip count as
  "embedded" is re-read before the picture set ships. Their files are never sent to an AI tool (MoCap Online asks for
  written consent). The Cascadeur clinch sample
  (flag 4) is not built on. MetaHuman bodies ship under the MetaHuman terms (flag 1): re-read them before the Steam page,
  because pictures made in Godot from those bodies are the product's whole look.
- Nothing from the reference games: no card text, numbers, art or names. Studies stay notes in our own words.
- The prototype's code is public while Arena writes it on the mirror. It moves to a private repo at M3 (plan S539 s4).

**Marketing a small studio can afford** (all free but time):
1. The hook in one clip: "seven martial arts, seven different card games" - a 15-second clip per art as it joins.
2. Steam page at M3 for wishlists; itch demo the same week; a mailing list on both.
3. The fight communities, for the authenticity angle (Submission Saga's praise was "authentic"): one honest post per art
   when it joins, asking practitioners what is wrong. Their corrections are free design review.
4. One Next Fest with the demo (date to pick at M3; John brings the numbers small card games got).
5. Keys to small streamers of card games and of fight content at Early Access.
6. Cross-promotion with FightCamp: each store page points to the other; one crossover fighter card.

## 10. Risk register
| # | Risk | Likely | Impact | Early warning | Mitigation |
|---|---|---|---|---|---|
| 1 | Balance passes with bots and it is still not fun in his hands | High | High | He stops before the second bout; cannot say why he lost | He plays weekly from M0; the three questions; fun bars are his words, not a number |
| 2 | The table breaks again as arts join | High | Medium | A frozen cell moves over 3 points; the new art needs more than 2 pair cards | Frozen arts, pair cards, one art a step, the matrix file in every diff |
| 3 | Scope creeps back (seven arts and a ladder at once) | High | High | A brief with two new things; a milestone with no play | One new thing a round; this page as the METHOD line; stop-or-keep weekly |
| 4 | Arena's code goes green by cutting tests or does not run | Medium | High | Test count falls; page not opened | Guard on the count; code-check chat; Claude opens the page before every merge |
| 5 | Closer competitors break out first (three launched in six weeks) | Medium | Medium | One passes 500 reviews | Ship the hook (arts that differ) early as a demo; John re-reads their numbers at each milestone |
| 6 | "Fast and punchy" is lost as arts, animation and layers pile up | Medium | High | A bout over 5 minutes; decisions over 45 | D1 in the PLAY gate; animation budget of 1 s; speed setting |
| 7 | Bouts are thin (3.0 choices a decision, 14.3% of turns with nothing laid - scope 6e) | Medium | High | Critics under 8 on depth; he calls a turn obvious | Rivals' Edges, the corner pick and cross-training add reasons to choose; measured before more arts |
| 8 | A licence stops the look (MetaHuman terms, bought clips) | Low | High | The re-read finds a limit | Read at M2, before the picture set is large; fallback: GrappleMap figures and Ludo-drawn bodies |
| 9 | The Steam wrapper does not work as hoped | Low | Medium | The M2 spike fails | Godot shell as fallback with one rules engine; decided at M2, not at M4 |
| 10 | Free seats stall (Arena down, chats lose context) or the gym game starves | Medium | Medium | A round takes over two days; gym queue stops moving | Briefs are self-contained; rounds are small; the card game is one board row with a weekly cap of his and Claude's time |

## 11. Decisions needed from the owner (taste, scope, money only)
1. **Play builds before balance is finished?** Recommended: yes - you play every week once it opens and plays.
2. **Art order: wrestling, kickboxing, judo, karate, sambo, MMA last?** Recommended: yes.
3. **Early Access with four arts, the rest as free updates?** Recommended: yes - sooner on sale, no paid add-ons early.
4. **May an art have a bad matchup, like the real sports?** Recommended: yes, never worse than 40-60.
5. **Try the Expedition 33 timed guard once, optional?** Recommended: yes, at the three-art build; you judge it.

Not asked, decided here and reported: the limb points stay out as the resource and return inside kickboxing (measured);
the browser build is the product (code structure); price and name wait for M3 with numbers.

## 12. The next three rounds (briefs for Arena; none starts before he signs this page)

**Round 7 - the build he can open (PLAY gate).** Start from whatever CARDFIX6B lands. One thing: the PLAY gate passes
and stays passing. (a) A node test that links the page's module graph with a stub document and a scripted player that
finishes one bout and one ladder step through the page's own calls; (b) `probe.mjs gate=play` and `gate=ship` print the two
tables of section 7, with P1 and L2 measured on the slice (boxing v BJJ, real ladder states); (c) the play log and its
copy button; (d) the first-10-minutes script of section 3 as the opening (two fighters to pick, the first volley one card,
one line on why the bout ended). No rule or number changes beyond CARDFIX6B's list. Owned: proto/cardgame/. Done when the
pull request says READY FOR THE OWNER'S PLAY and Claude has played it by script. He plays; his words open round 8.

**Round 8 - cards as data, with pictures (no rule change).** One thing: content moves to data and every card shows two
bodies. (a) cards.mjs becomes one data file per art (the row format of section 6) and the card text is generated from it;
a test proves every printed number equals the engine's; (b) the BJJ pictures and the position strip from proto/grapplemap
(GRAPPLEMAP1) on the cards and the strip; boxing uses the pair pictures Claude supplies as files; a card with no picture
fails a test; (c) a 0.6 s land effect in CSS with a speed setting and an off switch; the 27 sounds hooked; (d) the look
from the style sheet he picked. The matrix file is written for the first time (one cell). His round 7 notes that are
defects are fixed here; notes that are design go to round 9.

**Round 9 - the slice to the SHIP gate, sized by hand.** One thing: the two decks pass the full sheet. Kalli first writes
the two decks' numbers with a one-line reason each (no search); Arena then (a) fixes the pairing with at most two pair
cards an art (BJJ's answer to a boxer who stands back up; the boxer's on the ground), targets P4 47 to 53, P2 each way to
win 15%+, P5 holds end 15 to 30% of ground bouts, boxing's P6 over 50%; (b) rivals by rung each with one visible Edge and
a deck that uses it; ladder floors; L1 30 to 70 titles; (c) the beginner bar with the lesson on. Then two fresh critics
(Kalli or Dola, and a code-checked Arena chat) score depth and play with their lists to 10 and their drawings. A pass
plus his "another career" is milestone M1; round 10 is wrestling's paper sheet.
