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
   nothing at all, which is the point. A habit is a promise: in one stated situation he plays that card,
   every time. Reading pays.
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
the right hand; hit him clean and he gives ground. Every habit is shown to you as a sentence, never as
a number, and only the ones on film.

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
