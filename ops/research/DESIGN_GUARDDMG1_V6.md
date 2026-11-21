# GUARDDMG1 V6 - guard damage: covering must change who wins the exchange (S534, Fable console, from the code)

Brief: `ops/research/TASK_GUARDREV6.md`. Follows the verdict of `DESIGN_GUARDDMG1_V5_CRITIC_KALLI_KALLI.md` (Depth 6 /
General design 7 / Play 5): "every v5 rule acts after the exchange is settled". That is a METHOD finding, so v6 changes
the method (where the guard enters the fight), not the numbers.
Tags: **CODE** = I opened the file and the line is true on 2026-11-21 (working tree on main at 48f290a26). **DERIVED** = my
sums from CODE numbers, not measured. **ESTIMATE** = a number to tune, not in the game. **V5** = taken from the v5 map's
own CODE table and not re-opened this session. **CUT** = not in v6. No Godot was run. Files opened: section 8.
`scripts/state/LiveRound.gd` has another session's 2 uncommitted lines (245-246, StepWire.ride); line numbers below are the
working tree's. The committed file is 2 lower from line 245 on.

## 0. The short version
- Today the guard is counted AFTER the 30 seconds are decided. It changes knockdown odds and figures. It never changes
  who wins a round, because rounds are exchanges won and nothing from the guard is in the exchange's sum (1.2, 1.3).
- v6 adds one standing setting, **Hands: High / Normal / Loose**, beside Pace and Aim. It adds points to the same sum
  the corner call, the pace and the plan already feed, BEFORE `Exchanges.settle` (section 2).
- Covering now loses rounds against a boxer who boxes at range or is tiring, wins them against one who loads up, and
  tires a presser who keeps punching the guard. Loose hands win rounds against a tired or hurt opponent and get your
  boxer hurt against a counter-puncher.
- A worn guard also costs points in the exchange (the `GUARD_EDGE` the code says is "NOT YET", `GuardState.gd` line 10).
- All three stale screen lines v5 found are already fixed in the code (1.6). Nothing of section 2 is built.

## 1. What the game does today (CODE)

### 1.1 How 30 seconds are decided
- A round is six exchanges (`Exchanges.EXCHANGES` 10). `LiveRound.exchange` builds one number `d`, "her edge in power
  points", then calls `Exchanges.settle(d, roll_a, roll_b)` at **LiveRound 287**.
- `Exchanges.settle` (356-361): margin = d + two dice of +/-33 each (`EX_SPREAD` 66, line 14). Margin 0 or more = your
  boxer won the exchange. The size of the margin picks the landed punches: 4-3, 5-2 or 6-1 (`LANDED` 345, `band` 349-351).
- The round: most exchanges won; 3-3 goes to the bigger total margin (`Exchanges.round_of` 366-379, called by
  `LiveRound.close` 408). The cards: 10-9 a round won (`BoutRules.cards_of` 402-412). The three judges who count
  clean punches and work rate are drawn but do NOT decide (`JudgeNight.DECIDES` false, line 16).
- So today the ONLY way to win a round is to push `d` up. Landed punches decide nothing on the cards.
- DERIVED from `settle` (the same sum `Exchanges.win_shift` 215-223 uses): from an even exchange, +3 points wins 4 more
  exchanges in 100, +5 wins 7, +8 wins 11, +17 (a best corner call done well) wins 22.

### 1.2 Everything that feeds d BEFORE settle (LiveRound 212-283)
| Line | Term | Guard in it? |
|---|---|---|
| 212 | the round's base (`lv["base"]`: the strength gap and energy), the corner call (`Exchanges.call_edge` 255-265), stiff jab perk, an unfixed habit | The call "Hands up, move your head" is here: +17 x how well your boxer does it when the opponent loads up, +5 when your boxer is tired or hurt, 0 in every other game (`MODES` 126-133, `EDGE` 18). It is graded on Defence and head movement (`CALLS` 79; `Attrs` 264-266). |
| 214, 221 | the corner's talk, a fired set-up | no |
| 222 | pace and aim (`PaceAim.edge` 26-41: Push +6, Save -4, a named aim -1.5), push on an empty tank, a cold start | no |
| 233 | the read (counter) | no |
| 265 | the plan's line, the round's reads, the plan's pressure, the pro read | no |
| 267 | camp weeks spent on the opponent's game | no |
| 268 | `CrackWire.guard_edge` (68-74): a cracked rib "guards worse" | a rib rule, not the guard number |
| 275 | the clinch's price | no |
| 279-283 | the place duel, style levers, the step's opening and deny | no |
**Nothing from `GuardState` or `GuardWear` is in this sum.** Kalli's finding is true, with one correction: the call
"Hands up" already moves who wins, but only as a right answer to "Loading up". In the other five games it costs
nothing (edge 0, energy 0: `CALLS` 79) and still earns +5 guard at the corner (1.4). A free cover.

### 1.3 Every guard rule, and where it runs: all AFTER settle
| Line (LiveRound) | Rule | Changes |
|---|---|---|
| 288 | `StepWire.levers` (158-190): a planned step denies some of the opponent's punches, a wrong step lets more in, a step can drain the opponent (`lv["opp_drain"]` 184) | `s["landed"][1]`, the opponent's energy (`RingDuel.opp_energy` 332-335) |
| 297 | pace output: Push x1.25, Save x0.75 (`PaceAim.PACE_OUTPUT` 13) | `s["landed"][0]` |
| 300-304 | hurt ribs / a cracked side land less | `s["landed"]` |
| 307-313 | Counter sense perk: +1 landed, margin up, damage | landed, margin (not `won`) |
| 318 | **ONE CHANGE "Gloves high" / "Elbows in"** (`Adaptation.body_shots` 80-90): moves some of the opponent's landed punches between head and body for one round, 2.0 head damage each (`HEAD_DAMAGE` 24) | where punches land. Its own header says "not who wins" (`Adaptation.gd` 5) |
| 325-334 | punches taken in a tie-up (`ClinchRest`) | landed, damage |
| 354 | **`GuardState.after`** (93-135): blocks, wear, recovery, the tie-up's +10, the Hands up flag | the two guards |
| 355-359 | **the leak** (`GuardState.wear_through` 65-81) | `m["damage"]` |
| 389 | `RingDuel.settle` (356-397): energy, who is hurt (from the margin, 383-386), the opponent's next game | the next exchange |
`m["damage"]` is read only by the knockdown rule after the round (`BoutNight._counts` 254 -> `Knockdowns.round_counts` 20-74).

### 1.4 The guard number itself
- Each side has `{g, max, clinch, hands_next}` (`GuardState.open` 37-49). Full: light 80, middle 100, heavy 120, any
  amateur 70 (`GuardWear.max_guard` 268-275).
- Blocks are worked out from the other side's landed count: thrown = landed / 0.33 (`BoutBurn.LAND_RATE` 8); 60 in 100
  of the punches that did not land were blocked (`GuardState.BLOCK_SHARE` 16, `blocked_of` 53-55). The same 60 for every
  boxer: Defence is not in it. No choice of the player changes it.
- A block costs 1 / 3 / 5 guard points by punch kind (`GuardWear.wear` 127-160), the mix is fixed (`BoutBurn.MIX` 9: jab
  50, cross 25, lead hook 13, body hook 6, uppercut 6), then x0.40 pro / x0.28 amateur (`GuardState` 17-18).
  Passed in today: ropes +12%, amateur +15%, shoulder endurance, the "slow starter" habit (`GuardState.after` 100-111).
  In `wear` and passed by nobody: **moving -5%, high posture +8%**, condition, missed weight (138-150).
- The leak: jab 25%, power 42.5%, heavy 55% of a blocked punch at a full guard, doubling on a slope to an empty one
  (`GuardWear.transmission` 100-117), x the punch's worth x 0.038 (`GuardState` 19-20, 78-81).
  The opponent's power is in neither the wear nor the leak.
- Back in the round: +3 (amateur +4) only when the other side threw nothing (`GuardWear.in_round` 219-224).
  DERIVED: `settle` always gives the loser at least 1 landed = 4 thrown, so this fires only when a step's deny or a
  rib rule cuts a side's landed to 0. The "+1 for 1-2 thrown" branch cannot happen.
- The corner: +15 a minute, +5 more if "Hands up" was called in the round (`GuardWear.corner` 241-257,
  `GuardState.open` 45-46, `after` 132-133). The tie-up: +10 once a round under half guard (`GuardWear.clinch` 228-236;
  its `skilled` +13 is passed `false` at `GuardState.after` 128).

### 1.5 The opponent's side of it
- The opponent has no Pace or Hands setting. It plays one of six games (`Exchanges.MODES` 124-134) by its style
  (`MODE_V` 180-190), switches to "Tiring" 3 times in 4 once its energy is under 45 (`next_mode` 273-274,
  `OPP_TIRED` 56), and its energy runs from the bell's figure to the round-end figure (`BoutNight._energy` 319-341)
  less body shots and `opp_drain` (`RingDuel.opp_energy` 332-335).
- So "the puncher pays for punching a guard" needs no second energy model: `lv["opp_drain"]` is already a line.

### 1.6 What v5 listed as wrong on screen: fixed in the code since
| v5's stale line | Now (CODE) |
|---|---|
| "Hands up ... your boxer throws less" | "{opp}'s big shots miss" (`Exchanges.CALLS` 80, comment S533 GUARDREV5) |
| "a quiet exchange gives back 4" | "it comes back only when the opponent lands nothing (+4, pro +3)" (`GuardNotes.amateur_note` 24-26) |
| the guard bar's hover never mentioned blocks | "Guard: how high the hands stay. Blocked punches wear it down." (`HudBars.WORDS` 38) |
Still there: the caption that names no button, "The hands are coming down - over the top!" (`HudBars._guard_call` 300-307,
under 55%: `GUARD_LOW` 46); `GuardWear.blocked_strikes` (321), `parry_chance` (302), `posture_damage` (202), `word` (342)
and the clinch's "stamina -10 / free exchange" (236) with no caller in `scripts/` (git grep, this session).

### 1.7 Earlier research this map follows
- GUARDPROBE1 (`docs/GUARDPROBE1_RESULT.md`, `tools/guard_probe.gd`) sized the wear scales and the leak.
- GUARDPROBE2-4 (`docs/GUARDPROBE4_RESULT.md`) tested a HIGH / NEUTRAL / LOW **posture** (head against body) with
  `posture_damage`: HIGH or switching was best everywhere, LOW never. S528 decision: no posture control; the corner's
  Gloves high / Elbows in already is posture. v6 keeps that decision. **Hands is not a posture.** Posture = WHERE the
  punches land (head or body). Hands = HOW MUCH your boxer covers instead of punching. `posture_damage` stays unused.

## 2. The core change (TO BUILD; every size ESTIMATE until the probe of section 6)

### 2.1 Hands: High / Normal / Loose
- A third standing setting beside PACE and AIM on the corner bar. Same life as Pace: counts from the next exchange and
  stays until changed (`PaceAim.WHEN` 101), carried round to round in `m["live"]` (as `pace` / `aim` at LiveRound 111),
  set through the shout string as `|hands=high` (the `|pace=` / `|aim=` parser at LiveRound 167-172).
- The shout **"Hands up, move your head" = High for that one exchange**, whatever the setting. The shout **"Let your
  hands go" = Loose for that one exchange**. This answers v5's open question: a shout lasts 30 seconds, the setting holds.
  If the round's plan call is one of the two (`call` at LiveRound 190), it holds all round.
- New pure module `scripts/rules/HandsEdge.gd` (no preloads), one line in LiveRound next to 222:
  `d += HandsEdge.points(hands, sit, vals) + HandsEdge.worn(share_b) - HandsEdge.worn(share_a)`.
  It joins the SAME sum as the call, the pace and the plan, before `Exchanges.settle` (287).

### 2.2 The points, by the game the exchange is fought in (`Exchanges.situation` 194-199)
| The exchange | High | Loose | Why (boxing) |
|---|---|---|---|
| The opponent loads up | +6 | -8 | big single shots hit gloves; loose hands eat them |
| The opponent presses | -3 | +2 | a shell on the ropes gives the 30 seconds away, but see 2.4 |
| The opponent boxes at range | -7 | +3 | covering against a jab is not punching: the round goes |
| The opponent waits to counter | -2 | -6 | nothing to block; loose hands walk onto the counter |
| The opponent is tiring | -8 | +6 | covering lets a tired boxer rest; open up |
| The opponent is hurt | -8 | +5 | same |
| Your boxer is tired | +3 | -6 | survive the 30 seconds |
| Your boxer is hurt | +5 | -10 | survive the 30 seconds |
Normal is 0 everywhere: today's game.
- A plus is multiplied by how well your boxer does it, a minus by how hard your boxer commits to it - the corner
  calls' own rule (`Exchanges.grade` 227-245, `COMMIT` 32). High is graded on Defence and head movement (the "hands" call's
  needs, `CALLS` 79). Loose on Stamina and hand speed ("Let your hands go", 82). **The week feeds the fight here.**
- DERIVED sizes: High against a boxer at range loses about 10 more exchanges in 100; Loose against a tiring opponent
  wins about 9 more; High against a loader wins about 9 more. Between Save (-4) and a best call (+17): a setting matters
  less than a right call and more than nothing.
- The shout on top: "Hands up" against a loader keeps its +17 call edge AND the +6. "Hands up" at range is call edge 0
  AND -7: the free cover of 1.2 now has a price.

### 2.3 A worn guard costs points (the code's "NOT YET")
- `HandsEdge.worn(share)`: guard under half -2, under a quarter -4, for that side. Both sides: the opponent's worn guard
  pays your boxer. This is the first time wearing a guard down wins rounds, and the reason High cannot be held all night
  (2.5: it takes more blocks).

### 2.4 Covering tires the puncher (Kalli point 3)
- While Hands is High and the opponent is pressing or loading up: `lv["opp_drain"] += 1.0` an exchange (the existing line
  of 1.5). DERIVED: 6 energy a round, on top of the opponent's own spend.
- Under 45 energy the opponent turns "Tiring" 3 times in 4 (CODE, 1.5). There High is -8 and Loose is +6. The player
  must SWITCH: cover while the presser is fresh enough to hurt, open up when the mouth is open. The opponent's energy
  bar and the clue line ("mouth is open; the hands come back slow", `CLUES` 146) already show the moment.
- Over 3 amateur rounds the drain rarely gets a fresh presser under 45 in time (ESTIMATE; the probe measures it): there
  High just loses -3 an exchange. Over 6 pro rounds it does. Amateur and pro stay different.

### 2.5 What Hands does after settle (the count, the guard, the hurt)
The winner from `settle` stands. These lines change counts and damage only, next to LiveRound 297:
| | High | Loose |
|---|---|---|
| The opponent's landed | 1 in 3 becomes a block: 6->4, 5->3, 4->3, 3->2, 2->1, 1->1 (`round(n / 3)` taken off) | +1 when the opponent won the exchange |
| Your boxer's landed | x0.75, rounded as Save is (LiveRound 297): 6->5, 5->4, 4->3, 3->2, 2->2, 1->1 | +1 when your boxer won it |
| Blocked share of misses (`BLOCK_SHARE` 0.60) | 0.75 | 0.45 |
| Wear of each block | +8%: pass `"posture": "high"` to `GuardWear.wear` (CODE, unused today) | no change |
| Chance your boxer is hurt when losing big (`RingDuel.settle` 385-386) | x0.7 | x1.3 |
| Head damage | only the leak | +2.0 for the extra clean punch (`Adaptation.HEAD_DAMAGE`'s size) |
- One count rule (Kalli point 4): the figure line reads "Lost 4-3 - 2 on the guard". Blocks made by High are shown as
  "on the guard", never as landed.
- DERIVED: High means about a quarter more blocks at 8% more wear each; with the leak rising as the guard falls, a boxer
  who covers for three rounds reaches the -2 / -4 of 2.3 about a round earlier. The probe sizes it.

## 3. Kalli's 10 points, one by one
| # | Kalli asks | Verdict | How, and the number it moves |
|---|---|---|---|
| 1 | Covering into the exchange edge before settle, and it holds | **TAKE - section 2** | `d` at LiveRound 222, before `settle` 287. Her -0.15 / -0.20 are restated in the sum's own unit (power points, 2.2). The setting lives beside Pace and Aim, not in ONE CHANGE: that slot is shared with the habit fix and lasts one round (`Adaptation.gd` 2-5, `CallButtons` 73), and "Gloves high" there already means head-against-body (1.7). |
| 2 | "Wrong against heavy hands" true for amateurs | **TAKE** | (a) Wear and leak x (0.5 + power / 110) in `GuardState.wear_through` (power 40 = x0.86, 80 = x1.23; power as `Attrs` 268 builds it). (b) While Hands is High, every 4 power or heavy punches blocked from an opponent of power 70+ add +1 to the referee's look (point 8). DERIVED: about +1 an exchange, so a boxer who shells against a heavy hitter is stopped around the end of round 2 or in round 3, amateur or pro. |
| 3 | Covering tires the puncher | **TAKE - 2.4** | `lv["opp_drain"]`. The opponent has no Pace (1.5), so the trigger is its game (pressing, loading up), not "Push". |
| 4 | One count rule | **TAKE - 2.5** | The winner stands; "Lost 4-3 - 2 on the guard"; BROKEN's punches read "through a broken guard". |
| 5 | Link the week to the guard | **TAKE four, REFUSE one** | Defence sets the block share: 0.50 + Defence / 500 replaces the flat 0.60 (`GuardState.blocked_of`). Defence and head movement grade High; Stamina and hand speed grade Loose (2.2). The Tie up step at Sharp (60, `MoveMastery` 26) passes `skilled` = true: +13 instead of +10 (CODE constant, 1.4); Signature +16 (ESTIMATE). The habit "drops the right after the jab" (`HabitFix.PUNISHED_BY` 17), unfixed and under half guard: 1 block an exchange lands on the head instead. REFUSE "neck work cuts the head leak": neck mornings already train Durability (`Attrs` 273), which is the chin the knockdown rule reads (`Attrs` 261, `Knockdowns` 26) - a second cut would count it twice. Each taken link gets one line on the Training tab through `GuardNotes.lines`. |
| 6 | Guard in the plan and in the Why | **TAKE** | Plan: the round row that already opens a round on a pace (`PlanFile.pace_for`, LiveRound 107) also carries Hands. The plan page rates it against the opponent's main game (`Exchanges.favourite` 312) with 2.2's sign: Beats it / Works / Walks into it. Why: the Hands swing is counted like the plan's (same dice without the edge, LiveRound 290) -> AGAINST YOU or YOUR PLAN reads "Hands High cost 3 exchanges; 14 on the guard, 4 got through" from `FightStats`' blocked / through (33-38). NEXT points at the Training line of point 5. Fight prep (`FilmNight.prep_rows` 89): heavy hands and guard habits as rows with "Write it". |
| 7 | "Through the guard" as an Aim, pro only | **TAKE** | A sixth entry in `PaceAim.AIMS` (7), offered only when the bout is pro: the opponent's guard wears x1.5, your boxer lands 1 fewer clean an exchange, the usual aim cost -1.5 (`AIM_COST` 20). It pays through 2.3: the opponent's guard under half is +2, under a quarter +4. |
| 8 | One referee gauge; drop the warning price and the duplicate; mark the source | **TAKE** | One gauge a boxer: the look 0-10 as the bar, the counts as pips under it (3 in a round, 4 in a bout: `Knockdowns` 7-8). One stop rule: after a count the existing stop chance (`REF_STOP` 15, line 55) is x (1 + look / 10); the look reaching 10 with no count stops it as "outclassed". The "+2 on a warning" price is CUT (no warnings in the game). "Let your hands go: -1 for each exchange won" is CUT (it was the base rule). England Boxing 10.3.2 is John's citation: **CHECK** before any screen quotes it. |
| 9 | Fix and cut | **BUILT in part, TAKE the rest** | The three lines: BUILT (1.6). The caption becomes "The opponent's hands are dropping: Aim Head, hands Loose" - it now names two buttons and is true (2.3). Delete `blocked_strikes` and the clinch's "stamina -10 / free exchange" (energy in a tie-up is `ClinchRest`'s, REFILL 11). `parry_chance` stays for the counter below. |
| 10 | The probe before any board | **TAKE - section 6** | |

### 3.1 What v5 took from John: kept, changed or cut
| v5 item | v6 |
|---|---|
| 3.1 BROKEN under 20%, pro only: 1 block in 3 lands | KEPT. It also takes 2.3's -4, so it now costs rounds. |
| 3.2 "Hands up" as the cover (opponent lands 1 fewer, yours 30% fewer, the counter, the look) | REPLACED by section 2. Kept from it: the counter off a blocked power punch (`parry_chance("cross", defence)` x 0.25, +1 landed for your boxer), only while Hands is High. |
| 3.3 the referee's look | KEPT, merged into one gauge (point 8). Fed by: lost 6-1 (+1), covered and landed 0-1 (+1), a count (+2), heavy hands on a High guard (point 2), an exchange won (-1), the corner (-2). |
| 3.4 a guard price on each call | KEPT for Tie up (halves that exchange's leak) and Go to the body (every 3 body shots take 5 off the opponent's next corner refill; Aim Body counts too). CHANGED: "Jab and move" passes `"moving": true` to `GuardWear.wear` (-5%, CODE, unused) instead of "blocks become misses"; "Hands up" and "Let your hands go" are the timed High and Loose. |
| 3.4 "+5 at the next corner" for Hands up (`hands_next`, CODE) | CUT once High exists: too small to change a pick (Kalli), and High already pays in the exchange. |
| 3.5 the opponent's power, "Heavy right hand" mix, the pro habit "goes to the arms when ahead" | KEPT, power factor widened (point 2). |
| Section 4, John's page items | KEPT, with Kalli's cut: guard by round only on hover and in the Why, not on the corner card. |

## 4. Does any setting win everything? (the depth claim, to be proven by section 6)
| Opponent | High | Normal | Loose | Best plan |
|---|---|---|---|---|
| Light presser (power under 50) | loses rounds (-3); little to fear | fine | +2, small risk | Loose or Normal |
| Heavy presser, fresh | loses rounds AND fills the look (point 2) | takes clean shots | hurt x1.3 | Normal, tie up, move; High only when hurt |
| Heavy presser over 6 rounds | early: drains 6 a round; switch when it tires | | late: +6 | High, then Loose |
| Loader (slugger) | +6 while the guard lasts; -2 / -4 once worn | | -8 | High in bursts, Tie up to refill |
| Counter-puncher | -2 | best | -6 | Normal; Aim "Through the guard" (pro) |
| Boxer at range, volume puncher | -7 | fine | +3 | Loose, watch the energy |
No column is best on every row, and two rows need a switch during the bout. NOT PROVEN until the probe.

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| 3D fight, corner bar | PACE and AIM buttons with hover | `CornerBar` 156-186, `PaceAim.pace_tip` / `aim_tip` | CODE TODAY |
| 3D fight, corner bar | HANDS: High / Normal / Loose, the chosen one gold; hover = what it buys and costs in the game on show now, and "Counts from the next exchange" | `HandsEdge.points`, `lv["hands"]` | TO BUILD |
| Fight night (words), shout bar | PACE row and its cost line | `ShoutBar._draw_drive` 86-95 | CODE TODAY |
| Fight night (words), shout bar | HANDS row and its one-line effect | same as above | TO BUILD |
| Shout bar, the eight calls | when, energy, grade, win shift | `Exchanges.CALLS` 69-94, `win_shift` 215 | CODE TODAY |
| Shout bar, the calls | "Hands up" = High for 30 s, "Let your hands go" = Loose for 30 s; guard prices of 3.1 | `HandsEdge` | TO BUILD |
| 3D fight HUD, guard arc | fill, hover number, "?" until scouted | `HudBars` 38, 252-253; `FightMeters.bars` 45-47 | CODE TODAY |
| 3D fight HUD | the state under the arc: WORN (-2), ARMS DROPPING (-4), BROKEN (pro) | `HandsEdge.worn`, `GuardWear.word` (342, unused) | TO BUILD |
| 3D fight, caption | "The hands are coming down - over the top!" | `HudBars._guard_call` 300-307 | CODE TODAY -> reword (point 9) |
| 3D fight / corner minute | the referee's gauge with count pips | `f["bout"]["look"]`, `m["counts"]` (`BoutNight` 276) | TO BUILD |
| Corner minute | "Guard down to N% (leaking / arms dropping): Hands up or a tie-up buys it back." | `CornerCard.guard_line` 107-110, `card` 76-77 | CODE TODAY -> reword: "costs N points an exchange: a tie-up buys 10 back, or take the hands off High" |
| Corner minute | the coach's Hands pick for next round, with the reason (the opponent's game in the last three exchanges, as `Exchanges.read` 410-431 already reads it) | `HandsEdge.points` over `read`'s game | TO BUILD |
| Corner minute, ONE CHANGE | Gloves high / Elbows in (head against body, one round) | `Adaptation.offers` 31-47; `CornerOverlay` 344 | CODE TODAY, unchanged. Wording: rename the tile "Protect the head" / "Protect the body" so "high" means one thing on screen |
| Result page, figures | Punches blocked, Got through the guard (in punches), Guard left at the last bell | `FightStats.rows` 66-76 | CODE TODAY |
| Result page, figures | exchange lines as "4-3 - 2 on the guard"; "through a broken guard" | `rec["guard"]["blocked"]` (`GuardState.after` 134) | TO BUILD |
| The Why | AGAINST YOU / YOUR PLAN / NEXT (ropes, counts, steps today) | `FightWhy` 96-110; `WhyCard` 21 | CODE TODAY, no guard line |
| The Why | "Hands High cost / won N exchanges; N on the guard, M got through"; NEXT -> the Training line | hands swing (as LiveRound 290), `FightStats` | TO BUILD |
| Plan page, round rows | the round's pace | `PlanFile.pace_for` (LiveRound 107) | CODE TODAY |
| Plan page, round rows | the round's Hands, rated Beats it / Works / Walks into it | `HandsEdge.points` x `Exchanges.favourite` | TO BUILD |
| Fight prep, WHAT YOUR PLAN SHOULD ANSWER | the filed claims with "Write it" | `FilmNight.prep_rows` 87-90; `FightPrep` 9 | CODE TODAY, no guard row |
| Fight prep | heavy hands -> "High fills the referee's look"; the guard habit -> its round | point 2, `OppFile.GUARD_NOTE` 66 | TO BUILD |
| Opponent file | three guard habits | `OppFile.GUARD_NOTE` 64-67 | CODE TODAY |
| Opponent file | "goes to the arms when ahead" (pro) | v5 3.5 | TO BUILD |
| Training tab (bout booked) | the ropes warning, the amateur note | `GuardNotes.lines` 29-34 | CODE TODAY |
| Training tab | "Defence 58: blocks 62 in 100 of what misses"; "High guard: OK (Defence 58, head movement 55)"; "Tie up Sharp: +13 in a tie-up" | point 5 | TO BUILD |
| Boxer page, attributes | shoulder endurance: "the guard wears N% slower" | V5 (`AttrBoard` 281-287) | CODE TODAY (V5) |
Not asked of the 3D fight: nothing. It shows the settled round; the hands' height on screen is FIGHTPLAYER2's work
(METHOD line), and this map adds no layer in `scripts/fight3d`.

## 6. The probe that must pass before any board (GUARDPROBE6)
- Tool: `tools/guard_probe6.gd`, built on `tools/guard_probe.gd`'s population and `_play` (whole bouts through the game's
  own BoutNight path; `tools/guard_onoff.gd` 3-8 reuses it the same way). Headless, through `godot_slot.py`. GUARDPROBE4
  played 2,400 bouts in about a minute, so this is cheap.
- Population, named in the output: at least 3 different boxers of ours (never one boxer for every cell; never two
  identical fighters), against FOUR opponent types, 3 different opponents each: **light presser** (Pressure fighter,
  power under 50), **heavy presser** (Pressure fighter or Slugger, power 75+), **counter-puncher**, **volume puncher**.
  Formats: **amateur 3 rounds, pro 4, pro 6**. 12 cells, 200 bouts a cell, seeds printed.
- Arms: CONTROL (today's rules: a static switch `HandsEdge.on = false`, like `GuardState.damage_on` 21), NORMAL all
  bout, HIGH all bout, LOOSE all bout, READ (High against loading up or own trouble, Loose against tiring or hurt, else
  Normal), ROPE (High until the opponent is under 45 energy, then Loose).
- Bars (bands, never exact counts):
  1. NORMAL is within 2 wins in 100 of CONTROL in every cell: the change does not move the base game.
  2. No fixed setting (HIGH, NORMAL, LOOSE) is best against all four types in any format.
  3. HIGH and LOOSE are each best of the three in at least one cell.
  4. Pro 6, heavy presser: ROPE beats NORMAL by 5+ wins in 100.
  5. Amateur 3, heavy presser: HIGH loses to NORMAL by 5+ wins in 100, and more of its losses are stoppages.
  6. READ beats every fixed setting in at least 8 of 12 cells: reading the fight pays.
  7. GUARDPROBE1's guard bands still hold on NORMAL (amateur round 3 in yellow with red rare, pro last round in
     orange), and amateur stoppages stay inside 5-12 in 100 (`Knockdowns.gd` 3-4).
- The instrument can read worse: a mutant arm with 2.2's table zeroed must FAIL bars 2-6.
- A bar that fails is fixed on the table of 2.2 or the sizes of 2.3-2.5, and the probe is run again. The result page
  `docs/GUARDPROBE6_RESULT.md` is the run's own printed lines.
- Cannot be run today: 12-round bouts (the game has none).

## 7. Rulings kept
- The 3D fight never decides: every rule here is in `LiveRound.exchange` before the ring draws it; the new edge is in
  `d` before `settle`.
- Names only in headers: every new string says "your boxer" / "the opponent" (as `Exchanges.roles` 107 does).
- Only actionable information: every new line names the button that answers it (the caption, the corner line, the
  Why's NEXT). The guard-by-round history is on hover only.
- Amateur and pro stay apart: amateur full guard 70, +15% wear, scale 0.28, never BROKEN, no "Through the guard" aim,
  no "goes to the arms"; and three rounds are too short for the rope trade (2.4), six are not.
- Every new mechanic wired, shown, 7+: section 5 is the wiring table; the build is done only when each row shows in
  the .exe and one golden-path test sets Hands, plays a round and reads the Why's hands line.
- Build order when approved: `HandsEdge.gd` + its unit test (a pure module: a cloud seat), the LiveRound line and the
  setting, GUARDPROBE6, then the screens of section 5. Regression: `tests/guard_wear_test.gd`, `tests/guard_contract_test.gd`.

## 8. Code files opened (this session)
Whole: `scripts/rules/Exchanges.gd`, `GuardWear.gd`, `GuardNotes.gd`, `CornerCard.gd`, `CornerJobs.gd` (no guard rule in it:
nothing to cite), `LineGrade.gd` (read only; no guard rule), `PaceAim.gd`, `Knockdowns.gd`, `scripts/state/GuardState.gd`.
In part: `scripts/state/LiveRound.gd` (100-142, 160-468), `RingDuel.gd` (300-398), `StepWire.gd` (150-190), `BoutNight.gd`
(225-342), `JudgeNight.gd` (1-80), `CrackWire.gd` (55-80); `scripts/rules/Adaptation.gd` (1-110), `BoutRules.gd` (395-425),
`Judges.gd` (1-40), `FightStats.gd` (1-80), `BoutBurn.gd` (1-14), `ClinchRest.gd` (1-30), `Attrs.gd` (260-268), `PlanFight.gd`
(44-58), `FightWhy.gd` (90-110), `FilmNight.gd` (84-92); `scripts/fight3d/HudBars.gd` (30-48, 200-212, 238-256, 286-310),
`CornerBar.gd` (150-186), `ShoutBar.gd` (84-96). By git grep only (the cited line): `OppFile.gd` 64-66, `HabitFix.gd` 17,
`MoveMastery.gd` 26, `CallButtons.gd` 73, `CornerOverlay.gd` 344, `FightCast.gd` 79, `WhyCard.gd` 21, `FightPrep.gd` 9,
`tools/guard_probe.gd`, `guard_onoff.gd`. Results read: `docs/GUARDPROBE1_RESULT.md` to `GUARDPROBE4_RESULT.md` (head and RESULT lines).
Not opened, so nothing of theirs is tagged CODE: `AttrBoard.gd`, `FightNight.gd`, `PlanFile.gd`, `Combos.gd`. The v1-v4 maps were
not used as evidence.
