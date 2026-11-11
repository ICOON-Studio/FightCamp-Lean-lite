# AMATEURWEEK1 design map: amateur bouts need no camp, they need a fight week (S429)

Status: DRAFT for critics. Not on the operator's board until two fresh critics score its depth 7 or more.
Source: the operator's S428 scope change (ops/research/SCOPE_FOUR_FIGHTERS_S428.md): "make it so amateur fights do not require
fight camp and can happen within a week". Real world (J_MATCH1): the 8 to 12 weeks is the SHOW's permit; the bout sheet closes
24 hours to 3 days before; a senior amateur can box about 18 times a season.
Measured in the game (HANDSPROBE1): the mean camp today is 3.9 weeks from offer to bell, and only 6% of camps own every answer
at taper. So today's amateur camp is already too short to be a camp and too long to be a fight week.

## 1. What changes
- An amateur offer arrives 1 to 2 weeks before the show (today 2 to 4: AmateurBooking LEAD_WEEKS_MIN / MAX).
- No camp for an amateur bout: no camp page, no camp level, no peak goal. Camps stay for pro fights, title fights and the
  nationals, where the long build is the point.
- The last seven days before the bout are the FIGHT WEEK. It has four small jobs, and each one costs something else.
- The fighter boxes with what is already in the hands. A new punch takes two weeks of pads to be usable (MoveMastery 30), so
  nothing learnt after the offer arrives in time. The building happens in the weeks BETWEEN fights; the fight week only chooses.

## 2. What the player decides
Before saying yes (the offer):
1. TAKE IT OR PASS. The offer shows the opponent beside your fighter (the compare card exists: BoutCompare), the rank a win or
   a loss would give (RankLine, built S429), and whether your fighter OWNS an answer to this opponent's best weapon. With no camp
   to fix a bad match, the choice of opponent is the big decision. Passing is free today; when asking for fights (R37) is
   built, a pass will cost a favour with that club.

In the fight week (four jobs, shown as four boxes):
2. THE WEIGHT: hold or cut (the diet and the weigh-in forecast exist). A cut costs tiredness.
3. THE TAPE: one evening of film shows ONE tell of the opponent (the tape room exists). It takes that fighter's pad evening.
4. ONE LINE OF THE PLAN: write one answer to what the tape showed (the game plan exists). It only works if the fighter owns
   that punch (mastery 30 or more). If not, the line is weak and the screen says so.
5. FRESH OR SHARP: light mornings bring tiredness down for the night (tiredness carried into the ring empties the tank at
   the first bell: BoutRules); normal mornings keep building but the fighter boxes heavier-legged. One switch for the week.

The links between them (what makes it more than a checklist):
- The tape costs a pad evening, and pad evenings are shared between three boxers (FOURSTART1). Film for Tess means no pads
  for Samira that night.
- The plan line needs an owned punch, which was built (or not) in the weeks before. A thin book means the tape finds a tell
  you cannot answer: the lesson is to build the book between fights.
- A cut and normal mornings both add tiredness; you cannot do both and arrive fresh.
- With four fighters, two fight weeks can land in the same week.

## 3. The numbers
- Lead: 1 or 2 weeks (was 2 to 4).
- A season: the target is 8 to 10 bouts a year for an active amateur (real ceiling about 18). Today's offer rate with a 2 to 4
  week lead gives fewer; the offer rate is re-set from a probe.
- Rest after a bout: one light week (the sensible player already does this); after a stoppage loss 28 days out (the real
  medical suspension after a knockout or a referee's stop for head blows).
- What a camp gave an amateur and what replaces it: the camp's "edge" (0.25 to 1.0) and peak bonus (+1 every number) go.
  The fight week gives freshness (the tank at the first bell) and the plan line (the existing bonus for a line that beats the
  opponent's game). Net effect on win chance must be measured so amateur fights are not suddenly harder or easier.
- Money: more bouts means more $450 ticket cuts. Four fighters at 8 bouts a year would be about $14,400 a year, more than a
  third of the club's yearly costs. Either the cut is only paid on HOME shows (real: away shows cost travel and pay nothing),
  or it comes down. MONEYFOUR1 gives today's count; the number is set after it.

## 4. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Home | each fighter's row: "Fights Sat 14 Feb. Fight week: 2 of 4 done." | Home.gd rows, Bouts, the fight-week state |
| Fights | offers 1 to 2 weeks out; compare card; rank a win or loss gives; "owns an answer: yes / no" | Fights.gd, AmateurBooking, BoutCompare, RankLine, OppFile + PlanLines |
| Bout page | four fight-week boxes in place of the camp setup (amateur only); camp setup stays for pro, title, nationals | BoutPage.gd, Bouts (no start_camp for amateurs), BoutRules |
| Fighter page, Training (week board) | the fight week marked on the board; the fresh or sharp switch; the film evening | WeekBoard, WeekPhase (a fight-week phase), PadWeek |
| Tape room | the one tell the film evening showed | TapeRoom, Bouts.tape_days |
| Playbook, Game plan | the one line, and whether the fighter owns it | GamePlan, PlanLines |
| The guide | "Tess fights in ten days. Keep the legs fresh." then one line per job still open | GuideLines, the coach's read (TRAINREAD1) |
| Continue button | stops at the weigh-in and at fight night | Clock, FirstWeek needs |
| Fight night, result, the Why | the rank earned; which fight-week jobs counted | BoutNight, FightWhy, RankLine |
| Week review (Monday) | what the fight week cost the others (the pad evening) | the week review |

## 5. What is built, in order
1. A probe (Qwen, measure only): amateur win chance and bouts a year with the lead at 1 to 2 weeks and no camp, against today.
2. The rule changes (pure, with tests): the lead, "no camp for an amateur", the fight-week state and its four jobs, rest rules.
3. The screens: the Bout page's four boxes, the Fights page tags, the week board's fight-week band (Cursor, one screen a task).
4. The guide's lines and the golden-path test: offer, yes, four jobs, weigh-in, fight, rank earned.

## 6. Risks, said plainly
- Four boxes could become a checklist everyone fills the same way. The shared pad evening and the owned-punch rule are what
  stop that; if the critics find a best order that always wins, the links are too weak.
- Removing the camp removes a system the player already knows; pro camps must feel like a step up, not a leftover.
- More bouts means more injuries and more fight nights to watch: highlights stay the default.
- The ticket money can break the economy if it is not re-set.
