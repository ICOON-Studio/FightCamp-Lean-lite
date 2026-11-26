# ALLPLAY2 - claude (Claude, shell seat) - Ring Switches with and without tells

## VERDICT
**Keep (b): one body tell, but fix three things first.** In six bouts the tells made me play better (no tells: 1 loss, 2 wins;
tells: 2 wins, 1 draw) and gave me the best beats I had. But as built, a tell is almost always true (50 of 54, and the Jabber
never lied in 18), so for most beats it became a sum with one right answer. It never showed the second half of his beat (a feint,
a second punch), and those hidden halves caused every big hit I took with tells on. Showing his whole plan (a) would turn the
fight into a puzzle that is the same every time. Hiding everything (c) works, but "which line is open" was a coin flip too often.

Results: no tells - Jabber L 27-30 (b1), Slugger W 29-28 (b2), Body Snatcher W 29-27 (b3).
Tells on - Jabber W 30-26 (b4), Slugger W 30-26 (b5), Body Snatcher D 29-29 (b6, a knockdown on the very last beat).
Tells seen: Jabber 18 (0 fake), Slugger 18 (2 fake), Body Snatcher 18 (2 fake).

## NOT SURE
- I learned two lie rules from what was on screen. Then I read Kalli's design and it matches: the Slugger fakes the shoulder when he is
  on 3 stamina or less (my guess was "at Inside"; both fakes were at Inside, on 3 and 2 stamina), and the Body Snatcher fakes the knees
  after a body punch of his was blocked (my guess was "when he really steps in"; both fakes did come after a blocked body cross). So I
  found the effect of each lie but not its cause. I never found the Jabber's lie because it never fired: I was ahead on health in every
  beat of b4, and Kalli says his lie needs him ahead.
- With 54 tells, "usually true" (93% here) may just be my seeds. The rate a player sees will depend on how the bout goes.
- The page pictures were made with beat_shot.mjs, which forces the plans. The "STAMINA -1 OF 7" in the knockdown picture may come
  from the tool, not from real play.
- Habit reading ("he may answer exactly that") stays hidden. I can't tell if he read me in b3 R2B2 or I just guessed wrong.

## 2. FUN

### Three best moments
1. **b6 R3B6** - 2-6 down, cards gone, his tell says "step in" while already Inside (I had learned that means a wasted step). Hook +
   rear uppercut, the hook drops him, and the round turns 10-9: **a draw 29-29 from a lost bout.** The knockdown worth 3 points makes the
   last beat matter.
2. **b5 R3B5** - rear-shoulder tell at Mid. Step in with my lead high and rear "still up", his overhand blocked, his jab smothered, my
   rear uppercut lands as a counter for -5. Reading, covering and countering in one beat, and the words tell all of it.
3. **b2 R3B5-B6** - 3-3, I'm on 3 health. I worked out that a level round goes to the man who backed off less (he had once, I hadn't),
   covered body + under (his uppercut was blocked), then clinched the last beat to win 29-28. A real decision about the cards.

### Three dullest
1. **Back-offs at Long that change nothing.** b3 R1B1, b2 R2B1, b2 R3B1: he "backs off - already at Long, nowhere further" and my
   punch falls short. Two players paid stamina and nothing happened.
2. **Wasted steps at Inside by the AI.** b5 R1B2, R2B2, R2B5, R3B2, R3B6; b6 R1B3, R2B4, R3B6: "steps in - already Inside, nowhere closer".
   Eight beats in two bouts where he gave me a free hit. A push at Mid (b4 R3B6, "a shove at nothing") is the same bug.
3. **b2 R1B3 and b6 R3B2: the clinch erases my beat.** In both I paid 5 stamina for a hook + uppercut and "no punch lands". b6 R3B2
   was the worst: he was on 4 health, 1 stamina, quiet guard, and the quiet tell cannot tell a clinch from standing still.

### Unfair, or hard to explain from what I was shown
- **The "still up / back up" rule** decided most beats and I learned it only by losing (b1 R1B5, b1 R3B6). A hand that punches later in
  the beat counts as held HIGH before it punches and back HIGH after. So a straight punch in moment 1 into a man who punches later is
  always blocked, and a body punch in moment 1 almost always lands (b2 R1B2, b3 R1B2, b4 R2B2, b6 R1B1). The help says one line about it.
  **The page shows it** ("His jab and cross: open in moment 2 only"), so this is a words-only problem.
- **b1 R2B6:** at 7-5 up, a body hook and a body cross off the pull put me down, and the round went 9-10. The knockdown is worth 3, so a
  round you lead by 2 can be lost in one beat. Fine as drama, but a player won't see it coming.
- **Stamina bar shrink.** In b1 his body shots took my bar from 8 to 4 by round 3, so I had 2 stamina for most of that round. Every
  opponent digs the body, so this is the strongest effect in the game, and it is permanent.

### "Which line is open": a READ or a coin flip?
- **No tells:** about half reads and half coin flips. Reads: his held hands this round (b1 R2B4-5: rear held low 3 times, so hook twice);
  a man on 1 stamina at Inside clinches (4 of the 8 times I saw it; the others were a back-off, a step and two quiet beats - so push + body cross, which is safe either way); his habit of holding the lead low
  (b2 R3B2 jab). Coin flips: whether he steps in or backs off in moment 1. That decides whether my punch falls short, lands or is
  smothered, and nothing shown predicts it (b2 R2B1, R2B3, R2B5, b1 R3B4).
- **With tells:** a read nearly every beat, because the tell removes the range coin flip (a step-in tell). But the tell names only ONE of his
  three switches. The other hand stays a coin flip and hurt me most: b5 R1B5 (overhand shown, the lead uppercut behind it hit me), b6 R1B4
  (uppercut shown, the hook landed), b4 R1B3 / b5 R2B1 (rear loading shown, a feint in front of it made the punch impossible to block).

### A plan that is right every beat; a switch I never wanted; a dead range
- **Close to right every beat:** "step in first, lead high, then a rear punch" (b4 R2B3, b5 R1B4, R2B1, R3B5; b6 R2B6, R3B1). The step uses
  moment 1 while my rear is still up for the side and my lead is high for the straight, and it beats his back-off. Against the Body
  Snatcher, "lead low + body cross" won round 1 of b3 without a hit taken. Each was broken only by a feint or a second punch I couldn't see.
- **Never wanted:** feet=back (once, b2 R2B5, a waste: both backed off and everything fell short). Overhand only once. A lead held low
  alone was a liability, since the body line needs your lead and so does the jab.
- **Dead range:** Long. Only jabs reach, both men usually leave it in moment 1, and four beats of mine ended "falls short at Long".

### Each opponent
- **The Jabber is not a jabber.** In b1 he stepped in and threw body hooks, uppercuts, overhands and body crosses; he jabbed in 5 of 18 beats.
  His blurb ("stays at Long behind the jab and backs off") misled my first two beats. Hardest of the three for me (my only loss).
- **The Slugger** walked in and hooked, and also went to the body a lot. Clinched or pushed when tired. Close to his blurb.
- **The Body Snatcher** = his blurb. The easiest: lead low shut down most of his offence (b3). With tells he was harder (the draw).
- **All three look alike** in what they throw: body cross and lead hook / lead uppercut after a step in. The difference is mostly
  health and how often they back off. Reading did pay: the "1 stamina at Inside = clinch" rule and his held-hand counts won me beats.

### Rounds 2-3, knockdowns, ropes, stamina
- Rounds 2 and 3 play differently: the body-shot bar shrink, the cards (protecting a 10-8, the level-round rule), and clinching to close.
- **Knockdowns** change everything: 3 points, and the last beat of b6 shows it is the comeback tool.
- **The ropes:** I trapped him twice (b1 R2B3, b4 R2B3, "you step in and cut him off") and both were good beats. Nobody ever backs off on
  purpose, so ground given only ever hurts the AI.
- **Stamina** is the real clock: 1-2 stamina beats are dead beats (hold, or clinch at Inside).

### WITH TELLS
- **Did I follow them?** Every beat. They were right 50 of 54 times. Following them blindly would have won me about as much as reading them.
- **Did I find each lie?** The Slugger's in **b5 R2B3** (shoulder shown, he pushed) and confirmed in **R3B4** (shoulder, he clinched). The Body
  Snatcher's in **b6 R1B3** (knees shown, he stepped in) and confirmed in **R2B1**. The Jabber's never fired (0 of 18).
- **Did catching a lie feel good?** Yes the first time. But I could never use it: when the Slugger lied he clinched or pushed, and that
  wipes out whatever I threw (b5 R3B4). A lie should leave a gap you can hit.
- **A sum with one right answer?** For the true ones, yes. "Rear loading" means lead high + rear still up, then a counter; "knees" means
  lead low (+ rear low at Inside). After about 10 beats I stopped thinking about cover and thought only about what to throw.
  The quiet tell is too wide: it covers no punch, a lead hook, a jab, a back-off, a push and a clinch.
- **Feedback loop note:** the tell costs him nothing and his AI doesn't know I see it. That makes the tells too easy to use: he never
  changes because of what he showed.

## 3. THE OWNER'S QUESTION: should the game show his intention before you choose?

**(a) His whole plan shown, card-game style.** In b4 R2B5 the tell (knees) plus his last beats nearly gave me his whole plan, and the beat
was a sum: cover both, nothing to think about. With his whole plan shown, every beat is like that. The fight becomes a lock to solve,
and the clinch and feint lose their surprise. **No.** It only works if what you plan to do is shown to him too, and that is a different game.

**(b) One body tell, usually true** (b4-b6). Best of the three: it gave me reads and my best beats (b5 R3B5, b6 R3B6). As built it is
**too true** and **too narrow**. It needs: a lie rate that matters (the Jabber never lied), a lie the player can hit when he finds it,
the hidden second action made learnable (a ledger of what came after each tell), and a quiet tell split into "weight on the back foot"
(back off / clinch) and a real quiet guard.

**(c) As now: his last three beats and his hand counts this round** (b1-b3). It works. The "1 stamina at Inside = maybe a clinch, so push" rule, and
his rear held low 3 times so hook him (b1 R2B4-5), were real reads. But the range in moment 1 was a coin flip that decided half my beats.

**My pick: (b), changed as above.** I wanted to keep playing the tells-on bouts more: the draw in b6 was the most exciting bout of the
six. For it to work: lie rates near 70-80% (not 93-100%), each lie tied to a state you can see (as Kalli designed it, but it must
actually fire), a found lie leaves a gap you can hit, and "quiet" no longer hides a clinch.

**Where my play agrees with the prior research:** Kalli's lie rules are what I saw (Slugger tired, Body Snatcher after a blocked body
shot). S558's "a hand that punches guards high the rest of the beat; a step in beats a back off" is still the hidden rule I learned by
losing (the page now shows it, the words don't). S558's "Long is a corridor" still holds: 4 of my short punches fell short at Long.
**Where it disagrees:** Kalli's case against her own design ("a player may just follow the cue every beat") came true here, because
the cues were almost always true. Her measure "following every cue blindly should win no more than 55%" would fail on my bouts:
I followed them and went 2-0-1.

## 4. SCORES (1-10)
| | FUN | DEPTH | CLARITY | VARIETY |
|---|---|---|---|---|
| No tells (b1-b3) | 7 | 7 | 5 | 6 |
| Tells on (b4-b6) | 8 | 7 | 7 | 6 |
- Fun no tells 7: real reads and a clinch-for-the-cards ending, but too many beats lost to the moment-1 range coin flip. Tells 8: the
  knockdown comeback and the counters were the best beats.
- Depth 7 both: the fork rule (two lines one hand guards: body + straight, or side + under) and the move order give depth. But "step in,
  lead high, rear punch" is close to right every beat, and the tells make cover a lookup.
- Clarity no tells 5: the "still up / back up" rule, smothered = a miss = his counter, and what a held hand means after a push were all
  learned by losing. Tells 7: the tell turns the range into something you can see.
- Variety 6: three men who throw the same punches. Overhand and back-off are rare.
- **I could NOT judge from words:** pace, sound, whether the moment strip reads at a glance, the drag-to-order feel, and whether a tell
  as a body POSE (not words) can be read in time.

### Clarity: does the page show what the words showed? (pictures in shots/)
I took three beats I played (b1 R2B3 feint + cross, b5 R3B5 step + rear uppercut counter, b6 R3B5 the trade that put me down).
- **Better than the words:** the strip "WHAT YOU LEAVE OPEN - His jab and cross: open in moment 2 only / His hook and overhand: open
  in moment 3 only / His uppercuts: OPEN" (order_feintcross_plan.png) tells you the still-up rule before you click. I'd have saved b1
  with it. The range bar ("INSIDE lands: Hook, Uppercut, Body, Cross, Overhand") and "Last beat / Before that" match the words.
- **Worse than the words:**
  1. The right-hand story column is so narrow that "blocked: your lead hand was still up (its Feint comes in moment 2)" wraps one word
     per line, and Leo Marsh's commentary box covers the rows under it (order_feintcross_after.png, order_rupcounter_after.png).
  2. The numbers in brackets in the plan list - "Feint (2)", "Cross (3)", "Body cross (1)" - are the ORDER, but they read as a cost. The
     stamina bar says 2 this beat for that body cross.
  3. His overhand is drawn with the rear hook clip ("red_rear_hook_blocked"), so the picture can't tell overhand from hook.
  4. The knockdown picture (order_tradedown_after.png) pushes my man off the left edge of the ring, and the caption names only his
     uppercut, not my body cross landing at the same moment.
  5. There are no tells on the page at all (words-only trial), so (b) can't be judged there yet.

## 5. TO REACH 10/10 (most important first)
1. **Tie each lie to a state you can see, and make sure it fires.** The Jabber showed 18 tells and none were fake (b4). Aim for 70-80%
   true across a bout. Add a tell ledger on his card: "shoulder: true 2 fake 1, faked on 3 stamina or less" after the bell (b5 R2B3/R3B4).
2. **A found lie must leave a gap you can hit.** When the Slugger lied (b5 R3B4) he clinched, and my punch was wiped out. A faked tell
   should cost the liar: his loaded side opens, or a fake costs 1 stamina (Kalli's rule), and push beats the clinch.
3. **Split the quiet tell.** "Weight on the back foot" = back off or clinch; "quiet guard" = no punch. Quiet hid a clinch that cost me
   5 stamina at 4 health (b6 R3B2).
4. **Show what came after each tell**, round by round: "after his shoulder dropped: a lead uppercut 1, a jab 1" (b5 R1B5, b6 R1B4). That
   makes the hidden second action learnable.
5. **Fix the AI's dead moves:** no step in at Inside (8 beats in b5/b6), no push at Mid (b4 R3B6), no back-off at Long (b3 R1B1, b2 R2B1).
   Each one is a free beat that teaches nothing.
6. **Put the still-up / back-up rule into the words version and the help** as one line per moment, like the page's "open in moment 2 only"
   strip (b1 R1B5, b1 R3B6).
7. **Show the habit read:** "He has read you: step in + body cross, 2 of your last 3" (b3 R2B2 - I guessed and lost a point).
8. **Make the Jabber a jabber:** stays at Long, jabs and moves, crosses at Mid. In b1 he went to the body like the other two.
9. **Make Long worth something:** a jab at Long that lands pushes him back or costs him 1 stamina, so the "corridor" has a payoff
   (b2 R2B1-B3, 3 shots fell short).
10. **Ease the body-shot bar shrink:** cap the loss at 2 per bout, or recover 1 between rounds. b1 left me on a bar of 4 by round 3.
11. **Fix the page:** a story column at least 600 px wide with one line per moment, commentary not over the rows, order shown as "1st /
    2nd" not "(2)", an overhand picture, and the knockdown kept inside the ring.

**My 10/10 fight screen:** ten.html -> ten.png (1920x1080). The tell is in the top-left corner of the ring, never on the men. His shoulder
lights up, there is a tell ledger with the visible condition for his lie, a table of where your hands are each moment, a
"he has read you" warning, his stamina labelled with what he can afford, and what he saw of you last beat.

Files: b1-b6.json + .log.txt (every beat), why_lines.md (the WHY I wrote before each beat), shots/ (page pictures), ten.html, ten.png.
