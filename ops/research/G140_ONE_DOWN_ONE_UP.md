# G140 - One down, one up: the seconds after a knockdown or a stuffed shot (S102)

Owner: grok (Expert). Collected S103 2026-09-27 from grok.com/c/8228102c-8996-4ef1-8cf9-7b4b5054591b (artifact
`G140_ONE_DOWN_ONE_UP.md`, 14.8 KB, 112 sources). This file is Claude's CONDENSED transcription - every figure and grade
kept, prose and table layout trimmed. Grades: S sourced, P proxy, J judgement.

## Prefab check (Grok)

No public dataset tags the aftermath. FightMetric/UFCStats (proprietary, scraped): KD count only. Sportradar (commercial
API): same gap. Hutchison et al. 2014, Am J Sports Med 42:1352-8 (paywalled, abstract public): KO blow -> stoppage
timing. "Inside the Finish" UFCStats rebuild (8,337 fights to 2025-09-06): KD x finish type. Bloody Elbow Analytics 2014:
same-round KO given a KD. Follow/wait and downed-man responses need our own video coding; everything below on them is J.

## 1. After a standing knockdown

| Condition | KO/TKO | Sub | Dec | Grade |
|---|---:|---:|---:|---|
| Fight had >=1 KD (2,930 / 8,337) | 63.5% | 9.5% | 26.9% | S |
| Fight had no KD | 13.9% | 24.7% | 61.4% | S |
| >=1 KD in a round -> KO that same round | 55.5% | | | S |

Hutchison, 108 UFC KOs: KO strike -> referee stop mean **3.5 s** (SD 2.8, range 0-20), 2.6 extra head strikes (S);
TKO by repeated strikes: 18.5 strikes in last 30 s, 92.3% to the head (S).

Per knockdown (P): ends fight <=10 s ~38%; <=30 s ~52%; survives this sequence ~45-50%. Median time to stop when it
stops: ~4 s clean KO, ~8-12 s GnP TKO, combined ~6 s (P).

Standing man's choice (J): FOLLOW down ~55% (heavy KD, wrestler) / HOVER and punch down ~25% / RESET, let him up ~20%
(flash KD, kickboxer; often not a choice - he is already up). Heavyweights follow more; lightweights scramble up more.

## 2. Downed man's responses (J, share of recovered KDs)

| Response | Share | Works (back up safely) |
|---|---:|---|
| Shell / cover / turtle | ~35% | low - buys 2-5 s, ref stops if no improvement |
| Stand straight up | ~25% | high if the other man has not closed |
| Wall-walk (cage) | ~15% | high if he hooks the fence before mount |
| Leg grab / single / sit-up double | ~12% | medium - becomes a scramble |
| Upkick | ~8% | low-medium, legal to a standing head |
| Butt-scoot / sit-up | ~5% | medium; mostly after slips/stuffs |

## 3. Referee

Looks for consciousness, intelligent defence (protecting, improving, firing back - covering alone is not enough once
shots stack), ability to defend while rising; a second KD in a round is stopped sooner. No 10-count in MMA (Nevada).

| Type (J) | Immediate stop | Recovers this sequence |
|---|---:|---:|
| Flash KD | ~10% | ~80% |
| Heavy KD | ~60% | ~30% |
| Out cold | ~100% | 0 |

## 4. Fouls (Unified Rules 2024 wording, UFC since Nov 2024)

Grounded = anything but hands/feet on the canvas. Illegal: knee/kick/stomp to a grounded head. Leg kicks to a grounded
man legal; upkicks legal. UFC DQs ~15-25 in 8,500+ fights (S); foul rate per KD far under 1% (P). Usual action: time-out,
warning or 1-2 point deduction; intentional + cannot continue = DQ (S). What matters in a sim: the half-second
hesitation it causes, which is why men hover and punch.

## 5. Non-knockdown entries (same topology, low danger)

Stuffed shot (most of them; 2-8 s, then TD, front headlock or both stand), slip (1-4 s), failed sweep / guard pull
(2-6 s, legs kickable), stumble to a knee (1-3 s). All J. Much lower stoppage, higher both-stand.

## 6. Boxing and kickboxing

Mandatory 8-count, standing man to a neutral corner, follow-down illegal. Standing 8: not in ABC unified boxing; some
amateur K-1. Three-knockdown rule: not in unified/major title boxing (some US states non-title); common in kickboxing
(Glory: 3 in a round = TKO). A ruleset flag, not a default. The count REPLACES this state; MMA enters it at once.

## 7. Smallest state machine (MMA only)

STANDING / ONE_DOWN_ONE_UP / GROUND_TOP (existing seats) / CLINCH / STOPPED. ONE_DOWN_ONE_UP is not GROUND_TOP: no hips
claimed, no guard, it lasts seconds. Entry: scored KD (danger high); slip, stuffed shot, failed guard pull (danger low).

Per-second rates at high danger (J, calibrated to the S timings), columns t=0-3 s / 4-10 s / >10 s:

| Transition | 0-3 | 4-10 | >10 | To |
|---|---:|---:|---:|---|
| Referee stoppage | 0.18 | 0.08 | 0.03 | STOPPED |
| Follow-down settles on top | 0.12 | 0.10 | 0.06 | GROUND_TOP |
| Downed man stands clean | 0.08 | 0.12 | 0.15 | STANDING |
| Wall-walk to feet | 0.03 | 0.05 | 0.04 | STANDING or fence clinch |
| Leg grab / scramble | 0.04 | 0.05 | 0.04 | GROUND_TOP (either) or STANDING |
| Upkick lands, standing man hurt | 0.01 | 0.01 | 0.01 | STANDING (roles may flip) |
| Illegal knee/kick | 0.002 | 0.002 | 0.001 | pause -> warning / point / DQ |

Low danger: stoppage /10, both-stand and leg-grab x2, force a branch at ~8 s.
Standing-man policy picked on entry (may flip once): FOLLOW / HOVER / RESET, priors 0.55/0.25/0.20; wrestler FOLLOW
~0.7, kickboxer HOVER+RESET ~0.6. RESET exits to STANDING in 1-3 s.

Deferred: flash vs heavy as a field (use incoming damage + a consciousness roll), the exact response mix (one
defend/stand/grab triad), foul mini-game (a hazard + DQ leaf), weight-class modifiers, the boxing/KB count machine (its
own ruleset), multi-KD tripwire (raise stoppage after KD #2).

**v1 acceptance on a scored standing KD:** ~35-40% of sequences over by 10 s; ~50-55% over by end of round; median
time-to-stop 5-7 s; survivors exit to STANDING or GROUND_TOP, never a reset that erases the damage.

## Claude's disposition (S103)

Build target for the engine queue after the fence pin: a knockdown in MMA enters ONE_DOWN_ONE_UP instead of ending or
snapping back. Gate on the v1 acceptance lines above, measured with Q205's census extended by a KD-sequence counter.
