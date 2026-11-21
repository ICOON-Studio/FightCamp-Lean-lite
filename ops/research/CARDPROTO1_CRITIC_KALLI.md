# Critic brief: FightCamp card game prototype (round 1) - you are a FRESH critic

You judge a small browser card game that turns our boxing-gym management game into cards. Be blunt; a kind score is useless. Score 0-10 each: DEPTH (are there real, repeated, interesting decisions; does knowledge/skill beat luck; do cards differ in more than numbers), PLAY (is it fun to play: tension, surprise, agency, pace, would you play a second bout), GENERAL (overall). Then: (1) missing cards or options, (2) useless or dominated cards, (3) what each change would do, (4) THE ORDERED LIST "TO REACH 10/10" - most important first, concrete enough to build (card names, numbers, rules). Also say which single thing is most wrong right now. Our bar to keep the mechanic is 8+ on DEPTH and 8+ on PLAY.

Game in short: the player is a boxing coach. Camp (4 weeks, one drill a week) decides which cards the boxer brings; scouting reveals the opponent's style and habits; the fight is 3 rounds of 6 exchanges, both corners play one card face down and reveal together; between rounds one corner card, each with a cost; ends by stoppage or three judges' scorecards. Real boxing flavour (styles: out-boxer, pressure, counter, volume; wind/head/body damage; knockdowns).

Below: the prototype's README (rules), the balance table from 2,000 AI-vs-AI bouts, and three full AI bout transcripts. Note: in the transcripts defensive cards (slip, roll, pivot) "land" damage - judge whether that reads sensibly.

## README
# FightCamp - card game prototype (boxing)

A playable browser prototype of a card game version of FightCamp. You are the coach, not the boxer:
you pick a fighter, spend a four week camp shaping his deck, read the other corner's habits, then
call the fight one card at a time and work the corner between rounds.

Boxing only, as asked. The rules are data, so another art later is new card data, not new code.

```
proto/cardgame/
  index.html      the page - dark room, warm brown and gold, card faces drawn in CSS
  ui.js           the shell: screens, drawing, clicks. It decides nothing about the fight
  rules.js        the pure rules: cards, resolution table, habits, camp, corner, seeded RNG
  rules.test.mjs  node proto/cardgame/rules.test.mjs        -> PASS/FAIL per check, exit 1 on failure
  balance.mjs     node proto/cardgame/balance.mjs [bouts]   -> 2000 AI-vs-AI bouts, printed table
  README.md       this file
```

No build step, no libraries, no external fonts or images, nothing outside this folder.

## How to open it

Double-click `index.html`. It plays from the file system - no server, no install.
(If you prefer a server: `python -m http.server` in this folder, then open `/index.html`.)

Keys: `1`-`5` play a card from your hand, `Enter` presses the gold button.

## How to play

1. **Pick your boxer.** Two are free this month: Ada Nowak (out-boxer, best feet in the gym) and
   Mara Okafor (pressure fighter, body first). The other corner is drawn from the rest of the gym,
   so a bout is never against the same man twice.
2. **Camp - four weeks.** Each week offers three training cards; pick one. A drill either puts more
   cards in your fight deck (two more jabs, a roll, a cut-off the ring) or raises a stat a little.
   The camp is the manager layer: it decides which 16-20 cards your boxer brings and what they are worth.
3. **The scouting file.** Before the bell you see his style and **0, 1 or 2 of his habits** - sometimes
   nothing at all, which is the point. A habit is a promise with a condition: in one stated situation
   that is the card he looks for first. Reading pays, and pays best when you know when to commit.
4. **The fight.** Three rounds, six exchanges a round. Both corners play one card face down and turn
   them over together. One line per exchange ("Your cross lands; her slip is mostly smothered").
5. **The corner.** Between rounds you pick one of three corner cards. Each one costs something -
   wind, punch power, the first exchange of the round, or a body of damage you keep.
6. **The result.** Three judges score every round 10-9 (10-8 with a knockdown or a dominant round),
   the cards are read out, and a stoppage ends it early.

## The rules in plain words

**Cards and wind.** Every card costs wind. Your boxer's Stamina sets his tank and makes his cards
cheaper. You can always throw a card you cannot pay for, but you throw it flat: less damage, worse
accuracy. Wind never goes below zero.

**Damage.** Punches damage the head and the body. Body work also takes wind out of him (a body hook
costs him more than the card cost you). Head damage is what knocks a man down; a hurt man is easier
to hurt again.

**Range.** The fight sits at range (`out`), mid or inside. Each card has the distances it likes; played
outside them it lands softer and misses more. Footwork and clinching move the fight: step back takes it
outside, pivot out resets to mid, cutting off the ring and clinching take it inside. The jab is the
only cheap punch that works everywhere.

**Punches vs defence vs feet.** Each pair of cards has one outcome, written as data in the table below.
The table is anti-symmetric by construction: what a card does to another is exactly the flip of what
the other does back.

| code | meaning |
|---|---|
| **W** | you crush it: he whiffs, you land full (x1.5 damage) and he takes nothing |
| **w** | you win the exchange: you land, he does not |
| **t** | a trade: you both land, softer |
| **l** | you lose the exchange: your shot is smothered, his lands |
| **X** | you are countered: you land nothing, he lands full |
| **n** | nothing doing: both corners wasted the exchange (and the wind) |

**The set-up.** Land a jab and your next punch sits down on it (+15% damage, easier to land). That is
why the cheap card is not the nothing card.

**Habits (the read).** Each opponent has two. They fire when their situation is true and the card is
in his hand: hurt, he clinches; crowd him and he fires the uppercut; after his own jab he sits down on
the right hand; hit him clean and he gives ground. A habit card is drilled into his deck twice - it is
his signature, not a rare accident - but it is still one card of twelve, so the read is a judgement
about when to commit, not a button. Every habit is shown to you as a sentence, never as a number, and
only the ones on film.

**A knockdown** comes from a big clean head shot to a tired or hurt man. Chin raises the bar, a low
tank and existing head damage lower it.

**A stoppage** is three knockdowns, too much head damage, or a beaten-up boxer (32 head damage or more) on an empty tank.

**Scoring.** Three judges with different tastes - one leans on landed punches, one on damage, one on
work rate - and a little noise, so they disagree. A round is 10-9; a knockdown or a dominant round
makes it 10-8. A draw is possible and honest.

## The resolution table

`W` you crush it, `w` you win, `t` trade, `l` you lose, `X` countered, `n` nothing doing.
Read a row as *the card you played* against *the card he played*.

| played ＼ against | Jab | Crs | Hk | BH | UC | Slp | Blk | Rll | Cln | SB | Pv | CO |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Jab** | t | t | t | t | l | l | l | t | w | w | l | w |
| **Cross** | t | t | t | l | l | l | l | t | w | l | l | l |
| **Lead hook** | t | t | t | t | l | w | l | l | w | l | t | t |
| **Body hook** | t | w | t | t | t | w | t | l | l | l | l | t |
| **Uppercut** | w | w | w | t | t | t | w | w | l | l | l | t |
| **Slip** | w | w | l | l | t | n | n | n | l | n | n | l |
| **Block** | w | w | w | t | l | n | n | n | l | n | n | l |
| **Roll** | t | t | w | w | l | n | n | n | t | n | n | l |
| **Clinch** | l | l | l | w | w | w | w | t | n | l | l | t |
| **Step back** | l | w | w | w | w | n | n | n | w | n | n | X |
| **Pivot out** | w | w | t | w | w | n | n | n | w | n | n | w |
| **Cut off the ring** | l | w | t | t | t | w | w | w | t | W | l | n |

Short version, the things worth remembering:

- **Slip** beats the straight punches (jab, cross). **A hook beats a slip.**
- **Roll** beats the hooks (lead hook, body hook). **The uppercut beats a roll** - you roll into it.
- **Block** stops the hands. **The uppercut goes through the guard.**
- **A hook beats a clinch attempt at range**; the clinch smothers the inside punches (body hook, uppercut).
- **Cut off the ring beats Step back**; **Pivot out** escapes the trap; **the jab** meets a man walking in.
- **Step back** takes the big shots away, but **the jab follows you**.

## Stats, and what they change

| stat | what it does |
|---|---|
| Power | punch damage |
| Speed | counter damage on defence and footwork cards; decides the sharper counter |
| Stamina | the size of the tank and the cost of every card |
| Chin | the knockdown threshold |
| Technique | how often a card lands (fewer misses) |
| Defence | how much of his damage you take |

## Tests and the balance harness

```
node proto/cardgame/rules.test.mjs     # 32 checks, PASS/FAIL, exit 1 on any failure
node proto/cardgame/balance.mjs        # 2000 AI-vs-AI bouts, different boxers every time
node proto/cardgame/balance.mjs 6000   # more bouts, steadier table
```

The test file covers the resolution table pair by pair (all 144, plus the anti-symmetry of the whole
table), stamina never going below zero over hundreds of exchanges, 10-9/10-8/10-10 judging, the
stoppage rule and that a real stoppage is always justified by the state, the same seed playing the same
bout exchange for exchange, a habit firing in its situation and not firing when the card is not in hand,
the camp, the scouting file and the corner.

The harness plays the same AI the game uses, so the table is what the game actually does. It prints the
win share per style pair, how often every card is played and its win rate when played, and how the
bouts end. It fails (exit 1) on a **design defect**: a card that wins more than 65% of the time it is
played, or a card that is effectively never played (under 1% of exchanges).

Both corners get a camp in the harness - the AI runs a camp for the other boxer as well - because
otherwise the table measures *prepared against unprepared*, and camp picks are style-flavoured, which
bends every cell. In the game itself only you prepare; the opponent is the puzzle.

What the numbers said when this was written (8,000 bouts): every card inside the limits (highest
win-when-played: **Lead hook** and **Uppercut**, 55.4%; least played: **Block**, 6.6%); style pairs
between **38% and 56%**, with the widest gap **Pressure v Counter-puncher**, about 16 points to
Pressure; stoppages **12%** of bouts, 1.7 knockdowns a bout.

**Does the read pay?** Measured, not asserted: over 4,000 AI-vs-AI bouts where the left corner plays
the scouting file it was dealt, it wins **46.9%**, against **44.4%** for the same AI ignoring the file.
Knowing both habits instead of the 0-2 you are dealt is worth about **47.8%**. So the file is worth a
couple of points and a large edge only when you have studied him - which is the size this wants to be.
A prototype where one revealed habit won you the fight would have made the cards irrelevant.

## Why the page does not use an ES module import

`rules.js` is a pure module - no DOM, no I/O, no `Date`, no `Math.random`, no state outside the object
you pass it - but it is written in a UMD shape rather than with `export`: in Node it exports through
`module.exports` (which `rules.test.mjs` and `balance.mjs` import), and in a browser it publishes
`window.FightCampRules`. It has to, because **browsers refuse to load ES modules over `file://`** (the
module fetch is a cross-origin request), and the acceptance for this prototype is that double-clicking
`index.html` plays a bout. If the game ever moves behind a dev server, converting the top and bottom
of `rules.js` to `export`/`import` is a two-minute change.

## Data-driven: another art later

Everything the fight knows is data in `rules.js`:

- `CARDS` - one object per card (name, kind, cost, damage, accuracy, ranges, one line of text, `art`).
- `MATRIX_ROWS` - the resolution table, one 12-character row per card.
- `STYLES` - how a corner likes to fight: a weight per card.
- `HABITS` - a `when` situation and the card he plays in it, plus the sentence the player reads.
- `CAMP_CARDS`, `CORNER_CARDS`, `BOXERS`, `JUDGES` - decks, corners, the roster, the judges' tastes.

A new art (Muay Thai, then the rest) is a new `CARDS` block with `art: 'muay_thai'` and its own table,
kicks and elbows in the kind list, and a roster of its own. The engine only reads these tables; nothing
in `playExchange` knows what a jab is.

## What I would add next

1. **The opponent reads back.** The AI already scores cards against the foe's style, but it does not
   notice when you keep slipping the same punch. Let it update its belief from the last three cards and
   the read becomes a two-way game.
2. **Corner plans that change rules, not numbers.** "Change the plan" should let you set a standing
   order ("if he is hurt, sit down on the right hand"), so the corner shapes the fight instead of
   topping up stats.
3. **A proper camp budget.** Four free picks is generous; make each week cost purse money and fatigue,
   so the camp is a choice about the fight you expect, not a shopping list.
4. **Fatigue between fights.** A career of three bouts, with damage carried over, would make the
   "ice the eye" corner card a real decision rather than a small heal.
5. **More boxing first, not more arts.** Cutmen, cuts and swelling, a referee who warns for holding,
   and a second habit per boxer revealed only by a corner card. Depth in boxing before breadth.

## Balance table (2,000 bouts)
```
FightCamp card game - balance: 2000 AI-vs-AI boxing bouts

Style pairs (left corner v right corner)
  pair                      bouts  left wins  right wins   draws
  counter v counter            65      46.2%       49.2%    4.6%
  counter v out               148      45.9%       43.9%   10.1%
  counter v pressure          143      39.9%       55.2%    4.9%
  counter v volume            144      55.6%       38.9%    5.6%
  out v counter               142      42.3%       51.4%    6.3%
  out v out                    71      46.5%       50.7%    2.8%
  out v pressure              132      43.2%       51.5%    5.3%
  out v volume                155      52.9%       38.1%    9.0%
  pressure v counter          148      48.0%       46.6%    5.4%
  pressure v out              137      46.0%       48.9%    5.1%
  pressure v pressure          75      50.7%       45.3%    4.0%
  pressure v volume           140      55.7%       38.6%    5.7%
  volume v counter            144      45.1%       47.2%    7.6%
  volume v out                151      40.4%       49.0%   10.6%
  volume v pressure           145      44.1%       49.0%    6.9%
  volume v volume              60      50.0%       41.7%    8.3%

Cards: how often played (share of all exchanges, both corners) and win rate when played
  card              kind         plays    share win when played  avg dmg
  Jab               Punch        11770    33.4%           45.5%      3.1
  Cross             Punch         7663    21.7%           44.0%      5.5
  Lead hook         Punch         4595    13.0%           55.4%      7.0
  Body hook         Punch         9063    25.7%           44.7%      5.1
  Uppercut          Punch         8446    24.0%           55.4%      7.9
  Slip              Defence       4168    11.8%           32.4%      1.5
  Block             Defence       2342     6.6%           37.3%      1.1
  Roll              Defence       4466    12.7%           32.9%      1.7
  Clinch            Defence       4611    13.1%           51.6%      2.4
  Step back         Footwork      2886     8.2%           29.9%      1.1
  Pivot out         Footwork      3897    11.1%           46.8%      0.9
  Cut off the ring  Footwork      6583    18.7%           39.4%      2.7

How the bouts end
  stoppage                 239    11.9%   (round 1: 10, round 2: 35, round 3: 194)
  on the cards            1761    88.0%
  draws                    133     6.7%
  knockdowns / bout       1.68
  exchanges / bout        17.6

RESULT: PASS - no card over 65% win-when-played, no card under 1% of exchanges played
```

## Three bout transcripts (AI v AI)
```
--- bout 3 (Ines Duarte v Rio Tanaka)
R1.1 [out] Your cross misses; his step back lands
R1.2 [inside] Your body hook lands in a trade; his uppercut misses
R1.3 [inside] Your cross misses; his block lands
R1.4 [inside] Your block lands in a trade; his body hook lands in a trade
R1.5 [inside] Your pivot out finds nothing; his roll finds nothing
R1.6 [mid] Your jab lands in a trade; his cross misses
R2.1 [inside] Your jab is mostly smothered; his uppercut lands
R2.2 [inside] Your lead hook lands in a trade; his cross lands in a trade
R2.3 [inside] Your cut off the ring lands; his roll is mostly smothered
R2.4 [inside] Your cut off the ring lands; his slip is mostly smothered
R2.5 [mid] Your jab is mostly smothered; his slip lands
R2.6 [mid] Your uppercut misses; his cross is mostly smothered
R3.1 [mid] Your jab lands in a trade; his roll lands in a trade
R3.2 [inside] Your jab is mostly smothered; his uppercut lands — you are down! KNOCKDOWN
R3.3 [inside] Your jab lands in a trade; his body hook lands in a trade
R3.4 [inside] Your body hook is mostly smothered; his pivot out lands
R3.5 [inside] Your cross lands in a trade; his cross lands in a trade
R3.6 [inside] Your cut off the ring lands in a trade; his uppercut lands in a trade
RESULT: Rio Tanaka wins on points. (27-30, 27-30, 27-30 on the three cards.)
--- bout 11 (Ines Duarte v Rio Tanaka)
R1.1 [inside] Your jab is mostly smothered; his uppercut lands — you are down! KNOCKDOWN
R1.2 [mid] Your jab lands in a trade; his cross lands in a trade
R1.3 [mid] Your cross lands in a trade; his roll lands in a trade
R1.4 [inside] Your uppercut lands in a trade; his slip lands in a trade
R1.5 [inside] Your body hook lands in a trade; his uppercut lands in a trade
R1.6 [inside] Your block is mostly smothered; his uppercut lands — you are down! KNOCKDOWN
R2.1 [mid] Your jab lands in a trade; his cross lands in a trade
R2.2 [mid] Your body hook misses; his roll lands
R2.3 [inside] Your cut off the ring lands; his roll is mostly smothered
R2.4 [inside] Your cut off the ring lands in a trade; his body hook misses
R2.5 [inside] Your lead hook is mostly smothered; his block lands
R2.6 [inside] Your pivot out finds nothing; his slip finds nothing
R3.1 [mid] Your jab lands in a trade; his jab lands in a trade
R3.2 [inside] Your cross misses; his uppercut lands
R3.3 [inside] Your cut off the ring is mostly smothered; his pivot out lands
R3.4 [inside] Your jab misses; his block lands
R3.5 [inside] Your cut off the ring lands in a trade; his body hook lands in a trade
R3.6 [out] Your cross is mostly smothered; his step back lands
RESULT: Rio Tanaka wins on points. (26-30, 26-30, 26-30 on the three cards.)
--- bout 25 (Mara Okafor v Kwame Boateng)
R1.1 [mid] Your body hook misses; his body hook misses
R1.2 [mid] Your lead hook lands in a trade; his body hook misses
R1.3 [inside] Your cut off the ring lands in a trade; his uppercut misses
R1.4 [inside] Your cut off the ring lands; his cross is mostly smothered
R1.5 [inside] Your body hook misses; his body hook misses
R1.6 [inside] Your cross misses; his body hook lands
R2.1 [inside] Your cross misses; his cut off the ring lands
R2.2 [inside] Your clinch lands in a trade; his cut off the ring lands in a trade
R2.3 [inside] Your uppercut is mostly smothered; his clinch lands
R2.4 [inside] Your body hook is mostly smothered; his roll lands
R2.5 [inside] Your clinch is mostly smothered; his jab lands
R2.6 [inside] Your body hook is mostly smothered; his clinch misses
R3.1 [inside] Your body hook misses; his uppercut lands in a trade
R3.2 [inside] Your body hook lands in a trade; his body hook misses
R3.3 [inside] Your body hook misses; his clinch lands
R3.4 [inside] Your clinch lands; his body hook is mostly smothered
R3.5 [inside] Your uppercut misses; his uppercut misses
R3.6 [inside] Your lead hook lands in a trade; his body hook lands in a trade
RESULT: Kwame Boateng wins on points. (28-29, 28-29, 28-30 on the three cards.)
```
