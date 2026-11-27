# DESIGN BUILD1 - the fighter's body as a ship: cards live on the body parts, the deck is what the body holds (S570)

Owner S569 (verbatim): "maybe Try scaling health and the other parameters to start at 50 (or 75) and possible to reach 100
later ... the energy management should be part of the decision making (maybe lower health limits your stamina pool orr
something) . Also consider this analogy with breachway : A fighters body similar as spaceship with variations , then you
can equip different discipline cards depending on your fighter and choices or progression so you will have those moves as
your deck in the fight like you do in breachway for each module , and you got to be careful which moves can blend and flow
etc . You may increase attacking action pool ,or defensive and body conditioning , analogy with the core and card mechanics
increase your earned resources in breachway." And: "we can use it as unique feature so that the player drafts his deck on
the spot , and of course not all move can be combined with others".

Status: design + greybox probe (two rounds) + critics. Nothing on any page or rule file changed. Puncher's chance, boxing first.

## 1. Breachway, read from the installed files (our words; nothing of theirs copied)
Read-only: identifiers in `Breachway_Data/il2cpp_data/Metadata/global-metadata.dat` (153,577 names) and our CARDREF1 notes
(the card table: 1,823 entries, each card rests 0 to 8 turns after use). What the structure says:
- **The ship is a set of mounts** ("hardpoints"). Each mount takes one family of part (an install type decides what fits).
- **A part carries card slots** (a base number of slots per part, more slots from upgrades and from crew) **and passive
  sub-slots** (small modifiers that change the part's cards). The deck in a fight = the cards the installed parts carry.
- **The core (the reactor) sets the economy**: energy made a turn, a ceiling on stored energy, a hand size. It can be
  upgraded, and it has a second purse (heat): spend past a line and you pay a penalty. Energy comes in kinds (three
  allocations are named), so a card asks for the right kind, not only an amount.
- **Cards rest after use** (a cooldown in turns), so the strong card is away for a known time.
- **Slots can be broken or disabled in a fight** (names for a broken slot, a damaged slot, a disabled slot): the enemy
  takes your cards away by hitting the part that carries them.
- **Parts and cards can be combined / merged** for a fee, and the game shows the combined result before you commit.
- **Crew** add slots and their own small energy pool.
How builds differ: which parts sit on which mounts (what kinds of card you can carry at all), how many slots each has, the
core's level (how much you can play a turn), and which cards you upgraded. A build is a set of trade-offs, never "more".

## 2. The map: the fighter's body = the ship
| Breachway | Puncher's chance | What it holds / does |
|---|---|---|
| mounts (hardpoints) | **five body parts**: Lead hand, Rear hand, Legs, Core (trunk), Head | each part takes only its own kind of card |
| card slots on a part | **discipline slots** | Lead: jab family, hooks, feint, push off. Rear: cross family, overhand, uppercut, body cross. Legs: footwork (and kicks when kickboxing comes). Core: clinch, body defence. Head: passives (chin, eyes) |
| the core / reactor | **conditioning (the engine)** | the health bar and the stamina bar |
| energy a turn | **attack pool** | stamina you may spend in one beat and the weight of your punches |
| shields / hull upgrades | **defence pool** | the guard bar (and, measured, what else it must buy: section 6) |
| a broken slot | **a hurt part** | body shots already shorten the stamina bar (the core is hit); kickboxing's low kick takes a Legs card away for the round; a hurt hand is rare (a cut, a bad hand) |
| upgrading a card | **drilling a card** in camp | +1 damage OR 1 less stamina (pad time: the game's decided "a new move is a weapon in 2-3 weeks of pad time") |
| a new slot | **a new weapon learned** | costs camp weeks, never wins |
| crew | **the coach** | a coach's speciality opens one slot of his kind (a boxing coach: a hand slot; a kickboxing coach: a Legs slot) |

**The base cards every body holds** (like the two free blocks in Mixed Martial Cards, so no hand is ever dead): jab, cross,
both guard holds, step in / hold / back off. The build ADDS discipline cards on top: three at the start of a career.

**What is new (why this is not one more deckbuilder, S551 "there are 1 million deckbuilding games")**: there is no draw and no
shuffle. The hand IS the body: every card is always visible on the part that carries it, and **the opponent's punches
take cards away by hurting the part** (the body shot that shortens your stamina is the first such link and is built
already). You do not build a deck; you build a fighter, and in the fight you defend the parts your best cards live on.

## 3. The three pools (his scale: start at 50, grow toward 100)
Shown as three numbers on the fighter's body card: **Conditioning, Attack, Defence**, each 50..100. The in-fight bar reads
the same scale (a 50-health man's bar says 50; damage shows in the same units). Engine: **75 = today's man** on the boxing
page (health 18, stamina 8, up to 6 stamina a beat, guard 6) - the probe's mapping, so 50 = two thirds of today's man.
- Conditioning: health and the stamina bar.
- Attack: how much stamina you may spend in ONE beat (50 = 4, 75 and up = 6: at 50 you throw one punch a beat, rarely two)
  and the weight of your punches (x attack / 75).
- Defence: the guard bar. **Measured: on its own it buys nothing** (section 6, v1). Round 3 makes it buy the chin.
His "lower health limits your stamina pool": measured in section 6 - as a straight link it halves the comebacks
(25% -> 11%), so it is NOT taken as written. RULES569 idea 3 owns the link on the page; this design keeps the body shot
(already built) as the one health-to-stamina link.

## 4. Blend and flow (the deck-building decision)
**Combination table** (two cards dropped on each other = ONE move in ONE moment; RULES569 idea 4 measures it on the page):
| Pair | Combines? | Why (boxing) |
|---|---|---|
| Step in + Jab | yes: the stepping jab | the jab is thrown on the step; the classic way in |
| Back off + Lead hook | yes: the pull counter | weight goes back, the lead hook comes round as he follows |
| Feint (lead) + Cross | yes: feint and cross | the feint draws the hands, the cross goes through the gap |
| Body hook + Lead hook | yes: up-and-down (two moments) | the same hand, body then head, the classic double |
| Two rear-hand punches | no | one rear hand, one moment |
| Back off + Overhand | no | the overhand needs weight moving forward |
| Clinch + any punch | no | both hands are holding |
| Push off + any lead punch | no | the lead glove is on his chest |
**Flow** (which card follows which in the next moment of a beat): jab -> cross, body -> head, feint -> anything. A body
that holds both ends of a flow pair plays it; the slot budget decides which flows you own. Flow bonuses are not measured
here (the page's order of moments already pays some: a counter after a block is +1).

## 5. How it plugs into what exists
- **The fight page** (order.html, the hand of cards S568 "i like the B", the strip Lead / Rear / Feet): the hand is grouped
  by body part on the body view (S561: the body view replaced the board). A hurt part greys its cards ("Legs hurt: no
  step in this round"). Nothing is drawn near the fighters (S562): the cards sit in the panels.
- **The gym side**: training focus raises a pool (the decided pace: 1.0 a focused week, headroom clamp), pad time drills
  a card (MoveMastery), camp weeks open a slot, the coach's speciality opens a slot of his kind. This is where the career
  and the fight finally meet: a week of training changes what the player can click in the next bout.
- **The styles = starting builds**: Outboxer (lead hand weapons, ring craft legs), Pressure fighter (hooks and body,
  stalking legs, the clinch), Generalist (more cards, none drilled). Kickboxing later adds Legs cards (kicks, checks):
  the same body, a new discipline's slots.
- **The ladder**: opponents carry builds and pools too, sized to the ladder (regional 50-60, national 70-80, pro debut 75-85).

## Feedback loops
- **Stronger build -> more wins -> more progression -> stronger build.** Caps: (1) opponents scale with the ladder (their
  pools and slots grow too: a 100 man meets 100 men); (2) slots are scarce - a slot costs camp weeks, never a win; at most
  3 discipline slots a part and 8 on the body; (3) drilling costs pad weeks the gym pays coach time for; (4) every pool
  stops at 100. Measured (v1): a 50 man v a 75 man wins 14%; 100 v 75 wins 58%; 100 v 100 wins 56 / 33 (11% draws) - the
  edge from growth is real and the ladder that grows with you cancels it.
- **Low health -> smaller stamina pool -> fewer actions -> more damage -> lower health** (his link). Floor: the stamina bar
  never drops below its minimum (today 4 of 8), stamina comes back every beat and at the bell. Measured: the share of men
  15%+ behind on health after round 1 who still win was 25% on today's rules and **11% with the link** (5 of 20 v 2 of 18:
  the bands overlap, decided by 3 bouts - the code check is right that this does not reject his link). Not taken YET:
  re-measure at n=200 on 3 seeds. A softer form (the link takes at most 2 off the bar) was
  queued and stopped by the PC's low-memory reaper before it ran.
- **Trial first**: one rep each (N=12, seed 1) of the outboxer and the pressure fighter mirrors ran before the probe: the
  two plan mixes differ (the outboxer: body cross 39%, holds his ground 41%; the pressure fighter: jab 38%, backs off 40%,
  body hook 29%, clinch 9%), so the probe went on.

## 6. The greybox probe (two rounds, measured)
Tool: `ops/research/s558_balance/build1_probe.mjs` (new; reads order.html's rules through rules.mjs; changes in memory only,
listed in full after the code check: a deck filter per man, the spend cap a beat, the clinch only with a clinch card (and,
round 3, not while the trunk is hurt), the stamina floor, the guard bar size, punch weight (x attack / 75, on health only -
points still come from the raw damage), the Legs cards; it also adds the drilled cards to the option lists, scales the
health a man gets up on to his health (round 3: to his defence), and adds a fourth 'mirror' opponent slot). Both men
play the beat's solved mix; the look-ahead is today's vtable.json (made for two equal full-deck men - an approximation for
unequal builds). Builds: base cards + 3 discipline cards + 1 drilled card. n=36, seed 1, jobs=1 per cell. Full output:
`results/build1_v1.txt`, `results/build1_v2.txt`. Control: today's man (all 12 cards, 75 everywhere) in the same loop.

**Control (today's rules, 75 v 75, every card)**: 47 / 39 / 14 (wins / losses / draws), stoppages 14%, 2.3 knockdowns a
bout, Inside / Mid / Long 32 / 36 / 32%, comebacks 25%. The loop agrees with the page's own bars.

**v1** (outboxer: drilled jab, body jab, feint, body cross; pressure: drilled cheap hook, body hook, clinch; generalist
control: drilled cross, hook, body jab, body cross):
| Cell (all at 50) | A wins / B wins / draws | stoppages | knockdowns | plan-mix distance |
|---|---|---|---|---|
| outboxer mirror | 47 / 36 / 17 | 8% | 1.9 | 0.09 |
| pressure mirror | 39 / 50 / 11 | 0% | 0.5 | 0.15 |
| generalist mirror | 47 / 44 / 8 | 0% | 0.8 | 0.12 |
| outboxer v pressure | 53 / 47 / 0 | 0% | 0.8 | **1.25** |
| outboxer v generalist | 28 / 58 / 14 | 8% | 1.5 | 0.70 |
| pressure v generalist | 36 / 56 / 8 | 0% | 0.6 | **1.30** |
| every card at 50 (control at 50) | 53 / 42 / 6 | 8% | 1.5 | 0.14 |
Growth (pressure fighter): 50 v 75 wins 14% (stopped 31%); 100 v 75 wins 58%; 100 v 100 56 / 33 / 11.
Where to put 50 points (a 100-50-50 man v a 67-67-67 man): into conditioning 33%, **attack 56%, defence 19%**.

**v2** (fixes tried: a Legs card per style - the pressure fighter may step in after your jab landed, the outboxer may back
off once more on the ropes; the generalist gets 4 cards and no drill; defence takes weight off the punches that land):
| Cell (all at 50) | A / B / draws | stoppages | knockdowns |
|---|---|---|---|
| outboxer mirror | 50 / 50 / 0 | 69% | 3.8 |
| pressure mirror | 36 / 56 / 8 | 67% | 3.9 |
| generalist mirror | 50 / 44 / 6 | 42% | 2.8 |
| outboxer v pressure | 64 / 31 / 6 | 36% | 2.7 |
| outboxer v generalist | 47 / 47 / 6 | 64% | 3.7 |
| pressure v generalist | 42 / 50 / 8 | 25% | 2.2 |
Spread: 100-50-50 v 67-67-67: conditioning 17%, attack 28%, defence 28% - spreading evenly beats any choice. 50 v 75: 0%.

**What the probe says**
1. **The builds play differently - yes.** Two builds against each other share far less of their plan mix (distance 0.7 to
   1.3) than a build against itself (0.1 to 0.2). The body-as-ship map makes styles real in the bout, not a label.
2. **A deck that is part of another tends to lose to it** (my first trial, at a scaling not kept, is not in the result
   files; Grok Dev's runs on the kept tool: 5 of the 12 cards v all 12 won 13%, the two base punches alone 0%). In theory a
   smaller set is never better, not always beaten. In a game of solved mixes more cards is never worse, so the full deck can never exist: slots must be scarce and
   every build an equal budget. Designed in.
3. **The pool scale decides how violent a bout is.** v1 (punch weight with attack, health with conditioning) keeps 50 v 50
   quiet - 0 to 8% stoppages (bar 10-40%); v2 (defence also takes weight off) makes it 42 to 69%. The number between lies
   in the weight curve, not in the map.
4. **Defence as a bar buys nothing; spreading must not beat choosing.** v1: defence 19% v attack 56%. v2: even spread
   beats every choice. A pool must pay in a way the others cannot - round 3 below.
5. **Dead cards**: the pressure fighter's lead hook is chosen in 0-3% of beats in the pressure MIRROR (13-27% in the cross
   cells); the overhand 0-1% at 50 (at conditioning 50 the stamina bar is 5, and the 3-stamina overhand leaves no lead
   punch beside it). The pressure mirror drifts to Long (46-51% of beats). The stalking Legs card was DEAD CODE (it lifts a
   rule the page switches off: `keep: 0`, Grok Dev's runs identical with and without it), so v2 says nothing about it.
   v2 also moved the pressure drill from the lead hook to the body hook (unstated before), and its 'defence takes weight
   off' made punches HEAVIER at 50 (damage / (50/75)): that, not defence, is why v2 bouts were violent.
6. **His health-to-stamina link halves comebacks** (25% -> 11%): not taken as written.
7. Growth changes outcomes the way a career should: 50 v 75 is a heavy loss (14%, v2 0%), 100 v 75 a clear win, a ladder
   that grows with you stays level.

## 7. Round 3 (the design as it now stands, to be measured next)
- **Pools pay in kind, with thresholds (Breachway: the core's level gates what you can mount)**: Attack 60 opens a 2nd
  punch a beat (spend 5), 75 opens the big punches (overhand, rear uppercut). Defence buys the CHIN: get-up health after
  a knockdown (x defence / 75) and the guard bar; Conditioning buys health and the stamina bar. So spreading evenly leaves
  you without the threshold cards - a choice with a cost.
- **Weight curve**: punch weight = attack / 75, health = 18 x (conditioning + 75) / 150 (50 = 15 health), so 50 v 50 sits
  inside 10-40% stoppages.
- **Pressure's card**: the stalking Legs card ALSO takes one ground step from him when you step in and he backs off (the
  cut-off), and the lead hook is replaced in the pressure build by the up-and-down pair (body hook -> lead hook, one card).
- **The hurt part** (the innovation measured): a landed body shot greys one Core card for the round (the clinch) as well as
  shortening the stamina bar - measured only after the above holds.
- Bars for round 3: every build mirror inside the page's bars; each cross-match 35-65%; the three styles form a cycle or
  sit within 40-60% of each other; no card under 3% in its own build; where-to-put-50 points: each choice 35-65% v the
  even spread; comebacks at least 20%.

## 6b. Round 3 measured (after Kalli's critique; n=200, seed 11, `results/build1_v3.txt`)
Round 3 as section 7 wrote it, less the up-and-down card (not in the engine): the pressure build carries the body cross in
place of the lead hook; the generalist is the boxer-puncher (one of the game's styles), its overhand open from attack 75;
a landed body punch takes the trunk's card (the clinch) away for the NEXT beat only (Kalli PLAY 1).
| Cell (all at 50) | A / B / draws | stoppages | knockdowns | came back | distance |
|---|---|---|---|---|---|
| outboxer mirror | 49 / 45 / 6 | 18% | 1.9 | 23% | 0.08 |
| pressure mirror | 48 / 44 / 8 | 2% | 0.5 | 25% | 0.08 |
| boxer-puncher mirror | 50 / 42 / 9 | 2% | 0.5 | 10% | 0.05 |
| outboxer v pressure | 48 / 46 / 7 | 2% | 0.6 | 16% | 0.78 |
| outboxer v boxer-puncher | 34 / 57 / 9 | 10% | 1.3 | 15% | 0.48 |
| pressure v boxer-puncher | 46 / 46 / 8 | 4% | 0.6 | 16% | 0.54 |
Where to put 50 points (pressure, v 67-67-67): conditioning 28%, **attack 58%, defence 16%**.
Growth (boxer-puncher): 50 v 75 wins 14% (stopped 50%); 100 v 75 wins 60%.
- PASS: every cross-match inside 35-65% of decided bouts (outboxer v boxer-puncher 37%) - the styles are now close, not a
  cycle; the builds still play differently (0.5-0.8 v 0.05-0.08); growth reads like a career.
- FAIL: pools still have one answer (attack 58, defence 16 - the chin does not pay); bouts at 50 are too quiet for two of
  three builds (2-4% stoppages, bar 10-40%); comebacks 10-16% in four of six cells (bar 20%); the trunk is hurt 6-10 times
  a bout (body punches are common), so "the clinch is away" is the normal state, not an event; the feint is 1-7%.

## 8. Critics (two fresh, one code-checked) - neither reaches 8
| Critic | DEPTH | PLAY | GENERAL | SPEED | FIRST 5 MIN | File |
|---|---|---|---|---|---|---|
| Kalli (design) | 6 | 6 | 5 | 6 | 4 | BUILD1_CRITIC_KALLI.md, 10/10 page BUILD1_CRITIC_KALLI_10.png |
| Grok Dev (code-checked, ran 27 of its own probes) | 4 | 4 | 5 | 6 | 3 | BUILD1_CRITIC_GROKDEV.md, 10/10 page BUILD1_CRITIC_GROKDEV_10.png |
Both scored the page at commit 4ecd137 (rounds 1-2; round 3 was measured after, and fixes only the cross-matches).
Both agree: the body-as-ship spine is right ("for the first time a week in the gym changes what the player can press in the
next bout"); the pools have one right answer; the hurt part - the one new idea - is unmeasured where it matters (protect a
part as a choice); dead or hidden cards; too much for the first five minutes. The code check found 18 page-v-code faults;
the ones that changed a conclusion are corrected above (dead stalking card, unstated drill move, v2's heavier punches, the
subset claim, the comeback rejection decided by 3 bouts, the hook "dead in every cell", the overhand reason).

## 9. The next round (from both critics' To reach 10/10, most important first)
1. **Pools: no single right answer.** Sweep all 21 splits of the 50 spare points, 200 bouts x 3 seeds: no split over 60%,
   each pool's best split at least 40%. Defence must pay something attack cannot (a shown threshold: from 60 a blocked
   body punch costs no stamina, from 75 the slip card) and never make punches heavier (ab = max(1, D / 75)).
2. **A look-ahead per build** (vtable for each pair: deck, spend cap, bar sizes) - every cell today borrows the
   full-deck 18-health table. This is the heavy step (a table a pair): needs a PC slot, not a worker beside two others.
3. **The hurt part as a choice:** a held hand guards a PART (lead low covers the trunk cards this beat); a part loses at
   most one card a round, back at the bell; measure protect v not-protect (8+ points of win share) and comebacks 20%+.
4. **Dead cards out:** the stalking card gets a live rule ("your step in beats his back off even on the ropes") or goes;
   feint + cross becomes one slot card owned by the builds that pay for it (Kalli: it decided all five of her bouts);
   every discipline card in 5%+ of its build's beats.
5. **Words:** four parts - Lead hand, Rear hand, Feet, Trunk (Head cut: the chin belongs to Defence); Engine for
   conditioning; the pools map to the agreed abilities (Conditioning = stamina, recovery, durability; Attack = strength,
   explosiveness, speed; Defence = defence, footwork, composure); "the opponent", never he.
6. **First five minutes:** the coach builds the first body (base cards + one discipline card), one thing opens per bout
   (slots after bout 1, thresholds after 2, combining after 3); a spar test (wins in 100 v the booked opponent) before a
   slot is locked; every grey card says why in one line.
7. Re-measure his health-to-stamina link at n=200 x 3 seeds before it is rejected.

BUILD1 BLOCKED: two fresh critics scored DEPTH 6 / 4 and PLAY 6 / 4 (bar 8); round 3 fixed the style cross-matches but the pools still have one right answer (attack 58% v defence 16%), and the next round needs a look-ahead table per build pair (heavy CPU, not with two measuring workers on the PC) and the hurt part as a guard choice on a page this worker does not own
