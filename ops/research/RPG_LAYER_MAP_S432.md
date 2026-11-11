# RPGLAYER1: the RPG layer for you, Coach and your fighters - v3 (S432)

The owner's words: "i want a bit more rpg elements with coach and fighters", then "yes add the rpg layer after the review".
Builds on the club week (`ops/research/CLUBWEEK_MAP_V4_S432.md`, with the verdict's ten changes, `docs/mockups/s432/critics/VERDICT.md`). Nothing in
the club week's rules changes; every new choice is paid in the club week's own coin: pad places, coached mornings, cash, loyalty, favours, fans.
Words: "You" is the head coach, the player. "Coach" is the hired assistant coach. Game text never says he, she, her or him.
Drawn: `docs/mockups/s432/rpg_coach.png` (Club > You, your own page) and `docs/mockups/s432/rpg_fighter.png` (a fighter's Character tab, Tess Reilly).

V3 (critics v2: a systems critic 6.5, a club head coach 7; reviews `docs/mockups/s432/critics/rpg2_systems_review.md` and `rpg2_coach_review.md`).
What changed, and the point it answers:
- EVERY EFFECT HAS A HOOK (systems 1, 8): each effect names where it lands, in the fight code today (CODE) or in a club week rule built before this layer
  (WEEK); all of them in THE HOOK TABLE (section 17). Six effects did nothing and were changed: HARDENED and Iron chin's GETS UP read the referee's stop odds
  (the count number is only the picture); SHAKEN reads them too (the boxing fight never reads composure); TRUST ME now opens the SHOUTS (the corner's talk
  was never cut by mood in the code, so "the talk lands in full" was empty); THE MINUTE is two set-ups (the code has one change in the minute, not two
  fixes); EYE FOR THE SCALE halves the Eat less price (no weight forecast in the code has a range to remove). Five perk B versions rewritten on real hooks.
- WHAT YOUR PICKS WON (systems 2): a ledger on Club > You and the Character tab, one line per pick in the Why; a pick under 0.5 in 100 a season greys out.
- TRAITS AT LINES (systems 5): each trait shows its NEXT line, what crossing it does, and the button that moves it; the per-point numbers go to hover.
- LOYALTY FORECAST (systems 6): on the bar and on each Club week row, before Start week.
- THE PERK PICK PRICED ON THE NEXT THREE NAMES (systems 3), and the direction's clash on the weak-spot chip (systems 7).
- KNOWN: per-group speed (Body in about 3 weeks, Skills about 7, Fire only under fire), a plain true number once a group is known, and one game effect per
  step (systems 4, coach 2).
- EXPERIENCE FROM OUTCOMES (coach 7, systems 9): no "+2" chips at the deal, no +1 for a perk pick; +1 a stat point gained in your own sessions.
- MOMENTS: a coin tag on every answer, at most a third paid in a pad place (coach 4); UP A WEIGHT and THE NIGHT OUT replace A NEW WEAPON and THE OLD
  COACH AGAIN (coach 8). AMBITIONS MOVE at milestones (coach 3).
- MARKS say how they fade; CHAMPION added (systems 10, coach 9). THE STYLE SHAPES THE TRIAL MAT (coach 5). A CLUB CAPTAIN (coach 6). ANA'S BELT PICKS
  (coach 10). PARTNERS' bonus raised to a size that can pass its probe or go (systems 9).
- PROBES FOR BOTH SIDES OF EVERY PICK (coach 1): COACHPICK1 joins PERKPICK1, KOTURN1, TRAITLINE1, LEDGER1 and the rest, each with the cut rule.
- Coach's area counts only in the week review; "Coach and <name>" is a hover (systems 9, coach useless list). Asks not taken: REJECTED, near the end.

ALREADY BUILT AND KEPT (read in the code, S432): Recruit (class from style, potential in stars, ceilings, two traits on show, one habit, signature,
ambition, one starting focus); PerkRoad + PerkFight (8 perks, each with a fight hook); CornerTrust (a wrong call costs mood, a Low fighter's shouts do not
land); HeadCoach (your background, one edge); CoachAreas; HabitFix; CoachNotes; StripeCall; FighterProfile (six traits, mood); Knowledge (KNOW1: ranges per
group Body / Skills / Fire that narrow with exposure, "the range never lies"; built and tested, wired nowhere yet); TheRead; the v4 loyalty.

## 1. The idea in nine lines
- YOU GROW: experience from what your own hours achieve raises your level; each level is an EITHER/OR pick, one level shaped by your background; after
  level 6, one SEASON PICK a year.
- YOUR FIGHTERS PICK TOO: each of the eight perks opens as two versions; you pick one per fighter, priced against their next three opponents.
- ONE NUMBER PER FIGHTER: LOYALTY is the bond, with a forecast. Mood stays the short one.
- YOUR STYLE: Hard school, Craft first or Family club; it colours the gym, suits or clashes, and changes who walks in.
- TRAITS MATTER AT LINES: hidden until known; worn down or hardened by the weeks; each shows the next line and the button that moves it.
- BUILD DIRECTION: Keep it long, Walk them down, Counter, or None (Adaptable).
- KNOWN: how well you know each fighter, group by group, from your own hours; each step does something.
- MOMENTS, MARKS AND THE SQUAD: cards that remember and are paid in many coins, marks that stay and fade, partners, feuds and a captain.
- WHAT YOUR PICKS WON: every pick reports what it earned, so a weak one can be rethought.

## 2. You grow: coach level and the either/or perks
WHAT YOU DECIDE: at each new level, one of two perks (three at your background's level), for good. Club > You and the top-bar flag LEVEL UP.
EXPERIENCE (only results of your own hours; Coach's work gives you nothing). Not shown on the slots at the deal (it would bait the week); read on Club > You
and in the Monday review ("+4: Samira's dropped right trained out on your pads").
| Source (an outcome) | Experience | The club week decision behind it |
|---|---|---|
| A bout you cornered | +1, +2 more on a win | who corners on a two-hall night (v4: you or Coach) |
| A whole stat point gained in your own sessions (week review) | +1 | your 4 coached mornings and 2 pad places |
| A habit trained out on your pad places | +3 | your pad places (only yours train a habit, v4 3.2) |
| A fighter's perk opens and the stat that opened it last rose in your session | +2 | whom you coach in person |
| A professional's camp you ran, won | +2 | the camp's load and pad places |
| A dated promise kept | +2 | the talk card's promise (v4 3.8) |
| A season target met | +4 | the season target (v4 3.9) |
| A fighter reaches KNOWN 5 | +2 | whom you coach in person (section 8) |
| A feud settled by your talk | +1 | the pad place it costs (section 10) |
| Ana's stripe given on time / a belt | +1 / +3 | the stripe call (StripeCall) |
CAP PER BOUT (kept): a cornered bout pays experience and Known only, so who corners on a two-hall night stays a choice.
LEVELS (ESTIMATE): level 2 at 15, 3 at 36, 4 at 62, 5 at 88, 6 at 118; then a SEASON PICK each 55 more, at most one a season.
A first season with this line-up (18 bouts cornered, 9 won; about 25 stat points in your sessions; 2 habits; 3 perks opened under you; 2 professional
camps won; 3 promises; 2 targets; 2 fighters at Known 5; Ana's stripes) gives about 100: levels 2 to 5. A player who lets Coach corner half the bouts and
deals few of their own sessions gets about 60: levels 2 and 3. COACHXP1 must show 3 to 4 steps for the careful player, 2 to 3 for the other, and a season
pick reached in each of seasons 2 to 5.
THE PICKS (each pair moves the same coin both ways; hooks in section 17; ESTIMATE unless marked code):
| Level | The question | Pick one | or the other | Your background's third card |
|---|---|---|---|---|
| 2 | Where your hours go | LONG EVENINGS: your evening gives 3 pad places (was 2); your coached mornings 3 (was 4) | EARLY STARTS: your coached mornings 5 (was 4); your evening 1 pad place (was 2) | STRENGTH COACH, BODY FIRST: your coached Cardio and Strength mornings take two fighters at 1.0 each (shared is 0.8) |
| 3 | How you run a room | ONE ON ONE: a morning alone with you counts twice toward Known and can train out a habit like a pad place | THE ROOM: in any session you run with two or more fighters nobody skips (v4: discipline under 45 skips 1 alone morning in 3), and each gains discipline +1 every 4 weeks | AMATEUR COACH, THE CLUB NIGHT: Coach's class evenings count 0.5 toward Known for every amateur in the class |
| 4 | The corner | RINGSIDE VOICE: 3 shouts a round land in full (code: the round's first 2, later ones at half) | THE MINUTE: two set-ups in the corner minute, each a combination on its own gap (code: one), and the habit fix holds two rounds (code: one) | EX-PRO, ONE YOU SAW COMING: once a bout, a NOW! fired into the wrong game is read as a fit (code: a miss costs 9) |
| 5 | What you see | EYE FOR TAPE: the film evening answers two questions, not one (v4 4); it takes your evening | EYE FOR PEOPLE: Known grows 1.5 times as fast; watching a trial takes 1 coached morning, not 2 | OLD HAND, EYE FOR THE SCALE: Eat less costs half (tank -1 per 0.2 kg, v4: per 0.1 kg); once a season a kilo asked for no favour |
| 6 | Your name | A NAME IN THE TRADE: each season starts with +1 favour at each show club; once a season the trial mat brings a prospect of potential 80+ | A HOME FOR LIFE: a Loyal fighter (70+) loses no loyalty to going short, and leaving waits for a third talk, not a second | none |
THE PICK CARD reads from YOUR record and YOUR squad, and prints BEST FOR from COACHPICK1. Level 4: "last 6 bouts: 9 shouts landed at half" against "5 rounds a
second gap opened with no NOW! armed"; best for: "a squad with two Stubborn fighters: +1.8 in 100" against "a squad with 3+ drilled combinations: +1.6".
Level 2: "Tess's 2 Cardio mornings with you: Stamina +0.5 a week, was +0.4". The road shows both sides of every later level ahead of time.
SEASON PICK (after level 6, one a season, 55 experience each; Club > You). Pick ONE of:
- DEEPEN a perk you took (same coin): Long evenings 4 pad places, mornings 2. Early starts 6 mornings, no evening pads. Body first: three fighters at 1.0.
  One on one: a morning alone also opens one tell of that fighter's own habit. The room: discipline +1 every 3 weeks. Club night: 1.0 toward Known. Ringside
  voice: round 3's shouts all in full. The minute: three set-ups. One you saw coming: twice a bout. Eye for tape: three questions. Eye for people: x2. Eye for
  the scale: two kilos a season. Name in the trade: +2 favours. Home for life: also Settled (50+) loses no loyalty to going short once a month.
- SECOND THOUGHTS: take the side you closed at one level (the side you held closes). One level, once a season, the experience spent. The ledger (section 13)
  marks a pick that won little as "a pick to rethink", with this button beside it.
REAL BASIS: club coaches choose where their own hours go, one-to-one against group work, and a corner known for its voice during rounds or its plan in the
minute (J55: two instructions get through). XCOM 2's promotion pick; Darkest Dungeon's camping skills for the deepening.
CUT: a coach perk that is only "+5% training"; experience from members or money; experience for a click.

## 3. One number per fighter: loyalty is the bond
DECISION (kept): the bond with you IS LOYALTY, the v4 number (0 to 100, moved by your deals). No second bond meter. MOOD = now (this week's training, this
fight's listening); LOYALTY = you and them over the season.
WHAT BUILDS AND BREAKS IT: all of v4 3.8 and the verdict's changes, plus (ESTIMATE): your style suits them +1 every 4 weeks, clashes -1 every 2 weeks;
moment answers (section 9); a season target that matches their ambition +5 more when met, one set against it -5 when set and -1 every 4 weeks it stays
against (section 7); a partner leaving -4 (section 10); a captain passed over -3 once (section 10).
THE FORECAST (NEW): the bar and each Club week row show where this week's deal takes it, if the rota repeats: "66 now; as dealt 69 in 4 weeks, Loyal in 5;
short twice more: 60". The same deal preview the board already runs for pad places, read through v4 3.8's prices. It changes as you deal, before Start week.
WHAT IT UNLOCKS (the bands, on the loyalty bar):
| Band | Loyalty | What it does |
|---|---|---|
| Leaving | under 25 | after two talks, leaves the next Monday for Eastside ABC (v4) |
| Wavering | 25 to 49 | the WANTS A WORD card (v4); signs with an outside manager at turning professional: the club keeps 10%, not 25% |
| Settled | 50 to 69 | no talk card; turns professional with the club at 25% |
| Loyal | 70 to 84 | can HOLD PADS (+1 pad place at 0.7); one short week in four costs no loyalty; moments offer a third, generous answer with its own price; can be CAPTAIN |
| Trusts you | 85+, and Known 4 | TRUST ME in the corner minute (below) |
TRUST ME (rewritten): once a bout, chosen in the corner minute, for the next round: every shout lands whatever the mood (the Low gate is skipped and the mood
counts as Fired up, 1.05), and if they were hurt in the round just gone, RECOVER has 4 points, not 3. It needs Known 4 as well as loyalty 85: the trusted
coach is the one who knows them. TRUSTME1 must show 1.5 wins in 100 on bouts with a hurt round or a Flat or Low mood; else 85+ brings a friend to the trial mat
once a season (a prospect of potential 70+).

## 4. Your coaching style (the gym's philosophy)
WHAT YOU DECIDE: one style for the gym, on Club > You, from week 6. Changed at most once a season: every fighter's loyalty -4, the new style's plus counts
half for 4 weeks. Every number on the style cards is shown in THIS squad's weeks ("Lucy: Stamina +0.36 a week, was +0.40"), multipliers in hover.
| Style | What it colours (ESTIMATE) | Its price | Suits (+1 loyalty / 4 weeks) | Clashes (-1 / 2 weeks) |
|---|---|---|---|---|
| HARD SCHOOL | Hard mornings x1.4 (code x1.3); Hard sparring x1.4 (v4 x1.3); heart +1 every 8 weeks for all | every loyalty loss x1.3 | Big heart, Disciplined | Fragile, Folds when hurt |
| CRAFT FIRST | pad places teach x1.15 mastery; a plan holds one more line; temper -1 every 8 weeks for all | Cardio and strength mornings x0.9 | Listens, Confident | Stubborn, Short fuse |
| FAMILY CLUB | every loyalty loss x0.7; the talk's "give the pad place back" +6 (v4 +4) | no Hard sparring at the club | Loyal, Fragile | Wanders off the plan |
THE FIT AT SIGNING: the trial card, the walk-in card and Find a fighter show the fit per trait on show ("Listens: suits Craft first"; unknown shows "?").
THE TRIAL MAT (NEW): 8 weeks after a style is set, 2 prospects in 3 on the trial mat and at reception carry one of its suiting traits (code: Recruit's trait
roll, weighted); their card says "came for your Craft first". A style change takes 8 weeks to change who walks in.
REAL BASIS: clubs are known for a way; boxers choose and leave gyms over exactly this fit.
STYLE1 must show: no style best in more than 2 of 3 seasons across the eight line-ups; a clash costs at least one band of loyalty a season if nothing is done;
and the trial mat's weighting moves the squad's suiting share by a third within two seasons.

## 5. Traits: they matter at lines
THE FIVE: coachability, heart, confidence, temper, discipline (FighterProfile.TRAITS less loyalty, which is the bar of section 3).
LINES, from the code (TRAITLINE1 checks each; the two NEW lines are new hooks). The Character tab shows the value, the word, the NEXT line, what crossing it
does, and the button that moves it; the per-point effect is in hover.
| Trait | Its lines (what each does) | What moves it (the button) |
|---|---|---|
| Coachability | under 40 STUBBORN: a habit fix in the corner holds half (NEW; code: in full). 70 LISTENS: the round's third shout lands in full too (NEW; stacks with Ringside voice to 4). Hover: takes in 0.7 + 0.3 x value of each full shout (code) | +1 an ask heard (PushBack: "Hear it"); +1 every 4 weeks at Loyal; -2 an ask overruled; -1 a wrong call followed |
| Heart | no line: every 10 points count. The referee's stop odds after a count x(1.4 - heart / 100): x0.56 at 84, x0.9 at 50; a badly hurt boxer stays down (1 - heart / 100) x 0.7 (code). Hover: a loss hurts mood x0.8 | +3 a win from behind; Hard school +1 / 8 weeks; the knockout turn +6 / -6 |
| Confidence | under 50: "Fire up" lifts +2.0, not +1.5 (code). under 45: "the truth" turns against them, -2 (code) | +2 a stoppage win, +2 three wins running; -4 a stoppage loss, -2 a loss to a name below (which bout on the sheet) |
| Temper | 65 SHORT FUSE: "Fire up" turns wild (-2, hurt x1.6), "Calm down" +1; the counter goes earlier (code: CornerJobs.talk, TheRead.trigger) | +1 each 2 Hard sparring evenings; -1 each 4 Technical or Body only evenings (the sparring setting) |
| Discipline | under 45: skips 1 alone morning in 3 (WEEK). under 50: pushes back on a Hard week (code: PushBack). 60: "the truth" works, +1.2 not +0.3 (code) | +1 each 4 weeks with no skip; The room +1 / 4 weeks; the captain's room; -1 each week a session is skipped |
Example (drawn): "Coachability 36, Stubborn. Next line 40: corner fixes hold in full. 4 points: hear Thursday's ask (+1), Loyal by May (+1 / 4 weeks)."
CROSSING A LINE: the word on the card changes and the Monday review says what that changes ("Tess, coachability 40: corner fixes now hold in full").
HIDDEN, THEN KNOWN: the signing card shows two traits; the rest show "?" until known; a hidden trait still acts. A trait opens from CoachNotes, in sparring by
the setting (ESTIMATE: Hard 1 in 2, Technical 35 in 100 (code), Body only 1 in 5), at Known 2 and 4 (section 8), or from a moment that names it.
EACH TRAIT MOVES AT MOST 10 A SEASON (ESTIMATE).
THE KNOCKOUT TURN: after a stoppage loss, or two counts in one bout, a roll the Monday after: HARDENED (heart +6, mark) or SHAKEN (heart -6, confidence -4,
mark). Base 50 in 100. Toward HARDENED: REST 2 weeks (v4) +15; SIT WITH THEM (moment 1) +15, +25 with a SAT WITH THEM mark; Loyal +10; Known 5 +10.
Toward SHAKEN: back on a sheet inside 3 weeks -20; Fragile -10. The odds show exact at Known 5, as a range before. A knockout also cuts Fire knowledge to
60% (Knowledge.stale, built).
TRAITDRIFT1: a season of Hard sparring moves temper by 5 or more. KOTURN1: Hardened against Shaken boxers changes stoppage losses by 1 or more in a season of
a boxer with 8+ bouts, and Rest moves a season's Hardened count by at least 1 in 4.

## 6. Their perks: two versions each, you pick
WHAT YOU DECIDE: when a perk's need is met (PerkRoad.status) a PERK PICK waits (top-bar flag, Character tab, Profile perk road). One version, for good;
before Monday's Start week, else the version the direction lists first.
| Perk (need, code) | Version A (code today) | Version B (hook in section 17) |
|---|---|---|
| Iron chin (Durability 70) | TAKES IT: the first count each bout is only a stagger | GETS UP: after every count the referee waves it off x0.8, and a badly hurt count stays down half as often (the count number falls 2: picture only) |
| Stiff jab (Accuracy 65) | THE FENCE: +3 power when the opponent presses | THE RANGEFINDER: +3 power when the opponent boxes at range |
| Second wind (Stamina 70) | THE BELL: +10 energy at the bell for round 3 | THE LONG NIGHT: from round 2, what calls and combinations spend is x0.85 |
| Ring general (Fight IQ 65) | THE VOICE: corner calls that fit work 25% better | THE EYES: with no shout, they find the BEST answer themselves when the opponent's game carries on (code: the ok answer) |
| Counter sense (Defence 65 + Check hook 30) | THE TRAP: a free counter 3 in 10 when an attacker is beaten | THE READER: the read on an opponent's habit needs a quarter fewer looks (TheRead) |
| Body snatcher (Body hook 30) | THE DRAIN: body shots drain 15% more energy | THE DROP: after the opponent's first count in a round, the next comes as easily (the 0.6 fall-off goes) |
| Finisher (Explosiveness 70) | THE CLOSER: after the opponent's count, the referee stops it 1.5x as often | THE STALKER: +4 power in every exchange while the opponent is hurt |
| Fast hands (Speed 70) | THE FLURRY: combinations of the plan x1.4 | THE SNAP: single-punch lines of the plan x1.4 |
THE PICK CARD, PRICED ON THIS FIGHTER (replaces "best against: <style>"): each version's wins in 100 against the next three names (the booked opponent and the
sheet's names) and the average over this season's opponents so far, from PERKPICK1's tables read with this fighter's own numbers. Drawn: "The drain: K. Bell
+2.4, J. Moss +1.1, R. Ade +0.3; season +1.6" against "The drop: +0.6, +2.9, +1.8; season +1.2". The direction's first version wears a small tag.
ANA'S PICKS (NEW, the grappler): at the white belt's fourth stripe and at each new belt, Ana picks one of two (ESTIMATE). Fourth stripe / blue: GUARD
RETENTION (the opponent's pass works 1 in 5 less often on Ana) or SCRAMBLES (a missed takedown or sweep of Ana's keeps the initiative). Purple: BACK TAKER
(taking the back +8 points of odds) or PRESSURE PASSER (passing +8 points). Guard player lists Guard retention and Back taker first; Top game the others.
REAL BASIS: two boxers with the same gift use it differently; a coach shapes which. Grapplers build an A game at each belt.
PERKPICK1 must show: each version beats the other by 1.5 wins in 100 or more against some opponent style, measured on the played bout; else that pair goes
back to one perk. BJJPICK1: each of Ana's versions wins 3 matches in 100 more against some BjjOpp style; else one version.

## 7. What <name> wants (on the Character tab)
Shows the AMBITION, the SEASON TARGET (v4 3.9), whether they MATCH, and what is left. Setting a target that matches: met = loyalty +5 more. Against it:
-5 at once ("you want something else for me") and -1 every 4 weeks while it stays against.
AMBITIONS MOVE (NEW). The ladder (Recruit.ambition gives the first rung today): A first win at home; A winning record by the summer; A regional title within a
year; The nationals; A pro debut before 25; A title as a professional. At a milestone the Monday review names the new one ("was: a regional title"):
three wins running or a title: one rung up; a stoppage loss: one rung down; turning 25 with no debut, or 30: "a winning record" (time is short). A moved
ambition can make the season target you set stop matching, so the price changes under you and the Character tab says so.
REAL BASIS: a boxer who wins three running starts talking about the pros; one stopped wants a win at home first.

## 8. Known: how well you know each fighter (built on Knowledge.gd)
NAME: "How well you know <first name>"; one word: KNOWN. "The read" stays the fight rule (TheRead.gd). ONE RANGE SYSTEM: Known IS Knowledge.gd.
WHAT YOU DECIDE: whom YOU coach in person. Only your sessions add exposure (One on one, Eye for people and Club night change this).
EACH GROUP AT ITS OWN SPEED (ESTIMATE amounts for Knowledge.expose):
| Your session | Exposure |
|---|---|
| your coached Cardio or Strength morning on them | Body 3 (shared 1.5; One on one x2) |
| your coached craft or bag morning; one of your pad places | Skills 1 each |
| a sparring evening on your evening | Skills 1 (Body only 0.5); Fire: Hard 1.5, Technical 1, Body only 0.5 (Fire from sparring stops at FIRE_SPAR_CAP 12.5) |
| a bout you corner | Fire 4, Body 1, Skills 1 |
| the trial watch (v4) | Body 3, Skills 3 ("test") |
A GROUP IS KNOWN once three fifths of its range is gone (exposure 18; Knowledge gains `known(k, group)`): its numbers then show plain and true; an open
group shows its range. With two of your body mornings a week, Body is known in about 3 weeks; Skills in about 7 weeks of pads and sparring; Fire only after
Hard sparring and about two cornered bouts ("you know their heart when you have cornered them").
THE PIPS (the share of range gone, averaged over the three groups), each with what it DOES:
| Pip | Share gone | Opens | Does in the game |
|---|---|---|---|
| 1 | a fifth | the pull sizes' ranges halve | (information) |
| 2 | two fifths | one hidden trait (the most extreme) | (information) |
| 3 | three fifths | potential to half a star | a habit on your pad places trains out a week sooner (v4: 4 weeks) |
| 4 | three quarters | every trait | TRUST ME can be used (with loyalty 85) |
| 5 | five sixths | the knockout turn's odds exact | Hardened +10 on the knockout turn; +2 experience |
Beside each fighter: "pip 3 in 4 sessions: a habit trains out a week sooner", so Known says whom to coach next. A knockout, layoff or step up cuts Fire to
60% (Knowledge.stale, built). HYPE1 (queued separately) owns Knowledge's hype lift.
KNOWN1 must show: a bot that uses Known (whom to coach, TRUST ME, the habit week) wins 1.5 in 100 more a season than one that never coaches for it; else the
pips keep only the traits (2 and 4) and the game effects move to plain counts of your sessions.

## 9. Moments with memory, paid in many coins
Story cards from a trait, loyalty, an event or an EARLIER ANSWER, in the fighter's row on Club week; answered before Start week (else the plain answer and
loyalty -1). At most one per fighter every 6 weeks, one a week at the club; never in that fighter's fight week, except THE NIGHT OUT, which comes only then;
NO CARD TWICE FOR ONE FIGHTER IN A SEASON. From week 8. The talk card (v4) stays the loyalty-under-50 card.
MEMORY: every answer writes a dated note; later cards read the notes; the lasting ones become MARKS.
COINS (a tag on every answer): PAD one of your pad places; MORNING one of your coached mornings; CASH; FAVOUR; SHEET the next bout sheet; SPAR a sparring
evening or its setting; TRIAL a trial-mat place; TIME a lost day or rest; TANK fight-night energy; LOYALTY; PROMISE a dated promise. At most a third of the
deck's answers cost PAD (this deck: 5 of 54).
| # | Card | Comes when | Answers [coin] and prices (ESTIMATE) |
|---|---|---|---|
| 1 | AFTER THE KNOCKOUT | the Monday after a stoppage loss | SIT WITH THEM [MORNING]: Hardened +15 (+25 with a SAT WITH THEM mark). BACK ON THE SHEET [SHEET]: Ready, Hardened -20. TWO WEEKS OFF [TIME]: Rest, Hardened +15 |
| 2 | CALLED OUT | a named rival on the regional table calls them out in the news | TAKE IT [SHEET]: that rival is next sheet's name above, loyalty +3, fans +3; a loss there: confidence -4. LET IT GO [LOYALTY]: confidence -2. A DATE [PROMISE]: kept +5, broken -12 |
| 3 | A WEDDING ON SATURDAY | the week before a weekend with no bout | LET THEM GO [TIME]: Saturday lost, loyalty +3, note. SAY NO [LOYALTY]: -3. Loyal only: GO, TRAIN SUNDAY [MORNING]: you open Sunday, one of next week's mornings |
| 4 | SPARKS IN SPARRING | Short fuse, a Hard evening | SIT THEM OUT [SPAR]: the evening lost, temper -2. LET IT RUN [SPAR]: partner +10 tiredness, cut risk doubled, temper +2, feud count +1. ON THE PADS [PAD]: temper -1 |
| 5 | UP A WEIGHT | 1.5 kg or more over the class limit three Mondays running, or aged 21 or under and growing | STAY AND CUT [TANK]: Eat less every fight week, loyalty -2. MOVE UP [SHEET]: the next class, unranked there (wins stay on the record), new sparring pairs, loyalty +3. A TRIAL BOUT UP [FAVOUR]: one bout at the new weight on a friend's show, then the card returns with the result |
| 6 | MONEY IS TIGHT | a job fighter with no seat for 8 weeks | LEND $200 [CASH]: loyalty +5, discipline +1, note. A SEAT NOW [CASH]: $1,000 block (v4). NOTHING [LOYALTY]: -3, skips 1 alone morning in 3 for 4 weeks |
| 7 | THE OLD COACH CALLS | Known under 3 | ONE EVENING THERE [TIME]: a hidden trait opens; 1 in 3 an old habit comes back. NO [LOYALTY]: -1. Loyal only: BRING THE OLD COACH IN [CASH]: $60, the trait opens, no habit |
| 8 | THEIR OWN WAY | a direction against the class | THEIR WAY: direction to the class's, loyalty +4. YOUR WAY [LOYALTY]: -3; coachability +1 if Loyal, else -2. HALF AND HALF [TIME]: no direction for 4 weeks |
| 9 | ANA: THE BIG ACADEMY | Ana, loyalty under 70 | GO ONE CLASS A WEEK [LOYALTY]: drills x1.15, loyalty -3. STAY: nothing. GO WITH ANA [MORNING]: one of your mornings a week, drills x1.15, loyalty +2 |
| 10 | YOU SAID <MONTH> (memory) | a dated promise falls due, not kept | KEEP IT NOW: the promised thing, from whoever holds it (named price). BUY TIME [LOYALTY]: a new date 4 weeks on, -3. BREAK IT [LOYALTY]: -12, BROKEN PROMISE mark |
| 11 | THE FAVOUR BACK (memory) | 8+ weeks after LET THEM GO or LEND $200 | TRAIN THROUGH IT: a short week with no loyalty loss. BRING A MATE [TRIAL]: a prospect on the trial mat next Monday. NOT NEEDED: loyalty +1 |
| 12 | THE NIGHT OUT (fight week) | discipline under 50 or temper 65+, 1 such fight week in 4 | THE TRUTH [TANK]: tank -6 on the night, confidence +2. BENCH THEM [SHEET]: the bout goes ($300 and a favour, as a miss), loyalty -4, discipline +3. SAY NOTHING [TANK]: tank -10, note: the next comes 1 in 2 |
| 13 | MY PAD PLACE (squad) | short of your pad places 3 weeks running while a team-mate got them | SWAP ONE BACK [PAD]: them +3, the other -2. SPAR THEM, TECHNICAL [SPAR]: settled 1 in 2, else both temper +1. SAY NOTHING [LOYALTY]: -2, they will not spar together 4 weeks |
| 14 | A SPARRING GRUDGE (squad) | two Short fuses, their second Hard evening in 8 weeks | LET IT RUN [SPAR]: both x1.1 sparring gain tonight; a third Hard evening makes a FEUD. SPLIT THEM [CASH]: an outside partner, $160 this week. TALK IT OUT [PAD]: both temper -1 |
| 15 | MY PARTNER'S GONE (squad) | a PARTNERS pair loses one | SIT WITH THEM [MORNING]: the -4 halved. A NEW PARTNER NOW [SPAR]: the nearest weight, +10 tiredness week 1. NOTHING [LOYALTY]: -4 |
| 16 | OUTGROWING THE ROOM (squad) | no fair sparring pair 3 weeks running | BRING IN A PARTNER [CASH]: $160 a week, sparring full. A TRIP OUT [PAD]: +1 favour. MAKE DO [LOYALTY]: half-weight partner, -1 |
| 17 | THE NEW ONE (squad) | you sign a fighter in the same class | A TALK [MORNING]: loyalty +2. PAIR THEM [SPAR]: a PARTNERS start, a SPARKS risk if Short fuse. NOTHING [LOYALTY]: -3 |
| 18 | YOUR CORNER THIS TIME (memory) | a two-hall night, and Coach cornered them last time | YOU CORNER THEM: loyalty +3, the other fighter gets Coach. COACH AGAIN [LOYALTY]: -2, note (a second time -4) |
PAD answers: cards 4, 13, 14, 16, and the feud talk (section 10): 5 of 54. CUT IN V3: A NEW WEAPON ("pads on it" won almost every time) and THE OLD COACH
AGAIN (thin); card 1 no longer costs a pad place.
MARKS (at most 4 shown per fighter, dated, each with one effect and a way out; on the Character tab, the card hover and History; when full, the new mark
asks which old one to drop):
| Mark | From | Effect (ESTIMATE) | Goes when |
|---|---|---|---|
| HARDENED | the knockout turn | after a count the referee waves it off x0.85 | a second stoppage loss inside a year |
| SHAKEN | the knockout turn | after a count the referee waves it off x1.15 | a stoppage win, or after 3 bouts |
| FIRST HOME WIN | the first win at a home show | +2 fans every home bout | never |
| BROKEN PROMISE | card 10, or a promise broken on the talk card | the next promise: kept +3, broken -18 | two promises kept |
| PARTNERS (with name) | section 10 | x1.15 sparring gain together; the other -4 when one goes | one leaves |
| FEUD (with name) | section 10 | cannot spar together | settled, or 12 weeks apart |
| SAT WITH THEM | card 1, first answer | the next knockout card: Hardened +25 | used by that card |
| CHAMPION (NEW) | a title (regional, national or a belt) | confidence never under 60 that season (the talk's lines, section 5); +3 fans a bout | the season ends (it moves to History) |
REAL BASIS: Darkest Dungeon's events stay alive because they leave marks; a real gym remembers who kept their word, and who won the title.
MOMENT1 must show: no answer best in more than 2 of 3 draws of each card; 4 to 8 moments a season for the club, never two in a week, no card twice for one
fighter in a season; at least a third of season 2's cards are memory or squad cards; at most a third of the answers drawn in a season cost PAD.

## 10. The squad: partners, feuds and the captain
PARTNERS: two fighters paired in sparring 6 of 8 weeks become PARTNERS (a mark on both): x1.15 sparring gain together; when one leaves or turns professional,
the other loyalty -4 (card 15). PARTNERS1 must show the bonus is worth 1.5 wins in 100 a season to the pair; if not, the bonus goes and the -4 stays.
FEUD: two Short fuses paired for Hard sparring 3 times in 8 weeks (card 14 first): they cannot be paired for 4 weeks unless your talk settles it (1 of your
pad places that week, both temper -1, +1 experience).
CAPTAIN (NEW, small): from week 10 you may name one captain on Club week (6+ bouts, Loyal 70+). Any session the captain is in, nobody skips (v4's
discipline skip); the captain's own alone mornings count 0.9 (time given to the room); a senior with more bouts passed over loses 3 loyalty once; a changed
captain loses 3. One chip, one mark-free line. It stacks with The room (yours) and covers the sessions you do not run. CAPTAIN1 must show: in a line-up
with a discipline under 45, a captain saves 2 or more skipped mornings a month; else cut.
WHERE IT SHOWS: the sparring pair picker (v4 B, Monday) names partners and a feud (locked, "settle it: 1 pad place"); the captain chip on Club week; marks.
REAL BASIS: gyms run on sparring partners and a senior the others train behind; one leaving shakes the other.

## 11. Coach grows, small (the hired coach)
- AREAS RISE: each of Coach's five areas (CoachAreas) +1 per 10 sessions Coach runs in it, up to the hire's ceiling (Luke Reid +8; Marcus Hale +12). Shown
  in the Monday review only ("Coach's pads 59"): nobody routes a session to grow an area.
- A SIGNATURE DRILL: 40 of Coach's pad sessions on one move opens it: that move x1.2 mastery on Coach's pads. On Club > People and the move's chip.
- A RAISE: every 2 area points gained, Coach asks +$40 a week. YES: paid. NO: Coach's areas stop rising for 8 weeks, then the ask comes back.
- "Coach and <name>": a hover on Coach's line of the Character tab ("22 sessions together; if Coach goes, -6").
- "Coach runs it" per fighter (AGREED, NOT BUILT): a fighter Coach runs gets none of your sessions, so Known does not grow.
COACHGROW1 must show: a season of growth is worth less than the gap between Luke Reid and Marcus Hale, so the hire still matters.

## 12. Build direction per fighter
WHAT YOU DECIDE: one direction per fighter, any Monday, on the Character tab (and a chip on Club week). From week 8.
| Direction | Trains faster (x1.10) | Slower (x0.90) | Moves +15% on pads | Perk versions first | Dials drift toward (2 a week) |
|---|---|---|---|---|---|
| KEEP IT LONG | Speed, Footwork | Strength, Inside fighting | Jab, Cross | The rangefinder, The eyes, The snap | pressure 30, counter 40 |
| WALK THEM DOWN | Stamina, Inside fighting | Footwork, Timing | Body hook, Lead hook | The drain, The long night, The stalker | pressure 80, work rate 75 |
| COUNTER | Timing, Defence | Stamina, Explosiveness | Check hook, Cross | The trap, The reader, Gets up | counter 75, pressure 45 |
| NONE: ADAPTABLE | nothing | nothing | none | version A first | none; in the corner minute SWITCH IT UP: for the next round the pressure dial moves 25 toward pressing or boxing at range |
| Ana: GUARD PLAYER | Flexibility, Guard | Takedowns, Top game | guard moves first | Guard retention, Back taker | scores from the bottom |
| Ana: TOP GAME | Strength, Takedowns | Guard, Flexibility | takedowns, passes first | Scrambles, Pressure passer | scores from the top |
IN THE FIGHT: the style dials (FighterProfile.style_dials, read by Attrs) move 2 points a week toward the direction; in 8 to 12 weeks the style word changes.
Against the class: half speed, and moment 8 can come. Changing: free, the dials only move toward the current direction.
THE CLASH, SHOWN WHERE IT BITES (NEW): the weak-spot chip on Club week says when the direction slows it ("Timing is slower under Walk them down: its fix 1 week
longer"); the Character tab shows the direction against the next opponent's style ("+0.9 in 100 against Saturday's out-boxer", from DIRECTION1's tables).
DIRECTION1 must show: 12 weeks of a direction win 1.5 in 100 more against the styles it is meant to beat and lose about that against the others; None best in
at least one line-up. Else the fight half is cut and only the training tilt stays.

## 13. What your picks won (NEW)
THE LEDGER: every pick reports what it earned this season, in the unit it works in.
- Fight picks (perk versions, Ringside voice, The minute, One you saw coming, TRUST ME, Hardened, the direction, Switch it up): each hook writes its id on
  the exchange it touched (as PerkFight.round_line does today); the Why's replay (BoutRead's swing replay, built) runs the bout again with that one hook off,
  same dice. The line: "The drain: 41 exchanges, 2 rounds turned, +2.1 in 100".
- Week picks (Long evenings, Early starts, Body first, One on one, The room, the style, Eye for people): counted in the week review in their own unit and what
  it led to: "Long evenings: +14 pad places; Tess's body hook Usable 2 weeks sooner"; "Craft first: +31 mastery across the squad, Stamina -1.2; loyalty Lucy +4,
  Tess -9".
WHERE: Club > You (your picks and the style), the Character tab (that fighter's perk versions, direction, marks), and one line per pick that fired in the Why.
A fight pick under 0.5 in 100 over a season, or a week pick with no season effect, greys out: "a pick to rethink", with SECOND THOUGHTS beside it.
LEDGER1 must show: the ledger's season sums match the probes' averages within the season's noise, and a bot that uses Second thoughts on greyed lines wins
1.5 in 100 more the next season than one that does not; else the ledger keeps the counts and drops the "in 100".

## 14. How it joins the club week (one view)
| Club week decision (v4) | What the RPG layer adds to it |
|---|---|
| Your 4 coached mornings and 2 pad places | Known by group, experience from stat points and habits, levels 2 and 3 reshape them, the habit week at Known 3 |
| Coach's evenings: pads or class | Coach's areas and signature drill; Club night; Craft first makes a pad place worth more |
| The sparring setting and pair | temper drift, traits open, Fire known, PARTNERS and FEUDS, Hard school x1.4, Family club forbids Hard |
| Who corners (you or Coach) | experience and Known only; card 18 remembers |
| The talk and dated promises | experience for a kept promise; card 10; BROKEN PROMISE |
| Ready, building or rest | the knockout turn's odds; Fire goes stale after a knockout |
| Pulls (weak spot, weapon) | the direction's clash on the weak-spot chip; Known narrows each pull's size; a perk pick when the weapon's perk opens |
| The season target | experience when met; matches the ambition or not, and the ambition moves |
| The seat; a captain | discipline drift; card 6; the captain's room |
| Signing (trial mat, walk-in) | the style fit and the style's share of who walks in; Eye for people / Club night; card 11's mate, card 17's pairing |
| The scale and the kilo rule | Eye for the scale; card 5 UP A WEIGHT |
| Fight week | card 12 THE NIGHT OUT |
| Ana's stripe and division | experience; Guard player or Top game; Ana's picks |

## 15. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Club > You (NEW tab, drawn `rpg_coach.png`) | portrait, background edge, level ring and this season's experience by outcome; the either/or pick when one waits, read from your last six bouts, with BEST FOR; the road; your style in this squad's numbers with the trial-mat line and Change; WHAT YOUR PICKS WON; Known pips per fighter with what the next step does; the squad (partners, the captain, a squad card); Coach's raise | new CoachLevel; new CoachStyle; Knowledge; new Ledger; new SquadBonds; CoachGrowth; HeadCoach; ClubDeal; Loyalty |
| Club > People | the YOU card: level, style, "pick waiting"; Coach's card: the signature drill, a raise waiting | StaffCard, CoachLevel, CoachStyle, CoachGrowth |
| Fighter page > Character (NEW tab, drawn `rpg_fighter.png`) | loyalty bar with bands and the FORECAST; WHAT <NAME> WANTS with the moved ambition; MARKS with how each goes, and the sparring partner line; a PERK PICK priced on the next three names; traits with the next line and its button; KNOWN by group (plain once known) with what the next step does; direction with its clash and its value against the next opponent; WHAT YOUR PICKS WON for this fighter; a waiting moment card with coin tags; Coach in hover | FighterPage, new Character panel; Loyalty (forecast); Recruit.ambition + new Ambition; SeasonTarget; new Marks; PerkRoad + new PerkPick; FighterProfile; Exchanges; Knockdowns; CornerJobs.talk; Knowledge; new BuildDirection; new Ledger; new Moments |
| Fighter page > Profile | true numbers for known groups, ranges for open ones; the direction chip; the loyalty word; perk road with picked versions; trait hover with the next line | DarkOverview, AttrBoard, Recruit.stars, Knowledge, BuildDirection, PerkPick |
| Fighters > Club week | each row: direction chip, the style's clash mark, the loyalty forecast, Known "+1" on your slots, the weak-spot chip's clash line, moment cards with coin tags, PERK PICK and LEVEL UP as needs, the captain chip; the pair picker with PARTNERS and FEUD | ClubWeek, ClubDeal, Moments, CoachStyle, Knowledge, Loyalty, SparPair, SquadBonds |
| Fighters cards | the loyalty word; the two trait words with the next line in hover; a corner flag "Moment" or "Perk pick"; marks in hover | RosterCards, RosterFlag, Loyalty, Moments, Marks |
| Find a fighter, the trial, the walk-in | traits "?" until known; the style fit; "came for your <style>"; Known ranges; Eye for people's 1 morning; card 11's mate | RecruitPanel, Trial, Interview, CoachStyle, Recruit, Knowledge, CoachLevel |
| Home | needs: your level pick, a perk pick, a moment waiting, Coach asks for a raise | HomeNeeds, CoachLevel, PerkPick, Moments, CoachGrowth |
| Top bar | flags LEVEL UP, PERK PICK, MOMENT | Shell, Needs |
| Fight night | TRUST ME in the corner minute (85+ and Known 4, once a bout); Ringside voice's third shout, The minute's second set-up, One you saw coming; SWITCH IT UP; the perk versions at work; the experience on the result | FightNight, BoutNight, LiveRound, CornerTrust, Exchanges, CornerJobs, PerkFight, Knockdowns, CoachLevel |
| Result and the Why | one line per pick that fired, with its share; a trait opened or crossing a line; the knockout turn waiting; a mark earned | FightWhy, BoutRead (replay), Ledger, CoachNotes, TraitDrift, Marks |
| Week review (Monday) | experience by outcome; a trait crossing a line and what it now does; Known steps; the knockout turn; a moved ambition; partners or a feud; Coach's areas | WeekReview, ReviewReveal, CoachLevel, TraitDrift, Knowledge, Ambition, Marks, CoachGrowth |
| Playbook > Game plan | Craft first's extra line; the direction's default lines | PlanLines, CoachStyle, BuildDirection |
| History | marks with their dates beside the bouts that made them; CHAMPION at the season's end | BoutHistory, Marks |
| Grappler page | Guard player or Top game; Ana's picks; loyalty, Known and traits as on the Character tab; card 9 | GrapplerPage, BjjSide, BuildDirection, PerkPick, Moments |
| Handbook | Words: Loyalty, Mood, Known, Direction, Style, Level, Mark, Partners, Feud, Captain, Ledger | Handbook |
THE NEW MECHANICS, MENU BY MENU (each shows on every menu below in the .exe, and the golden-path test walks it):
| Mechanic | Menus | Wired to |
|---|---|---|
| Coach level, picks, background card, season picks | Club > You; Club > People; Home; top bar; Week review; fight night; Club week counters | CoachLevel; ClubDeal; Exchanges; CornerJobs; LiveRound; Favours; WeekBill |
| Fighter perk picks (and Ana's) | Character tab; Profile; Home; top bar; Club week; fight night; Grappler page | PerkRoad; PerkPick; PerkFight; Knockdowns; TheRead; BjjMatch; BjjBeat |
| Loyalty as the bond (bands, forecast, TRUST ME) | Character tab; Club week rows; Fighters cards; fight night | Loyalty; CornerTrust; LiveRound; CornerJobs; Moments |
| Coaching style, the fit, the trial mat | Club > You; Club week; Character tab; Playbook; sparring cells; trial, walk-in, Find a fighter | CoachStyle; WeekPlan; SparSet; PlanLines; Loyalty; Recruit; RecruitPanel |
| Traits at lines and drift | Character tab; Profile hover; cards; Why; Week review | TraitDrift; CoachNotes; FighterProfile; Exchanges; LiveRound; Knockdowns; CornerJobs; PushBack |
| What they want, ambitions that move | Character tab; Club week season target; Week review | Recruit.ambition; Ambition; SeasonTarget; Loyalty |
| Build direction and its clash | Character tab; Profile; Club week chips; Grappler page; Playbook; corner minute | BuildDirection; WeekPlan; PadWeek; MoveMastery; style_dials; BjjSide |
| Known by group | Character tab; Club > You; Profile; trial card; bout sheet; pull chips | Knowledge; Recruit.stars; LeverSize; BoutSheet; HabitWeeks |
| Moments, memory, marks | Club week rows; Home; top bar; Character tab; History; card hover; Grappler page | Moments; Marks; ClubDeal; Loyalty; TraitDrift; Knockdowns |
| Partners, feuds, captain | pair picker; Club week; Club > You; Character tab; Week review | SquadBonds; SparPair; Marks |
| What your picks won | Club > You; Character tab; the Why | Ledger; BoutRead; WeekReview |
| Coach grows | Club > People; Home (raise); Week review; Character tab hover | CoachGrowth; CoachAreas; MoveMastery |

## 16. The reveal order (added to v4's weeks 1 to 5)
| Week | Arrives | What the guide says |
|---|---|---|
| 6 | your level and the first pick; your style | "Your first pick. Your hours, your way." |
| 7 | Known (pips on the fighter pages) | "You know them by the hours you put in." |
| 8 | build direction; moments; perk picks; the ledger's first lines | "Build each one toward a way of fighting." |
| 10 | Coach's growth; partners on the pair picker; the captain | "Coach gets better at what Coach runs." |

## 17. THE HOOK TABLE (every effect, and where it lands)
CODE = a function in the game today that the effect changes or reads. WEEK = a club week v4 rule, built before this layer. NEW = a small new hook, named.
| Effect | Lands on |
|---|---|
| Long evenings, Early starts, Body first | WEEK 3.1 counters (your pad places, coached mornings, the shared morning's 0.8) |
| One on one | CODE Knowledge.expose x2; WEEK 3.2 habit training on your sessions |
| The room; the captain | WEEK 3.7 the discipline skip; CODE FighterProfile personality "discipline" |
| Club night; Eye for people | CODE Knowledge.expose (new calls for class evenings; x1.5); WEEK the trial watch |
| Ringside voice; Listens (coachability 70) | CODE Exchanges.uptake: FULL_SHOUTS read per fighter (2, +1 each) |
| Stubborn (coachability under 40) | CODE LiveRound: the fixed habit costs half its HabitFix.cost, not nothing |
| The minute | CODE CornerJobs set-up (a list of two, each its own gap); LiveRound's fix kept a second round |
| One you saw coming | CODE CornerJobs.setup_edge called with fits = true once a bout |
| Eye for tape | WEEK 4 the film evening |
| Eye for the scale | WEEK 3.5 / the bill: Eat less per 0.2 kg; the kilo rule's favour |
| A name in the trade; A home for life | WEEK 3.5 favours, the trial mat; WEEK 3.8 loyalty |
| Hold pads, the free short week, third answers | WEEK 3.1, 3.8; Moments |
| TRUST ME | CODE LiveRound's shout gate (CornerTrust.lands skipped, FighterProfile.trust 1.05); CornerJobs.RECOVER_POINTS 4 |
| Loyalty forecast | WEEK 3.8 prices run over the dealt rota (the board's deal preview) |
| Hard school | CODE WeekPlan "hard" gain 1.3 -> 1.4; WEEK Hard sparring; heart drift |
| Craft first | CODE MoveMastery pad gain x1.15; PlanLines line count +1; temper drift |
| Family club | WEEK 3.8 loyalty losses x0.7; WEEK sparring setting without Hard |
| The trial mat | CODE Recruit's trait roll, weighted 2 in 3 |
| Heart | CODE Knockdowns REF_STOP x(1.4 - heart / 100), KO_ODDS; FighterProfile mood |
| Confidence, temper, discipline lines | CODE CornerJobs.talk (45, 50, 65, 60); TheRead.trigger; PushBack LOW_DISCIPLINE; WEEK the 45 skip |
| HARDENED, SHAKEN, Iron chin GETS UP | CODE Knockdowns stop_mult on their own side (BoutNight sets side "a" as it sets "b" for Finisher; puncher_chance must read stop_mult too, it does not today); GETS UP also KO_ODDS x0.5 |
| The rangefinder | CODE PerkFight.jab_edge on situation "range" |
| The long night | CODE LiveRound: the round's spent energy x0.85 from round 2 |
| The eyes | CODE Exchanges.call_edge "finds": the best answer, not the ok one |
| The reader | CODE TheRead.looks_needed x0.75 |
| The drop | CODE Knockdowns.round_counts: the 0.6 fall-off skipped for that winner |
| The stalker | CODE LiveRound exchange: +4 while opp_hurt |
| The snap | CODE PerkFight.combo_rate for single-punch lines |
| Guard retention, Scrambles, Back taker, Pressure passer | CODE BjjMatch.odds by kind (pass, back); BjjBeat._miss_flips |
| Known: groups, plain numbers, steps | CODE Knowledge.expose, width, stale; NEW Knowledge.known; WEEK the habit weeks (pip 3) |
| Direction | CODE WeekPlan gain; MoveMastery; FighterProfile.style_dials (Attrs) |
| Switch it up | CODE style_dials for the next round |
| FIRST HOME WIN, CHAMPION's fans | WEEK 3.10 fans |
| CHAMPION's confidence floor | CODE CornerJobs.talk reads confidence |
| BROKEN PROMISE | WEEK 3.8 promises |
| PARTNERS, FEUD | WEEK the sparring pair (v4 B) |
| Coach grows | CODE CoachAreas; MoveMastery (the signature drill) |
| The ledger | CODE PerkFight.round_line pattern (ids on exchanges); BoutRead's swing replay; WeekReview counts |

## 18. To be measured before the build (the cut rule: under 1.5 wins in 100 on the bouts where it fires and no season effect = cut or redesign)
A season effect is one of: weeks to a target, a fighter kept, dollars, a habit gone. Each probe runs on the played bout, after LOYAL1.
- COACHPICK1 (NEW): each coach level pair and each background card: each side best in at least one of the eight line-ups by 1.5 in 100 or a season effect;
  a pair that fails is redesigned; the pick card's BEST FOR comes from it.
- PERKPICK1: each perk version beats the other against some style by 1.5 in 100; else one perk. BJJPICK1 for Ana's pairs (3 matches in 100).
- KOTURN1: Hardened against Shaken changes stoppage losses by 1 or more a season; Rest moves the Hardened count by 1 in 4.
- TRAITLINE1 (NEW): each printed line moves wins 1.5 in 100 on the bouts where it applies; a line under that moves to hover (the number stays true).
- TRUSTME1 (hurt or Flat rounds; else the trial-mat friend). KNOWN1. DIRECTION1 (and None best once). STYLE1 (and the trial mat). PARTNERS1 (else the -4
  only). CAPTAIN1. COACHGROW1. LEDGER1 (NEW). MOMENT1 (with the PAD third). COACHXP1 (3 to 4 steps careful, 2 to 3 the other; a season pick each season after).

## 19. Build order, in small tasks
1. Probes above (cloud, pure). 2. Pure rule modules with unit tests, one a task: CoachLevel, CoachStyle, TraitDrift, BuildDirection, PerkPick (the eight
pairs and Ana's as hooks), Moments (deck, notes, coin tags), Marks (with their way out), SquadBonds (partners, feuds, captain), Ambition, Ledger,
CoachGrowth; Loyalty gains the bands, the forecast and TRUST ME; Knowledge gains `known` and the pip bands. 3. Wire them on the hooks of section 17 (one
task per module touched, each with its test going red first). 4. Screens: Club > You, the Character tab, then chips and needs on Club week, Profile, cards,
Home, top bar, Why, Week review, pair picker, History, signing cards. 5. The golden-path test walks: a level and a pick, a style chosen, a direction set,
a perk pick priced on names, Known making Body plain, a trait crossing a line, a moment answered and its memory card later, a mark earned and lost, partners,
a captain named, a ledger line greyed and Second thoughts taken, a knockout turn after Rest, TRUST ME used once.

## 20. Risks, said plainly
- More on day one: kept off it by the reveal order (weeks 6 to 10).
- Loyalty carries the bond and its rewards: LOYAL1 plus STYLE1 check no deal is "always keep everyone 85+"; TRUST ME now also needs Known 4.
- Ranges can read as hiding numbers: a known group shows plain true numbers, and an open one shows a range that holds the truth.
- The ledger replays bouts: one replay per pick that fired, the same pure replay the Why already runs.
- Eight perk pairs, Ana's four, eighteen cards, eight marks: all ESTIMATE. The probes cut, they do not decorate.
- Coach's growth must not make the second hire pointless (COACHGROW1).

## REJECTED (asks not taken, and why)
- Iron chin's GETS UP as "the third count in a round does not stop the bout" (systems 1): it breaks the real amateur rule (three counts in a round stop it,
  Knockdowns.COUNTS_ROUND_STOP). Taken instead: stop odds x0.8 and a badly hurt count stays down half as often.
- "Confidence 75 = Fire up +2.0" (systems 5): the code does the opposite (Fire up lifts an unsure fighter most: +2.0 under 50, +1.5 above), and that is the
  real corner. The map prints the code's lines.
- "Coachability 40 = a corner fix lands in 1 round, not 2" (systems 5): a fix lasts one round in the code and works in full. Taken as: under 40 it holds half.
- A weight forecast range so Eye for the scale has something to remove (systems 8, first option): it would add fog to a number that is true today. Taken:
  the second option, a real price halved.
- "+2 / +3 experience on the slots at the deal" (designer v1, kept in v2): reversed on the coach's point that it baits the week; experience is read after.
- The left rail and the tab names Overview, Week, Fight prep, Playbook, Character, History (trainer v1): the shell has had no left rail since S416, and the
  fighter page's tabs are the S431 matched look the owner liked (Q-182). Character joins them as the seventh.
- Staff loyalty bands with Coach leaving for Eastside ABC (trainer v1): that is the rival club that poaches, left for the small living world.
- A fighter's own bond number with Coach: two bond numbers per fighter breaks the one-number rule. "Coach and <name>" is a hover.
- ADAPTABLE as "one opponent tell fewer is known" (designer v1): amateur opponents do not scout your fighters in the game.
- Levels 7 to 10 as four new pairs each (trainer v1): twenty new pairs widen content without new decisions; the season pick gives the yearly goal.
- "Let them talk = a rival corner card two bouts later" (designer v1): opponents' corners have no memory in the game (the living world).

## RPG MECHANICS FOR THIS VERSION
1. COACH LEVEL: experience from what your own hours achieve; levels 2 to 6 with five either/or picks (BEST FOR from COACHPICK1), a background card at one level; a season pick each year after.
2. FIGHTER PERK PICKS: each of the eight perks opens as two versions, every one on a real fight hook; the pick priced on the next three names; Ana picks at the white belt's fourth stripe and at each belt.
3. LOYALTY IS THE BOND: one number per fighter with a forecast; bands unlock holding pads, the free short week, priced third answers, the captaincy and TRUST ME.
4. COACHING STYLE: three ways, shown in this squad's numbers, on every signing card, and in who walks in; changed once a season at a cost.
5. TRAITS AT LINES: each shows its next line, what crossing it does and the button that moves it; hidden until known; drift; the knockout turn.
6. WHAT THEY WANT: ambition and season target side by side; the ambition moves at milestones; matching pays, crossing costs.
7. BUILD DIRECTION: Keep it long, Walk them down, Counter, or None (Switch it up); Guard player or Top game; its clash on the weak-spot chip.
8. KNOWN: Knowledge.gd's ranges, by group, from your own sessions; a plain true number once known; each step does something.
9. MOMENTS AND MARKS: eighteen cards with memory and squad cards, a coin on every answer; up to four marks, each with an effect and a way out.
10. THE SQUAD: partners, feuds and a captain.
11. COACH GROWS: areas rise with sessions run, a signature drill, a raise to answer.
12. WHAT YOUR PICKS WON: a ledger for every pick, and Second thoughts for the weak ones.
Built already and kept: the background edge, the signing card, the perk road (now picked), CoachNotes, HabitFix, StripeCall, CornerTrust, Knowledge, TheRead.

## LEFT FOR LATER
- A rival club that poaches (fighters and Coach): its offer reads loyalty; promises and poaching at contract time.
- Scars: past injuries changing future risk; a fighter's prime and decline; retirement talk; retired fighters back as coaches.
- More than one style at once; a full respec of coach perks.
- A professional's own moments with promoters and managers; opponents' corners that remember.
- A crossover direction (a boxer learning to grapple), which waits for the crossing rules.
- Hype (HYPE1, its own map) lifting Knowledge's ranges.
