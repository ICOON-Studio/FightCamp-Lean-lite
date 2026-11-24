# DESIGN_COACHMAP1 - coaches, as they stand after the cuts (S548)

One clean page for the critics. It replaces `DESIGN_COACHDEEP9.md` as the page to read (v9 stays as the history).
Sources, cited in brackets: [I n] = the owner's interview `COACH_INTERVIEW_S542.md` point n; [G Qn] = his grill answers
`COACHDEEP_GRILL_S539.md`; [Q-329] = his board answer of S548; [R9 sN] = the measured result `docs/COACHDEEP9_RESULT.md`
section N; [CB] = `docs/CORNERBASE1_RESULT.md`. A number marked ESTIMATE is a guess that the probe ran with, not a study.
NOTHING ON THIS PAGE IS IN THE GAME YET except where section 6 says so.

## Decided while writing
- The trial week is gone everywhere: no button, no price, no line on the money page. The chemistry word shows on the
  hire card for every boxer, free, before signing [Q-329: "Cut it, show chemistry"].
- "Shown only after 2 weeks together" [G Q12] goes with it: a word the hire card already showed cannot be hidden again.
- The falling-out is a news line, not a pop-up (v9's stop rule, [R9 s4]).
- I did not fill the holes the cuts leave. They are listed in section 7.

## 1. The mechanic in ten lines
You own the gym and are its head coach, with no ratings of your own [G Q1]. The coaches you hire carry the ratings.
It is a staff game, as in Football Manager: a few decisions a season, not a weekly puzzle [I 1]. You decide who to hire
and when (the main decision [I 6]), whether to match a raise or a rival's offer, whether to let a coach push a boxer
towards his own style, whether to send him on a course, and who stands in the corner on fight night [I 8, 9]. The week
pairs coaches and boxers by itself; you may overrule it for free [I 2, 14]. A wrong call is felt as story: an unhappy
boxer or coach, a warning on their card, and after two warnings a person lost for good [I 3, 15]. Up to four coaches
[G Q2], each on a weekly wage [G Q3].

## 2. The rules

**A coach.** Eight ratings 1-20, each wired to a rule the game has: pads, conditioning, tactics, cutman, weight
management, film, motivation, teaching beginners [G Q8]. Two or three specialties [G Q9]. A playbook: one of the six
styles [G Q10]. Five traits 1-20: temper, patience, discipline, ambition, loyalty [G Q11]. Each rating has a ceiling
(rating + 3, ESTIMATE), shown in words [G Q22]. Your coaches and candidates show exact numbers [G Q4, Q16].

**The wage - one rule for every coach** [G Q17 "wages scale with ratings"; R9 s2]:
P = (4 x teaching + 3 x pads + 2 x tactics + 2 x conditioning + motivation + film + 0.5 x cutman + 0.5 x weight) / 14;
wage = $150 + $125 x (P - 9) + $150 for each art past the first + $350 for a known name, rounded to $10. The weights and
the three constants are ESTIMATES ([R9 s9]: "the formula itself, not a card, is what the owner should judge").

**The hire list.** Three candidates a month [I 6, G Q15]. The HIRE CARD shows:
- his ratings, specialties, playbook, traits and wage;
- THE CHEMISTRY WORD WITH EACH OF YOUR BOXERS: bond / fine / clash, the reasons on hover [Q-329];
- "Pays for itself at about N members" - N is the smallest membership at which the class nights he can run plus the
  dues of the members his coaching lets the gym carry cover his wage [I 6]; a known name's card says instead "Pays only
  with a pro or a title boxer in his corner" [I 11];
- "The boxers win about X more a season with this coach" - X comes from TRAINING (his ratings on her learning over a
  season), not from the corner: see section 5.

**The known name** [I 11]: $800-1,100 a week. When he works the corner of a professional bout the promoter pays the gym
a name fee of 60% of the purse, capped at $4,000 a bout, and each pro win adds +2 reputation (ESTIMATES). Measured: he
loses 22 to 41 lines over two years in every gym without a pro and gains 12 to 38 in every gym with one [R9 s3].

**Pairing.** Each week the plan pairs every boxer with the coach who suits her best (his areas by her style, his
specialties, his playbook, the chemistry word). "Change" overrules a pairing for free; the new pair's word is the only
consequence [I 2, 14]. Class nights fill the evenings no boxer needs and show as a fact; there is no class-or-pads
choice [I 10].

**Chemistry** [G Q12]. His traits against hers (for example a hot-tempered coach with a hot-tempered boxer -0.4; a
patient coach with an unsure boxer +0.3) plus weeks together (+0.01 a coached week, cap 0.25). The word: bond at +0.15
or more, clash at -0.15 or less, fine between (ESTIMATES). It moves her learning (up to about 4.5% either way), morale
and loyalty. One-way: results and money never move it.

**The moments** - at most one a month, a few a season [I 13], each a pop-up like the pro offer:

| Moment | When | The answers |
|---|---|---|
| A raise | his boxers win 3 in a row or a title; ambition 12+; once in 26 weeks | MATCH: wage +25%, his loyalty +10. REFUSE: his loyalty -20 and a warning. |
| A rival's offer | as the raise, for a coach with loyalty 8 or less | MATCH: wage +25%. LET GO: he leaves in two weeks. |
| A style push | his playbook does not fit her style, 8+ weeks together; once a boxer a season | ALLOW: her style becomes his (faster learning later; her next 2 bouts at 0.6 of the plan; her own combination restarts at half). REFUSE: his loyalty -12 and a warning. |
| A course | a coach under his ceiling, cash over $6,000; once a season | SEND: $600 and 2 of his evenings a week for 3 weeks, then +2 in his lowest of pads / tactics / teaching. NOT NOW: an ambitious coach -3 loyalty. |

Measured [R9 s4]: the raise is a real call (refuse best in 6 gyms of 10, match in 4); the style push is a real call
(refuse 6, allow 4). The course was not measured as a call.

**The falling-out is not a decision** [R9 s4]. Backing the coach was best in 10 gyms of 10, so the gym does it: when a
clash pair has worked together 4+ weeks and falls out, the boxer takes the warning and the player reads one news line
("Reid and Kira fell out. The gym backed the coach: Kira is unhappy, warning 1 of 2, until 12 May."). The player can
still split a clash pair with "Change" before it happens.

**Warnings, and losing people** [I 15; R9 s2]. A moment that goes against a person puts a warning on their card, with
its reason, its cost and its fade date. While it stands: a warned boxer learns 10% slower, hears the corner 15% less
and loses 2 loyalty a week; a warned coach's ratings count 10% less (ESTIMATES). It fades after 26 weeks. A person
with two warnings leaves for good at the next blow that takes their loyalty under 25. In its first 8 weeks a warning
never takes anyone under 25.

**The corner pick** [I 9]. Before a fight you pick the coach in the corner. The best tactician gives better calls
between rounds; the coach with the bond is the one she listens to (calls x (1 + 0.4 x chemistry), ESTIMATE); a clashing
coach gets one call ignored a fight; the known name earns his fee only from the corner. Measured on the greybox: the
tactician was right in 45% of the fights where the two differ, the bonded coach in 55% [R9 s1 bar 4].

## 3. What changed against v9

| Rule | v9 | Now | Why |
|---|---|---|---|
| The trial week | one week of his wage shows the chemistry words; one a month | CUT | the wrong buy in 9 gyms of 10 [R9 s5]; owner [Q-329] |
| Chemistry on the hire card | hidden until a trial or two weeks' work | shown for every boxer, free | owner [Q-329] |
| The falling-out | a pop-up with three answers | a news line; the gym backs the coach | one answer best in 10 of 10 [R9 s4]; v9's stop rule |
| The money page | wages, the trial, the course, the name fee | wages, the course, the name fee | the trial is gone |

## 4. The seven bars after both cuts (from [R9 s1], no new run)

| Bar | Status |
|---|---|
| 1 No hire best in more than 6 gyms of 10 | MET (the film-room coach 4, the known name 6) - but see section 7, hole 1 |
| 2 The known name pays with a pro and loses without | MET |
| 3 No answer best in more than 6 of 10, each moment | MET on the two moments left (raise 6 / 4, push 6 / 4) |
| 4 Corner: tactician and bonded coach each right 25%+ | MET (45% / 55%) - but see section 7, hole 2 |
| 5 A careless owner loses, a careful one does not | MET (careless loses in 5 gyms, careful in 0) |
| 6 The trial is right in 2+ gyms and wrong in 2+ | NO LONGER APPLIES (the trial is cut) |
| 7 Nothing runs away | MET |

To re-run: bar 1 with the chemistry word known at hiring (the probe's hire pick was blind to it), and bar 5 (the
careless owner hired blind; with the word on the card a careless hire is harder to make).

## 5. A fact from another probe this map must not contradict
In a SIMMED bout a coach's rating buys nothing: a corner coach rated 80 against one rated 35 is +0.4 to +0.7 wins in
100 [CB verdict 4]. What helps a simmed boxer is a coach who rests her when she is tired and says "hands up" when she
is hurt (+2.6 wins in 100 at 3 rounds, +6.2 at 6 [CB verdict 2]) - any coach could do that. So the hire card's "win
about X more a season" must come from training, and the corner pick's worth must come from the bond, the ignored call
and the name fee, not from the tactics number, until a rule makes tactics matter in the ring. And in the game today
the win read ignores the corner coach entirely [R9 s7]: every coach would show the same "about X%".

## 6. Every menu the mechanic appears on

| Menu | What it shows | Wired to | In the game today |
|---|---|---|---|
| Office computer > Staff (cards) | each coach as a card: face, name, job, four facts, one button; the chemistry word per boxer on hover | coach data, chemistry | The cards exist (`scripts/ui/StaffDesk.gd`, `StaffDeskCard.gd`, S547). They show today's staff: Luke Reid and Marcus Hale (`scripts/state/Data.gd` l.34-37, one rating each), the mat coach and four jobs (`scripts/rules/StaffRoles.gd`). Eight ratings, traits, chemistry: not built. |
| Staff > the hire list | three candidates a month; the hire card of section 2 | the monthly draw, the wage rule, pays-at N, the X line, chemistry | Not built. Today: "coaches for hire" cards while none is signed (`StaffDesk.gd`), a cash runway line (`scripts/ui/HireRunway.gd`). |
| The coach card | ratings and ceilings in words, specialties, playbook, traits, his boxers and the word with each, warnings, loyalty | coach data, chemistry, warnings | Not built. |
| The week plan | each boxer's coach as a fact, with "Change"; class nights as a fact | the pairing rule, class demand | Not built. Today the class-nights-against-pads control is still there (`scripts/rules/CoachRoles.gd` class_week): the owner cut it [I 10]. |
| The boxer card | her coach, the word, any warning with its cost and fade | pairing, chemistry, warnings | Not built. |
| The moment pop-ups | the raise, the rival offer, the style push, the course: both people's loyalty, who would carry a warning and what it costs | the moment rules | Not built. By the owner's S544 rule these are SCENES with cards, not rows. |
| News / Mail | the falling-out line | the falling-out rule | Not built. |
| The corner pick, before a fight | each coach's tactics, the word with this boxer, the name fee, "about X%" | the corner rules | Not built, and its read needs wiring first [R9 s7]. |
| Finance | wages, the course, the name fee | cash ledger | Wages are there; the course and the fee are not built. |

## 7. What the cuts leave open (not filled here)
1. IS THE HIRE STILL A CHOICE? With the word free on the card, nobody hires into a clash by accident. The measured
   best hire depends on one thing: a gym with a pro wants the known name, a gym without wants the film-room coach
   [R9 s3]. That is two answers by one rule a player learns once. Chemistry on the card may add the second axis (the
   best coach on paper clashes with your best boxer) - or it may not: unmeasured.
2. THE CORNER PICK AGAINST THE LIVE CORNER. Since S543 the player calls the corner live (eight commands), worth about
   +10 wins in 100 over a coach who reads the file [CB]. This page's corner pick was designed before that. What the
   picked coach does when the player is the one calling is undefined: does he set how well she hears the player's
   call (the bond), give the call when the player sims, or both?
3. THE COURSE has no measured trade (it is "send him when you can afford it").
4. WITH THE FALLING-OUT AUTOMATIC, a clash pair costs a warning the player never chose. "Change" is his only lever, and
   the week pairs by best fit, word included, so a clash pair should be rare. If it is never seen, the news line is dead.
5. THE FOUR JOBS in the game today (second coach, strength coach, physio, cutman) "stay until rated coaches replace
   them" [I 10]: which of the eight ratings replaces which job is not written.

## 8. Feedback loops and their caps (v9's, minus the trial)
- A known name -> fee and reputation -> more members and money -> can afford him: capped at $4,000 a bout, +2
  reputation a win, reputation at 100.
- Bond -> she listens in the corner -> wins -> loyalty and morale. Chemistry itself stays one-way; the bond caps at 0.25.
- Warning -> loyalty drains -> the person leaves -> fewer people: one moment a month; two warnings always shown first;
  8 weeks before a drain can take anyone under the line; a person who left triggers nothing. Measured: a careful owner
  loses 0.00 people a career, a careless one 1.05 at worst [R9 s6].
- A style push -> her style changes -> fit rises -> faster learning: one push a boxer a season; the bonus tops at +15%.
- Wages -> cash: the lowest mean end cash was -$19.9k (the known name in a novice gym, the card that says he does not
  pay there) [R9 s6].
- Removed with the trial: "trial -> the word known -> better pairing". The word is now known at hiring for nothing.

## 9. The decisions the critics score
| Decision | How often | What it trades | Measured as a real call? |
|---|---|---|---|
| Who to hire, and when | a few times a career | wage against class nights, training and (the known name) pro purses; now also the word with each boxer | Two answers by gym type [R9 s3]; with the word on the card: unmeasured |
| Match a raise or refuse | about once a season a coach | +25% wage for good, against a warned coach working 10% worse for 26 weeks | Yes: 6 / 4 |
| Match a rival's offer or let him go | rare | +25% wage against losing him | Not measured apart from the raise |
| Allow a style push or refuse | once a boxer a season | two shaky bouts and a restarted combination now for faster learning later, against a warned coach | Yes: 6 / 4 |
| Send him on a course | once a coach a season | $600 and six of his evenings for +2 in one rating | No |
| Who works the corner | every fight | tactics against the bond against the name fee | 45% / 55% on the greybox; in the game the read is not wired, and the live corner changes what it means (hole 2) |
| Overrule a pairing | when a word is clash | her best-fit coach against a pair that will fall out | No |
| (gone) The trial week; the falling-out | - | - | Cut |
