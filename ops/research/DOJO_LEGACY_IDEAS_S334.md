# DOJO_LEGACY_IDEAS_S334 - ideas from Dojo Legacy (bjj-link.com) for FightCamp, never copies

2026-11-01, S334 side session (Claude). Operator (verbatim): "check it for ideas ?" Rule (operator S275): ideas, never copies.
Research only: nothing built, no board question (the main session picks from the top 5 and asks him).

**Sources read** (public pages, curl static HTML, no sign-up, no download, nothing under `/api/`): `/en`, `/en/dojo`,
`/en/termos`, and 15 guide pages under `/en/guia/`: primeiros-passos, treino-energia-e-evolucao, faixas-e-graduacao,
tecnicas-e-arsenal, combate-por-turnos, meu-dojo, meu-evento, hall-da-fama-e-legado, carreira-no-mma,
vida-dinheiro-e-patrocinio, liga-de-equipes, passe-do-dojo-e-compras, matgram-e-rival, lesoes-saude-e-equilibrio,
relacionamentos-e-familia. The game itself was not played: it needs the web app, and an account for most features.
Licence and what it is: see `BJJ_SOURCES_S334.md` section 3b. It is all rights reserved, so we take nothing but ideas.

**Compared against Lean:** `E:\FightCamp\Lean\docs\RESTART_PLAN.md` (weeks 1-5), plus a one-line read of every module in
`scripts/state` and `scripts/rules` and a grep for each idea's keywords.

## The key difference

In Dojo Legacy you LIVE one athlete's life, from about 10 years old to an heir. In FightCamp you RUN a boxing gym and
its boxers. So every idea below is turned to face the gym owner. "Your belt" becomes "her next step, which you steer".
"Your social life" is dropped.

## What Dojo Legacy does (short)

- **Loop:** a year has 4 seasons. Each season gives 100 energy to spend on classes, work, leisure and tournaments,
  then "Advance period". The Overview screen holds alerts, pending decisions, goals and the advance button.
- **Progression:** talent of 1-5 stars sets the attribute ceiling, 86-98, and XP speed, 95-115%. The gap is "real but
  small on purpose". The fighting style picked at creation locks some attributes at 59 or 74. Belts need a minimum
  age, time at the current belt and 3 wins at that belt, and each belt raises the attribute cap and the number of
  arsenal slots (8 at white, 30 at black). Techniques level up to "Mastered", and a mastered move can pass to the heir.
- **Gym:** you pick a gym tier (free community project, garage, traditional, competitive). Each gym's reputation
  moves every year with its athletes' results, and "a gym has its eye on you" lets you switch without the joining fee.
  Later, at age 30 and reputation 50, **My Dojo**: you pick an identity (Community / Performance / Premium / Scale) and
  one of 3 building offers (down payment, yearly cost, risk), hire coaches, set the class schedule (which decides what
  students you attract), hold a belt ceremony per student per year, corner your team at tournaments, settle cash at
  year end (bankruptcy after too long in the red) and see a ranking against other academies.
- **Fights:** turn-based. Before a bracket you pick a strategy (balanced, aggressive, pull guard, play on top...) and
  then "Fight" (pick every move) or "Quick simulate". Gas, wear carried across the bracket, momentum. A corner
  action between bracket matches.
- **Stories:** one ARCHRIVAL per career with an opposite style, living a parallel season. Their gym is locked to you,
  and you can build a dossier before you meet. A social feed (MatGram): before a superfight the opponent posts about
  you, and replying aggressively, respectfully, dismissively or not at all changes hype, reputation and mindset.
  A promoter path (My Event): build a card, negotiate purses, and do the ticket math, with a partner who carries
  friendship and business-trust bars.
- **Legacy:** retire at 30-60, pick a child or a student as heir, and pick ONE carried bonus (+8 to a stat, cash,
  or a mastered move). Family debts can pass on too. Hall of Fame of the top 10 real players.
- **Monetisation:** free; Dojo Pass R$9.90 a month (no ads, 5 energy refills, an exclusive monthly gi); paid instant
  refills of energy and morale, minor-injury heals, a stat respec, instant construction, **a second MMA weigh-in**;
  a separate League Pass; a soft daily XP cap (past 300 XP the extra yields only 20%).

## Already in Lean (not pitched)

Injuries per body part (`Injuries`, `BodyMap`, `BodyReport`), training load and burnout (`TrainingLoad`, acute:chronic),
morale and walk-out to a rival gym (`FighterGoal`), prospects' potential at trials (`Roster`), per-move mastery
(`MoveMastery`, `Combos`), corner calls and pace (`CornerJobs`, `PaceAim`), money runway warning at 8 weeks
(`GymBills.runway_weeks`) and closing after 8 weeks below $0, HOME's pending list and a CONTINUE that stops on its own
(`Needs`), region rivals fighting at club shows (`Region`, `Data.RIVALS`), news feed (`Career.add_news`), Nationals
(`Champs`, `SeasonPath`), pro debut (`ProDebut`), save/load.

## Ideas, each with the problem it solves and the boxing version

### 1. The next-step card: two or three bars that fill, then the coach says so
- **Seen:** the belt panel shows "wins at this belt" and "time since last promotion" side by side. When both are full
  and the age is met, the coach's alert appears.
- **Problem for us:** the amateur ladder is in the rules (`AmateurBooking` novice 0-10 bouts, `SeasonPath` NAC needs
  5 bouts + 3 months registered, Elite age 19-40, `ProDebut`) but the player has to know it. A watchable career needs
  "where is she going and how far is it" on one card.
- **Boxing version:** on her fighter page, "NEXT STEP: Open class". Bars: bouts 7/10, and for Nationals entry,
  "registered 2/3 months" and "bouts 5/5". When they fill, the coach line reads "She's ready for Open class. Enter her
  at the next show?" with one button. Later steps follow the real ladder: Open -> regional title -> Nationals -> pro
  licence.
- **Cost:** small. The data exists. It is a UI card plus one rule that reads the step and its bars from SeasonPath and
  AmateurBooking.

### 2. Her rival: one named boxer who lives her own season beside yours
- **Seen:** one archrival per career, with the opposite style. Their gym is shown and locked. They meet you in
  brackets. A dossier before the bout.
- **Problem for us:** Lean has a pool of region rivals, but nobody the player LEARNS to hate. One recurring name turns
  a run of bouts into a story you want to watch the end of.
- **Boxing version:** at signing, each fighter gets one rival at her weight from another club, with a style that
  counters hers (her dials flipped in `FighterProfile`). Her results show in news after each club show ("Dana Reyes
  (Hulme ABC) stops her third novice in a row"). The draw at Nationals keeps them apart until late (`ChampDraw` seeding).
  The scouting film on the rival builds over the season, so the first meeting is a payoff. A loss to her sets the next
  goal: "beat Dana".
- **Cost:** medium. It reuses the Region sim and `Faces`. It adds a `rival_of` link and news lines.

### 3. Milestone moments: the ceremony, not the routine
- **Seen:** "It's a rite, not a routine": one belt ceremony per student per year. Achievements with rarity.
- **Problem for us:** between bouts the career feels flat, and the operator judges by "a watchable boxer career".
  Firsts are what a boxing parent or coach remembers.
- **Boxing version:** a full-screen beat with her photo (the HOME polaroid / `Faces`) for her first carded bout, first
  win, first stoppage, moving to Open class, a regional title, the Nationals, and the pro licence. Each is stamped into
  her **record book** (a real amateur has one), which you can page through on her profile. At year end, the club's
  awards night: "Boxer of the Year". The same events can later become Steam achievements at no extra cost.
- **Cost:** small. The events already happen in `Bouts`/`BoutNight`/`Champs`. Add a list on the fighter and one modal.

### 4. The build-up: one choice before a big bout that moves the crowd and her head
- **Seen:** before a superfight the opponent posts about you, and your reply tone (aggressive / respectful /
  dismissive / silent) changes hype, reputation and mindset.
- **Problem for us:** a bout starts at the offer and the camp. A big night has no build-up, and the ticket cut is a
  fixed number.
- **Boxing version:** before a title bout or a home show, the local paper or the other club's page says something
  ("Her coach says she can't go 3 rounds"). You pick how the gym answers: say nothing, respectful, or fire back.
  Firing back raises ticket sales and the rival's edge (her opponent trains angry). Respect raises sponsor interest. Her
  morale moves depending on her personality traits (`FighterProfile`): a nervous boxer hates the noise. Keep it to one
  choice per big bout.
- **Cost:** small to medium. A modal, plus three numbers into `BoutNight` (ticket cut, opponent edge, morale).

### 5. Every greyed-out button says why, and every commitment shows the money ahead
- **Seen:** a disabled button "shows disabled, with the reason". The requirements screen "marks what's missing in
  red". Finances rate the situation in a word (critical / tight / stable / comfortable), show the biggest cost and
  best income, and say "check the projection before taking on a new commitment".
- **Problem for us:** Lean disables controls (`Fighters.gd`: focus, diet, combo, load) without saying why. The runway
  warning comes only after the money is already bad (`GymBills.runway_weeks`). Playtests have already lost him to
  dead ends: an unplayable route (S276) and a BUILD click that fell through (S287).
- **Boxing version:** each disabled control gets a one-line reason ("In camp: focus is locked until the bout").
  Hire a coach, sign a boxer or take a camp, and the button shows "after this: +$X/week, runway 14 -> 6 weeks", with
  the money word coloured.
- **Cost:** small. The numbers exist (`GameMoney.weekly_projection`, `runway_weeks`).

### Other ideas (later, ranked lower for the demo)
6. **Club reputation table.** The gym's standing among the region's clubs moves each season with its boxers'
   results. Better standing brings better walk-ins and trial prospects. Rival clubs try to poach a winning boxer
   ("Hulme ABC has its eye on Lucy") - this joins our walk-out rule. *Solves:* it ties gym management to the fighters'
   results. Medium.
7. **Host your own club show.** Amateur clubs really run their own shows: book the card from the region, pay officials
   and the venue, sell tickets, and your boxers fight at home with a crowd edge. A loss-making show is possible.
   *Solves:* a money and identity goal for the gym, and a home-crowd night to watch. Medium to big. Week 5+ territory.
8. **Gym identity.** A community club (kids, fitness members, grants), a fight factory (competitors, higher coach
   cost) or white-collar boxing (high dues, few fighters). Each changes `Membership`/`GymBills` and who walks in.
   *Solves:* replay value and a real strategic choice. Scope call - later.
9. **Coach ceiling.** A coach can only take her so far. A boxer stops gaining near her coach's level until you hire
   better or send her to a specialist. This plays the role the belt cap plays in Dojo Legacy. *Solves:* gives coach
   upgrades a reason beyond flat gain. Needs real-world evidence first (no defaults without direction).
10. **Fight-time choice: watch it or get the result.** "Quick simulate" for small club-show bouts, the full night for
    the ones that matter. *Solves:* pace over a long career. Check what Lean's words-mode already costs in clicks
    before building anything.
11. **Retired boxer becomes staff.** When a boxer retires, she can join as a coach and carry one mastered combo she
    teaches better (one carried bonus, as with Dojo Legacy's heir). *Solves:* a long-term loop and gym continuity.
    Post-EA.

## Not to take (monetisation and padding hooks)
FightCamp is premium ($19.99 EA). None of these fit, and several would damage trust:
- Energy that refills only by advancing time, or for money; paid refills of morale or energy.
- **Paying to undo a mistake:** a second weigh-in for money, instant injury heals, a paid stat respec, instant
  construction.
- A soft daily cap that stretches play across real days (past 300 XP the extra yields 20%).
- A monthly exclusive cosmetic that is gone if missed (FOMO), separate passes per mode, ads.
- An online Hall of Fame that needs an account (it runs on servers and the dev's time). An offline record book (idea 3)
  gives most of the pride.
- A full life sim (dating, children, school, army or referee careers). It is the athlete's life, not the gym's, and
  it is scope creep.

## What keeps their players coming back, and our version
- **Something new every time you return** (the feed refreshes on the real clock). Ours: HOME always has one fresh line
  from the region (a rival result, a club show draw) when CONTINUE stops.
- **Fixed dates to aim at** (league seasons with real start and end dates). Ours: the amateur calendar is already
  real (Nationals); show the countdown on HOME.
- **A visible ladder** (belts, a talent ceiling that is "real but small on purpose") - ideas 1 and 9.
- **One face to beat** - idea 2.

## Top 5 by "does this put a watchable boxer career in his hands sooner?"
1. **Next-step card** (idea 1): smallest build. It makes the whole amateur ladder readable on her page.
2. **Her rival** (idea 2): turns a list of bouts into a story with a payoff, and reuses the Region sim.
3. **Milestone moments + record book** (idea 3): cheap. The firsts become something to watch and remember.
4. **The build-up choice** (idea 4): gives big bouts a before, and moves money and morale the player can see.
5. **Reasons on greyed buttons + money ahead** (idea 5): removes "why can't I?" dead ends of the kind that broke
   earlier playtests.
