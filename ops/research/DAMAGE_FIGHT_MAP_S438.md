# DAMAGE FIGHT MAP: the body in the bout (S438)
Author: Claude (lead designer). v5, the FIGHT half of DAMAGE1 (the earlier whole map is ops/research/DAMAGE_MAP_S437.md).
This half ends at the final bell. What a place carries into the weeks after is the other map; section 7 is the hand-over.
EVERY NUMBER TABLE here is printed by `tools/damage_fight_numbers.py` (stdlib, fixed seeds, 18 asserts, about three and a half minutes).
Run it to check any number; nothing in a table was typed by hand. The script is a design probe on the real exchange formula
(Exchanges.settle), not the game: the build re-measures every TUNE number on the real modules (section 8, task 8).

HOW THE DECISIONS ARE TESTED (new in this version)
- D2 is scored on 48 moments HARVESTED from 25,600 simulated bouts (the 6.3 populations), not on starts picked to cover each option.
  From each moment the bout is played on 600 times with each option, the same exchange dice for each option.
- D1 is scored on 96 cases drawn at random from 8 things the player can see (2,304 combinations), 300 bouts a cell.
- A case is CLEAR when its best option beats every other by 1.5+ win points. On the clear cases the script fits every one-thing and
  two-thing lookup rule ("pick X when the file says Y") and asserts: no rule on one thing picks the best option in more than 75% of
  clear cases, no option is best in more than 60%, every option is best at least once. D1 also asserts weakness x their style at 75% or less.
- A decision the probe found to be worth little became a default the player sees and can override (D3, D4, D5 in 4.2). It is no longer
  counted as depth.

## 1. What is wrong today (read in the code)
| # | Today | Code |
|---|---|---|
| 1 | Only `body_hook` reaches a rib, always the side opposite the attacker's lead hand: two orthodox boxers never hit the left ribs | BodyMap.gd:43, 66-67 |
| 2 | A body hook takes 1.5 of 100; a side needs 30 hooks to go hurt (45 off), a bout lands far fewer | BodyMap.gd:8, 15 |
| 3 | A second rib truth: "hurt" after 4 body shots a side, and it puts a southpaw's liver on the left | PaceAim.gd:158-173 |
| 4 | Aiming at a hurt place is automatic: +4 edge and x1.3 damage against a flat 1.5 cost for any Aim | PaceAim.gd:16-19, 25-34, 61-69 |
| 5 | The Aim tips promise "about a third more damage" | PaceAim.gd:137, 139 |
| 6 | Places exist only when the bout is watched in 3D | fight3d/BodyLive.gd:16, 33-36 |
| 7 | No place changes an exchange: only the whole-boxer hurt flag costs Guard | Duels.gd:145-148 |
| 8 | Counts read lost-round damage (8 / 18 / 32), not the HEAD place | Knockdowns.gd:13-14, 34 |
| 9 | Ice on the ribs gives energy back and 15% of the loss for a round, on the worse side picked for you | CornerJobs.gd:18-19, 40; BodyMap.gd:184-187 |
| 10 | Elbows in moves half of ALL body punches; Gloves high adds 0.15 to the body (not "the reverse") | Adaptation.gd:21-22 |
| 11 | The opponent mode "Hurt" and the place band "hurt" are one word for two things | Exchanges.gd:107-109; BodyMap.gd:112-119 |
| 12 | The corner sees the opponent's exact numbers; nothing in a place's state is a read | BodyMap; CornerOverlay.gd |

## 2. Vocabulary (one word per thing; the bands 55 / 35 / 15 are settled)
| Word on screen | Means | Code key |
|---|---|---|
| fine / sore / hurt / injured | a PLACE at 56-100 / 36-55 / 16-35 / 0-15, read on the shown (rounded) number | BodyMap.band |
| HEAD, LEFT EYE, RIGHT EYE, NOSE, LEFT RIBS, RIGHT RIBS (liver) | the six places; the liver is always on the right | BodyMap.PLACES |
| Own game / Head / Body / Ribs | the four Aims. Body = down the middle (was "Downstairs"); Ribs = the hooks, the left hook to the liver first | PaceAim.AIMS |
| Cover the ribs | the ONE CHANGE that tucks the elbows (was "Elbows in") | Adaptation |
| ROCKED / WINDED / LIVER DROP / BLIND SIDE / CUT | lost an exchange badly / no breath for one exchange / a delayed fall / an eye the boxer cannot use / an open cut | Exchanges, new |
| WEAKNESS | where the opponent is open (ribs / body / head / none), a line on their file, found by tape study | OppFile.gd:82 + `open` |
| A read, 1-3 dots | what your corner SEES on the opponent (a sign, never a number) and how sure it is | new |
| LONG / POCKET / INSIDE | the range strip; each Aim's cost depends on it | Exchanges range |

## 3. The mechanic, step by step
### 3.1 A landed punch finds a place (every bout: watched, words and Sim)
The exchange still decides who wins it and how many land (4-3 / 5-2 / 6-1, Exchanges.gd:296-312). Then each landed punch:
| Step | Rule (numbers in 6.1) |
|---|---|
| 1 Head or body | the Aim's body share (Own game 0.20, Head 0.08, Body and Ribs 0.45) |
| 2 Middle or hook | a body punch goes down the middle 80% at long, 35% in the pocket, 25% inside; Body adds 35 points, Ribs takes 25 off; else a hook |
| 3 Which hand, which side | a LEFT hook lands on the RIGHT ribs (the liver), a right hook on the left ribs. The Ribs Aim throws the left hook 3 in 4; unaimed hooks are 60% the lead hand |
| 4 Cover | under their Cover the ribs, 70% of the hooks at the ribs are covered: 60% of those die on the elbows, the rest ride up to the eye on that side (a left hand finds the right eye) and the head |
| 5 Upstairs | jab: nose 60 / eye 40; cross 50 / 50; hook: the eye; uppercut: the nose. The Head Aim turns half the straight shots into hooks and uppercuts |
| 6 Big | 15% of punches are big (x2). A big punch on an eye or the nose opens a CUT 1.2% of the time (headguard x0.5) |
In a real ring: the lead left hook is the liver shot; straight body shots go to the solar plexus; tucked elbows take body hooks.

### 3.2 Points and caps
Rib hook 6, face punch 1, head 0.55 (hooks and uppercuts x1.5 upstairs), big x2, an open cut x1.5. One place loses at most 10 in an
exchange and 30 in a round; at each bell the ribs get back 15% of that round's loss, the face and head nothing. A fresh place cannot be
sore after round 1, and a fresh rib cannot reach injured in three rounds (both asserted; lowest fresh amateur rib 24).

### 3.3 What each place does in the bout (both boxers, the same rules)
| Place | Sore (36-55) | Hurt or injured | In a real ring |
|---|---|---|---|
| RIGHT RIBS (liver) | breath: energy spend x1.25, the minute's water stops at 95; LIVER DROP 5% on each big LEFT hook | spend x1.4, water stops at 90; drop 10% (injured 18%) | the pain arrives a beat late and the legs go |
| LEFT RIBS | breath x1.25, water stops at 95 | x1.4, 90 | bruised ribs hurt to breathe |
| An EYE | nothing yet (swelling) | BLIND SIDE: -4 edge if it faces their rear hand, -2 if their jab. An open cut over the eye is a BLIND SIDE at any word (blood) | a closing or bleeding eye cannot see that side |
| NOSE | nothing | an open nose cut: the minute's water x0.75 | blood in the throat |
| HEAD | the count input (3.6) | the count input | the knockdown is the head |
| (middle) | not a place: a big straight body punch rolls WINDED 14% x e^((power-durability)/12) | | under 45 energy WINDED is a knee: a count |
Tiredness costs 10 x (65 - energy) / 65 edge under 65 energy. The removed jobs: the left-ribs twist (it was live in about 1 exchange in 100)
and "nose at hurt" (it never fired); the nose now acts through a cut.

### 3.4 The Aims (corner bar; set at each minute, the only place Aim numbers live)
| Aim | Body share | Edge cost long / pocket / inside | Its job | Cheaper with |
|---|---|---|---|---|
| Own game | 0.20 | 0 / 0 / 0 | nothing extra | |
| Head | 0.08 | 1.2 - Accuracy/80 at every range | eyes, cuts, the HEAD place | Accuracy (85 costs 0.14) |
| Body (the middle) | 0.45 | 0.5 / 1.5 / 2.5, less Inside fighting/50 in the pocket and inside (floor 0.5) | WINDED, energy | Inside fighting |
| Ribs | 0.45 | 3 / 0.5 / 0.5, less Body hook mastery/40 at long (floor 0.5); +1 if your left is the rear hand (a southpaw) | breath, the water ceiling, LIVER DROP | Body hook mastery |
Three links make the Aim a plan, not a lookup:
- WEAKNESS needs the WEAPON. The Aim that matches their weakness gets +0.5 edge and its punches x1.1 (Body: WINDED and energy x1.1;
  Head: cuts x2), but only if your boxer has the weapon for it: Body hook mastery 40+ for ribs, Inside fighting 50+ for body, Accuracy
  50+ for head. Their Cover the ribs shuts a ribs weakness. The weapon comes from the pad planner and the Playbook (pack 4.2).
- THE BODY OPENS THE HEAD. While their worse rib side reads sore, the Head Aim gets +3 edge (+4 at hurt): their hands come down.
  The plan "Ribs, then Head" moves to the Head at the first minute your corner READS their ribs sore (3.5), and does not go back.
- THEIR CORNER ANSWERS. It covers the ribs 10% of minutes (file: "covers rarely") or 30% ("often"), +10% for each hook past 3 on
  one side last round, at most 70%. It moves its own Aim to your damage 6 minutes in 10: a cut or sore face draws their Head, a sore
  rib side their Ribs.
The bout length counts too: rib damage pays through breath and the water ceiling, so it grows with 4 and 6 rounds.
A mid-round Aim switch costs one exchange at -2 (the boxer resets); the probe only switches at the minute.
Deleted: "Finish the head" as an Aim (the Go for the finish shout stays), the "Go to the body" shout (the Aims carry it),
HURT_AIM_EDGE, HURT_AIM_DAMAGE, RIB_HURT_AT, AIM_COST 1.5, the separate Liver and Left ribs Aims (one Ribs Aim; the liver is its payoff).

### 3.5 Reads, not numbers
The corner never sees the opponent's place numbers. It sees SIGNS between rounds: the elbow drops after body shots, a wince on the turn,
breathing through the mouth, a closing eye. Each sign gives a word (fine / sore / hurt) with 1-3 dots: right 55 / 70 / 85 in 100, else one
word off. Dots: 1, +1 for Ring IQ 60+, +1 for a head coach rated 70+, +1 after tape study (max 3). Your own boxer's numbers stay exact.

### 3.6 Counts and drops (one HEAD truth)
At the bell the round's loser rolls counts with the damage term reading the HEAD place: 5% x margin x e^((power - durability)/12)
x (1 + (100 - HEAD)/15). Inside an exchange: a LIVER DROP is a count at the end of that exchange (stays down 50 in 100: the bout ends);
a WINDED knee is a count; in amateur bouts the referee gives a standing count (35%) when a WINDED boxer loses an exchange dominantly.
All counts feed the amateur stop rule (3 a round, 4 a bout, Knockdowns.gd:7-8).

### 3.7 The corner minute: ONE table
| Buy | Who | Does | Offered when | Code |
|---|---|---|---|---|
| Water | seconds, 1 point each of 3 | +6 energy under 40, +3 at 40-60, +2 over 60; stops at the rib ceiling | always | CornerJobs.gd:15-16 |
| Ice a rib side | seconds' pick (shown, the player may change it) | the side reads one word better next round (breath, drop) and gets back 15% more of the round's loss | a rib side sore or worse | CornerJobs.recover |
| Clear the head | seconds, 1 point | starts the round not ROCKED | ROCKED at the bell | CornerJobs.gd:42-43 (kept) |
| ONE CHANGE | the coach: one of three | Fix the habit (takes 5 / 7 / 9 in 10 by Coachability) / Cover the ribs (3.1 step 4, liver drop x0.2) / Gloves high (face and head x0.5, ribs x1.2, their body share +0.15) | always; D2 when a habit is open and something is hurt | Adaptation.offers |
| Cutman | PRO bouts only, one job | closes one open cut (an eye cut before the nose): no bleed, no blind side, the doctor reads it 2 in 100 | a cut open | BodyMap.corner cut |
| The doctor's look | end of the minute | stops it 28 in 100 with a face place or HEAD at 15 or under; 8 in 100 for an open cut, 2 for a closed one | as stated | R28 card (pro); amateur: rule only |
Amateur seconds have water and a towel: no cutman work (the doctor reads an untreated cut). An open habit costs its edge at ITS range
only (one habit, one range: "drops the right hand at long"), so its price depends on the opponent's range mix.

### 3.8 WINDED: the boxer answers by himself
The next exchange costs 16 edge. The boxer answers by his Heart: Heart 65+ fights through (-8); under 65 he steps off and breathes (-8,
+3 energy, the bout goes to long range for two exchanges, rib hooks on him land at half and cannot drop him). The player may shout Tie up
(-9, inside, no big shot either way, a 3-point dig on a sore rib, a referee warning 30% and the second a point). The probe measured the
three answers on 48 harvested moments: on average 2.2 win points separate best and worst, so it is not counted as a decision (6.5).

### 3.9 Worked bout (script, seed 27): a body puncher on "Ribs, then Head" against an orthodox pressure fighter, covers rarely
| Bell | Exchanges | Their liver / left ribs | Your liver / left ribs | Their worst eye | Energy you / them | Aim next | Changes you / them |
|---|---|---|---|---|---|---|---|
| 1 | 4-2 | 77 fine / 91 | 77 fine / 100 | 96 | 78 / 76 | Ribs | none / none |
| 2 | 1-5 | 72 fine / 91 | 52 sore / 79 | 88 | 52 / 59 | Ribs | none / cover |
| 3 | 3-3 | 72 fine / 91 | 51 sore / 79 | 70 | 37 / 54 | Head | cover / cover |
Events: their corner covers from round 2; at the round-3 minute your corner (2 dots) READS their liver sore while it is 72 fine and moves
the Aim to the Head; your corner covers your sore liver; you are WINDED in round 3 and step off. Ends on points, you win. Read it: their
cover took your rib hooks in round 2, a wrong read sent you upstairs early, and the cover on your side kept your liver off the drop.

## 4. Decisions
### 4.1 The two scored decisions (from the script; "why not" = the average win % lost in the clear cases where the option is not best)
| Decision | When it appears | Options and what each costs | Best in (clear cases) | Why you would NOT pick it |
|---|---|---|---|---|
| D1 Aim plan | before round 1 and at each minute | Own game (free) / Head / Body / Ribs / Ribs, then Head on a sore read (costs in 3.4) | 4% / 6% / 24% / 46% / 20% of 50 | -7.5 / -11.1 / -5.5 / -4.5 / -5.6 |
| D2 ONE CHANGE | minute, a habit open and a sore rib side with 4+ hooks on it, or a sore or cut face | Fix the habit (may not take) / Cover the ribs (habit stays open) / Gloves high (habit open, ribs take more) | 56% / 19% / 26% of 27 | -4.0 / -4.4 / -5.0 |
D1: 50 of 96 cases are clear; the options are 9.1 win points apart on average. The best one-thing rule (your skills) picks the best plan in
60% of clear cases, the best two-thing rule (their style x your skills) in 74%, weakness x their style in 72%. What decides it, from the
per-case lines: Ribs wins with a body puncher, a carried rib or a long bout; Body with an inside man against a body weakness; "Ribs, then
Head" mostly against sluggers and with head-hunter or inside-man skills; Own game and Head only in a few 3-round or head-weakness cases.
D2: 27 of 48 moments are clear; the options are 4.1 win points apart on average. The best one-thing rule (your face: sore, cut or fine)
picks the best option in 74%; the best two-thing rule (rounds left x habit) in 93%, fitted on 27 cases with many empty cells, so it
overfits (the build's probe re-checks it on more moments). What decides it: a sore rib side with 3+ rounds left and a small habit says
Cover; a sore (not cut) face says Gloves high; the last round, a big habit or a boxer who takes fixes says Fix.

### 4.2 What stopped being a decision, and why
| Was | Measured (6.5) | Now |
|---|---|---|
| D3 the answer to WINDED | 2.2 win points best to worst on average; 19 of 48 moments 2.5+ apart | the boxer's own answer by Heart (3.8); Tie up stays a shout |
| D4 water or ice | 1.1 win points on average; 6 of 48 moments 2.5+ apart | the seconds' pick (ice the worse side at energy 50+), shown, changeable |
| D5 cutman: eye or cut | no cutman work in amateur bouts (rule); in pro bouts a cut is the one job | the cutman closes a cut, eye before nose |
| Doctor's card (R28) | 1.3 stops in 100 amateur bouts, 7.7 in 100 six-round pro bouts | the card in pro bouts; amateur: the doctor's rule only |
| Liver vs Left ribs Aims | the best side was always their lead side | one Ribs Aim, the left hook first |

## 5. The menu table (only what the player can act on)
Every body picture: the place is the TINTED MUSCLE on the game's own figure with a HOOKED LEADER LINE out of the body to its name
(BodyCallouts.gd, CalloutLine.gd). No ovals or blobs on the chest. Your boxer shows a number at sore or worse; the opponent shows a word
and its dots (FIGHT_DISPLAY_DECISION_S419).
| Screen | Element | Wired to | The act |
|---|---|---|---|
| Fight HUD (3D) and words view | one figure a side; yours "LEFT RIBS 48 sore", theirs "RIGHT RIBS sore (2 dots)" | HitPlaces.map; DamageEffects.read(map, dots) | hover: the sign seen and what the place does |
| Fight HUD | chips: WINDED, BLIND SIDE (left), LIVER DROP, ROCKED, CUT, "their corner covers" | DamageEffects.chips(map, events) | pick the Aim, shout Tie up |
| Fight HUD | range strip LONG / POCKET / INSIDE, and next round's mix from their style ("long 20 / pocket 40 / inside 40") | Exchanges range; STYLES mix | plan the Aim |
| Corner bar | the four Aims, each with its cost at that mix as one number ("0.9 at this mix"), "their weakness: ribs, you have the weapon", "+3: the body opened it" | PaceAim.aim_cost(aim, boxer, mix); OppFile; DamageEffects.opened | pick the Aim |
| Corner minute, damage row | your places (numbers), theirs (words and dots), their corner's cover habit, "Ribs, then Head" switch line | DamageEffects.read; OppFile cover | keep or switch the Aim |
| Corner minute, ONE CHANGE | Fix the habit ("takes 7 in 10"), Cover the ribs ("habit stays open"), Gloves high ("ribs take more"), each with the coach's arrow better / same / worse (right by the coach's rating) | Adaptation.offers; CornerJobs | pick one |
| Corner minute, seconds | water and ice as the seconds picked them; cutman job (pro); the doctor's chance; one "Coach's pick" button | CornerJobs.recover_options; BodyMap.corner; R28 card | change or accept |
| Result page | both figures at the last bell; the cause line; "your Aim bought: 34 rib points, 11 energy off them" | HitPlaces.final(map); the hand-over (7) | read; the other map's choices follow |
| Fight prep > opponent file | weakness with WHERE and the weapon it needs; cover habit; carried damage from their last bout ("stopped by a body shot 12 days ago: right side 70") | OppFile.gd:82 + open, cover, carried | plan the Aim, the pads |
Removed: "a third more damage" (PaceAim.gd:137, 139), the "+4" hurt Aims, the 3D-only map, the opponent's place numbers.

## 6. Numbers (pasted from the script output)
### 6.1 Constants (TUNE: the build's probe may move them inside the range)
| Constant | Value |
|---|---|
| Place words | fine 56-100, sore 36-55, hurt 16-35, injured 0-15, on the shown (rounded) number |
| Points | rib hook 6, face punch 1, head 0.55; hooks and uppercuts x1.5 upstairs; big x2 (15% of punches); open cut x1.5 |
| Caps on one place | 10 an exchange, 30 a round; ribs get back 15% of the round's loss at the bell |
| Aim cost long/pocket/inside | Head 1.2 - Accuracy/80 at any range (floor 0); Body 0.5/1.5/2.5 less Inside fighting/50 in the pocket and inside; Ribs 3/0.5/0.5 less Body hook mastery/40 at long (floor 0.5); Ribs +1 when your left is the rear hand |
| Body share by Aim | Own game 0.20, Head 0.08, Body 0.45, Ribs 0.45; a Ribs Aim throws the left (liver) hook 75% |
| Their WEAKNESS | the matching Aim, if you have the weapon (Ribs: Body hook mastery 40+; Body: Inside fighting 50+; Head: Accuracy 50+): +0.5 edge, its punches x1.1 (Body: WINDED and energy x1.1; Head: cuts x2); their cover shuts a ribs weakness |
| Head after the body | Head Aim +3 edge while their worse rib side reads sore, +4 at hurt |
| Breath (either rib side) | spend x1.25 sore, x1.4 hurt; the minute's water stops at 95 / 90 |
| Tired | -10 edge x (65 - energy) / 65 under 65; a water point +6 under 40, +3 at 40-60, +2 over 60 (x0.75 with an open nose cut) |
| Ice a rib side (1 point) | the side reads one word better next round (breath, liver drop) and gets back 15% more of the round's loss |
| Blind side | an eye at hurt or an open cut over it: -4 edge facing their rear hand, -2 facing their jab |
| Cuts | a big punch on an eye or the nose opens one 1.2% of the time; headguard: cuts x0.5, face points x0.6 |
| WINDED | 14% a big straight body punch x e^((power-durability)/12); under 45 energy a knee (a count) |
| WINDED answers | Fight through -16 x 0.5 / 0.75 / 1 at Heart 65+ / 55-64 / under 55; Tie up -9, inside, no big shot either way, a 3 dig on a sore rib, warning 30%, the second a point; Step off -8, +3 energy, long range two exchanges, rib hooks on you half and no drop |
| Standing count (amateur) | 35% when a WINDED boxer loses an exchange dominantly; counts toward 3 a round / 4 a bout |
| Liver drop, a big LEFT hook on the right ribs | fine 1%, sore 5%, hurt 10%, injured 18% x e^((power-durability)/12), max 30%; cover x0.2; stays down 50 in 100 |
| Head count at the bell | 5% x margin x e^((power-durability)/12) x (1 + (100 - HEAD)/15) |
| Doctor (end of the minute) | a face place or HEAD at 15 or under 28 in 100; an open cut 8; a closed cut 2 |
| Cover the ribs | 70% of the hooks at the ribs are covered: 60% of those die on the elbows, the rest land on the eye on that side and the head; liver drop x0.2; costs the ONE CHANGE slot (the habit stays open) |
| Gloves high | face and head points x0.5; ribs x1.2; their body share +0.15 |
| Their corner | covers 10% (rarely) / 30% (often) +10% a hook past 3 on one side, max 70%; moves its Aim to your damage 6 minutes in 10 |
| A read (signs, not numbers) | right 55 / 70 / 85 in 100 at 1 / 2 / 3 dots, else one word off |
| Open habit | 0.6 / 1.1 / 2.2 edge an exchange over a mix, all of it at its one range (x3); the fix takes 5 / 7 / 9 in 10 by Coachability; their cardio: spend x1.15 low, x0.85 high |
One edge point in one exchange = 0.24% of a 3-round bout at level (exchange pivot 0.31 x round pivot 0.5).
| Edge | -7 | -6 | -4 | -2 | 0 | +2 | +4 |
|---|---|---|---|---|---|---|---|
| Exchange won % | 40 | 41 | 44 | 47 | 50 | 53 | 56 |

### 6.2 Their ribs at the last bell, by your plan (3 rounds from fresh, 400 bouts; orthodox, covers rarely, no weakness, average skills)
| Your plan | vs | Their worse rib mean | Sore or worse | Hurt or worse | Your win % |
|---|---|---|---|---|---|
| Own game | out-boxer | 83 | 0% | 0% | 47 |
| Head | out-boxer | 92 | 0% | 0% | 44 |
| Body | out-boxer | 85 | 0% | 0% | 47 |
| Ribs | out-boxer | 51 | 65% | 8% | 43 |
| Ribs, then Head on a sore read | out-boxer | 57 | 48% | 6% | 41 |
| Own game | pressure | 77 | 2% | 0% | 48 |
| Head | pressure | 89 | 0% | 0% | 44 |
| Body | pressure | 77 | 2% | 0% | 45 |
| Ribs | pressure | 46 | 79% | 23% | 48 |
| Ribs, then Head on a sore read | pressure | 53 | 64% | 8% | 45 |
Reading: in a 3-round bout with no weakness and average skills, rib work buys a sore side but not the bout; D1 shows what changes that.

### 6.3 How often it meets the player (4 styles x 4 weaknesses x 2 stances x 2 cover habits x 100 seeds = 6400 bouts a column)
Your boxer's Heart, habit and skills vary by seed. Hand-over: 20% of fresh amateur bouts end with your rib side sore or worse; that share
starts the next bout with the side at 70. Women: amateur 3x3 in headguards. Pro: 6x3 with a cutman.
| Per 100 bouts | Amateur fresh | Amateur hand-over | Amateur women | Pro 6 rounds |
|---|---|---|---|---|
| A place on either boxer sore or worse at the bell of round 1 | 0.0 | 3.1 | 0.0 | 0.0 |
| ... by the bell of round 2 | 15.9 | 19.6 | 14.5 | 15.4 |
| A chip (a place sore or worse, or WINDED) before round 3 | 37.3 | 39.8 | 36.3 | 37.0 |
| WINDED (either boxer) | 42.6 | 42.4 | 43.4 | 75.8 |
| ... a knee (WINDED under 45 energy) | 2.4 | 2.3 | 2.6 | 24.5 |
| Standing counts on a WINDED boxer | 1.1 | 1.1 | 1.1 | 0.0 |
| Liver drops | 3.1 | 3.1 | 3.0 | 9.0 |
| Head counts at the bell | 22.0 | 22.0 | 16.1 | 57.2 |
| Cuts opened by a big punch | 13.7 | 13.8 | 6.9 | 26.5 |
| Their corner covers the ribs (minutes) | 47.7 | 47.6 | 48.2 | 117.3 |
| Stoppages (all kinds) | 7.9 | 8.0 | 4.8 | 28.6 |
| ... by a liver drop | 1.7 | 1.7 | 1.7 | 4.8 |
| ... by the doctor | 1.3 | 1.3 | 0.2 | 7.7 |
| Your corner faces D2 (ONE CHANGE, a habit open and something to protect) | 4.5 | 5.2 | 3.8 | 27.2 |
| ... D3 (an answer to WINDED) | 14.0 | 13.9 | 14.1 | 18.5 |
| ... D4 (points with a rib side sore or worse) | 4.7 | 8.5 | 4.9 | 18.7 |
| ... D2 or D3 | 18.2 | 18.7 | 17.7 | 41.7 |
| Exchanges with a BLIND SIDE open (per 100 exchanges) | 3.6 | 3.6 | 1.5 | 10.9 |
Caps held: most off one place in one exchange 10.0 (cap 10), in one round 30.0 (cap 30); lowest fresh amateur rib 24.
Reading: the chip bar (35+ before round 3) now holds from fresh; amateur stoppages sit inside REAL 5-12 (J-KDRATES1). D1 is faced in every
bout. D2 comes up in about 1 amateur bout in 20 and 1 pro bout in 4: it is a pro-bout decision first. The blind side now comes from cuts.

### 6.4 The decision tables (from the script; per-case lines in its output)
| D1 option | Best in (clear cases) | Share | Why NOT |
|---|---|---|---|
| Own game | 2 of 50 | 4% | -7.5 |
| Head | 3 of 50 | 6% | -11.1 |
| Body | 12 of 50 | 24% | -5.5 |
| Ribs | 23 of 50 | 46% | -4.5 |
| Ribs, then Head on a sore read | 10 of 50 | 20% | -5.6 |

| D2 option | Best in (clear cases) | Share | Why NOT |
|---|---|---|---|
| Fix the habit | 15 of 27 | 56% | -4.0 |
| Cover the ribs | 5 of 27 | 19% | -4.4 |
| Gloves high | 7 of 27 | 26% | -5.0 |

### 6.5 Measured, not decisions
48 harvested moments each, 300 play-ons per option. D3 the answer to WINDED: average gap best to worst 2.2 win points, 19 of 48 moments
2.5+ apart. D4 water or ice: 1.1 win points, 6 of 48 moments 2.5+ apart.

## 7. The hand-over to the other map (what this map passes on at the final bell)
| Per boxer, per place | Value | State | Flags |
|---|---|---|---|
| HEAD, each EYE, NOSE, each RIB SIDE | 0-100 at the last bell (after the give-back) | fine / sore / hurt / injured | CUT (eye, nose); LIVER DROPS taken; counts (head / body); how it ended |
This map takes back ONE number: the start value of each place for the next bout (model value: 70 for a side that ended sore, boxing again
inside 14 days). The opponent's file shows the same carried value for THEIR last bout once tape study finds it. The stand-down, the injury
roll and every care choice belong to the other map.

## 8. Build order (pure module + unit test first; one screen per task; every file under 500 lines; boxing only)
| # | Task | Seat | Owns | Test (red on main first) |
|---|---|---|---|---|
| 1 | HITPLACES1: a place per landed punch in EVERY bout, the hand picks the side, middle vs hook, cover on the elbows, cuts, caps, give-back | Arena | rules/HitPlaces.gd; LiveRound / BodyLive call lines | hit_places_test: left ribs hit between two orthodox boxers; a Ribs Aim lands 3 in 4 left hooks; caps 10/30 |
| 2 | DAMAGEFX1: breath and water ceiling, blind side (swelling or cut), nose cut, WINDED and the boxer's answer, liver drop on a left hook, standing count, reads with dots | Qwen | rules/DamageEffects.gd; one call line where the edge is summed | damage_effects_test: every row of 3.3 and 3.5 |
| 3 | AIMS2: four Aims, cost by range and skills, weakness with weapon, the body opens the head; delete HURT_AIM_*, RIB_HURT_AT, the Liver / Left ribs pair | Arena | PaceAim.gd, OppFile.gd | pace_aim_test: the 3.4 table; no "+4" path left |
| 4 | HEADCOUNT1: counts read the HEAD place; liver drops, knees and standing counts count toward 3 / 4 | Arena | Knockdowns.gd | knockdown_rates_test: amateur stoppages 5-12 per 100 |
| 5 | MINUTE2: ONE CHANGE fix / cover / gloves with the fix taking by Coachability; habit at its range; seconds' ice; cutman pro-only; their corner covers and re-aims | Qwen | CornerJobs.gd, BodyMap.corner, Adaptation.gd | corner_minute_test: the 3.7 rows |
| 6 | Screens, one task each from a drawn 1920x1080 mockup: (a) HUD figures, chips, range strip, (b) corner bar Aims, (c) minute damage row and ONE CHANGE, (d) result figures and "your Aim bought", (e) file weakness, weapon, cover, carried | Cursor; Claude opens every still | one scene each | section 5 rows |
| 7 | GOLDEN: a body puncher aims Ribs, their corner covers, a wrong read moves the Aim to the Head, your boxer is WINDED and steps off, Cover the ribs bought, the result shows the hand-over | Claude | tests/golden_damage_fight.gd | itself, then the .exe |
| 8 | PROBE: run D1 and D2 on the real Exchanges / Duels (tools/exchange_balance.gd) with the same rule-fit asserts, on more D2 moments, and move the TUNE numbers until they hold | Arena | tools only | the same asserts as the script |
Order: 1, then 2-5 in parallel, 8, then 6, 7 last. Tasks 1-5 ship ON (GameSwitches.GAME_ON); plain --script tests stay the OFF arm.

## 9. Needs the owner's yes (on the board with --attach before the task that needs it)
| # | Change | Why | Before task |
|---|---|---|---|
| 1 | Ice on the ribs stays (the owner's S316 call) but becomes the seconds' pick, shown and changeable, with a new effect (one word better, 15% more back) | the probe found water-or-ice worth about 1 win point: not a choice worth his attention | 5 |
| 2 | Elbows in becomes Cover the ribs: the elbows take most covered hooks (was "moves punches, not who wins", S406) | a cover that only moves damage was never chosen; now it is best in about a fifth of D2 cases | 5 |
| 3 | The corner sees signs with 1-3 dots, never the opponent's numbers | a number made the keep-or-switch call arithmetic | 6 |
| 4 | A weakness on the file pays only with the weapon for it (Body hook mastery / Inside fighting / Accuracy) | links the Aim to the pads; the weakness alone decided the Aim | 3 |
| 5 | WINDED: the boxer answers by his Heart; Tie up stays a shout | the three answers were measured about 2 win points apart | 2 |
| 6 | Amateur bouts: no cutman work, the doctor reads an untreated cut; the R28 card in pro bouts | the amateur rule; the card never fired in amateur bouts | 5 |
| 7 | Words: fine / sore / hurt / injured; ROCKED for the opponent's "Hurt" mode; Body for Downstairs; Cover the ribs for Elbows in; one Ribs Aim | one word, one meaning (the S422 game-words rule) | 6 |
Decided by Claude inside approved features: rib points 6 and the 10 / 30 caps; counts read the HEAD place; the liver drop, WINDED, knee and
standing-count numbers; the doctor's look; the Aim costs by range and skills; the habit at its range; the fix taking by Coachability;
their corner's cover and re-aim; "Finish the head" and "Go to the body" removed as Aims (the finish shout stays).
Not reopened: bands 55 / 35 / 15; the exchange decides and the 3D only shows; the cutman owns cuts and swelling (S322); six places.

## 10. Left for later (named so no one builds it by accident)
"Circle away" from a blind side; "Ask about the ribs" in TALK (a high-Heart boxer under-reports pain); a core-and-neck morning that
toughens the ribs for a camp; a "protect the ribs" camp focus; a per-buy win-chance preview (the coach's arrow stands in); the mid-round
Aim switch in the probe; a seventh place (the stomach: WINDED is an event); jaw and temple; hands as places; the 3D face (lid uniform,
brow marks). D2 comes up in about 1 amateur bout in 20: if the owner wants it in every amateur bout, that is a scope call.
## 11. Changed in round 2
- Decisions are no longer scored on hand-picked starts: D2 is scored on moments harvested from simulated bouts, D1 on 96
  random cases, and the script fits one- and two-thing lookup rules to the winners and asserts none passes 75% on one thing.
- One Ribs Aim replaces Liver and Left ribs; the hand picks the side (a left hook finds the liver), the rear-side penalty is gone, the
  liver drop needs a left hook (script fixed), Downstairs is renamed Body.
- Aim costs fall with your own skills (Accuracy, Inside fighting, Body hook mastery); a weakness pays only with the weapon for it.
- The body opens the head (+3 / +4 to the Head while their ribs read sore) and a "Ribs, then Head" plan that acts on a READ.
- The corner sees signs with 1-3 dots, not the opponent's numbers; the range strip and each Aim's cost at the coming mix are on screen.
- Their corner answers: covers more after more hooks, and moves its Aim to your damage.
- Breath raised (x1.25 / x1.4) and a sore rib caps the minute's water; water gives less above 60 energy; tiredness weighs more.
- Cover the ribs: the elbows take most covered hooks; a diverted left hook now finds the RIGHT eye (script fixed). Gloves high joins ONE
  CHANGE. The habit costs its edge at its own range, and the fix takes by Coachability.
- WINDED: answers rebuilt on the person and simulated in bouts; measured small, so the boxer answers by Heart. Knee under 45 energy,
  amateur standing count added. D3 no longer scores one call twice.
- Cuts come from big punches; an open cut over an eye is a blind side; amateur bouts have no cutman; the doctor's card is pro.
- Ice and water became the seconds' pick after measuring them; D5 and the Liver / Left ribs choice are gone as decisions.
- Script fixes: the edge-to-bout figure is 0.24% (round pivot 0.5), the count weighting is gone (D3 is simulated), place words read the
  rounded number, cut order is deterministic, the chip bar holds from fresh, 4-, 6-round and women's columns added, the worked bout
  shows its events.
