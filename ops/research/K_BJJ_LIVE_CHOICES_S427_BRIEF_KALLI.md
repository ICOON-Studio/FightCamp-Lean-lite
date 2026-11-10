# K_BJJ_LIVE_CHOICES_S427_BRIEF_KALLI - Kalli answer (seat queue SQ39)

Brief: research/K_BJJ_LIVE_CHOICES_S427_BRIEF.md
Sent: 2026-11-10 18:12 | collected: 2026-11-10 18:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'll start with the critic pack, the access notes, BjjMatch.gd and the V6 design, then write the in-bout decisions page and paste it here as text.

I'm writing the BJJ in-bout decisions page now. You'll get it pasted here as text, in parts.

Part 1 of 3

# What the player decides DURING a BJJ bout (S427, Kalli)

**Answer first.** Today the live bout has one decision: 3 move calls (GAME, BjjMatch CALLS_PER_MATCH). All three come on settles, often with two options that are the same, and none come when Ana is tired. That leaves about four minutes of watching. This page puts in nine decisions a real no-gi corner makes. A scheduler makes sure an ask comes at least every 30 s (INVENTED) and never repeats the last ask. Each ask is paid for with one of three things: a call token, a shout the corner has to earn (trust), or Ana's gas. Build these first: the duplicate fix, the pace shout with the scheduler, the last minute, and "caught deep: fight or tap". A hard critic scores today's bout 3/10 and this design 7/10. Section 9 lists what takes it to 10.

Sources. GAME: [BM] scripts/rules/BjjMatch.gd, [V6] ops/research/BJJ_DESIGN_V6_S397.md, [CP] ops/research/CRITIC_PACK.md. REAL: [IB] [IBJJF Rule Book v6.1 2024](https://www.ufaf.org/tournament/2024JUN_IBJJF_Rules_EN.pdf); [IBN] [IBJJF heel hook update](https://ibjjf.com/news/new-rules-updates); [AD] ADCC rules from [FloGrappling](https://www.flograppling.com/articles/12784957-adcc-rules-heres-what-to-know-about-how-adcc-worlds-works) and [the jjbqc.org rules PDF](https://jjbqc.org/wp-content/uploads/2023/06/ADCC-Rules.pdf). I didn't read the Miro board, because it needs a signed-in Miro connector that I don't have here.

## 0. The rules we play, and the bug

- Ana Ribeiro (no-gi, women's divisions, [CP] 4.15) faces another woman. The match is 5:00 at white belt (REAL [IB] match time table: white 5, blue 6, purple 7, brown 8, black 10 minutes). The game sets it in BeltRoad.match_minutes (GAME [BM]).
- Points: takedown 2, sweep 2, knee on belly 2, pass 3, mount 4, back 4 (REAL [IB] Art. 4; GAME BeltRoad.POINTS). A position must be held 3 s (REAL [IB]). Giving a position up and taking it back scores nothing (REAL [IB]; GAME PAID_ONCE).
- Advantage: a scoring position nearly reached, or a submission with the opponent "in real danger" (REAL [IB] Art. 5). Level points go to advantages, then fewer penalties, then the referee: who attacked more (REAL [IB] 2.5.3, 2.5.4, 2.6).
- Stalling: the referee counts 20 consecutive seconds and calls "Lute" (REAL [IB] 7.3.1). Holding side control without progressing is stalling, and so is a closed guard that just clutches (REAL [IB] 6.2.1 examples). Holding mount or the back is not stalling, and neither is defending under mount, back, side control or north-south (REAL [IB] 6.2.1 D, E).
- Penalty ladder: 1st marked, 2nd an advantage to the opponent, 3rd 2 points to the opponent, 4th disqualification (REAL [IB] 7.2). A move illegal for the division is an instant disqualification (REAL [IB] Art. 6, item M). Heel hooks and knee reaping are legal only for adult brown and black belts in no-gi (REAL [IBN], 2021).
- A tap is two taps with a hand, two with a foot, a verbal give-up, or a scream of pain (REAL [IB] 2.1.1-2.1.4). The referee may stop a hold that risks serious injury (REAL [IB] 2.2.2). The rule book text I read has no line letting a coach stop the match: CHECK (John).
- ADCC is different and could be a later "ADCC-style open". There are no points in the first half of a qualifying match (10 min with the first 5 scoreless, REAL [AD]). Pulling guard and staying down 3 s costs minus 1, and so does disengaging. Passivity gets two warnings, then minus 1 (REAL [AD]).
- **The duplicate bug.** call_offers takes the top 2 offers by expected points (GAME [BM]). Two plain positional arrows with the same title, kind and odds (PLAIN_MASTERY 30, GAME [BM]) both get through, which is how the film showed "Move up (46%)" twice. Design fix: one option per kind and landing. Plain moves name where they land ("Up to mount", never "Move up"). The freed slot goes to the best move of a different kind. If there is none, the card shows 2 options. No card may show two options with the same kind and the same landing.
- Flag for Claude: tick() calls level points at the bell a draw (GAME [BM]), but a bracket needs a winner and the real rule is advantages, then penalties, then the referee (REAL [IB] 2.5-2.6). BjjMatch.decide exists, and decide() sends advantages as [0, 0]. So advantages are not live in BjjMatch: they are a NEW lever here (designed in [V6] F as the near miss within 0.10, at most 2 a match).

## The cadence: what asks, and when

- Pacing rule: a quiet timer runs from the last ask. At 30 s (INVENTED) the next eligible ask fires. The pace shout (D2) is always eligible, so a quiet stretch can always be filled. An ask may not be the same decision as the one before it. Settle calls keep CALL_GAP_S 20 s (GAME [BM]).
- What it costs. There are 4 call tokens a match (INVENTED, up from 3 GAME), spent by D1, D4 and D6. Shouts (D2, D3, D5, D8, D9) are free, but only two a minute get through in full (GAME [CP] 4.8 boxing rule, reused here); a third lands at half (INVENTED). D7 is free because it is forced.
- Trust: morale is trust in the corner. Fired up gives x1.05 of a call's effect, Steady x1.0, Flat x0.85, Low x0.7. A wrong call costs -2 morale and a right one adds +1 (GAME [CP] 3). The grade comes from the Why's read of the moment, not from the dice.
- Gassed: today calls stop below gas 0.35 (GAME TIRED_GAS). New rule: the card still comes, but shows 2 options, "Hold and breathe" and the plan move, under a TUNNEL VISION label. Shouts land at half (INVENTED).
- A typical 5:00 brings 9-11 asks (INVENTED target), and 4 of them spend tokens.

| Clock | Likely ask |
|---|---|
| 0:00-0:20 standing | D2 pace (first word) |
| 0:30-2:20 | D1 settles, D6 when stuck underneath, D5 once a habit has shown twice |
| 2:30 | D8 the half-way word (free, once) |
| 2:40-3:50 | D4 points or finish, D3 when the count starts, D7 when caught |
| 4:00-5:00 | D9 the last minute, then D3 or D1 as they come |

Part 2 of 3

## 1-4. The decisions

**D1 The move call (fixed).** When: a heavy settle with Ana holding the initiative (GAME [BM] SETTLES; SETTLE_S 0.4 s; CALL_GAP_S 20 s). 3-5 times in 5:00. Cost: 1 token, plus gas (MOVE_GAS 0.015, +0.025 on a miss, x(1.5 - cardio/100); GAME [BM]).

| Option | Right when | Changes / sees |
|---|---|---|
| Plan move (from the mat tree) | its points are unpaid and the odds are at or above its kind's base (GAME KIND_BASE) | odds by kind, points; a LANDS or MISSED banner, the score plate ticks |
| A different kind (a sweep, a sub, a stand) | the plan move pays 0 (PAID_ONCE) or the opponent owns its answer | as above; a miss passes the initiative (GAME [BM]) |
| Hold and breathe | Ana is in mount or back (no stall, REAL [IB] 6.2.1 E) or gas is under 0.5 (INVENTED) | +0.06 gas (GAME HOLD_GAS); in guard, half guard or side control it starts the stall count (REAL [IB]) |

**D2 Pace: Push / Work / Slow it down.** When: the first word at the start, after every score change, and as the filler. 2-4 times. The pace stays set between shouts, as in boxing (GAME [CP] 4.8). Cost: a shout.

| Option | Right when | Changes / sees |
|---|---|---|
| Push | Ana trails, or the opponent is breathing harder | the grip-fight beats go to Ana 60% (INVENTED; initiative lever); odds +0.04 (INVENTED); gas drain x1.4 (INVENTED). A PUSH chip; the opponent's gas word drops |
| Work | even match, plenty of clock | today's engine |
| Slow it down | ahead and in mount or back, or gas under 0.5 with over 1:30 left | Ana holds where possible (+gas) and the opponent gets more beats. Outside exempt spots the 20 s count starts (REAL [IB] 7.3.1) |

**D3 The referee's count.** When: the 20 s count starts on Ana (REAL [IB] 7.3.1). 0-2 times. Stall tallies live in BjjRef ([V6] H: every 2nd idle hold is a stall, GAME) and the live bout's stall count is in [CP] 4.15. BjjMatch.gd itself has none: CHECK (Claude) where the live count sits. Cost: a shout.

| Option | Right when | Changes / sees |
|---|---|---|
| Show work (the lowest-risk attempt, GAME LOSS table) | the next penalty would be the 2nd or 3rd (advantage or 2 points to the opponent, REAL [IB] 7.2) | ends the count; costs a little gas |
| Climb a rung (GAME TOP_RANK) | Ana's mount or back odds are 0.45+ (INVENTED); mount and back are exempt (REAL) | a stalling lever plus odds by kind; the count ring vanishes |
| Take the penalty | it would only be the 1st (marked, no score, REAL [IB] 7.2) and Ana leads | a penalty dot on the plate; the hold keeps its gas |

**D4 Points or the finish.** When: one settle offers both a sub and a scoring move. 1-3 times. Cost: 1 token.

| Option | Right when | Changes / sees |
|---|---|---|
| Take the points | Ana leads or it is level before 3:00, and the sub odds are near base (0.22, GAME KIND_BASE) | points; a miss only stays put (GAME LOSS 0.5) |
| Hunt the finish | Ana trails by 3+ after 3:30, or the sub is at signature (50, GAME [CP] 4.15) | a hit ends it; a miss gives up the grips and the initiative (GAME LOSS 1.0). NEW: a near miss within 0.10 scores an advantage ([V6] F; REAL [IB] Art. 5) |
| Set it up | over 2:00 left and the sub is owned but its odds are low | NEW chain lever ([V6] engine "chain"): the next sub from here +0.06 (INVENTED); a "set" chip |

**D5 Answer the opponent's best move.** When: the opponent has tried the same kind or the same named sub twice (from the match log, GAME [BM]). It comes once per kind, 1-2 times a match. Cost: a shout.

| Option | Right when | Changes / sees |
|---|---|---|
| Name the answer | Ana owns the answer move (30+, GAME OWNED_AT) | NEW lever: the opponent's odds on that kind x0.8 if the answer is owned, x0.95 if only felt (15-29, GAME [V6] F); INVENTED multipliers. A habit chip "Guillotine x2" turns to ANSWERED |
| Beat it to the punch | Ana has more gas than the opponent | the initiative goes to Ana in that position for the next beat (INVENTED) |
| Let it come, win elsewhere | the move scores 2 or less and Ana leads by 4+ | nothing changes; saves a shout for later |

**D6 Back to the feet.** When: Ana is underneath (guard or half guard) without the initiative for 20+ s (INVENTED), or has just been swept. 1-2 times. Cost: 1 token.

| Option | Right when | Changes / sees |
|---|---|---|
| Stand up | Ana's takedown odds beat the guard's sweep odds, with over 1:00 left (a takedown is 2, REAL) | NEW move kind "stand": escape base 0.40 (GAME KIND_BASE) x strength; to standing |
| Work the guard | Ana owns a sweep from here | the sweep is offered first (odds by kind) |
| Tie up and breathe | gas is under 0.4 (INVENTED) and the clock is long | +gas, but a clutching closed guard is stalling (REAL [IB] 6.2.1 example); the count starts |

**D7 Caught deep: fight it or tap.** When: the opponent's sub roll misses by 0.10 or less (the near band, GAME [V6] F). The bout slows for 3 s (INVENTED). 0-2 times. Free, because it is forced. Real point: on an open day of 3-5 matches (GAME [V6]) a tap saves Ana for the next round of the bracket.

| Option | Right when | Changes / sees |
|---|---|---|
| Fight it | a choke, and Ana leads or the bracket ends here | escape by [V6] F slide S (0.30-0.70, GAME); the opponent gets an advantage (REAL Art. 5) |
| Turn into it | Ana owns its escape (30+) | S +0.15 (INVENTED); lands in that arrow's escape position ([V6] F) |
| Tap | a joint lock (armbar, kneebar), or more matches today, or down with under 1:00 left | loss now, no injury. NEW: fighting a joint lock rolls an injury (weeks out, INVENTED) |

**D8 The 2:30 word.** When: half the belt's clock (2:30 of 5:00). The [IB] match table gives one match time and no break (CHECK (John)). A real corner shouts the time and the score. Once, free, and it does not count against the two-a-minute. The card shows three words picked from the match state:

| Word | Right when | Changes / sees |
|---|---|---|
| "Points, stay heavy" | Ana leads | NEW: shifts the default pick (the [BM] ev: sub x10, points +0.5) toward points |
| "Go get the finish" | Ana trails by 4+ or has the opponent's back | the pick shifts toward subs |
| "Breathe, then go at 1:30" | gas is under 0.5 | holds until 1:30 left, then Push |

**D9 The last minute.** When: 1:00 left, and once more at 0:20 if the score has changed. Cost: a shout. The clock maths is real: 60 s is three 20 s counts. Riding side control with a 2-point lead can run 1st marked, 2nd advantage, 3rd 2 points (REAL [IB] 7.2), and the lead is gone.

| Option | Right when | Changes / sees |
|---|---|---|
| Ride it out | Ana is in mount or back (exempt), or the lead is 5+ | holds; the clock turns red |
| Keep moving safe | Ana leads in a position that can be stalled | lowest-LOSS moves only; no count |
| Everything on it | Ana trails | sub odds +0.03 (INVENTED); a miss costs double gas (INVENTED) |
| Bank an advantage | points are level | NEW: near-miss attempts weighted (advantage lever) |

Real no-gi corner words for the shout labels (common coaching words, no source claimed): "Frame", "Hips out", "Underhook", "Hand fight", "Time", "You're up two", "Stay heavy".

**The owner's other asks (art, effects).** The sources do not list the missing refinement art, and I didn't read the Miro board, so I invent none. Each landing needs these drawn or felt:
- the call card with distinct options;
- a PUSH / WORK / SLOW chip;
- the 20 s count ring and the referee's "Lute" gesture (REAL [IB] 1.4);
- dots for points, advantages and penalties on the score plate;
- the habit chip;
- the two-tap and the deep slow-down;
- the 2:30 board;
- the red clock in the last minute;
- a flash on a landed call, and gas bars that tween ([CP]: "animated meters").

Part 3 of 3

## 5. The camp link (bought before match day)

| Bought before | Where | What it gives live |
|---|---|---|
| A drilled escape or answer owned (30, GAME) | the week's classes, the mat tree | "Name the answer" (D5) and "Turn into it" (D7) |
| A game plan path on the mat tree (points path or finish path) | the Playbook, "<name>'s mat" ([CP] 5.4) | D1's first option and the default of the 2:30 word |
| Scouting the opponent | NEW for BJJ (boxing has tape study, [CP] 4.3) | the habit chip from 0:00; D5 after one show, not two |
| Cardio worked in the week | Ana's stats ([BM] CARDIO_K) | how long Push is affordable |
| A stand-up drilled | NEW syllabus item | D6 "Stand up" at owned odds |
| Ana's gas from the last match on the day | NEW carry-over | makes D7's tap a real choice |

## 6. The menus

| Screen | Decisions | Reads from |
|---|---|---|
| Live bout: the call card | D1, D4, D6, D7 | BjjMatch offers, odds, gas_cost, risk, calls, the paid ledger |
| Live bout: the shout bar (NEW, like boxing's) | D2, D3, D5, D9 | the match log, clock, points, the BjjRef stall tally, the opponent's gas word |
| Live bout: the 2:30 board | D8 | points, gas for both, penalties, habit chips |
| The score plate | all | points, advantages (NEW), penalties, the pace chip, the count ring |
| Mat tree / Playbook | D1, D5, D7 set-up | owned moves, owned answers, the plan path |
| Open night / fight prep card ([CP] 5.x) | D5 and the gas carry-over | the opponent's file (scouted), Ana's gas from the last match |
| The after-bout Why | grades all | each call against the moment (right, ok, wrong), swings, what decided it |

## 7. The smallest build, then the order

1. Probe first, on 300 headless matches (INVENTED count). Pass bars: the longest gap without an ask is 35 s or less; never the same ask twice running; every option is the best pick in 15-60% of the times it is shown (INVENTED band); the calls move the win chance by 3-10 in 100 (INVENTED).
2. The smallest version: the duplicate fix, the gassed 2-option card, the quiet timer with D2 pace, D9 the last minute, and D7 fight or tap.
3. D3 the referee's count (needs the live stall tally).
4. Advantages live in BjjMatch, then D4 points or finish.
5. D5 the habit answer, then D8 the 2:30 word.
6. D6 back to the feet (the new "stand" kind).
7. The camp links: owned answers, scouting, gas carry-over.

## 8. Kill list

| Decision | Hardest objection | Answer |
|---|---|---|
| D1 | Still "pick the biggest %". | The other-kind slot plus PAID_ONCE gives the top % 0 points. Partial: if the probe shows one option wins 60%+, cut it. |
| D2 | A persistent pace gets set once and forgotten. | It is asked again after every score change; Push costs gas, so leaving it on gasses Ana. |
| D3 | Players will never take a penalty. | The 1st penalty costs nothing on the plate (REAL), so taking it is correct play with a lead. |
| D4 | Subs at 0.22 base are never worth it. | They are when trailing late; the Why shows the swing. Honest: at white belt it may stay rare. |
| D5 | It is a free buff with no choice in it. | Each option has its own case, and a shout spent here is gone from the two-a-minute. |
| D6 | Standing up is always safe. | It is a move with miss odds; a miss under the opponent passes the initiative. |
| D7 | Tapping feels bad and nobody will. | The injury roll and the next bracket round make it real; this needs the carry-over built, or it is weak. |
| D8 | One free word is a no-choice. | The three words fit different states; a wrong word costs trust. |
| D9 | It overlaps D2. | It asks something else (how to spend 60 s against the stall clock) and has its own options. |

## 9. Scores (a hard critic, depth 0-10)

| Part | Now | With this | To reach 10 |
|---|---|---|---|
| The bout as a whole | 3 | 7 | the probe bars pass; the Why grades every call; ADCC-style opens as a second rule set |
| D1 move call | 3 | 6 | the chain lever so calls build on each other |
| D2 pace | - | 7 | the opponent visibly changes pace after 2:30 (NEW opponent shouts) |
| D3 the count | - | 7 | the referee's gesture and count on screen, measured penalty rates |
| D4 points or finish | - | 7 | advantages live, the set-up chain measured |
| D5 habit answer | - | 6.5 | scouting built, and the opponent switching habit once answered |
| D6 to the feet | - | 6 | the stand kind in GrappleMap data with its own 3D move |
| D7 fight or tap | - | 7.5 | injuries and gas carried across the bracket |
| D8 2:30 word | - | 6 | words that name the opponent's habit, written from the state |
| D9 last minute | - | 7.5 | a red clock, and the stall clock maths shown in plain words |

## INVENTED numbers (for John)

Quiet timer 30 s. 4 call tokens. Third shout in a minute at half. Gassed: shouts at half; hold is right under 0.5 gas. 9-11 asks a match. Push: grip beats 60%, odds +0.04, gas x1.4. Climb at 0.45+ odds. Set it up +0.06. Answer x0.8 / x0.95. Beat it to the punch: 1 beat. Stuck 20 s; tie up under 0.4 gas. Deep slow-down 3 s. Turn into it +0.15. Joint-lock injury weeks. Everything on it: +0.03 odds and double gas. Probe: 300 matches, 35 s, 15-60%, 3-10 in 100.

## CHECK (John)

- Whether a coach may stop an IBJJF match (not found in [IB] 2.1-2.2).
- The legality table's columns: I took heel hooks and reaping for brown and black from [IBN]; the PDF table lost its marks in text.
- That "Lute" is the stalling command, and the 3 s hold for points.
- The ADCC numbers if an ADCC-style open is built.
- The idea that a tap saves gas for the next match (a game rule; no real source).

## CHECK (Claude)

- Where the live 20 s count runs, since BjjMatch.gd has none.
- The level-points draw at the bell in tick() versus decide(), which passes advantages as [0, 0].

---

The two-identical-options bug comes from call_offers: it keeps the top 2 by expected points, so two plain moves with the same name and odds both show. I didn't read the Miro board, and no source lists the missing refinement art, so the page invents none.

The page is saved on my computer at `/workspace/r28/BJJ_LIVE_DECISIONS_S427_KALLI.md` and isn't in the repo yet; Claude commits.
