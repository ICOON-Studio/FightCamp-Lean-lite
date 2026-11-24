# CARDRANGE_SCOPE_S550 - boxer v boxer version 3: where the two men stand

## The finding (a METHOD finding)
Two code-checked critic rounds in one session put the same thing first:
- version 1 (`BOXCARDS1_CRITIC_ARENA.md`, real bout 5, depth 6, play 6): "Range: only temporary step/ropes flag";
- version 2 (`BOXCARDS2_CRITIC_ARENA.md`, 6 / 5 / 7): "no range, no way to advance or cut off a retreat, and several
  card outcomes are unconditional physical facts".
It is also item 1 of Arena's fourteen things a boxing card game must carry (`proto/cardgame/CARDBOX1_BREAKDOWN.md`).
A step back, a clinch, a body hook and an uppercut are card facts today because nothing says how far apart the men are.

## The rule until this is done
No third patch round on version 2's numbers (head bar, breather price, leads a round). Version 2 stays as it is on the
page the owner plays (`proto/boxcards/`, phone: https://claude.ai/artifact/RVECDqN7dwM9NLGVqQjQxq). His notes on
that play are read BEFORE version 3 is written: they may change what range has to do.

## Version 3 on paper first (Claude's starting direction, not yet probed)
One shared track, three places: LONG (the end of the jab), MID (punching range), INSIDE (chest to chest).
- What reaches where: jab at Long and Mid; cross at Mid; lead hook and body hook at Mid and Inside; uppercut Inside.
- Coming in: a jab that turns at Long carries him to Mid (so jab - cross works from Long and a bare cross does not);
  the leader may also pay 1 wind to step in one place before his volley - seen by the other man - or step out.
- Going back: a step back moves the range one place out and the punch falls short; at Long there is nowhere left, so
  he is on the ropes (today's flag becomes a place). A man on the ropes cannot step back until he has led or turned
  off (a leader's "step in" on him is cutting off the ring).
- Tying up: a clinch needs Mid or Inside and takes the range to Inside; the referee's break puts them at Mid.
- A counter must be a punch that reaches at that range.
- The bell puts them back at Long.
What this should buy: the out-boxer's game (hold Long, score with the jab, step back) against the pressure game (get
Inside, hooks, body, uppercut), from the SAME deck - before any style decks. It also gives the feint a ring meaning
later (a feint that draws the step back).

## Phases
| Phase | What | Done when |
|---|---|---|
| 0. His play of version 2 | He plays the page; his words are quoted here | his notes, or "go" |
| 1. Paper | The range rules above as a full page with one walked bout; every card names where it reaches | every exchange of the walk says where the men are |
| 2. Greybox | `proto/boxcards/rules3.mjs` + bot + probe + tests; a one-bout trial first | the bars below |
| 3. Critic | a fresh code-checked critic (Arena), then the chat critics | 8 on depth and 8 on play |
| 4. Page | the page shows the range as a strip between the two corners | HIS PLAY |

## Bars for phase 2 (written before any run)
- Version 2's bars still hold: first lead 45-55%, a combination in most bouts, empty leads under 10%, no card unused,
  no blind pilot over 60% against the reader.
- RANGE IS FOUGHT FOR: each of the three places holds 15% or more of the punches turned; the range changes in half
  the exchanges or more.
- TWO GAMES FROM ONE DECK: a pilot that always seeks Long and one that always seeks Inside each win 35-65% against the
  reader, and each beats the other in 35-65% (neither is the answer).
- NO RUNNING: a pilot that steps out or back whenever it may wins under 50% (the ropes and the cut-off bite).
- To the judges: not a bar until a real three-round amateur sample exists (Arena, twice: 40-70% was never a boxing fact).

## Feedback loops
- Stepping back -> Long -> only jabs reach -> more stepping back. Capped: the ropes at Long, the leader's step in, the
  jab that carries him to Mid. Measured by the NO RUNNING bar.
- Inside -> clinch -> break to Mid -> step in -> Inside. Capped: no clinch twice running, the third hold costs a point.
- Body work Inside -> shorter wind bar -> he cannot pay to step out -> more Inside. Capped at a bar of 2; print the
  share of exchanges at each place by round.
- One-rep trial: one bout printed with the range on every line before any 400-bout table.

## Prior research
`DESIGN_BOXCARDS1.md`, `DESIGN_BOXCARDS2.md`, both critics, `CARDBOX_SCOPE_S549.md`, `CARDBOX1_BREAKDOWN.md` (items 1
and 8), `CARDREAL_AUDIT.md` (the old game's range letters K / P / C: the same idea, mixed with the floor).

## Phase 0 - his play of version 2 (S551, 2026-11-24)
- On the answer prompt's "Take it - His Jab lands clean" button: "ithink this is dumb , need to find better mechanic".
  Measured on 400 reader v reader bouts of version 2 (24.9 prompts a bout): "Take it" was the ONLY button in 28%, it
  stood beside one answer in 41%, and it was picked in 1% of the prompts that offered anything else. The prompt is not
  a decision.
- On the two bars: "i do not see health wtf is this ?" (the bar was "Head 0 of 8", filling as he is hit). The page now
  shows HEALTH 8 of 8 draining and STAMINA (was Wind); no rule or number changed. Version 3 keeps those two words.

## Step A of version 3: THE DEFENCE IS LAID, NOT ASKED (built S551, `rules3.mjs`, `bot3.mjs`, `probe3.mjs`)
The leader lays up to three cards face down. The other man sees how many, and the FIRST card, and lays his own line
against them: one answer or nothing against each place. Both lines turn over together. A punch that meets nothing
lands (no button). An answer that cannot meet its punch is wasted; a feint draws out the answer laid against it; answers
in places never reached go back to the hand free. Everything else is version 2 (range is step B, on top of this).
One-bout trial first (`node proto/boxcards/probe3.mjs walk=1 seed=5`), then 400 bouts:

| Bar (written from his note) | Version 2 | Laid, first card seen | Laid, nothing seen |
|---|---|---|---|
| "No defence" chosen when he could defend (a real choice: 10-50%) | 1% | 13% | 1% |
| Ways to defend to pick from, on average | 1 to 2 buttons at 69% of prompts | 16 lines | 17 lines |
| His line was the best against what really came (40-80%: read, not solved, not a coin) | - | 70% | 28% |
| Laid answers wasted or drawn out | - | 16% | 40% |
| First lead wins (45-55%) | 54% | 50% | 45% |
| Empty leads (under 10%) | 7% | 12% NOT MET | 7% |
| Bouts to the judges | 80% | 74% | 55% |
| Best blind pilot against the reader (under 60%) | none over 50% (DESIGN_BOXCARDS2) | 38% (an answer in every place) | not run |
Blind pilots, first card seen, 200 bouts each: never defends 4%, a block everywhere 8%, a slip everywhere 8%, clinch 5%,
step back 6%, answers only the card he sees 21%, an answer everywhere 38%, jab-cross-hook every lead 11%, all jabs 13%,
never leads 0%. VERDICT: seeing the first card is the version to keep (seeing nothing is a guess: right 28% of the time).
NOT MET: empty leads 12% (the breather is taken more now that a lead is answered blind) - a number for step B, not
tuned here. NOT MEASURED: fun - his play of the page (`proto/boxcards/v3.html`).

### Feedback loops (step A)
- Laid answers are wasted -> stamina gone -> he cannot lead -> breathers. Capped: 3 stamina back before each exchange,
  a breather gives the other man 2 points; measured as empty leads (12%).
- Slip-and-counter ends his volley -> the leader leads one card -> one card is easy to answer. Seen: 34% of leads are
  one card (version 2: 27%). Watched in step B, where a jab that turns carries him in.

## S551, later the same play: THE FORM ITSELF IS IN QUESTION (a METHOD finding - this scope is ON HOLD)
His words: "there are 1 million deckbuilding games , do a proper research if you have too , i expect a proper innovative
design , you can interview me if needed . here is an idea : ironbound for example it has four slots 1left hand 2 right
hand 3 trinket (it can be left leg) 4 trinket (it can be right leg) add more if need for knees and elbows".
- So: no step B (range) on this deck engine until the form is settled with him. Step A's page (`v3.html`, `page3.js`) is
  on disk, NOT played in a browser by anyone, not linked from the page he plays.
- Ironbound, checked S551: our files hold nothing true about it (CARDREF1 s5 "not read, encrypted packs"; Dola's market row
  "3 lanes, weapon + shield" is contradicted by the reviews). From reviews (bitsandpieces.games 2020, Steam): four classes,
  each a FIXED set of tokens (no deck building); on your turn you play a token from your hand OR activate a piece of
  equipment; four equipment slots, two weapons and two trinkets; upgrades make equipment stronger. Reviewers' complaint:
  "playing whatever cards you happen to have and then using your weaponry" (thin decisions) - the thing ours must beat.
- Not the same as his S537 "action points for each limb", which was probed as limb LIGHTS on a card deck and lost to the
  wind pool (DESIGN_CARDGAME_SCOPE 6d). Slots that HOLD a technique and are always there to use is a different form.
- Next: the interview he offered, then `ops/research/BODYSLOTS_SCOPE_S551.md` (paper, greybox probe, critics at 8).
