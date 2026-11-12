# DAMAGE FIGHT MAP: the body in the bout (S438)
Author: Claude (lead designer). v6 (round 3), the FIGHT half of DAMAGE1 (the earlier whole map is ops/research/DAMAGE_MAP_S437.md).
This half ends at the final bell. What a place carries into the weeks after is the other map (DAMAGE_AFTER_MAP_S438); section 7 is the hand-over.
EVERY NUMBER here is printed by `tools/damage_fight_numbers.py` (stdlib, fixed seeds, 20 asserts, 222 seconds with 4 worker processes on a
GREEN PC; `--jobs 2` beside agents). Nothing in a table was typed by hand. It is a design probe on the exchange formula (Exchanges.settle),
not the game: the build re-measures every TUNE number on the real modules (section 8, task 8).

WHAT ROUND 3 CHANGED IN THE MECHANIC (not the words)
- The corner minute is now a GUESS AGAINST THEIR CORNER. Their corner guards what hurt them last round (Elbows in after body work, Gloves
  high after head work), by a habit you read on tape. A guard that meets your Aim costs you 4 edge; a guard on the wrong door gives you 3.
  Keeping an Aim builds on itself (+1.5 a round). So "keep or switch" depends on their habit, what you did, and what their body shows.
- Where you fight is yours to set: a RANGE CALL (Stay long / Their pace / Get inside). Each boxer is strong at a home range. The Aim and the
  call are ONE pick on one card, because scored apart neither is a decision (4.3).
- The opponent is READ: signs with 1-3 dots for their places, and their plan and corner habit read off tape with the same dots.
- ONE CHANGE is a bet: Fix the habit is safe; a guard is a bet on where they punch next, and it stays until you change it.
- Every option shows its price as a change in the chance to win, from the coach. Edge numbers live in tooltips only.
- Retire your boxer, priced in win chance, healing days and the suspension.

HOW THE DECISIONS ARE TESTED: REGRET, NOT SHARES
Minutes are HARVESTED from 6,000 simulated bouts (3, 4 and 6 rounds) where the bout is still winnable either way. From each minute the bout
is played on with every option on the same dice, split in two halves: best play is the option best on one half, valued on the other, so
dice luck never counts as depth. The script then fits every rule that reads ONE thing on the screen (about 20 things: their style, your
skills, the score, rounds left, your Aim, a read, their tape habits, your places, habit, mood...) and every TWO-thing rule, and asserts:
the best one-thing rule loses 2.5+ win points in 100 against best play; "always the most common option" loses 3+; per bout length, each
cell with its standard error. No "best in N %" share is asserted any more.

## 1. What is wrong today (read in the code)
| # | Today | Code |
|---|---|---|
| 1 | Only `body_hook` reaches a rib, always the side opposite the attacker's lead hand: two orthodox boxers never hit the left ribs | BodyMap.gd:43, 66-67 |
| 2 | A body hook takes 1.5 of 100; a side needs 30 hooks to go hurt, a bout lands far fewer | BodyMap.gd:8, 15 |
| 3 | A second rib truth in PaceAim ("hurt" after 4 body shots), with a southpaw's liver on the left | PaceAim.gd:158-173 |
| 4 | Aiming at a hurt place is automatic: +4 edge and x1.3 damage against a flat 1.5 cost | PaceAim.gd:16-19, 25-34, 61-69 |
| 5 | Places exist only when the bout is watched in 3D | fight3d/BodyLive.gd:16, 33-36 |
| 6 | No place changes an exchange; counts read lost-round damage, not the HEAD place | Duels.gd:145-148; Knockdowns.gd:13-14 |
| 7 | Elbows in moves half of ALL body punches and changes nothing else (measured not to change who wins) | Adaptation.gd:21-22 |
| 8 | Range is never the player's: it comes from the opponent's style only | Exchanges range |
| 9 | The corner sees the opponent's exact numbers; their corner never answers | BodyMap; CornerOverlay.gd |

## 2. Vocabulary (one word per thing; the bands 55 / 35 / 15 are settled)
| Word on screen | Means | Code key |
|---|---|---|
| fine / sore / hurt / injured | a PLACE at 56-100 / 36-55 / 16-35 / 0-15 (on the shown, rounded number) | BodyMap.band |
| HEAD, LEFT EYE, RIGHT EYE, NOSE, LEFT RIBS, RIGHT RIBS (liver) | the six places; the liver is always on the right | BodyMap.PLACES |
| Liver / Left ribs / Middle / Head | the four Aims. Liver = left hooks to the right ribs; Left ribs = the right hand to the left ribs; Middle = straight shots to the stomach | PaceAim.AIMS |
| Stay long / Their pace / Get inside | the range call | new |
| Elbows in / Gloves high | the two guards, the same words for both corners (round 2's "Cover the ribs" is Elbows in again) | Adaptation |
| ROCKED / WINDED / LIVER DROP / BLIND SIDE / CUT | lost an exchange badly / no breath for one exchange / a delayed fall / an eye he cannot use / an open cut | Exchanges, new |
| A read, 1-3 dots | what your corner SEES (a sign, never a number) and how sure it is | new |
| Cautious / stubborn corner; goes to the body / hunts the head | their corner's habit and their plan, read off tape with dots | OppFile |
| Home range; their range game fair / strong | where each boxer gets an edge | STYLES, skills |

## 3. The mechanic, step by step
### 3.1 A landed punch finds a place (every bout: watched, words and Sim)
The exchange still decides who wins it and how many land (4-3 / 5-2 / 6-1, Exchanges.gd:296-312). Then each landed punch:
| Step | Rule (numbers in 6.1) |
|---|---|
| 1 Head or body | the Aim's body share: Liver, Left ribs, Middle 0.45; Head 0.08 (+0.15 when the defender has Gloves high) |
| 2 Middle or hook | down the middle 80% at long, 35% in the pocket, 25% inside; Middle +35 points, a rib Aim -25 |
| 3 Which hand, which side | a LEFT hook lands on the RIGHT ribs (the liver), a right hand on the left ribs. Liver throws the left 85%, Left ribs the right 85%, unaimed 60% the lead. The REAR hand lands x1.25 |
| 4 Elbows in | covers 75% of hooks on the defender's REAR side (an orthodox boxer's liver) and 45% on the lead side; 60% die on the elbow, the rest ride up to the eye on that side |
| 5 Upstairs | jab: nose 60 / eye 40; cross 50 / 50; hook: the eye; uppercut: the nose. The Head Aim turns half the straight shots into hooks and uppercuts and sends 60% of eye punches to the WORSE eye |
| 6 Big | 15% of punches are big (x2). A big punch on an eye or the nose opens a CUT 1.2% of the time (headguard x0.5) |
In a real ring: the lead left hook is the liver shot and the cheap one in the pocket; the right hand to the body is the steady rear-hand shot;
straight body shots go to the solar plexus; tucked elbows take hooks on the near side best.

### 3.2 Points and caps
Rib hook 6, face punch 1, head 0.55 (hooks and uppercuts x1.5 upstairs), big x2, an open cut x1.5. One place loses at most 10 in an exchange
and 30 in a round; at each bell the ribs get back 15% of that round's loss. A fresh place cannot read sore after round 1 (100 - 30 = 70,
structural); a fresh rib cannot reach injured in three rounds (asserted; lowest fresh amateur rib 24, the floor the caps allow is 23.5).

### 3.3 What each place does in the bout (both boxers, the same rules)
| Place | Sore (36-55) | Hurt or injured | In a real ring |
|---|---|---|---|
| RIGHT RIBS (liver) | breath x1.25; each water point worth 1 less; LIVER DROP 12% on each big LEFT hook | breath x1.4, water 2 less; drop 22% (injured 30%) | the pain arrives late and the legs go |
| LEFT RIBS | breath x1.25, water 1 less | x1.4, water 2 less | bruised ribs hurt to breathe |
| Either rib side | THEIR HANDS DROP: your Head Aim +3 edge (+4.5 at hurt, +1 more while their elbows are in, none under Gloves high) | | body first opens the head |
| An EYE | nothing yet (swelling) | BLIND SIDE: -4 edge facing their rear hand, -2 their jab; an open cut is a blind side at any word | a closing or bleeding eye cannot see |
| NOSE | nothing | an open nose cut: water x0.75 | blood in the throat |
| HEAD | the count input (3.8) | the count input | the knockdown is the head |
Liver drop x e^((power - durability)/12), at most 40%; ice on the liver halves it next round; down 50 in 100 ends the bout.
Tiredness costs 10 x (65 - energy) / 65 edge under 65. Round 2's "water stops at 95 / 90" could never bind (coach critic); it is gone.

### 3.4 The four Aims (one row of the minute card)
| Aim | Cost long / pocket / inside (edge, tooltip) | Cheaper with | Pays | Beaten by |
|---|---|---|---|---|
| Liver (orthodox: the lead hook) | 1.8 / 0.3 / 0.8 | Body hook mastery at long (/40) | breath, the LIVER DROP, opens the head | Elbows in (75% on an orthodox liver) |
| Left ribs (orthodox: the rear hand) | 1.4 / 0.8 / 0.3 | | x1.25 points, breath, opens the head | Elbows in (45%) |
| Middle | 0.3 / 0.8 / 1.3 | Inside fighting (/100) off long | WINDED, energy x1.6 | Elbows in at 0.8; it dips your head: their Head +2 |
| Head | 0.2 / 0.6 / 1.3 | Accuracy (/100) | the eye (blind side +2), cuts, the HEAD place, counts | Gloves high |
A southpaw's lead hook lands on the left ribs, so for him Left ribs is the cheap lead shot and the liver is the rear hand.
- KEPT AIM: an Aim kept round after round sets itself up: +1.5 edge a round kept, at most +3, none while their guard meets it.
- THEIR GUARD: met by the Aim it was set for, +4 to them (rib Aims scaled by that side's cover); set for the wrong door, +3 to you.
- WEAKNESS needs the WEAPON (Body hook mastery 50 for ribs, Inside fighting 60 for middle, Accuracy 60 for head): +1 edge, punches x1.15.
Cut: "Own game" as an Aim (best in 2 of 50 cases in round 2); the coach writes an opening Aim instead.

### 3.5 Range: home, mix, the call
Each exchange is at long, pocket or inside, drawn from their style's mix (out-boxer 60/30/10, pressure 20/40/40, counter 45/45/10, slugger
25/45/30; the first two exchanges of round 1 are long). At its home range a boxer gets an edge: yours by skills (head-hunter long, body puncher
pocket, inside man inside: +6), theirs at their style's home (+3 "fair", +9 "strong", on their file). THE CALL moves 60% of the coming mix to
long or inside, times trust (Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7); Stay long costs 0.5 energy an exchange, Get inside 0.8. Set at the
minute; as a shout it lasts to the bell. The range strip shows the mix for the next round under each call.

### 3.6 The guards and their corner (one trigger, both corners)
ELBOWS IN cue: a round of body work on him (an Aim on the ribs or the middle) or a rib side sore. GLOVES HIGH cue: a round of head work, a cut,
or a face place sore. Their corner acts on the cue 90 in 100 (cautious) or 5 (stubborn), +10 for each hook past 3 on one side, at most 85.
The next minute it goes ROUND your guard (Gloves high: to your worse rib side; Elbows in: to your head) or after your damage, 70 in 100
(cautious) / 30 (stubborn); else it keeps its plan (goes to the body / hunts the head). A guard stays until its corner changes it.
Elbows in costs its wearer: own rib hooks x0.6, +0.5 on a rib Aim. Gloves high: ribs x1.25, the other side's body share +0.15, -1 at long;
a blind side costs half while the gloves are high.

### 3.7 Reads, not numbers
The corner never sees the opponent's numbers. Between rounds it sees SIGNS: the elbow drops after body shots, a wince on the turn, mouth
breathing, a closing eye. Each gives a word with 1-3 dots: right 55 / 70 / 85 in 100, else one word off (at the ends inward, so the figures
are true at every word: a coach critic's fix). Their plan and their corner's habit are read off tape the same way, once per bout. Dots: 1, +1
for Ring IQ 60+, +1 for a head coach rated 70+, +1 after tape study (max 3). Your own boxer's numbers stay exact.

### 3.8 Counts and drops (one HEAD truth; the constants the critics found missing)
At the bell the round's loser rolls a count: 5% x (0.3 for a round won 4-2 or closer / 1 for 5-1 / 2.2 for 6-0) x e^((power - durability)/12)
x (1 + (100 - HEAD)/15); each further count x0.6, at most 3. After any count the referee stops it 0.17 x (1 + (100 - HEAD)/60), at most 0.9:
that rule makes most stoppages. Inside an exchange a LIVER DROP is a count (down 50 in 100 ends it), a WINDED boxer under 45 energy takes a
knee (a count), and in amateur bouts a WINDED boxer who loses an exchange badly gets a standing count 35 in 100. Amateur stop rule: 3 a round,
4 a bout (Knockdowns.gd:7-8).

### 3.9 The corner minute: ONE table
| Buy | Who | Does | Offered when | Price shown |
|---|---|---|---|---|
| THE MINUTE CARD: Aim x range | the player | one Aim (3.4) and one call (3.5), picked together | every minute | the coach's % on each Aim (at their pace) and each call (with the Aim kept) |
| ONE CHANGE | the coach, one of three | Fix the habit (takes Coachability 5/7/9 in 10 x trust, from the 2nd exchange) / Elbows in / Gloves high (3.6) | a habit open or a place sore: every minute in 3- and 4-round bouts; 6-round: the coach's pick (4.3) | the coach's % each |
| Water / ice | the seconds' pick, shown, changeable | 3 points: water (+6 under 40, +3 at 40-60, +2 over 60, less with a sore rib); ice the worse rib side at energy 50+ (one word better next round, 15% more back, liver drop x0.5) | always | none (measured worth about 1 point, round 2) |
| Clear the head | seconds | starts the round not ROCKED | ROCKED at the bell | none |
| RETIRE | the player | stops the bout now (4.5) | every minute | "Win 42 % -> 0 %; saves about 25 healing days; costs a stoppage loss: 30 days out, -2 members, -4 reputation" |
| Cutman, the doctor's look | PRO ONLY | the cutman closes one cut (eye first); the doctor stops it 28 in 100 with a face place or HEAD at 15 or under, 8 an open cut, 2 a closed one | pro bouts | in pro bouts |
An open habit costs 2.5 / 5 / 7.5 edge in each exchange at ITS one range ("drops the right at long"), so its price is its range's share.

### 3.10 WINDED: the boxer answers by himself
The next exchange costs 16 edge. Heart 65+ fights through at half (-8) and keeps the range; under 65 he steps off (-8, +3 energy, long range for
two exchanges, rib hooks on him at half and no drop). Measured in round 2 at 2.2 win points best to worst: not a decision. Tie up stays a shout,
not modelled in the probe.

## 4. Decisions
### 4.1 The regret table (pasted; 3x3 minute: 96 minutes x 240 play-ons an option; other minute cells 48 x 320; ONE CHANGE 64 x 400)
| Decision | Bout | Gap best-worst | Best ONE-THING rule | It loses (win pts in 100, +/- SE) | Always the most common option | Best TWO-THING rule | It loses |
|---|---|---|---|---|---|---|---|
| The minute: Aim and range together | 3x3 | 18.6 | their style | 3.9 +/- 0.6 | 5.7 +/- 0.7 | their style x your Aim | 2.7 +/- 0.4 |
| The minute: Aim and range together | 4x3 | 15.4 | your skills | 2.8 +/- 0.7 | 5.4 +/- 0.9 | their style x habit | 1.5 +/- 0.5 |
| The minute: Aim and range together | 6x3 | 17.3 | your Aim | 2.7 +/- 0.6 | 5.6 +/- 1.0 | your Aim x takes a fix | 1.0 +/- 0.4 |
| ONE CHANGE | 3x3 | 23.2 | your energy | 4.0 +/- 0.7 | 10.2 +/- 1.6 | score x habit | 2.3 +/- 0.5 |
| ONE CHANGE | 4x3 | 27.3 | your energy | 3.0 +/- 0.6 | 3.4 +/- 0.6 | habit x takes a fix | 1.0 +/- 0.4 |
| ONE CHANGE (CUT in 6-round bouts) | 6x3 | 20.3 | your face | 1.1 +/- 0.4 | 1.8 +/- 0.5 | habit x takes a fix | 0.5 +/- 0.3 |
| Aim alone (not scored: merged) | 3x3 | 10.5 | habit | 0.6 +/- 0.5 | 1.8 +/- 0.8 | their plan (tape) x habit | 0.0 +/- 0.4 |
| Range call alone (not scored: merged) | 3x3 | 6.9 | your skills | 0.4 +/- 0.4 | 3.0 +/- 0.9 | their style x their corner (tape) | 0.0 +/- 0.2 |
Read it: in a 3x3 amateur bout a player who reads one thing gives away about 4 win points in 100 at every minute; thinking about two things
gets most of it back. Best option in (3x3 minute, 96): Head with Stay long 29, Head with Get inside 22, Middle with Get inside 12, Liver with
Stay long 9, Left ribs with Get inside 7, the rest 17. ONE CHANGE best in 3x3: Fix 14, Elbows in 27, Gloves high 23 (of 64); 4x3: 30 / 20 / 14.
The 4x3 and 6x3 minute cells pass by less than one standard error (2.8 and 2.7 against 2.5): the build's probe re-checks them (task 8).

### 4.2 The coach's % (the clarity fix, and a rule like any other)
Each Aim, call and ONE CHANGE shows "+4 %" or "-2 %": the coach plays the bout on from what the corner READS (place words at their middle
value, their plan and corner habit as read on tape, so he is right as often as the dots: his rating is one of them), priced "if their corner
changes nothing". Pressing the coach's best % on each row is measured as a rule:
| Decision (3x3) | Minutes | Press the coach's best %: it loses | The coach's pick is the best play |
|---|---|---|---|
| The minute | 96 | 3.6 +/- 0.6 | 32 in 100 |
| ONE CHANGE | 64 | 6.2 +/- 1.3 | 53 in 100 |
So the % helps a new player and never plays the minute for him: what it leaves out is exactly their corner's answer and what the reads got wrong.

### 4.3 What was merged or cut, and why
| Was | Measured | Now |
|---|---|---|
| The Aim alone at the minute | best one-thing rule loses 0.6 | merged into the minute card with the range call |
| The range call alone | best one-thing rule loses 0.4 | merged (the call is the Aim's price: Liver is cheap in the pocket, Head at long) |
| ONE CHANGE in 6-round bouts | loses 1.1 (your face decides it) | CUT there: the coach's pick shows, changeable but not a decision; redesign before the 6-round pro tier |
| Own game as an Aim | best in 2 of 50 (round 2) | cut |
| WINDED answer, water or ice | 2.2 and 1.1 points (round 2) | the boxer's own answer; the seconds' pick |
| Knees, standing counts, the doctor in amateur bouts | 3.3, 1.6, 0.9 in 100 amateur bouts | PRO ONLY chips (a standing count still counts toward 3 / 4, shown in the count tally, no chip) |
Kept on amateur screens (5+ in 100 amateur bouts): WINDED 28, LIVER DROP 7.1, cuts 13, BLIND SIDE 7.5, head counts 22, their Elbows in 78 minutes.
The Head Aim's job: after the body (hands down) and the worse eye (blind side): it is the best Aim in the most 3x3 minutes, and the worst
when their gloves are up (4.4).

### 4.4 A minute, played (3x3, the minute before round 3, one round each; script, 1,000 play-ons an option)
What the player sees: your inside man (orthodox, mood Low, a habit "drops the right in the pocket", a fix takes 4 in 10) against a southpaw
pressure fighter. Your boxer: every place fine, energy 81. Your Aim last round: Middle. Their body as read with ONE dot: both rib sides "sore",
both eyes "sore". The tape (one dot): "stubborn corner", "hunts the head". Their range game: fair. The coach's %: next to every button.
If nothing changes (keep Middle, their pace, Fix the habit as the coach's default) you win 58 in 100.
| Press | Win | What happened |
|---|---|---|
| Aim: Liver / Left ribs / Head | 53 / 51 / 52 | each throws away the +1.5 a kept Middle has built, and the reads were wrong: their ribs are really 86 and 77 (fine), so the head was never open |
| Range: Get inside (Stay long 57) | 62 (+5) | inside is your home (+6) and your Middle costs 1.3 - 0.85 there |
| ONE CHANGE: Gloves high | 78 (+20) | they hunt the head (the tape was right this time): their head punches meet the gloves (+4 to you), the face takes half |
| ONE CHANGE: Elbows in | 44 (-14) | the wrong door: they hunt the head and the elbows leave it open (+3 to them, +1 their head opening) |
| Retire | 0 | saves about 11 healing days; he is stopped anyway 2 in 100 if he goes on |
The lesson the screen teaches: the reads with one dot lied about their ribs, the tape told the truth about their plan, and the biggest button
was the guard, not the Aim. A player who reads only "their ribs: sore" switches to the Head and loses 6.

### 4.5 Retire your boxer, priced (from the minute play-ons that keep the Aim at their pace)
| Bout | Minutes | Win if he goes on | Minutes with a win chance under 15 | ... stopped anyway | Healing days saved by retiring |
|---|---|---|---|---|---|
| 3x3 | 96 | 42 | 13 | 10 in 100 | 24.6 |
| 4x3 | 48 | 34 | 11 | 13 in 100 | 36.1 |
| 6x3 | 48 | 45 | 8 | 26 in 100 | 47.8 |
Healing days = extra rib and eye points lost / the other map's healing a day (ribs 1.4, eye 2.0). Retiring is a stoppage loss: 30 days
out (StandDown), -2 members, -4 reputation (code), against a points loss at -1 / -2 and no stand-down. Its currency is days, not win points,
so it is priced, not regret-scored here; the after map's day-equivalents score it in that map's probe.

## 5. The menu table (only what the player can act on)
Every body picture: the place is the TINTED MUSCLE on the game's own figure with a HOOKED LEADER LINE out of the body to its name
(BodyCallouts.gd, CalloutLine.gd); no ovals or blobs on the chest. Your boxer shows a number at sore or worse; the opponent a word and dots.
| Screen | Element | Wired to | The act |
|---|---|---|---|
| Fight HUD (3D) and words view | one figure a side; yours "LEFT RIBS 48 sore", theirs "RIGHT RIBS sore (2 dots)"; hover: the sign seen | HitPlaces.map; DamageEffects.read(map, dots) | read |
| Fight HUD | chips: WINDED, BLIND SIDE, LIVER DROP, ROCKED, CUT, "their elbows are in", "their gloves are high"; amateur bouts hide the PRO ONLY chips | DamageEffects.chips(map, events, tier) | shout the call (range) or Tie up |
| Fight HUD | range strip LONG / POCKET / INSIDE: this exchange and the round's mix; your home and theirs marked | Exchanges range; Range.mix(style, call, trust) | shout Stay long / Get inside |
| Corner minute, THE MINUTE CARD | Aim row (Liver / Left ribs / Middle / Head) and range row (Stay long / Their pace / Get inside), each with the coach's %; "kept 2 rounds: +3" on the kept Aim; edge in the tooltip | PaceAim.aim_cost; Range; CoachForecast.price(state, reads) | pick one Aim and one call |
| Corner minute, their corner | "Their corner: cautious (2 dots)", "Plan: hunts the head (1 dot)", "Last round you worked the body: expect Elbows in" | OppFile tape habits; their_change cue | read, then pick |
| Corner minute, ONE CHANGE | Fix the habit ("takes 4 in 10"), Elbows in, Gloves high, each with the coach's %; 6-round: the coach's pick shown | Adaptation.offers; CoachForecast | pick one |
| Corner minute, seconds | water and ice as picked, changeable; Clear the head; cutman and the doctor's chance (pro only) | CornerJobs.recover_options; BodyMap.corner | change or accept |
| Corner minute, RETIRE | a quiet button behind a divider, never pre-selected: win % -> 0, healing days saved, the stoppage's price | Retire.price(state) -> AfterFight | retire |
| Result page | both figures at the last bell; the cause line; "your Aim bought: 34 rib points; their guard met you 2 rounds; your call kept you at home 60%" | HitPlaces.final(map); the hand-over (7) | read; the other map's choices follow |
| Fight prep > opponent file | weakness with the weapon it needs; their range game and home; tape habits (corner, plan) with dots; carried damage from their last bout | OppFile.gd:82 + open, home, corner, plan, carried | plan the Aim, the pads, tape study |
Removed: "a third more damage" (PaceAim.gd:137, 139), the "+4" hurt Aims, the 3D-only map, the opponent's place numbers, Own game.

## 6. Numbers (pasted from the script output)
### 6.1 Constants (TUNE: the build's probe may move them)
| Constant | Value |
|---|---|
| Points | rib hook 6 (rear hand x1.25), face punch 1, head 0.55; hooks and uppercuts x1.5 upstairs; big x2 (15%); open cut x1.5 |
| Caps on one place | 10 an exchange, 30 a round; ribs get back 15% of the round's loss at the bell |
| Aim cost long / pocket / inside | lead-hook side 1.8/0.3/0.8 (less Body hook/40 at long); rear-hand side 1.4/0.8/0.3; Middle 0.3/0.8/1.3 (less Inside fighting/100 off long); Head 0.2/0.6/1.3 (less Accuracy/100) |
| Range | home +6 (yours by skills); theirs 3 (fair) or 9 (strong); a call moves 60% of the mix x trust; energy 0.5 / 0.8 an exchange |
| Their guard | met: +4 to them (rib Aims x the side's cover / 0.75; Middle x0.8); the wrong guard: +3 to you |
| Elbows in | covers 75% rear side, 45% lead side; 60% die, the rest ride up to that eye; own rib hooks x0.6, +0.5 on a rib Aim |
| Gloves high | face and head x0.5, a blind side half; ribs x1.25; their body share +0.15; -1 at long |
| Kept Aim | +1.5 a round kept, at most +3, none while their guard meets it |
| Head after the body | +3 while their worse rib side IS sore, +4.5 hurt; +1 with their elbows in; none under Gloves high; worse eye 60%, +2 on a blind side; Middle dips your head: +2 to their Head |
| Liver drop (big LEFT hook, right ribs) | fine 2%, sore 12%, hurt 22%, injured 30% x e^((power-durability)/12), max 40%; ice x0.5; down 50 in 100 |
| Breath | spend x1.25 sore, x1.4 hurt; each water point -1 sore, -2 hurt |
| Their corner | acts on the cue 90 (cautious) / 5 (stubborn) in 100, +10 a hook past 3, max 85; goes round your guard or after your damage 70 / 30 |
| Open habit | 2.5 / 5 / 7.5 edge an exchange at its one range; the fix takes Coachability (5/7/9 in 10) x trust, from the 2nd exchange |
| A read | right 55 / 70 / 85 in 100 at 1 / 2 / 3 dots, else one word off (inward at the ends); tape habits the same |
| WINDED, counts, cuts | WINDED 14% a big straight body punch x e^(pd/12); knee under 45; standing count 35% (amateur); counts as 3.8; cut 1.2% |
One edge point in one exchange = 0.24% of a 3-round bout at level (100/66 x 0.3125 x round pivot 0.5); 4 rounds 0.18%, 6 rounds 0.15%.

### 6.2 How often it meets the player (2,000 bouts a column; style, weakness, skills, both stances, their corner, plan, mood, Heart, habit, dots, cardio, a carried rib on their side 1 in 5 all vary)
| Per 100 bouts | Amateur 3x3 | Amateur women (headguards) | Pro debut 4 | Pro 6 | On amateur screens |
|---|---|---|---|---|---|
| A place sore or worse by the bell of round 2 | 31.2 | 28.8 | 31.4 | 32.4 | shown |
| A chip (sore place or WINDED) before round 3 | 45.4 | 43.4 | 46.5 | 48.5 | shown |
| Bouts with a WINDED | 27.8 | 27.9 | 35.4 | 45.5 | shown |
| ... knees (WINDED under 45 energy) | 3.3 | 3.4 | 12.7 | 28.4 | PRO ONLY |
| Standing counts | 1.6 | 1.5 | 0.0 | 0.0 | count tally only |
| Bouts with a LIVER DROP | 7.1 | 7.1 | 10.9 | 20.2 | shown |
| Head counts at the bell | 22.4 | 16.4 | 33.0 | 60.2 | shown |
| Bouts with a cut | 13.1 | 7.0 | 19.2 | 22.9 | shown |
| Bouts with a BLIND SIDE | 7.5 | 4.0 | 12.6 | 35.4 | shown (women: 4.0, see 9) |
| Their corner's Elbows in (minutes) | 78.2 | 78.5 | 114.6 | 192.9 | shown |
| Stoppages (all kinds) | 10.1 | 7.8 | 15.5 | 32.5 | shown |
| ... by a liver drop | 3.7 | 3.7 | 6.0 | 11.0 | shown |
| ... by the doctor | 0.9 | 0.2 | 0.5 | 3.6 | PRO ONLY |
Caps held: most off one place in one exchange 10.0, in one round 30.0; lowest fresh amateur rib 24. Amateur stoppages 10.1 sit inside REAL
5-12 (J-KDRATES1, asserted). Hand-over: 30% of amateur bouts that go the distance end with your rib side sore or worse.

## 7. The hand-over to the other map (at the final bell)
| Per boxer, per place | Value | State | Flags |
|---|---|---|---|
| HEAD, each EYE, NOSE, each RIB SIDE | 0-100 at the last bell (after the give-back) | fine / sore / hurt / injured | CUT (eye, nose); LIVER DROPS taken; counts (head / body); how it ended (points, stoppage, RETIRED) |
This map takes back ONE number: each place's start value for the next bout (f["places"][k].v; model value 70 for a side that ended sore).
The other map's "known" flag becomes their corner's tape read of YOUR carried place. A retirement is a stoppage for the stand-down. The
opponent's body share the other map asked for is the Aim they used most (Liver / Left ribs / Middle = body 45%, Head 8%).

## 8. Build order (pure module + unit test first; one screen per task; every file under 500 lines; boxing only)
| # | Task | Seat | Owns | Test (red on main first) |
|---|---|---|---|---|
| 1 | HITPLACES1: a place per landed punch in EVERY bout, the hand picks the side, rear x1.25, Elbows in by side, cuts, caps, give-back | Arena | rules/HitPlaces.gd; LiveRound / BodyLive call lines | hit_places_test: left ribs hit between two orthodox boxers; Liver throws 85% left; caps 10/30 |
| 2 | DAMAGEFX1: breath and water, blind side, nose cut, WINDED and the boxer's answer, liver drop and ice, standing count, reads with dots | Qwen | rules/DamageEffects.gd; one call line where the edge is summed | damage_effects_test: every row of 3.3 and 3.7 |
| 3 | AIMS3: four Aims, cost by range and skills, kept Aim, head after the body, middle dip, weakness with weapon; delete HURT_AIM_*, RIB_HURT_AT, Own game | Arena | PaceAim.gd, OppFile.gd | pace_aim_test: the 3.4 table |
| 4 | RANGE1: homes, the call (minute and shout), trust, energy | Qwen | rules/Range.gd; Exchanges range line | range_test: 3.5 numbers |
| 5 | GUARDS1: the one cue, both corners, met / wrong guard, their corner goes round your guard, tape habits with dots | Arena | Adaptation.gd, rules/TheirCorner.gd | guards_test: 3.6 rows |
| 6 | HEADCOUNT1 + RETIRE1: counts read HEAD with 3.8's constants; retire as a stoppage with its price | Arena | Knockdowns.gd, rules/Retire.gd | knockdown_rates_test: amateur stoppages 5-12; retire_test |
| 7 | COACHPCT1: the coach's % from the reads, "if their corner changes nothing" | Arena | rules/CoachForecast.gd | coach_forecast_test: right as often as the dots |
| 8 | PROBE: run the regret asserts on the real Exchanges / Duels (tools/exchange_balance.gd), more minutes for the 4x3 and 6x3 cells | Arena | tools only | the script's 20 asserts |
| 9 | Screens, one task each from a drawn 1920x1080 mockup: HUD, minute card, their corner and ONE CHANGE, retire, result, file | Cursor; Claude opens every still | one scene each | section 5 rows |
| 10 | GOLDEN: the 4.4 minute played end to end, a guard met, a retire offered, the result shows the hand-over | Claude | tests/golden_damage_fight.gd | itself, then the .exe |
Order: 1, then 2-7 in parallel, 8, then 9, 10 last. Tasks 1-7 ship ON (GameSwitches.GAME_ON); plain --script tests stay the OFF arm.

## 9. Needs the owner's yes (on the board with --attach before the task that needs it)
| # | Change | Why | Before task |
|---|---|---|---|
| 1 | THE CORNER WEIGHS MORE: one minute pick moves a deciding round by up to about 20 win points (4.4); the minute card swings 15-19 best to worst | that is what makes it a decision in a 3-round bout; it must be checked against "training beats planning" and "good plan 59 / no plan 45" | 8 |
| 2 | Their corner answers: it guards on a cue and goes round your guard (extends the agreed "opponents adjust by round 2") | the guess against their corner is the decision | 5 |
| 3 | A range call at the minute and as a shout; home ranges; "their range game" on the file | the Aim's price is now the player's | 4 |
| 4 | Elbows in and Gloves high become guards that meet or miss (S406 "moves punches, not who wins" is reopened) | a guard that changes nothing was never a choice | 5 |
| 5 | Reads with dots for their places, their plan and their corner habit; never their numbers | the call stops being arithmetic | 9 |
| 6 | Retire your boxer, a new corner button | the cornerman's biggest call; ties the bout to the weeks | 6 |
| 7 | Own game removed as an Aim; Liver and Left ribs two Aims again | Own game was never best; the two hands differ | 3 |
| 8 | ONE CHANGE is the coach's pick in 6-round bouts until redesigned | it failed the regret bar there | 9 |
| 9 | Blind side stays on women's amateur screens at 4.0 in 100 (under 5), with the men's | one rule for one game; or tag it PRO ONLY for women | 9 |
Decided by Claude inside approved features: every constant in 6.1; the counts' constants; the liver drop raised to 7 in 100 amateur bouts;
the habit's cost at its range; the fix by Coachability x trust; the coach's % "if their corner changes nothing".
Not reopened: bands 55 / 35 / 15; the exchange decides and the 3D only shows; the cutman owns cuts and swelling (S322); six places.

## 10. Left for later (named so no one builds it by accident)
A mid-round Aim switch; "Circle away" from a blind side; "Ask about the ribs" in TALK; a core-and-neck morning; a "protect the ribs" camp focus;
ONE CHANGE redesigned for 6-round bouts; Tie up in the probe; a seventh place (the stomach); jaw and temple; hands as places; the 3D face.

## Changed in round 3
- Share asserts deleted; regret asserts per bout length with standard errors, best play valued on the other half of the dice.
- The minute is the decision: the Aim and a new range call are one card (apart, neither passed); their corner guards on a cue and goes
  round your guard; a kept Aim builds; the coach's % on every button, priced "if their corner changes nothing", measured as a rule.
- Their places, plan and corner habit are reads with dots; your own numbers stay exact; read figures now true at every word.
- ONE CHANGE: Fix / Elbows in / Gloves high as a safe fix against a bet on their next punch; a guard stays until changed; one cue, one name
  (Elbows in) in both corners; cut to the coach's pick in 6-round bouts.
- Liver and Left ribs are two Aims by hand: the lead hook to the liver is the cheap pocket shot with the drop; the rear hand is steady;
  ice halves the liver drop. Own game cut. The Head Aim works the eye and pays after the body.
- Retire your boxer, priced. Knees, the doctor and standing-count chips off amateur screens. The dead water ceiling replaced.
- The count constants (margin factor, referee stop) are in the map; "both asserted" corrected; your boxer is southpaw in 3 bouts in 10.
- "A minute, played" added from the script.
