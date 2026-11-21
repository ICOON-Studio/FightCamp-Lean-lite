# TASK CARDPROTO1 - a card-game version of FightCamp: playable browser prototype, boxing only (owner S536)

Seat: Arena (arena.ai Agent Mode) on ICOON-Studio/FightCamp-lite, branch master. Work on your own arena/ branch, open a PR,
never merge. Discipline: boxing only; other martial arts come later (keep the rules data-driven so a new art = new card data).
Owner S536: "make a card game version of our game, a prototype only for boxing and then we will add other arts".

## What FightCamp is (so the cards are OUR game, not a generic one)
A boxing gym management game. The player is the club's head coach, not the boxer: he picks a boxer, trains him through camp
weeks (Technique, Power, Conditioning, Defence, Speed), writes a fight plan, and in the fight shouts one call every 30
seconds and changes the plan in the corner between rounds. Amateur bouts are 3 x 3 min; a pro debut 4 rounds. A boxer has
Power, Speed, Stamina, Chin, Technique, Defence (0-100), a style (Out-boxer, Pressure, Counter-puncher, Volume puncher) and
habits an opponent can read on film. Our measured weakness: choices that do not depend on the moment are fake. Every card
must be a TRADE whose value depends on the opponent, the round, or what you have read about him.

## Build: `proto/cardgame/` only (no other folder, no .gd, no Godot)
1. `rules.js` - a PURE rules module (ES module, no DOM): data + functions, seeded RNG (pass a seed; same seed = same bout).
   - CAMP (before the fight, 4 weeks): each week pick 1 of 3 training cards; each adds cards to the boxer's FIGHT DECK or
     raises a stat a little. Camp shapes the deck - this is the manager layer.
   - FIGHT: 3 rounds x 6 exchanges. Each exchange both corners play ONE card face down, reveal together. Card kinds:
     punches (Jab, Cross, Lead hook, Body hook, Uppercut), defence (Slip, Block, Roll, Clinch), footwork (Step back, Pivot
     out, Cut off the ring). A clear resolution table (e.g. Slip beats straight punches, Roll beats hooks, a hook beats a
     clinch attempt at range, Cut off the ring beats Step back) - write it as data. Damage to head and body, stamina cost per
     card, landed / thrown counts, a knockdown on a big head shot to a tired or hurt boxer; 3 knockdowns or a hurt boxer on
     zero stamina = stoppage. Three judges score each round 10-9 by landed and damage.
   - THE READ: the opponent AI has a style and 2 habits (e.g. "drops his right after a jab", "always clinches when hurt");
     scouting before the fight reveals 0-2 of them; a habit makes his card choice predictable in a stated situation, so
     reading pays. Shown to the player as words, never as numbers.
   - THE CORNER: between rounds pick 1 of 3 corner cards (Ice the eye, Change the plan: draw 2, Breathe: +stamina, Gloves
     high: Block costs less next round...). Each costs something.
   - Boxer stats modify card strength (Power -> punch damage, Speed -> wins ties, Stamina -> card costs, Chin -> knockdown
     threshold, Defence -> defence cards, Technique -> fewer misses).
2. `index.html` + `ui.js` - one page, no build step, no external libraries: pick 1 of 2 boxers (different stats and style),
   play the 4 camp weeks, see the opponent's scouting file, fight 3 rounds with your hand of 5, the reveal, a short line per
   exchange ("Your jab lands; she slips the cross"), the round scores, the corner, the result. Dark theme; card faces drawn
   in CSS (name, kind, cost, one-line effect). Readable at 1920x1080 and at 1280x720.
3. `rules.test.mjs` - `node proto/cardgame/rules.test.mjs` prints `PASS`/`FAIL` per check and exits 1 on any failure:
   resolution table (every pair), stamina never below 0, scoring 10-9 / 10-8 on a knockdown, stoppage rule, same seed =
   same bout, a habit fires in its situation.
4. `balance.mjs` - `node proto/cardgame/balance.mjs` plays 2,000 AI-vs-AI bouts (different boxers and styles, never two
   identical boxers) and prints: win share per style pair, how often each card is played and its win rate when played, and
   the share of bouts decided early by stoppage. Report the result in the PR body; a card that wins more than 65% of the
   time it is played, or is never worth playing, is a design defect to fix before the PR.
5. `README.md` in proto/cardgame: how to play, the rules in plain words, the resolution table, what you would add next.

## Acceptance (put these lines in the PR body)
- RESULT: node proto/cardgame/rules.test.mjs -> all PASS
- RESULT: node proto/cardgame/balance.mjs -> the printed table (and no card over 65% win-when-played)
- The page opens from the file system (double-click index.html) and a full bout can be played to a result.
Do not edit anything outside proto/cardgame/. Do not delete or weaken a test to go green. Everything is public: no
third-party art or text; card names are generic boxing words.

## Prior research (Claude)
John is studying boxing / fighting card games (ops/research/JOHN_CARDGAMES_RESEARCH.md, answer pending); Dola is queued for
card-set ideas; a v2 round will fold both in. The owner's stance idea (docs/mockups/s536/stance.png) can become a camp card
later - not in v1.

## Contract
OWNS: proto/cardgame/rules.js, proto/cardgame/ui.js, proto/cardgame/index.html, proto/cardgame/rules.test.mjs,
proto/cardgame/balance.mjs, proto/cardgame/README.md
RED_TEST: proto/cardgame/rules.test.mjs (new)
REGRESSION: none (nothing in the game touched)
VISUAL: yes - Claude opens the page and plays a bout before merge
