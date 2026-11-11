# DAMAGE1: hits, damage and recovery, design map v3 (S437)
Author: Claude (lead designer). v3 for two fresh critics (S425: depth 7+ from both). v1 depth 6 / 6; v2 depth 6.5 / 6, clarity 6 / 5.
The owner, S437: "i want the ribs to take normally the damage and deepen/streghten/tighten the damage system/mechanic and hit system ,
have the current one judged and  improve it , same with the recovery mechanics when an area become injured options for player to act etc".
His notes the same night: body pictures use "the hook line and the pointer out of the body", never shapes on the chest; and "do we have
mechanic to show damage done during the fight on the faces ?" (today only the 2D close-up, scripts/ui/FaceMarks.gd; answered in 8 and 10).
Tags: REAL (measured or rule book), CODE (file:line), SHAPED (a real pattern, our size), TUNE (bounded range, the probe picks), TO SOURCE
(John before the build). Source codes (G132, J55...) are explained once, in section 13. Nothing was run: every number in 9 is arithmetic.

THE CHAIN (one line): punch -> place -> chip -> the 30 s answer -> the minute -> the last bell -> SORE or KNOCK -> check -> care ->
the pencilled bout -> the medical -> the next bout's starting value -> what the other corner knows and hunts.

CHANGED SINCE v2 (each is a rule or a number, not wording)
1. Bout decisions now come up: the result page offers PENCIL THE NEXT SHOW (14-21 days) before any knock is known, and a sparring night on a
   SORE place can crack it. Section 6.4 counts how often each decision meets the player in a 26-week career; bar 10 is weighted by it.
2. COVER follows the defender's STANCE: the rear side 60% off, the lead side 30%. The liver stays on her right; a southpaw's liver is her lead side.
3. The other corner spends its own three minute points in version 1, by its rating, and hunts or covers by its STYLE (a table), 1 bell in 5 off-script.
4. The physio is scarce: on call = 2 slots a week, full-time (new, $160) = 4. Checks, care weeks, SORE treatment and the fight-week rub-down all
   take a slot. On paper 2 slots run short in about 1 week in 4.
5. Every option has a price: pads instead of sparring on a SORE side costs fight-night edge in a camp (-0.3 a PEAK night).
6. Caps on every roll; landed-count multipliers round DOWN and change only what lands, never who wins the exchange; covered shots go to the HEAD.
7. ONE Aim table with every edge cost. The "Go to the body" shout is one free exchange of Aim Body (a shout); Aim Body persists and costs 1.0.
8. The STOMACH has its own payoff: SHORT OF BREATH takes her PUSH. It gives back 25% at each bell, never counts, never a serious knock.
9. ONE HEAD truth: counts, stand-down and the injury roll all read the HEAD place; HEADTRUTH1 owns StandDown.gd and the Injuries.gd head read.
10. The timed liver shot: a counter's left-hand body hook can drop a FRESH fighter (0.6% base, x2 on her Push, capped 3%, once a bout).
11. The medical is a risk: the doctor finds a crack not on her card 50 in 100; missed = a HIDDEN CRACK. A scan puts it on her card: certainty,
    and Keep the date closes. Left ribs no longer cut her landed count: any hurt side drops the Guard 2, the left ribs 6.
12. Arithmetic redone with big punches (x1.15) and round 1 opening long; a southpaw row; a face table for bar 9b. Body pictures: tinted muscle and
    a hooked line out of the body, never ovals. Three face-damage tasks added. "Stay long", "Flexibility into the rolls", T39 and the
    separate doctor card are gone (the doctor rides on the agreed R28 cutman card).

## 1. What is wrong today
| # | Defect | Code |
|---|---|---|
| 1 | Only `body_hook` reaches a rib, always the side opposite the attacker's lead hand: between two orthodox boxers the left ribs are never hit | BodyMap.gd:43,66-67 |
| 2 | A body hook takes 1.5 points; "hurt" is 45 down: 30 hooks on one side, a bout lands about 5-13 | BodyMap.gd:8,15 |
| 3 | A second rib truth (hurt after 4 shots a side) puts a southpaw's liver on her left; the button lights while the figure reads 94; the 3D can swap body shots away | PaceAim.gd:162-176; ExchangeBeats.gd:137-151 |
| 4 | Places exist only when the bout is watched in 3D | fight3d/BodyLive.gd:33-36 |
| 5 | No damaged place changes the fight | Duels.gd:127-151; FightMeters.gd:1-4 |
| 6 | The screen promises rules that do not exist ("a third more damage", "gas drains faster", "the doctor may stop it", "A knockdown chance") | PaceAim.gd:61-69; CalloutLine.gd:16-19; BodyTip.gd:15; Exchanges.gd:87-89 |
| 7 | THREE head numbers: counts read lost rounds (8/18/32), the figure reads punches, the stand-down and injury roll read damage x 2.2 | Knockdowns.gd:13-14; StandDown.gd:7,14-15; Injuries.gd:28,181-187 |
| 8 | Landed `rear_hook`, `lead_uppercut` do nothing; a landed READ counter does 0 | BodyMap.gd:18; TheRead.gd:44 |
| 9 | After the bout every injury is one timer, the place starts the next bout at 100, fighting hurt is a flat 10/15/20 ENERGY | Sim.gd:171-213; BodyMap.gd:21-28; Injuries.gd:31-34 |
| 10 | Once hurt the player has nothing to do; the 3D faces never change; nothing shows on the result page or portrait after | Injuries.gd:242-244; FaceMarks.gd (2D close-up only) |

## 2. Vocabulary (one word, one meaning)
| Word on screen | Means | Code key |
|---|---|---|
| HEAD, LEFT EYE, RIGHT EYE, NOSE | as today | head, left_eye, right_eye, nose |
| RIGHT RIBS (liver side) / LEFT RIBS / STOMACH | her two sides and the middle | right_ribs / left_ribs / middle |
| fine / hurt / critical / doctor | 55 / 35 / 15 (settled) | BodyMap.gd:8-10 |
| Chips: SHORT OF BREATH, WINDED, HANDS DROPPING, EYE CLOSING, NOSE, ROCKED | a hurt place doing its job | new |
| COVER <place> | one effect, three scopes: a shout (this exchange), a minute buy (next round), a plan line (all night) | new |
| Elbows in / Gloves high | ONLY the corner's ONE CHANGE (all body / all head) | Adaptation.gd:21 |
| SORE / KNOCK / TENDER | days, nothing locked / a named injury with a course / a place that starts a bout under 100 | new |
| PENCIL | a next show held before the knock is known | new |
| ENERGY, Cardio, Durability | fight fuel; the stat that fills it; chin AND body (agreed 10 attributes) | Duels.gd:79, Attrs.gd:33 |

## 3. THE HIT SYSTEM
### 3.1 The exchange decides; each landed punch gets a place
The 30-second exchange and its counts (4-3 / 5-2 / 6-1, Exchanges.gd:296-302) decide who wins it and feed the judges, unchanged. After
they are settled, a pure module (`HitPlaces`) gives each landed punch a PLACE, HAND, PUNCH and "big or not" (15% big, TUNE 10-20) and writes
the fight's one map, in every bout (watched, words, Sim). The 3D shows that list and may never re-roll, swap or drop it.
RULE FOR EVERY MULTIPLIER ON A LANDED COUNT: it applies after the exchange is scored, rounds DOWN, and changes only what lands (places, the
3D list). It never changes the exchange winner or the cards. Covered shots are not lost: they land on the HEAD at x1.0.

### 3.2 Where a punch goes
| Step | Rule | Src |
|---|---|---|
| 1. Head or body | the Aim's body share (3.3) | CODE PaceAim.gd:15; REAL 20% to the body |
| 2. Place by distance | unaimed body shots, stomach / attacker's lead-hand side / rear-hand side: LONG 70/20/10, POCKET 30/42/28, INSIDE 20/45/35. Round 1 opens LONG (RingDuel.gd:76) | TUNE ±10; 60:40 lead:rear = LIVER_SHARE (PaceAim.gd:165) |
| 3. Which side | the LEFT hand lands on her RIGHT RIBS, the right hand on her LEFT RIBS (orthodox lead hook finds the liver; a southpaw finds it with the rear left, less often, big x2) | anatomy |
| 4. Aim at one place | a side: 60% of body shots in the pocket or inside, 35% at long. Stomach: 85% at long, 50% near | TUNE ±10 |
| 5. Her COVER | 4.3, applied after step 4; moved shots to the head | |
| 6. Head places | jab 60 nose / 40 eye, cross 50/50, hooks the eye, uppercuts the nose; the eye on the punching hand's side | CODE BodyMap.gd:48-65 |
| 7. The punch shown | her mastery mix: stomach = body jab, body cross; sides = lead or rear body hook; head = five + rear_hook, lead_uppercut | RoundStyle.gd:16-22; new beats body_jab, body_cross, rear_body_hook |

### 3.3 THE AIM TABLE (the only place Aim numbers live; today one AIM_COST 1.5 for all, PaceAim.gd:19,27-28)
| Aim | Edge every exchange | Body share | Its job | Its counter |
|---|---|---|---|---|
| Own game | 0 | 0.20 | none | none |
| Head | -1.0 | 0.08 | the HEAD place (counts) | Gloves high |
| Body (both sides and stomach) | -1.0 | 0.50 | Cardio, spread | Elbows in |
| Stomach | -1.0 | 0.55 | takes her Push | COVER stomach 40% |
| Left ribs | -1.5 | 0.55 | hands drop, the head opens | COVER: 60% if it is her rear side, 30% her lead side |
| Right ribs (liver) | -2.0 | 0.55 | WINDED, the body count | COVER: 60% vs orthodox (rear side), 30% vs southpaw (lead side) |
| The hurt head | -1.5 | 0.08 | the finish | Tie up, COVER head (Gloves high) |
| Any Aim on a place at hurt | +4 (kept, PaceAim.gd:16); no damage bonus (HURT_AIM_DAMAGE 1.3 deleted) | | | |
| "Go to the body" shout | 0, ONE exchange of Aim Body; best/ok/wrong by her mode; one of the round's 2 full shouts | 0.50 | a burst | as Body |

### 3.4 Points off a place of 100
| Lands on | Points | Cap | Src |
|---|---|---|---|
| Nose or eye | 0.8 (was 1.1); hooks and uppercuts x1.5 | | TUNE 0.6-1.1 for bar 9b (9.3) |
| HEAD | 0.55 | | CODE BodyMap.gd:13-14 |
| RIGHT or LEFT RIBS | 3.0 | | TUNE 2.5-3.5 (no real per-punch number) |
| STOMACH | 2.0 | | TUNE 1.5-2.5 |
| Big punch / face place on an open cut | x2 / x1.5 | | CODE BodyMap.gd:16-17 |
| Any one place | | 10 points an exchange, 25 a round | new |
| At each bell | sides give back 15% of their loss, the stomach 25%, face nothing (swelling stays) | | SHAPED G132; TUNE 10-20 / 20-30 |
| Landed READ counter | a big head punch (today 0), or the liver counter (5.2) when it is a left-hand body hook | | TheRead.gd:44 |

### 3.5 How a body attack pays (from 9.1)
Cardio from the first shot (1.2 ENERGY a body shot x0.4-1.8 by Durability, Exchanges.gd:38-43). An AIMED side in the pocket goes hurt in
round 3 of 3 at level volume; at long range only the stomach Aim gets there. An unaimed body plan is a CARDIO plan in three rounds and
says so on its button. Over 4-6 rounds any body plan hurts a place unless covered.

## 4. DAMAGE: what each place changes
### 4.1 One job per place, one chip, on BOTH boxers
| Place | Hurt (55 or under) | Critical (35 or under) | Cap | Chip |
|---|---|---|---|---|
| STOMACH | her Push reads Steady (no +6 edge, PaceAim.gd:10); body shots x1.25 ENERGY | also her minute's water gives half | gives back 25% a bell; never a count; light knock only | SHORT OF BREATH |
| RIGHT RIBS | each shot rolls WINDED 8% (big 16%) | 16% (big 32%); a big shot while WINDED rolls the body count | WINDED 40% a shot | WINDED |
| LEFT RIBS | Guard -6, Aim Head against her +3 (BODY_ON_TIRED_EDGE's size, PaceAim.gd:18) | Guard -10 | places take at most 12 off Guard; with tiredness (TIRED_LEGS 12, Duels.gd:72,133-134) at most 20 | HANDS DROPPING + 3D glove drop |
| Either side, hurt | Guard -2 more for each hurt side ("kill the body, the head follows") | | inside the 12 | |
| An EYE | Head movement -3 | -6; the R28 cutman card opens (4.4) | | EYE CLOSING |
| NOSE | the minute's rest returns a quarter less ENERGY | and Composure -5 | | NOSE |
| HEAD | none: it IS the count input (5.1) | the towel card (M13); any body place at doctor: red chip, 5.2 | | ROCKED |

WINDED: she pays in the NEXT exchange: edge -12 (TUNE 8-14), no Push. Her answers: "Breathe" halves it; "Tie up" halves it but the clinch
digs land on her ribs (ClinchRest.gd:11-58); "Jab and move" takes the ribs out of hook reach (stomach 70% at long). Saying nothing pays in full.

### 4.2 Her answers (each with a price)
| Answer | Where | Does | Price | Right when | Wrong when |
|---|---|---|---|---|---|
| COVER <place> (shout) | when the other Aim is on a hurt place of hers | 3.3's cover for THIS exchange; moved shots to her head at x1.0 | -2 edge; one of the 2 full shouts | WINDED odds live, round nearly won | behind; head already hurt |
| COVER <place> (minute) | 1 point | the same, all next round | -2 edge in pocket and inside (TUNE 1-3) | one side hurt, head fresh | must win inside |
| COVER <place> (plan line) | Playbook | the same from the first bell; drilled on pad nights, half strength undrilled | a plan line; -2 edge all night | their corner knows (7) | they do not: a wasted line and edge |
| Jab and move | shout | stomach 70% of body shots | must win at range | a SIDE hurt, she out-reaches | the STOMACH is hurt |
| Tie up | shout | halves WINDED; rest +1.5 | 1-2 rib digs (CODE) | winded, ribs fine | a side at critical |
| Elbows in / Gloves high | ONE CHANGE | half of all body punches to the head / the reverse | no habit fix that round (unfixed habit -10.5 an exchange, HabitFix.gd:55-59) | the whole body worn, head fresh | the head is the hurt end |

### 4.3 COVER and stance
Rear side 60% off, lead side 30%, stomach 40% (TUNE ±10). Rear side = right ribs for an orthodox defender, left ribs for a southpaw. The liver
is on her right whatever the stance: a southpaw's liver is out in front and the hard one to cover. 3.3 and 9.1 carry both.

### 4.4 Eyes and cuts (owner S322: the cutman handles them)
The cold iron goes on a swelling eye by itself: the coach's x0.85 next round, a hired cutman's x0.7 (TUNE 0.6-0.9). The doctor rides on the
agreed R28 cutman card (one card, never two): at a bell with an eye, the nose or HEAD at doctor, the card shows the cutman's work and the
doctor's stop chance, 35 in 100 (TUNE 25-50) x0.8 coach / x0.6 cutman; stop it or send her out. The towel card (M13) keeps the first word.

## 5. COUNTS (one HEAD truth)
### 5.1 HEAD is the only head number
| Reader | Today | v3 |
|---|---|---|
| Bell count roll | lost-round damage 8/18/32 (Knockdowns.gd:13-14) | (100 - HEAD) x scale (TUNE 0.8-1.6, probe holds main's rates ±15%) |
| Stand-down | damage x 2.2 (StandDown.gd:7,14-15) | the HEAD place's band at the last bell |
| Injury roll, head row | damage x 2.2 (Injuries.gd:28,187) | the HEAD place |
Set-up +30, clinch break +8, Counter sense +15 become big head punches. HEADTRUTH1 (task 5) owns all three readers.

### 5.2 Counts inside an exchange (at most one count an exchange)
| Count | When | Chance | Cap |
|---|---|---|---|
| Head | call "Go for the finish" AND she is Hurt or WINDED | the bell formula, that exchange's band, x0.4 (TUNE 0.25-0.5) | 3.9% x power head punches landed (REAL K67) |
| Body (worn) | a big shot on RIGHT RIBS at critical while WINDED, or any big shot on a body place at doctor | 6% x e^((power - her Durability)/12) | clamp 2%-15% a shot |
| Liver counter (fresh) | a landed READ counter or a won "Draw the lead" exchange whose landed punch is a LEFT-hand body hook, any rib value | 0.6% x e^((power - Durability)/12), x2 if she was on Push | clamp 0.3%-3%; once a bout a boxer |
On paper: a counter-puncher who times it lands 2-4 such counters a bout: about 1 bout in 50 ends with a fresh body drop. All body counts
together stay 10% or fewer of all counts (bar 8; REAL finals 90%+ head). A body stoppage keeps today's 30/90/365 until John sources the rule.

## 6. AFTER THE FIGHT
### 6.1 Place at the last bell -> what follows
| Place | Becomes |
|---|---|
| fine / hurt | nothing / SORE 2-5 days: a bout inside them starts the place at 85. HEAD hurt = the 10-day stand-down only |
| critical | a KNOCK shown as a RANGE, drawn 60 light / 40 serious (TUNE 50-70) |
| doctor | the serious knock, named |
| hand, training strain | today's rolls |
| SORE side on a sparring night | 10 in 100 it becomes the light knock (TUNE 5-15): sparring makes training knocks place-based |

| Place | Light (days) | Serious (days) | Locks while healing |
|---|---|---|---|
| RIGHT / LEFT RIBS | Bruised ribs 10-21 | Cracked rib 42-56 | sparring; body bag and pads that side (stage 1); cracked: strength, roadwork in stage 1 (TO SOURCE) |
| STOMACH | Sore stomach muscles 7-14 | none | sparring, core work |
| An EYE | Swollen eye 5-10 | Cut 14-21 | sparring |
| NOSE | Bloodied nose 5-10 | Broken nose 21-35 | sparring |
| HEAD | 21-day stand-down | Head knock 21-35, never a choice | sparring; hard sessions in stage 1 |
The 6% bout roll is retired for places. A head stoppage keeps 30/90/365 and Durability -2.

### 6.2 Course and TENDER: ONE rule
| Stage (share of days) | She may | Re-hurt x | Bout-night value |
|---|---|---|---|
| 1 SETTLE (40%) | what does not load the place | 3 | light 55; serious: cannot pass a medical that finds it |
| 2 REBUILD (40%) | the place's work at half; sparring only in a body protector, gains x0.6 | 1.5 | light 70; serious as stage 1 |
| 3 CLEARED (20%) | everything | 1 | light 85; serious 70 |
| After the course: Full rest | | | 100 |
| After the course: Train around | | | 85 for 14 days, then 100 |
| HIDDEN CRACK (missed at the medical) | | | 40; each big shot there re-cracks 25 in 100; doctor band at 25, not 15 |
| Physio pre-bout treatment (a slot) | | | +15 on any of these, once, max 90 |
| SORE | | | 85 |

### 6.3 The player's options
| # | Option | Does | Price | Right when | Wrong when |
|---|---|---|---|---|---|
| 1 | CHECK: physio's look | names the range next day, right 3 in 4 (TUNE 65-85); NOT on her medical card | a physio slot | money short; you may want to gamble the medical | the look says bruise and it is a crack |
| 2 | CHECK: scan | names it in 2 days, sure, and puts it ON her medical card | $300 (TUNE 250-400); a named crack in stage 1-2 closes Keep the date | a bout or offer sits in the range and you want certainty | you meant to keep the date on a gamble |
| 3 | No check | free | offers only after the range's LAST day; care runs blind | you would rest her anyway | the pencilled show is 2 weeks off |
| 4 | CARE: Full rest | course 20% shorter; ends at 100 | all training off, gains x0.25; the return week reads as a load spike (2-4x risk); mood -5 if she asked to train | a crack; she must be whole | a show inside the course: she arrives unfit |
| 5 | CARE: Train around | only locked sessions stop, full gains | re-hurt 3 in 100 a week (x3 if an unnamed crack); TENDER 85 for 14 days after | named bruise, next opponent no body hunter | unnamed range; a body hunter next |
| 6 | PHYSIO slot | 6.5 | 6.5 | | |
| 7 | SORE in BUILD or PEAK: keep the sparring night | sparring gains; 10 in 100 a light knock | the risk | early BUILD, a slot to treat it | the show is 10 days off |
| 8 | SORE: switch the night to pads | no risk | PEAK night -0.3 fight-night edge, BUILD night -0.15 (TUNE 0.2-0.5), shown on the camp card | a pencilled show inside the knock's range | a camp already short of sparring |
| 9 | BOUT: Keep the date | she fights with the bout-night value of 6.2 | THE MEDICAL (6.6); heals x1.5 after (Injuries.gd:34); her trust if overruled and it goes critical | a light knock in stage 2-3; an unnamed range you will gamble | a scanned crack (closed); a body hunter with film |
| 10 | BOUT: Ask to move it | +7 days (fight week) / +14 (camp); one ask; never a championship; yes 4-7 in 10 by how keen | the opponent's gain shown ("+1 form"); a NO = that club cool 4 weeks (TUNE 2-6) | fit date just past the bout, place named | unnamed range: the ask spent, the medical still waits |
| 11 | BOUT: Pull out | the bout ends; $300 ($150 for a pencil before it is firm, 10 days out) | money, the rank it would show, mood -5 if she wanted it | serious knock | light knock, goal needs it |
| 12 | Spar anyway (stand-down) | head knock 2 / 6 in 100 (StandDown.gd:48-81) | the shown risk | a title camp short of rounds | any other week |
Her wish: Heart 65+ wants to fight, low Composure wants out; following it is free, overruling is morale -5 / +5. Unanswered on Monday: the
coach picks Full rest. Not offered: train through an injury (rejected, Training v6.1). In BASE the coach switches a SORE night to pads unasked.

### 6.4 THE PENCIL and how often each decision comes up
Result page, amateur, not in a bracket: "Pencil the next show: Sat <date>" (14-21 days out; shows every other Saturday). Free, booked +5
morale (code), the rank sooner. It is chosen BEFORE the check. It firms 10 days out. This is the frequent decision (most bouts); the knock
decisions below are rare by design (a knock is rare in the sport).

| Per 26-week career, 3 boxers (~27 boxer-bouts) | Count | Meets a booked or pencilled bout |
|---|---|---|
| Pencil or not | ~20 | is the booking |
| Fight knocks (4-9 per 100) | 1.1-2.4 | 60% pencilled: 0.7-1.5 |
| Training knocks (1.3% a week, Injuries) | ~1.0 | booked ~60% of weeks: 0.6 |
| SORE-night cracks (about 2 SORE in BUILD/PEAK x 10%) | 0.2 | always (BUILD/PEAK means booked) |
| Nationals bracket knocks | ~0.2 | always (next round) |
| SORE sparring choice (7, 8) | ~2 | |
| Check and care (1-5) | 1.3-3.6 | |
| Bout decisions (9-11) | 1.5-2.5 | |
| Physio squeezes (6.5) | ~7 | |
Offers come for dates after the last KNOWN day: an unnamed rib range (to day 56) shuts out about eight weeks of shows, a named bruise two or
three. That is what a check buys besides the medical.

### 6.5 The physio: scarce for real
| Hire | Slots a week | Price | Src |
|---|---|---|---|
| None | one outside visit, $60 | per visit | TUNE 40-80 |
| On call | 2 | $75 a week | CODE StaffRoles.gd:12 ("a session a week") |
| Full-time (new) | 4 | $160 a week | TUNE 130-200 |

| A slot buys | Effect |
|---|---|
| A CHECK | 6.3 #1 |
| A CARE week | that week's 7 days count as 9 (the x0.75, StaffRoles.gd:19; never under 55% of the days with other cuts) |
| SORE treatment | SORE days halved |
| Pre-bout treatment | +15 on a TENDER place (6.2), or +3 first-bell ENERGY with no place (the fight-week rub-down) |
On paper (3 boxers, the BJJ athlete's strains too): wants a week = rub-downs 1.2 + SORE 0.35 + care 0.15 + checks 0.1 = 1.8 on average.
Two slots run short when wants reach 3: about 27% of weeks (Poisson 1.8). Four slots: about 4%. So full-time is a real buy.

### 6.6 THE MEDICAL (weigh-in day): a risk, not a certainty
| She carries | The doctor | Result |
|---|---|---|
| fine, SORE, light knock, any head/eye/nose knock | sees the face, checks the head card | eyes, nose, head knocks in stage 1-2 fail (visible); the rest pass |
| A serious rib NOT on her card (unchecked or physio's wrong look) | presses the ribs: finds it 50 in 100 (TUNE 35-65) | found: bout off, $300, that club cool 4 weeks. Missed: HIDDEN CRACK (6.2) |
| A scanned crack in stage 1-2 | it is on her card | Keep was closed; no medical |
Keep with an unnamed rib range: 60% bruise (pass), 20% found, 20% hidden crack. Fight prep shows these odds.

## 7. LINKS AND THE OTHER CORNER
| From | To | The link |
|---|---|---|
| Training week | the bout | Durability sets body cost and both count rolls (one stat, agreed attributes); COVER plan lines need pad nights |
| The bout | the week | SORE asks about the sparring night (cost on the camp card); a knock greys its locked sessions; "Train X next week" offers only unlocked work |
| The Aim | the next rounds | left ribs now = the head opens later; right ribs now = WINDED and a count later; stomach now = no Push for her late |
| The minute | the month | Breathe and COVER keep a side out of critical: SORE instead of a knock |
| The pencil | the knock | a pencil taken before the check meets a knock 1-2 times a career: check, move, keep or pull out |
| The check | the medical, offers | physio's look keeps the gamble, the scan buys certainty and closes Keep; known range opens offers |
| Care | the next bout | Full rest unfit but clean; Train around fit but TENDER |
| Money | all | scan $300, visit $60, pull-out $300 / $150, physio $75 / $160; the stipend keeps running while she is out (CODE GameMoney.gd:23 sums every roster row's weekly_salary; nothing in Injuries.gd stops it) |
| Mood | the corner | overruling her wish costs morale; at Low she ignores shouts (CornerTrust.gd:11-13), COVER and Breathe included |
| Four fighters | the physio | 6.5 |

### 7.1 What their corner knows about her (shown on Fight prep as "Their corner: knows / may know / does not")
| How the knock happened | Chance they know |
|---|---|
| Public ending (stoppage, doctor, towel) | 100% |
| On film of that bout (their rating 60+) | 60% |
| A pull-out or a moved date | 30% (they know "something", not where) |
| Training knock, SORE | 0% |
A known place is hunted per 7.2. The COVER plan line is now a bet on this shown chance, not a lookup.

### 7.2 The other corner (version 1: the same rules both ways)
Minute: its own 3 points. Rating 60+ spends by the same best-spend rule the game suggests to the player (water / Breathe / clear head /
COVER); under 60, water x3 (clear head when hurt). At each bell it follows its style 4 bells in 5 (TUNE 70-90%), its own game otherwise.

| Style | Hunts our hurt side | Its Aim | Covers its own hurt side | File line once scouted |
|---|---|---|---|---|
| Pressure fighter | rating 50+ | right ribs | rating 80+ | Goes to a hurt side |
| Volume puncher | 60+ | Body | 70+ | Goes to the body |
| Boxer-puncher | 60+ | the hurt place | 65+ | Goes to a hurt side; Covers when hurt |
| Out-boxer | 75+ | Stomach (long) | 55+ | Covers when hurt |
| Counter-puncher | never aims | own game; liver counter x2 | 60+ | Times the body counter |
| Slugger | 70+ (body) | the hurt head first | never | Goes for the hurt head |
Bar 14 holds the two directions level.

## 8. THE MENU TABLE (only what the player can act on)
EVERY BODY PICTURE: the place is the TINTED MUSCLE on the game's own body figure (stomach = the abdominals, a side = the obliques and
ribs on that side) and a HOOKED LEADER LINE out of the body to its name and number beside the figure (scripts/ui/BodyCallouts.gd,
scripts/ui/CalloutLine.gd). Never ovals, dots or blobs on the chest. Numbers only under 55 (FIGHT_DISPLAY_DECISION_S419).

| Screen | Element | Wired to | The act | Test |
|---|---|---|---|---|
| Fight HUD (3D) | one figure a side, tinted muscle + hooked lines | the fight's map | hover: the job | one_map |
| Fight 3D boxers | FACE in the ring: swelling, the eye closing, blood under the nose, the cut, from the map | HitPlaces map (task 11) | read the eye before the minute | face3d (still on the game camera) |
| Fight HUD | the chip over EACH boxer | DamageEffects | hers: which answer; theirs: when the Aim or finish pays | damage_effects |
| Words mode, Sim view | two small figures, tinted muscle + hooked lines, chip words | the same map | the same Aim and answers | one_map |
| Corner bar / words row | Pace; the 3.3 Aims, each with its edge cost; a hurt place marked "+4" | HitPlaces, PaceAim.edge | pick the Aim | hit_places |
| Shout bar | "Go to the body" (one exchange); COVER <place> when her hurt place is aimed at; on WINDED: Breathe, Tie up | Exchanges offers | answer inside 30 s | damage_effects |
| Corner minute | damage row only with a hurt place: place, job, their Aim, what their corner bought | CornerJobs | 3 points: water / Breathe (2) / clear head / COVER | corner_minute |
| Corner minute | R28 cutman card with the doctor's stop chance; the towel behind its divider | R28, M13 | stop it / send her out | cutman_card |
| Weigh-in modal | THE MEDICAL: pass / fail, why, $300, "Eastside cool until Mon 14" | InjuryCare.medical | none (the result of the earlier choice) | injury_care |
| Result page | DAMAGE tile: the figure with the hurt places tinted + hooked lines (value, shots, round it went, answer used); her FACE as it left the ring | Aftermath, the map (task 12) | "Choose her care" | golden |
| Result page | SORE / knock lines with ranges; "Pencil the next show: Sat <date>"; "Train X next week" lists only unlocked work | InjuryCourse, AmateurBooking | pencil; "Physio's look" / "Scan $300" | injury_care |
| Home | need card when a knock, a SORE night or a squeezed physio opens a choice; Monday page lines: "Right ribs: SETTLE -> REBUILD (Thu)", "The range named itself: bruised" | Needs, InjuryCare.pending | opens the care card | injury_care |
| Home rows, Roster card, Fighter header | portrait with FaceMarks while a face place heals (fades by stage); Condition flag SORE / the knock and its clear date | InjuryCourse (task 13) | click: the care card | face_heal |
| Care card (modal) | a TIMELINE: today, the range as a bar (light / serious courses), the pencilled bout as a pin, each option a coloured path ending at its bout-night value and offer date; text in hovers | InjuryCare | every option of 6.3 that applies | injury_care |
| Fighter page > Overview, BODY row | the figure, tinted place + hooked line, stage bar, clear date | InjuryCourse | to the care card | injury_care |
| Fighter page > Week | locked sessions greyed "ribs, until Mon 23"; SORE night toggle Spar / Pads with its edge price; protector sparring x0.6; Spar anyway (2 in 100); "Back from a knock: Normal reads x1.7" | InjuryCourse.locks, StandDown, TrainingLoad | re-plan | week_locks |
| Fighter page > History | per bout: places that went hurt, the knock | the saved map | none (one line a bout) | golden |
| Fight prep | Keep (medical odds) / Ask to move (yes odds, their gain) / Pull out $300 or $150, each with the bout-night value; "Their corner: knows / may know / does not" | InjuryCare.bout_options, 7.1 | decide; add a COVER line | injury_care |
| Fight prep > opponent file | 7.2's file line, body share | scouting | add a plan line | plan lines |
| Playbook | "Work the <place>", "COVER the <place>" | PlanFight | write and drill | plan lines |
| Fights offers, versus screen | offers dated after the known range; "fit on <date>"; "sooner with a check"; "<club> cool until <date>" | AmateurBooking + 6.4 | check or wait | injury_care |
| Club > People | physio: on call / full-time, the week's slots and who holds them | PhysioSlots | hire, assign | physio_slots |
Removed: the camp card's dead night lines (CampCard.gd:62-64), band words that are not rules, the "third more damage" tooltip.

## 9. NUMBERS
### 9.1 Body arithmetic (3.0 sides / 2.0 stomach, big x1.15 on average, give-back 15% sides / 25% stomach, caps in 3.4)
Landed ON her in 3 rounds: 36 (she wins most exchanges), 63 (level), 90 (loses most). "Mixed" = round 1 at long for half, then the pocket.

| The other corner's plan | 36 | 63 | 90 | 6 rounds, 126 |
|---|---|---|---|---|
| Own game, mixed (her lead-hand side) | 92 | 85 | 79 | 75 |
| Aim Body, mixed | 79 | 64 | 48 | 39 |
| Aim a side, all long (an out-boxer keeps it there) | 79 | 64 | 49 | 42 |
| Aim a side, mixed | 67 | 42 | 17 | 3 (doctor: the referee, a count, or a cover first) |
| Aim a side, all pocket | 65 | 38 | 12 | 1 |
| Aim her REAR side, mixed, COVER from round 2 | 82 | 69 | 55 | 56 |
| Aim her LEAD side (a southpaw's liver), mixed, COVER from round 2 | 74 | 55 | 36 | 30 |
| Aim Stomach, all long | 70 | 48 | 25 | 26 |
| Aim Stomach, mixed | 81 | 67 | 52 | 55 |
Reading: right ribs pay most against a pocket fighter, and against a southpaw even when covered; the stomach is the long-range weapon and
fades in the pocket (it gives back fast); nothing aimed reaches hurt in 3 rounds when she wins most exchanges.

### 9.2 Constants
| Constant | Value | Range | Src |
|---|---|---|---|
| Big share; one-place body share | 15%; 0.55 | 10-20; 0.50-0.60 | TUNE |
| BODY_COST; stomach hurt / critical | 1.2; x1.25 / x1.5 | 1.2-1.6 | CODE Exchanges.gd:38 |
| WINDED hurt / critical (big x2); edge; cap | 8% / 16%; -12; 40% | 5-12 / 12-20; 8-14 | TUNE |
| Guard: left ribs / each side / cap | -6 (-10) / -2 / 12, 20 with tiredness | 4-8 | TUNE |
| Body count; liver counter | clamp(6% x e^(d/12), 2, 15%); clamp(0.6% x e^(d/12) x2 on Push, 0.3, 3%) | 3-10; 0.3-1 | TUNE |
| COVER rear / lead / stomach; edge | 60 / 30 / 40%; -2 | ±10; 1-3 | TUNE |
| Other corner style rule kept | 80% of bells | 70-90 | TUNE |
| Cold iron; doctor stop | x0.85 / x0.7; 35 in 100 | 0.6-0.9; 25-50 | TUNE |
| SORE; sparring on it; pads price | 2-5 days; 10 in 100; -0.3 PEAK / -0.15 BUILD | 5-15; 0.2-0.5 | TUNE |
| Critical draw; stages | 60 / 40; 40/40/20 | 50-70; ±10 | TUNE; ribs TO SOURCE |
| Physio slots; full-time wage; outside visit | 2 / 4; $160; $60 | 130-200; 40-80 | TUNE |
| Physio's look; scan; medical finds a crack | 3 in 4; $300; 50 in 100 | 65-85; 250-400; 35-65 | TUNE |
| Pencil firm; pencil pull-out; club cool after a NO | 10 days out; $150; 4 weeks | 2-6 weeks | TUNE |

### 9.3 Face arithmetic for bar 9b (worst eye; head share 0.80, an eye 25% of head punches, hooks x1.5 on a 40% mix = x1.2, big x1.15)
| Landed on her | 3 rounds 36 / 63 / 90 | 6 rounds 72 / 126 / 180 |
|---|---|---|
| Worst eye at 0.8 a punch | 92 / 86 / 80 | 84 / 72 / 60 |
| Worst eye at 1.1 (today) | 89 / 81 / 73 | 78 / 62 / 45 |
At 0.8 a critical eye needs about 1.6x the average eye share: a tail, about 10-15% of 6-round losers on paper (target 9b). Main measured 86%
(S423 probe), so main's real eye share is higher than 25% (UNVERIFIED): the probe measures it first and sets FACE_HIT from it.

### 9.4 The bars (bounded, two different fighters, population named, each with a control arm)
| # | Bar | On paper |
|---|---|---|
| 1 | Own game, 3 rounds: her worst body place ends 75-95 in 70%+ | 92 / 85 / 79. Control: 1.5 points must fail bar 3 |
| 2 | Aim Body: a side hurt in 10-35% of 3-round bouts, 60%+ of 6-round | 79 / 64 / 48; 39 |
| 3 | Aim a side, uncovered, mixed, 3 rounds: hurt or worse 50-80%, critical 10-30%, doctor 5% or fewer; covered (rear side) from round 2: hurt 5-30% | 67 / 42 / 17; 82 / 69 / 55 |
| 4 | Both sides: 200 bouts, two orthodox boxers, 4+ body shots: LEFT RIBS damaged in 70%+ (main: 0%) | pocket 28% a shot: 73% at 4, 98% at 13 |
| 5 | One truth: every exchange, the 3D list equals the map (count, place, hand), Push, clinch, Counter sense included | by construction |
| 6 | No best Aim: over 6 styles x 2 stances, each of right ribs, left ribs, stomach is best against one and worst against one | 9.1 reading |
| 7 | COVER works and costs: the place loses 30-50% less (rear), the head takes the moved shots, her exchange win rate falls 1-4 points | |
| 8 | Counts and stoppages within ±15% of main; body counts (both kinds) 10% or fewer | 5.2 |
| 9 | Knocks: 4-9 per 100 boxer-bouts at 3x3 (REAL ~6), 60%+ face or head (REAL 72%); SORE 35-65% of losers. 9b, 4-6 rounds: 12-22 per 100 (REAL 17.1) | 9.3 |
| 10 | No care or bout answer wins everywhere: cases weighted by 6.4's counts; each of Full rest, Train around, Keep, Move, Pull out best in a case worth 10%+ and worst in one | 6.3 right / wrong columns |
| 11 | 26 weeks, sensible play: 30-50% of fighters carry a knock at some point | |
| 12 | Aiming at a hurt place is better against 3-4 of 6 styles when she may COVER | +4 against -1.0 to -2.0 and a cover |
| 13 | One head: over 200 bouts the stand-down band, the injury roll's head value and the count input read the same HEAD place in 100% | red on main |
| 14 | Level corners: at equal rating and plan, the AI's body attack on the player and the player's on the AI hurt a side within ±10% | |
| 15 | Physio squeeze: on call, slots short in 20-35% of weeks with a knock, a SORE or a fight week | 27% |

## 10. BUILD ORDER (pure module + test first, then one screen each; files under 500 lines; boxing only)
| # | Task | Seat | Owns | Reads | Test (red on main first) | Gate |
|---|---|---|---|---|---|---|
| 1 | RIBS1: side by hand, rear body hook, 3.0, rear_hook / lead_uppercut count, RIB_HURT_AT deleted (the Aim reads the figure's sum), HURT_AIM_DAMAGE deleted, no body beat swapped | Cursor (brief 4893db40, amended to this row) | BodyMap.gd, PaceAim.gd, ExchangeBeats.gd | | rib_side_test (bar 4), body_map_test rows (1-3) | none |
| 2 | ONEMAP1: the fight owns the map in every bout; caps; give-back; rounding rule | Arena | rules/HitPlaces.gd; LiveRound.gd, BodyLive.gd | | hit_places_test, one_map_test (bar 5) | none |
| 3 | EFFECTS1: one job per place, WINDED, COVER (three scopes, stance), the other corner's styles and minute | Qwen | rules/DamageEffects.gd, rules/OtherCorner.gd; ONE call line in Duels.gd (488/500) | the map | damage_effects_test (7, 12, 14) | none |
| 4 | STOMACH1: the seventh place, body_jab / body_cross, Push taken | Arena; Claude checks clips on the game camera | BodyMap.gd, HitPlaces.gd, beat map | | body_map_test (1-3, 6) | owner's yes (11) |
| 5 | HEADTRUTH1: counts, stand-down AND injury roll read HEAD; in-exchange counts; liver counter; READ counter big | Arena | Knockdowns.gd, BoutNight.gd, StandDown.gd, Injuries.gd head read (:25-28, :181-187) | the map | knockdown_rates_test (8), head_truth_test (13) | before 7 |
| 6 | MINUTE1: four buys, cold iron by itself, doctor on the R28 card | Qwen | CornerJobs.gd, the R28 card's rule file | | corner_minute_test (5.4's three minutes) | ice line: owner's yes (11) |
| 7 | COURSE1: SORE and knocks from the map, ranges, stages, TENDER rule, locks, SORE nights | Arena | rules/InjuryCourse.gd; state/Injuries.gd (after 5) | the map | injury_course_test (9, 9b, 11) | after 5 |
| 8 | CARE1: checks, cares, the medical and hidden crack, pencil, bout options, offers by range, her wish, what they know | Arena | rules/InjuryCare.gd, rules/PhysioSlots.gd | InjuryCourse | injury_care_test (10), physio_slots_test (15) | Keep the date: owner's yes (11) |
| 9 | Screens, one each from a drawn mockup: (a) figures + chips, (b) words / Sim figures + Aim row, (c) minute row + cutman card, (d) result tile + lines + pencil, (e) care card timeline + Home need + Roster flag, (f) Week locks + SORE toggle, (g) Fight prep options + their-corner line + versus date, (h) Playbook lines, (i) physio slots, (j) History line, (k) weigh-in medical | Cursor, one at a time; Claude opens every still | one scene each | | section 8 tests | after 1-8 |
| 10 | GOLDEN: aimed right ribs, WINDED answered, COVER bought over water, critical at the bell, pencil taken, a range, the physio's look, train around, the medical passed on a gamble, the bout kept TENDER, their corner hunts it from film | Claude | tests/golden_damage_path.gd | all | itself, then the .exe | last |
| 11 | FACE3D1: the 3D boxers' faces in the ring: swelling and closing eye, nose blood, the cut, updated per landed punch and at each bell | Ziva (3D); Claude checks stills via still_framing | the face layer on the fight3d boxer (UNVERIFIED which morphs the MetaHuman heads carry: a tint decal is the floor) | the map (task 2): eye, nose, cut values | face3d still pair: fresh vs eye at critical, both head to feet | after 2 |
| 12 | FACERESULT1: the result page shows her face as she left the ring (FaceMarks painted from the final map) | Cursor | the result scene's face card | the saved map (Aftermath) | face_result_test | after 2 |
| 13 | FACEHEAL1: portraits (Home row, Roster card, Fighter header) carry FaceMarks while a face place heals, fading by stage | Cursor | the portrait helper | InjuryCourse values by day | face_heal_test | after 7 |
Riding on task 1: stale comments (TheRead.gd:38-41, PerkFight.gd:16, ClinchRest.gd:19); "Go to the body" opens on a body punch
(RoundScript.gd:39-46); inside fighting keeps body shots (InsideBeats.gd:74-88). Before 7, John: rib layoffs, the body-stoppage rule,
headguard and cuts, the medical's rule. Before the board: the care card timeline and the minute row drawn as a 1920x1080 picture, Ludo paints.

## 11. Settled, and what needs the owner
| Kept | Where settled |
|---|---|
| Bands 55/35/15; unsourced values approximated and tagged | body_damage topic; K67 owner 2026-09-21 |
| The exchange decides; the 3D only shows it | Week 5 |
| The cutman works cuts and swelling; R28 owns the card | owner S322 |
| Head knocks never a choice; 30/90/365 after a stoppage; Durability -2 | S327 |
| Pull out $300; how serious and the fit date shown | Q-S294-46 |
| Heal by knock type, never by age; no training through an injury | J12; Training v6.1 |
| One figure a side, numbers only under 55; hooked lines, no shapes on the chest | S419; owner S437 |
| Durability is chin and body (one stat) | the agreed 10 attributes |

Decided by Claude inside approved features (reported, not asked): counts read the HEAD place; the pencil; offers dated after the known range;
the physio's two hires; the doctor's chance on the R28 card; the other corner's styles; the 6% roll retired for places; Aim costs by place.

THREE REOPENINGS THAT NEED HIS YES (on the board with --attach before tasks 4, 6 and 8 start):
| # | Reopen | One-line reason |
|---|---|---|
| 1 | Six places become seven (the STOMACH) | his S419 "do we only have 2 hit points on the whole body?"; the stomach is the only long-range body weapon (9.1) |
| 2 | "Fight hurt" (ENERGY 10/15/20) becomes Keep the date with a TENDER place and a medical that can miss | the knock and the hit system must meet; a flat ENERGY ignores where she is hurt |
| 3 | Ice on the ribs goes from the minute (his S316 "ice on muscle") | the one study found chest ice no better than nothing; kept version offered: ice on the STOMACH, SHORT OF BREATH off for 1 point |

## 12. Left for later (named so no one builds it by accident)
Hit or miss per punch; jaw and temple; hands as live places; repeat-site weak places and scars; the full cutman and cut location (R28 v4);
a punch-by-punch box; a modelled headguard; moving a championship date; a body-conditioning number apart from Durability.

## 13. Source codes and the critics' brief
| Code | What |
|---|---|
| G132 | body-work research (20% of strikes to the body; a break takes 10-20% of the sting) |
| J12 | injury layoffs (return days, hands, strains) |
| J55 | corner research (minute recovery 13-19%, chest ice, cutman evidence, pro injury rate 17.1) |
| K67 | Kalli: count caps (3.9% a power head punch), finals 90%+ head, approximating to game scale |
| U20 | liver shot timing (collapse up to about 30 s after) |
| M12 / M13 / R28 | the count card / the towel card / the cutman card (passed maps) |
For the critics: score depth and clarity out of 10 for hits, damage and recovery; name what is missing, useless or always best; end with
the list that takes each to 10, most important first; draw your 10/10 (1920x1080 HTML, tools/render_mockup.py), body places as tinted
muscle with hooked lines out of the body, never shapes on the chest.
