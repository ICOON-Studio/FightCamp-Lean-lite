# The BJJ fight, deep - design v5, parts A, E, F, H, I (S397, for a blind critic panel)

FightCamp (Steam, Godot 4) is a boxing + no-gi BJJ gym manager. The player coaches Ana from white belt to black: each week
picks what Ana drills (moves on a game tree of positions: grey -> felt -> owned at mastery 30), enters IBJJF no-gi opens
(single elimination, 3-5 matches a day, divisions by belt and weight), and watches each match simulated beat by beat or
plays it live. Every opponent is generated on the same maths. [R] = a real number (sources: ops/research/
BJJ_REAL_NUMBERS_S397.md), [G] = our choice, to be fitted in the headless harness. This page covers five parts.

THE ENGINE (kept): a walk on a position graph (49 positions, 80 moves, 135 arrows). A beat is ~33 s: 9 beats in a 5-minute
white match, 11 blue (6 min), 13 purple (7), 15 brown (8), 18 black (10) [R IBJJF match lengths]. The side with the
initiative ACTS (one arrow) or HOLDS (no roll; the initiative passes). A hit moves, scores IBJJF points and keeps the
initiative; a miss lands on the arrow's miss position ("bad": already in the data for every arrow) when the defender owns
the answer, else resets in place; the initiative passes. Odds = the arrow's even-field base rate (attempt-to-success, so a
submission's base already includes the defence) x the attacker's mastery of the move / the defender's mastery of its best
answer x chain x mood x the read, then levers add on the logit (all levers 0 = today's calibrated odds).

## A. What a belt means
- MAT TIME is one hidden skill level. A belt starts at white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9. Inside a belt
  an athlete sits at start + t x SPREAD, where t is the time at the belt (0 fresh .. 1 four-stripe) and SPREAD is a share of
  the step to the next belt: white 0.60 (of 1.0), blue 0.55 (of 0.8), purple 0.55 (of 0.6), brown 0.50 (of 0.5), black
  0.4 levels over its first 300 classes. So a four-stripe white (0.6) still trails a fresh blue (1.0). Sandbaggers: 10% of a
  white or blue division draws t from 1.0-1.6 (a long tail, not +-noise) [G; R: promotions take 1.5-4 years, IBJJF puts
  experienced wrestlers at blue, art. 5.5].
- Read ONCE: every arrow adds MAT_W x (attacker level - defender level) on the logit, attack and defence alike, so the senior
  both scores and finishes more [R: favourites submit 53% / are submitted 9% at a 200 rating gap]. No other belt bonus is
  added in the fight. Across belts there is one more difference, stated: the belt's MOVE LIST (owned moves by belt in the
  generator: white 8-12, blue 25-36, purple 30-40, brown 36-46, black 40-50 of the 80 on the map).
- Fitting: MAT_W is fitted on the INSIDE-belt bars only, per belt band (white-blue, purple, brown-black: a black match has
  twice the rolls of a white one): a four-stripe vs a fresh athlete of the same belt wins 66-76% [R proxy: a 100-200 rating
  gap]; a division's top quarter by mat time wins 65-72% of its matches against the rest [R: rated favourites 65.7%]. The
  ACROSS-belt table is then measured, not tuned: it must be monotone, no cell above 99%, and within 7 points of the coach's
  bands (white->blue 80-88, blue->purple 70-80, purple->brown 65-75, brown->black 60-70, two belts 85-95, three+ 95-99). If it
  is not, the move-list bands are adjusted, not a second lever.
- Player sees: the opponent's belt and stripes, and a word for the time at the belt ("fresh blue", "solid blue", "four-stripe
  blue", "sandbagger?" when results run far above the belt); the result card names mat time when it decided an arrow.
- Lives in: BjjBody.mat_time (exists), BjjOpp (t, the tail), the harness.

## E. How often a grappler acts; guard vs pass; scrambles
- ACT OR HOLD: an athlete acts only when its best arrow's expected value clears its HOLD BAR; the bar is per belt band
  (lowest at white: white belts act more and miss more), moved by posture (part I) and by leading late. HOLD BAR values [G]
  are fitted to these bars: attempts per athlete per match: white (5 min) 3-5, black (10 min) 3-4.5 [R ADCC 2019: ~3.5 an
  athlete a match]; submission attempts per athlete per match: white/blue 1.0-1.6 [R Williams 2019, gi: 1.24], black
  0.8-1.3 [R ADCC 2019: ~1.0]; completed passes per athlete per 10 minutes at brown/black 0.17-0.25 [R ADCC 2019].
- A hold is WORKING or IDLE. Working: the first hold by a side on a position since it last acted - gripping, framing,
  pressing. Idle: a side's second hold in a row on the same position with no attempt of its own in between. Only an idle
  hold off a pin is a stall (part H). Bar: >= 60% of all holds are working at every belt.
- THE PASS AS A CONTEST: a pass attempt that fails without a sweep or escape leaves PRESSURE: +0.35 on the logit for that
  athlete's next pass on that guard (one stack). It is cleared by the bottom athlete landing a sweep or escape, or by a
  RETENTION roll: when the bottom athlete holds with the initiative, frames + flexibility vs the passer's pass mastery +
  strength, an even contest at 50%; a win clears the pressure and is noted ("kept the guard"). A missed sweep keeps it.
- SCRAMBLES: a miss that lands on the scramble position is settled in the same beat: explosiveness + composure + the best
  standing-lane mastery / 100 vs the same; the winner comes up on top. Bar: the more explosive side (10+ points) wins 58-65%.
- Lives in: BjjPass.gd (new, ~120 lines: hold bar, working/idle, pressure, retention, scramble); BjjWalk calls it.

## F. Submissions and defence
- No extra finish gate: the base rates already include the defence [R attempt-to-tap tables].
- A missed submission lands on the arrow's miss position when the defender owns the answer - the real escapes are data per
  arrow (33 submission arrows, all in the data today): triangle -> the passer stacked on top in side control; guard armbar
  -> the guard opened; outside heel hook -> 50-50; inside heel hook, kneebar, ankle lock, darce, anaconda -> a scramble;
  mounted armbar -> back to closed guard; RNC -> the defender turns into half guard on top. The miss slides there only as
  often as the defender owns the answer (mastery / 30, capped at 1); otherwise the attacker keeps the position and goes
  again - so a back is usually KEPT after a missed choke [R: a back take leads to that athlete's finish 45-61%, Lamas 2023].
- NEAR = an advantage [R IBJJF]: a missed submission, sweep, pass or takedown whose roll missed by 0.10 or less (r < odds +
  0.10) scores an advantage to the attacker; at most 2 advantages an athlete a match from near misses.
- Legality by belt from the IBJJF table (already per move in the data): white to purple: straight ankle lock only; brown and
  black: kneebar, toe hold, heel hooks and reaping [R IBJJF 2021]. Leg-lock defence is knowledge: the answer moves owned.
- Bars on even fields (same belt, mat time within 0.2): submissions black 40-55% [R 45%], brown 45-60%, purple 40-58%, white
  and blue 35-60% (no adult belt data; regional mixed-belt events 50-63% [R weak]); RNC and heel hook the top two finishes
  at brown/black, 17-25% each [R]; a back take ends in that athlete's finish 45-61% [R]; advantages decide 2-8% [R no-gi 2.4%].
- Lives in: BjjWalk (near, cap), assets/data/bjj_tree.json (miss positions checked per submission arrow).

## H. The referee
- Bell order [R IBJJF 2021]: points, advantages, fewer penalties, then the referee's decision.
- Stalling: an IDLE hold (part E) is a stall, unless the athlete holds mount or the back, or is defending under mount, back,
  side control or north-south [R IBJJF 2021]; holding side control, knee on belly or north-south idle IS a stall. Every 2nd
  stall is a penalty. Ladder [R]: 1st marked, 2nd an advantage to the opponent, 3rd two points, 4th disqualification; both on
  3 penalties: a restart standing.
- Double pull: both athletes sit to guard on one beat -> a 20-s count (the next beat): the first to come up on top scores an
  advantage; if neither does, both take a penalty [R IBJJF].
- Decision weights from the data (more takedown attempts won 85% of real decisions, more submission attempts 58% [R BJJ
  Heroes]): takedown attempts 2 (hit or miss), beats on top after acting 1, near misses 3, submission attempts 1.5, other
  attempts 1; the larger share wins; inside 0.45-0.55 the call is drawn from the shares.
- Bars on EVEN matches (pre-match win chance 40-60% by the harness's own estimate): decided by the referee 2-10% [R 7%
  black], by advantages 3-8%, by penalties <= 3%; never a penalty for holding mount or the back.
- Lives in: BjjRef.gd (exists; the exemption list, the 4th penalty, double pull, weights).

## I. The coach's part
- SCOUTING only where it is real: round 1 of an open (the draw is out on the Monday before), a known rival, a superfight. The
  card shows the opponent's standing plan, top game and bottom game as tells with a confidence: 60% from the record, 90%
  after watching 3 films (one film a week, from the Tape room). Between rounds on the day: a short card with one tell at 60%
  (seen in the opponent's earlier round). No drilling between rounds.
- The COUNTER WEEK: instead of the week's plan, drill the answers of the round-1 opponent's main lane: +5 mastery (cap) to
  those 2-3 answer moves for that bout only; the week's own drill gain is lost (bar: the counter moves the round-1 match 4-6
  points; over 4 weeks the lost growth is worth more than that).
- POSTURE for a bout, moving WHAT is picked: Hunt (submission and back-take arrows' expected value x1.3 in the chooser, the
  hold bar lower; a miss costs 50% more gas), Steady, Hold (when leading, the hold bar higher and the retention roll +0.2; the
  idle count climbs, so stalling penalties come). Bar: over 6 games x 3 postures no posture is best against more than 3
  games, and none beats the best alternative by more than 5 points over all games.
- LIVE CALLS (the live match, 3 a match): offered when Ana has the initiative on a settled position - guard, half guard,
  side control, mount or back, held at least 0.4 s - with 5 seconds to answer, else Ana's plan acts. The menu: up to 2 of Ana's
  OWNED moves out of that position, each with its chance and what a miss costs (e.g. "stays underneath, the initiative goes
  over"), plus "Hold and breathe" (+6 gas, no score, the initiative stays). Below 35% gas only "Hold and breathe" is offered
  (tunnel vision).
- THE RESULT CARD: one line per lever that decided something, most decisive first. Examples:
  1. "Knee cut pass 6:12, straight off the failed body lock: the pressure told (3 points)."
  2. "Armbar 2:40 missed by a hair: an advantage; Kim came back to guard."
  3. "Kim penalised for stalling at 4:10, the second time sitting in closed guard: an advantage to Ana."
  4. "Level 2-2, advantages 1-1: the referee gave it to Kim, three takedown attempts to one."
  5. "Ana's double leg 0:35 stuffed by the sprawl: Kim, a four-stripe blue, has more mat time."
- Lives in: BjjOpp (tells), BjjBody (posture), BjjMatch/BeltMatch (live calls exist), BjjWalk notes (the lines exist).
