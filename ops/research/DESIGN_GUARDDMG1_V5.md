# GUARDDMG1 V5 - guard damage, written from the code (S533, Fable console)

Brief: `ops/research/TASK_GUARDREV5.md`. Follows the verdict of `GUARDDMG1_V1_CRITIC_JOHN_S533.md` (6/5/6, "not designed
yet") and the owner's line on John's page (S533: "john has some nice ideas in his render").
Tags: **CODE** = I opened the file and the line is true on 2026-11-21 (main at 10fae9af7). **DERIVED** = my sums from CODE
numbers, not measured. **ESTIMATE** = a number to tune, not in the game. **CUT** = not in v5. No Godot was run.
Files opened are listed in section 7.

## 0. The short version
- The guard is built as a NUMBER that wears and leaks. It is not yet a CHOICE: nothing the player picks changes how many
  punches land on the guard. That is why John scored depth 6.
- Three things on screen today are not backed by the code (section 1.6). Fix those first.
- John's page needs four new pieces: a broken state, a referee's look, a guard price on each corner call, and the
  opponent's power in the leak. Everything else on his page is a new way to show numbers the fight already has.

## 1. What the game does today (CODE)

### 1.1 Where the guard lives
- Each side has a guard `{g, max, clinch, hands_next}` in `f["bout"]["guard"]`: `scripts/state/GuardState.gd` `open` (37-49).
- Full size: light 80 (limit up to 64 kg), middle 100 (up to 81 kg), heavy 120; ANY amateur 70.
  `GuardWear.max_guard` (268-275), `GuardState.wclass` (30-33).
- `LiveRound.open` calls `GuardState.open(f, n)` (LiveRound 119); every exchange calls `GuardState.after` (LiveRound 354).

### 1.2 How many punches land on the guard
- Blocks are NOT played punch by punch. They are worked out from the punches the other side landed:
  thrown = landed / 0.33 (`BoutBurn.LAND_RATE`, 8), and 60 in 100 of the ones that did not land were blocked
  (`GuardState.BLOCK_SHARE` 16, `blocked_of` 53-55).
- An exchange lands 4-3, 5-2 or 6-1 (`Exchanges.LANDED` 345, `settle` 356-361). DERIVED: landing 6 means 8 of that
  side's punches hit the other guard; 5 -> 7; 4 -> 5; 3 -> 4; 2 -> 3; 1 -> 2.
- So the guard of whoever LOSES exchanges wears faster. No call, pace or plan changes the blocked share.

### 1.3 Wear (guard points lost)
- A block costs 1 (jab), 3 (power) or 5 (heavy): `GuardWear.wear` (127-160), constants 26-28. The punch mix is the same
  for every boxer: jab 50, cross 25, lead hook 13, body hook 6, uppercut 6 (`BoutBurn.MIX` 9; `GuardState.KIND` 27).
- One block in four counts as the third punch of a combination, x1.5 (`GuardState.COMBO_SHARE` 22; `GuardWear` 133).
- What `GuardState.after` passes in (100-111): on the ropes +12%, amateur +15%, shoulder endurance (Stamina x 0.7 +
  Strength x 0.3; 65 = 12% slower, 80 = 20% slower, floor 25%: `GuardWear.shoulder` 181, `shoulder_wear_pct` 187-198),
  and the habit "slow starter" (12% slower in rounds 1-2, 12% faster after: `trait_wear_pct` 279-284).
- Then the whole thing is scaled: pro x0.40, amateur x0.28, sized by GUARDPROBE1 (`GuardState` 17-18, 66).
- DERIVED: a mean block costs a pro about 0.95 guard points and an amateur about 0.77; an even pro round costs about 29
  of 100 and the corner gives 15 back.
- In `GuardWear.wear` but passed by nobody: moving -5%, condition under 70 +10%, missed weight +18%, high posture +8%.

### 1.4 What gets through (the leak)
- Share of a blocked punch that gets through at a full guard: jab 25%, power 42.5%, heavy 55%; it rises on a slope to
  double at an empty guard; light class x0.9, heavy x1.3; third punch of a combination x1.5; never over 80%.
  `GuardWear.transmission` (100-117). (John's point 6, "a slope, not a step": built.)
- The leak is that share x the punch's worth (1 / 2.5 / 4) x 0.038: `GuardState.wear_through` (65-81), `BASE` 20,
  `K_THROUGH` 19. GUARDPROBE1 sized it at +7 to 11% of a bout's damage.
- It is added to `m["damage"]` (LiveRound 355-359). The only reader is the knockdown rule: `BoutNight` 254 ->
  `Knockdowns.round_counts` (20): head damage 60 doubles the chance of a count (`DAMAGE_SCALE` 12), and after a count the
  referee's stop chance rises with it (`REF_STOP` 15).
- The leak does NOT change who wins an exchange, the round or the cards. A worn guard does not make the next exchange
  harder: `GuardState` line 10 says so ("NOT YET: the guard's feedback on the exchange").
- The opponent's power is NOT in the leak or the wear. A light hitter and a heavy hitter leak the same.

### 1.5 Getting it back
- In the round: +3 (amateur +4) when the other side threw nothing, +1 for 1-2 thrown, else 0: `GuardWear.in_round`
  (219-224). The habits "fades late" (-25% after round 4) and "chases the stoppage" (-10%), and our morale under 40
  (-20%), cut it: `trait_recovery_pct` (289-297), `GuardState.after` 120-122.
- The corner: +15 every minute; +5 more if "Hands up, move your head" was called in the round
  (`GuardWear.corner` 241-257; `GuardState.open` 43-48; `after` 132-133). The cutman +5 and "back off" +20 exist in
  `corner` and are passed by nobody (`open` passes false, false).
- The tie-up: the call "Tie up" gives +10 guard, once a round, only under half guard (`GuardWear.clinch` 228-236;
  `GuardState.after` 127-131). The call itself gives 2 energy back an exchange (`Exchanges.CALLS` tie, 88: cost -2.0).

### 1.6 Three lines on screen the code does not back (fix first)
| On screen | Where | The code |
|---|---|---|
| "Amateur guard: ... a quiet exchange gives back 4 (pro 3)" | `GuardNotes.amateur_note` (21-25), shown on the Training tab | DERIVED: it almost never happens. One landed punch already means 4 thrown (1 / 0.33), which gives 0 back; the "+1 for 1-2 thrown" branch cannot happen at all. Guard comes back in the round only when the other side lands nothing. |
| "Hands up, move your head ... your boxer throws less" | `Exchanges.CALLS` hands, `expect` (80), the call's hover | Nothing lowers our punches for this call. Only the pace does (`LiveRound` 297, `PaceAim.output`). |
| "Guard: how high the hands stay. It sinks as the shoulders tire." | `HudBars.WORDS` guard (38), the 3D bar's hover | Since S524 the bar is also the worn guard (`FightMeters.bars` 45-47, `HudBars` 252-253). The hover never mentions blocked punches. |

Also unused: `GuardWear.parry_chance` (302), `posture_damage` (202), `blocked_strikes` (321), `word` (342), and the
clinch's "stamina -10" and "free exchange" (236; `GuardState.after` reads only `ok` and `guard`). No caller in `scripts/`.
`scripts/fight3d/BarGuard.gd` is NOT the guard bar: it is the camera rule that keeps the boots above the HUD bar.

### 1.7 Where the player sees it today
| Screen | What it shows | CODE |
|---|---|---|
| 3D fight, each boxer's rings | a guard arc, 0-100 on hover; the opponent's shows "?" until a habit was found on tape | `HudBars` 32-46, 241-253, 291-296; `FightMeters.bars` 45-54, `guard_known` 88 |
| 3D fight, caption | "Corner: The hands are coming down - over the top!" once a round when the opponent's scouted guard is under 55% | `HudBars._guard_call` 300-307 |
| Fight night, between rounds | "Guard down to N% (leaking / arms dropping): Hands up or a tie-up buys it back." with a state icon, only under half | `CornerCard.guard_line` 107-110, `card` 76-77; `FightNight` 213, 228-238 |
| Corner calls | each call: when to use it, energy pips, and on hover what to expect and the grade | `CallButtons` 126-146; `Exchanges.CALLS` 69-94 |
| Result page, figures | "Punches blocked", "Got through the guard (in punches)", "Guard left at the last bell" | `FightStats.of` 33-38, `rows` 66-76; `MatchStats` 65; `ResultTabs` 201 |
| Opponent file | the habit and what it does to the guard ("guard holds early, wears faster from round 3") | `OppFile.GUARD_NOTE` 66-67, line 91 |
| Training tab, with a bout booked | the ropes warning against a presser or a loader; the amateur note | `GuardNotes` 15-33; `ClubWeek` 103; `TrainSide` 186 |
| Boxer page, attributes | "the guard wears N% slower when blocking" | `AttrBoard` 281-287 |

## 2. John's 11 points, one by one
| # | John asks | Verdict | Detail |
|---|---|---|---|
| 1 | Settle "blocked punches score or not" | BUILT, one leftover | Blocks never score: an exchange is settled before blocks exist (`Exchanges.settle` 356). Leftover: delete `GuardWear.blocked_strikes` (321), which says the opposite and has no caller. His "a broken guard lets punches land" is TAKEN in section 3.1. |
| 2 | Re-pace the guard | BUILT another way | Sized by GUARDPROBE1 instead of his 0.5 / 1.5 / 2.5: amateur round 3 in yellow with red rare, pro round 6 in orange (`GuardState` 17-18). His test "a pro who covers lasts 12 rounds" cannot be run: the game has no cover choice and no 12-round bout yet. Re-measure after section 3. |
| 3 | Give covering a price | TAKE | There is no covering today (1.2). Section 3.2 makes "Hands up" a real cover with a price; section 3.3 adds the referee's look. |
| 4 | Make blocking active (a counter off a block; the puncher pays for a blocked punch) | TAKE the counter, REFUSE the puncher's cost | Counter: section 3.2, from the unused `parry_chance`. Puncher's cost: energy is charged by call and pace, not by punch (`RingDuel.settle`), so it would be a second energy model. |
| 5 | "Go to the arms" pro only; add "Body first" and "Clinch and reset" | TAKE as habits and prices, no new buttons | The eight calls stay (`Exchanges.CALLS`). "Clinch and reset" is "Tie up"; "Body first" is "Go to the body"; each gets a guard price (3.4). "Go to the arms" becomes an opponent habit, pro only (3.5). |
| 6 | A slope, not a step, for the worn guard | BUILT | `GuardWear.transmission` 109. The four colours are only how it is drawn (`colour` 328). |
| 7 | "Step off" needs its own cost | BUILT | Ground is already a cost: losing an exchange to a presser or a loader puts your boxer on the ropes (`PlanFight.LOST_CARD` 26), where a block wears 12% more (`GuardState.after` 101). No second "move" call. |
| 8 | Cut GLOVES | BUILT | No glove term in `GuardWear` or `GuardState`. |
| 9 | One endurance stat; wire "Gloves high" / "Elbows in" | BUILT / REFUSE | One stat: shoulder endurance (`GuardWear.shoulder` 181; `AttrBoard` 281). Posture: `posture_damage` stays unused: it is a second cover choice with the same shape as 3.2. |
| 10 | "his guard" -> "the opponent's guard" | BUILT | The strings say "your boxer" / "the opponent" (`GuardNotes` 18, `CornerCard` 110, `Exchanges.roles` 107). |
| 11 | Label every share number as tuning | BUILT | Every constant in `GuardWear` 13-95 is tagged ESTIMATE; three are sized by a probe (`GuardState` 17-19). |

## 3. What v5 adds (TO BUILD; every number ESTIMATE until a probe sizes it)
Each rule names the number the round ALREADY uses that it changes. The 3D fight still only shows the settled round.

### 3.1 The broken guard (John's page: the cracked bar, BROKEN)
- Under 20% of full the guard is BROKEN. One block in three then lands instead: it is added to the other side's landed
  count for the exchange (`s["landed"]`, the number `FightStats` and the knockdown rule read) at full worth, not the leak.
- Pro only. An amateur guard goes no lower than WORN (John: "worn is the amateur effect, broken the pro one").
- It does not change who won the exchange (`settle` ran first): the round is still the exchanges.

### 3.2 Covering becomes a choice: "Hands up, move your head"
| While the call holds | Changes this number | Today |
|---|---|---|
| The opponent lands 1 fewer; that punch is blocked instead | `s["landed"][1]`, then `GuardState.blocked_of` | fixed by the band |
| Your boxer lands 30% fewer (John: "offense will be greatly affected") | `s["landed"][0]`, as the pace does at `LiveRound` 297 | not cut (1.6) |
| A blocked power punch opens a counter: chance `GuardWear.parry_chance("cross", defence)` x 0.25, +1 landed for your boxer | `s["landed"][0]` | unused rule |
| The referee's look +1 if your boxer lands 1 or 0 | 3.3 | none |
- RIGHT against a light hitter: the leak is small, the guard lasts, the round is won on fewer clean punches taken.
- WRONG against heavy hands: see 3.5 - the leak and the wear both grow with the opponent's power, the guard is broken
  by the middle rounds and the look fills.

### 3.3 The referee's look (John's page: the gauge)
- A gauge 0-10 per boxer, in `f["bout"]`. +1 for an exchange lost 6-1; +1 for an exchange covered with 1 or 0 landed;
  +2 for a count; -1 for an exchange won. Carries over rounds, -2 in the corner.
- At 10 the referee stops it: the existing stoppage screen ("REFEREE STOPS IT", `FightNight` 209), no new ending.
  It replaces nothing in `Knockdowns`; it is the England Boxing 10.3.2 "outclassed" stop John sourced.
- This is the price that stops covering from being the answer to everything.

### 3.4 Every corner call shows its guard price (John's page: the four priced buttons)
No dominant call: each is best in one state and costs in another. Energy and the exchange edge are CODE; the guard
column is what v5 adds or already does.
| Call (`Exchanges.CALLS`) | Energy an exchange (CODE) | Guard (today -> v5) | The look (v5) | Wrong when |
|---|---|---|---|---|
| Tie up ("Clinch and reset") | gives 2 back | +10 once a round under half (CODE) -> also halves this exchange's leak | +2 on a warning, 1 in 8 | the guard is over half: nothing back |
| Hands up, move your head | 0 | +5 at the next corner (CODE) -> the cover of 3.2 | +1 if nothing comes back | against heavy hands |
| Jab and move ("Move, don't cover") | gives 0.5 back | none -> half the blocks become misses | 0 | on the ropes or tired (under 35 energy): the opponent lands 1 more |
| Let your hands go ("Fire back") | costs 3 | none | -1 for each exchange won | tired: the tank pays |
| Go to the body ("Body first") | costs 1.5 | none -> every 3 body shots landed take 5 off the opponent's next corner refill | 0 | the opponent is loading up (CODE: the "wrong" call there, `Exchanges.MODES` 129) |
The other three calls (Draw the lead, Breathe, Go for the finish) keep their prices and get no guard line.

### 3.5 The opponent's hands
- The leak and the wear are multiplied by the opponent's power: x (0.7 + power / 180) (ESTIMATE: power 40 = x0.92,
  55 = x1.0, 80 = x1.14), in `GuardState.wear_through`. Today every opponent hits the guard the same (1.4).
- An opponent whose file says "Heavy right hand" (`OppFile` 37-38 already keys on it) throws more heavy punches at the
  guard: the uppercut share of `BoutBurn.MIX` 6 -> 15 for the blocks only.
- New opponent habit, pro only: "goes to the arms when ahead". When ahead on rounds, 1 of the opponent's landed
  punches an exchange is thrown at the guard instead. Found on tape like the other three guard habits
  (`GuardState.GUARD_HABITS` 26; `OppFile.GUARD_NOTE` 66).

### 3.6 Fix with it
The three lines of 1.6; delete `blocked_strikes`; either wire or delete the clinch's "stamina -10 / free exchange".

## 4. John's page, item by item
| On his page | Does fight night show it today? | v5 |
|---|---|---|
| Guard bar cracked and grey with a red BROKEN tag | No. An arc with no state (`HudBars`), an icon between rounds (`FightNight` 238) | TAKE with 3.1 |
| Guard by round: 100, 96, 88, 74 ... | No. The round keeps it (`LiveRound` 446 `"guard"`) and nothing draws it | TAKE: a row under the bar, from the rounds already saved |
| One line under the bar saying what the state means | No. `GuardWear.word` (342) has four words and no caller | TAKE: "A blocked jab lets N% through, a big shot N%", read from `transmission` at today's guard; with 3.1 "1 in 3 lands clean" |
| Coach note saying WHY: "the opponent has gone to the arms since round 4: 112 on the guard" | Partly: "Guard down to N% ...: Hands up or a tie-up buys it back" (`CornerCard.guard_line`), no cause | TAKE: the cause is the largest of ropes / exchanges lost / the habit of 3.5, with the round's blocked count (`rec["guard"]["blocked"]`, `GuardState.after` 134) |
| Landed: Head / Body / On the guard (N got through) | Only on the result page (`FightStats.rows` 62-72). Not during the bout | TAKE: the same three numbers on the corner minute |
| Timed strip: "1:15 big right hand on the guard - 1:14 guard under 20" | No. `FightLog.lines` (32) lists punches for the analysis page, no guard events | TAKE at the exchange's own clock (30 s steps): crossed half, crossed 20%, tie-up used. No invented seconds |
| Four corner calls, each with its price | Energy pips and the hover only (`CallButtons` 126-146). No guard price | TAKE: 3.4's guard and look columns on each tile |
| "From the tape: heavy hands - goes to the arms when ahead" under the calls | Only on the opponent file (`OppFile` 91) | TAKE: one line, only what the tape found |
| "One call. It lasts until the bell." | Not true today: the plan holds the round, and a shout changes one exchange (two are heard in full: `Exchanges.FULL_SHOUTS` 47, `uptake` 249) | REFUSE the words; say "The plan holds to the bell. A shout changes the next 30 seconds." |
| The referee's look gauge | No such rule | TAKE: 3.3 |
| "Next big shot on the guard: hurt 1 in 6" | No | TAKE as "A count this round: about 1 in N", read from `Knockdowns.round_counts` with the damage so far; never a made-up figure |
| A "Why?" link | No on fight night | TAKE: opens the hover card with the round's guard rows (Tip.gd), not a new page |
| Bars coloured only when at risk | Half: head, body and legs are ivory until hurt; stamina, guard and heart are always the corner's colour (`HudArc.colour` 79-84) | TAKE for the guard: corner colour until under half |

## 5. Every menu the mechanic appears on
| Menu | Shows | Wired to | Status |
|---|---|---|---|
| 3D fight HUD, guard arc | fill; hover number | `GuardState.share` -> `HudBars` 252 -> `FightMeters.bars` | CODE TODAY (hover words stale, 1.6) |
| 3D fight HUD, BROKEN tag, guard by round, state line | 3.1, section 4 | `GuardState`, `GuardWear.transmission` | TO BUILD |
| 3D fight, the referee's look | gauge 0-10 | new `f["bout"]["look"]` | TO BUILD |
| Corner minute (FightNight) | the guard line and icon | `CornerCard.guard_line` | CODE TODAY |
| Corner minute | the cause, on-the-guard counts, the event strip, the tape line | `rec["guard"]`, `OppFile.GUARD_NOTE` | TO BUILD |
| Corner calls and shout bar | when, energy, grade | `Exchanges.CALLS`, `CallButtons` | CODE TODAY |
| Corner calls and shout bar | guard price and look price | 3.4 | TO BUILD |
| Result page, figures | blocked, got through, guard left | `FightStats.rows` | CODE TODAY |
| Opponent file | three guard habits | `OppFile.GUARD_NOTE` | CODE TODAY |
| Opponent file | "goes to the arms when ahead", heavy hands and the guard | 3.5 | TO BUILD |
| Training tab (bout booked) | ropes warning, amateur note | `GuardNotes` | CODE TODAY (the amateur note is wrong, 1.6) |
| Boxer page, attributes | shoulder endurance | `AttrBoard` 281-287 | CODE TODAY |

## 6. Rulings kept, and the depth claim
- The 3D fight never decides: every v5 rule changes `s["landed"]`, the guard or the look inside `LiveRound` before the
  ring draws it.
- Names only in headers; every string says "your boxer" / "the opponent".
- Only what the player can act on: each new line ends in a call that answers it (the cause -> the call; the tape line ->
  the plan). The event strip shows only state changes, not every punch.
- Every number on screen is read from the rule (the state line from `transmission`, the count chance from `Knockdowns`).
- Amateur and pro stay apart: amateur full guard 70, +15% wear, scale 0.28, never BROKEN, no "goes to the arms".
- DEPTH: covering is right against a light hitter and wrong against heavy hands (3.2 + 3.5). No dominant call: each of
  the five has a state where it is wrong (3.4). Each call changes a number the round already uses (named in 3.2-3.4).
- NOT PROVEN: none of the v5 numbers is measured. Before any board: a probe on a named population (different boxers,
  a light and a heavy opponent, amateur 3 rounds and pro 4+), with today's rules as the control arm, must show covering
  wins against the light hitter and loses against the heavy one, and that no call wins every state.

## 7. Code files opened
`scripts/rules/GuardWear.gd`, `GuardNotes.gd`, `Exchanges.gd`, `CornerCard.gd`, `CornerJobs.gd`, `FightStats.gd`,
`FightMeters.gd`, `OppFile.gd`, `Knockdowns.gd`, `BoutBurn.gd`, `ClinchRest.gd`, `PaceAim.gd`, `FightLog.gd`,
`PlanFight.gd` (line 26); `scripts/state/GuardState.gd`, `LiveRound.gd`, `BoutNight.gd` (250-275), `ClubWeek.gd` (103),
`RingDuel.gd` (`settle`, the energy lines; this file has another session's uncommitted edits, so I cite the function,
not line numbers); `scripts/fight3d/BarGuard.gd`, `HudBars.gd`, `HudArc.gd` (79-84), `CornerBar.gd` (head);
`scripts/ui/modals/FightNight.gd`, `CallButtons.gd`, `AttrBoard.gd`, `TrainSide.gd`, `MatchStats.gd`, `ResultTabs.gd`.
`CornerJobs.gd` was read whole and has no guard rule (nothing to cite). The v1-v4 maps were not used as evidence.
