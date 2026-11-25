# ALLPLAY1 - Ring Switches played six times and judged on FUN (Ziva, S557, seat ZIVA)

I played six bouts through `proto/twohands/tools/play_cli.mjs` from `E:/FightCamp/Lean`, two against each man, deciding
every beat myself with one line of WHY before it. Seeds 71-76, my own folder `E:/FightCamp/tmp/allplay1/ziva/`, state
files and logs beside this report. I read no tool code and never opened `order.html` until my six bouts were over.
**I changed no project file and committed nothing. Nothing opened on your screens** - no window, no viewer, no render.

Record: **2 wins, 4 losses.**

| bout | seed | opponent | result |
|---|---|---|---|
| 1 | 71 | Jabber | LOST, referee stopped it in R3 (my 3rd knockdown). Round 2 was mine 10-9. |
| 2 | 72 | Jabber | **WON**, referee stopped it in R3 (his 3rd knockdown, my feint-overhand). |
| 3 | 73 | Slugger | LOST on the cards 28-29 (R1 mine 10-9, R2 and R3 his 9-10). |
| 4 | 74 | Slugger | LOST, stopped in R3. R1 mine 10-9, R2 his 9-10, R3 gone. |
| 5 | 75 | Body Snatcher | LOST, stopped in R3. Both rounds his. |
| 6 | 76 | Body Snatcher | **WON on all three cards 30-27**, with him down twice and me once. |

## VERDICT

**The read got real, and it is the best thing that has happened to this game.** His last three beats, what each of his
hands did this round, the points of every landed punch, what a body punch did to the bar and for how long, the life
count, and a cheaper plan handed to me instead of a dead beat - all of that arrived, and all of it changed what I did.
Bout 6, round 1, beats 3 to 5 is the proof: the hand tally read *his rear hand thrown 3 of 3*, I threw the fast lead
hook on that read three beats running for 3, 5 and 5 damage and 8 points, and led the round 9-0 with a man who had
never touched me. That is a read of a man's habits paying off in a way the first playtest never once managed. In
ZIVAPLAY1 I said my deepest skill was "pattern-memorising a man's beats"; tonight it was reading a man's guard off a
number on the screen, and I want more of it.

**What has not moved is what happens when the read fails, and the game now has two new ways to delete a beat
outright.** The clinch is the worst of them: four times (bout 4 R1B3 and R1B5, bout 5 R1B2 and R1B4) I paid 2 or 3
stamina for a big Inside punch and he clinched, "no punch lands", and my beat simply did not exist - ten stamina and
four beats erased by one word I could neither see coming nor punish. My own clinch was then shoved off by his push
(bout 5 R2B6) and I ate a 4-health uppercut for it. Blocking is still free money for the man who guesses right (his
blocks became counters on me again and again), and the stamina cap still turns round 3 into an arithmetic worksheet.
By bout 5 I was playing a 4-stamina game where one 2-cost punch is the whole beat.

**Scores: FUN 7/10, DEPTH 8/10, CLARITY 7/10, VARIETY 7/10.** Up on all four from the first playtest's 6, 7, 6, 6, and
the climb is mostly the display work rather than new rules - the display work was the right work.

## WHAT CHANGED FOR ME SINCE ZIVAPLAY1 (asked for)

Last time I gave four asks; three landed and they are the reason my scores moved.

1. **"Show me his guard habit before I choose" - LANDED, and it is the single best change on the page.** His last three
   beats with the per-hand tally for the round is exactly what I asked for. I read it before every beat of bout 6 and it
   decided that bout (R1B3-B5). It is not a total fix: the tally is a beat behind, and when his numbers are 2-2 the
   guess is still a coin flip (bout 2 R2B2 - I could not tell whether his rear would be low or out, threw the body
   cross, and he had it covered). But "which line is open" is now a bet on a number rather than a bet on nothing.
2. **"Never refuse a beat - fall back and say so" - LANDED, and no beat was ever lost.** I hit the refusal twice and
   both times it offered a plan I could pay for (both exited with code 2):
   ```
   NOT PLAYED: that costs 2 stamina, you have 1. Nothing is lost: the beat waits for a plan you can pay for.
   YOU CAN PAY FOR IT WITHOUT BODY CROSS: lead=high rear=high feet=hold   (0 stamina)          [bout 2, R2B5]

   NOT PLAYED: that costs 4 stamina, you have 3. Nothing is lost: the beat waits for a plan you can pay for.
   YOU CAN PAY FOR IT WITHOUT LEAD HOOK: lead=high rear=rbody feet=hold order=rear   (2 stamina)   [bout 3, R3B3]
   ```
   The floor is now shown too - the log says *"stamina bar stays 4 (it never goes lower)"* and *"for the rest of the
   bout"*, which is the line I asked for in ask 2 and could not find anywhere in ZIVAPLAY1.
3. **"Price the block" - LANDED, but I could barely feel it, and I cannot tell what it costs.** My guard read 6/6 on 105 of
   my 108 beat lines; it showed 5/6 three times (bout 2 R2B1 and R2B2, bout 6 R1B2), which is two separate beats on
   which BOTH my held hands each blocked one of his punches, and it was back to 6/6 within two beats. I never saw it lower and I never saw a
   block fail, so from the player's seat the guard meter is still an unexplained number.
4. **"Give Long one honest punch" - the body jab did it, and Long is now a real (small) choice** - but see below, I
   still call Long the range where nothing is worth doing.
5. **"Print the life count" - LANDED** ("down 2x - ONE MORE ENDS IT") and it changed my play inside one beat: bout 5
   R3B2 and bout 4 R3B4 I gave ground to Long behind both hands and stopped boxing because of that one line.

The one thing I got badly wrong last time: I called the **feint** dead weight. Tonight it was the best value in the
game - 1 stamina to make my next punch uncoverable, so 4 stamina bought a guaranteed 4-5 health and 2 points. It won me
bout 2 by stoppage (R3B6) and took the knockdown that decided bout 6 R2B2. I only found it because the log priced it;
the words in `help` ("Draws his hands") still do not tell you the payoff is "cannot be covered".

## NOT SURE

- **Everything I could not hear or click.** I played in words again: no window, no viewer, no sound. Pace, the bell,
  the punch and block cues, and above all the feel of choosing the ORDER - the game's whole second dimension - are
  invisible to me. I have never once used the UI I am being asked to judge.
- **The guard meter.** Three beat lines out of 108, no documented cause and no visible consequence. Is it a real resource
  or a leftover?
- **The ropes.** I watched him pinned twice (bout 4 R2B5-B6; bout 1 R2B2-B3) and saw him stop being able to retreat, but
  I never learned what being on the ropes does to the man's numbers, and I never once felt pinned myself.
- **What a knockdown "costs".** It is 3 points plus the punch, and it resets the downed man to 6 then 4 - which means a
  knockdown can leave the man who was just beaten FRESHER. In bout 2 R1B6 I put him down and he stood up on 6 while I
  was on 4, and he beat me in round 2. I cannot tell whether that is the intended drama or an accident.
- **The AI's read.** I read the designers' notes only after my bouts: he looks for a plan of mine he has seen twice,
  order included, and counters it on `read`. I felt it exactly twice (bout 3, the Slugger held lead low after my body
  work; bout 5, he mirrored my own guard - lead high, rear low - back at me) but I cannot tell a scripted response from
  a solve from the seat. It is legible enough to be fun and not legible enough to be studied.
- **Health 18 / 16 / 21 / 18.** I only ever played these numbers.

## The three best moments

1. **Bout 6, round 1, beats 3 to 5 (Body Snatcher).** The hand tally said his rear hand was thrown 3 of 3, so the side
   was open; lead hook, rear hand home, every beat. Beat 3: hook lands 3, and it beats his rear uppercut TO THE PUNCH
   ("beaten to the punch: your Lead hook is faster, landed first and stopped it"). Beat 4: hook plus body cross, 5
   damage. Beat 5: both again, 5 damage. Nine points to nothing, him from 18 to 4, me untouched at 18. The first time
   in either playtest that a plan came together because I had read something rather than remembered it.
2. **Bout 2, round 3, beat 6 - the bout winner.** Inside, last beat, both cards 10-9 and one more knockdown of him ends
   it. I feint on moment 1 and overhand on moment 2: he pushes me off to Mid, crosses (blocked - my lead was back up),
   and my overhand lands as a counter for **-5** and the stoppage. Everything in the game's rulebook arrived in one
   beat: the order, the feint, the block, the counter, the range, the knockdown.
3. **Bout 5, round 2, beat 4 (Body Snatcher).** He has copied my guard - lead high, rear low - and that low rear is the
   one thing that opens the side. Lead hook: it lands for 3, beats his cross to the punch, and his lead uppercut is
   blocked by my own low rear. A read, a punch and a guard all correct on the same beat.

Honourable mention: **bout 6, round 3, beat 4** - both men went down in the same beat (my jab put him on the floor for
the second time, his body cross put me down for the first), and we stood up 6-4. Chaotic, fair and completely readable
from the log.

## The three dullest

1. **The four clinched beats: bout 4 R1B3 and R1B5, bout 5 R1B2 and R1B4.** Inside, I pay 2 or 3 stamina for the punch
   that the range is for, and he ties me up: "no punch lands". No line of mine, no line of his, no points, no damage,
   and the beat is over. Four beats and ten stamina spent on nothing, twice in each of two bouts. It is the only thing
   in Ring Switches that can make a chosen beat not exist.
2. **Bout 5, round 3, beats 2 and 3 (Body Snatcher).** Both men at 1-2 health, both hands up, and neither able to
   punch: I backed to Long because at Long he cannot do more than 1 health, and he backed off too. Two beats of nothing
   at all (0-5 the round, already lost on cards). Retreating to the safe range is a legitimate plan and it is the least
   interesting beat the game can produce.
3. **Bout 3, round 1, beats 4 to 6 (Slugger).** I had lost my Mid punches to his back-off twice in a row (R1B3: my
   feint-cross fell short when he retreated; R1B4: my jab blocked by the lead hand he was holding for a hook), and by
   R1B5-B6 I was holding both hands and chipping a 1-damage body jab at Long. I won that round 10-9 on the ground
   tiebreak having thrown almost nothing. It is a win I did not earn and would not want to watch.

## The beat that felt unfair, and the one I could not explain

**Unfair - the clinch that eats a paid punch.** Bout 5, round 1, beat 4. At Inside, 6 stamina, I read his uppercuts and
paid 3 for the rear uppercut that the under line is for. He clinched: "no punch lands", +2 stamina to him, and we are
broken at Mid. Nothing in `help` says a clinch cancels a punch already being thrown, and nothing in the log says what my
3 stamina bought. It is not a 50/50 like a guard guess - it is my beat being deleted after I paid for it. The same beat
happened three more times (bout 5 R1B2, bout 4 R1B3, R1B5), and the other side of it is worse: my own clinch in bout 5
R2B6 was beaten by his push off ("tries to clinch - shoved off") and I ate a 4-health uppercut for the privilege. So the
clinch is a free escape when he uses it and a trap when I do.

**Could not be explained from what was shown - whose feet win.** Bout 4, round 3, beat 4. I was on 4 health with him on
13, the feint-overhand is the shot that kills me and it reaches only Mid and Inside - so I gave ground, feet=back, both
hands home, planning to make him come to Long where his biggest punch is a 1-health jab. The result: "moment 1: Mid to
Inside - you back off, he steps in", then his body hook and rear uppercut, and he stopped me. My back-off did not buy a
single place. Nothing I was shown says a step-in in the same moment beats a back-off; there is no line in `help` about
it and the log does not say it won, only that both happened. I died on a rule I could not have learned from anything
the game had told me.

## "Which line is open": a read now, or still a coin flip

**A read - the first time I can say that honestly - but a short one, and a lie about a third of the time.**

- It paid: bout 6 R1B3-B5 (rear hand thrown 3 of 3 -> the side is open -> three hooks, 8 points); bout 6 R3B6 (his lead
  held low 3 of 5 that round -> the straight is open -> jab for the knockdown); bout 5 R2B4-B5 (his rear out throwing,
  twice -> two hooks for 4 points).
- It lied: bout 2 R2B2 (his rear 1 high / 1 low / 1 thrown, no lean to read, my body cross blocked); bout 3 R1B4 (his
  lead hand "still up" because a hook was queued in it, and my jab was blocked by a guard that was only up because a
  punch was in flight); bout 6 R3B4 (I read "side open" off the round tally and he had brought the rear hand up - hook
  blocked, body cross blocked, both my punches dead in one beat).
- The honest number from my seat: when his tally shows a lean of 3-to-0 or more I am right nearly every time; when it
  shows 2-2 or 1-1-1 I am guessing, and a wrong guess costs 3-5 health to his counter. That is a big improvement on a
  coin flip and it is still not a read of the MAN - I am reading his last four seconds, not his habits.

## A plan right every beat? A switch I never wanted? A range worth nothing?

**A plan right every beat: still no, and I am glad.** My best plan - "lead hook, rear home high, hold ground", the same
one I spammed last time - went 3 for 3 in bout 6 R1B3-B5, and then was blocked twice in one beat the moment he raised
his rear hand (bout 6 R3B4). It is a read, not a lock. What IS right every beat is not a punch at all: **holding both
hands costs nothing and pays +2 stamina**, and at Mid against the Slugger (lead high, rear high) it left him only the
body line. I used it as a deliberate banking beat in bout 6 R2B4 and bout 2 R3B1. And at Inside with 1 stamina the ONE
right action is the clinch - which is its own problem (below).

**A switch I never wanted: `push`.** I never once threw it in 108 beats. I met it three times and it hurt me twice - it
shoved me off my own clinch (bout 5 R2B6, followed by a 4-health uppercut) and displaced me off Inside from where his
recovered guard blocked my hook (ZIVAPLAY1's bout 4 R3B6, the same shape). Its stated use, "stops his clinch", is a
counter to a switch I only ever use because nothing else is affordable. Two marginal switches in a game with fourteen is
not a disaster, but `push` is the one I would cut.

**A range where nothing is worth doing: Long, and it is now also the only safe place, which is worse.** At Long my whole
arsenal is the jab and the body jab - 1 stamina, 1 health, 1 point each - and to fight there in bout 3 R1B5-B6 and bout
5 R3B2-B3 meant trading 1-health pokes and banking stamina. But at Long HIS biggest punch is also a 1-health jab, so
when I was at 2 health in bout 6 R3 (and 4 health in bout 5 R3) the correct play was to go and stand where nothing is
worth doing. The safe range and the dull range are the same range, and that is a design smell: Long should either have
one real punch in it or cost something to sit in.

**And one genuinely forced beat.** At Inside with 1 stamina there is no legal punch of mine that reaches (jab and body
jab are Mid and Long only, and the cheapest Inside punch is 2), so the only useful action is the clinch (bout 6 R2B6
and R3B5). That is a beat where the game has taken the choice away - and the clinch it forces is the same switch I hate
being on the wrong end of.

## The three opponents

**The Jabber (16) - the best fight, and the one who punishes a lazy read.** He jabs and body-jabs at Long, crosses at
Mid, holds his lead low to smother my body work, and has the feint-overhand pair that ended my night in bout 1 R2B4
(-4 as a counter). Reading him pays and his own habit is the gift: his back-off handed me bout 1 R2 (level at 9-9) on the ground
tiebreak, and holding his lead low to smother my body work is what let me pick the straight in bout 6. Too hard? No. Too easy? No. He is the right first opponent
and the one I would fight for fun.

**The Slugger (21) - the most man, and the one I think is too hard, again.** Both hands, both big lines: hook and
overhand on the side at Mid (3 and 4 health), uppercuts under at Inside (3 and 4), and he can throw the pair - bout 5
R1B3 he hit me with the rear uppercut and the lead uppercut in one beat for 7 health, from 14 to 7, and every piece of
that is legal, fast enough, and unanswerable by any single guard. 21 health against my 18 and the widest punch
selection in the game means I cannot out-trade him; I can only out-read him, and I did not manage it twice. He is also
the most literal repeater: bout 3 R3 he played "step in, feint, overhand" twice, and in bout 4 he clinched on beats 3
and 5. Reading him pays the most of the three and it still lost me both bouts.

**The Body Snatcher (18) - the most distinctive, and the one I beat both cleanest and ugliest.** His game is
subtraction: every body punch cuts my bar a point for the rest of the bout to a floor of 4, so bout 5 R3 was a
4-stamina game where one 2-cost punch was the whole beat. He keeps a hand home, and his lead alternates low and out -
which is exactly the read the new display finally made usable: lead low means the straight is open (bout 6 R3B6, jab,
knockdown), rear out means the side is open (bout 6 R1B3-B5, three hooks, 8 points). He is also the opponent who proved
the AI reads me back: he mirrored my own lead-high/rear-low fortress at me in bout 5 R1B5, and clinched away four beats
of my Inside work across bouts 4 and 5. Beat him 30-27, lost to him 0-2 rounds. He is the best-designed of the three
and the least fun to be losing to.

## The shape of a bout

- **Rounds 2 and 3 do play differently, and it is the bar.** Round 1 is an 8-stamina game where I can pay for two
  punches in a beat; by round 3 my cap was 4 to 6 in every bout, and a 4-cap beat means one 2-cost punch or two 1-cost
  pokes. The texture changes from boxing to arithmetic, and the log now at least tells you the truth of it ("stamina bar
  7 for the rest of the bout", "stays 4 (it never goes lower)").
- **A knockdown changes everything about the next ten seconds.** It is 3 points plus the punch - it decided the round in
  bout 6 R1 (10-9, when I had led 9-0) and it swung bout 1 R2 from 3-2 to 3-7 in one beat - his rear
  uppercut put me down - though I still took that round 10-9 on the ground tiebreak. And it resets the man who was
  just beaten: bout 2 R1B6 I put him down and he rose on 6 while I was on 4, and he won round 2. When the card says
  "down 2x - ONE MORE ENDS IT" every beat becomes a different game - bout 4 R3 and bout 5 R3 I stopped boxing and
  started surviving, and in bout 6 R3 that discipline is exactly what won me the bout 30-27.
- **The ropes matter, but mildly.** A man on the ropes cannot retreat (bout 4 R2B5-B6, bout 1 R2B2-B3), which turned a
  step-in into a real tactic for me twice, and pinned men fight instead of retreating (bout 4 R2B6 he stepped in and
  feinted from the ropes). I never felt the ropes myself in six bouts and I still do not know what they do to numbers.
- **The stamina bar is the real clock.** Not health - the bar. A man whose bar is 4 cannot throw the pair that beats
  you, and digging his bar with body punches (2 health, 1 point, plus the cap cut) was worth more to me than a hook in
  bout 6: his bar went 8 -> 7 -> 6 while my health stayed at 18.

## Where my play agrees with the prior research, and where it does not

**Agrees.** (a) The order rule is the game's one original idea and its deepest skill - `RINGSWITCH_S556.md` and
ZIVAPLAY1 both say so, and I used it to win bout 2 R3B6. (b) Long is the dead range (ZIVAPLAY1: "the range where
nothing is worth doing") - six bouts, still true, and worse than ZIVAPLAY1 knew because it is also the safe range.
(c) The ground tiebreak is a real win condition the AI does not play for: two of my rounds came out level on points and
both went to me on ground (bout 3 R1 at 1-1, bout 1 R2 at 9-9) - S556's NOT GREEN line is right. (d) The Body Snatcher
is the most distinctive and the least fun to lose to (ZIVAPLAY1 said the same; he is also the man I beat cleanest,
which neither of us predicted). (e) The stamina cap decides round 3 - still.

**Does not agree.** (a) **S556 says "the jab still lands too often, 73%", and my experience is the opposite** - the lead
hand is up over the straight almost every time I throw it, and my jab was blocked in bout 1 R1B1, bout 3
R1B4, bout 3 R2B1, bout 3 R3B1 and bout 6 R1B2. A look-ahead bot knows when the guard is up; a player does not, and I
would rather the bar measure the player's jab than the bot's. (b) **ZIVAPLAY1 called the feint and push off "switches a
player will learn to ignore" - half right.** Push off I never threw once; the feint became my best punch enabler (bout
2 R3B6, bout 6 R2B2), so the feint's problem was never the rule, it was that `help` never said "cannot be covered".
(c) **ZIVAPLAY1's ask 1 ("show me his guard habit") is now delivered, and I would go further than that report did**: it
is not just a legibility fix, it is the difference between DEPTH 7 and 8 for me. (d) ZIVAPLAY1's "never refuse a beat"
is delivered and the refund line is better than asked for. (e) **Neither prior document mentions the clinch as a
problem.** From the player's seat it is the single worst thing in the game: S556's bot tables report "no punch in a beat
13-19%", and I would bet a large share of that is clinches the bots take because they are free.
`docs/RINGSWITCH_S556.md` never mentions it in 84 lines.

## SCORES (1 to 10)

- **FUN 7/10** - one bout I would tell someone about twice (bout 6: a read, three landing hooks, a knockdown each way
  and a 30-27 card), a knockout finish I earned (bout 2), and a long middle of banking-stamina beats and four beats
  deleted by clinches (bout 5 especially).
- **DEPTH 8/10** - the order, the feint's uncoverable punch, speed and size deciding a moment, the guard versus the
  line, the permanent bar cut, the knockdown reset and the ground tiebreak, and I used every one of them deliberately
  in bout 6. The read is now a skill you can practise because the numbers are on the screen. One short of 9 because the
  read is still four seconds long, and because a clinch can make a deeper plan worthless.
- **CLARITY 7/10** - every landed punch prints its points and its health, the body-bar line now says "for the rest of
  the bout" and "never goes lower", the unpayable beat offers a cheaper plan, and the life count is on screen. Still
  missing: reach (learned by failing - "smothered: too close at Inside" and "falls short" cost me stamina in four
  bouts), whose feet win a moment, what the guard meter is for, and what the ropes do. Every one of those is one line of
  text.
- **VARIETY 7/10** - the three men are genuinely three men, my plan for each was different, and inside a bout he changes
  (he copies my guard, he switches his lead between low and out). But my decisive beats collapse into three shapes (the
  hook, the feint-over, the body punch), his literal repeats are still the most reliable thing about him (bout 6 R1B3-B5
  landed three times running; bout 4 he clinched on beats 3 and 5), and six of the fourteen switches never left my hand.

**What I could not judge from words:** pace - how long a beat takes and whether it drags; sound (the bell, punch, block,
whiff and knockdown cues, none of which I heard); the click and the ORDER UI, which is the game's whole second dimension
and which I have now judged twice without ever touching it; how the animation reads in motion (I could not tell a lead
hook from a rear hook from an uppercut); the hover text on the score line; the opponent's body language between beats,
which is where a human would learn the guard I can only infer from a tally; and the guard meter, whose purpose I never
saw demonstrated.

## TO REACH 10/10

Most important first. Each is tied to a beat I played.

1. **The clinch must not be able to eat a punch you have already paid for.** (Bout 5 R1B2 and R1B4, bout 4 R1B3 and
   R1B5: four beats, ten stamina, "no punch lands", and my read of his uppercuts was correct every time.) Make the
   clinch resolve in the moment it happens, like every other action: a punch thrown in an EARLIER moment of that beat
   lands before the tie-up, and only the moments after it are cancelled - or say on the switch that a clinch costs the
   next beat's stamina gain, so it cannot be a free escape. And make `push` beat a clinch only when the pusher was not
   also punched, because right now he shoves off mine *and* lands the uppercut (bout 5 R2B6, -4 health).
2. **Put reach on the switch before the beat.** (Bout 3 R3B3: I paid 3 stamina for a body jab at Inside - "smothered -
   too close at Inside"; bout 2 R2B4: my rear uppercut fell short at Mid when he backed off; bout 3 R1B3: my feint-cross
   fell short at Long.) The cheap-plan message proves the tool can check a plan before it is played: dim or flag every
   switch that cannot reach at the range printed on the state line, and print the reason ("does not reach Inside")
   instead of taking the stamina and telling me afterwards.
3. **Give Inside a 1-stamina option.** (Bout 6 R2B6 and R3B5: at Inside with 1 stamina my jab and body jab do not reach
   and the cheapest punch costs 2, so my only action was the clinch - the switch I spent this whole report complaining
   about.) A short jab that reaches Inside for 0 or 1 stamina, or a 1-stamina version of the uppercut, gives the broke
   player a real beat instead of a forced tie-up.
4. **Print the two feet rules.** (Bout 4 R3B4: "you back off, he steps in" gave me Inside, not Long, and I was stopped
   on the next beat.) Say whose feet win a moment when both men move, and what a second back-off costs, in the same
   voice as the rest of `help`.
5. **Say what the feint does.** (Bout 2 R3B6 - the feint-overhand won me the bout; bout 6 R2B2 - it took the knockdown.)
   One line in `help`: "the punch you throw in the next moment cannot be covered". It is the strongest two-switch
   combination in the game and the words currently undersell it into looking like dead weight.
6. **Explain the guard meter or take it off the state line.** (Bout 2 R2B1-B2, bout 6 R1B2: 5/6, and nowhere else in 108
   beats.) I asked for a priced block last time and I still cannot tell what a block costs or what happens at 0. Either
   show the cost on the block line ("blocked - his guard 5/6") so a player can learn it, or delete it.
7. **Put the knockdown lifecycle in `help`:** up on 6, then 4; the third ends it whatever the cards say. (Bout 2 R1B6: I
   put him down and he stood up fresher than me at 6 against my 4, and won the round.) The log now says the count -
   which saved me in bout 6 R3 - but the numbers behind it are still invisible until they happen to you.
8. **Break up his literal repeats.** (Bout 6 R1B3-B5: I played the identical plan three beats running and it landed every
   time, because he kept his rear hand out; bout 4: he clinched on beats 3 and 5, alternating.) Keep each man's home hand
   and favourite line, but vary the ORDER and the timing, so a read stays alive instead of becoming a lookup.

## The ten.html

`E:/FightCamp/tmp/allplay1/ziva/ten.html` - my 10/10 fight screen, one 1920x1080 page, written and NOT rendered and NOT
opened (no window, no viewer, as instructed), so everything on it is drawn from the rules I played and no part of it is
a picture of anything running. What it shows: the two men mid-moment with health / stamina (cap shown as a broken-off
tail) / guard / ground under each; the moment log with the reason on every line, because the reason a punch landed is
the whole game; his last three beats as chips plus per-hand habit bars, which is my read made visible; the three switch
rows with reach drawn on every card and unpayable switches dimmed with the cheaper plan offered in their place; the ORDER
strip, which is the dimension I have never been able to touch; the life count; the clinch priced with what it costs; and
the range line with the current range lit.
