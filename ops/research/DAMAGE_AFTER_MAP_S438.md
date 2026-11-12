# DAMAGE AFTER THE FIGHT: what a bout leaves, the care, the next bout (design map, S438, round 2)
Author: Claude (lead designer). The AFTER half of DAMAGE1. v3 (DAMAGE_MAP_S437.md) scored under the bar three rounds running, so
the map is split: the fight half (hits, places in the ring, the minute) is a separate map; this half starts at the final bell.
EVERY NUMBER TABLE BELOW IS PRINTED BY `tools/damage_after_numbers.py` (stdlib Python, fixed seeds, 81 asserts on this map's own
caps and rules, about a minute). Run it to check any table; nothing here is typed by hand. Tags: CODE (file:line), REAL, TUNE.

THE CHAIN: last bell -> the morning after -> each place gets a WORD from its number -> Monday: the care card for a contested
case, or a standing order -> the place heals day by day (or is knocked in training) -> the next offer shows the place and its
RISK against that opponent -> Fight prep: Keep (with Elbows in), ask to move, pull out; Aim her carried place -> the weigh-in
medical -> the place STARTS the next bout at its number (no longer 100).

FOUR CHANGES OF MECHANIC AGAINST v3 (not wording)
1. A place KEEPS ITS NUMBER between bouts and heals day by day. Now a sore rib is a live number the week, the offer, the medical
   and the next bout all read: one number, one rule.
2. CARE IS PER RIB PLACE AND PER SESSION KIND: Train / Protect (body protector, light pads) / Spare, or Rest the week, plus a
   physio session. A worked place still heals (40%), so Train is a real answer, not a freeze.
3. THE OPPONENT PRICES THE PLACE. A carried rib costs 1 in 20 against a head hunter and 1 in 2 against a body puncher (T3b). Her
   weapon is on the card, the offer and Fight prep; a carried place of HERS (seen on tape) can be aimed.
4. NO MEDICAL GAMBLE. Any injured place fails the weigh-in until back at 56; an eye or the nose under 65 fails (visibly swollen).
   The check (guess / physio's look / X-ray) buys a KNOWN fit date, not a way to hide a crack.

## 1. What is wrong today (read in the code)
| # | Today | Code |
|---|---|---|
| 1 | Places are made fresh for every bout; nothing a bout did reaches the next one | BodyMap.gd:21-28 (fresh), :190-193 |
| 2 | Places exist only when the bout was watched in 3D; words mode and Sim carry none | BodyLive.gd:33-36; Injuries.gd:188-191 |
| 3 | The bout injury is ONE 6% roll scaled by the worst place, type by fixed weights, days a flat random range | InjuryRoll.gd:7, :25-35, :20, :95 |
| 4 | The ribs only weigh the roll (x3 under 35); a sore rib is nothing after the bell | InjuryRoll.gd:18-19, :70-80 |
| 5 | The result page says "sore" (Aftermath.gd:86-90) but no rule reads it: no state, no date, no choice | Aftermath.gd:74-99 |
| 6 | One injury timer per fighter; a second, shorter one is dropped | Injuries.gd:242-248 |
| 7 | Fighting hurt is a flat 10 / 15 / 20 ENERGY by days, not by place; two buttons | Injuries.gd:33, :84-102 |
| 8 | The head reads damage x 2.2 (not the HEAD place) for stand-down and the roll | Injuries.gd:28, :187; StandDown.gd:7, :14-15 |
| 9 | The week does not know a place: no session is "on the ribs"; training rolls ignore places | InjuryRoll.gd:136-154; Injuries.gd:208-226 |
| 10 | The physio is a passive x0.75 on days: hire and forget | StaffRoles.gd:12, :19; GymSpend.gd:86 |
| 11 | Offers simply wait past the injury; the S428 1-2 week lead is not built (still 2-4) | Injuries.gd:236, :261; AmateurBooking.gd:10-11 |
So once the bell rings the player has nothing to do about a place unless the 6% roll fires: about twice in 26 weeks.

## 2. Vocabulary (one word per level; use only these)
| Word | Place number | After the last bell (T1) |
|---|---|---|
| fine | 90-100 | nothing to decide (fine is not zero risk: T3b start 90) |
| sore | 56-89 | heals by itself (at 40% on a day a session works it); can be knocked |
| hurt | 36-55 | the same, knocked four times as easily |
| injured | 0-35 | a named injury, light or serious; fails the medical until back at 56 |
- hurt 55 and the 35 line are the settled bands. Injury names (light / serious): Swollen eye / Cut eye; Bloodied nose / Broken nose;
  Bruised ribs / Cracked rib. Places: left eye, right eye, nose, left ribs, right ribs, and the HEAD (stand-down only).
- RISK = the chance the place ends INJURED in the next bout, from its forecast and the opponent's weapon (T3b), said in words:
  1 in 20, 1 in 10, 1 in 5, 1 in 3, 1 in 2, 3 in 4, 9 in 10. FORECAST = the place's number on fight night if she spares it.
- NUMBERS ON SCREEN ONLY UNDER 55 (settled S419), kept everywhere: a sore place shows word + date + risk ("Right ribs: sore, fine
  Thu 12, 1 in 2 vs Mensah"), never "forecast 70". Training lost is shown as what it costs: "Power -0.3 by fight night".
- KNOCK = a training session that takes 25 off a sore or hurt place. Staff by role: Coach, Physio, Cutman, Doctor.

## 3. The mechanic, step by step
### 3.1 The morning after
| Place | Overnight | Real ring, one line |
|---|---|---|
| Ribs | get back 10% of what THIS bout took; a rib still HURT rolls an injury: 10 in 100 x (56 - number) / 20, and drops to 30 | spasm settles in hours; a crack shows the next morning |
| Eyes | lose a further 25% of what THIS bout took | swelling peaks a day after the bout |
| Nose | as at the bell | a broken nose is found by the hands, not by time |
| Head | the HEAD place sets the stand-down, never a care choice (settled) | the doctor, not the coach, decides a head |
An injured place rolls light or serious (30 in 100 from the fight's critical band, 70 from the doctor band; an eye with an open cut
is always serious). The head knock and the hand keep InjuryRoll's bout roll (its head 37 and hand 18 weights of 100).

### 3.2 Healing (one rule). T2, whole days rounded UP (the date shown is the first day the place reads the word; asserted):
| Place | Points a day | Sore 75 -> fine, days | Sore 60 -> fine, days | Light injury 25 -> fit (56) | Serious injury 25 -> fit (56) |
|---|---|---|---|---|---|
| eye | 2.0 | 8 | 15 | Swollen eye 10 (real 5-10) | Cut eye 21 (real 14-21) |
| nose | 2.4 | 7 | 13 | Bloodied nose 10 (real 5-10) | Broken nose 26 (real 21-35) |
| ribs | 1.4 | 11 | 22 | Bruised ribs 16 (real 10-21) | Cracked rib 56 (real 42-56) |
Multipliers: physio hired x1.33 (built), gym plan x1.11 (built S409), a rest week x1.5, together capped at x2.0. An outside physio
session ($50) then ADDS +0.5 for 7 days on top of the cap, on worked and rest days alike (round 1 multiplied it into the cap: worse
than nothing with the physio hired; now it always heals, asserted). The clinic sees the club twice a week: two sessions shared by
all the boxers, so booking one is a choice between them.

### 3.3 What loads a place, and the four answers for a rib
| Place | Sessions that work it | Real ring |
|---|---|---|
| Eye, nose | sparring only | bag and pads never touch the face |
| Ribs | sparring, pads AND the heavy bag | every punch twists the trunk |
| Answer (per rib place) | The sessions | Heals on a worked day | Knock odds | Keeps of the session |
|---|---|---|---|---|
| Train | as planned | 40% | sore 2 in 100 sparring, 1 in 200 pads/bag; hurt 8 in 100 / 2 in 100 | all |
| Protect | pads to the head mitts, sparring in the body protector ($75 once, Club > Money) | 75% | a quarter of Train | 85% |
| Spare | bag -> roadwork, pads -> shadow and footwork, sparring -> technical bag rounds | 100% (not worked) | none | 70% / 70% / 30% |
| Rest (whole fighter) | one week off (gains x0.25, built), heals x1.5, then she spares what is still sore | 150% | none | 25% |
An injured place is always spared (settled). A SORE FACE spars body-only (the coach's fixed rule, keeps 60% of sparring, no card):
a face clears by itself before almost every bout, so the face is shown on the figure and its hover, never as a card row. The fight
week (S428: light, no sparring) works only the ribs.

### 3.4 The next bout reads the number. T3b (the bout model from that start, 600 bouts a cell: injured at the last bell / mean
injury days). A place that starts low loses less a round: 25 from 100 down to 15 from 60 (she guards it, the corner greases it).
| Place | start 100 | start 90 | start 80 | start 70 | start 60 | start 50 | start 40 |
|---|---|---|---|---|---|---|---|
| eye (vs mixed) | 2% / 0.1 | 6% / 0.7 | 17% / 2.3 | 40% / 7.0 | 70% / 14.2 | 92% / 23.4 | 100% / 30.3 |
| nose (vs mixed) | 0% / 0.0 | 5% / 0.6 | 19% / 2.2 | 42% / 5.6 | 66% / 10.4 | 94% / 20.7 | 100% / 27.3 |
| ribs vs a head hunter | 0% / 0.0 | 0% / 0.0 | 0% / 0.0 | 0% / 0.1 | 6% / 1.7 | 30% / 7.4 | 86% / 22.0 |
| ribs vs mixed | 0% / 0.0 | 0% / 0.0 | 1% / 0.3 | 11% / 2.4 | 39% / 9.6 | 77% / 23.0 | 98% / 37.0 |
| ribs vs a body puncher | 2% / 0.3 | 13% / 2.3 | 34% / 6.6 | 57% / 13.4 | 82% / 21.6 | 99% / 41.2 | 100% / 63.0 |
| ribs vs a body puncher, Elbows in | 0% / 0.1 | 2% / 0.4 | 13% / 2.6 | 29% / 6.6 | 64% / 16.6 | 91% / 30.3 | 100% / 49.0 |
Opponent body share: head hunter 10%, mixed 22%, body puncher 45% of what she lands. In words, ribs at 80: 1 in 20 / 1 in 20 /
1 in 3; at 70: 1 in 20 / 1 in 10 / 1 in 2. THE WEIGH-IN MEDICAL: she fails if any place is injured, or an eye or the nose is under
65 (an eye at 60 would be injured 70 in 100: the doctor stops it before the bell). Hurt ribs pass: the coach's call, priced above.
ELBOWS IN FROM ROUND 1 (a Fight prep plan line, the built corner ONE CHANGE moved to the plan): 3 in 10 of her body punches go to
the head. It costs her own body work (counted as 1.5 day-equivalents, about 3 in 100 less chance to win: the fight half measures it).

### 3.5 What a bout leaves. T3 (4,000 bouts; landed on her 36/63/90 at 35/40/25%; opponent mix 35/40/25%):
| Landed on her | Bouts | Ribs sore or worse | Face sore or worse | A place hurt or worse | Injured per 100 |
|---|---|---|---|---|---|
| 36 | 1393 | 63% | 99% | 1% | 0.0 |
| 63 | 1607 | 86% | 100% | 34% | 0.5 |
| 90 | 1000 | 94% | 100% | 94% | 13.8 |
| all | 4000 | 80% | 100% | 37% | 3.6 |
Injuries per 100 bouts: eye 2.4, nose 1.1, ribs 0.4; head knock + hand (InjuryRoll) 3.3; all 6.9 (REAL ~6, Alevras 2022; asserted 4-8).

### 3.6 T4 worked example. Morning after: left eye 91 fine, right eye 84 sore, nose 80 sore, left ribs 71 sore, right ribs 54 hurt.
The next show is in 14 days (a BASE week, then the fight week). Same answer on both ribs; 2,000 runs, costs over 600:
| Her two weeks | Ribs on fight night (mean) | Right ribs injured on the night: head hunter / body puncher | A training knock | Focus stat lost | Cost vs body puncher | Cost vs head hunter |
|---|---|---|---|---|---|---|
| rest | left 96, right 79 | 1 in 20 / 1 in 3 | 0 in 100 | 0.7 | 10.8 | 6.4 |
| rest + physio session ($50) | left 96, right 83 | 1 in 20 / 1 in 3 | 0 in 100 | 0.7 | 10.3 | 7.2 |
| train | left 83, right 64 | 1 in 20 / 3 in 4 | 20 in 100 | 0.1 | 15.6 | 4.4 |
| train + physio session ($50) | left 82, right 68 | 1 in 20 / 3 in 4 | 14 in 100 | 0.1 | 14.7 | 3.5 |
| protect | left 87, right 70 | 1 in 20 / 1 in 2 | 4 in 100 | 0.2 | 10.8 | 2.6 |
| protect + physio session ($50) | left 87, right 74 | 1 in 20 / 1 in 2 | 4 in 100 | 0.2 | 10.2 | 3.3 |
| spare | left 91, right 74 | 1 in 20 / 1 in 2 | 0 in 100 | 0.3 | 9.6 | 3.2 |
| spare + physio session ($50) | left 91, right 79 | 1 in 20 / 1 in 3 | 0 in 100 | 0.3 | 8.5 | 3.9 |
Reading: against a body puncher, Spare + a session (next best 1.1 higher); against a head hunter, Protect (0.5 lower than Spare).
Same bruise, two answers: the opponent's weapon is the reason. Against the body puncher the card OPENS (hurt rib, 14 days, body
puncher is a contested situation, T5b); against the head hunter the standing order (Train) acts and costs 1.8 here, which is why
orders are editable ("hurt + 14 days + head hunter -> Protect").

### 3.7 The cost model behind the script (design only; the game never shows a cost or a "best")
DAY-EQUIVALENTS (a day of a full training week = 1): training lost x her goal's weight (no goal 0.6, on track 1.0, AT RISK 1.6:
the goal chip); $50 = 1 (T7 also $20 / $120); a day out injured = 1; each point under 90 at the first bell 0.04; injury days on the
night from T3b against that opponent (or Elbows in, + its cost, whichever is less); a MEDICAL FAIL = $300 pull-out + a lost bout 6 +
every injury day still to come (round 1 forgot the days, so a knock that injured a rib made Train look cheaper); no bout booked =
half a bout's price against a mixed opponent at day 14; overruling her wish 1 (morale -5, built). The game shows the INPUTS (word,
date, risk vs this opponent, knock odds, stat lost, price, her wish), so the choice is read, never solved on screen.

## 4. The decisions (when, options, costs, why NOT; all numbers from the script)
| Decision | When it appears | Option | What it costs | Why you would NOT pick it | Best in |
|---|---|---|---|---|---|
| Monday care card (per rib place) | a contested situation (T5b) where the worst answer costs a day+ more than the best | Train | knocks (T3.3), heals 40% on worked days | vs a body puncher a hurt rib reaches the night at 1 in 2+ | 50% |
| | | Protect | 15% of rib sessions, $75 protector once | slower than Spare: right ribs 70 vs 74 (T4) | 10% |
| | | Spare | 30% of pads/bag, 70% of sparring | Ring IQ and combo work wait a week; a goal at risk pays 1.6x | 10% |
| | | Rest the week | 75% of a week's gains | a whole week for a rib a mixed opponent barely touches | 30% |
| Physio session | on the card, per place; 2 a week for the club | +0.5 healing for 7 days | $50 and a slot another boxer may need | worth it only when the rib's risk drops a band (24% of card cases) | 24% |
| Standing orders | Coach card; pre-filled with each uncontested situation's usual best | edit an order | the order is wrong 13% of its cases, 0.17 a time | an order that suits a head hunter fails a body puncher | (policy) |
| The next offer | an offer while a rib is not fine | Accept | the bout starts at the forecast, priced by HER weapon | sore rib vs a body puncher: Pass wins 74% | sore: 71 / 62 / 26% vs head hunter / mixed / body |
| | | Pass (built, free) | the next offer about 14 days later: 4.2 | a head hunter barely touches it | (the rest) |
| Fight prep | a booked bout at 1 in 5 or worse, or a medical fail | Keep (+ Elbows in, + Protect) | the night's risk; Elbows in 1.5 | | keep 50 / 77 / 53% |
| | | Ask to move it 14 days | yes 6 in 10; a NO cools that club 4 weeks AND she now goes to the body | 1.5 for asking; her Heart 65+ wants this bout | (the rest) |
| | | After a NO: keep / pull out | pull out $300 (settled) + 14 days | $300 = 6 | keep 52% / pull 48% |
| Aim her place | Fight prep, when the opponent's last bout (filmed) left a place sore | "Aim: the right eye" plan line | fewer punches at our best targets (fight half) | a place at 85 is half-healed | T6b |
| The check | an injured nose or rib | guess / look $60 / X-ray $250 | T7 by the club's cash | tight club: the X-ray is weeks of wages | 67/25/8, 28/50/22, 6/36/58% |
Asserted: on the card no answer best in over 70% or under 8%; the same fighter on the same day gets a different best answer vs a
head hunter than vs a body puncher in 45% of cases; Accept moves 45 points between opponents; after a NO both keep and pull win.
Her wish (built): Heart 65+ wants to fight, low Composure wants rest; overruling is morale -5 (built), now a tile on the card.

### 4.1 T5b: is the Monday choice a lookup? (situations the player can see; usual best, its share, n; ORDER = a standing order)
| Worst rib | Days to the bout | vs head hunter (none: unknown) | vs mixed | vs body puncher |
|---|---|---|---|---|
| sore | none | - | train 88% (83) ORDER | - |
| sore | 7-10 | train 59% (165) | train 56% (157) | train 41% (143) |
| sore | 14 | train 79% (85) ORDER | train 77% (83) ORDER | train 49% (80) |
| sore | 21 | train 95% (86) ORDER | train 92% (87) ORDER | train 53% (87) |
| hurt | none | - | train 89% (19) ORDER | - |
| hurt | 7-10 | rest 57% (37) | rest 64% (36) | rest 95% (44) ORDER |
| hurt | 14 | train 85% (20) ORDER | train 80% (15) ORDER | rest 53% (19) |
| hurt | 21 | train 82% (22) ORDER | train 76% (21) ORDER | train 53% (17) |
Where one answer wins over 70%, the player sets it ONCE as a standing order instead of meeting 42 cards; the card opens only where
the rib's number, her goal chip, her wish and the session price still decide it. Of 1,430 situations: 124 too close to matter (the
coach picks), 565 standing orders, 741 cards (Train 50%, Rest 30%, Protect 10%, Spare 10%).

## 5. THE MENU TABLE (every screen it appears on, and what each is wired to)
Body pictures: the place is the TINTED MUSCLE on the game's own figure with a HOOKED LEADER LINE out of the body to its name, word,
date and risk (BodyCallouts.gd, CalloutLine.gd); never blobs on the chest. New pure module: `scripts/rules/PlaceCare.gd`.
| Screen | Element | Wired to | The act | Test |
|---|---|---|---|---|
| Result page, DAMAGE tile | figure: each carried place tinted, hooked line to "Right ribs: hurt 54, fine Mon 30"; injured names the injury and its range | AfterFight.gd -> PlaceCare.morning(map) -> f["places"]; Aftermath.damage | "Plan her week" opens the care card or names the order | place_care_test, golden |
| Home, need card | "Plan around Ana's right ribs" on a Monday the card opens (contested only) | Needs.gd <- PlaceCare.card_open(f, day, orders) | opens the care card | golden |
| Care card (new modal) | per RIB place: word, fine date, risk vs the booked opponent (her weapon tile); four answers each with risk on the night, knock odds, "Power -0.3 by fight night", goal chip line; physio session per place with slots left this week; her wish tile ("Ana: wants to fight; overrule -5 morale") | PlaceCare.options(f, day, opp) -> f["care"] | pick Train / Protect / Spare / Rest; book a session; "Make it my order" | care_card_test |
| Care card, injured place | the range as a bar (light / serious fit dates), the check: guess / look $60 / X-ray $250 | PlaceCare.check(f, place, kind) | pick a check | care_card_test |
| Coach card > Standing orders | one line per situation: "hurt rib, 7-10 days, body puncher -> Rest"; pre-filled, editable | PlaceCare.orders (saved on Career) | edit | care_orders_test |
| Fighter page > Week | sessions that work a carried place tagged "works the right ribs"; Protect / Spare swaps shown | PadWeek / WeekPlan read PlaceCare.session(f, dow) | edit as today | week_spare_test |
| Week review (modal) | "Order: Protect on the right ribs (hurt, 14 days, head hunter)"; "Sparring Thu: right ribs knocked, 51 -> 26" | WeekActual log <- PlaceCare | none (cause shown) | place_care_test |
| Fighter page > Overview, BODY row | figure with hooked lines, word, fine date; faces on hover | f["places"] | opens the care card | golden |
| Roster cards, Condition tile | the worst carried place: "Right ribs sore, fine Thu 12" | RosterCards.gd <- f["places"] | opens her page | roster_tile_test |
| Fights > offer card | "On fight night: right ribs sore, 1 in 2 vs Mensah (body puncher)"; her carried place if filmed: "Mensah: right eye sore, cut 9 days ago" | OfferCard.gd <- PlaceCare.risk(f, bout_day, opp) | Accept / Pass (built) | offer_forecast_test |
| Fight prep | risk per place; at 1 in 5+ or a medical fail: Keep / Ask to move / Pull out $300; plan answers "Elbows in from round 1" and "Aim: her right eye" | FightPrep.gd <- PlaceCare.bout_options; Injuries.pull_out; new Injuries.ask_move; Playbook plan lines | decide; write a plan line | bout_options_test |
| Rival file | her carried places from her last filmed bout, with dates | World rival record <- her own f["places"] | "Write it in the plan" | rival_places_test |
| Club > Money | body protector $75 (once); physio sessions this month | GymSpend.gd lines | buy | money_lines_test |
| Weigh-in modal | THE MEDICAL: pass, or "fails: right eye 61" with $300 | WeighIn.gd <- PlaceCare.medical(f) | none (the result of earlier choices) | golden |
| Fight (first bell) | the figure starts from the carried numbers; Elbows in / Aim lines live | the fight half reads f["places"] and the plan | (fight half) | one_map (fight half) |
| History | per bout: places that ended hurt or worse, any injury | BoutHistory.gd <- the saved morning map | none | golden |
Removed: the "Fight hurt" button and its flat 10/15/20 energy (Injuries.gd:33, :93), once his yes (9, item 2) comes.

## 6. Numbers (from the script; TUNE ranges for the probe)
| Constant | Value | Range | Src |
|---|---|---|---|
| Ladder; face medical line | fine 90, sore 56, hurt 36; face under 65 fails | 60-70 | settled 55/35; SHAPED |
| Points a day eye / nose / ribs | 2.0 / 2.4 / 1.4 | ±20% | REAL layoffs (T2 asserts) |
| Heal on a worked day: Train / Protect | 40% / 75% | 30-50 / 65-85 | TUNE |
| Keeps: Protect / Spare pads-bag, sparring / Rest | 85% / 70%, 30% / 25% | | TUNE; Rest built |
| Knock: sore spar / other; hurt spar / other; Protect; drop | 2 / 0.5; 8 / 2 in 100; x0.25; 25 | ±50% | TUNE |
| Rest, cap; physio session; clinic slots | x1.5, x2.0; +0.5 for 7 days, $50; 2 a week | $40-80 | REAL price (GBP x1.25) |
| Opponent body share; Elbows in moves; its cost | 10 / 22 / 45%; 3 in 10; 1.5 | 35-50; 2-4 in 10 | TUNE (fight half) |
| Carried place round cap | 25 from 100 down to 15 from 60 | 12-18 | TUNE (fight half) |
| Goal weight; wish overrule | 0.6 / 1.0 / 1.6; 1.0 | | morale -5 built |
| Ask to move: yes; Fight prep opens at | 6 in 10; risk 1 in 5 | 4-7 | TUNE |
| Card opens: worst - best; contested | 1 day-equivalent; no answer over 70% in the situation | 0.5-2 | TUNE |
T8 (how often, 26 weeks, 3 boxers, a bout every 18 days = 30 bouts; each Monday re-checked from that day's places):
| Decision | Times | Why |
|---|---|---|
| The Monday care card (Train / Protect / Spare / Rest, the physio) | 20 | contested situations only |
| A standing order acts instead (the week review says what it did) | 22 | editable on the Coach card |
| The offer shows a carried rib with its risk (Accept / Pass) | 11 | an offer while a rib is not fine |
| Fight prep opens Keep / Ask to move / Pull out | 6 | a booked bout at 1 in 5 or worse |
| An injured place: the check | 1.1 | 3.6 per 100 bouts |
| Training rib knocks under the chosen answers | 1.2 | the KNOCK table, not InjuryRoll |
(v3: the recovery half met the player about twice in 26 weeks. Now about 38 real decisions plus 22 orders that act on their own.)

## 7. The hand-over to the fight half
IN, at the final bell: the number of each of the six places (0-100), the cut flag per face place, the head-stoppage flag, the
HEAD place, which places ended hurt or worse. OUT, at the next first bell: f["places"] = {place: {v, word, injured, sev, known}};
the fight starts each place at v. known = their corner knows the place (it ended hurt or worse in a filmed bout, it shows at the
weigh-in, or a NO to "ask to move"); a known rib makes a body puncher aim it.
FINDINGS FOR THE FIGHT HALF (re-measure with its own probe):
1. The carried round cap (25 from 100 down to 15 from 60) is what keeps T3b near real; without it an eye from 60 was injured 82 in
   100. If the fight half moves the caps, T3b and every share above move.
2. Elbows in is counted at 1.5 day-equivalents of win chance; Aim a carried eye at 20% of face punches takes her eye from 28 to 58
   in 100 (start 75, T6b). Both are guesses until the fight half measures who wins.
3. The opponent's body share (10 / 22 / 45%) now drives the after half; the fight half must hand over her weapon as one of these.
4. Rib injuries per 100 bouts fell to 0.4 (eyes 2.4) with the new body shares; the real split (ribs 10, cuts 20, nose 15 of 100
   injuries) wants ribs nearer 0.6.

## 8. Build order (pure module + unit test first, one screen per task, files under 500 lines, boxing only)
| # | Task | Seat | Owns | Test (red on main first) | After |
|---|---|---|---|---|---|
| 1 | PLACECARE1: ladder, morning, heal a day (worked 40% / protect 75%), loads, the four answers, knock roll, risk vs opponent, medical, check, orders | Qwen | scripts/rules/PlaceCare.gd (new, <400) | tests/place_care_test.gd copies T1, T2, T3b rows, the medical rules, the knock order | none |
| 2 | CARRY1: f["places"] written the morning after (every bout), healed each day, knocked in end_week; InjuryRoll keeps head + hand only | Arena | state/Injuries.gd (265), InjuryRoll.gd, one call in Injuries.day_tick | tests/carry_places_test.gd: a hurt rib on Saturday is sore on Wednesday and starts the next bout below 100 | 1, the fight half's ONEMAP |
| 3 | Care card modal + Home need + standing orders on the Coach card | Cursor | ui/modals/CareCard.gd, Needs.gd line, CoachOrders.gd | care_card_test, care_orders_test | 2 |
| 4 | Week tags, Protect / Spare swaps | Cursor | WeekDay.gd / PadWeek.gd read PlaceCare.session | week_spare_test | 2 |
| 5 | Result DAMAGE tile + History line | Cursor | AftermathTiles.gd, Aftermath.gd, BoutHistory.gd | place_care_test rows | 2 |
| 6 | Offer risk + Fight prep options + Elbows in / Aim plan lines + rival places + ask_move | Cursor (screens), Qwen (Injuries.ask_move) | OfferCard.gd, FightPrep.gd, Injuries.gd, rival file | offer_forecast_test, bout_options_test, rival_places_test | 2 |
| 7 | Weigh-in medical + Roster tile + Money lines | Cursor | WeighIn.gd, RosterCards.gd, GymSpend.gd lines | roster_tile_test, money_lines_test | 2 |
| 8 | GOLDEN: a body puncher leaves right ribs hurt, the card opens Monday, Spare + session, the next offer shows "1 in 3 vs <name>", Keep with Elbows in, the medical passes, the next bout starts the ribs at the forecast, History shows it | Grok Dev | tests/golden_care_path.gd | itself, then the .exe | 3-7 |
Every screen task starts from a drawn 1920x1080 mockup (the care card first), Claude opens every still. New features ship ON
(GameSwitches.GAME_ON); plain --script tests stay the OFF arm. Before 2: John sources rib layoffs and England Boxing's medical rule.

## 9. Needs the owner's yes (on the board with --attach before task 2; none of this is built as fact before his answer)
| # | Reopen | One-line reason |
|---|---|---|
| 1 | A fourth word, SORE (56-89), inside the settled "fine over 55" band; fine narrows to 90+ | without it a bout leaves nothing to decide |
| 2 | "Fight hurt" (Q-S294-46: flat 10/15/20 energy) is replaced by the carried number + the weigh-in medical | the hurt place itself should start the bout |
| 3 | The 6% bout roll stops deciding eyes, nose and ribs; their injuries come from the place's number (head and hand keep it) | one truth: the place watched is the place injured |
| 4 | Money lines: physio session $50 (2 a week for the club), body protector $75 once, X-ray $250 | new spending (his call); the built physio hire stays |
| 5 | Ask to move a bout 14 days (yes 6 in 10; a NO cools the club and their corner learns the place) | a new rule between clubs; never a championship round |
| 6 | Standing orders for care on the Coach card | a new kind of player rule (policy set once, acted on by the coach) |
| 7 | The weigh-in doctor fails an eye or the nose under 65 (today: hurt only, under 56) | a stricter medical than round 1; real amateur doctors stop a closing eye |
| 8 | (from the fight half) the STOMACH as a seventh place: after the bell sore only, 1 day | his S419 "do we only have 2 hit points on the whole body?" |
Decided by Claude inside the feature (reported, not asked): the morning step, heal rates, the four answers, the knock rule, the
risk words, the card opening rule, Elbows in and Aim as Fight prep plan lines, the goal weight and the wish tile.

## 10. Left for later (named so no one builds it by accident)
Hands as places (the hand injury stays InjuryRoll's roll); the BJJ athlete's strains (her bouts carry no places); the habit "hides
pain" (her reported word reads one band better until the physio looks); per-session control finer than the four answers (spare only
Thursday); the cutman working on an eye the morning after; pro camps (BUILD / PEAK sparring twice: re-run T5 first); scars; healing
faces in 3D and portraits; headguard modelling; repeat injuries to the same rib. The hired physio stays one number (built).
For the critics: score depth and clarity for the AFTER half only; name what is missing, useless or always best; end with the list
that takes it to 10, most important first; check any table by running `python tools/damage_after_numbers.py`.

## Changed in round 2
- Care is per rib place with four answers (Train / Protect / Spare / Rest); a worked place heals at 40% (was 0), Protect at 75%.
- The opponent's body share (head hunter / mixed / body puncher) is in the bout model; risk is shown in words vs that opponent.
- Fight prep gains "Elbows in from round 1" (with its cost) and "Aim her carried place" (rival file, offer, plan line; T6b).
- A medical fail now costs the injury days still to come; no bout is priced as half a bout, not a flat left-over rate.
- The carried round cap slides 25 -> 15; the eye's morning swelling counts only this bout's loss; the face medical line is 65.
- The physio session ADDS +0.5 on top of the cap and heals on worked days; 2 clinic slots a week for the club; $50.
- Standing orders replace lookup Mondays; the card opens only in contested situations; T5b shows every situation; T8 re-checks
  each Monday and counts knocks from the KNOCK table.
- Faces leave the card (body-only sparring rule, hover); training lost is shown as stat points; her wish and goal chip are on it.
- Days are rounded up (ceil) and the first-fine-day is asserted; numbers-under-55 kept: offers show word + risk, no forecast number.
- Fight prep opens on the night's risk (1 in 5+), not on a forecast line; T4 runs 2,000 times and shows two opponents.
