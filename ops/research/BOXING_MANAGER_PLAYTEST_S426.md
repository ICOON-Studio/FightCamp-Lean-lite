# Boxing Manager (Steam 1605370) played out of sight - S426 playtest

Follows `BOXING_MANAGER_COMPARE_S425.md` (files only). This time the game was PLAYED: a new career, 6 in-game weeks, two
fights of my own boxers and one neutral world-title fight watched. Everything here is in our words; no asset, text passage
or data of theirs is in the repo. Screenshots (185) and three silent videos live outside git in `E:\FightCamp\tmp\bm_play\`.
Limits: entry-level 4-round bouts only, one run per plan, no knockdown seen, no show promoted, sound off, video at 3 to 4
frames a second (fine motion not judged).

## 1. What worked technically
- STARTED OUT OF SIGHT: yes. The exe was started on the never-shown desktop "FightCampHidden" with `--audio-driver Dummy
  --windowed` while Steam was running. It did not relaunch through Steam; no window of its process ever appeared on the
  visible desktop (checked before every stage). Nothing was added to or changed in the install folder.
- PICTURES: yes. Windows' PrintWindow WITH the full-content flag (3), called from a thread that has joined the hidden
  desktop, returns the real 1920x1009 picture. Without that flag it is blank. (Our own `tools/hidden_desktop.py` said
  PrintWindow is blank there: true only without the flag; its note is corrected. Worth using for our own builds.)
- CLICKS AND KEYS: yes. Posted window messages (mouse move, click, wheel, Enter, typed text) from the same joined thread.
- VIDEO: frames piped to ffmpeg, then the `eyes` tool indexed the first clip (36 camera shots in 4 minutes, on-screen text read).
- One trap: the starter process must stay alive, or the tool shell ends the game with it.
- Cost to the PC: 2.2 to 2.4 GB of memory, 47 to 56 C, watchdog AMBER (disk) throughout; I waited out one RED before starting.
- Engine: Godot 4.6.1 custom build, Vulkan. A world of 3,400 fighters was generated in 3.6 seconds.
- LEFT BEHIND on his PC: one save in the game's own user folder (career "Test Corner", manager "Sam Reed", slot 1) and the
  first-time tutorial already seen (the game's Options can replay it). Steam recorded no play time (it never launched it).
- The driver is now in the repo as `tools/hidden_play.py` (start, wins, shot, click, type, film); it plays any windowed program this way.

## 2. The walk
SETUP (4 minutes). Three cards: names, world size (3,400 up to 20,000 fighters, 17 weights), home city. Then the game
hands you a small gym with a trainer and lets you sign up to six unbeaten local prospects for free. Start: $500,000,
weekly cost $1,720. 27 tutorial cards in all, one sentence each, each lighting the control it talks about.

WEEK 1, the only busy week (about 12 minutes, 60 clicks, 17 choices for three boxers).
- Training: five areas, four levels each, a 100% cap; one more level in one area means one less in another. Set once.
- Matchmaker: a table of 23 to 27 possible opponents with 16 columns. Clicking a name shows AT ONCE whether his camp says
  yes, with one sentence, plus a label ("slight favourite 57%"), a one-line read of the night, the purse split, weeks out.
- Fight plan: one of five game plans and up to two of six focus tags, or let the trainer choose. A second tab lists the
  opponent's five best ratings ("biggest threats") and three worst ("openings") beside a radar of both men.
- I booked three bouts 4, 5 and 7 weeks out with three different plans.

WEEKS 2 TO 4: nothing. One press of "advance to my next fight" played three weeks in about ten seconds. The card said how
many fights the world resolved (1,251), title news about strangers, and one line of mine: a rating went up by one.

WEEK 5, fight night (Smith, a 93% favourite, plan: stay long and jab). The advance button itself turns into "go to the
fight". About 10 minutes live. He won every round, 40-35 on all three cards. Then: 5,220 experience points, a world
ranking for the first time (#170), five weeks of enforced rest, and a new "make a fight" button. I spent the points on one
rating; the game showed the price before I confirmed: the points AND two points of his lifetime potential (17 to 15).

WEEK 6, second fight (Gray, 74%, plan: pressure and body). Round 1 was poor; the corner said why in one line; I picked the
option it argued for; his connect rate went 12%, 22%, 26%, 36% and he won 39-37, 39-37, 40-36.

THE WATCHED TITLE FIGHT (any bout in the world can be opened and watched). A 12-round heavyweight title fight, stopped
in round 4. Afterwards the world rankings showed the winner one place above the loser with the new belt beside his name.

## 3. Their fight screen, as seen
- A real 3D ring: muscled boxers, referee, lit crowd, both corners with cornermen, the promoter's name on the canvas.
  The camera cuts about every 7 seconds between a side view, a high corner view and a wide view; a "replay" button
  appears after big moments. It looks like a broadcast, far above what the files suggested.
- Over each head a state chip: PRESSING, ON THE ROPES, IN TROUBLE. Bottom left: the round clock and landed/thrown this
  round with an arrow for who is ahead. One line of commentary under the ring.
- Speeds: live (a round takes about 150 seconds), long highlights, short highlights (about 90 seconds a round), fast
  forward (about 25 seconds a round), skip to the bell, skip to the result. A 12-round fight live is half an hour.
- Side panel: commentary log (about one line a second, each time-stamped), live statistics down to each punch type,
  radar compare, betting with in-game money (locked at the bell), and the officials.
- Officials, shown BEFORE round 1: three named judges, each with a taste in two words ("work rate", "even ledger"), a
  star rating, "steady card" or "unpredictable card", and one line for the panel as a whole.
- END OF ROUND CARD: a headline verdict ("edged the round", "dominated the round", "tight round") with a three-word
  reason; five paired bars (landed, thrown, power, jabs, body); a momentum strip with one chip per round in the winner's
  colour; stamina regained on the stool for both men ("+13, now 92"). The camera goes to a wide shot of both corners,
  then a top-down close-up of the cornerman at work. The fight waits for your press.
- Result: a staged reveal, judge by judge, then the name. Then four report tabs: totals, a round-by-round table tinted
  green for the better man in each cell, the cards, damage (head, body, stamina left).

## 4. The ten questions
1. HOW MANY THINGS DOES A WEEK ASK? A quiet week: 1 click, 0 choices (the result card carries the next advance button).
   A booking, per boxer: about 12 clicks, 4 choices (opponent, plan, two tags). A fight: 3 clicks to get in, then one
   choice a round and two shouts a fight. Training was never reopened. Three boxers did not make weeks busier, only
   more often interrupted by a fight.
2. IS THE 3D FIGHT WORTH WATCHING? Yes for a round or two: the cuts, chips, crowd and corners carry it. Bodies look alike
   and at our 3 to 4 frames a second I cannot judge the punches. Short highlights do NOT make a fight short (90 seconds a
   round); fast forward and skip-to-the-bell do. I watched one round live, then skipped, both times.
3. DO THE PLAN AND TAGS VISIBLY CHANGE A FIGHT? In the numbers, yes: with "stay long" + "jab" 352 of 424 punches were
   jabs. But the game never says so. No screen tells you what the plan did or whether it was the right one, and one run
   cannot separate the plan from the boxer. Decoration it is not; feedback it has none.
4. WHAT DOES A BETWEEN-ROUND INSTRUCTION CHANGE? Eight options, each with its trade written under it ("+body work,
   -head shots"; "+power, +KO chance, -defence"; "+defence, -all offence"). In my fight each one moved the next round
   the way it said: body punches went from 24% to 44% of his output; "go for the knockout" raised his power punches
   from 12 to 21 and let the other man connect 37% instead of 28%; "cover up" cut his output from 116 to 75 and the
   other man's connect rate to 21%. The commentary does not mention the instruction. The corner's one-line advice
   changes with the round when things go badly ("missing too much: jab first"), and repeats itself when they go well.
   A shout (2 a fight, 5 kinds) says "on until the bell" and nothing more.
5. ARE THE TABLES READABLE? At 1080p yes. Colour-banded bars (red, orange, yellow, green on a 1 to 20 scale), weight-class
   chips and radars read at a glance. The matchmaker's 16 columns and the body initials (four bodies plus a fifth),
   "UNR", "3F", "FTW" slowed me for about ten minutes; the tutorial covers most of them.
6. HOW FAST IS A YES, AND DOES A NO TEACH? Instant, and shown before you even ask. A no is one generic sentence ("no
   upside for them") and a greyed button; I found no way to improve the offer. What it teaches comes from the pattern:
   boxers with a rival promoter beside their name refuse. The title-shot tab is better: each closed door gives its exact
   reason ("not ranked in the top 10", "already booked against X in week 2"), and the boxer's page says "regionally
   ranked #55: the regional top 5 get a title shot".
7. BOXER CAREER MODE, AND LOCKS? The start screen shows a "manager mode" label and no way into another mode. Nothing was
   locked in 45 minutes: plans, two shouts a fight, every weight. No store, advert or subscription prompt appeared. The
   save folder does hold an empty wallet with tables for purchases, an "all weights" entitlement and advert placements
   (before a fight, on week advance): the phone shop's plumbing ships with the PC build, switched off as far as I saw.
8. HOW BIG IS THE WORLD? 3,400 fighters at the smallest setting, 17 divisions, four bodies plus a lineal belt, 3,402
   amateurs with countdowns to four tournaments, 156 trainers for hire in one country, about 300 fights resolved a week.
9. DOES ANYTHING STOP YOU? Only your own fight. Between two interesting choices there were three empty weeks, and after
   a fight the boxer is out for 4 to 5 weeks. The loop is: book, skip, fight, spend points, book.
10. WHAT WOULD I OPEN NEXT, WHAT PULLS ME BACK? The 57% fight I booked for week 8 (the only one I am unsure of), then
    the ranking after it. The pull is the countdown chip beside each boxer, a ranking number that moved, points to spend,
    and a named next rung with its rule. Nothing about the boxers as people pulls: they are rows.
WHAT THE PLAYER WAITS FOR: the fight date, the rest period ending, a ranking reaching the line for a title shot.
WHAT THE GAME REWARDS: a win with points (one rating, at a price in potential), a ranking, a record. Money did not
matter: purses near $2,000 against $500,000 in the bank. The win itself is a table, not a moment.

## 5. Ratings corrected by play (0 to 10)
| Aspect | Files said | After play | Why it moved | FightCamp today |
|---|---|---|---|---|
| Things to do in a week | 5 | 4 | quiet weeks ask nothing at all; training is never reopened | 6 |
| Depth of decisions | 7 | 6.5 | the yes/no is shown before the ask; the plan is three picks with no feedback | 7 |
| The fight to watch | 6 | 8 | real broadcast: cuts, crowd, corners, chips, replays, six speeds | 5 |
| The fight to steer | 5 | 6 | round instructions have written trades and visibly work; two shouts | 8 |
| Readable screens | 6 | 7 | colour bars, chips, radars, a good tutorial; tables still dense | 6 |
| World and career | 9 | 9 | confirmed: every bout watchable, rankings react at once, each rung states its rule | 3 |
| Progression and reward | 7 | 6.5 | the priced upgrade is good; the win is flat and money is irrelevant | 5 |
| Realism | 8 | 8 | judges with tastes, rest periods, sanctioning ladder | 7 |
| Overall | 7 | 7 | the fight show is better than thought, the week emptier | 5.9 |
The gap is the same size but sits elsewhere: their fight as a SHOW is three points ahead of ours; their week is two
behind what ours already is. Week design v2 attacks exactly what they leave empty.

## 6. What to take, most valuable first
1. THE ROUND CARD IN PICTURES. Verdict headline with a three-word reason, a momentum strip with one chip per round, and
   stamina regained on the stool. Improves: the left panel of `docs/mockups/s425/corner_v1.png` (today: an exchanges bar,
   two body figures, one quote). Add the strip of round chips and the "+13 on the stool" read. Size: small.
2. A WRITTEN TRADE UNDER EVERY CHOICE, AND THEN THE READBACK THEY LACK. "+this, -that" in three words under each
   option. Improves: every option in "Your minute" on corner_v1 (only Range has its two chips today) and Thursday's one
   change in WEEK_DESIGN_V2 section 3 ("what it buys, what it takes"). Ours must go further: after the round, one mark
   saying whether the call did what it promised. They never do, and it is the first thing I missed. Size: small.
3. THE COACH'S LINE NAMES THE OPTION IT ARGUES FOR. Their corner sentence is a diagnosis that points at one button, and
   following it worked. Improves: Reid's quote on corner_v1 and Wednesday's sentence in section 2: light the matching
   option. Never repeat the same line two rounds running (theirs does). Size: small.
4. A NAMED NEXT RUNG WITH ITS RULE AND YOUR PLACE. "Top 5 get a shot, you are #55." Improves: "What playing on opens"
   and Home's "Opens next" (section 3), now for the nationals gate and the draw, later the belt ladder. Size: small now,
   large with the ladder.
5. A COUNTDOWN CHIP ON EVERY BOXER ROW (4w, FIGHT, OUT 5w). Improves: Home's board in section 2. Size: small.
6. THE CHECKLIST AT THE ASK. They show yes or no the moment you pick a name. Keep our Thursday answer (the wait is the
   anticipation they throw away) but show at ask time what is already met and what is missing. Improves: "The next
   fight: the ask, the card" (section 3, points 2 to 4). Size: small.
7. THREATS AND OPENINGS AS THE PICTURE OF A SCOUTED RIVAL. His five best and three worst as coloured bars beside a
   two-man radar. Improves: the banked weakness from ringside and the card in pictures (section 3, "The next fight").
   Size: medium.
8. SKIP TO THE BELL, AND A STAGED RESULT. One judge at a time, then the name; and a skip that stops at the next corner
   minute so the player never loses a choice. Improves: fight night after Saturday in section 2, and the 3D fight
   display. Size: small to medium.
9. STATE CHIPS OVER THE HEADS in the 3D fight (pressing, on the ropes, in trouble) and a landed/thrown counter with an
   arrow. Improves: the fight display the owner approved for building (S422). Size: small.
10. EVERY REWARD PICK SHOWS WHAT IT USES UP. "Costs these points and two of his potential." Improves: "What playing on
    opens" (a freed evening, a plan place): show the price on the reward itself. Do NOT add a points currency. Size: small.
11. THE WEEK CARD CARRIES THE NEXT STEP. Their result card has the advance button on it and tabs per week when several
    were skipped. Improves: next Monday's three-line readback in section 2. Size: small.
12. JUDGES SHOWN BEFORE THE BELL, each a taste in two words plus steady or unpredictable. Improves: the small living
    world agreed for after the week (judges with taste); it answers the owner's worry about scoring rules the player
    cannot see. Size: medium, after the week.
13. ONE-SENTENCE TUTORIAL CARDS that light the control, shown the first time each screen opens, replayable. Size: small.

## 7. What they do worse than us
- THE WEEK IS EMPTY. Three weeks passed in ten seconds with nothing to do, anticipate or choose. This is the gap our
  week design fills, and after playing theirs I rate that the most valuable thing we are building.
- NO PREPARATION. Between booking and the bell there is only waiting: no camp, no drilling, no tape, no weight story at
  this level. Our "answers in the boxer's hands before taper" has no counterpart.
- NO WHY. The plan and the tags give no feedback; the report is statistics. Our "why you won" and graded plan lines are ahead.
- TRAINING IS SET AND FORGOTTEN, as the files suggested. Confirmed.
- A REFUSAL IS A DEAD END: one generic sentence, no way to work on it.
- THE WIN IS A TABLE. No face, no moment, no crowd reaction; boxers are rows with a flag. Our portraits and warm look matter.
- THE COMMENTARY IS A FLOOD: about a line a second, unreadable live. One call every 30 seconds, as ours, is the better pace.
- MONEY HAS NO TEETH early: $500,000 against $1,720 a week. Our club that can close keeps every choice priced.
- DENSE TABLES AND INITIALS on the booking screen, against the owner's graphics-first rule.

## 8. Evidence
- Screens and videos: `E:\FightCamp\tmp\bm_play\` (numbered in play order; `s_*.png` are contact sheets;
  `fight1_a.mp4` round 1 live, `fight1_b.mp4` short highlights, `fight2_smith.mp4` my boxer's whole fight).
- Four reference stills are on the review board under stage S426, rated "reference, not ours".
- Running notes: the shared notes folder of this session group (`bm_playtest_notes.md`). The driver: `tools/hidden_play.py`.
