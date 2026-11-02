# K_BELTROAD1_KALLI - Kalli answer (seat queue SQ26)

Brief: AgentComms/briefs/K_BELTROAD1.md
Sent: 2026-11-02 16:40 | collected: 2026-11-02 17:01 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Reviewing the belt road now. The full answer follows in parts.

**PART 1 of 2**

**The short verdict:** the belt road is a good-looking progress bar with no decisions in it. The player watches Ana fill bars. The fun is in the structure: a long climb, IBJJF time rules, owned moves. The flatness is that every week plays itself, the stripe is always right to give, and an open is a coin flip with an entry fee.

**1. Is the stripe a real decision?**
No. A stripe is due, it costs nothing and it carries no risk, so the player always presses it. That makes it a notification with a button.

*What would make it a choice:* a stripe should be morale against standing.
- **Giving it on time:** morale +6 and loyalty +3. The gym's grading standard is unchanged.
- **Holding it back a quarter:** Ana trains with a chip on her shoulder. Mat-time gains go up 15% until the next stripe, but morale drops 8, and with loyalty under 50 she starts asking about other clubs.
- **Giving it early, before it's due:** morale +10, but the gym's "grading standard" drops a step. Members see it (members' trust -2), and Ana's next open seeds her against tougher people of the same stripe.

Three answers, each with a cost. The coach's line recommends one based on Ana's traits, for example "Ana's hungry: holding it back would fire her up."

**2. The one weekly choice**
**What she drills**, picked from three moves, with the cost in time. The current auto-pick (the move closest to owned) becomes the coach's default, marked COACH'S PICK.
- **Closest to owned:** the safe road to the next stripe. The bar fills fastest.
- **The gap:** the weakest group, say takedowns at 6 of 30. That's slow (+3.2 a week), but it raises her open odds against the bracket's style, because opponents in the next open lean on a particular group (see 3).
- **Her favourite:** a move she already owns, pushed past 30 to a "signature" at 50. No progress toward blue, but +0.05 to her match chance in any match where it applies.

Why this choice and not class count or privates: it ties the week to the open and to the belt road at once, and it costs only time. Privates come later as a money sink (£40 a session, +2× drill rate for that move).

Arguing against it: three drill choices every week can become a chore. The fix is the same as the boxing whiteboard: the coach's pick stands unless the player changes it, so it's 0 or 1 clicks a week.

**PART 2 of 2**

**3. Opens**
- **Before pressing Enter, the player reads three things:**
  1. **The bracket's lean.** One line from the organiser's past results, for example "This open: mostly wrestlers. Takedowns decide it." It names the syllabus group that matters, which feeds the drill choice. The first open is free of this line; after that, one week of tape study reveals it.
  2. **Her weigh-in.** Her walking weight against featherweight, as a word: ON WEIGHT, TIGHT (a week of light classes) or CUT (one class lost, -0.05 chance in her first match). No-gi opens weigh on the day, so a cut matters.
  3. **Her chance as a word, not a percent:** LONG SHOT (under 40%), EVEN, or FAVOURITE (over 60%), for the first match only. The rest of the bracket is hidden until the day.
- **What a result changes:**
  - **A win in a match:** confidence +4. A submission win also gives +1 mastery to the move she won with.
  - **Winning the bracket (gold):** a stripe comes due straight away, members +2 on the BJJ side, and a news line.
  - **A loss by submission:** confidence -6 and a named habit hint ("Ana leaves her arm out in guard"). That gives the player a drill target, so the loss feeds the loop.
  - **A loss on points:** confidence -3 and nothing else.
- Single elimination with 8 people means 3 matches for gold. At about 54% a match, gold is about 16%. That's fine for a first open. Show the "about 1 in 6" as the coach's guess, not a number.

**4. What a BJJ athlete gives the gym**
These are small UK club numbers in the game's currency. NOT COMPUTED against real club books.
- **Members:** a BJJ side starts with about 8 adult members at $70 a month each, so $560 a month. Every gold medal at an open brings 1 to 2 new members. Each stripe Ana earns is a small spike, and a blue belt brings 3 new members once.
- **Money:**
  - Open entry costs $95 to $110. Most opens pay no prize money, so every open is a loss in cash and a gain in members and reputation.
  - Ana can teach the beginners' class from blue belt on, saving $30 a class on a hired coach.
- **Reputation:** gym reputation +1 for each open medal and +3 for a promotion. At blue belt the gym can host its own open, which takes in about $800 at the door, minus about $400 in costs.
- **Why the player cares:** BJJ is the steady side of the business. Boxing gives big nights, while BJJ gives monthly members who stay. Ana's progress is a sales pitch for the class.

**5. My one first change: the stripe decision**
Spec, buildable in a day:
- When a stripe is due, the COACH'S CALL panel shows three buttons instead of one: GIVE IT NOW, HOLD IT BACK and, before it's due only, GIVE IT EARLY (greyed out while a stripe is due).
- **GIVE IT NOW:** stripe +1, morale +6, loyalty +3.
- **HOLD IT BACK:** no stripe. Ana's mat-time gains rise 15% for the next quarter. Morale -8. If loyalty is under 50, add a news line: "Ana asked about another club."
- **GIVE IT EARLY:** stripe +1, morale +10, and a "grading standard" counter (starting at 0) gets +1. At 2 or more, members' trust -2 and her next open's bracket lean becomes "tough".
- The coach's line picks a recommendation from her traits: hungry or high confidence → HOLD, low confidence → NOW, low loyalty → NOW.
- One record entry per choice in the RECORD tab, for example "Stripe 3 held back (week 34)".
- Tooltips on each button name the cost in plain words.

Arguing against my pick: the drill choice touches every week, while the stripe comes only every few months, so maybe the drill should come first. I'd still ship the stripe first. It's one panel and three buttons, and it turns the most visible button on the page from a formality into a decision.
