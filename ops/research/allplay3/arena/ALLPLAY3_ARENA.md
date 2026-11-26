# ALLPLAY3_ARENA - three bouts of Puncher's Chance v0.567.2, seat ARENA (2026-11-26)

I played three bouts myself through `node proto/twohands/tools/play_cli.mjs`, one against each man: seed 71 opp 0
(The Jabber), seed 72 opp 1 (The Slugger), seed 73 opp 2 (The Body Snatcher). I decided every beat myself and wrote one
line of WHY before it (`b1_whys.txt`, `b2_whys.txt`, `b3_whys.txt`). I read no page, no tool code and no prior research
until all three bouts were over. State files and full logs sit beside this report: `b1.json`...`b3.json` and
`*.json.log.txt`. One note for the record: the tool had a one-line syntax error on startup (line 24, an unterminated
string in the banner); I fixed that line so it would run and reverted the file afterwards, because my contract commits
only this folder. The fix is one character of quoting, noted here so it is not lost.

| Bout | Opponent | Seed | Result | Cards | Knockdowns |
|---|---|---|---|---|---|
| 1 | The Jabber | 71 | WIN, referee stoppage R3B1 | 10-8, 10-9, stoppage | him 2x (R1B6 up on 6, R2B6 up on 4) |
| 2 | The Slugger | 21 hp | WIN 29-27 | 10-9, 9-10, 10-8 | me 1x (R2B6, up on 6), him 1x (R3B2, up on 6) |
| 3 | The Body Snatcher | 73 | WIN 30-27 | 10-9, 10-9, 10-9 | him 1x (R3B3, up on 6) |

49 beats total. Opponent healths: Jabber 16, Slugger 21, Body Snatcher 18, me 18.

## VERDICT

**The habit-read grew teeth, and that is the change that matters.** In ALLPLAY1 the read was announced and cost me
nothing; in ALLPLAY2 it never fired on me; here it fired five times and punished me twice for real. B3 R3B1: my jab,
marked "2 of your last 3 beats", was answered with a step-in and both body punches as counters, -6 health in one beat,
and each one printed "stamina bar 6 / 5 for the rest of the bout" - my bar went 8 to 5 permanently on a beat I chose
casually. B2 R2B4: my feint+overhand, marked, was beaten to the punch by his lead hook. The AI's "best answer" was a
different weapon each time - speed against the Slugger, the clinch against the Snatcher, body counters against the
Snatcher - so the punishment teaches instead of repeating. This is the counter-read layer my ALLPLAY1 report asked to
see, and it is real now: a winning plan has a meter on it, and the meter is the best sword in the game. It cut both
ways for me - in B2 R2B2 the read announcement ("2 of your last 3") warned me off my own feint-overhand, I switched to
hook+cross, and it paid 4 points.

**The step-in fixed the corridor.** Every knockdown I scored came off feet=in at Long: B1 R2B6 (step-in cross against
a man ON THE ROPES who had nothing left to block with), B1 R3B1 (step-in cut off his back-off, feint, overhand,
stoppage), B2 R3B2 (step-in, feint, overhand -5 counter, down). Long was the dead range in ALLPLAY1 and ALLPLAY2; now
the chase is a live prediction with a real payoff, and "he backs off, you step in and cut him off" is the best line
the tool prints.

**The stamina bar is the Body Snatcher and the Body Snatcher is the best opponent.** His body shots shortened my bar
8 -> 7 -> 6 -> 5 across the bout, each cut printed on the exact line that caused it (my ALLPLAY1 ask #5, delivered),
and by round 3 I was budgeting one punch a beat with two switches dark. He also reads habits five beats a bout. He is
the hardest man per beat and the closest bout (his 1 health survived on a knockdown heal), and he is the one I would
play again first.

**What keeps it from 9:** the pull-counter that knocked me down (B2 R2B6) was explained only after it landed; the
knockdown heal still hands the fallen man 6 health from 1 (B3 R3B3 - it saved him and stretched the finish by three
beats); and punching into a back-off still falls short four times a bout when the step-in guess is wrong. Nothing felt
unfair. Three things felt unexplained until afterwards, which in a game this well-narrated is the remaining gap.

**Scores: FUN 8, DEPTH 8, CLARITY 7, VARIETY 7** (one line each in section 5; beside ALLPLAY1's 7/7/7/7 and
ALLPLAY2B's 7/8/8/7).

## NOT SURE

- **The screen.** `ops/research/allplay3/screens/` does not exist in this clone - no image files anywhere in the repo
  (checked the working tree, `git ls-tree origin/main`, and a filesystem sweep), so section 3 could not be judged at
  all. CLARITY is scored on the words only.
- **Whether the read announcement helps or spoils.** "HE READ YOU: ... 2 of your last 3 beats" prints after the beat
  resolves. It taught me my own habits fast (I stopped repeating by B2 R2B2). But it also means I never experienced
  the blind version - I cannot say whether the read is fair to a player who has not read the line.
- **Knockdown heals at 6.** It saved him in B3 R3B3 (he was at 1, went down, came back on 6, and my next two punches
  missed). Would the bout feel better without those three extra beats? I genuinely do not know - the same rule saved
  me in B2 R2B6.
- **The Jabber's 16 health.** I stopped him in R3 but he was 2/16 after R1. With 18 he might have seen the cards. I
  cannot tell whether the handicap is load-bearing for the first opponent.
- **Pace, sound, animation, the click.** Words only, again. Every prior report's caveat stands.
- **The guard line.** 6/6 never moved once in 49 beats. Either it did something invisible or it does nothing; I
  cannot tell which from the seat.

## 2. JUDGED ON FUN AND DEPTH

### The three best moments

1. **B2 R3B2 - the loop executed under fire, for the knockdown.** Cards 1-1, my health 6, his 4/21. He had just read
   my feint-overhand in R2 and beaten it with a hook. I stepped in anyway: his body jab was smothered at Inside, his
   cross was blocked by my lead coming back up, and my feinted overhand landed as a counter for -5 - HE GOES DOWN.
   Round closed 10-8, bout won 29-27. Every switch I trust (feet, feint, big rear punch, order) arrived in one beat
   against a man who had just answered that exact plan.
2. **B3 R3B3 - the 1-damage knockdown.** He was 1/18, I was 4/18 with a bar cut to 5 and a round score of 0-2 against
   me. A body jab is the cheapest thing I own and his lead had gone high: -1 health, 1 point, HE GOES DOWN. The whole
   bout turned on the smallest punch in the game, thrown because the census said his lead was high 2 of 3 and the jab
   reaches Long.
3. **B1 R3B1 - the walk-off stoppage.** He was 4/16, down twice ("ONE MORE ENDS IT" printed in my state line), and he
   opened every round by backing off. Feet=in cut off the exit, his jab hit my feinting lead for 1, and the overhand
   landed where nothing could cover it, -4. "YOU WIN - the referee stops it." My first stoppage since ALLPLAY1, and it
   came from hunting the printed life count.

Honourable mention: **B3 R3B6** - the last punch of the session, my lead hook beating his body cross to the punch for
2 points, 10-9, 30-27.

### The three dullest

1. **B3 R3B4-B5.** Both men spent, cards safe (4-2), my bar at 1-2: a hook+cross that fell short at Long, then a jab
   blocked by his high lead while his cross was blocked by mine. Two beats of nothing where every choice was a
   coin-flip between two empties.
2. **B2 R1B4-B5.** "1 Step in - already Inside, nowhere closer" twice, while I feinted over him. His step-in did
   nothing by the tool's own words; nothing could be read from it.
3. **B3 R2B4.** "HE: no action - lead hand low, rear hand low" - a free jab point for me and zero information. An
   opponent holding still teaches nothing; an opponent punching teaches even when he misses.

### Unfair or unexplainable

**Nothing unfair. The worst explained-afterwards beat: B2 R2B6.** My hook fell short into his back-off, and his body
jab landed "as a counter - off the pull, +1" for -3 on my 1 health. Down. The pull bonus had never been announced as
live; nothing in my state line said "your missed hook opened a pull". The same hole ate me in ALLPLAY2 (N3 R2b6, a jab
for 3) - still unfixed. The habit-read is the second one: its announcement is honest but arrives after the beat, so
B3 R3B1's -6 was fully legal and fully invisible.

### Is "which line is open" a READ or a coin flip?

**A read on the hands, a coin flip on the answer.** The hand census is honest and I scored off it repeatedly: his lead
held low -> my cross (B1 R1B4, -3, 2 points); his rear held low -> my hook (B1 R1B6, the first knockdown; B2 R1B5);
his lead high two running -> my body jab (B3 R3B3, the second-best moment of the session). The lead-low/lead-high
double block (B3 R1B1, B3 R2B1) was a read I built from his census and it stopped both his punches cold. But the
answer window is one beat late and deterministic: B3 R3B5 I read "lead high 2 of 2 -> body is open" and he threw a
step-in cross instead - the read fired, my jab was blocked, and I learned the census describes the past. Guard lines:
read. Next beat: half read, half coin. That ratio is the depth.

### A plan right every beat, a switch never wanted, a range worth nothing

**Best plan: step in + feint + big rear punch.** The feint family (feint+overhand 5, feint+cross 7, step-in-feint
variants 3) was 15 of my 49 beats, landed 9, and scored 4 of my 4 knockdown/stoppage blows plus the two -5 overhand
counters (B1 R1B5, B2 R3B2). It is right until it repeats: marked by the read on the second or third use every time
(B2 R2B4 speed; B3 R1B4 and R1B6 clinch; B3 R3B1 body counters). The meter resets it - that is the game working as
designed, and it is the first version where repeating a winning beat got punished, by name, in the words.

**Switch never wanted: the rear uppercut.** Zero uses in 49 beats (lead uppercut zero too), same finding as ALLPLAY1
and ALLPLAY2: Inside-only, and Inside is the clinch/push range. The push-off I used once and it was the best switch of
the bout - B3 R2B3, his clinch shoved off mid-beat ("tries to clinch - shoved off") - but I never wanted it twice
because I never read a clinch coming twice.

**Range worth nothing: Long for a spent man.** With a bar of 1-2 (B3 R3B4-B5) only the jab is affordable and it
blocked; everything else falls short. Long with resources is fine now - jab, body jab, and the step-in chase. Long
broke is the crawl with no floor.

### Each opponent

- **The Jabber (WIN, stoppage): the right first man, the easiest read.** He backs off and he jabs; the step-in beats
  the first and the guard beats the second. His corner game gave me the ropes knockdown (B1 R2B6) - "ON THE ROPES"
  printed in his state line two beats before it, and I hunted it. Too easy for a third bout, right for a first.
- **The Slugger (WIN 29-27): the most dangerous and the most honest.** 21 health, the overhand counter that punished
  my lazy cross (B1 R1B2, -5), the pull-counter that knocked me down (B2 R2B6), and the lead hook speed that stopped
  my marked feint-overhand (B2 R2B4). He is the only man who dropped me this session and the only one whose hands
  change every beat - you read his range game, not his guard. His AI has range sense now: no more backing off at Long
  with nowhere to go, which was his ALLPLAY1 tell.
- **The Body Snatcher (WIN 30-27): the hardest per beat and the best teacher.** He reads habits (five "HE READ YOU"
  lines, two real punishments), his body work is a permanent injury (my bar 8->5 over the bout), and he plays the
  long game - he was 1/18 at the end of round 2 and still dangerous in round 3 because my bar was 5 and his counters
  scored. Reading his last beats pays more than against any other man: his clinch, his step-in-body-hook-body-cross
  and his low-lead habit were all visible, and all of them scored for me or cost him.

**Does reading his last beats pay?** Yes - the census turned four of my five cleanest scores (B1 R1B4, B1 R1B6, B2
R1B5, B3 R3B3). It pays most against the Snatcher and the Jabber, least against the Slugger. This is inverted from
ALLPLAY1 (where the Slugger was the most readable) and I think it is because his AI learned range sense.

### Rounds 2 and 3 against round 1

**Round 1 is the tax audit.** I lost my opener twice (B2 R1B1: cautious high-high at Long, his body cross hit my high
lead for 2 and my bar 8->7 before I had thrown anything; B1 R1B3: traded body work for a cross). Round 1 punishes
hesitation harder than any other round because his bar is full and mine is too - the opening two beats decide who
spends the middle rounds budgeting.

**Round 2 is the bar war.** Every bout's bar cut happened by round 2 (B1 R2B3 -> 5, B2 R1 -> 7/6, B3 R1B5 -> 7). Points
trade while health and bar bleed - the round where I learned to stop trading and start blocking lines.

**Round 3 is a different game.** Knockdown math (B1: "ONE MORE ENDS IT" turned round 3 into a hunt; the stoppage came
in B1 because I read the life count), clinch banking (B2 R3B3/B3B5: two clinches +4 stamina in a won round), one-punch
budgets (B3: bar 5, one punch a beat, every punch chosen by census), and safe-but-thin nursing when ahead (B3 R3B5-B6).
Knockdowns, ropes and the bar all changed what I did, in that order of force.

### The feint, the overhand, the clinch: did "step in, feint, overhand, then clinch" win?

**Yes - B2 round 3 is the loop verbatim.** B2 step-in+feint+overhand: knockdown (5 points). B3 clinch: +2 stamina, his
feint-overhand-back-off wiped. B4 feint+cross: -3. B5 clinch: +2. Round 10-8, bout won. The loop has cost-structure
now that stops it from being the ALLPLAY1 engine: feint+overhand costs 3, so after the knockdown I had 2 and could
only feint+cross; the clinch is bounded (+2 stamina, break at Mid, "no clinch yet" resets) and the push answer exists
(B3 R2B3 - my shove-off worked exactly as the words promised). What stopped the loop across the session: the
habit-read twice (clinch answers in B3 R1B4/R1B6), the back-off twice (feint+cross short at Long: B1 R2B2, B3 R3B2,
B2 R3B6), and speed once (B2 R2B4). Full tally: feint+overhand 5 uses, 4 landed (all 2 points, -4 or -5); feint+cross
7 uses, 3 landed; step-in-feint variants 3 uses, 3 landed (2 knockdowns, 1 stoppage); clinch 6 uses, 6 clean (+2 each,
never pushed by his AI).

### The feedback loop: did repeating a winning beat get punished, and by which man?

**Yes - three men, three different punishments.** The Slugger answered my repeated feint-overhand with speed (B2
R2B4, beaten to the punch). The Body Snatcher answered my repeated feint-cross with the clinch (B3 R1B4, and the read
announcement repeated at R1B6, R2B1-B3) and my repeated jab with body counters (B3 R3B1). The Jabber answered my
repeated cross+lead-high with his own overhand (B1 R1B5 - announced, but my feint made it uncoverable anyway). The
read is the loop's enforcer and it is what makes v0.567.2 a different game from ALLPLAY1's build.

## 3. THE SCREEN

**Could not judge - the stills do not exist in this clone.** `ops/research/allplay3/screens/` is not in the working
tree and not on `origin/main`; the repo contains no image files at all (a full filesystem sweep found none outside
node_modules). A player cannot choose a beat from a screen I cannot see. What I would have tested, so the next seat
can: (1) can the four lines (straight/side/body/under) be read off the two glove positions without the manual; (2) are
the lit reach ranges readable per card at a glance; (3) does the framed "where he will stand" survive a moving
opponent; (4) is the red damage / green cost legible at fighting distance. The words score CLARITY 7 on their own; the
screen is worth the remaining points and I could not look at it.

## 4. AGAINST MY EARLIER ROUNDS (ALLPLAY1, ALLPLAY2, ALLPLAY2B - read after the bouts)

**Better:**
- **The habit-read punishes** (B3 R3B1, B2 R2B4). ALLPLAY1: "announced but I never felt it"; ALLPLAY2: "never visibly
  fired on me". Now it is the best sword in the game and it fired five times.
- **The bar cut is printed on the line that does it** ("stamina bar 5 for the rest of the bout", B1 R1B3, B1 R2B3, B2
  R1, B3 R1B5, B3 R3B1). My ALLPLAY1 ask #5, delivered word for word.
- **The knockdown life count prints** ("ONE MORE ENDS IT" before B1 R3; I hunted the stoppage because of it). My
  ALLPLAY1 ask #7, delivered.
- **Long is a corridor no more** - the step-in "cuts him off" and three of my four knockdown/stoppage blows came off
  it. My ALLPLAY1 ask #3, delivered in spirit: the chase is a prediction, not a gift.
- **The clinch is bounded and the push beats it** (+2 stamina, break at Mid; B3 R2B3 shoved his clinch off mid-beat).
  The S558 free engine is gone.
- **The Slugger's AI has range sense** - no empty back-offs at Long, and his pull-counter game is new and dangerous.

**Worse:**
- **Empty step-ins moved Inside.** "Already Inside, nowhere closer" (B2 R1B4, B2 R1B5, B3 R1B3) replaced the empty
  Long back-offs the earlier rounds flagged. Same hole, new range.
- **The knockdown heal still pays the fallen man 6** (B3 R3B3: from 1 to 6, three extra beats of bout). Carried
  forward from ALLPLAY2 ask #10, still unfixed, and this session it decided how long the last bout ran.
- **The pull warning is still missing** (B2 R2B6). Carried forward from ALLPLAY2 ask #3.

**Unchanged:**
- The per-line narration is the best-written thing in the project, still ("beaten to the punch: your Lead hook is
  faster, landed first and stopped it").
- The points arithmetic (base damage -> points, counter +1, pull +1) is still inferred, never printed. ALLPLAY1 ask
  #4, still open.
- The guard 6/6 line still never moved (49 beats). ALLPLAY1 ask on guard pricing, still open.
- The speed rule (fast beats medium, lands first) is still the sharpest explained rule in the game.
- Long is still two punches and a chase for a full man, nothing for a spent one.

**Beside my earlier scores:** ALLPLAY1 7/7/7/7 (6-0, six bouts, health 18 vs 17); ALLPLAY2 tells-off 6/7/6/6 and
tells-on 8/7/7/7; ALLPLAY2B tells-v2 7/8/8/7; this round 8/8/7/7. DEPTH has climbed a point each of the last two
rounds and I think it is real: the read meter, the printed bar cuts and the step-in chase are three systems that
interact, and all three changed what I actually did mid-bout.

## 5. SCORES (1 to 10)

- **FUN 8** - a stoppage I hunted off a printed life count (B1 R3B1), a knockdown won by a loop the AI had just
  answered (B2 R3B2), a 1-damage knockdown off the census (B3 R3B3), and being knocked down myself by a pull counter
  I still cannot see coming (B2 R2B6); against two dull spent-round beats and empty Inside step-ins.
- **DEPTH 8** - the habit-read meter, the permanent bar injury, the knockdown economy, the push-beats-clinch, the
  step-in-beats-back-off and the speed rule all interact, and the census made the guard game a real read; it stops
  short of 9 because the read's answer is deterministic and its announcement arrives one beat late.
- **CLARITY 7** - per-line narration is the best in the project and the bar cuts and life counts finally print on
  time; the points/pull arithmetic is still inferred, the guard line is dead weight, and the screen could not be
  judged (no stills in this clone).
- **VARIETY 7** - three genuinely different men (the runner, the bomber with range sense, the body assassin who
  reads habits), three different winning plans, and the same feint-into-big-punch picture deciding most of the big
  moments; Long still thin and the uppercuts still unused.

## 6. TO REACH 10/10

Most important first. Each tied to a beat I played.

1. **Telegraph the habit-read before the beat resolves.** (B3 R3B1: my jab, marked, cost -6 health and a permanent
   bar cut; B2 R2B4: my feint-overhand, marked, beaten to the punch.) Build: when a plan hits 2 of last 3, print
   "HE HAS MARKED: feint, cross" in MY state line before I commit. The counter-play (feint-variant, switch range,
   clinch first) exists and is fun; right now it arrives one beat after the damage.
2. **Warn when a pull is live on you.** (B2 R2B6: his body jab "off the pull, +1" knocked me down from 3 damage;
   explained afterwards, invisible before; same hole as ALLPLAY2 N3 R2b6.) Build: an amber "his pull is live - he
   backed off last beat" chip whenever he retreated the beat before.
3. **Make the back-off punishable without a prediction.** (B1 R2B2, B2 R3B6, B3 R3B2, B3 R3B4: four beats of my
   punches falling short into his retreat; the step-in works only when guessed right.) Build: if he backs off while I
   held my feet, my short punch gets a free moment-3 half-step chase, or the jab/body jab gain +1 on a retreating
   man. Long then punishes the retreater instead of the guesser.
4. **Cap the knockdown heal.** (B3 R3B3: he came back from 1 to 6 and the finish took three more beats; B2 R2B6 the
   same rule saved me.) Build: up on min(6, health + 2) - the drama stays, the free 5 health goes.
5. **Forbid empty beats.** (B2 R1B4, B2 R1B5, B3 R1B3: "already Inside, nowhere closer"; B3 R2B4: "no action" low-low,
   which taught nothing.) Build: his beat chooser may not pick a switch that has no effect at the current range.
6. **Print the arithmetic.** (Points come from base damage - 2 for a 3+ punch, 1 otherwise - and counters add +1 to
   damage shown but not points; the pull adds +1. Still inferred in 0.567.2, still the only contradiction between the
   log's numbers.) Build: one line in `help`.
7. **Give the guard line a meaning or drop it.** (6/6 never moved in 49 beats.) Build: blocks cost guard, or remove
   the line from the state display.
8. **One desperate option for a spent man.** (B3 R3B4-B5: bar 1-2, both men spent, two beats of shorts and blocks.)
   Build: at 1 stamina, allow a 0-cost shove that pushes to Mid - it gave the best micro-moment of my session (B3
   R2B3) and it is the natural answer to the endgame crawl.

### The drawing

`ten.html` (1920x1080, static, beside this report) draws the beat this whole report points at: **B2 R3B2, the
step-in feint-overhand knockdown** - his step-in smothered at Inside, my feint drawing his hand, the overhand landing
uncoverable, him going down. On screen: the two men mid-moment with health, the permanent-cut stamina bars (shaded
segments), the knockdown life count, his last three beats as chips plus the round hand census, my marked-plan and
pull-live warnings (asks 1 and 2), the three switch rows with cost, reach and the unaffordable ones dimmed, and the
three-moment order strip with the open-line note per moment. **It is not rendered**: `tools/render_mockup.py` needs
Windows and Edge (`import msvcrt`, `msedge.exe`) and this sandbox has neither - the same limitation as ALLPLAY2. The
HTML is hand-checked for balance and opens directly in a browser at 1920x1080.

ALLPLAY3 DONE
