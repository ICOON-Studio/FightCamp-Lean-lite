# ALLPLAY2B_ZIVA - the tells, version 2: three bouts and a verdict (S563)

Seat: ziva (shell). Discipline: boxing. Played cold: I read `play_cli.mjs help`, the task file and my own round-1
report, and nothing else - no `tells.mjs`, no `DESIGN_TELLS2.md` - until all three bouts were played. One line of WHY
before every beat, decided by me. No game file touched, no commit. Bout files and logs: `v1.json`, `v2.json`,
`v3.json` beside this report (round-1 files `b1`..`b6` are beside it too).

## VERDICT

**Version 2 fixed 3 of the 10 fixes I listed in round 1, and broke nothing outright - so it is a clear
improvement, and it is still not the thing I asked for.** The three fixes are real and they landed:

- **Each man now lies by one rule tied to something on screen, and the bell names it.** I found all three rules
  (all different) and the ledger's WHEN clause was the tell that made each one usable. That was my round-1 ask 6.
- **A fake costs him 1 stamina** (13 fakes, 13 stamina, across three bouts). My round-1 ask 7, half of it.
- **"HE READ YOU" is printed** when his habit-answer rule fires (10 times in three bouts). My round-1 ask 8.

What did not change: the cue still names the punch family and not the moment (ask 3), the knockdown is still a heal
(ask 1), the clinch is still a free delete that now also hands him +2 stamina (ask 2), and Long is still a corridor
(ask 4).

And one thing I did not expect, which is now the most important single fact in this report:

> **"A lie is always a BLUFF: he shows more than he throws" is not true for all three men.** Against The Body
> Snatcher it held perfectly (3 fakes, his real beat did 0 damage all three times, and my paid punches landed
> freely). Against The Jabber it held (4 fakes, real beats were a step, a back off, nothing). Against The Slugger
> it was false: 6 fakes, his real beat was a *bigger* punch four times, twice for 5 damage and 3 points on one
> beat (bout v2 R1 beat 4: he showed a loading rear hand and hit me with a body cross *and* a lead uppercut).

The man whose fakes were genuine bluffs is the man I beat (Body Snatcher, 29-27). The man whose fakes hid his real
combination is the man who beat me (Slugger, 27-30). So the fake is not a decoration on top of the tell - it decides
the fight, and its fairness depends on a property the design currently states but does not enforce.

Version 2 tells bouts: **2 wins, 1 loss** (stoppage win, 27-30 loss, 29-27 win). Round 1 tells bouts: 1 win, 1 draw,
1 loss. Same three men, same three seats, different seeds - so this is not a head-to-head result, but the tells are
now something I attacked rather than something I obeyed, which is the change I wanted.

## RESULTS, WITH ROUND 1 BESIDE THEM

VERSION 2 (this round, tells=2):

| # | Opponent (seed) | Result | By round | His fakes | Knockdowns (mine / his) |
|---|---|---|---|---|---|
| v1 | Jabber (51) | **WIN - referee stops it (R3 b2)** | 10-8, 10-8, - | 4 (2 R1, 2 R2) | 0 / 2 |
| v2 | Slugger (52) | **LOSS 27-30** | 9-10, 9-10, 9-10 | 6 (2 per round) | 2 / 0 |
| v3 | Body Snatcher (53) | **WIN 29-27** | 10-9, 10-8, 9-10 | 3 (1 R1, 2 R2) | 0 / 2 |

VERSION 1 (round 1, tells=1), for comparison:

| # | Opponent (seed) | Result | By round | His fakes |
|---|---|---|---|---|
| b1 | Jabber (41) | WIN 30-27 | 10-9, 10-9, 10-9 | **0** (17/17 true) |
| b2 | Slugger (42) | DRAW 28-28 | 9-10, 10-8, 9-10 | **0** (18/18 true) |
| b3 | Body Snatcher (43) | LOSS 27-30 | 9-10, 9-10, 9-10 | **5**, all on "knees bend", no condition named |

In round 1 two of the three men never lied at all in 35 tells, and the third lied 5 times with the ledger saying
only "knees bend 5 (true 3, fake 2)" - no when, no why. That was the whole complaint. In version 2 every man lied,
each by a different on-screen condition, and each ledger gave the condition verbatim. 13 fakes in 50 beats is exactly
the promised "1 beat in 4 or 5".

## 1. EACH MAN'S LIE: FOUND? WHERE, AND WHAT TIPPED ME OFF

All three rules are real, all three are different, and all three are tied to something I did or something on screen.
Two of the three I could have read from the beat story alone; all three were named outright by the bell ledger.

**The Jabber (bout v1, seed 51) - found in round 1, beats 3 and 4. Rule: "the rear shoulder load is fake the beat
after he backed off."**
His very first cue was true (R1 b1: rear shoulder drops, he stepped in and crossed with his lead hand low; my jab
landed). Then R1 b2 ended "2 Back off - lead hand low", and R1 b3's cue was the same rear load - and it was a fake.
R1 b3's beat story ended with another back off, and R1 b4's cue was a fake again.
WHAT TIPPED ME OFF: **his last beats, not the ledger.** Two fakes in a row, each one the beat after a back off, was
visible in the "HIS LAST BEATS" strip while it was happening. The R1 bell then said it in words: "rear shoulder drop
3 (true 1, fake 2: all the beat after he backed off)" - which confirmed the read and made it a plan for round 2
(2 more fakes in R2, and I stopped respecting that cue).
His rate on that one cue: **4 fakes in 7 shows (57%)**.

**The Slugger (bout v2, seed 52) - found in round 1, beats 4 and 6. Rule: "the rear shoulder load is fake the beat
after you landed on him."**
R1 b3: my cross landed on him, and his cue at R1 b4 was a fake. R1 b5: my body hook landed on him, and R1 b6 was a
fake again. Both fakes were at the bell listed as "all the beat after you landed on him".
WHAT TIPPED ME OFF: **the beat story again** - I could see my own landed punches in the previous beat. This is the
cleanest rule of the three because the condition is MY action, not his: I controlled when he lied, and the fix was
mine to make (stop landing, or start expecting the lie specifically on the beat after I land).
His rate on that one cue: **6 fakes in 8 shows (75%) - the lie was more likely than the truth.** That is a man whose
shown cue I should have been *disobeying* by round 2.

**The Body Snatcher (bout v3, seed 53) - found at the round-1 bell, beat 3 of the ledger. Rule: "the knees cue is
fake the beat after you blocked one of his punches."**
R1 b1: I blocked his cross with my lead hand held high. R1 b2: his cue was "knees bend" and it was a fake (his beat
would have shown a step in). I had no idea at the time - it was the first cue he had ever shown me.
WHAT TIPPED ME OFF: **the ledger.** "knees bend 2 (true 1, fake 1: it the beat after you blocked one of his punches)"
- the WHEN clause was the whole answer, and it took one bell to be a plan instead of a mystery. In R2 I called that
cue a probable bluff three times and was right twice: at R2 b3 (fake - my feint-cross landed for 3 and 2 points) and
R2 b6 (fake - hook and cross both landed, 6 damage, his second knockdown), and wrong once at R2 b2, where the cue
was true and he really dug my body and stepped in, though my low lead blocked the dig anyway.
His rate on that one cue: **3 fakes in 7 shows (43%)**. Verifying the condition afterwards: all three fakes were
preceded by a beat in which I blocked one of his punches, and every knees cue after a beat with no block was true.
His condition is necessary but not sufficient (exactly as designed), which is what made it a read rather than a rule.

**Per-man, per-cue honesty (his own ledgers, three bouts):**

| man | the cue he lies on | rate | every other cue |
|---|---|---|---|
| Jabber | rear shoulder drop | 4/7 fake (57%) | all true |
| Slugger | rear shoulder drop | 6/8 fake (75%) | all true |
| Body Snatcher | knees bend | 3/7 fake (43%) | all true |

So each man lies on exactly one cue - but the "1 beat in 4 or 5" average hides the fact that the Slugger's
shoulder cue was a coin flip that came up false three times in four. **The lie is per-cue, not per-man**, and that
is the most learnable thing in the whole system.

## 2. A CAUGHT LIE: DID IT LEAVE A GAP I COULD HIT?

Yes - but only against one of the two men, and the difference is the finding.

**A gap I hit (Snatcher, v3 R2 beat 6).** He showed "he bends his knees and his level drops" (a body punch or an
uppercut). His real beat was "a plain, quiet guard" - he stepped in and threw nothing. I played lead hook + rear
cross (4 stamina). Both landed: -6 health, 4 points, **he went down for the second time** ("down 2x - ONE MORE ENDS
IT"). The gap was total: he had advertised his heaviest family and delivered an empty beat, so both of my punching
lines were open at once. Same shape twice more: v3 R1 b2 (fake, he stepped and feinted, my body cross landed) and
v3 R2 b3 (fake, he stepped, my feint-cross landed for 3 and 2). **Three fakes from him, 0 damage returned, 7 points
and 11 health to me.**

**A gap I could not hit (Slugger, v2 R1 beat 4).** He showed "his rear shoulder drops back (the rear hand is
loading)". I obeyed it and set lead hand high, rear hand high - straight and side covered, the two lines a big rear
punch uses. His real beat was "he bends his knees and his level drops": a body cross that landed for -2 health,
1 point and a permanent cut to my stamina bar, then a step in, then a **lead uppercut that landed for -3 health and
2 points** - 5 damage and 3 points on a beat where I had covered the family I was told about and nothing else.
His real family was covered by neither of my hands, because a lead uppercut comes from below and my rear hand was
high. Twice more, same man: v2 R2 b1 (fake shoulder cue, his real beat a step in plus a lead hook for -3 and 2
points) and v2 R3 b3 (fake shoulder cue, his real beat a step in plus a body jab for -2 and a body cross for -3,
5 more damage).

**The one fake that cost me nothing** (Slugger, v2 R3 beat 1): same fake shoulder cue, his real beat a step in plus
a lead hook, but this time my rear hand was already high, so it was blocked and the beat cost 0-0.

Measured over all 13 fakes: **Snatcher 3/3 fakes returned 0 damage; Jabber 4/4 fakes showed a punch he did not
throw, but 1 of the 4 still cost me (a body jab pull counter for -3); Slugger 6/6 fakes hid a punch, 4 of the 6 did
damage, and 2 of the 6 were the biggest beats of the fight against me.** A lie that always shows more than it
throws is a gift to the defender. A lie that hides his real combination is a trap. Version 2 ships the same word
("fake") over both.

## 3. IS A BEAT WITH A TELL STILL A DECISION, OR A SUM WITH ONE RIGHT ANSWER?

**Still mostly a sum on defence, and more of a decision than version 1 was on offence.** The honest version: the
cue answers "which line is open", and it does not answer "when", and the fake is the only thing that can make the
answer wrong - so the tells cost me most of the defence, and the decisions that were left were about stamina and
timing, not about him.

What version 2 added, with the beat that shows it:

- **Two of the five cues name a NON-threat,** so those beats are offence beats, not cover beats. "His weight sits on
  his back foot" and "a plain quiet guard" between them were 14 of the 49 cues I was shown in these three bouts. In round 1
  there were only four cues and every one of them named a punch, so a cue always meant "cover" - that is exactly the
  arithmetic I complained about. Now half of a fight's cues leave me choosing a punch instead of a guard.
- **The back-foot cue created the first real trade I have had in this game.** v3 R3 b2: I had him at 3 health, down
  twice, one punch from a stoppage. His cue said he was going backwards. I wanted the finish, so I threw the fastest
  3-damage punch (lead hook) rather than respect the cue - "he backs off" and my hook fell short at Long. Next time
  (v3 R3 b5) I picked the punch that reaches whether he stays or retreats (the cross, Inside and Mid) and he backed
  off, it fell short, and his follow-up body jab landed as a pull counter for -3. Two beats, two stamina spends, zero
  damage, and both times the cue was right and I disobeyed it - because the round's score made chasing the stoppage
  worth the risk. **That is a decision, and version 1 had nothing like it** (version 1 had back-offs, but no cue ever
  warned me, so I never linked "he is about to leave" to "my punch will die").
- **The fake un-answers the cue often enough to matter.** At v2 R2 b1 I obeyed a false shoulder cue and ate a lead
  hook; at v2 R1 b4 I obeyed it and ate 5 damage. Three separate beats where the correct play against the cue was to
  disobey it.
- **And it is still a sum underneath.** Against the Snatcher, 7 of my 18 beats were "cue says body/under, set both
  hands low, take 0". Against the Jabber, once I had his rule I simply stopped respecting the shoulder cue entirely.
  So the ceiling is: the cue is the answer, the moment is hidden, the fake is a reliability question, and the only
  free choice left is how much stamina to bet.

Versus round 1, the tells' cost also changed shape in a way I did not expect: **a cue that I obey can now be the
reason I lose the beat** (3 beats above), where in round 1 obeying was always at least safe. That is a real
deepening - and it came from the Slugger's fakes not being bluffs.

## 4. THE BACK-FOOT CUE, THE QUIET GUARD, AND THE CLINCH

**The back-foot cue is clear and it was honest every time - 7 shows, 0 fakes across the three bouts.** It is also
the best new cue in the game and it hides three unequal outcomes behind one sentence:

1. a plain back off (harmless - v2 R3 b5, he backed off and my jab blocked),
2. a back off into a pull counter, which is where the damage is: punching into it turned his 1-damage body jab into
   -3 health (-3 twice: v2 R2 b3, where it knocked me down, and v3 R3 b5),
3. a clinch, which deletes my whole paid beat and handed him +2 stamina (v3 R3 b4, below).

The cue says "a back off or a clinch" and never hints at the counter, which is the only one of the three that costs
more than tempo.

**The quiet guard is clear in words and misleading in practice, and this is a bug in the vocabulary, not in the
wording.** "Nothing: a plain, quiet guard" means none of the other four cues fired - but the lead hand has no cue at
all. In v3 R1 b3 his cue was a TRUE quiet guard and he threw a **lead hook** that landed for -3 health and 2 points
("Lead hook - lands (your rear hand was out, throwing its Body cross)"). I had read the cue as "no threat" and
committed to an offence beat with my rear hand out. Two more lead hooks came out of cues that name something else
entirely: v2 R2 b1 and v2 R3 b1 both showed "his front foot creeps forward" and both hid a lead hook (one landed for
-3, one was blocked). **The cue list covers the rear hand, the body, the uppercuts and the feet; the lead hand is
invisible except its uppercut.** So a quiet guard is not safety, and the game never says so.

**The clinch still surprised me, and it is worse than it was.**
v3 R3 beat 4: he was at 3 health, down twice; his cue was the back-foot one, which I believed; I threw the cross
precisely because it reaches both Inside and Mid, so it would not die to a back off. He clinched: "HE: clinch - ties
you up - no punch lands - the referee breaks them at Mid, **+2 stamina**" - my 2-stamina punch was deleted outright
and he went from 6/7 to 7/7. In round 1 I asked for the clinch to be priced; in version 2 the man who takes the
clinch still loses nothing and now gains stamina for it. It was the only clinch in my three bouts, and it was the
single most annoying beat I played, because unlike the fakes it is not a read - it is simply a beat I paid for and
did not get.

## 4b. THE FEEDBACK LOOP: DID THE COST CHANGE HOW HE FOUGHT?

**No.** Three separate measurements say the fakes are not a cost he experiences:

- **His fake rate never adapted.** Per round: Jabber 2, 2, 0; Slugger 2, 2, 2; Body Snatcher 1, 2, 0. The Slugger
  faked six times and never once slowed down, changed cue, or stopped - including at v2 R3 b3, when he faked with
  4 stamina in the bar and then won the beat for 5 damage. A man who lies at a profit keeps lying, which is correct AI,
  but it means the "cost" is invisible from the other side of the table.
- **The price is refunded at the bell.** The stamina bar refills between rounds (v1 R1 b5: his bar was **0/8** after
  two fakes and my pressure; v1 R2 b1: **8/8**). A body punch's cut persists ("stamina bar 7 for the rest of the
  bout"), a fake's does not. So 13 fakes cost him 13 stamina *inside rounds* and 0 across the bout, and the only
  round where fakes visibly broke a man was the Jabber's R1 - which he had already lost 10-8.
- **He does not know I can see the cue** (the design says so, and it shows): at v2 R2 b1, R2 b3 and R3 b3, in the
  same bout, he re-used the identical fake rule three times against a player who had already been told the rule by
  the R1 ledger. The tells' whole promise - "learn the man" - is only half-served if the man never learns me back.

If the fake is meant to be a trade, it needs one of: a price that survives the bell, a liar who stops lying when he
is being read (or lies harder), or a fake that costs him his own guard on the beat he fakes.

## 5. SCORES: VERSION 2 BESIDE VERSION 1

| | V1 (round 1, tells=1) | V2 (this round, tells=2) | why it moved |
|---|---|---|---|
| **FUN** | 8 | **8** | The hunt is better (three rules, three men, findable) and I stopped losing beats to mystery. But the fakes gave me free beats against one man and punished me against another for reasons I could not act on at the time, and the clinch still deletes a beat I paid for. Fun up, ceiling unmoved. |
| **DEPTH** | 7 | **8** | The back-foot cue created the first genuine risk/reward beat in the game (v3 R3 b2 and b5: chase the stoppage or respect the retreat, and I chose chase and paid twice). The fake makes the cue occasionally wrong, which is a layer v1 did not have. Capped at 8 because defence is still "cover the named family". |
| **CLARITY** | 8 | **9** | My round-1 ask delivered: the ledger now says WHEN ("all the beat after he backed off", "it the beat after you blocked one of his punches") and "HE READ YOU" is printed when his habit rule fires. Every fake in three bouts was explained exactly. Not a 10 because the moment is still fog ("his hand was still up, its Cross comes in moment 3"), and because a "quiet guard" that hides a lead hook is a clarity failure the legend invites. |
| **VARIETY** | 6 | **8** | Three men, three different screen-tied rules - the biggest single improvement in this version, and the first time the three seats have felt like three men. A fifth cue, a redefined quiet guard, a live ledger. Still held back by my own kit (cover the family / feint then big / dig the body) and by dead options (the push off: 0 uses again, and the clinch). |
| **Overall tells** | 7.3 | **8.3** | |

Round-1 scores were FUN 8 / DEPTH 7 / CLARITY 8 / VARIETY 6 for the tells bouts. Everything I liked in round 1 is
still here and three of the things I disliked are gone or reduced. The tells are now a system rather than a caption,
which is what I asked for - they are just still a system with one obvious hole (the lead hand) and one unearned
mechanic sitting next to them (the clinch).

## 6. TO REACH 10/10 FOR THE TELLS (most important first, each tied to a beat I played)

1. **Give the lead hand a cue, or say out loud that it has none.** v3 R1 b3: a TRUE "plain, quiet guard" hid a lead
   hook that landed on me for -3 health and 2 points while my rear hand was out on an offence beat. v2 R2 b1 and
   v2 R3 b1: "his front foot creeps forward" hid a lead hook both times (one landed for -3, one was blocked). The
   cue list names the rear hand, the body, the uppercuts and the feet, and the lead hand shows nothing but its
   uppercut - so the quiet guard currently reads as safety and is not. Fix: a sixth cue for the lead hand ("his lead
   shoulder turns in" = a lead hook), or print in the legend that a quiet guard does not cover lead-hand punches.
   This is the single change that would most improve my defence, and it is invisible in the design's own list
   because the design counts cues rather than punches.
2. **Make the bluff promise true, or tell the truth about it.** v2 R1 b4: his shoulder cue was a fake and his real
   beat was a body cross landing for -2 plus a lead uppercut landing for -3 - 5 damage and 3 points, worse for me
   than the cross he showed. v2 R3 b3: the same fake hid 5 more. The design says a lie "always shows more than he
   throws"; measured across 13 fakes it is false for one of the three men and it is exactly the man who beat me.
   Fix: enforce it (a fake may never resolve to a beat worth more damage or points than the threat it showed), or
   have the ledger print what it cost ("he showed a cross and hit you for 5 - the bluff was bigger than the promise").
3. **Split "a back off" from "a clinch".** v3 R3 b4: his back-foot cue was true and he clinched - my 2-stamina cross
   was deleted and he went from 6/7 to 7/7 stamina. The same cue also hid the pull counter that is the actual damage
   (-3 twice, once for a knockdown: v2 R2 b3). One sentence covers a harmless retreat, a -3 counter and a beat-deleting
   clinch. Fix: two cues, and price the clinch - my round-1 ask 2, still open, and now worse because it pays him
   stamina for taking it.
4. **Show the moment, not only the family** (round-1 ask 3, still open, still the read I want). v3 R3 b6: my hook died
   on "his rear hand was still up (its Cross comes in moment 3)". v3 R1 b1: my jab died on his lead hand being up
   while his cross came later. v2 R1 b1 and v2 R1 b6: two more. A cue that names the family and hides the moment can
   never win a beat on its own - the tell still cannot beat the order strip.
5. **Print the rule with the first fake, not at the bell.** v3 R1 b2: I saw "HIS TELL WAS A FAKE - his beat would
   have shown his front foot creeps forward" and had no idea why; the "when" only arrived at the bell, one beat
   later than it was useful. One line on the first fake of a bout ("he fakes the beat after you block him") turns
   three beats of mystery into a hunt, which is exactly what made round 2 fun.
6. **Let the liar notice he is being read.** The fakes adapted 0%: the Slugger re-used the same false shoulder cue
   three times in one bout after the ledger had named it (v2 R2 b1, R2 b3, R3 b3). Fix: a man whose fake has been
   caught should switch cue or stop bluffing for a round - or lie harder, but differently - so the second read is a
   read and not a lookup.
7. **Give the fake a price that survives the bell** (or make it cost him more than stamina). v1 R1 b5: two fakes and
   my pressure put his bar at 0/8, and at the R1 bell it was 8/8. The tell system asks me to notice a cost the game
   refunds every round. Fix: carry the fake's stamina debt across the bell, or make a fake cost a guard point.
8. **Keep the ledger, keep the three different rules, keep the "HE READ YOU" line.** They are the best three things
   in version 2, they are the reason my scores moved, and none of them should be traded away for any fix above.

## WHAT I COULD NOT JUDGE FROM WORDS

Pace and sound; whether the cue reads at a glance in a 2-second beat; the legend's layout now that it has five cues
and two redefinitions; and whether "HIS TELL WAS A FAKE" arriving *after* my beat is a writing choice or a limit of
resolving the beat first. If it is a choice, it is the wrong one - the fake is the only event in the game that is
reported after the fact, and it is the one I most wanted to act on.
