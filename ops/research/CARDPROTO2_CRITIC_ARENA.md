# CARDPROTO2 — independent, code-checked critic (round 2)

Fresh critic, not the author. I read `proto/cardgame/README.md`, `rules.js`, `rules-data.js`,
`rules-exchange.js`, `rules-ai.js`, both test files, `balance.mjs` and the scoring code in `ui.js`,
then played **~120,000 complete bouts through the shipped engine** with my own harnesses. Nothing in
`proto/` was edited; no test was deleted or weakened. My harnesses live outside the repo (`/tmp`), and
every number below is reproducible with the recipe in the last section.

## Verdict

**DEPTH: 4/10 · PLAY (fun): 5/10 · GENERAL: 4/10.**

**Does not meet the keep-mechanic bar (8+ DEPTH and 8+ PLAY).** Round 2 fixed the round-1 sins — the tell
is real, the AI reads the film, camp and corner effects fire — and then overcorrected: it handed the player
a **free, per-exchange, 55–85%-accurate view of the opponent's card**, and the game's best line is now one
sentence long: *play the heaviest card that beats the tell.* That wins **76.7%** of bouts, 25 points above the
engine's own chooser and 41 points above random. A mechanic whose optimal play is a single lookup table has
no depth, however well the parts are built. The engine, the seeds, the tests and the data are in better shape
than round 1; the *game* is not.

I also found **five shipped effects that are inverted, misscoped or dead**, one of which (the referee point)
currently rewards the fouling boxer. Those are cheap, high-value fixes and they come before any new card.

## Method

- Everything below runs through `rules.js` (real `playExchange`, `chooseAiCard`, `pickCorner`, `endRound`,
  `checkStoppage`, `scoreRound`). No combat resolver was reimplemented; only *policies* are mine.
- **Symmetrized setup** unless stated: four `pickCampCard(game, aiCampPick(game))` for the player, then
  `applyCampTo(fight.opponent, campModsFor(foe, seed))` so both corners are prepared. This is deliberately
  harsher than the shipped UI, which never trains the opponent (see D7).
- Opponent is always the shipped engine AI. Same seeds across policies; different actions branch the combat
  RNG, so policies are comparable but not luck-identical (paired tests are called out where used).
- "Smart play" = policies a human can actually run from what the UI shows: the tell chip's *word*, the film
  card, style, own hand, wind, range. **I checked what `ui.js` renders**: the tell is a category label
  ("loading a straight", "looking to move out"), never the card id, so my tell policies use the label only.
- Win% excludes draws; draws are reported. Wilson 95% intervals at n=3,000 are about ±1.8 pp.
- Total played: policy table (7 × 400), seat bias (4 × 600 + 8,000 swaps), camp ablations (12 × 600 + 7 ×
  2,500), react/predict pairs (800 × 2), tell-accuracy curve (12 × 1,200), information curve (5 × 1,500),
  plus probes for judging, referee, corners, habits, range, wind and every described card effect.

## 1. Is there a dominant strategy? Yes, and it is one sentence

3,000 bouts per policy, engine opponent, both camps prepared:

| Player policy (all legal, public information only) | W–L–D | Win% [95% CI] | Stoppage% |
|---|---:|---:|---:|
| random hand card | 1,016–1,847–237 | **35.5** [33.7, 37.3] | 10.7 |
| largest printed damage | 1,263–1,596–141 | **44.2** [42.3, 46.0] | 19.8 |
| the shipped engine chooser | 1,477–1,386–137 | **51.6** [49.8, 53.5] | 13.5 |
| **"beat the tell chip", one rule** | 2,196–666–138 | **76.7** [75.1, 78.3] | 11.7 |
| beat the tell, then always Predict | 2,207–656–137 | **77.1** [75.5, 78.6] | 10.2 |

The winning rule, exactly: *take the tell chip's card; among your hand, play the card that beats it (`W`/`w`
in the table) with the largest printed damage; if none, play the largest damage.* No cost check, no range
check, no film, no read of the opponent's habits, no Predict. It beats the engine **25.1 pp** and random
**41.2 pp**. Round 1's complaint was that smart play barely beat random (+12 pp); round 2's answer is that
*one piece of information* beats everything, which is a worse design outcome.

The tell's word is enough. Using the exact hidden card instead of the label would only take the same rule to
**~75.5%** (n=800: 563–183); following the *film* card instead scores **50.2%** — i.e. the film is worth
nothing next to the tell chip. Nobody needs to read habits, camp for deck shape, or think about wind.

### The information curve (same seats, same seeds, 1,500 bouts each)

| What the player knows | Win% |
|---|---:|
| nothing (random card) | 36.5 |
| printed damage only | 44.3 |
| the shipped engine chooser (style + expected swing + film) | 53.0 |
| **the tell's word** (this is what the game gives free, every exchange) | **74.6** |
| the exact card the opponent will play (impossible without the leak) | 85.4 |

**Break-even accuracy of the tell is ~20%.** At 0% accuracy the same rule still scores **39.2%** (better than
random, because "play your biggest card" is a decent default); at 15% it is 48.0%, at 20% 50.9%, at 30%
52.7%, at 55% 67.0%, at 70% 75.0%, at 85% 78.5%, at 100% 88.2%. The shipped chip is **55/70/85%**, so it is
*three to four times* over the strength at which it becomes dominant. Even with zero habits and zero camp
(55%) it wins **71.4%**.

The rock-paper-scissors core is fine but thin. Counted from the stored table, the 144 directed cells are
**1 `W`, 1 `X`, 39 `w`, 37 `t`, 39 `l`, 27 `n`**; across the 66 unordered pairs that is 10 wins, 16 trades,
29 losses, 10 nothings and **1 clean counter**. The only `W`/`X` in the whole table is Step back vs Cut off
and its mirror, so "clean win" and "countered" — the two words the Predict mode is built on and the only
codes that pay 1.5× damage or nothing at all — almost never happen organically.

## 2. How much does smart play beat random? (and what "smart" is worth)

- Random → the shipped chooser: **+16.1 pp** (35.5 → 51.6). That is the round-2 improvement and it is real.
- Choosing the largest printed damage is **+8.7 pp** over random: a third of the "skill" is free.
- The shipped chooser is **not** worse than a hand-built style-matrix answer. Head to head on the same
  seeds (2,000 bouts) the chooser scores **54.2%** and the matrix answer **49.8%**; an earlier 4-policy run
  that ranked them the other way (48.4 vs 51.1) used different seed tags and a different affordability
  factor, and the difference between those two configurations is inside the noise of "roughly the same".
  The honest reading: the shipped chooser is a competent ~52% bot, and *both* bots are 20+ points below a
  player who simply reads the tell.
- Adding a **Predict** decision that is available on public information makes the best line *worse* unless it
  is the free tell (see §3 and §8, D1).

### "Always the same card", all twelve (1,500 bouts each, play it whenever held, else `hand[0]`)

| Card | Win% [95% CI] | Held% of exchanges | Card | Win% [95% CI] | Held% of exchanges |
|---|---:|---:|---|---:|---:|
| Cross | **40.0** [37.4, 42.6] | 10.4 | Roll | 34.8 [32.3, 37.3] | 11.6 |
| Body hook | 38.2 [35.7, 40.8] | 12.3 | Step back | 33.3 [30.9, 35.9] | 8.5 |
| Uppercut | 37.6 [35.1, 40.2] | 11.5 | Block | 33.5 [31.0, 36.0] | 6.8 |
| Pivot out | 37.5 [35.0, 40.1] | 8.0 | Clinch | 31.9 [29.6, 34.4] | 12.8 |
| Lead hook | 36.7 [34.2, 39.3] | 5.8 | Cut off the ring | **31.2** [28.8, 33.7] | 11.8 |
| Jab | 36.6 [34.1, 39.2] | 19.3 | Slip | 34.8 [32.3, 37.4] | 12.5 |

Random hand card on the same seeds: **35.0%**. So the spread across every single-card build is only
**8.7 pp** (40.0 down to 31.2), and **six of the twelve** one-card policies are *worse than random*
(Clinch, Cut off, Step back, Block, Slip, Roll) — every one of them a card that deals zero damage. "Spam the
same card" is not an exploit, which is good; but it also means deck *composition* barely matters: any deck that
plays its cards at random is within 9 points of the best one-card build and 41 points below a tell-follower.
The shipped `balance.mjs` gate ("no single-card priority beats 45%") passes with 5 points of headroom on a
surface that is nowhere near the real problem.

The seat itself is fair: the same engine chooser in the player seat wins **48.1%** of 8,000 bouts played in
both orientations on the same seeds, so nothing below is a seat artifact.

## 3. Do tells, film, Predict, camp and corner change decisions — or are they inert?

One line per described effect, measured. `[/]` = effect exists and the number moved; `[×]` = inert, inverted
or misscoped; `[~]` = fires but is dominated.

| Described effect | Verdict | Evidence from my runs |
|---|---|---|
| Tell chip reliability 55/70/85% | `[×]` too strong | Measured **54.0 / 70.4 / 84.9%** — the calibration is exact. Following it wins 71.4 / 78.1 / 80.1%. Break-even is ~20%. |
| Film's "chance it is in the five-card hand" | `[×]` never updates | 0.604 at the bell, **0.604 after six exchanges** with 6 of the opponent's card already in its discard. `habitChanceInHand` reads `side.deck`, which play never shrinks. The number is a fixed prior, so the film cannot sharpen as a bout goes on. |
| Correct film read → 70% habit | `[/]` | Measured fire rate when the trigger was true and the signature held: **68–73%** across all 10 habits. `Jab to open` 70%, `Cut the ring` 70%, `Hold when ahead` 73%, `Roll the hooks` 73%. |
| Opponent counter-weights a card repeated twice | `[~]` | Fires (weight ×2 in `rules-ai.js`), worth **–2.8 pp** to a tell-follower when removed. Irrelevant next to the tell. |
| Film of 1–2 habits → Predict becomes useful | `[×]` | Forecast accuracy **27.7–29.7%** in real bouts; Predict is only one outcome step better than 50/50 at 50%. All-React 58.4% vs all-Predict **26.5%** over 800 paired seeds. The best free-ish use ("Predict only when an active film read exists") still loses 74.6 → **72.2%** and raises stoppages 13.2 → 16.5%. |
| Correct Predict = clean win | `[×]` with a defence card | Correct read + **Block** → own code `W`, **0 damage**, no position, no wind. The promised "clean win" pays nothing. With a punch it works (Cross vs forecast Jab: own code `W`). |
| React: Speed 65+ gives accuracy | `[/]` small | Removing it (Speed forced to 50) costs a tell-follower **5.7 pp** (80.3 → 74.6%). Fire rate 8–15% of accuracy. |
| Jab's setup after "a clean exchange win" | `[×]` too generous | A Jab that only **trades** (`t`, e.g. vs Lead hook at mid) still sets `combo=true`; the code accepts `W/w/t`. |
| Jab setup value | `[~]` | +15% damage, +5 accuracy. Banning Jab from the tell rule costs **6.6 pp** (77.5 → 70.9%) — Jab is the deck's only 3–4× card (Jab is 38.5% of all plays in `balance.mjs`). |
| Uppercut accuracy at out | `[/]` | Hard-forced to 0.50 (printed 0.58). |
| Defence deals no damage | `[/]` | Slip/Block vs Cross: deal 0.00, but **count as "landed"** for the judges (see D3). |
| Slip/Roll opening +30% dmg | `[/]` | Same Cross, same seed: **22.45** with an opening vs **17.27** without (= +30%). |
| Block refunds one wind when it wins | `[~]` | Works, but a won Block still costs net **–2** wind (paid 3, refunded 1) → 50 → 48. A lost Block is 50 → 47. |
| Step back costs the opponent one wind | `[~]` | Works: 97 → 90 on a win. But the card costs **3**, so the winner of that exchange is still down net 2. |
| Range (out/mid/inside) | `[×]` nearly inert | Share of exchanges: **mid 64.5%, inside 25.0%, out 10.5%**. Forcing every exchange to `inside` changes a tell-follower by **–0.8 pp** (80.3 → 79.5%); forcing `mid` is –1.8 pp. Nobody plays a range game. |
| Wind as a resource | `[×]` never binds | Across 14,175 exchanges, **0** had a card the player could not afford; the cheapest card is 3, the dearest 7, and the lowest wind seen at a decision was **13**, median 74. Every corner also hands both boxers **+14 + 12% of stamina** (~23) plus 6 body back. |
| Camp: 4 weeks, 1 of 3 | `[~]` real but small | Forcing one drill every time it is offered, 2,500 bouts each: Uppercut pads **+3.2 pp**, Double-jab +1.3, Right-hand +1.2, Roadwork +0.7, Ladder +0.8 — against Ring craft **–7.2** and Head movement **–6.6**. Deck drilling is weak; two drills are traps. |
| Camp: "no deck-replacement/removal budget" | `[×]` | Confirmed: `pickCampCard` only appends. Decks grow 16→21 for the roster; the same drill can be offered in two different weeks (500/500 seeds), so repeating one drill is a free choice. |
| Corner: each card costs something | `[/]` mostly | Ice the eye −10 head/−5 wind; Breathe +16 wind/−35% first exchange (**65%** damage, A/B 8.11 vs 12.48); Gloves high (block 1 cheaper, punches ×0.85); Change the plan +2 cards/−6 wind; Study +1 habit/−3 wind. All fire. |
| Corner: Sit on the stool | `[×]` wrong target | Read the code + A/B: a player who picks the stool gets **`foe_first +0.20`** — the opponent hits 20% harder in the first exchange — while the opponent picking it gets `firstExchange +0.20`, i.e. hits 20% *harder* itself. The card's cost never reaches the player who chose it, and the opponent's own stool is a **buff**, not a cost. |
| Corner offers: are they choices? | `[~]` | `aiCornerPick`'s own order shows it: heal if hurt → breathe if tired → study → **always Gloves high** → Change the plan. Over 791 corner picks it took Gloves high **295 (37%)**, Study 202, Change the plan 153, Ice the eye 91, Breathe 33, **Stool 17 (2.1%)** — the stool is nearly dead in the bot's own preference order, and it is the one card that costs the picker. |
| Referee: 2 consecutive clinches warn, 3rd costs a point | `[×]` **inverted** | The deduction is subtracted from the **wrong card**. Isolated test: a round Ada clearly won records **[[10,8]…]** normally, and **[[10,7]…]** after "Ada loses a point" — the punished boxer's own card does not change. A round Ada clearly lost goes **[[9,10]…] → [[8,9]…]**: the fouler gains a point. Holding is therefore **safe or profitable**, and the real holding loop only fires ~0.06 times a bout, so it is invisible in tests. |
| Breathe's "first exchange is light" | `[~]` misscoped | `firstExchange` is `fight.exchange === 0`, which is true for exchange 1 of **every** round, and mods are reset at each corner, so the debuff re-applies in round 3 and never applies after a mid-round reset. |
| Gloves high: Block 1 cheaper next round | `[/]` | Confirmed in `cardCost` (`block_discount`). |
| Study is removed when both habits are known | `[/]` | Confirmed; replacement keeps 3 distinct offers. |
| Opening-exchange knockdown protection | `[/]` | Power 99 vs chin 1 on the bell: **8 knockdowns in 300 bouts (2.7%)**, all in later exchanges. |
| Body damage drains wind | `[/]` saturated | `–0.45 × body damage` per exchange, but median wind never fell below 75/95, so the drain never reaches a decision. |

## 4. Missing cards and options

1. **A way to not play a card.** There is no Feint, no Catch breath, no reset. Every exchange forces one of
   five cards, and the safest card is whichever beats the chip. The round-1 critic asked for Feint/Catch
   breath; round 2's "not in this round" still lists them.
2. **A defensive scoring category.** Defence cards cannot hurt, but a 1-head Pivot "lands" exactly as a Cross
   does. There is no "ring generalship", no "blocked" stat, no way to win a round without damage.
3. **A real wind decision.** No card costs enough and no card restores enough for wind to matter; there is no
   "spend now or coast" choice, so one of the five printed resources is decoration.
4. **A range contest.** Range exists, works, and is worth ~1 pp. There is no card that *contests* range, no
   cost to being out of position, and no reward for pinning an out-boxer on the ropes.
5. **Combinations.** Beyond Jab's setup there is no pair rule (1-2, hook-body, slip-counter). 66 pair cells,
   one `W` and one `X`: nothing to discover.
6. **Deck construction.** No removal, no swap, no cap, no "this drill changes your identity". Camp is four
   additive picks from a flat 12-card pool.
7. **A risk/cost dial on the tell.** The chip is free, always on, and better than everything else. There is no
   "buy a sharper read and pay for it" decision.
8. **An opponent who plays your game.** The shipped UI never gives the opponent its camp
   (`startFight` builds it from the bare boxer; only `simulateAiBout`/balance use `applyCampTo`). Measured
   cost in the UI as it stands: **51.2% vs 51.5%** win rate — the fight is *not* actually a trained-vs-
   untrained mismatch, but the asymmetry is undocumented and unauthored.
9. **Five judges / no-draw scoring** (round-1 Part D, still open), and see D6 for why it is now urgent.

## 5. Useless, dominated and dead cards

**No card is dominated outright** — my 12×12 census has no row ≥ every other row — but two are dead on
arrival and one pair is a near-tie:

- **Cross vs Lead hook.** Same cost (6), same ranges (mid/inside), printed 15 vs 14, accuracy .62 vs .64.
  Census: Lead hook is equal vs 7 of 12 opponent cards, **better vs 4** (Body hook `l→t`, Slip `l→w`, Pivot
  `l→t`, Cut off `l→t`) and worse vs only **1** (Roll). Holding a hook is therefore never worse than holding
  a Cross except against Roll. Camp agrees: forcing Right-hand work (adds 1 Cross) every week measures
  **+1.2 pp**, while Uppercut on the pads measures **+3.2 pp**. Cross is still played 7,102 times (20.0% of
  plays) in the shipped balance run because it sits in **seven of the eight decks** and habits pad it —
  volume, not value.
- **Pivot out:** never `l` or `X` against any card (row `wwtwwnnnwnnw`) — 6 wins, 1 trade, 5 nothing. It is
  the safest card in the game and it costs only 5.
- **Jab:** the hub of the best policy (Jab is 38.5% of all plays in `balance.mjs`, 25.2% win-when-played).
  The habit padding, not camp, decides who owns it: Ada 4, Ines 4, Lena 4, Piotr 4, Mara 3, Kwame 3,
  **Tomas 1, Rio 1** — the two counter-punchers get a 1-Jab deck with 19% of it locked in Slips and Roll
  padding (Tomas: 4 Slip, 3 Roll, 3 Clinch in 18 cards), while the volume boxer gets 4 Jabs and 3 Crosses in
  21. A boxer's fight identity is set by a `while (count < 3) push` loop over its habits, not by its stats.
- **The seven `counter` blocks are unreachable data.** Slip 3 head, Block 2, Roll 3, Clinch 1+3, Step back 2,
  Pivot 1, Cut off 1+3 are printed on the cards and **never applied** — `strike()` sets `base` to
  `{head:0, body:0}` for every non-punch, so all seven cards always deal 0. Same for `shape` (0 references in
  the resolver; all 144 cells are shape-blind) and `art`. Three fields of twelve are decoration.
- **By exchange-win when played** the defence/footwork family looks strong (Pivot 64.6%, Step back 45.8%,
  Clinch 35.7%) while damage cards look weak (Cross 21.4%, Lead hook 14.5%). Treat that column as noise, not
  as card strength: it counts a `W/w` code as a win even when the card dealt 0 damage, and the code is a
  property of the pair, not of the card. My own all-twelve run (§2) is the honest signal: every single-card
  build lands between **31.2% and 40.0%** against a **35.0%** random baseline on the same seeds, so the best
  one-card build is worth **+5.0 pp**; the shipped harness's own priority table, on its own seeds, puts the
  same spread at 28.8–38.4% against 37.1%, i.e. +1.3 pp. Either way, **no single-card build is an exploit** —
  which is the good news in this file.

## 6. Do defence cards read sensibly?

Partly. The matrix tells a clear story (Slip beats straights and loses to hooks; Block beats straights; Roll
beats hooks; Clinch beats hooks/uppercut; Cut off beats evasion, loses to Jab), and the numbers behind it fire:
a Slip opening is worth exactly +30% on the next punch, Block refunds 1, Step back drains 1.

But the *language* is wrong on three counts:

1. **"Defence and movement do not deal damage" is enforced by deleting the numbers, not by the rule.** All
   seven cards carry a `counter` line that the player can see in the data and that never runs, so a boxer who
   reads the card list will believe a Slip counters for 3 and it never does.
2. **A defence card counts as a landed punch.** 39.7% of all "landed" events in 1,500 AI bouts (15,606 of
   39,291) are cards that dealt exactly 0 damage. The judges weight "landed" 0.35–0.75 per point against
   damage 1.0–1.75, so zero-damage contact is a real scoring channel — a 1-head Pivot is worth the same
   "landed" credit as a 15-damage Cross. That is why damage-free footwork shows a 64.6% exchange-win rate.
3. **Winning with defence is still a net loss.** Win a Block: −2 wind. Win a Step back: −2 wind. Win a Clinch
   against a Jab: *lose*, and 97 → 90 of your own wind. Defensive cards convert a turn into position and
   nothing else, and position is worth ~1 pp. So the correct read on this family today is "never build around
   it".

## 7. Bout length, swing and house rules

- **Length:** median **18** card picks (min 6, max 18), plus 4 camp picks and 2 corner picks = **24 decisions
  per bout**. At AI speed that is a few seconds a bout; for a human it is 3–4 minutes with no decision that
  takes more than a glance. 87% of bouts go to the cards; 13% stop, essentially all in round 3 (326 of 391
  stoppages).
- **Swing:** final damage margin mean +2.3, SD **22.6**, |margin| > 20 in **37.0%** of bouts. The boxer who
  does more damage loses **14.4%** of bouts (n=2,000). The round-1 leader (cards or damage) keeps the decision
  **69.8%** of the time. A deterministic damage verdict disagrees with the three judges in **22.7%** of
  decisions. That is a lot of luck, and it is *not* visible luck: the player cannot tell a judge's taste from
  noise. Round 1 asked to lower judge noise (.10/.06/.14 → .05/.03/.07); round 2 did not touch it.
- **Draws:** **6.97%** of 4,000 AI bouts. Card shapes: 235 all-three-level ("---"), 44 mixed ("-OP"). This
  contradicts two of the repo's own house rules used by the shipping game —
  `scripts/rules/CardOdds.gd` ("a 3-round card has no draw") and `scripts/world/WorldSim.gd` ("a world table
  books no draws") — and round-1's Part D. A national-level amateur card in this repo is never a draw.
- **House rule: same-sex only.** Holds. `createGame` filters by pronoun, rejects an explicit cross-sex
  pairing, and 160 seeded opponent draws (8 boxers × 20 seeds) all came back same-sex. Green test too.
- **House rule: amateur bouts have a winner.** **Fails**, 7% of the time (above). Nothing in the code forces
  a tiebreak on a level card.

## 8. Five defects to fix before new content (ranked by cost ÷ effort)

- **D1. Follow the tell chip = 76.7%.** Detail and numbers in §1. The chip also never gets *sharper* as the
  deck thins (D2), so there is no skill curve to climb: the same free information is equally strong in
  round 3 as in exchange 1.
- **D2. The film's hand-odds are frozen.** `habitChanceInHand` reads `side.deck`; measured 0.604 at the bell
  and 0.604 six exchanges later. The one number the game prints as your estimate cannot improve, so the film's
  promise ("about N% chance it is in the five-card hand") is a constant and the "Study" corner card (worth
  +3.7 pp as a camp drill) buys a read that never grows.
- **D3. Zero-damage cards score as landed punches.** 39.7% of landed events deal 0. Any "defence is its own
  currency" design is undermined by paying defence in the same currency as punches.
- **D4. The referee deduction is inverted.** A fouling boxer gains a point on an otherwise lost round (9-10 →
  8-9) and keeps his opponent's card untouched on a won round. Holding is free money; only 0.06 holds a bout
  happen, so it is currently invisible.
- **D5. Sit on the stool's cost lands on the wrong boxer**, and the opponent's stool is a *buff* to the
  opponent. Combined with D4, the two "cost you something" corner/house effects both point the wrong way.

Two more, lower severity: **D6** draws (7%) contradict the repo's no-draw house rule; **D7** the shipped UI
never trains the opponent (camp and corner are player-only) while `balance.mjs` measures a symmetric game, so
the balance the tests defend is not the balance a player meets; **D8** three data fields (`counter`, `shape`,
`art`) are dead, and `counter` is printed on the card faces where the player can read it.

## THE ORDERED LIST — TO REACH 10/10

Most important first. Each item is a proposal with numbers to hit, not a claim of proven balance.

1. **Delete the free card-level tell and sell information as a scarce resource.** The tell chip must name a
   *category* with a cost attached, not a card for free. Proposal: chip = "he is loading a looping shot"
   (correct 60%, wrong 40%, and the 40% is never the exact opposite), one free look per round; further looks
   cost **4 wind** and **1 accuracy step is added per exchange you spend only React** (so reads reward
   patience). Target: a tell-follower scores **58–62%**, not 76.7%; break-even accuracy near **40%**, not 20%.
   Acceptance: one-rule bot at 60% tell accuracy lands inside 58–62% over 10,000 bouts, and no policy beats
   the engine by more than 20 points.
2. **Make each letter of the resolution table mean something: rebalance the table to ~18 `W`/`X` pairs.**
   Today 66 pairs give 1 `W`, 1 `X`, 10 `w`, 16 `t`, 29 `l`, 10 `n` — so Predict has no payoff to forecast
   and "countered" is trivia. Ship explicit pair rules: **Cross beats Jab at mid/inside**, **Slip counters
   Cross and Lead hook**, **Uppercut counters Slip and Roll**, **Cut off counters Step back and Pivot out**,
   **Roll counters Body hook**, **Clinch smothers Uppercut**, each as a hard `W`/`X` cell with a named reason
   shown in the log. Target: at least **8** `W`/`X` pairs, and a correct Predict on a *named* pair pays a
   clean win with damage attached (see item 3).
3. **Pay the Predict payoff for defence cards, and give the correct read a body.** A correct Predict with
   Block currently returns a `W` for **0 damage, no position, no wind**. Rule: a correct read converts your
   card to `W` **and** applies its `counter`/`opening` effect (Block refunds 2 wind, Slip/Roll set opening,
   Step back moves out, Clinch drains 4) — otherwise nobody will ever Predict with defence and the mechanic
   only ever serves punches. Target: "Predict when a read is active" ≥ all-React on the same seeds.
4. **Fix the referee and the stool (D4, D5) and make holding a decision.** Subtract the deduction from the
   offender's own card (`score[offender] -= deductions`), and make two consecutive Clinches cost a **warning
   plus 2 wind to the holder**, three cost a point *and* the opponent's choice of range. Fix the stool to
   `self +0.20 first exchange, opponent draws one extra card` so the picker pays. Acceptance test: a round the
   offender clearly won with one deduction reads 9-9 for him and 10-9 for the other; the 600-bout hold loop no
   longer runs at 51.9% vs a 52.7% baseline.
5. **Give wind a job or delete it.** Either (a) raise costs ~40% (Jab 3→4, Cross 6→8, Uppercut 7→10) and cut
   the between-rounds recovery to **+8 wind**, so a six-exchange round actually spends the tank, or (b) drop
   wind and use a **cards-per-round budget (6)** that the corner can buy back. Target: **3–6%** of exchanges
   offer a card the boxer cannot afford (today 0.00% of 14,175), and the corner's "Breathe" is a real tempo
   choice rather than a 16-point top-up on a full tank.
6. **Make the film a live estimate and the deck finite.** `habitChanceInHand` must use the *unseen* pool
   (`deck + draw`), so the printed odds climb as the opponent's discard grows (0.60 → 0.85 by exchange 5 of
   round 2). Show the delta. This is the one change that turns the film from decoration into a skill: you
   learn to *hold* a read until the odds justify it. Acceptance: the printed chance at the bell differs from
   the chance at exchange 6 by ≥ 0.15 in 80% of bouts.
7. **Make range cost something, and give `out` a purpose.** Share is mid 64.5 / inside 25.0 / out 10.5 and
   the whole system is worth ~1 pp. Proposal: every card gets a **range it is thrown from and a range it
   leaves you in**; being out of your card's range costs **1 extra wind and −6 accuracy** (not a 0.62 damage
   multiplier nobody can see); Cut off and Pivot out become a genuine contested pair worth a `W`/`X` (item 2);
   add **Ropes** as the fourth range for the corner. Target: forcing `inside` moves a policy by ≥ 6 pp.
8. **Make camp construction, not accumulation.** No removal, no cap, decks 16–21, and one drill repeatable
   across weeks. Ship: **4 weeks, 3 offers, and each pick is "add 1, and remove 1"**; cap the fight deck at
   **16**; make the drill's *shape* matter (Double-jab converts up to 2 cards into Jabs; Uppercut on the pads
   converts 1). Kill or re-price the two trap drills measured at **–7.2 pp (Ring craft)** and **–6.6 pp (Head
   movement)**; they currently punish a new player who picks the flavour text. Target: informed camp beats
   random camp by **≥ 5 pp** (it is currently indistinguishable).
9. **Make the judges legible and stop the draws (D3, D6).** Zero-damage cards must not count as "landed" for
   punches (D3): split `landed` into `punches` and `defence`, weight punches on damage and defence on
   "exchanges won without being hit". Show each judge's taste as a one-line card at the bell (today the player
   cannot tell .55/.35/.75 apart). No draws on a 3-round card: a level card goes to the boxer who won more
   exchanges (the repo's `WorldSim` already does this). Target: draws **0%**, deterministic-vs-judges
   disagreement **≤ 12%** (today 22.7%), and the damage leader's win share ≥ 85% (today 85.6% — keep it).
10. **Kill the dead data and let the card faces tell the truth (D8).** Either implement the seven `counter`
    blocks (Slip 3, Block 2, Roll 3, Clinch 1+3, Step back 2, Pivot 1, Cut off 1+3) as *defensive points that
    only score when you win the exchange and take no damage*, or delete them from the data and the card face.
    `shape` should drive the matrix: build the 144 cells from `{straight, looping, uppercut, evade, guard,
    escape, close}` × `{...}` + the pair exceptions, so "hook beats straight" is a rule and not 66 hand-typed
    letters. Then art, shape and tags all mean something.
11. **Train the opponent, and say so.** Give the opponent its camp in `startFight` (or in `createGame` via
    `campModsFor`) and print the opponent's camp in the scouting file. Otherwise the scouting file is lying by
    omission and the tests defend a game nobody plays.
12. **Then, and only then, measure with humans.** The bar is 8+ DEPTH and 8+ PLAY and no test can grant it.
    Twelve blind first-timers, ask them to call five pairs before the reveal (Cross–Jab at mid, Slip–Uppercut,
    Cut off–Pivot, Block–Cross, Clinch–Uppercut), require **80%** comprehension and a majority wanting a
    rematch. Re-measure the one-rule bot afterwards: if a single lookup still beats the engine by 20+ points,
    the mechanic is not done whatever the test suite says.

**The single thing most wrong right now** is item 1: the tell chip hands the answer to the table away for
free, every exchange, at three to four times the accuracy at which it becomes dominant. Fix that and the
matrix, the film, the camp, the range and the corner all become decisions again. Fix everything else first
and the game stays one lookup with better decoration.

## Verification (run unchanged, output quoted)

```
$ node proto/cardgame/rules.test.mjs
...
32 passed, 0 failed
RESULT: PASS - all 32 checks green

$ node proto/cardgame/rules.round2.test.mjs
...
RESULT: PASS - round 2 (19 checks green)
```

Both are green, and the green suite **still passes with D1–D5 present**. It checks that a correct read yields
code `W`, that two clinches warn and the third deducts `round.deductions === 1`, that Slip deals 0 damage, and
that Gloves high multiplies punches by 0.85. It does **not** check *whose* card loses the point (a test that
would have caught D4), that a defence-only correct read pays anything, that the stool's cost lands on the
picker (D5), that the film's printed odds move as the deck thins (D2), that the tell is calibrated to a
sensible strength (D1), or that any camp drill is not a trap. Green here means "the code does what the code
does", not "the game is good".

`node proto/cardgame/balance.mjs` (2,000 bouts, `RESULT: PASS`) cannot see D1, because its two reference
policies are the engine chooser and random hands — the engine chooser never looks at the tell chip. Reproduced
on the exact harness seeds (`hashSeed('reading-v-random', i)`, 5,000 bouts, half-credit draws):

| Policy (the harness's own seeds and pairing) | Win share |
|---|---:|
| reading policy (shipped chooser) | **53.6%** |
| random hand card | **37.1%** |
| **tell-follower, same seeds** | **75.4%** |

The gate "reading edge ≥ 15 pp" is met at +16.5 pp and hides a 22-point gap between the harness's best
policy and the rule a first-time player works out in one bout. **The harness needs a tell-follower arm and a
largest-damage arm as reference policies, or it will keep certifying a balance that is one lookup away from
broken.**

## Reproduction

```sh
# harnesses: plain Node ESM, no deps, importing the shipped module
import R from './proto/cardgame/rules.js';
# setup for every policy bout
const game = R.createGame({ seed, playerBoxerId: me, opponentBoxerId: foe });
while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
const fight = R.startFight(game);
R.applyCampTo(fight.opponent, R.campModsFor(foe, seed));   // symmetric camp
while (!R.isOver(fight)) {
  if (fight.phase === 'corner') { R.pickCorner(game, R.aiCornerPick(game)); continue; }
  R.playExchange(game, policy(fight));
}
```

- Seeds: `R.hashSeed(<tag>, <policy>, <bout index>)`; opponent pair from
  `BOXERS.filter(b => b.pronoun === me.pronoun && b.id !== me.id)` indexed by
  `R.hashSeed('<tag>-pair', i)`, so every policy meets the same roster schedule.
- The winning policy (D1): `const t = fight.tell.card; const c = hand.filter(id => ['W','w'].includes(
  R.RESOLUTION[id][t])).sort((x,y) => dmg(y)-dmg(x)); play c[0] ?? hand.reduce(biggest dmg)`.
- Hidden-hand check: no policy reads `fight.opponent.hand`; `R.predictedCard` and
  `R.scoutingPrediction` are used only as the UI exposes them (a word and a card name).
- Ranges: win% excludes draws; Wilson 95%; n and W–L–D are printed with every row above so any figure can be
  re-derived.

*Scores are 0–10 and deliberately unkind: DEPTH 4, PLAY 5, GENERAL 4. The prototype's engineering is good
enough to deserve better content; the content is one lookup away from being a game.*
