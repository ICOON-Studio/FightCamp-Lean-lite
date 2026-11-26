# ALLPLAY2_ZIVA - six bouts of Ring Switches, tells on and off (S563)

Seat: ziva (shell). Discipline: boxing. Played cold: I read only `play_cli.mjs help`, then played all six bouts
before opening `order.html`, `tells.mjs`, `ops/research/allplay1/`, `docs/RINGSWITCH_S558.md` or the two briefs.
No game file was touched; no commit. State files and logs are beside this report (`b1`..`b6`).

## VERDICT

**Yes, show the opponent's intention before you choose - but not the way TELLS does it now.**
The telling is the best thing in the game and it is also currently the whole game.

Six bouts, same two men each time, three with TELLS and three without:

| # | Opponent (seed) | Tells | Result | Points by round | My knockdowns taken | His |
|---|---|---|---|---|---|---|
| 1 | Jabber (41) | ON | **WIN 30-27** | 10-9, 10-9, 10-9 | 1 | 2 |
| 2 | Slugger (42) | ON | **DRAW 28-28** | 9-10, 10-8, 9-10 | 1 | 0 |
| 3 | Body Snatcher (43) | ON | **LOSS 27-30** | 9-10, 9-10, 9-10 | 1 | 0 |
| 4 | Jabber (31) | OFF | LOSS 26-30 | 9-10, 9-10, 8-10 | 2 | 0 |
| 5 | Slugger (32) | OFF | LOSS 26-30 | 9-10, 8-10, 9-10 | 2 | 0 |
| 6 | Body Snatcher (33) | OFF | LOSS 26-30 | 8-10, 9-10, 9-10 | 2 | 0 |

With tells: 1 win, 1 draw, 1 loss. Without tells: three losses by the same 4-point margin, knocked down twice in
each. I was knocked down 8 times in these six bouts and my own knockdowns came from executed reads (bout 1 R2 b5,
bout 1 R3 b4). The tells are not decoration: **they are worth about 4 points a bout**, i.e. a whole fight.

The single most important thing I learned, and the reason my answer is "yes, but not like this":
**a hand that punches is held HIGH in the other moments, so a tell that names his punch family also names the line
he has just left open.** The tell is therefore not a hint, it is the answer - for defence every time, for offence
whenever I could also guess the moment. Following the tell blindly made me nearly unhittable: the Jabber scored 1
point in round 1 and 2 in round 3 of bout 1 while I took every round, and in bout 3 R2 beats 2-4 I took zero damage
across three beats by setting my guard straight off the word "knees".

Underneath that, three mechanical things decide these fights and none of them is the opponent's intention: **the
knockdown is a heal** (I went down at 1-3 health six times and got back up on 6 with a full stamina bar), **the
clinch erases a paid beat for free** (7 of mine, 6 of his; one erased the punch that would have finished bout 1),
and **Long is a corridor** where the only punches that reach are 1-damage pokes (all six bouts spent whole beats
trading jabs, and that is where I stopped caring).

## NOT SURE

- **Pictures, pace, sound, the order strip: unjudged.** I played in words. I never saw how a tell is drawn, where
  it sits on his card, or whether the ledger is readable at a glance. My answer to the owner's question is about
  the *information*, not about the look of it.
- **I never saw two of the three lie rules fire.** Jabber 18 tells, 18 true, 0 fakes. Slugger 18 tells, 18 true,
  0 fakes. Body Snatcher 18 tells, 13 true, 5 fake - and all 5 fakes were the "knees bend" cue. Kalli's design says
  the Jabber fakes his shoulder drop when he is ahead on health and the Slugger holds instead when his stamina is
  <=3; in my bouts the Jabber was behind on health almost throughout and the Slugger's low-stamina beats showed
  "knees" or "foot", not a shoulder. So "find each man's lie" was not testable in three bouts - I could not tell
  whether the other two rules exist.
- **Whether the feint's "draws his hands" changed my numbers.** The log credits it ("the feint drew his hand") but I
  cannot see what it removed.
- **What my own tells would have shown him.** I played one side of a two-sided system.
- **The AI's intent when the log is silent** (a feint that drew nothing, a step "already Inside, nowhere closer").
- **Whether the no-tells losses are the AI being better or the habit-read rule punishing me.** Bout 1 (with tells)
  and bout 4 (without) are different seeds, so not a clean A/B.

## 2. JUDGED ON FUN (each point with bout, round, beat)

### The three best moments
1. **Bout 1 (Jabber, tells) R2 beat 5 - the knockdown built out of three separate reads.** He was on 2 health; his
   lead hand had not been held low once in 11 beats, so his body was the open line; and his beats open with a lead
   punch, whose hand is out of guard at moment 1. I threw the rear body cross at moment 1. Log: "Body cross - lands
   (his lead hand was held high): -2 health, 1 point ... HE GOES DOWN ... a man who goes down throws nothing more
   that beat" - so the loaded cross he was sitting on never happened. Three reads stacked into one beat and all
   three were true. That is the game at its best.
2. **Bout 1 R3 beat 4 - the feint that finished the argument.** He blocks well (he had blocked my cross three times
   by covering straight), so I stopped attacking the block and attacked the cover: feint, then overhand. Log:
   "feints - the next punch cannot be covered ... Overhand - lands (the feint drew his hand): -4 health, 2 points
   ... HE GOES DOWN and gets up on 4 health." Second knockdown, "ONE MORE ENDS IT". It read as a plan, not a roll.
3. **Bout 3 (Body Snatcher, tells) R1 beat 5 - punishing the loaded hand.** Tell: "his rear shoulder drops back".
   A loading rear hand is held high in every other moment, and a high rear hand cannot cover the under line. Log:
   "Cross - blocked by your lead hand, held high. Rear uppercut - lands as a counter (his rear hand was out,
   throwing its Cross): -5 health, 2 points." Four damage plus the counter, from one sentence of his own body.

Honourable mention: bout 2 R2 beat 6, the hook that landed because he was broke and holding both hands high with
his rear low ("Lead hook - lands (his rear hand was held low): -3 health, 2 points"), which won the 10-8 round that
made the draw.

### The three dullest moments
1. **The Long corridor. Bout 4 (Jabber, no tells) R2 beats 1-2, and again bout 5 R3 beats 1-2.** Two beats in a row
   of "1 Jab ... 1 Jab" - 1 damage each, 1-1, nothing else in range on either side (hook, cross, overhand and
   uppercut all reach Inside/Mid only). Nothing is worth doing at Long, and the round's first beat is always Long,
   so every round in every bout opens with this.
2. **The blind cover beats: bout 5 R3 beat 6 and bout 3 R3 beat 6 ("no action - lead hand low, rear hand low").**
   With no tells I have to cover two of his four lines blind, so the correct play is to throw nothing and hope; the
   beat contains no decision at all. I played "no action" 9 times in the no-tells bouts.
3. **The clinch. Bout 1 R3 beat 6:** he was at 4 health, down twice, facing the feint-overhand that had just
   knocked him down - and he clinched. Log: "HE: clinch ... ties you up - no punch lands". The beat, and the
   4 stamina I spent on it, simply ceased to exist. Same in bout 2 R1 beat 6. It is the only action in the game
   whose effect is "delete the beat", and both men can use it for free.

### A beat that felt unfair / could not be explained from what was shown
- **The pull counter, bout 4 (no tells) R1 beat 1.** He backed off at moment 1 and his 1-damage body jab landed for
  **-3 health**: "Body jab - lands as a counter - off the pull, +1". The help text puts the pull counter under
  `feet=back` as *my* bonus ("Your next punch this beat is a pull counter: +1 if it lands"); nothing on my screen
  said he had bought one, and I could not have known from his last three beats. It is the only log line in six
  bouts that made me feel the game had taken something I could not have defended.
- **The invisible step, bout 5 (no tells) R3 beat 3.** From Mid he stepped to Inside at moment 1 and both his
  uppercuts landed, -7 health, "YOU GO DOWN". With tells I would have read the step; with his last-3-beats panel I
  saw only "Body cross - lead hand low". The range change is the single most valuable thing to know and it is
  exactly what the no-tells game hides.
- **His habit-read was invisible.** Bout 1 R2 beat 1: after I stepped in on beats 1-3 of round 1, he answered by
  stepping in himself and digging my body for -4 ("Body jab ... Body cross ... stamina bar 7"). The rule exists
  ("HE READS HABITS" is in the help) but the log never says "he answered your last three beats", so I could only
  explain it because I had read the S558 report afterwards.

### Is "which line is open" a READ or a coin flip?
- **With no tells: a coin flip, and a costly one.** My only information was his last three beats plus per-round
  hand counts. That gave me one genuinely good read (bout 4 R3 beat 4-5 and bout 6 R3 beats 2-5: his lead hand is
  never held low, so the body is open - my body cross landed five times for damage, points and stamina off him).
  Everything else was a guess and half of my guesses were blocked ("Cross - blocked: his lead hand was still up",
  five times) while his landed as counters. I was knocked down 6 times in the three no-tells bouts.
- **With tells: a read, and usually a solved one.** The tell names his punch family; a punching hand guards high in
  the other moments; so the guard works out and the open line often works out. Measured over my own logs: I
  took no damage at all in 34 of 51 beats in the cue bouts (67%) against 28 of 51 in the no-cue bouts (55%) -
  a smaller gap than the results suggest, because in the no-cue bouts I simply covered blindly and threw
  nothing. The genuine coin flip that survived is *which moment* he acts in - and that

### A plan that is right every beat, a switch I never wanted, a range where nothing is worth doing
- **Right every beat: "lead low, rear low" against a body/uppercut tell at Inside.** Bout 3 R2 beats 2-4 and R3
  beat 6, bout 5 R3 beats 4 and 6: his named families are exactly the two lines those two held hands shut, so it
  cannot lose. It is also the most boring correct answer in the game: the whole beat is decided before I choose.
- **A switch I never wanted: the push off.** I threw it zero times in 180 beats. Its only jobs are Inside-only
  (send him to Mid) and stopping his clinch - but the clinch is free for him, so paying 1 stamina to cancel one
  is worse than the clinch is for him.
- **A range where nothing is worth doing: Long.** Only the jab and body jab (1 damage each) reach; hooks, crosses,
  overhands and uppercuts are all Inside/Mid. Bout 4 R1 beat 3, bout 4 R2 beats 1-2, bout 5 R3 beats 1-2, bout 6 R3
  beat 6 were all 1-damage pokes 4 to 6 beats per bout. Both men also have every incentive to be there, because
  the man who steps in pays stamina to arrive.

### Each opponent: a different man? does reading him pay?
- **Jabber - a different man, and the best-designed.** With tells I beat him 30-27 and knocked him down twice
  (bout 1); without them I lost 26-30 and ate 2 knockdowns (bout 4). Sharpest habit: he answers your step-ins by
  coming in under them with the body hook (bout 1 R2 beat 1), and he holds his lead hand low when he is moving,
  which is the read that beat him twice (bout 1 R2 beat 5).
- **Slugger - a different man, and the one I could not solve.** 21 health, walks in, throws with both hands, and
  his guard is genuinely open in the moment he throws - I won a 10-8 round off it (bout 2 R2) and still only drew,
  because he deals 3-4 a punch and my answer is 3. He clinched when hurt twice. Reading him paid less than reading
  the other two: 1 draw with tells, a loss without.
- **Body Snatcher - a different man, and the most punishing.** He digs the body with both hands, and every landed
  dig cuts my stamina bar for good: my bar went 8 -> 7 -> 6 -> 5 -> 4 (the floor) across bout 3, so from round 2 on
  I could never pay for two big punches in one beat. With tells I could still lose 27-30 while giving him nothing
  in the last three rounds. Without tells, 26-30. His fake is also the only lie I ever saw: "knees bend" 5 times
  turned out to be a step or nothing.
- **Too hard or too easy?** None is too easy: I never beat the Slugger or the Body Snatcher. The Jabber is winnable
  with tells and only with tells (30-27 with, 26-30 without, same man, different seed).

### Do rounds 2 and 3 play differently from round 1; do knockdowns, ropes and the stamina bar change what you do?
- **Round 1 is the feeler, round 3 is a knife-fight.** Round 1 is where I probed at Long and learned his guard
  (bout 1: 10-9; bout 4: 9-10). From round 2 the tells start paying (bout 1 R2 was my best round: 5-2 with a
  knockdown, "HE GOES DOWN"). By round 3 health is already spent - I entered round 3 of bout 4 at 1 health and of
  bout 6 at 1 health - so round 3 is where I stopped attacking and started covering (bout 6 R3: cover beats and
  clinches, 1-6 on points).
- **Knockdowns changed everything, wrongly.** Being knocked down is the best thing that can happen to a tired
  fighter: bout 4 R2 beat 5 I went down at **1 health** with my bar cut to 5 and came up on 6 health with a full
  bar; bout 1 R2 beat 5 I knocked the Jabber down at 2 health and he got up on 6. From bout 4 R2 onward I stopped
  treating 1-2 health as fatal, because a knockdown would heal me. That is a design leak, not a drama.
- **The ropes were the one positional rule that changed my plan.** Bout 1: I spent beats 3-5 of round 1 buying his
  back-offs (step in plus a cheap jab) until he was ON THE ROPES at 2/2 - and because he could no longer flee, my
  hook landed at Mid for the rest of the round (10-9). Bout 4 R2, same trick, and he wasted his last ground backing
  off when already at Long. Good rule, and the AI misplays it.
- **The stamina bar is the real clock.** He spends 4-6 a beat, so by mid-round he is at 2/8 holding both hands home,
  which is when my hook lands for free (bout 2 R2 beat 6, bout 3 R1 beat 5, bout 5 R3 beat 4). The Body Snatcher
  cut my bar to its floor of 4 across bout 3, and I could feel the game close: I could no longer afford a feint
  plus a punch in one beat.

### WITH TELLS: did I follow them? did I find each man's lie? was catching one good, or is it a sum?
- **His first action is a coin flip, and that is the thing no cue ever fixed.** Over my three cue bouts his
  opening action was a lead punch 20 times, a step or a back-off 20 times, a rear punch 11 times and a clinch 3
  times - so "guess moment 1" is a one-in-three chance. That is why my best beat of the six (bout 1 R2 beat 5) came
  from reading his health and his hand history rather than his order.
- **I followed them on essentially every beat.** They were the first thing I read and they set my switches before I
  thought about his habits.
- **I found one man's lie, and the game told me.** Bout 3 R1 beat 4: "HIS TELL WAS A FAKE: he showed 'he bends his
  knees and his level drops' - his beat would have shown 'his front foot creeps forward'." That was the first lie
  in 24 tells; I had set my lead low for a body punch he never threw and my cross was blocked for it. The Body
  Snatcher faked that one cue 5 times in 18 tells (his foot and shoulder cues were 6/6 true); the Jabber (18) and
  the Slugger (18) never lied once.
- **Did catching a lie feel good?** For one beat, yes: bout 3 R1 beat 5, where I stopped trusting the body read,
  used his rear-load tell instead and landed the rear uppercut for -5 and 2 points. But the ledger line that taught
  me the lie arrived at the bell of the round it belonged to, and by then that round was 1-7 gone. Real
  information, late.
- **Did the tells turn a beat into a sum with one right answer?** For defence, mostly yes, and that is the honest
  finding: when the cue names a family and his other hand is accounted for there is one correct guard and it is
  arithmetic - bout 3 R2 beats 2-4 were three such beats and I took 0 damage across them. For offence, no: the
  moment he acts in is still unknown, and every punch of mine that was blocked died on that. So the cue removes the
  defensive decision and leaves the offensive one, which is backwards from what a read should feel like.

## 3. THE OWNER'S QUESTION: should the game show the opponent's intention before you choose?

**Pick (b): one body tell, usually true, as in my tells-on bouts - with four fixes, or it will eat the game.**

**(a) His whole plan shown before you choose (as a card game shows an enemy's next move) - no.** Beat that proves
it: **bout 3 R2 beat 2.** Cue "knees bend"; he was at 9 health, I was at 2; his beat was "Body jab, Body cross,
Step in". I played lead low plus rear low and took **zero** damage while he spent 3 stamina, because both lines he
was going to use are shut by two held hands. Now show me his *whole* plan - three switches and the order - and that
beat is not a decision, it is a form to fill in: I would know his moments, so I would not merely defend, I would
place my punch in the one moment his hand is off its line and take his health for free. Bout 1 R2 beat 5 is the
proof that this is already nearly true with one cue: three reads (his health, his lead hand's history, and the
moment order I inferred from his habits) put him on the floor. Give me all three switches and there is no inference
left. A card game can show the enemy's move because it is about resource management; here the whole skill is the
inference.

**(b) One body tell, usually true - yes, this is the right shape.** Beat that proves it: **bout 2 R3 beat 5** - cue
"his rear shoulder drops back (cross or overhand)", at Mid, both of us on 6 health. His two possible punches are
exactly the two lines my two high hands cover, so I weighed covering both against spending my rear into the line
his own load opens, played the hook, and got both: "Lead hook - lands (his rear hand was held low): -3 health, 2
points ... Lead hook - blocked by your rear hand, held high". One cue, one real decision, 2 points.
**What has to change for (b) to be worth keeping:**
1. **The cue must be an odds, not a verdict.** 36 of my 54 tells were true, with zero fakes from two of the three
   men. A cue that never lies is an oracle: in bout 1 I ran six beats of round 1 and eleven of the bout at almost
   no risk on the strength of it. John's brief says experts call the punch 83-96% of the time when they see the
   video core and 20-23% when it is cut 80 ms early - a lean. The game should feel like the lean.
2. **The fake must be findable inside the round it happens.** The ledger is the right screen, but in bout 3 the
   round that taught me the lie (round 1, two fakes) was already lost 9-10 by the time the line printed.
3. **A cue must cost the man who shows it.** As Kalli designed: a big punch shown by a cue hits full, the same
   punch thrown hidden hits 1 weaker, a fake costs stamina. Without a cost, reading is free and hiding is free, so
   every beat becomes "show me, I will cover it".
4. **Keep the moment secret.** That is the part that stayed a genuine read in all six bouts, and it is why beat 6
   of a round still decides fights.

**(c) As it is now (his last three beats and his hand counts, nothing about the beat to come) - no, and this is
the incumbent.** Beat that proves it: **bout 4 R3 beat 6** (no tells), last beat of the bout. I had his three
previous beats and his hand counts, and I reasoned "his beats open with a lead punch, so the straight is open at
moment 1" - my cross was blocked ("his lead hand was still up") while his body cross landed on my 2 health and put
me down. Three beats of history told me what he *had* done, and nothing about what he was doing. Same man with
tells (bout 1) I beat 30-27. What (c) does well is the hand counts: "his lead hand held high 0, held low 0, thrown
5" is the best read on the screen and it earned me my whole body game (bout 4 R3 beats 3-4, bout 6 R3 beats 2-5).
So (c) is half a read, and the half it is missing is the half that decides.

**So: (b), with the four fixes.** It is the only one of the three that gave me both a decision and a mistake.

## 4. SCORES (1-10, one line each; scored on what I actually played)

**WITH TELLS (bouts 1-3: win, draw, loss)**
- FUN 8 - the tells made every beat a choice and the one fake I caught made me sit up; only the Long corridor and
  the free clinch cost it points.
- DEPTH 7 - one cue hides three moments, so offence stays a real read; but defence collapses into arithmetic the
  moment the cue arrives, and that caps it.
- CLARITY 8 - the log explains every beat, down to "his lead hand was still up (its Body hook comes in moment 3)";
  only the moment order is fog.
- VARIETY 6 - four cues, three men and a per-man fake is real variety, but my own kit collapsed to three shapes:
  cover the named family, feint then a big punch, dig the body.

**WITH NO TELLS (bouts 4-6: three losses by the same margin)**
- FUN 3 - the first beats of every round are 1-damage jab trades at Long and the rest is blind covering; the only
  fun left was the one read I could still make (his lead hand is never low).
- DEPTH 3 - his last three beats are history, not information; two of my three knockdowns came from a punch I
  could not have anticipated from anything on screen.
- CLARITY 6 - the log is as clear as ever, but the pre-beat screen says nothing, so clarity collapses exactly when
  I need it: I could explain every loss afterwards and none of them before.
- VARIETY 3 - my play reduced to "cover two of four lines blind" and "jab at Long"; I threw no feint and no push
  off in these three bouts.

**What I could NOT judge from words:** the look of a tell (body language or a caption?), where it sits and whether
it reads at a glance before a 2-second beat; pace and sound; the order strip; the tell ledger's layout; and whether
the drawn screen below is close to what the page looks like today.

## 5. TO REACH 10/10 (most important first, each tied to a beat I played)

1. **Stop the knockdown from being a heal.** Bout 4 R2 beat 5: I went down at 1 health with my bar cut to 5 and
   came back on **6 health and a full bar** - a reward for losing a beat. Bout 1 R2 beat 5: I knocked the Jabber
   down at 2 health and he got up on 6, *more* than he had. Fix: getting up returns you to a fixed low number (4),
   never more than you had before the knockdown, and never refills the stamina bar. Until this is fixed the correct
   play at 1 health is to walk into a punch, which is what I found myself doing from bout 4 onward.
2. **Price the clinch.** Bout 1 R3 beat 6: he was at 4 health, down twice, and the feint-overhand that had just
   floored him was deleted by "he clinches - no punch lands". Fix: the clinch costs the man who takes it (loses his
   next beat's first moment, or pays stamina instead of gaining it, or needs an intact guard). It must not be a
   free delete of the other man's paid beat. I clinched 7 times myself once I saw how free it was.
3. **Show the moment, not just the punch.** Every blocked punch of mine died on "his hand was still up, its punch
   comes in moment N": bout 4 R3 beat 6, bout 5 R1 beat 1, bout 2 R1 beat 4, bout 2 R2 beat 2. Fix: print one
   timing fact with the cue ("his lead hand acts late in the beat"), or resolve equal-speed exchanges by the written
   order and say so. This is the read I actually wanted and the page never gave it.
4. **Put something worth doing at Long.** Bout 4 R2 beats 1-2 and bout 5 R3 beats 1-2: two straight beats of
   1-damage jab trades, because every big punch reaches Inside/Mid. Fix: one long-range punch that scores (a
   straight right worth 2 at Long), or make `feet=in` free, or start rounds at Mid. Right now the safest range and
   the dullest range are the same range, and every round opens there.
5. **Promote the hand counts into the read the game is about.** The best thing on my screen was "THIS ROUND: his
   lead hand held high 0, held low 0, thrown 5", which let me call the body open and land body crosses in bout 4 R3
   beats 3-4 and bout 6 R3 beats 2-5. Fix: show his held-hand position by *range* as well ("at Inside he keeps his
   rear hand low"), so "which line is open" is answerable without a cue.
6. **Make the fake conditional and visible, per Kalli's design.** His knees cue was 5 true / 5 fake, and both times
   it burned me I had no way to know (bout 3 R1 beat 4: I set low for a body punch and he stepped in instead).
   Fix: tie each man's fake to a state I can see, print the rule ("he fakes when he is behind on health", "he fakes
   after you block his body"), and run the true/fake count from beat 1 rather than at the bell.
7. **Give the tell a cost, so following it is a trade.** Bout 1 (18 true cues) I won 30-27; bout 4 (the same
   opponent, no cues) I lost 26-30. Fix: a big punch shown by its cue hits at full damage, the same punch thrown
   hidden hits 1 weaker, and a fake costs stamina - so the cue is information the man on the other side can price.
8. **Tell me when he answers my habit.** Bout 1 R2 beat 1 (he stepped in under my step-ins and dug my body for -4)
   and bout 3 R2 beat 5 (he dropped his lead low the exact beat I dug) are the "he reads habits" rule firing, and
   the log says nothing. Fix: one log line, "he answered your last three beats", so the rule is learnable by
   playing instead of by reading the design doc.
9. **Give the push off a second job, or drop it.** I threw it 0 times in 180 beats: Inside-only, and its other use
   is cancelling a clinch that currently costs him nothing. Fix: let it cost him guard or stamina, or let it work
   from Mid, so the Inside game is not just "dig or clinch".
10. **Keep the fake, keep the ledger, keep the per-man lie rules.** The one thing that made the cues feel like a
    read rather than a caption was "HIS TELL WAS A FAKE" (bout 3 R1 beat 4), and the bell ledger that followed it.
    They just need to arrive in the round they belong to.

## Drawn 10/10 screen

`ten.html` (1920x1080, beside this report) is my 10/10 fight screen: both men's health, stamina and guard; his hand
map by range (the read I actually used); the cue as one body line with its running true/fake count for the bout
(fix 6); a moment hint on his card (fix 3); the clinch priced on screen (fix 2); and my three switches with cost
and reach printed under them. Rendered to `ten.png` with `tools/render_mockup.py`.
