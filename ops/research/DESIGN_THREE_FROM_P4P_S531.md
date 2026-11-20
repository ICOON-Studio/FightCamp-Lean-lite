# Three ideas from the Pound for Pound playtest, made our own (S531)

Owner: "build 1, 2 and 3 but it has to be distinct from theirs". Source: ops/research/PLAYTEST_POUND_FOR_POUND_S531.md s5.
Their versions, in one line each, so we can see we are not copying them:
- Theirs 1: the PROMOTER buys an exclusive signing window on a fighter from the card, paid in tokens.
- Theirs 2: a HYPE grade on a matchup with two reasons and a public betting line.
- Theirs 3: a broadcast HUD over a 2D cage: momentum bar, crowd meter, stats columns, radio play-by-play.

We are a GYM, not a promoter. Each of ours turns on that.

## 1. "She asked about your gym" - a boxer from the card wants to train with you
Not a purchase and not a window the player opens: the BOXER chooses. After a bout, one boxer who was on that card
(the opponent, most often) may ask to train at your gym, because of what she saw your corner do that night. The pull is
earned in the fight, not paid for:
- The reason is your coaching, read off the bout itself: your boxer's plan worked (the Why), she came back after a hurt
  round, the corner's calls fitted. A beaten opponent who was out-thought says so: "Your corner had my number. Can I
  train with you?"
- The chance grows with the gym's reputation and with how clearly your corner won the night; it falls if she is from a
  bigger club. At most one ask a bout; none from a boxer of the other sex's division if the roster has no place for her.
- What happens: a line on the result page ("After the bout, <role> asked about training here - she'll come by reception
  this week") and she arrives at RECEPTION as a walk-in with her real record from the bout, the same interview and sign
  flow as any walk-in (no new screen, no token). If the player passes, she goes back to her club; the region remembers.
- Distinct from theirs: they buy a fighter; here a fighter buys into YOU, and the price is coaching well.

## 2. "The coach's read" - the head coach's word on every offer
Not hype, not a betting line: what this bout DOES TO THIS BOXER. On every offer card one short verdict from the head
coach and two reasons - one for, one against - read only from her own state:
- the goal she is chasing (goal talk), the ladder (rank, points to the next place), her streak, rest since her last
  bout, the weight to make, the opponent's style against her plan, the gap in ability.
- Verdict words in coach voice: "Take it", "Take it, but camp hard", "Too soon", "Wrong style for her", "Free points".
- Example: "Take it, but camp hard. For: a win moves her to 3rd on the ladder. Against: a pressure fighter, and she's
  been worst on the ropes."
- With no coach hired the read is the owner's own guess, shorter and less sure (coach quality = how good the read is).
- Distinct from theirs: theirs judges a show's selling power for the promoter; ours judges a step in one boxer's career.

## 3. "The corner's eye" - the top-down view shows what the corner sees
Not a broadcast HUD: the view from the stool. On the zoomed top-down ring (T in a round):
- The PLAN drawn on the canvas: a faint arrow for the step the plan holds on this card (where the coach told her to
  go), solid when she took it, crossed when she held it (phase 6) or did not get it off.
- Who OWNS THE RING: a soft shading of the half of the ring the exchange winner is pushing into (it grows over a run
  of won exchanges) - the corner's "you're walking her down" / "you're backing up".
- HURT shown on the body: a red pulse ring and the word HURT under the boxer who is hurt; a TIRED tag when gas < 35.
- The two names, each in its corner colour, in the line above, and the place tag (ON THE ROPES / CLINCH / CENTRE).
- No crowd meter, no momentum bar, no stat columns: everything is something a cornerman reads and can act on with a shout.
- Distinct from theirs: they report the fight to a viewer; ours shows the plan against the fight to the person who
  wrote the plan.

## Wiring table (filled as built)
| Mechanic | Screen | Wired to |
|---|---|---|
| 1 She asked about your gym | Result page line (ResultPage.summary "CardAsk"); NEEDS YOU amber "Meet her"; Reception interview | CardAsk.gd (chance/asks/walkin/reason/gone), BoutFinish._card_ask, Needs (non-blocking), Sim.step_day (leaves after 7 days) |
| 2 The coach's read | Fights > every offer card ("CoachRead_<id>") | CoachRead.gd (read/line), OfferCard.coach_read/facts (BoutRead.mismatch, BoutRules.days_since_bout, Sim.weigh_forecast, HotStreak, Region ranks, goal) |
| 3 The corner's eye | 3D round, T (top-down) | RingMap.plan_mark/owner, RingTopDown _plan_arrow/_tags/owner wash |

Built S531 evening. Tests: coach_read_test, card_ask_test, ring_map_test (+ golden_path, first_hour(_walk), first_week,
refuse_walkin, offers, results). Change on reflection: her ask does NOT stop time (a story walk-in does) - golden path
caught it blocking CONTINUE. Not yet: a critic round (two fresh critics, 7+) - queued.
