# Coaches: the design to approve (S412, 2026-11-09)

From his two lines (the ceiling and bond, then "each coach carries his own playbook") and an open round: a boxing trainer's view (S412_COACH/trainer.md, its real cases from memory, unchecked) and a sim designer's (S412_COACH/designer.md). They worked apart and landed on the same three rules. Picture: docs/mockups/s412/coach/designer.png (layout only, not the art). Nothing is built.

## The rules (Claude's call from the two)
1. **His book.** Each coach has a school (out-boxer, pressure, body work...) and a blind spot: about 5-8 moves, combos and corner calls. Outside it he can keep a move from fading, not raise it. What the boxer learned stays with the boxer.
2. **His limit.** On every move in his book he can only take a boxer so far: Usable, Sharp or Signature (mastery 30 / 60 / 85, the tiers the game already has), from COACH1's area ratings. A red line on the boxer's own bar and a note in the week review ("stops growing in about 2 weeks") let you see it coming.
3. **The bond.** Four steps per coach and boxer: Stranger, Working, Trusted, Corner. Built by weeks together and fights in the corner, a loss survived above all. The first two weeks with a new coach train slower. It is felt on fight night: a call rehearsed with this coach lands in full, one that was not lands weaker; the top of the book opens only with trust.
4. **Changing coach.** A hire is a block of about 4 weeks, so no hire-for-a-week trick. The cost shows before the click: the slow start, the calls lost, what fades. Rotating buys tools; staying buys depth and a corner that works.

Numbers are ranges to test, none is decided.

## Later, only if those feel right
The coach who picks up a move he watched your boxer win with. The parting lesson. Rival gyms poaching a coach. (The rival gym is not built.)

## Order
Fighter model first (it holds the mastery numbers), then a pure module and the bots, and only then a screen. COACH1's Club > People screen stays the base.

## The bots must be able to kill it
Loyal, rotate every block, rotate at the limit, one-week farm. Over many careers on different boxers. It fails if one strategy beats the rest by more than about 5 points of win rate across boxer types, or the farm beats loyal once costs count. It should show: a talented, coachable boxer gains by moving on at the limit; one with a fight inside 4 weeks should stay.
