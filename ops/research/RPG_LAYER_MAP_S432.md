# RPGLAYER1: the RPG layer for you, Coach and your fighters (S432, v2 after two critics)

The owner's words: "i want a bit more rpg elements with coach and fighters", then "yes add the rpg layer after the review".
Builds on the club week (`ops/research/CLUBWEEK_MAP_V4_S432.md`, with the verdict's ten changes, `docs/mockups/s432/critics/VERDICT.md`). Nothing in
the club week's rules changes; every new choice is paid in the club week's own coin: pad places, coached mornings, cash, loyalty, favours, fans.
Words: "You" is the head coach, the player. "Coach" is the hired assistant coach. Game text never says he, she, her or him.
Drawn: `docs/mockups/s432/rpg_coach.png` (Club > You, your own page) and `docs/mockups/s432/rpg_fighter.png` (a fighter's Character tab, Tess Reilly).

V2 (critics v1: a character-progression designer 6, a former professional trainer 6.5; reviews in `docs/mockups/s432/critics/rpg_*_review.md`). What
changed: the fighters now PICK their perks (two versions of each of the eight); the read is renamed KNOWN and built on the existing Knowledge.gd;
level 3 is a real trade; each background shapes one level; growth goes on after level 6 (one season pick a year); traits say what they DO in the
code's numbers; moments carry memory and leave MARKS, with squad cards; PARTNERS and FEUDS between your fighters; Coach (the hired coach) grows,
small; TRUST ME moved into the corner minute; build direction is a true trade and None has its own plus; WHAT <NAME> WANTS on the Character tab;
the style fit on every signing card; one cornered bout pays experience and Known only. Rejected asks, with why: the REJECTED section near the end.

ALREADY BUILT AND KEPT (read in the code, S432): Recruit (class from style, potential in stars as a range, ceilings, two traits on show, one habit,
signature, ambition, one starting focus); PerkRoad + PerkFight (8 perks opened by attributes, each with a fight hook); CornerTrust (a wrong call costs
mood, a Low fighter stops listening); HeadCoach (your background, one edge); CoachAreas (Coach's five areas); HabitFix; CoachNotes (habits and traits at
70+ or 40- revealed by fights, film and sparring); StripeCall; FighterProfile (six traits; mood scaled by heart, confidence, coachability; style dials);
Knowledge (KNOW1, S411: ranges per group Body / Skills / Fire that narrow with exposure, "the range never lies"; built and tested, wired nowhere yet);
the v4 loyalty (the trait made live by the deals).

## 1. The idea in eight lines
- YOU GROW: experience from what you do in person raises your level; each level is an EITHER/OR pick, one level shaped by your background; after
  level 6, one SEASON PICK a year (deepen a perk you took, or take back a side you closed).
- YOUR FIGHTERS PICK TOO: each of the eight perks opens as two versions; you pick one for that fighter, for good. Build direction says which suits.
- ONE NUMBER PER FIGHTER: LOYALTY is the bond. No new meter. Mood stays the short one; loyalty the long one, with bands that unlock things.
- YOUR STYLE: Hard school, Craft first or Family club; it colours the gym, suits some people, clashes with others, and shows on every signing card.
- TRAITS MOVE AND SAY WHAT THEY DO: hidden until known; worn down or hardened by the weeks; each row prints its effect in the fight's own numbers.
- BUILD DIRECTION: Keep it long, Walk them down, Counter, or None (Adaptable); two abilities faster, two slower; the style dials drift.
- KNOWN: how well you know each fighter, from the hours you give them in person; Knowledge.gd's ranges narrow; traits open.
- MOMENTS, MARKS AND THE SQUAD: story cards that remember your answers, marks that stay on the sheet, partners and feuds; and Coach grows with
  the sessions Coach runs.

## 2. You grow: coach level and the either/or perks
WHAT YOU DECIDE: at each new level, one of two perks (three at your background's level), for good. Club > You and the top-bar flag LEVEL UP.
EXPERIENCE (only things you do in person; Coach's work gives you nothing). Shown AT THE DEAL: each Club week slot that earns experience carries a small
"+2" or "+3" the moment you deal it, and Club > You reads "This week's board can earn you +9" with the list.
| Source | Experience | The club week decision behind it |
|---|---|---|
| A bout you corner | +2, +1 more on a win | who corners when two halls run the same night (v4: you or Coach) |
| A professional's camp run to its bout | +2 | the camp's load and the pad places it takes |
| A habit trained out on your pad places (or, with One on one, your mornings) | +3 | your 2 pad places a week (only yours train a habit, v4 3.2) |
| A dated promise kept | +2 | the talk card's promise (v4 3.8) |
| A season target met | +4 | the season target (v4 3.9) |
| A fighter's perk picked | +1 | the weapon pull, and the pick itself (section 6) |
| A fighter reaches KNOWN 5 | +2 | whom you coach in person (section 8) |
| A feud settled by your talk | +1 | the pad place it costs (section 10) |
| Ana's stripe given on time / a belt | +1 / +3 | the stripe call (StripeCall) |
CAP PER BOUT (critic): a cornered bout pays experience and Known (bout exposure) only. It no longer also pays loyalty or coachability, so who corners
on a two-hall night stays a real choice (the other fighter's Known and loyalty come from the week instead).
LEVELS (ESTIMATE): level 2 at 12, 3 at 28, 4 at 46, 5 at 66, 6 at 90; then a SEASON PICK each 45 more (135, 180, 225, 270), at most one a season.
A first season with this line-up (about 18 bouts cornered, 9 won, 4 professional camps, 2 habits, 3 promises, 2 targets, 3 perks picked, Ana's
stripes) gives about 79: levels 2 to 5 in season 1, level 6 early in season 2, a season pick every season after. COACHXP1 must show 3 to 4 steps in a
first season for a careful player and 2 to 3 for one who lets Coach corner and deal; and a season pick reached in each of seasons 2 to 5.
THE PICKS (each pair moves the same coin both ways; ESTIMATE unless marked):
| Level | The question | Pick one | or the other | Your background's third card |
|---|---|---|---|---|
| 2 | Where your hours go | LONG EVENINGS: your evening gives 3 pad places (was 2); your coached mornings 3 (was 4) | EARLY STARTS: your coached mornings 5 (was 4); your evening 1 pad place (was 2) | STRENGTH COACH, BODY FIRST: your coached Cardio and Strength mornings take two fighters at 1.0 each (shared is 0.8); your craft mornings stay one fighter |
| 3 | How you run a room | ONE ON ONE: a morning alone with you counts twice toward Known, and can train out a habit like a pad place | THE ROOM: any session you run with two or more fighters: nobody in it skips (v4: discipline under 45 skips 1 alone morning in 3), and each gets discipline +1 every 4 weeks | AMATEUR COACH, THE CLUB NIGHT: Coach's class evenings count 0.5 toward Known for every amateur in the class, and the class's +$350 stays |
| 4 | The corner | RINGSIDE VOICE: 3 shouts a ROUND land in full (code: Exchanges.FULL_SHOUTS = the round's first 2; later shouts at half); the corner minute keeps two fixes | THE MINUTE: three fixes in the corner minute (code: two); shouts stay 2 a round in full | EX-PRO, ONE YOU SAW COMING: once a bout, your set-up NOW! is read as a best fit if the gap is there at all (CornerJobs.setup_edge fits); shouts and fixes stay as they are |
| 5 | What you see | EYE FOR TAPE: the film evening answers two questions, not one (v4 4); it takes your evening, not Coach's | EYE FOR PEOPLE: Known grows 1.5 times as fast; watching a trial fighter takes 1 coached morning, not 2 | OLD HAND, EYE FOR THE SCALE: every weight forecast is exact (no range) on every page; once a season, asking a show club for a kilo (v4 3.5) costs no favour |
| 6 | Your name | A NAME IN THE TRADE: each season starts with +1 favour at each show club; once a season the trial mat brings a prospect of potential 80+ | A HOME FOR LIFE: a Loyal fighter (70+) loses no loyalty to going short, and leaving waits for a third talk, not a second | none |
THE PICK CARD reads from YOUR record and YOUR squad: level 4 shows "last 6 bouts: 9 shouts landed at half" against "4 minutes with a third fix
waiting"; level 2 shows "Tess's 2 Cardio mornings with you: Stamina +0.5 a week, was +0.4". The road shows both sides of every later level ahead of time.
SEASON PICK (after level 6, one a season, at 45 experience each; Club > You). Pick ONE of:
- DEEPEN a perk you took. Each side has one deepening, same coin (ESTIMATE): Long evenings: 4 pad places on your evening, mornings 2. Early starts:
  6 coached mornings, no evening pads. Body first: three fighters at 1.0. One on one: a morning alone also opens one tell of that fighter's own habit.
  The room: the room's discipline +1 every 3 weeks. Club night: 1.0 toward Known. Ringside voice: round 3's shouts all in full. The minute: a fourth
  fix in the last minute of the bout. One you saw coming: twice a bout. Eye for tape: the film answers three. Eye for people: x2. Eye for the scale:
  two kilos a season. Name in the trade: +2 favours. Home for life: also Settled (50+) loses no loyalty to going short once a month.
- SECOND THOUGHTS: take the side you closed at one level (the side you held closes instead). Not a respec: one level, once a season, and the
  experience is spent.
REAL BASIS: real club coaches choose where their own hours go, one-to-one against group work, and a corner known for its voice during rounds or its
minute between them (J55: two instructions get through). XCOM 2's promotion pick is the game model; Darkest Dungeon's camping skills for the deepening.
LINKS: every pick is felt on Club week's counters (2, 3), on fight night (4), on the bill, weight and Known (5), in favours or loyalty (6).
CUT: a coach perk that is only "+5% training"; experience from members or money.

## 3. One number per fighter: loyalty is the bond
DECISION (kept): the bond with you IS LOYALTY, the v4 number (0 to 100, moved by your deals). No separate bond or trust meter. MOOD = now (this week's
training, this fight's listening: CornerTrust and Exchanges uptake); LOYALTY = you and them over the season. The screen shows mood as its word and
loyalty as the one bar. A fighter has no second loyalty number toward Coach (section 11 keeps "Coach and <name>" as sessions, not a meter).
WHAT BUILDS AND BREAKS IT: all of v4 3.8 (going short, a week dealt in full, promises, the seat, holding pads, a ready sheet passed, the season target,
the stripe call, overtime), the verdict's changes, and the RPG sources (ESTIMATE): your style suits them +1 every 4 weeks, clashes -1 every 2 weeks;
moment answers (section 9); a season target that matches their ambition +5 more when met, one set against it -5 when set (section 7); a partner
leaving -4 (section 10). A bout you corner no longer gives loyalty (cap, section 2).
WHAT IT UNLOCKS (the bands, on the loyalty bar; v4's lower bands kept):
| Band | Loyalty | What it does |
|---|---|---|
| Leaving | under 25 | after two talks, leaves the next Monday for Eastside ABC (v4) |
| Wavering | 25 to 49 | the WANTS A WORD card; signs with an outside manager at turning professional: the club keeps 10%, not 25% (v4) |
| Settled | 50 to 69 | nothing more |
| Loyal | 70 to 84 | can HOLD PADS (+1 pad place at 0.7); one short week in four costs no loyalty (verdict change 2); moments offer a third, generous answer, each with its own price |
| Trusts you | 85+ | TRUST ME, in the corner minute: once a bout, your TALK lands in full whatever the mood (it skips CornerTrust.lands and the mood's TRUST share for that talk), and in a round they were hurt, RECOVER has 4 points, not 3 |
TRUST ME, REAL BASIS: the trusted coach's word matters most in the minute when the fighter is hurt. TRUSTME1 must show 1.5 wins in 100 on bouts with a
hurt round; else 85+ instead brings a friend to the trial mat once a season (a prospect of potential 70+): a recruit, not a number.

## 4. Your coaching style (the gym's philosophy)
WHAT YOU DECIDE: one style for the gym, on Club > You, from week 6. Changed at most once a season: every fighter's loyalty -4 and the new style's plus
counts half for 4 weeks. Every number on the style cards is shown in THIS squad's weeks, as the pick cards are ("Lucy: Stamina +0.36 a week, was
+0.40"; "Tess, Stubborn: -1 every 2 weeks, 60 by July"), with the multiplier in hover.
| Style | What it colours in training (ESTIMATE) | Its price | Suits (+1 loyalty / 4 weeks) | Clashes (-1 loyalty / 2 weeks) |
|---|---|---|---|---|
| HARD SCHOOL | Hard mornings x1.4 (code x1.3); Hard sparring x1.4 (v4 x1.3); heart +1 every 8 weeks for all | every loyalty loss x1.3 | Big heart, Disciplined | Fragile, Folds when hurt |
| CRAFT FIRST | pad places teach x1.15 mastery; a plan holds one more line; temper -1 every 8 weeks for all | Cardio and strength mornings x0.9 | Listens, Confident | Stubborn, Short fuse |
| FAMILY CLUB | every loyalty loss x0.7; the talk's "give the pad place back" +6 (v4 +4) | no Hard sparring at the club (Technical or Body only) | Loyal, Fragile | Wanders off the plan |
THE FIT AT SIGNING (NEW): the trial card, the walk-in card and Find a fighter show the fit for each trait on show ("Listens: suits Craft first"; a trait
not known yet shows "?"). So the style shapes whom you sign, its biggest effect in a real gym.
REAL BASIS: clubs are known for a way; boxers move gyms over exactly this fit.
STYLE1 must show: no style best in more than 2 of 3 seasons across the eight line-ups; a clash costs at least one band of loyalty a season if nothing
else is done.

## 5. Traits: what they do, and how they change
THE FIVE (FighterProfile.TRAITS less loyalty, which is the bar of section 3 and is NOT repeated in the traits list).
WHAT EACH DOES, IN THE CODE'S NUMBERS (printed on the Character tab, the Profile hover and the fighter card's two trait words; Tess's values as the example):
| Trait | Tess | What it does in the game (code) | The line it is moving toward |
|---|---|---|---|
| Coachability | 36 Stubborn | takes in 81 in 100 of each of the round's first 2 shouts (Exchanges.uptake 0.7 + 0.3 x 0.36); an overruled ask hurts mood x1.15 (FighterProfile) | at 40 the word goes; at 70 Listens (91 in 100) |
| Heart | 84 Big heart | gets up at 5 on a count (Knockdowns: 8 - heart / 25); badly hurt, stays down 1 in 9; the referee's stop odds x0.56 (x0.9 at heart 50); a loss hurts mood x0.8 | holds |
| Confidence | 70 Confident | "Fire up" adds +1.5 power an exchange next round (2.0 under 50); wins lift mood x1.04; a missed goal hurts mood x1.15 (CornerJobs.talk, apply_morale) | at 45 "the truth" turns against them |
| Temper | not known | at 65+ (Short fuse): "Fire up" turns wild (-2, hurt x1.6), "Calm down" +1 (CornerJobs.talk); the counter trigger drops (TheRead) | (known at Known 2 or a Hard spar) |
| Discipline | not known | under 50 pushes back on a Hard week (PushBack); under 45 skips 1 alone morning in 3 (v4); at 60+ "the truth" works (+1.2) | (known at Known 4) |
HIDDEN, THEN KNOWN: the signing card shows two traits (Recruit.traits); the rest show "?" until known; a hidden trait still acts. A trait opens from
CoachNotes (one per bout, film for habits), in sparring by the setting (ESTIMATE: Hard 50 in 100, Technical 35 (code), Body only 20), at Known 2 and 4
(section 8), from a moment that names it.
WORN DOWN OR HARDENED (ESTIMATE; each trait moves at most 10 a season):
| Trait | Rises when | Falls when | The decision behind it |
|---|---|---|---|
| Heart | +3 a win from behind on the cards or after a count; Hard school +1 / 8 weeks | the knockout turn (below) | the corner; rest or ready |
| Confidence | +2 a stoppage win; +2 three wins running | -4 a stoppage loss; -2 a loss to a name below | which bout on the sheet |
| Discipline | +1 each 4 weeks with no skipped alone session; The room +1 / 4 weeks | -1 each week a session is skipped | the seat, a team-mate in the room, level 3 |
| Temper | +1 each 2 Hard sparring evenings | -1 each 4 Technical or Body only evenings; Craft first -1 / 8 weeks | the sparring setting and pair |
| Coachability | +1 an ask heard (PushBack); +1 every 4 weeks at Loyal | -2 an overruled ask; -1 a wrong call followed (CornerTrust) | hearing asks; the bond |
CROSSING A LINE: the word on the card changes and the Monday review says what that changes ("Tess: Stubborn is wearing down, 36 to 41: now takes in
82 in 100 of a shout").
THE KNOCKOUT TURN: after a stoppage loss, or two counts in one bout, a roll the Monday after: HARDENED (heart +6, mark) or SHAKEN (heart -6, confidence
-4, mark). Base 50 in 100. Toward HARDENED: REST 2 weeks (v4) +15; you sat with them (moment 1) +15, +25 if a SAT WITH THEM mark is already there; Loyal
+10. Toward SHAKEN: back on a sheet inside 3 weeks -20; Fragile -10. The odds show at Known 5, a range before. A knockout also makes you know them less:
Knowledge.stale cuts their Fire knowledge to 60% (built).
TRAITDRIFT1: a season of Hard sparring moves temper by 5 or more. KOTURN1: Rest 2 weeks moves a season's Hardened count by at least 1 in 4.

## 6. Their perks: two versions each, you pick (NEW)
WHAT YOU DECIDE: when a perk's need is met (PerkRoad.status), it does not open by itself: a PERK PICK waits (top-bar flag PERK PICK, the Character tab,
the Profile perk road). You pick one version for that fighter, for good; before Monday's Start week, else the version their direction lists first.
| Perk (need, code) | Version A | Version B |
|---|---|---|
| Iron chin (Durability 70) | TAKES IT: the first count each bout is only a stagger (code today) | GETS UP: every count they get up 2 sooner (Knockdowns up_at -2), and the referee waves it off x0.8 |
| Stiff jab (Accuracy 65) | THE FENCE: +3 power when the opponent presses (code today) | THE RANGEFINDER: +2 power when the opponent boxes at range, and the opponent's set-ups land x0.8 |
| Second wind (Stamina 70) | THE BELL: +10 energy at the bell for round 3 (code today) | THE LONG NIGHT: tiredness costs 15% less in every round after the first |
| Ring general (Fight IQ 65) | THE VOICE: corner calls that fit work 25% better (code today) | THE EYES: the opponent's mode shows one exchange early on the shout bar (the clue for the next 30 seconds) |
| Counter sense (Defence 65 + Check hook 30) | THE TRAP: a free counter 3 in 10 when an attacker misses (code today) | THE READER: the read on each opponent habit fills 1.3 times as fast (TheRead) |
| Body snatcher (Body hook 30) | THE DRAIN: body shots drain 15% more energy (code today) | THE DROP: a body shot after a count: a second knockdown 1 in 10 |
| Finisher (Explosiveness 70) | THE CLOSER: once the opponent takes a count, the referee stops it 1.5x as often (code today) | THE STALKER: a hurt opponent's next exchange is +4 power for them |
| Fast hands (Speed 70) | THE FLURRY: combinations land whole more often, x1.4 edge (code today) | THE SNAP: single shots +2 power, and the jab's energy cost halved |
Build direction lists one version first (Keep it long: The rangefinder, The eyes, The snap; Walk them down: The drain, The long night, The stalker;
Counter: The trap, The reader, Gets up). The pick card shows "best against" from PERKPICK1 and the fighter's next bout.
REAL BASIS: two boxers with the same gift use it differently (a body puncher who wears people down, one who drops them); a coach shapes which.
PERKPICK1 must show: each version beats the other against some style by 1.5 wins in 100 or more; else that pair goes back to one perk.

## 7. What <name> wants (NEW on the Character tab)
Shows the AMBITION (Recruit.ambition, today shown on the signing card and changing nothing), the SEASON TARGET (v4 3.9), whether they MATCH, and what is
left to reach it. Setting a target that matches the ambition: met = loyalty +5 more. Setting one against it: loyalty -5 at once ("you want something
else for me"). The decision sits where it already is (the season target on Club week); the Character tab shows its price before you set it.
REAL BASIS: a boxer who wants a title and is told "a year to grow" hears it. The idea backlog's "career goals set by the fighter".

## 8. Known: how well you know each fighter (renamed; built on Knowledge.gd)
NAME: "How well you know <first name>"; one word on chips and in the Handbook: KNOWN. "The read" stays the fight rule (TheRead.gd).
ONE RANGE SYSTEM: Known IS Knowledge.gd (KNOW1). No new CoachRead rule. Its three groups (Body, Skills, Fire) and continuous ranges stay; the five pips
are bands of the share of each group's range already gone (from Knowledge.width), averaged over the three groups.
WHAT YOU DECIDE: whom YOU coach in person. Only your sessions add exposure; Coach's add none (One on one, Eye for people and Club night change this).
| Your session | Knowledge.expose (ESTIMATE amounts) |
|---|---|
| your coached morning on them (shared 0.5; One on one x2) | "session" 1 to Body (Cardio, Strength) or Skills (bag, craft) |
| one of your pad places | "session" 1 to Skills |
| a sparring evening they spar on your evening | "spar" Hard 1.5 / Technical 1 / Body only 0.5, to Skills and Fire (Fire capped by FIRE_SPAR_CAP) |
| a bout you corner | "bout" 3 to Fire, "session" 1 to Body and Skills |
| the trial watch (v4) | "test" 2 to Body and Skills |
| Pip | Share of the range gone (exposure about) | Also opens |
|---|---|---|
| 1 | a fifth (3) | the pull sizes' ranges halve |
| 2 | two fifths (8) | one hidden trait (the most extreme) |
| 3 | three fifths (18) | potential to half a star; their win band on the bout sheet normal width |
| 4 | three quarters (36) | every trait |
| 5 | five sixths (60) | the knockout turn's odds before rest or ready; +2 experience |
Fire is known only from sparring and bouts (FIRE_SPAR_CAP): you know their heart when you have cornered them. A knockout, layoff or step up cuts Fire
to 60% (Knowledge.stale, built): after a knockout you learn them again. Beside each fighter's pips: "step 3 in 4 sessions: potential to half a star",
so Known says whom to coach next. HYPE1 (queued separately) owns Knowledge's hype lift.
REAL BASIS: coaches say it takes months in the gym to know a fighter, and their heart only shows under fire.
READ1 (renamed KNOWN1) must show: a bot that picks with full numbers wins 1.5 in 100 more a season than one on pip-0 ranges; else Known keeps only the
traits (pips 2 and 4) and the ranges go back to Knowledge's plain exposure.

## 9. Moments with memory, and the marks they leave
Story cards from a trait, loyalty, an event or an EARLIER ANSWER. In the fighter's row on Club week like the talk card; answered before Start week (else
the plain answer and loyalty -1). At most one per fighter every 6 weeks and one a week at the club; never in that fighter's fight week; NO CARD TWICE FOR
ONE FIGHTER IN A SEASON. From week 8. The talk card (v4) stays the loyalty-under-50 card.
MEMORY: every answer writes a note on the fighter (data, dated). Later cards read the notes; the lasting ones become MARKS on the sheet.
| # | Card | Comes when | Answers and prices (ESTIMATE) |
|---|---|---|---|
| 1 | AFTER THE KNOCKOUT | the Monday after a stoppage loss | SIT WITH THEM: 1 of your pad places, Hardened +15 (+25 with a SAT WITH THEM note). BACK ON THE SHEET: Ready, Hardened -20. TWO WEEKS OFF: Rest, Hardened +15 |
| 2 | CALLED OUT | a named rival on the regional table calls them out in the news (replaces "the name above", which the bout sheet has) | TAKE IT: that rival is next sheet's name above, loyalty +3, fans +3; a loss there confidence -4 and note. LET IT GO: confidence -2. A DATE: a dated promise (kept +5, broken -12) |
| 3 | A WEDDING ON SATURDAY | the week before a weekend with no bout | LET THEM GO: Saturday lost, loyalty +3, note. SAY NO: loyalty -3. Loyal only: GO, TRAIN SUNDAY: you open Sunday, one of next week's coached mornings |
| 4 | SPARKS IN SPARRING | Short fuse, a Hard evening | SIT THEM OUT: the evening lost, temper -2. LET IT RUN: partner +10 tiredness, cut risk doubled, temper +2, feud count +1. ON THE PADS: 1 of your pad places, temper -1 |
| 5 | A NEW WEAPON | a move reaches mastery 30 | PADS ON IT: 2 pad places this week, +6 mastery, mood +5. LATER: mood -5 (overruled, code) |
| 6 | MONEY IS TIGHT | a job fighter with no seat for 8 weeks | LEND $200: loyalty +5, discipline +1, note. A SEAT NOW: $1,000 block (v4). NOTHING: loyalty -3, skips 1 alone morning in 3 for 4 weeks |
| 7 | THE OLD COACH CALLS | Known under 3 | ONE EVENING THERE: a hidden trait opens; 1 in 3 an old habit comes back; note. NO: nothing. Loyal only: BRING THE OLD COACH IN: $60, the trait opens, no habit |
| 8 | THEIR OWN WAY | a direction against the class | THEIR WAY: direction to the class's, loyalty +4. YOUR WAY: loyalty -3; coachability +1 if Loyal, else -2. HALF AND HALF: no direction for 4 weeks |
| 9 | ANA: THE BIG ACADEMY | Ana, loyalty under 70 | GO ONE CLASS A WEEK: drills x1.15, loyalty -3. STAY: nothing. GO WITH ANA: 1 of your coached mornings a week, drills x1.15, loyalty +2 |
| 10 | YOU SAID <MONTH> (memory) | the week a dated promise falls due, not yet kept | KEEP IT NOW: the promised thing, from whoever holds it (named price). BUY TIME: a new date 4 weeks on, loyalty -3. BREAK IT: -12, BROKEN PROMISE mark |
| 11 | THE FAVOUR BACK (memory) | 8+ weeks after LET THEM GO or LEND $200 | TRAIN THROUGH IT: they take a short week with no loyalty loss. BRING A MATE: a prospect on the trial mat next Monday. NOT NEEDED: loyalty +1 |
| 12 | THE OLD COACH AGAIN (memory) | after ONE EVENING THERE, and a habit came back | LET THEM GO BACK: the habit stays, loyalty +3. YOUR PADS ONLY: 2 of your pad places, the habit's fix 2 weeks sooner. A WORD WITH THE OLD COACH: 1 favour, the habit goes |
| 13 | MY PAD PLACE (squad) | one fighter short of your pad places 3 weeks running while a team-mate got them | SWAP ONE BACK: them +3, the other -2. SPAR THEM, TECHNICAL: settled 1 in 2, else both temper +1. SAY NOTHING: loyalty -2, they will not spar together 4 weeks |
| 14 | A SPARRING GRUDGE (squad) | two Short fuses, their second Hard evening in 8 weeks | LET IT RUN: both x1.1 sparring gain this evening; a third Hard evening makes a FEUD. SPLIT THEM: new pairs this week (a trip or a half-weight partner). TALK IT OUT: 1 of your pad places, both temper -1 |
| 15 | MY PARTNER'S GONE (squad) | a PARTNERS pair loses one (left or turned pro) | SIT WITH THEM: 1 of your pad places, the -4 halved. A NEW PARTNER NOW: paired with the nearest weight, +10 tiredness week 1. NOTHING: -4 |
| 16 | OUTGROWING THE ROOM (squad) | no fair sparring pair 3 weeks running | BRING IN A PARTNER: $160 a week, sparring full. A TRIP OUT: 1 of your pad places, +1 favour. MAKE DO: half-weight partner, loyalty -1 |
| 17 | THE NEW ONE (squad) | you sign a fighter in the same weight class | A TALK: one of your coached mornings, loyalty +2. PAIR THEM: they spar together at once (a PARTNERS start, a SPARKS risk if Short fuse). NOTHING: loyalty -3 |
| 18 | YOUR CORNER THIS TIME (memory) | a two-hall night, and Coach cornered them last time | YOU CORNER THEM: loyalty +3, the other fighter gets Coach. COACH AGAIN: loyalty -2, note (a second time: -4) |
CUT FROM V1: "Mouth before the show" (+3 fans against x0.9 uptake was too small to decide; the fans live in Called out) and "Your pads, not Coach's"
(the talk card already gives the pad place back).
MARKS (at most 4 shown per fighter, dated, each with one measured effect; on the Character tab, the card hover and History):
| Mark | From | Effect (ESTIMATE) |
|---|---|---|
| HARDENED | the knockout turn | gets up one count sooner (Knockdowns up_at -1) |
| SHAKEN | the knockout turn | composure -5 in round 1 of the next 3 bouts; gone after a stoppage win |
| FIRST HOME WIN | the first win at a home show | +2 fans every home bout |
| BROKEN PROMISE | card 10, or a promise broken on the talk card | the next promise to them: kept +3, broken -18 |
| PARTNERS (with name) | section 10 | +5% sparring gain together; the other -4 when one goes |
| FEUD (with name) | section 10 | cannot spar together until settled |
| SAT WITH THEM | card 1, first answer | the next knockout card's Hardened +25 |
REAL BASIS: Darkest Dungeon's events stay alive because they leave marks; a real gym remembers who kept their word.
MOMENT1 must show: no answer best in more than 2 of 3 draws of each card; a season holds 4 to 8 moments for the club, never two in a week, no card twice
for one fighter in a season, and at least a third of season 2's cards are memory or squad cards.

## 10. The squad: partners and feuds (NEW)
PARTNERS: two fighters paired in sparring 6 of 8 weeks become PARTNERS (a mark on both): +5% sparring gain when paired together; when one leaves or turns
professional, the other loyalty -4 (card 15). FEUD: two Short fuses (temper 65+) paired for Hard sparring 3 times in 8 weeks become a FEUD (card 14 comes
first): they cannot be paired for 4 weeks unless your talk settles it (1 of your pad places that week, both temper -1, +1 experience).
WHERE IT SHOWS: the sparring pair picker (v4 B, Monday) names partners (+5%) and a feud (locked, with "settle it: 1 pad place"); the Character tab's marks.
REAL BASIS: real gyms run on sparring partners and a pecking order; one leaving shakes the other.
PARTNERS1 must show: a kept pair is worth 1.5 wins in 100 a season to the pair, and splitting a feud costs less than letting it run in at least one line-up.

## 11. Coach grows, small (NEW: the hired coach)
The owner said "coach and fighters"; Coach (the assistant) now grows too, inside the club week's own decision of who runs which session.
- AREAS RISE: each of Coach's five areas (CoachAreas: pads, bag, conditioning, strength, sparring) +1 per 10 sessions Coach runs in it, up to the hire's
  ceiling (Luke Reid: start +8; Marcus Hale: start +12). So Coach's evenings on pads or class (v4) also choose which area grows.
- A SIGNATURE DRILL: 40 of Coach's pad sessions on one move opens it: that move x1.2 mastery on Coach's pads ("Coach's body hook pads").
- A RAISE: every 2 area points gained, Coach asks +$40 a week. YES: paid. NO: Coach's areas stop rising for 8 weeks, then the ask comes back.
- COACH AND <NAME> (Character tab): sessions together, Coach's signature drill if it is theirs, and the loyalty they would lose if you let Coach go
  (-6 at 20+ sessions). This is a count of sessions, not a second bond meter.
- "Coach runs it" per fighter (AGREED, NOT BUILT): a fighter Coach runs gets none of your sessions, so Known does not grow; "Coach and <name>" grows instead.
REAL BASIS: an assistant gets better on the pads with the boxers they hold, and builds a drill they are known for.
COACHGROW1 must show: a season of growth is worth less than the gap between Luke Reid and Marcus Hale, so the hire still matters.

## 12. Build direction per fighter
WHAT YOU DECIDE: one direction per fighter, any Monday, on the Character tab (and a chip on Club week). From week 8.
| Direction | Trains faster (x1.10) | Trains slower (x0.90) | Moves +15% on pads | Perk versions first | Dials drift toward (2 a week) |
|---|---|---|---|---|---|
| KEEP IT LONG | Speed, Footwork | Strength, Inside fighting | Jab, Cross | The rangefinder, The eyes, The snap | pressure 30, counter 40 |
| WALK THEM DOWN | Stamina, Inside fighting | Footwork, Timing | Body hook, Lead hook | The drain, The long night, The stalker | pressure 80, work rate 75 |
| COUNTER | Timing, Defence | Stamina, Explosiveness | Check hook, Cross | The trap, The reader, Gets up | counter 75, pressure 45 |
| NONE: ADAPTABLE | nothing faster | nothing slower | none | the code's version (A) first | none; in the corner minute, SWITCH IT UP: for the next round the pressure dial moves 25 toward pressing or boxing at range (only with no direction) |
| Ana: GUARD PLAYER | Flexibility, Guard | Takedowns, Top game | guard moves first | | scores from the bottom |
| Ana: TOP GAME | Strength, Takedowns | Guard, Flexibility | takedowns and passes first | | scores from the top |
IN THE FIGHT: the style dials (FighterProfile.style_dials, read by Attrs) move 2 points a week toward the direction; in 8 to 12 weeks the style word
changes (AttrGen.style_word). WITH OR AGAINST THE CLASS: matching the class drifts at full speed; against it half, and moment 8 can come. CHANGING:
free, but the dials only move toward the current direction.
DIRECTION1 must show: 12 weeks of a direction win 1.5 in 100 more against the styles it is meant to beat and lose about that against the others; and
None (Adaptable) best in at least one line-up. Else the fight half is cut and only the training tilt stays.

## 13. How it joins the club week (one view)
| Club week decision (v4) | What the RPG layer adds to it |
|---|---|
| Your 4 coached mornings and 2 pad places | Known (who you know), experience (habits), levels 2 and 3 reshape them, "+3" shown at the deal |
| Coach's evenings: pads or class | which of Coach's areas grows; Club night (Amateur coach); Craft first makes a pad place worth more |
| The sparring setting and pair | temper drift, traits open, Known's Fire, PARTNERS and FEUDS, Hard school x1.4, Family club forbids Hard |
| Who corners (you or Coach) | experience and Known only (cap); card 18 remembers who you left with Coach |
| The talk and dated promises | experience for a kept promise; card 10 when one falls due; BROKEN PROMISE mark |
| Ready, building or rest | the knockout turn's odds; Known's Fire goes stale after a knockout |
| Pulls (weak spot, weapon) | the direction points the weapon; Known narrows each pull's size; a perk pick when the weapon's perk opens |
| The season target | experience when met; matches the ambition or not (+5 / -5) |
| The seat | discipline drift; card 6 |
| Signing (trial mat, walk-in) | the style fit on the card; Eye for people / Club night; card 11's mate, card 17's pairing |
| Ana's stripe and division | experience; Guard player or Top game |

## 14. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Club > You (NEW tab, drawn `rpg_coach.png`) | portrait, background edge, level ring and experience with the last sources and "this week's board can earn you +N"; the either/or pick when one waits, read from your last six bouts and this squad's weeks; the road (both sides of every level, your background's third card, the season picks after 6); your style in this squad's numbers with suits and clashes and Change (its cost); Coach's growth (areas, signature drill, the raise); Known pips per fighter with "step N in M sessions" | new CoachLevel rule (experience, levels, picks, season picks); new CoachStyle rule; Knowledge (Known pips); new CoachGrowth rule; HeadCoach; ClubDeal (your hours); Loyalty |
| Club > People | the YOU card: level, style word, "pick waiting"; Coach's card: area levels with "+1 in N sessions", the signature drill, a raise waiting | Gym, StaffCard, CoachLevel, CoachStyle, CoachGrowth, CoachAreas |
| Fighter page > Character (NEW tab, drawn `rpg_fighter.png`) | loyalty bar with bands and what each unlocks, the last moves; WHAT <NAME> WANTS (ambition, season target, match, what is left); MARKS (up to 4, dated, effect); a PERK PICK when one waits; the five traits with value, word, what each does in the code's numbers, arrow and what moves it; KNOWN (pip step, sessions to the next, the three groups' ranges); build direction (four, with faster/slower and the dial); COACH AND <NAME>; a waiting moment card | FighterPage, new Character panel; Loyalty; Recruit.ambition; SeasonTarget; new Marks rule; PerkRoad + new PerkPick; FighterProfile; Exchanges.uptake; Knockdowns; CornerJobs.talk; Knowledge; new BuildDirection rule; CoachGrowth; new Moments rule |
| Fighter page > Profile | ranges on ceilings and potential from Known; the direction as a chip; the loyalty word; perk road with picked versions; trait hover with the effect line | DarkOverview, AttrBoard, Recruit.stars, Knowledge, BuildDirection, PerkPick |
| Fighters > Club week | each row: direction chip, the style's clash mark, "+2" / "+3" experience on the slots as dealt, Known "+1" on your slots, moment cards, PERK PICK and LEVEL UP as needs; the sparring pair picker with PARTNERS and FEUD | ClubWeek, ClubDeal, Moments, CoachStyle, Knowledge, CoachLevel, SparPair |
| Fighters cards | the loyalty word, "Trusts you" at 85+; the two trait words with their effect in hover; a corner flag "Moment" or "Perk pick"; marks in hover | RosterCards, RosterFlag, Loyalty, Moments, Marks |
| Fighters > Find a fighter, the trial, the walk-in card | traits "?" until known; the style fit per trait shown; Known ranges; Eye for people's 1 morning; card 11's mate | RecruitPanel, Trial, Interview, CoachStyle, Knowledge, CoachLevel |
| Home | needs: "Choose your perk", "Tess's perk pick", a moment waiting, Coach asks for a raise | HomeNeeds, Needs, CoachLevel, PerkPick, Moments, CoachGrowth |
| Top bar | flags LEVEL UP, PERK PICK, MOMENT | Shell, Needs |
| Fight night | TRUST ME in the corner minute's talk (85+, once a bout); Ringside voice, The minute or One you saw coming; SWITCH IT UP (no direction); the picked perk versions at work; experience on the result | FightNight, BoutNight, CornerTrust, Exchanges (FULL_SHOUTS), CornerJobs (fixes, talk, set-up), PerkFight, CoachLevel |
| Result and the Why | a trait opened; a trait that moved and what it now does; the knockout turn waiting for Monday; a mark earned | FightWhy, WhyCard, CoachNotes, TraitDrift, Marks |
| Week review (Monday) | experience gained and from what; trait words crossing a line with the new effect; Known steps; the knockout turn's result; partners or a feud formed; Coach's area +1 | WeekReview, ReviewReveal, CoachLevel, TraitDrift, Knowledge, Marks, CoachGrowth |
| Playbook > Game plan | Craft first's extra line; the direction's default lines | PlanLines, GamePlan, CoachStyle, BuildDirection |
| History | marks with their dates beside the bouts that made them | BoutHistory, Marks |
| Grappler page | Guard player or Top game; Ana's loyalty, Known and traits as on the Character tab; card 9 | GrapplerPage, BjjSide, NoGi, BuildDirection, Moments |
| Handbook | Words: Loyalty, Mood, Known, Direction, Style, Level, Mark, Partners, Feud | Handbook |
THE NEW MECHANICS, MENU BY MENU (each shows on every menu below in the .exe, and the golden-path test walks it):
| Mechanic | Menus | Wired to |
|---|---|---|
| Coach level, picks, background card, season picks | Club > You; Club > People; Home need; top bar; Week review; fight night (level 4); Club week counters (2, 3) | CoachLevel; ClubDeal; Exchanges; CornerJobs; Favours (6, Old hand) |
| Fighter perk picks | Character tab; Profile perk road; Home need; top bar; Club week need; fight night | PerkRoad; new PerkPick; PerkFight |
| Loyalty as the bond (bands, TRUST ME) | Character tab; Club week rows; Fighters cards; fight night corner minute; moments' third answer | Loyalty; CornerTrust; CornerJobs.talk; Moments |
| Coaching style and the fit at signing | Club > You; Club week rows; Character tab; Playbook; sparring cells; trial, walk-in, Find a fighter | CoachStyle; WeekPlan; SparSet; PlanLines; Loyalty; RecruitPanel |
| Traits: effects and drift | Character tab; Profile hover; fighter cards; Why; Week review | TraitDrift; CoachNotes; FighterProfile; Exchanges; Knockdowns; CornerJobs |
| What they want | Character tab; Club week season target | Recruit.ambition; SeasonTarget; Loyalty |
| Build direction | Character tab; Profile chip; Club week chip; Grappler page; Playbook; corner minute (Switch it up) | BuildDirection; WeekPlan; PadWeek; MoveMastery; FighterProfile.style_dials; BjjSide |
| Known | Character tab; Club > You pips; Profile ranges; trial card; bout sheet's band; pull chips | Knowledge; Recruit.stars / ceiling; LeverSize; BoutSheet |
| Moments, memory, marks | Club week rows; Home need; top bar; Character tab; History; card hover; Grappler page | Moments; Marks; ClubDeal; Loyalty; TraitDrift |
| Partners and feuds | sparring pair picker; Character tab; Week review | new SquadBonds rule; SparPair; Marks |
| Coach grows | Club > You; Club > People; Character tab (Coach and <name>); Home need (raise); Week review | new CoachGrowth rule; CoachAreas; MoveMastery |

## 15. The reveal order (added to v4's weeks 1 to 5)
| Week | Arrives | What the guide says |
|---|---|---|
| 6 | your level and the first pick; your style | "Your first pick. Your hours, your way." |
| 7 | Known (pips on your slots and the fighter pages) | "You know them by the hours you put in." |
| 8 | build direction; moments; perk picks (the first perk to open) | "Build each one toward a way of fighting." |
| 10 | Coach's growth on People; partners on the pair picker | "Coach gets better at what Coach runs." |

## 16. To be measured before the build (the verdict's cut rule: under 1.5 wins in 100 on a bout and no season effect = cut)
COACHXP1 (steps a season: 3 to 4 careful, 2 to 3 lazy; a season pick in seasons 2 to 5). STYLE1. TRUSTME1 (hurt rounds; else the trial-mat friend).
TRAITDRIFT1 and KOTURN1. DIRECTION1 (and None best in one line-up). KNOWN1 (was READ1). PERKPICK1 (each version beats the other somewhere by 1.5).
PARTNERS1. COACHGROW1. MOMENT1 (no repeats per fighter per season; a third of season 2 memory or squad). All on the played bout, after LOYAL1.

## 17. Build order, in small tasks
1. Probes above (cloud, pure). 2. Pure rule modules with unit tests, one a task: CoachLevel (levels, picks, background cards, season picks),
CoachStyle, TraitDrift, BuildDirection, PerkPick (the eight pairs as PerkFight hooks), Moments (deck + notes), Marks, SquadBonds, CoachGrowth; Loyalty
gains the bands and TRUST ME; Knowledge gains the pip bands (no new range rule). 3. Wire them: WeekPlan and PadWeek read style and direction; Exchanges,
CornerJobs and Knockdowns read level 4 and the perk versions; CoachNotes reads the sparring setting; Recruit.stars and ceiling read Knowledge.
4. Screens: Club > You, the Character tab, then chips and needs on Club week, Profile, cards, Home, top bar, Why, Week review, pair picker, History,
signing cards. 5. The golden-path test walks: a level and a pick, a style chosen, a direction set, a perk pick, Known reaching pip 2 with a trait
opened, a moment answered and its memory card later, a mark earned, partners formed, Coach's area +1, a knockout turn after Rest, TRUST ME used once.

## 18. Risks, said plainly
- More on day one: kept off it by the reveal order (weeks 6 to 10).
- Loyalty carries the bond and its rewards: LOYAL1 plus STYLE1 check no deal is "always keep everyone 85+".
- Ranges can read as hiding numbers. The rule ("real stats stay visible") is kept: the number is always there, its range narrows; only a trait not
  yet known is a "?".
- Eight perk pairs, eighteen cards, seven marks: all ESTIMATE. The probes cut, they do not decorate; a pair that fails PERKPICK1 goes back to one perk.
- Coach's growth must not make the second hire pointless (COACHGROW1).

## REJECTED (asks that widen the scope or clash with the code, and why)
- The left rail and the tab names Overview, Week, Fight prep, Playbook, Character, History (trainer item 11): the shell has had no left rail since S416
  (operator: "remove double menus"; Shell.RAIL is one Gym button plus Mail in the top bar), and the fighter page's six tabs (Profile, Condition,
  Training, Playbook, Fight plan, History) are the S431 matched look the owner liked (Q-182). Character joins them as the seventh. "Mall" was a font
  fault in the render: the drawings now read Mail. "About 4 levels a season" is cut (nothing to act on), as asked.
- Staff loyalty bands with Coach leaving for Eastside ABC (trainer item 3): that is the rival club that poaches, left for the small living world.
  The raise's NO pauses Coach's growth instead.
- A fighter's own bond with Coach as a number ("loyalty leans to Coach"): two bond numbers per fighter breaks the one-number rule. "Coach and <name>"
  is a count of sessions with one price (-6 if you let Coach go).
- ADAPTABLE as "one opponent tell fewer is known about this fighter" (designer item 8): amateur opponents do not scout your fighters in the game, so it
  would need a new system. SWITCH IT UP in the corner minute uses what exists (the style dials).
- Levels 7 to 10 as four new pairs each (trainer item 8): twenty new pairs widen content without new decisions. A season pick (deepen one perk you
  took, or Second thoughts) gives the same yearly goal from what is already there.
- "Let them talk = a rival corner card two bouts later" (designer item 7): opponents' corners have no memory in the game (the living world). Moment 5 is
  cut instead, and its fans live in Called out.
- The designer's "Confidence 70: wins lift mood x1.15": the code (apply_morale) gives x1.04; x1.15 is a missed goal. Corrected, not a new rule.

## RPG MECHANICS FOR THIS VERSION
1. COACH LEVEL: experience from what you do in person, shown at the deal; levels 2 to 6 with five either/or picks, a third card from your background at one level; a season pick each year after (deepen a perk, or Second thoughts).
2. FIGHTER PERK PICKS: each of the eight perks opens as two versions; you pick one per fighter for good; the direction lists one first.
3. LOYALTY IS THE BOND: one number per fighter; bands unlock holding pads, the free short week, priced third answers and TRUST ME in the corner minute.
4. COACHING STYLE: Hard school, Craft first or Family club, shown in this squad's numbers and on every signing card; changed once a season at a cost.
5. TRAITS: each says what it does in the code's numbers; hidden until known; worn down or hardened by the weeks; the knockout turn.
6. WHAT THEY WANT: ambition and season target side by side; matching them pays loyalty, crossing them costs it.
7. BUILD DIRECTION: Keep it long, Walk them down, Counter, or None (Adaptable, Switch it up); Guard player or Top game; two faster, two slower.
8. KNOWN: Knowledge.gd's ranges, narrowed only by your own sessions; five pips with sessions to the next; Fire only from sparring and bouts.
9. MOMENTS AND MARKS: eighteen cards with memory and squad cards, no card twice a season; up to four marks per fighter, each with an effect.
10. PARTNERS AND FEUDS: sparring pairs that bond or fall out, on the pair picker.
11. COACH GROWS: areas rise with sessions run, a signature drill, a raise to answer.
Built already and kept: the background edge, the signing card, the perk road (now picked), CoachNotes, HabitFix, StripeCall, CornerTrust, Knowledge.

## LEFT FOR LATER
- A rival club that poaches (fighters and Coach): its offer reads loyalty (Trusts you stays; Wavering listens); promises and poaching at contract time.
- Scars: past injuries changing future risk; a fighter's prime and decline; retirement talk; retired fighters back as coaches (Miro idea backlog).
- More than one style at once; a full respec of coach perks.
- A professional's own moments with promoters and managers (the full promotion); opponents' corners that remember.
- A crossover direction (a boxer learning to grapple), which waits for the crossing rules.
- Hype (HYPE1, its own map) lifting Knowledge's ranges.
