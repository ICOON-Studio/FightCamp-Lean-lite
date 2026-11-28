# Octagon v6: the owner's v2.7 Director's Cut, boxing (S573)

Source: ops/research/octagon/v27/ (his PDF, read whole; text in v27_text.txt). Built SEPARATELY from v5 (cards_v6.mjs, `v6=1`).
v2.7 replaces v2.6 for this line (he sent it in S573). Boxing only: BOX-01..12, FIQ-01..04, SYS-01 with his numbers.

## His v2.7 rules built (engine switches, all OFF on v5)
stance (Signature Stance Guard always there), surge (Desperation Surge: a Defend at 0 stamina costs 0, 2 to your own body),
neutral1 (Counter v Counter / Counter v Defend / Defend v Defend = both +1 stamina, Lead neutral), capOne (only the single
biggest speed bonus counts), pocket (Pressure: -1 damage taken at Close; +1 chip = chipPress), recUnhit (Deep Breath +3 only
if unhit), tellColor (his S573 idea: a won Shoulder Twitch Feint = next exchange he seals first and you see RED/BLUE or
YELLOW/GREEN). Read Tendencies = [Tell: Name] (his hand). Not built: Counter +1 speed v the Lead holder (in this engine
counter speed only decides Counter v Counter, which v2.7 makes neutral), Overhand's "rocked if unblocked" (5 damage rocks
anyway), Rear Uppercut v takedowns, relics, grappling (boxing only).

## His question: "check if 2.7 is missing anything from the version that rate 7/8 ... and see if you can fix it"
v5.4 (cup fun 7.5-7.75) has what the cup added; v2.7 drops it. Bots (pool_sim, every pool fighter v every other, both corners):
| v2.7 + | n | fighters (win %) | finishes |
|---|---|---|---|
| nothing (as written, `pure=1`) | 20 | 32-74 (Truck 74, Iron 69; out-fighters 32-35) | 51% |
| Initiative +1 (v5's, not his +2) | 20 | 31-68 | 47% |
| + clean counter +1 stamina, no rock on a round's first exchange | 20 | 35-67 | 47% |
| + always-there Range Jab, Hold Ground (+ parry), Elbows Down | 20 | 37-67 | 48% |
| + the rocked / pinned man's outs (Cover Up, Clinch & Hold, wall clinch) | 20 | 35-66 | 45% |
| + all of the above | 20 | 34-62 | 42% |
| + all, Pocket Armor off / +1 chip off / both | 20 | 36-65 / 40-66 / 40-67 | 43-45% |
| **+ all + HALF THE POWER BONUS = v6.1** | 20 | **41-58** | 38% |
| v6.1 | 40 | 37-59 (Long Night 37: IQ 3, the weakest build) | 40% |

The missing piece: v2.7's punches are cheaper (hooks / uppercut cost 2), so a big puncher cashed his POWER bonus nearly
every exchange. v6.1 = v2.7 + v5's cup rules + Initiative +1 + half the power bonus (`useV6()`; `pure=1` = as written).
Smoke bout through versus_oct: 18 exchanges, 2 tells shown, the seal-first wait works, 7 neutral resets.
Next: cup rounds on v6.1 beside v5.4.

## Fixes found playing (S573)
- The Stance Guard was locked ("not in your hand") until cup r14 E1 - the v6.1 rows above were re-measured with it working:
  v6.1 n=40 36-60%, finishes 16%; as written (`pure=1`) n=20 33-70%.
- Counter v Defend paid the power-counter whiff (his matrix: neutral reset) - fixed. NOW speed of a step-in card now uses
  the range it lands in. No tell off a Clinch & Hold. The tell's log line names who sees whose colour.

## Cup round 14 on v6.1 (fun 7/6/7/7 = 6.75, depth 7/7/6/7 = 6.75; v5.3 r13: 7.5 / 7.0)
Kalli beat Claude 29-28, Maria beat John 29-28. Both winners played the Signature Stance Guard 9 times in 18 exchanges;
all four seats named it. The tell worked when it fired (Claude: RED/BLUE -> the faster jab landed 4; YELLOW/GREEN twice
-> it was the guard both times, still a guess between two), but both men on the receiving end read the log line as theirs.
Kalli and Claude: whole hands with no punch at Mid.

## v6.2 (ON): Stance Guard free once a round, then +1 a use; Range Jab at Long AND Mid
Bots n=40: 37-58% (snapshot 58, truck 57, bodyshop 54, iron 52, ghost 51, silk 49, metronome 42, longnight 37), finishes 21%.
Still asked, not built: counter-puncher paid on a reset v a guard (John), the reset giving both stamina (Maria), a way out of
Mid for the Out-Fighter (Claude).

## Cup round 15 on v6.2 (fun 8/7/7/8 = 7.5, depth 8/6/7/7 = 7.0 - level with v5.3, 0.25 under the cup's best)
Claude beat John 29-27 (two RED/BLUE tells, both cashed; John's Stance Guards 9 -> 5), Kalli-Maria 28-28.
Asks: Range Jab + Stance Guard were half of all plays (Kalli, John, Claude); the Pressure man never reached Close, his
uppercut never played (John); live round score (Kalli, as in r12-r13); Pull Counter 6 -> 4 (Kalli, as r13); rocked turn
with no good attack (Maria); say which card a counter answers (Maria).

## v6.3 (ON): a Range Jab after a Range Jab costs 1 more; a Cut the Cage that beats a Defend walks him to Close
Bots n=40: v6.2 + feelTax 37-58%; + cutClose 39-57% (bodyshop 57, truck 56, snapshot 55, iron 53, silk 51, ghost 47,
metronome 42, longnight 39), finishes 18%.

## Cup round 16 on v6.3 (fun 7/7/7/7 = 7.0, depth 7/7/6/7 = 6.75)
Claude-Maria 28-28 (Claude's Pull Counter 6 rocked her to head 4; she guarded out round 3), Kalli beat John 29-27.
Asks: Read Tendencies showed TWO cards + the Lead -> a free power counter (John, Kalli); the slow Pressure man loses every
race and never reaches Close (John r15 + r16, Claude r16) - but the fast jab should keep him off (Maria r16); seven neutral
resets in a bout = dead air (Kalli); one counter decides a round (Maria). Measured OFF (n=40): heavyTrade 38-60%, stanceTax=2
37-61%, both 37-59%; counters at half power (ctrHalfPow) changed nothing - the 6 is the card's 5 + the +1 reflex bonus.

## v6.4 (ON): Read Tendencies shows ONE card (his v2.7 card text) - bots unchanged 39-57%

## v6.5 (ON): STATUSES (owner S573: "add statuses and debugs like staggered or stunned, keg injured, cut etc")
STAGGERED (the legs: 2 under his rock line, or a rock the rules blocked -> -1 speed, no stepping in next exchange), ROCKED
(+1 to the judges for the man who rocked him: "a rocked man should give something up"), CUT (his v2.7 Eye Cut: clean
straight punches of 2+ - the 2nd opens it, each after widens it; shows a card of his hand every exchange; the doctor stops it
at 5), WINDED (body at half: Defends give 1 less back). Leg injury proper (kicks) waits for the kickboxing deck.
| status + | staggers / cuts a bout | doctor stops | finishes | fighters |
|---|---|---|---|---|
| off (v6.4) | 0 / 0 | 0 | 18% | 39-57 |
| cuts from heavy (4+) head hits, doctor 3 | 1.45 / 0.61 | 0 | 18% | 40-60 (Truck 60) |
| cuts from 3+ head hits | 1.41 / 0.86 | 3% | 22% | 38-62 |
| cuts from sharp straights 2+, doctor 3 / 4 / **5** / 7 | 1.4 / 1.4 | 39 / 15 / **4** / 0% | 52 / 32 / **24** / 20% | 39-57 / 35-59 / **35-57** / 40-61 |

## Cup round 17 on v6.5 STATUSES (fun 8/7/7/7 = 7.25, depth 8/6/7/7 = 7.0; r16: 7.0 / 6.75)
Claude (Iron) beat John 30-27: a rock + the judges' +1 won round 2 by one point, a stagger left him at Close for the
Rear Uppercut, his jabs cut Claude to 3 of 5. Kalli beat Maria 29-28; Kalli timed a counter off her cut card. Asks: the
man ahead stalls round 3 behind guards (John, Kalli, Maria); the live round score (Kalli, 4th time); a widening cut should
score (John); the Step-In Jab off a fake at Long pays too much (Maria, 3rd bout).

## v6.6 (ON): the live judges' score on the screen; a Stance Guard repeat costs 2 - bots 37-59%

## Balance rating on v6.6 (owner S573: "i want balance rating from all")
| seat | BALANCE | Pressure | Out-Fighter | Counter | too strong | one fix |
|---|---|---|---|---|---|---|
| John | 6 | 7 | 4 | 6 | a heavy punch trading through a faster jab | 2+ speed faster stops the slower punch outright |
| Kalli | 6 | 7 | 4 | 5 | free neutral resets let the leader stall | a reset costs the man ahead on the live score 1 stamina |
| Maria | 6 | 6 | 4 | 5 | the Step-In Jab catching a fake at Long (4 + range + Lead + stagger + cut) | it lands the damage OR closes the range, not all |
| Claude | 6 | 6 | 4 | 6 | the leader guarding out round 3 | Kalli's: the man ahead pays on a reset |
Too weak: Check Left Hook (John: almost nobody steps in at Mid), the Out-Fighter's safe Mid punch (Kalli), Deep Breath (Maria).
All four: BALANCE 6, Out-Fighter 4 (bots agree: Metronome 43%, Long Night 35%).

# S574 - BALANCE FIRST (owner: "focus on balance first then fun and depth also try my version too")
Bots: every pool fighter v every other, both corners, n=200 x seeds 7/11/13 (11,200 bouts a seed). All runs in
ops/research/octagon/s574/grid*.txt; seat answers in s574/balance2, balance3; cup verdicts in ops/research/octagon/cup4_s574/.

## Two lines now
- v6.9 (`v6=1`, ours): v6.6 + every fix below. `v66=1` = the old v6.6.
- LITE (`v6=1 lite=1`): HIS v2.7 Director's Cut as written + only the fewest fixes: half the POWER bonus, the Range Jab
  (Long + Mid, meets a step-in), the S574 rules below, Stance Guard +1 a use after the first, Range Jab repeat +1.
  As written (`pure=1`): Truck 70%, Iron 65%, out-fighters 34-35% (Pressure runs away).
- His Stance Guard: he never wrote a repeat rule (owner S574 "i don recall putting a rule on that") - his card: cost 0,
  always there, blocks (1 chip v heavy); the PDF card gives no stamina back, his CSV and his UI art say +1. The repeat cost
  is ours (agents played the free guard 9 of 18 in r14).

## What changed, and why (each a TUNE switch, measured OFF first)
| switch | from | bots |
|---|---|---|
| gapStop 2: 2+ speed faster stops the slower punch | John, rating #1 | out-fighters +2 |
| resetTax 2: a neutral reset - the man ahead pays 1, the man behind +1 | Kalli, rating #1 | none (bots never stall) |
| fakeJab: a step-in punch that catches a feint lands, but does not close the range | Maria, rating #1 | none |
| stickMove: an out-fighter's landed Step-In Jab steps straight back to Long | Out-Fighter 4 from all | +1-2 |
| circleMid: Circle Out at Mid too (Mid -> Long) | Claude r15 "a way out of Mid" | +2-3 |
| startLong: round 1 starts at Long too (his v2.7 names no start range) | Claude r18 | the three styles to ~50% |
| cutStop 6 (was 5) | more jabs, doctor stops 12% -> 3% | |
| featPt: a feint that beats a Defend scores 1 with the judges | Kalli r18 | none |
| pinLeak: a block at cage space 0 still takes 1 | Kalli r18 | none |
| pull4: Pull Counter 4 (his card 5) | Kalli r13/r15/r18 | none |
| stanceTax 1 (was 2) | Maria r18 | none |
| ctrPt: a clean counter scores 2 with the judges | John, rating #2 | none |
| chkLong: Check Left Hook at Long (meets a step-in) | Kalli r19 | Ghost 43 -> 46 |
| stickCost 1, resetD (only a guarding leader pays), heavyTrade (4+ trades through a straight of 3) | Kalli, John, Maria r19 | spread 43-56 -> 46-55 |
| stopNoStep: a step-in punch beaten to it does not step in | Claude r20 | none |
Measured and left OFF: slipLong (Slip at Long: counters 59-68%), Ghost's own numbers (moved the weak spot to Long Night),
feelTie (Truck 57-59), stickFree, stickCardio (no change).

## The bots now
| | Snapshot | Ghost | Silk | Metronome | Long Night | Truck | Iron | Body Shop |
|---|---|---|---|---|---|---|---|---|
| v6.6 | 59 | 48 | 47 | 39 | 37 | 59 | 54 | 57 |
| v6.9 | 55 | 44 | 54 | 47 | 47 | 50 | 48 | 54 |
| his v2.7 as written | 49 | 46 | 41 | 34 | 35 | 70 | 65 | 60 |
| LITE | 56 | 48 | 54 | 47 | 46 | 47 | 49 | 53 |

## Balance ratings (all four seats, BALANCE only)
| rating | v6.x | LITE | styles |
|---|---|---|---|
| #1 v6.6 (S573) | 6/6/6/6 = 6.0 | - | Out-Fighter 4 from all |
| #2 v6.7 | 8/8/8/7 = 7.75 | 7/7/7/6 = 6.75 | Counter 4 from all |
| #3 v6.9 | 8/8/8/8 = 8.0 | 7/7/8/7 = 7.25 | v6.9: Pressure 5, Out 5, Counter 5 from all ("just right") |

## Cup rounds 18-20 (fun / depth)
| round | bout | version | result | fun | depth |
|---|---|---|---|---|---|
| r18 | John (Metronome) v Maria (Body Shop) | v6.7 | Maria 30-29 | 7 / 8 | 6 / 7 |
| r18 | Claude (Truck) v Kalli (Long Night) | LITE | Claude 30-27 | 7 / 6 | 7 / 6 |
| r19 | John (Snapshot) v Maria (Truck) | LITE | John 30-27 | 8 / 6 | 7 / 6 |
| r19 | Claude (Metronome) v Kalli (Ghost) | v6.8 | Claude 29-27 | 7 / 6 | 7 / 6 |
| r20 | Claude (Ghost) v John (Body Shop) | v6.9 | Claude 29-28 | **8 / 8** | **8 / 8** |
| r20 | Kalli (Long Night) v Maria (Snapshot) | LITE | Kalli 29-28 | 6 / 7 | 5 / 6 |
r20 v6.9 is the first cup bout at fun 8 AND depth 8. LITE r20 went flat (14 of 18 exchanges paws or guards at Long): the
Range Jab repeat tax is now ON in LITE too (bots unchanged).
Open asks after r20: the man ahead guarding the last two exchanges (John, Maria); the cut shows a card EVERY exchange - once
a round (John); Cut the Cage loses to the cheapest paw (John); same-speed paws should both land (Kalli; measured: Truck 57-59);
the step-in jab should show itself (Maria); the counter's real damage on the card (John r19).

## Cup round 21 (S574, after the r20 handover)
| bout | version | result | fun | depth |
|---|---|---|---|---|
| Kalli (Silk) v John (Iron) | v6.9 | Kalli 30-28 | 7 / 7 | 6 / 7 |
| Claude (Body Shop) v Maria (Metronome) | LITE | Claude 28-27 | 7 / 7 | 7 / 7 |
LITE up from 6.5/5.5 to 7.0/7.0 (the Range Jab repeat tax + the Stance repeat cost: Claude paid 13 stamina for five guards).
v6.9 r20's 8/8 did NOT hold with Kalli + John (7.0/6.5). Asks: the cut showed a card EVERY exchange (Kalli, John x2) ->
now once at the start of each round (cutOnce, v6.9); a cross-hook combo did 10 (Maria, Claude) -> a combo's extra punches
land at half (comboHalf, both; v6.9 bots 46-53%, LITE 44-57%); a feint broke a Circle Out that still stepped out -> fixed
(circleFeint, both). Still open: Pressure has no way to close at Long and every round opens there (John: start a round where
the last ended, or a Step-In Guard card); Hold Ground parry used to stall twice in a row (Kalli); the Stance Guard should say
what it covers - body shots under it (Maria); counter v counter at Mid is a free reset (Claude).
