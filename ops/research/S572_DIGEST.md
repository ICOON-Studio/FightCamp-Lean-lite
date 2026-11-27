# S572 digest (2026-11-27/28, Opus 5.5)

## Owner's words this session
- Q-S294-347 on the board (answered before the session): "Yes, do all moves" -> LAYERS1 launched as a console worker.
- His message: "consider these : Range Commitment & Grazing ... Long-Range Tax ... Feints Beat Passive Defends ... Block
  Chip Damage & Guard Meter ... Split Counters into Low-Commitment vs High-Commitment ... Sniper ... Economy of Motion".
- Then his PDF "Octagon_Tactics_v2_Rulebook_And_Cards.pdf" and his "Octagon_Tactics_v2_52_Card_Database.csv" - his v2.0
  rulebook and card set (copied to ops/research/octagon/).

## Done
- LAYERS1 (one man per picture, phase 1, every move) launched FIRST THING (his game was closed): Opus console worker,
  terminal tab c1 of S572, cross family first (docs/LAYERS1_RESULT.md grows as it goes).
- OCTAGON cup rounds 7-10, every rule change on pool_sim n=40 (2240 bouts) first, switched only between rounds:
  | rules | fun | depth | note |
  | v4.6 r7 | 6.25 | 6.75 | Claude beat Maria 30-27; Kalli KO'd John R2 |
  | v4.8 r8 | 6.5 | 6.5 | John KO'd Claude R3; Maria beat Kalli 28-27 |
  | v4.9 r9 | 6.5 | 6.5 | Claude beat Kalli 29-28; John KO'd Maria R3 |
  | v5 r10 | 7.25 | 7.0 | the owner's v2.0 book; Maria KO'd Claude R2, Kalli beat John 29-28 |
  | v5.1 r11 | 7.75 | 7.25 | BEST: John KO'd Claude on the last exchange (19-19), Kalli-Maria 29-29 |
  | v5.2 r12 | 7.5 | 7.0 | Kalli beat Claude 28-27, Maria KO'd John R3 |
  v4.7: a kept React Defend blocks a combo card in its zone (Elbows Down v a body combo); a halved punch is not clean (no
  maximum-stamina cut); the Read log says the real +1. v4.8: Hold Ground at Long reads a step-in feint. v4.9: Hold Ground
  after a Defend costs 1; a whiffed counter costs 1. All four seats over r7-r9: waiting at Long (Hold v Hold, Range Jab
  v Hold) and free Defends were the flat part; a whiffed counter emptied a counter-puncher; the out-fighter's deck has
  no Close card.
- OCTAGON v5 = HIS v2.0 RULEBOOK + HIS v2 CARDS (proto/octagon/cards_v5.mjs, `v5=1` in pool_sim / versus_oct /
  versus_by_message): a Feint beats a passive Defend (Lead + cage push), heavy (4+) chip 1 + 1 stamina through a block,
  a stationary Defend at Long costs 1, reactive counters whiff free / power counters lose 2, Economy of Motion for the
  Counter-Puncher, Pressure step-ins +1 speed, taxes reset at the bell; his 16 boxing + Fight IQ cards with his numbers,
  20-card decks, max 2 a card. Each rule is its own TUNE switch, all OFF on v4 (v4.9 re-measured identical).
  Bots as written: 34-64%, finishes 3% (Pressure 57-64%, Counter 34-38%). Three CALLS, measured: Initiative +1 (his +2),
  health x1.0 (v4.5 had 1.25), the Brawler's extra chip off -> 41-56%.
  v5.1 (Maria): a rocked man's Cover Up is safe from feints, a clean counter gives 1 stamina back, named round scores.
  v5.2 (John + Maria + Kalli): no rock on a round's first exchange. v5.3: a free reactive whiff really gives up the Lead;
  a feint battle pushes nobody. Measured and left off: powHalf + feintBase (only Claude asked).
- His v2.6 files (three rounds of them): the FINAL synchronized pair (Master_Card_Database (1).csv + Synchronized_Release_Kit
  .pdf) agree card for card (55 cards, 12 relics, fictional bosses) - saved as the master in ops/research/octagon/v26/.
  Earlier v2.6 files had real fighters' names as bosses and a PDF with blank card pages (told him). His call: "keep the
  current version and work seperately on the new rules leave the league design after we balnce the fights".
- TYPES1 DONE (docs/TYPES1_RESULT.md): his four card types on Puncher's chance fail every trial gate - as written the safe
  card is the best card; Defend needs a cost (ideas at the end of the page).
- LAYERS1: the cross family passes (0 jumps where both runs are layered; Long still the old picture). Worker continues.
- His Chrome: "do not open tabs on my chrome window" - S572 opened none (two older desktop sessions were alive); memory rule.

## Not done / next
- Cup round 13 on v5.3; FUN 8 is the target (best: 7.75 on v5.1).
- v6 = his v2.6 rules + cards, separate from v5, bots first.
- Collect RULES569 (tab c1 of S571), KICKFIX6 (two chains), LAYERS1 (tab c1 of S572).
- Q-S294-348 (C: drive at 8 GB: his AMD usage log 2.2 GB + two Ollama installers 3.7 GB) waits for him.
