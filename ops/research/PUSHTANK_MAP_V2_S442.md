# PUSHTANK map v2 (S442): HANDS spend WIND, FEET spend LEGS, both protect the HEAD

Status: DESIGN, not built. v1 (`PUSHTANK_MAP_S442.md`) stays as the record; its critics: systems designer depth 4 / play 5
(`PUSHTANK_CRITIC_A_S442.md`), boxing coach 6 / 6 (`PUSHTANK_CRITIC_B_S442.md`). Every number is CODE (file:line) or NEW
(with the reason). Drawing: `docs/mockups/s442/pushtank/fight_bars_v2.png` (generator `build_pushtank_v2.py`).

## 1. What it is for
His words: "I am thinking of adding 2 bars next to the fighter in the fight, one bar is switched on or off representing the
pushing aggression against the cost shown on the tank (other bar) which drains or regens according to the tactic."
Then: "I want to see bars feeling similar to the motor style race, where you control the tires and the fuel, something like
that inside our fight maybe." Then: "Need ideas to add more meters affected by like stamina to make it a bit more engaging
for the player ?"

**The one running decision:** which tank to spend tonight, and against whom. HANDS (Coast / Steady / Push) spends WIND;
FEET (Press / Hold / Move) spends LEGS and picks where the fight is fought; both protect the HEAD, which never comes back.
Set in the corner minute for free (the pit stop); a change in the round is one of the two shouts that land in full.

## 2. The critics' code claims, checked
| Claim | Verdict | Code |
|---|---|---|
| Push extra is never refilled; ordinary spend gets ~31% back in the minute | TRUE | `RingDuel.gd:340-341` after `BoutNight.gd:319`; `Combos.gd:35-38`, `:266-276` |
| The exploit is Save's flat +6, not the third step | TRUE: with `SAVE_RECOVER` 0, "Push five, Save one" costs 5 x 1.75 - 2 = 6.75 a round | `PaceAim.gd:13`, `:51-54` |
| Push greys the opponent's bar 0.24 an exchange (0.6 with Body aim), too little to see | TRUE (about 1 extra landed x 0.2 body x 1.2) | `Exchanges.gd:37-40`, `:307`; `LiveRound.gd:304`, `:316-321` |
| Push is worth 0 at 40, not at 55 or 35 | TRUE: 6 - 12 x (55 - 40) / 30 = 0 | `PaceAim.gd:182-190` |
| Case 4 wrong: being hurt needs a margin under -30, so Push LOWERS the chance | TRUE | `RingDuel.gd:349-350`; `Exchanges.gd:53-54` |
| Case 6: body greying is one number, the order does not matter | TRUE (`her_energy` subtracts body x cost every exchange) | `RingDuel.gd:304-307` |
| Case 9 wrong (Off in rounds 1-2 throws away 12 exchanges; a 3-rounder needs two rounds) | TRUE | `BoutRules.gd:371` (rounds won) |
| Case 7 is the talk, not the switch | TRUE: nothing links pace to temper | `CornerJobs.gd:105-121` |
| Under 35, Breathe is the best call (+17): running dry hands over an easy answer | TRUE | `Exchanges.gd:110`, `:18`, `:171-177` |
| AIM "Head" is strictly worse than Own game | TRUE: -1.5 for a body share of 0.08, no damage bonus | `PaceAim.gd:15`, `:19`, `:61-69` |
| AIM "Body" duplicates the "Go to the body" call | TRUE: both put half the punches to the body | `PaceAim.gd:15`; `Exchanges.gd:38`; `LiveRound.gd:317` |
| Head damage: close 8 / clear 18 / dominant 32 to the round's loser, 2 to the winner; 60 doubles the count chance and opens the KO | TRUE | `Knockdowns.gd:12-17`, `:30-34`, `:55-57` |
| Clear the head only removes the hurt flag | TRUE | `CornerJobs.gd:52-62` |
| A coasted LOST round costs head (bigger margin band) | TRUE: the round's band sets the damage | `Knockdowns.gd:13`, `:30-31` |
| Legs: "the legs went" (BodyReport) | PARTLY: BodyReport reads BodyLoad, which only the 3D view feeds; a headless bout has no legs at all | `BodyReport.gd:16`; `BodyLoad.gd:25-40`; `BodyBurn.gd:1-9` |
| The opponent never pushes or coasts | TRUE for hands; their FEET already exist as their game (press -> inside, range -> long, counter / load up -> pocket) | `BoutNight.gd:320`; `RingDuel.gd:25` |

## 3. The machine

### 3.1 HANDS (Coast / Steady / Push) spends WIND (today's tank)
- Push: +6 an exchange, landed x1.25, wind drain x1.35, fading under 55 to 0 at 40 and -6 at 25 (CODE `PaceAim.gd:10-12`, `:182-190`).
- Steady: today's play (CODE).
- Coast: -4, landed x0.75, drain x0.6 (CODE) and NO flat refill (NEW: `SAVE_RECOVER` 0, the exploit's cause). Coasting saves
  2 an exchange; it is for a round already settled (4-0 or 0-4 cannot change, `Exchanges.round_of`), and a coasted LOST round
  costs head (its band moves toward dominant: 18 -> 32, `Knockdowns.gd:13`).
- WIND refills: the minute (52% of the fast debt x Recovery 0.8-1.2, CODE) plus the second's water (+3 a point, +6 under 40,
  CODE); in the round only by the quiet calls (Breathe +3, Tie up +2, Jab and move / Draw the lead +0.5: CODE costs).
- The burst: "Let your hands go" / "Go for the finish" (3.0 an exchange, CODE) and the set-up NOW stay calls.

### 3.2 FEET (Press / Hold / Move) spends LEGS and picks the place
Anchored in the ring ladder (CODE `Duels.gd:9-13`, `:318-386`): each side wants a place (long, pocket, inside), steering is a
contest of footwork and foot speed, and a side kept inside while wanting out for 2 exchanges is on the ropes (pinned: its
steering pays `ROPES` 8 x (1.3 - composure / 100)).
- Hold: today's play: the fighter's own choice of place (`Duels.wants`, ring IQ finds the best place). Legs x0.7 (plants).
- Press: wants one place closer than now, with the forward urge's close bonus (`FORWARD_CLOSE` 0.55 a point, CODE) as if the
  dial were 75 (NEW); legs x1.5; the pressed side's legs x1.3 (CODE size: `BodyLoad.SIT_LEGS` press 1.3).
- Move: wants long (as "Jab and move" does: `RingDuel.CALL_PLACE`, CODE); legs x1.0; the opponent pressing pays its x1.3.
- A call that names a place (Jab and move, Draw the lead, Go to the body, Tie up) overrides FEET for that exchange (CODE).

**What LEGS needs to be a resource the result reads (NEW rules, sized from BodyLoad's own constants):**
1. LEGS per side, 0-100, 100 at the first bell less half the weight cut's drain (NEW; `BoutRules.tank_parts` weight, CODE).
2. Spent each exchange in LiveRound (headless too): base 2.0 (NEW: BodyLoad's 4.8 an exchange, `LEGS_PER_S` 0.16 x 30, runs a
   resource dry in 3 rounds) x FEET (above) x the wind link 1 + 0.5 x (1 - wind / 100) (CODE `BodyLoad.TANK_MULT` 0.5) x the
   fitness factor 1.2 - 0.4 x mean(Stamina, Footwork) / 100 (NEW, the shape of `Combos.spend_factor`). Inside the feet half
   stop: x0.5 (CODE `BodyLoad.INSIDE_LEGS`).
3. Body shots taken: 1.2 off wind now (CODE) and 0.6 off legs over the next round (NEW: the late part of a body shot).
4. The minute gives back 20% of the round's legs spend (NEW; BodyLoad's `REST_BACK` 0.55 is for shoulders and arms: a corner
   gets breath back, not legs).
5. `Duels.effective` reads LEGS for the legs side of the fade (guard, head movement, footwork, foot speed: `TIRED_LEGS` 12) and
   keeps WIND for the hands side (hand speed, power, accuracy: `TIRED_SNAP` 6) (CODE split, NEW source). The legs fade is a
   cliff: t = clamp((50 - legs) / 30, 0, 1) (NEW; full at 20).
6. Under 30, Press acts as Hold: a flat-footed fighter cannot step in (NEW).
Sized for: always Press with Push from the first bell reaches the 30 line in the second half of round 3; always Hold ends
near 70; Move near 60 (NEW, ESTIMATE; the probe measures it).

### 3.3 HEAD: no control, the wear both trades protect
- Today: added once a round, by the round's band, to its loser (CODE `Knockdowns.gd:13-14`, read in `BoutNight.gd:242-250`).
  60 doubles the count chance and opens the KO (CODE); after the bout the injury roll and the no-sparring days read it
  (CODE `InjuryRoll.gd:25-35`, `StandDown.gd:2-45`).
- NEW: settled per exchange so it moves live: the exchange's loser takes its band's round damage / 6, the winner 2 / 6. Same
  scale over a round. A landed set-up (30) and a landed Read stay as today (CODE).
- NEW links: head damage taken x1.2 under 35 wind (hands drop) and x1.3 under 30 legs (planted, can't roll). Both small; the
  big link is already in the code: a tired fighter loses more exchanges by more, and the band is the damage.
- The minute gives NONE back (see 6, decision changed).

### 3.4 Running dry must hurt (decision 5)
NEW: under 35 wind the exchange is no longer replaced by "Your fighter is tired". The opponent's game stays in force for the
calls (the clue shows it); Breathe is an OK-sized answer everywhere under 35 (+5, refills 3) and never the +17 best; the hands
fade (CODE) and the head link (NEW) both apply. Gassed now means: worse at everything, and still facing the opponent's game.

### 3.5 The opponent
- FEET: their game already decides their place (CODE `RingDuel.MODE_PLACE`); legs are spent by the same rule.
- HANDS (NEW): a corner per style and score: Swarmer / Volume puncher Push rounds 1-2, a Counter-puncher Coasts when ahead, a
  fader Coasts round 2; anyone behind in the last round Pushes. Seen only as tells in the clue line ("Ortega's corner has
  Ortega pushing") and on film; wind and legs shown as ranges (today's widths: 16 unscouted, 6 on film, `SidePanel.gd:19-20`),
  head exact (we see what we landed).

### 3.6 When (decision 4)
- The corner minute: HANDS and FEET set for the next round, free. This is the first build, not the second.
- In the round: a change is a shout: it takes one of the two that land in full (CODE `Exchanges.FULL_SHOUTS`), and goes through
  trust (CODE `CornerTrust.lands`: a fighter who stopped listening keeps the minute's setting). Today pace is free and unlimited
  (`CornerBar.gd:108-130`): that goes.
- The minute's three recover points (CODE): water (wind), ice (body hits back), clear the head (the hurt flag).

## 4. The running trade
| Spend | When it is right | Why (code) |
|---|---|---|
| WIND, save LEGS (Push + Hold) | against a mover; in a pocket war with the better chin | the mover makes Press cost legs and win nothing at range; Hold plants (x0.7) |
| LEGS, save WIND (Steady + Move) | against a body puncher; ahead late | body shots take wind now: stay out of the pocket; legs are worth nothing after the bell |
| Both (Push + Press) | the round that decides it; a hurt opponent | the pinned side pays ROPES 8; +6 and the finish stack |
| Neither (Coast + Hold) | a round already settled, head low | 2 wind an exchange back; costs head if the round is lost |

## 5. The cases (fixed and added)
| # | Case | HANDS + FEET | Why |
|---|---|---|---|
| 1 | Ahead 2-0 into round 3 | Steady + Move | Coasting lowers our margin and a lost dominant round adds 32 head; legs are the free currency now; amateur judges' ring lean credits a kept place (R29 spec) |
| 2 | Behind 0-2 into round 3 | Push + Press, finish calls | Two rounds down cannot be won on rounds (`BoutRules.cards_of`): only counts or a stoppage; spend everything |
| 3 | Level 1-1 into round 3 | Push + Press to the 40 line, then Steady + Hold | Push is worth 0 at 40 (CODE); legs carry the last minute |
| 4 | Opponent hurt | Push + Press, "Go for the finish" | Pinned and hurt; only if wind is above 40, or the flurry is worth nothing |
| 5 | Our fighter hurt | Push (above 40) + Move, "Tie up" when caught | Push keeps the margin above -30, where the hurt roll lives (CODE); Move gets off the ropes before the pin |
| 6 | Body puncher | Steady + Move | Spend legs, not wind: every body shot inside costs 1.2 wind now and 0.6 legs later |
| 7 | A mover (Out-boxer) | Push + Hold | Spend wind and hold the centre; pressing a mover burns legs for nothing at range |
| 8 | Opponent's wind lower (film) | Steady + Press | Make their legs work (x1.3) while their low wind wears them faster (x1 + 0.5 x (1 - wind)): gone legs, then the ropes |
| 9 | Slow starter | Push + Press all of round 1 | +3 more in the first two exchanges (CODE `COLD_EDGE`); round 1's push never reaches 40 |
| 10 | Fader | Steady + Hold rounds 1-2 with "Go to the body", then Push + Press | Win two rounds first; body work takes wind now and legs later; then spend into the fade |
| 11 | Short fuse, just hit hard | (the minute) Steady + Hold, talk "Calm down" | It is the talk: Calm down +1 for a short fuse, Fire up -2 and hurt x1.6 (CODE) |
| 12 | Drained by the weight cut | Steady + Move, Push only in the round that decides | Up to 25 off the wind at the first bell (CODE `BoutRules.gd:41-44`), half that off the legs (NEW) |
| 13 | Steal the last 30 seconds | Push for the last exchange only (one shout) | A 3-3 round goes to the bigger total margin (CODE `Exchanges.round_of`); 2-3 down, the last exchange is the round |
| 14 | Pinned on the ropes | Steady + Move while legs are above 30; under it "Tie up" | Steering off the ropes costs ROPES 8 (CODE); under 30 the feet cannot do it (NEW) |
| 15 | A round already lost (0-4, two left) | Coast + Move if head is under 40; Steady + Hold if head is near 60 | Coasting banks wind but a dominant loss adds 32 head instead of 18 |
| 16 | Two pushers, a war | Push + Hold with the better Stamina and chin; else Steady + Move | Both burn wind x1.35; the one who reaches 40 first loses the exchanges and then the head |
| 17 | 6-round pro, round 4 | Steady + Hold; Push only in close rounds | Wind refills, legs barely: Press early costs the last two rounds |

**Habits the probe must beat:** "Push while wind is above 45", "Push above 55", "always Press", "always Move", "always Hold"
(today), "Push + Press always", "Steady + Hold always".

**The probe before any screen (PUSHPROBE2), through the game's real bout, 3 rounds and 6 rounds, 400 paired bouts a cell, two
different fighters each side:** arm A today; arm B v1's switch (on / off, Save into Breathe); arm C HANDS only (Coast without
the flat refill, changes as shouts); arm D HANDS + FEET + HEAD (all of section 3). Cells: the 17 cases as starting states.
PASS: no named habit is best in more than 6 cells of 10; a coach who reads the fight (the case table) beats every habit by 3
points; "Push five, Save one" is gone in C and D. Log per policy: rest days (`Aftermath.toll`) and head at the last bell.

## 6. Coordinator decisions changed, and why
- **Decision 4, "what a recover point takes off the head": changed to nothing.** In the code head damage is the input of the
  injury roll and the no-sparring days (`InjuryRoll`, `StandDown`); a minute that takes it back would cut that link and make
  the head another fuel. In boxing the minute never gives back the chin's damage. The head's pit job stays "clear the head"
  (the hurt flag, CODE). This keeps HEAD as the only thing nothing refills: the engine wear.
- **Decision 1, FEET "spends LEGS" from BodyReport's legs: the code has no legs in the result.** BodyLoad's legs exist only
  when the 3D view feeds them; LEGS is a new resource (3.2, six NEW rules), not a wiring job.
- **Decision 1, HOLD: defined as today's play** (the fighter's own place) so arm D with Hold everywhere is the control arm.
- **Decision 6, the opponent's FEET: already exists** (their game sets their place). Only their HANDS is new.
- **AIM is cut from the screen**: Head is strictly worse (CODE), Body duplicates the call. The hurt-place aims (left ribs,
  right ribs, the hurt head: +4, x1.3, CODE) appear as call buttons only when a place is hurt.

## 7. Branches
| Branch | Link | When |
|---|---|---|
| Training | Wind: Stamina (roadwork, intervals) and Recovery (rest), CODE. Legs: Stamina and Footwork (shadow trains footwork, `Attrs.SESSION_ATTRS`, CODE) through the NEW legs factor; a skipping / hills morning LATER | First build (maths); the Week's words later |
| Weight cut | Wind off at the first bell, CODE; half of it off legs, NEW | First build |
| Plan before the fight | ROUND row: HANDS and FEET per round (`PlanFile`, `GamePlanRows.gd`); PlanPhase's if ahead / if behind wired for the last round (`PlanPhase.gd:103-109`, built, unused) | ROUND row first; PlanPhase second |
| Corner minute | The pit stop: set both, see wind refill, legs barely, head none | First build |
| Judges, amateur (R29 leans clean / ring / initiative) | Push lands more (clean); Press wins forward exchanges (initiative) and the wanted place (ring); Move wins ring when the long place is kept | When the Judges module is wired |
| Judges, pro (work) | Push counts as work | Same |
| Traits | Heart: a second wind once a fight under 35 wind at heart 70+ (+10, NEW, the perk's size `PerkFight.gd:14`); trust: a mid-round change is a shout, so a Low fighter ignores it (CODE); short fuse: LATER | Heart second; the rest later |
| Opponent | Their HANDS by style and score, tells in the clue line | First build (needed for the war case) |
| After the fight | Rest days from wind (`Aftermath.toll`, CODE) and from legs (NEW: + legs used x 0.2); the injury roll and no-sparring days from head (CODE) | Second |
| Ladder / pro | 6 to 10 rounds: legs decide | The probe runs 6 rounds now |
| BJJ | gas + hunt / hold (CODE `BjjBeat.gd:18-25`); grip strength as its legs | Later |
| HEAT (composure, bad at both ends; Calm down / Fire up; temper) | Not in v2 | LATER |

## 8. The screen
- **Beside the fighter (his ask):** two thin rings on the canvas under each fighter's feet: outer WIND (gold), inner LEGS
  (teal), in an arc that empties as they drain; drawn before the bodies so a head, glove or foot is never covered; hidden
  during a count and in close-ups. The opponent's rings drawn as a band (the range) until film.
- **The fixed panel in each top corner, its top edge in the corner colour:** HANDS (Coast / Steady / Push) and FEET (Press /
  Hold / Move), each with "set for this round" or "1 of 2 shouts left"; WIND with the 40 line ("push worth nothing") and the
  35 line ("gassed"); LEGS with the 30 line ("legs gone"); HEAD with the 60 line ("a count can finish it"). One line each, in
  clock time and slope words: "Wind: slowing, gassed at 1:00 of round 3 at Push"; "Legs: to the bell with 1:30 spare";
  "Head 24: a dominant round lost adds 32". Hover a step: its cost of the next 30 seconds is hatched on its bar first.
- **It replaces:** the plate's energy / legs / guard bars and numbers, "lasts to R3", the two body holograms (the head meter
  carries what their numbers said), the bottom bar's PACE and AIM rows, the "From the next exchange" box. The bottom bar keeps
  the calls, Say nothing, the clock, the landed box, speed and skip. Net: four elements fewer.
- One pulse at most: the line a resource is about to cross. Words, not symbols, on calls and steps. "Cardio" in hovers. No
  he / she / her / him.

## 9. Every menu and what it is wired to
| Menu | Shows | Wired to |
|---|---|---|
| Fight 3D, canvas | the rings | NEW floor-ring node drawn before the bodies (`scripts/fight3d/FightView.gd` scene), reads LiveRound wind / legs |
| Fight 3D, corner panels | HANDS, FEET, WIND, LEGS, HEAD, readouts | `SidePanel.gd` rebuilt; writes via a shout (`ShoutBar` pick with `|hands=..|feet=..`, `LiveRound.gd:186-192`) |
| Fight 3D, bottom bar | PACE / AIM rows gone; shouts left | `CornerBar.gd:151-177`, `:278-298` |
| Corner minute 3D / 2D | set HANDS and FEET; refill on WIND, a little on LEGS | `CornerOverlay.gd`, `CornerRest.gd`, `FightNight.gd:185-206`; `Combos.after_round`, NEW legs rest |
| Fight 2D (no picture) | the same panel as rows | `ShoutBar.gd:84-95` |
| Playbook > Game plan, ROUND row | HANDS and FEET per round; last round if ahead / if behind | `GamePlanRows.gd:12-29`, `PlanFile`, `PlanPhase.pace` |
| Result | wind, legs, head at the last bell | `FightStats.gd:34`, `:48` |
| Home, tiredness card | rest days from wind and legs | `Aftermath.gd:32-37` |
| Golden path test | minute sets Push + Press, a shout changes FEET, legs cross 30, the head meter moves | NEW `tests/pushtank_path_test.gd` |

## 10. The build
1. PUSHPROBE2 (no screen; arms A-D at 3 and 6 rounds). The owner sees the table. Fail = back to design.
2. Rules: Coast without the flat refill; changes as shouts; LEGS (3.2); HEAD per exchange (3.3); running dry (3.4); the
   opponent's HANDS. Unit tests, the "Push five, Save one" cell red on main first.
3. The corner minute: set HANDS and FEET, the refills.
4. The corner panels and the floor rings; the bottom bar trimmed; the 2D rows.
5. ROUND row; PlanPhase for the last round. Then the result / Home lines.
LATER: Heat, judges' links, short fuse, the legs drill, BJJ.
