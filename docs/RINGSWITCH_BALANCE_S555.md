# Ring Switches: the balance pass (S555, 2026-11-25)

The owner, playing the order page: "vs the jabber you win very easy , all your rear hands land easy , need better balance ,
i want this slice to be perfectly balance to move on (always have in scope other arts that will be added and knees and
elbows)". And first: "i want version with theorder of actions".

## NOT GREEN (read this first)
- **He has not played it.** Every number below is bots on the page's own rules. His play is the gate.
- **One bar of nine fails:** the jab lands 72% of the time (my bar: 30 to 65%). Both men keep the lead hand low against
  the body cross, so the head jab gets through. Tried: either hand held high stops a jab - the jab then lands 13% and
  dies. Left as it is: the jab is the light punch (1 health).
- **The body jab is not on the page.** With it the game measures better still (draws 4% instead of 12%, the jab and the
  body jab each in 12% of beats: Long gets a real guess), but it has no picture of its own. Next build:
  the authored take (pattern `tools/pics2d_bodycross_bake.gd`), its runs, then the page (`s555_apply_rules.py bjab` is
  the patch, in this page's last section).
- **The bars are mine**, not his: nine numbers that say "balanced" for two equal men who make no mistakes. Where real
  boxing has a number it is beside the bar.
- **Health is counted as plain numbers** when a beat is solved (a punch that would knock him down is worth its damage, no
  more), and the look-ahead knows range, both stamina bars and ground given - not the guard bar or a shortened stamina bar.
- Kalli's and John's answers came back the same session; what was built from them and what was not is the section
  "What the seats said" below. Their six unbuilt ideas are unmeasured.

## What was wrong, measured
| | The page this morning | Now |
|---|---|---|
| The measuring player (answers the man's last beat) against the Jabber / Slugger / Body Snatcher | wins 100% / 81% / 72%, stops the Jabber in 81% of bouts | see "The three opponents" below |
| Why | the opponents were scripts with a line always open: the Jabber's lead hand was jabbing or held high, so his body was never covered | each opponent plays the beat's best mix, leaning to his style |

And under that, a second problem the walk-over hid. Two equal men who BOTH play well (84 bouts):

| What | This morning's rules | Now | The bar |
|---|---|---|---|
| Beats fought at Inside / Mid / Long | 6% / 19% / 75% | 32% / 35% / 33% | each 15 to 55% |
| The most used switch | jab, in 50% of beats | back off 34%, step in 32%, body cross 28% | none over 40% (real boxing: the jab is 40-44% of punches thrown) |
| Switches never worth a click | lead uppercut 0%, lead hook 1% | none (the least used: overhand 5%, rear uppercut 4%, push off 4%) | each in 3% of beats or more |
| The cross / the body cross fall short | 88% / 83% | 34% / 33% | at most 40% |
| A punch lands | jab 58%, cross 11%, body cross 14% | body cross 45%, cross 46%, hooks 39-60%, uppercuts 52-57%, overhand 77%, **jab 72%** | 30 to 65% (real boxing: 27-32% of all punches land) |
| Knockdowns a bout | 0.0 | 2.3 | 0.5 to 2.5 |
| Bouts stopped / drawn | 0% / 32% | 20% / 12% | 10 to 40% / at most 20% (real pro boxing: 47% end by KO or TKO) |
| Two punches in a beat / no punch | 16% / 11% | 16% / 13% | 15 to 45% / 5 to 25% |
| Clinches a bout | 0.8 (the bout never got close) | 1.4 | at most 2 |
| An order to choose / the slot most often first | 63% / lead hand 61% | 68% / feet 47% | 40%+ / at most 60% |
| The same man against himself | 34% wins, 32% draws | 49% of decided bouts | 40 to 60% |
| BARS | 2 of 9 | **8 of 9** | |

## What changed on the page (`proto/twohands/order.html`)
Rules, each one line a player can read:
1. A jab that lands no longer keeps him out (the S554 trial rule). It made three beats in four Long.
2. **A step in beats a back off in the same moment**: you close anyway (cutting off the ring). To get away he has to
   back off a moment AFTER your step.
3. **Every back off gives ground**, at any range. Two and you are on the ropes: no backing off until you step in.
4. **The clinch works Inside only** and gives 2 stamina (it was Mid or Inside, 3).
5. **The cross and the body cross reach Mid and Inside** (they were Mid only).

Numbers: health 17 (was 22), up on 6 and then 4 (was 9, 7). Lead uppercut 2 stamina, 3 health, the hooks' speed (was 3,
4, slow). Lead hook as fast as the jab. Opponents' health 15 / 20 / 17 (was 20 / 26 / 22).

The opponents: no script. Each beat the page solves the guessing game (every plan a man can pay for, in every order,
against every plan of the other) and the opponent draws from the mix nobody can improve on, leaning to his style
(Jabber: jab, cross, back off; Slugger: overhand, hook, uppercuts, step in; Body Snatcher: body punches, step in). He
still answers a habit of yours. He makes up his mind while you set your switches, in under a second.

## The three opponents
Each opponent has a SKILL: the share of beats he plays the best mix. The rest are plain beats of his style (one of his
own switches, punches that reach if you stand still), and those are the beats a player reads him on. At skill 1 all
three were too sharp for a human: the player who simply answers the man's last beat won 31% / 21% / 26% and was stopped
in half his bouts.

| Who is in your corner | v the Jabber (skill 0.52, health 15) | v the Slugger (0.58, health 20) | v the Body Snatcher (0.78, health 17) |
|---|---|---|---|
| THIS MORNING: answers the man's last beat | wins 100%, stops him 81% | 81% | 72% |
| Answers the man's last beat (84 bouts each) | wins 44%, draws 5%, stops him 24%, is stopped 15% | 56%, 7%, 19%, 21% | 42%, 2%, 27%, 37% |
| Plays the best mix every beat (42 bouts each) | wins 81%, never stopped | 69% | 62% |
| Random clicking (56 bouts each) | wins 11% | 7% | 9% |

84 bouts is +-10 points, so "about half" is all the middle row says; the order of the three is not established.
His rear hands, the owner's complaint ("all your rear hands land easy"), for the player who answers the last beat:
body cross lands 61-67%, cross 41-48%, overhand 39-53%, rear uppercut 28-47% (this morning against the Jabber every body
cross landed: his body was never covered).
Each man still looks like himself: the Jabber backs off in 41% of beats and throws the cross in 31% and the jab in 25%
(the same man with no style: 34 / 17 / 22%); the Slugger steps in in 61%, lead hook 15%, overhand 10% (32 / 7 / 5%);
the Body Snatcher steps in in 56%, body cross 27%, body hook 11% (32 / 28 / 8%: his body work is his weakest mark).

## What the seats said (Kalli SQ331, John SQ332: `ops/research/RINGSWITCH_BALANCE_BRIEF_KALLI.md`, `_JOHN.md`)
They were given the game and this morning's measurements, not the changes above. Both answers landed the same session.

| Their idea | Kalli | John | Here |
|---|---|---|---|
| A step in beats a back off in the same moment; the man backing off gives ground | 4 (range does not change, ground lost) | **1, "try this FIRST"** (the range closes) | BUILT as John has it, before his answer came: Long 57% -> 40% |
| The opponents play the solved mix with a lean each, not a script | 2 | yes ("give the Jabber the solved mix, then its personality") | BUILT; a skill setting added so a human can win |
| Cut "a landed jab keeps him out" | 4 | 2: shorten it to the next MOMENT of the same beat | CUT. John's shorter version: not measured |
| The lead uppercut: 2 stamina, 3 health, faster | yes (fast slot) | yes (the cross's speed) | BUILT at the cross's speed |
| The lead hook is the check hook | +1 against a man stepping in | as fast as a jab against a man stepping in, and a counter | BUILT simpler: always as fast as the jab (3% -> 7% of beats) |
| The clinch from Inside only | - | yes | BUILT, and it gives 2 not 3 (a quarter of close play -> 1.4 a bout) |
| MOVING COSTS BREATH: a held hand gives its +1 only on a beat the feet stayed | 3 | 3 | NOT BUILT - both seats, the next thing to measure |
| An even round goes to the man who came forward / gave less ground | 6 | 4 | NOT BUILT - both seats; draws are 12% now (were 32%) |
| The lead uppercut beats a clinch thrown in the same moment | yes | yes | NOT BUILT - both seats |
| HURT: a big counter leaves his held hands blocking nothing next moment / big counters +2 | 5 | 5 | NOT BUILT; stoppages are 20% now without it |
| Back off escapes hooks and uppercuts but not straights; a new feet switch CIRCLE escapes straights | 1, her first | - | NOT BUILT: a new switch needs its pictures; measure on the tool first |
| The clinch: both men rest / the break costs the clincher his first moment / warnings and a point | yes | yes | NOT BUILT |

For the other arts both say the same three things, and nothing built today contradicts them: KEEP EXACTLY THREE RANGES
(Long: jab and kicks; Mid: punches, low kicks, the shot; Inside: short punches, knees, elbows, the clinch); LINES ARE
WHERE A STRIKE GOES, not what throws it (boxing's four stay; elbows on the side line, knees on the from-below and body
lines; only LEGS and TAKEDOWN are new and no hand covers them: a lifted leg and a sprawl do); THREE SPEEDS AND COSTS 1 / 2
/ 3 are fixed now, and "a limb that strikes is out of its guard only in that moment" holds for every limb. Kalli adds: no
strike over 5 damage, and each art's legal targets a setting so the board never changes. John adds: the clinch is a
place, each art decides what happens there (boxing: the referee breaks it).
The fights they name (Mayweather v Hatton's check hook, Fury v Wilder 3, Klitschko v Povetkin) are from their memory, not
re-checked: nothing rests on them.

## Tried and dropped (each measured the same way)
| Change | What it did |
|---|---|
| Only: the landed jab no longer keeps him out | Long 57%, still no stoppage, back off in 45% of beats, body cross falls short 73% |
| The body cross reaches Long | the body cross is thrown in 44% of beats, the jab dies (0.6 a bout) |
| The cross reaches Long too | health taken 28 a bout, 2.4 knockdowns, the jab in 2% of beats |
| Stamina back 2 a beat | no better: cross and body cross still fall short 60-67% |
| The body jab also shortens his stamina bar | the head jab falls to 3% of beats |
| Either hand held high stops a jab | the jab lands 13% and is thrown in 8% of beats |
| The lead hook at the hooks' speed | thrown in 3% of beats (6-7% as fast as the jab) |
| Health 18, up on 7 and 5 / health 16, up on 6 and 4 | stoppages 2% / 32% with 3.0 knockdowns; 17 with 6 and 4 gives 20% and 2.3 |
| The four guard rules (a punching hand guards: only out of its moment / not before it throws / not after / never) | none of them touched the Jabber walk-over (99-100%): the cause was the script, not the guard |
| The body jab against the scripted opponents on the order page | nothing: 96-99% against the Jabber in all three versions (the 97% to 60% of S554 was the old page) |

## The instrument (`proto/twohands/tools/balance.mjs`)
It reads the page's own tables (ACT, FEET, COVER) through `rules.mjs`, so a knee, an elbow or another art's moves are
measured the day they are in the tables. A change is tried without touching the page (`tweak=<file.json>`).
- `table`: looks a whole round ahead, last beat first, and writes `vtable.json` (the page loads it). About 7 minutes.
- `mix`: the best mix at each range: a switch that is never in it is dead, one in nearly every plan is a must.
- `play who=mix|sensible|random opp=mirror|0|1|2`: whole bouts, counted; against the mirror it prints the nine bars.
- AFTER ANY RULE OR NUMBER CHANGE ON THE PAGE: `node proto/twohands/tools/balance.mjs table`, then `play`, then
  `node proto/twohands/tools/rules_test.mjs` (29 tests).

## For the other arts (knees, elbows, kicks, takedowns)
What this pass shows must hold when they come:
- **One real guess per range.** Today: Long - nothing but the jab (the body jab will make it lead hand high or low);
  Mid - lead hand high or low (straight or body); Inside - rear hand high or low (hook or uppercut). A new limb or line
  must add a guess somewhere, not a punch nobody can stop.
- **A weak fast move dies the moment a strong one reaches the same range** (the jab, when the body cross reached Long).
  Reach is the balance lever, more than damage.
- **A one-range move falls short two times in three.** Every move needs two ranges or a way to hold the range.
- **Getting away needs a price** (ground). A knee or an elbow lives Inside: without the step in beating the back off,
  nobody ever gets there.
