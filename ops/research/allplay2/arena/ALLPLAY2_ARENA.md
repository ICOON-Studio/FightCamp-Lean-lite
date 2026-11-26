# ALLPLAY2_ARENA: Ring Switches played six times, tells on first (seat arena, 2026-11-26)

Shell seat. I played six bouts through `node proto/twohands/tools/play_cli.mjs`, in the order the launch message gave:
TELLS ON first (T1 Jabber seed 41, T2 Slugger seed 42, T3 Body Snatcher seed 43), then NO TELLS (N1 Jabber seed 31,
N2 Slugger seed 32, N3 Body Snatcher seed 33). I decided every beat myself, and wrote one line of WHY before it
(`why_t1.txt` ... `why_n3.txt`: the WHY line, then the tool's own output). The only helper was a two-line wrapper that
appended my WHY to that file before it ran the beat; it chose nothing. I read `order.html`, `tells.mjs`, the tools'
code and the prior research only after the sixth bout ended. State files and logs: `t1.json` ... `n3.json`, and
`*.json.log.txt`.

| Bout | Opponent | Tells | Result | Cards | Knockdowns |
|---|---|---|---|---|---|
| T1 | The Jabber, s41 | on | WIN | 29-28 (10-9, 9-10, 10-9) | none; I finished on 1 health |
| T2 | The Slugger, s42 | on | WIN | 30-25 (10-9, 10-8, 10-8) | him once (R3b6) |
| T3 | The Body Snatcher, s43 | on | WIN | 29-27 (10-9, 9-10, 10-8) | him once (R3b4) |
| N1 | The Jabber, s31 | off | WIN | 28-27 (10-9, 8-10, 10-8) | me once (R2b6), him once (R3b5) |
| N2 | The Slugger, s32 | off | LOSS | 26-30 (9-10, 8-10, 9-10) | me twice (R2b5, R3b3) |
| N3 | The Body Snatcher, s33 | off | WIN | 30-26 (10-9, 10-9, 10-8) | him once (R3b1) |

Counted from the logs:
- **His punches that landed on me:** 17 landed and 29 blocked with tells on; 27 landed and 15 blocked with tells off.
- **My punches:** 23 landed, 13 blocked, 6 short with tells on; 20 landed, 11 blocked, 6 short with tells off.
- **Tells:** 45 true and 9 fake out of 54 (83% true): T1 12/6, T2 17/1, T3 16/2.

## VERDICT

**Keep ONE body tell (way b). It made the game better for me, and it mostly made me better at DEFENCE, not at
hitting.** With tells I was never knocked down and won all three bouts. Without them I was knocked down three times and
lost to the Slugger, even though I played the no-tell bouts SECOND, knowing the rules better. My hit rate barely moved
(23 landed with tells, 20 without). What changed was his: 17 landed with tells, 27 without. So the tell answers "which
of my four lines do I close", and that is the decision the game asks you to make blind today.

**The tell is only good while it can lie.** The Jabber bout (6 fakes in 18) is the best bout I played: I spotted his
lie in R3b2 and used it to survive R3b4-b6 on 2 and then 1 health, winning 29-28. The Slugger bout (1 fake in 18) turned
into a lookup table by round 2:
- shoulder drop -> both hands high;
- knees -> both hands low;
- foot creeps while already Inside -> a free punch (R2b3, R2b5).

I won its last two rounds 10-8, 10-8 on that table, and it was the dullest bout of the six.

**Do not show his whole plan (way a).** In this game, two hands cover four lines and the order decides who lands
first. With his plan in view, every beat I played has one correct answer that I could work out by sum: T2 R2b5 would
just be "he holds low/low, so hook plus body cross". Nothing would be left to read.

**Way c (as now) is a read about half the time and a coin flip the other half.** Reading his last three beats paid
against the Body Snatcher: he keeps his lead low, so the cross landed in N3 R2b5. It failed against the Slugger, whose
hands change every beat (N2 R1b3, R1b4, R2b3: three lines picked, three blocked). That is the bout where I stopped
caring (N2 R2b6).

## NOT SURE
- **Seeds and order are mixed up with tells.** Tells-on used seeds 41-43 and tells-off used 31-33, so "tells helped my
  defence" rests on six bouts and different seeds. Tells came first, so my rules knowledge grew during the tell bouts.
  That would favour the no-tell bouts, yet they went worse. I still can't separate luck from the tells.
- **I never saw a picture.** Whether "knees bend" can be read off a 3D pose in under a second, and whether a human holds
  the ledger in their head, can't be judged from words.
- **I worked out the "punching hand is held high in the other moments" rule by being hit** (T1 R2b4, T1 R2b5,
  T3 R1b2, N2 R1b2). A human might never work it out. I may be marking CLARITY too high because I eventually did.
- **The habit reader ("same plan in two of your last three") never visibly fired on me.** I avoided repeats on
  purpose from T2 on, so I can't say how strong it is.
- **I guessed two of the three lie rules only half right before reading `tells.mjs`** (details in section 2). I can't
  say whether a human would find them faster or slower.

---

## 2. JUDGED ON FUN

### Three best moments
1. **T1 R2b1, feint then overhand off his shoulder tell.** It was a shoulder drop at Long, so he had to step in to
   throw. My feint drew his hand, the overhand went in uncoverable, and his cross was blocked by my lead coming back up.
   It landed as a counter: 5 damage, 2 points, his health 12 to 7. The tell said WHAT, I chose WHEN, and the order rule
   paid. This is the game at its best.
2. **N1 R3b5, a knockdown on the ropes to turn a lost bout around.** I needed a 10-8 in round 3 with a stamina bar cut
   to 4. I stepped in, and so did he. His body jab was "smothered, too close at Inside", my body cross landed as a
   counter, and he went down. Then I clinched the last beat. 28-27. That came from reading his position (on the ropes,
   2 health, no back off left), with no tell.
3. **T1 R3b4-b6, surviving on 2, then 1 health once I'd caught the Jabber's lie.** He showed a shoulder drop five times
   in round 3 and all five were fake. In R3b6 I backed off with both hands high: his jab was blocked and his body cross
   fell short. Won 29-28. Catching the lie felt really good.

### Three dullest
1. **Clinch beats.** In T1 R1b3 his clinch ate my double body attack and the 4 stamina I paid for it. My own
   last-beat clinches locked a won round with no risk (T3 R1b6, N1 R3b6, N3 R3b6). Each one was right and boring.
2. **Wasted AI beats at Long.** "Back off - already at Long, nowhere further", then a body cross that falls short:
   T2 R1b3, N2 R2b1, N2 R3b1, N3 R1b1. Also a push at Mid: "a shove at nothing" (T2 R3b4, N2 R3b5). Nothing happens and
   nothing can be read from it.
3. **Foot creeps while he's already Inside = a free punch.** T2 R2b3 and R2b5, T3 R1b5. It's a sum, not a read.

### Beats that felt unfair, or that what was shown couldn't explain beforehand
- **N1 R2b6: a jab knocked me down.** It was "off the pull, +1" from his back off, so 2 damage on my 2 health.
- **N3 R2b6: his jab did 3 damage.** That was +1 off the pull and +1 as a counter, because my cross had fallen short.
  The tool explained both afterwards, but nothing on screen warned me beforehand that a jab could do 3.
- **N2 R2b4: I clinched at full stamina, he pushed me off and stepped in for a rear uppercut (4).** This was fair,
  since push beats clinch both ways. I only knew that because I'd used it on him.
- **T3 R2b2: the knees tell hid a lead hook.** The cue shows one thing, so the hook in the same beat was invisible. It
  was fair, but low/low looked "fully covered" and wasn't.

### Is "which line is open" a READ or a coin flip?
- **No tells:** a read when he has a habit with his hands, a coin flip when he doesn't.
  - The Body Snatcher keeps his LEAD LOW: the straight landed in N3 R2b5 and N3 R1b4.
  - The Slugger's hands this round split 1-1, so I guessed at N1 R1b5 and N2 R1b3, R1b4, R2b3, and lost those guesses.
  - The useful rule I found is structural: a hand that punches later is held HIGH until then. So against a man who
    throws both hands, the BODY is open all beat (body cross landed in T1 R1b6, T2 R3b5, N2 R3b3, N3 R1b2).
- **With tells:** a read every beat. The tell tells me which line to CLOSE. Which line to HIT is still the hand-habit
  read, plus timing. A fast hook in moment 1 beats a rear punch loading in moment 1: T2 R3b3, T3 R1b3, N1 R1b2.

### A plan that's right every beat, a switch I never wanted, a dead range
- **Feint then cross (or overhand)** was my plan in 16 beats and landed 11 times. All five failures were a back off
  (T1 R3b2, N1 R1b4, N2 R3b1, N2 R3b5) or a hook in the same moment (N2 R1b6). "Step in, feint, cross" fixes the back
  off, because the step in wins. It landed 4 of 4 (N1 R3b3, N3 R2b1, R3b1, R3b5). That is close to a solved opener,
  as the S558 playtest found.
- **Push off Inside** beat his clinch every time I read one coming (N2 R1b3, N3 R1b3). It also moved us to Mid, where
  his uppercut fell short (N3 R2b2). Push then body cross is close to always right against a spent man Inside.
- **Switches I never wanted:**
  - rear uppercut: 0 times in 108 beats;
  - lead uppercut: once (T3 R1b5);
  - body hook: once.
  The uppercuts only reach Inside, and Inside is where clinch and push decide the beat.
- **Dead range: Long.** Only the jab and body jab reach, so every beat at Long is either a 1-point trade or "step in
  first". The best Long beats were all about him arriving at Mid.

### Each opponent
- **The Jabber is the most different.** He backed off 6 and 9 times, and the ropes and the back-off tiebreak came up
  in every round. Right difficulty.
- **The Slugger isn't the man the help describes.** "Walks in" and "overhands and hooks at Mid" were true in places,
  but he opened rounds by backing off at Long (N2 R2b1, R3b1). With tells he was easy (30-25). Without them he beat me
  26-30, because his hands change every beat and give you nothing to read.
- **The Body Snatcher has a readable habit** (lead home low) and a body attack that shrinks your stamina bar.
- **All three use the same three-moment template:** step in, then a lead punch, then a cross or body cross.
  T1 R1b2, T2 R2b2 and N2 R1b2 are almost the same beat against different men.
- **Reading pays most against the Body Snatcher, least against the Slugger.**

### Do rounds 2 and 3 play differently?
- **Yes, through damage and the stamina bar.** Body shots that land cut your bar for the rest of the bout. In N1
  R2b3-b4 two body shots took my bar from 7 to 4, and from then on I had one 2-stamina punch a beat. That is the
  biggest swing in the game, and it's mostly invisible until it has happened.
- **A knockdown HEALS you.** It sets health to 6, then 4. In N1 R2b6 a knockdown took me from 2 health to 6. It's an
  odd reward for being dropped.
- **The ropes matter through the tiebreak.** Four rounds went to "level on points: backed off less" (T1 R1, T2 R1,
  N1 R1, N3 R1). The AI backs off far more than I do (29 times against my 5), so ties are nearly always the player's.
- **The guard bar dipped to 5/6 a handful of times and never changed a decision.**

### WITH TELLS: did I follow them, find the lies, and was it fun?
- **I followed the tell almost every beat.** The two times I forgot that knees can mean step in then uppercut, it
  cost me 9 health in T1 R2b5 and 4 in T3 R1b2.
- **The Jabber (T1): lie found in R3b2.** That was the third shoulder drop in a row, and every one after R2b6 was fake.
  Before reading code I wrote "he fakes the shoulder once I'm hurt". The real rule (`tells.mjs`) is "a fake shoulder
  when he is ahead on health". In R3b5, at 2 health against 2, his tell came back true, as that rule predicts. It was
  learnable in one bout.
- **The Slugger (T2): one fake (R3b4)**, the shoulder shown while he pushed and backed off on 2 stamina. The real rule
  is "tired (3 stamina or less) and holding -> shoulder". One sample isn't enough to learn from.
- **The Body Snatcher (T3): fakes in R2b6 and R3b5**, both times knees shown while the real punch was a CROSS.
  - R2b6 cost me the round.
  - In R3b5 I was already suspicious and backed off, so the cross fell short.
  - I found WHAT he hides (the cross) but not WHEN. The real trigger is "the beat after you blocked his body punch". The
    on-screen ledger shows counts only, not the situation, so the trigger is hard to see.
- **Did catching a lie feel good?** Yes, every time (T1 R3b4-b6, T3 R3b5). It was the best feeling in the trial.
- **Did tells turn a beat into a sum?** With the Slugger, yes. In T2 R2 every beat was a table lookup.
- **No feedback loop (as the task notes):** his AI doesn't know I read him, and faking costs him nothing. That made the
  honest man (the Slugger) a solved puzzle, and only the liars stayed interesting.

---

## 3. THE OWNER'S QUESTION: should the game show the opponent's intention before you choose?

**(a) His whole plan shown, as card games show the enemy's next move: NO.**
- Card games can show intent because the player has more answers than the enemy has moves (a hand of cards, block
  values, energy). Here my answer space is small:
  - two hands guard four lines;
  - three moments;
  - the faster punch lands first.
  With his plan in view each beat becomes a sum with one answer.
- **Proof from my play, T2 R2b5.** Even one honest tell ("foot creeps", while already Inside) told me he would throw
  nothing. "Hook into his low rear, then body cross" was obvious and landed for 2 points. A full plan would make every
  beat like that. The simultaneous reveal, which gives the game its tension, would be gone.

**(b) One body tell, usually true, with one learnable lie per man: YES, pick this.**
- **Proof, T1 R2b1 and T1 R3b6.** In R2b1 the true shoulder tell told me WHAT, and I still had to pick WHEN: a feint in
  moment 1 and the overhand in moment 2, for 5 damage. In R3b6 I knew his shoulder tell was the lie, kept both hands
  high and backed off, and survived on 1 health.
- **It answers the owner's "more traditional card games" wish halfway.** You see something about his next beat, and
  you still play a guessing game about the moment and the hidden other hand.
- **Blind, his punches landed 27 times; with the tell, 17.** I got knocked down 3 times without it and never with it.

**(c) As now: his last three beats and what his hands did this round. Keep it AS WELL, not instead.**
- **Proof, N3 R2b5.** "Lead held low 2 of 2" was a real read: the cross landed for 2 points. It is the layer that tells
  you which line to HIT, where the tell tells you which line to CLOSE.
- **Alone, it left N2 as three wrong guesses in a row and a lost bout.**

**What has to change for (b) to work:**
1. **Every man has to lie often enough to matter.** The Slugger's 1 fake in 18 made him a lookup table. Aim for
   roughly 1 in 5 for every man, each lie still tied to ONE visible state.
2. **Show the state each fake was tied to on the bell ledger.** For example: "knees: 2 fakes, both the beat after you
   blocked his body punch". Without that, I found WHAT the Body Snatcher hides but not WHEN.
3. **Close the free-information holes.** "Foot creeps" while he's already Inside must not mean "no punch" (T2 R2b3,
   R2b5, T3 R1b5).
4. **Give the tell a cost or a feedback loop.** Faking costs a stamina, or an honest big punch hits harder (Kalli's
   brief). Then the man has a reason to be honest or to lie, and the tell becomes a duel rather than a hint.

---

## 4. SCORES (1-10, what I played)

| | FUN | DEPTH | CLARITY | VARIETY |
|---|---|---|---|---|
| **NO tells (N1-N3)** | 6: N1's comeback was great, N2 was guessing and losing, and I stopped caring at R2b6 | 7: the order, counters, pull and stamina bar make a real system; feint-cross is close to dominant | 6: counter and pull stacking (a jab for 3, N3 R2b6) and my own open lines only make sense afterwards | 6: Long is a corridor and all three men share one combo template |
| **WITH tells (T1-T3)** | 8: the Jabber bout is the best of the six; catching a lie feels great | 7: deep with a liar, shallow with the honest Slugger (lookup table in T2 R2) | 7: the cue words are plain and the true/fake line after each beat teaches fast | 7: the three lie rules make three different men to read |

**Could NOT judge from words:**
- pace, and any time pressure;
- whether a body pose (knees, shoulder, front foot) reads at a glance in 3D from the side;
- sound;
- whether a human keeps the tell ledger and his three last beats in their head (I wrote mine down);
- how the reveal animates three moments, and whether "moment 2" feels like a moment.

---

## 5. TO REACH 10/10 (most important first, each tied to a beat I played)

1. **Show MY open lines in each moment before I throw (the "line diamond" in `ten.html`).** A hand that punches is
   out in its moment and held HIGH in the others, and "high" never covers body or under. That rule cost me 9 health in
   T1 R2b5, 4 in T3 R1b2, and N2 R1b2's two body counters. Build: for each moment of my plan, four chips (straight /
   side / body / under), red or green, worked out from my switches before THROW.
2. **One body tell per beat, every man lying at a steady rate (about 1 in 5), each lie tied to one VISIBLE state, and
   the ledger saying which state.** T1 (6 fakes) was the best bout and T2 (1 fake) a lookup table. In T3 I found what
   the Body Snatcher hides but not when. Build: put the state on the bell ledger and on the tell bubble ("he lied
   after you blocked his body punch: 2 of 2").
3. **A "counter live on you" warning.** After my punch misses or is blocked, his next landed punch is +1, and +1 more
   off his back off. N3 R2b6 (a jab for 3) and N1 R2b6 (a jab knockdown) were explained only afterwards. Build: an
   amber line on my panel whenever I'm open to a counter, with the worst case in health.
4. **Show the habit meter.** "This plan: 2 of your last 3. He may answer it." I tracked it by hand from T2 on (N3 R3b3,
   N1 R3b5). Build: three rows of my recent plans, with the repeated one in red.
5. **Make the stamina-bar cut recoverable: 1 cut comes back at each bell, and it never falls under 5.** N1 R2b3-b4 (bar
   7 to 4) turned the bout into one punch a beat. Build: a cut segment drawn striped, and "1 comes back at the bell".
6. **Remove the AI's empty beats.** Backing off at Long with nowhere to go, then punching short (T2 R1b3, N2 R2b1, N2
   R3b1, N3 R1b1), and a push at Mid (T2 R3b4, N2 R3b5). Build: forbid switches that have no effect at the current
   range in his beat chooser.
7. **Close the "foot creeps while Inside = free punch" hole** (T2 R2b3, R2b5, T3 R1b5). Build: Inside, a step in is
   not a choice. His tell then comes from his hands (quiet, shoulder or knees).
8. **Break up the shared three-moment template.** "Step in, lead punch, cross or body cross" appears for all three
   men (T1 R1b2 = T2 R2b2 = N2 R1b2). Build: weight each man's combo list by his style. The Jabber jab-jab-back off,
   the Slugger overhand first, the Body Snatcher two body shots.
9. **Give Long something to do.** For example, a step in plus jab that "measures" (the next punch +1 if it lands), or a
   body jab that costs him 1 guard. Every Long beat today is a 1-point trade or a set-up (T1 R1b1, N1 R2b2, N2 R3b2).
10. **A knockdown shouldn't heal the man who goes down past where he was** (N1 R2b6: 2 to 6). Build: up on his
    current health plus 3, at most 6.
11. **Show the tiebreak live in the score area.** "Level on points? Yours: back-offs 0-2" decided 4 of my 18 rounds.

**The drawing:** `ten.html` (1920x1080). It shows T3's spot: round 2, beat 4, the Body Snatcher's knees tell with its
lie state, his card (tell ledger, last three beats as a moment grid, his hand habits), my panel (habit meter, counter
warning, clinch and ropes), the switch tray with out-of-reach switches greyed for the range, and the three-moment
timeline with my open lines per moment. **It isn't rendered:** `python tools/render_mockup.py` needs Windows and Edge
(`import msvcrt`, `msedge.exe`), and this sandbox has no browser. I checked that the HTML parses cleanly (no unclosed
tags) but haven't looked at a picture.

---

## Where my play agrees and disagrees with the prior research (read after the bouts)

**`docs/RINGSWITCH_S558.md` and `allplay1`:**
- **Agree:**
  - "the ORDER is still the best idea" (my own S558 report). My three best moments are all order beats.
  - Antigravity's loop (step in, feint, cross, then clinch) is my own N3 R3b1-b2 and N1 R3b3. I found the same
    near-solved opener cold.
  - "Long is a corridor."
  - "The guard bar means nothing to a player": it never once mattered in my six bouts.
  - The body attack shrinking your choices (my S558 b5 R2B1 and this trial's N1 R2b3-b4).
- **Disagree:**
  - "Backing off is dead": not for the AI. It backed off 29 times in my six bouts, and the back-off tiebreak decided 4
    rounds.
  - The clinch: I clinched 7 times in 108 beats and it was answered by a push once (N2 R2b4). It's still dull but
    no longer a free engine.

**`RINGSWITCH_READ_BRIEF_KALLI.md`:**
- **Agree:**
  - "you learn which hand is busy, not when": exactly how T1 R2b1 played.
  - Her case against her own design ("a player may just follow the cue every beat and do well"): confirmed. I followed
    it nearly every beat and went 3-0.
- **Lie rules against what I found cold:**
  - The Jabber's (fake shoulder when he's ahead on health): I found it in one bout, phrased as "once I'm hurt".
  - The Slugger's (tired, so shoulder and hold): seen once, too rare to learn.
  - The Body Snatcher's (fake knees after a blocked body punch): I found the what, not the when.
- **Disagree:** her costs (a fake costs 1 stamina, a hidden punch is an arm punch) aren't in the trial, and I think
  they're what's missing. Without them the honest man is solved.

**`RINGSWITCH_TELLS_BRIEF_JOHN.md`:** his top-ranked real cue is "closing the distance", the foot. In my play the foot
tell was the most reliable (true every time, all three men). It was also the source of the free-punch hole Inside, so
its meaning has to change once the range is already closed.
