# DESIGN_COACHDEEP2 - deep coaches v2: the owner's 24 answers in the map (S539)

Owner S539: coaches "like football manager ... to tighten and improve the core loop"; "more deep , what he know how he mix with
fighters and different personalities , his playbook , needs proper attributes and personality"; after the grilling: "Yes,
start v2". His 24 answers: ops/research/COACHDEEP_GRILL_S539.md (they win over v1, DESIGN_COACHDEEP1.md). Task:
ops/research/TASK_COACHDEEP2.md. Probe: tools/coachdeep2.gd + tools/coachdeep2_rules.gd -> docs/COACHDEEP2_RESULT.md.
Tags: CODE = read on 2026-11-23 at the file:line named; NEW = this design; ESTIMATE = a probe number; Qn = his answer n.

## 0. Status: the probe FAILS - the money under the coaches must change first
docs/COACHDEEP2_RESULT.md: bars (b) chemistry moves a line, (d) a thought-out week beats "everyone the same", (g) chemistry
is not the solved rule, (i) a hire pays in one club size and not the other - PASS. Bars (a), (c), (f2), (h) FAIL on one
cause: at the game's prices a class night ($117 + members, CODE ClubDeal.gd:30, ClubClasses.gd:17) is worth more than a
boxer's pad evening, and an amateur on the club's $250 stipend (CODE GameMoney.gd:9) returns $112 a week in ticket cuts
(CODE BoutRules.gd:113, one bout in 4 weeks). The best plan runs every evening as a class and lets the boxers leave. The
change list (result s5) goes before any build: price the boxer (an owner money call), class nights with falling returns,
a coached evening worth more than a stat decimal, a roster where no one coach is best.

## 1. What the game has today (CODE)
- One coach: `Career.coach` one Dictionary (scripts/state/Career.gd:23); `Sim.hire` (scripts/state/Sim.gd:475);
  `Career.extra_coaches` an evening-coach count (Career.gd:69) at StaffRoles.EVENING_WAGE $280 (scripts/rules/StaffRoles.gd:56).
- The coach rows: `Data.COACHES` Reid $450 "three evenings a week", pads 74, and Hale $1,090 (scripts/state/Data.gd:33-40).
- Coach evenings: a pad evening = 2 places, a class night instead pays `ClubDeal.class_cash` n x $117
  (scripts/rules/ClubDeal.gd:30-31, DuesLevers.CLASS_WEEKLY 350 / 3, scripts/rules/DuesLevers.gd:20) and 0.0625 new members
  (ClubClasses.MEMBER_A_NIGHT, scripts/rules/ClubClasses.gd:17); the coach's usual class money $350 a week stays on top
  (GameMoney.CLASSES_WITH_COACH, scripts/rules/GameMoney.gd:10, :44). Asks: ordinary 3, fight week +2 (ClubDeal.gd:12);
  the deal (ClubDeal.gd:69).
- Members: the walk to `Membership.natural_members` (scripts/rules/Membership.gd:38) a capped step a week (:45); every coach
  carries 40 members, volunteers 30 (StaffRoles.gd:54-55, `coaching_cap` :60); dues $35 a month (GymBills.gd:7).
- Training: `CoachAreas.lift` (scripts/rules/CoachAreas.gd:63-64) against ALONE_FACTOR 0.6 (:8); `MoveMastery.gain`
  (scripts/rules/MoveMastery.gd:62) with the pad skill read by `DrillWeek.pad_skill` (scripts/state/DrillWeek.gd:159).
- The fight read: `BoutRead.chance` takes the coach's rating (scripts/rules/BoutRead.gd:383) and reads the boxer's own
  combos' mastery (:196); `CoachPlan.write` (scripts/rules/CoachPlan.gd:65), one card at 50, two at 70 (READ_AT :27);
  film opens the file (`OppFile.tape`, scripts/rules/OppFile.gd:135).
- The boxer as a person: FighterProfile.TRAITS (scripts/rules/FighterProfile.gd:7), TRUST by mood (:39), morale (:147).
- Loyalty: weekly moves "short" -3, "short_running" -6, "full_week" +1 (scripts/rules/Loyalty.gd:46), "teammate_left" -2
  (:57), leaves under 25 after two talks (:27, :202), the pro share (:230). Leaving: reputation -2 / -5 ranked
  (scripts/state/Leaving.gd:27-28), team-mates under Settled (:101), Monday check (:128); the stipend stops with her.
- The other corner today is a style: `WeighMiss.answer` reads the opponent's style (TOUGH, scripts/rules/WeighMiss.gd:16,
  :20); the pop-up says "THEIR CORNER ANSWERS" (scripts/ui/modals/WeighIn.gd:46).
- Staff screens list Data.COACHES (scripts/ui/StaffCard.gd:53, scripts/ui/OfficeDesk.gd:356); your own card (StaffCard.gd:108).
- Your background already gives one edge (`HeadCoach.free_tells` :65, `cut_kcal` :79, scripts/rules/HeadCoach.gd).

## 2. The coach (NEW, by his answers)
### 2.1 You (Q1, Q19)
The owner and head coach, no ratings of your own on the card. You can cover 2 evenings a week as a plain coach, every rating
8 (rules copy: YOU). A one-coach gym runs; hiring is how it grows. Your evenings cost nothing and take nothing from the office.
### 2.2 Eight ratings 1-20 (Q4, Q8), each on a rule that exists
| Rating | Changes | Wired to (CODE) |
|---|---|---|
| Pads / technique | moves and combos learned on his evenings | MoveMastery.gain coach_skill (MoveMastery.gd:62) per boxer, not per club (DrillWeek.gd:159) |
| Conditioning | fitness gains on his evenings | CoachAreas.lift conditioning / strength (CoachAreas.gd:63) |
| Tactics | plan cards read, the call between rounds | CoachPlan.write rating (CoachPlan.gd:27, :65); BoutRead.chance coach (BoutRead.gd:383) |
| Cutman | guard and cuts between rounds | the corner's recovery (StaffRoles.CUTMAN_KEEP, StaffRoles.gd:20) - PHASE 1 shows it, PHASE 2 reads it |
| Weight management | the miss chance, the cut's toll | HeadCoach.cut_kcal (HeadCoach.gd:79) upstream of WeighMiss (WeighMiss.gd:20) |
| Film / scouting | tells opened before a bout | OppFile.tape sessions (OppFile.gd:135): 8+ one, 14+ two (ESTIMATE); one fewer with no fight-week evening |
| Motivation | weekly morale, trust in the corner | FighterProfile morale (FighterProfile.gd:147), TRUST (:39) |
| Teaching beginners | boxers under 21 learn faster; class nights keep members | the learning multiplier (NEW); ClubClasses members (ClubClasses.gd:17) x his teaching / 10 (ESTIMATE) |
x5 = the game's 0-100 scale (Reid's pads 74 reads 15).
### 2.3 What he knows (Q9) and his playbook (Q10)
2-3 specialties: the moves he teaches at full pads (a move outside them drills at 85%, ESTIMATE) and the style he reads best;
shown on his card with a hover. His playbook is one of the six styles; a boxer of his style learns faster (+15%) and his plan
for her reads better (+20%); pulled against it, the same minus (FIT table in the rules copy, ESTIMATE). The card shows "his
plan for her" - the arrows CoachPlan.write would write at his tactics and fit.
### 2.4 Personality (Q11) and chemistry (Q12)
Five traits 1-20: temper, patience, discipline, ambition, loyalty. Chemistry = his traits against hers (FighterProfile.TRAITS)
plus weeks together (the bond, +0.01 a week to +0.25). A word on both cards - bond / fine / clash - with the reasons on hover
("he shouts, she folds"), shown only after 2 weeks together. It moves learning (x 1 + 0.30 chemistry), morale (3 a week) and
loyalty (1 a week) - sizes v1's, kept by bar (g): pairing by chemistry was best in 2 of 10 cells at every size tried.
### 2.5 Time (Q13, Q14)
Five evenings a week a coach; an evening = up to 2 boxers on pads, or 1 class. You assign them in the week plan; a boxer with
no coach that evening trains alone at the lower gain. Every evening is a trade between class money and a boxer's progress -
the trade the probe found one-sided at today's prices (s0).
DECISION (code v his words): he said "a local coach covers his wage with one class night (~$350)". In the code $350 is the
class WEEK (three nights at $117, DuesLevers.gd:20, ClubDeal.gd:30-31). v2 keeps the code's $117 a night; a local at
$150-300 covers his wage with three class nights. Said here so he can overrule it.
### 2.6 Wages by band (Q3, Q17)
Weekly, scaled with ratings: local $150-300, solid $400-600, a known name $800-1,100 (Reid $450, Hale $1,090 today). Probe:
the $200 local pays in both club sizes (+33 and +57 lines over two years), the $480 film coach pays in the big club (+19) and
not in the small one (-12), the $1,000 known name pays in neither (-85, -46). The COACHHIRE1 trap (a hire only closes the gym
sooner, docs/COACHHIRE1_RESULT.md) is not back, but a $200 coach paying everywhere is too easy: it rides on the class nights.
### 2.7 Luke Reid converted (Q18)
The starting coach stays: pads 15, the rest 9-11, playbook Out-boxer, patient (14), steady temper (7), loyalty 14, $450, five
evenings. Probe finding: Reid is the best coach for both out-boxers in every cell - pads decide 0.7 of the week. v3 must make
the area weights follow the boxer, or Reid solves the pairing for most of the club.
### 2.8 Finding, keeping and growing coaches (Q15, Q20, Q21, Q22) - designed, not probed
- The list: monthly; local coaches, now and then a known name on a big wage, later your retired boxers; a paid one-week trial
  shows chemistry (price: a week's wage, ESTIMATE).
- Notice and matching (Q20): low loyalty + a rival offer = 2 weeks' notice; you can match (a raise: his wage +15%, ESTIMATE).
  An ambitious coach (14+) asks for a raise after a title or a run of 4 wins. Poaching by rival gyms waits for careers (Q7).
- Courses (Q21): three levels (England Boxing coaching levels): money + 2 of his evenings a week for 2-4 weeks; +1-2 in the
  ratings you pick; lifts his ceiling. Price per level and its evenings are an ESTIMATE for the probe after the money fix.
- Ceilings (Q22): each rating has one, shown in words ("could reach 15 in pads"), exact after a season with you. Years with good
  boxers move him slowly (Q5).
### 2.9 The other corner (Q6, Q16, Q23) - PHASE 2, on the same model from day one
Every club has a coach. Your coaches and candidates show exact ratings; an opposing card starts "?" and each rating turns
exact once learned: film -> tactics, film; a fight against him -> cutman, motivation; reputation -> his best rating from the
start; his boxer's weigh-in -> weight management; his playbook's first clue is his fighters' records. "THEIR CORNER" on the
weigh-in pop-up (WeighIn.gd:46) links to his card; WeighMiss.answer reads his temper instead of the TOUGH styles (WeighMiss.gd:16).

## 3. The five places it shows (Q24) - the menu table
| Menu | What shows | Wired to |
|---|---|---|
| Club office -> Staff tab (StaffCard.gd:53, OfficeDesk.gd:356) | FM-style table: one row a coach, the eight ratings, wage, evenings used / free, chemistry words with his boxers | the coach rows (new fields), rules chemistry |
| The coach card (from the table, the week plan, a boxer card, the fight) | ratings, specialties (hover), playbook + "his plan for her", personality, ceilings in words, his boxers, notice / raise lines | Data coach row; CoachPlan.write (CoachPlan.gd:65) |
| The week plan | drag coaches onto boxers' evenings and onto class nights; "alone" where nobody is; the class money and the boxer left short, side by side | the assignment -> pad skill per boxer (DrillWeek.gd:159), ClubDeal.deal (ClubDeal.gd:69), Loyalty "short" (Loyalty.gd:46) |
| Boxer cards | her coach, the chemistry word + hover reasons, the bond in weeks | rules chemistry / bond |
| The fight | your corner's tactics (plan cards) and cutman (between rounds); "their corner" links to the opposing card | CoachPlan rating, StaffRoles cutman, the opposing card (PHASE 2) |
Golden path (when built): hire a coach from the list, put him on two boxers' evenings and one class, play the week, see the
chemistry word after two weeks and the learning line move, fight with his plan, open their corner from the weigh-in.

## 4. Phase plan (Q7)
1. YOUR COACHES: the money fix first (s0, result s5 items 1-2), then the coach rows, YOU's 2 evenings, Reid converted, five
   evenings a coach, the week plan's coach drag, chemistry, wages by band, the Staff table and card. Probe v3 before build.
2. THE OPPOSING COACH: the same model, the "?" card learned (Q16, Q23), their weigh-in answer, their read speed, cutman.
3. COACH CAREERS: the monthly list with known names and retired boxers, notice and matching, courses, ceilings, poaching.

## 5. Cut list
- One overall "rating": not shown; kept only for old readers (Data.gd:33 note).
- CoachMarket / CoachFit (removed S538): not back.
- A coach best at everything: no - the probe shows Reid already is for the out-boxers; v3 fixes it by area weights, not by
  weakening him.
- The bag-rate rule for boxers on a class night (ClubClasses.gd:5-6) goes: v2's evening is pads OR a class, not both.
- Ambition / loyalty effects before PHASE 3 except notice and raises (Q20 asks for those in phase 1).

## 6. Critics on v1 (Kalli SQ302, Dola SQ303)
Not landed when v2 was written (`seat_queue.py list`: both "sent", no answer file). When they land, each "to reach 10" item is
answered here (done / changed / refused with why). Note: Kalli's queue dropped SQ293-295 on "text exceeds the maximum length";
the v1 brief is 84 KB, so SQ302 may need a shorter brief.
