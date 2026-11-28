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
