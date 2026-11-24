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
