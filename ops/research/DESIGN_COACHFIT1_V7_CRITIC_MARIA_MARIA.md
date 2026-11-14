# DESIGN_COACHFIT1_V7_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ126)

Brief: research/DESIGN_COACHFIT1_V7_CRITIC_MARIA.md
Sent: 2026-11-14 18:40 | collected: 2026-11-14 19:12 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give COACHFIT1 v7 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it reaches the owner's bar, just. It fixes v6's contradictions. It now has one word for the coach's budget (coach time, no longer "energy"), one rule for how high a coach can teach, a fit range that adds up, and sessional against full-time as a real early choice. The worked bout week (10.3) proves the corner costs something. It stays at 6 on general design because a lot of new rules sit on top of a week the game already has, the coach's default may beat a hand-made board, and nothing is probed yet.

## Scores

**1. DEPTH: 7/10**
What works:
- **The corner costs coach time,** so cornering competes with the other boxers' PEAK evenings. The worked week shows a trap (A), a fair answer (B) and the best answer (C).
- **Modes are a fork:** TEACH helps the boxer on Raw moves and hurts the one on Sharp moves, so a mode picks whom to favour.
- **Shared pad nights:** 1.5 coach time against a fifth of the second boxer's gain.
- **Bond is scarce:** 1 or 2 Trusted pairs per coach, and leaving a pair costs the bond you built.
- **Raises:** pay, or a held rating and a coach who works less.
- **Promoting the club coach** costs the fitness classes and 40 members.
- **Real fit.** Real small clubs work this way: the head trainer can't hold every pad night, a volunteer gets brought up, and the corner goes to whoever the boxer listens to.

What holds it back:
- **The coach's default may be good enough.** BOTSUITE asks for only 3 wins in 100 over a season for a hand-made board. If the default writes a sound board, most players never open it, and the depth stays hidden.
- **Fit stacks five parts** (temper, mode, coach time, bond, focus) on top of the existing chain (pace × coach factor × headroom × intensity). Gain runs from ×0.60 to ×1.32. With PEAK CAMP and the camp focus multiplier as well, a TOP FIT camp could outgrow the 59/45/41 balance. BALANCE only tests an average boxer.
- **Focus +10 is always on** for whichever area holds the FOCUS stat, so the right cell is always the FOCUS cell. That's a small default, not a choice.

**2. GENERAL DESIGN: 6/10**
What works:
- Every critic point gets a row: done, done in part, or refused with a reason.
- Code numbers are kept: coach factor, morale trust, Ring general ×1.25, the 4–6 plan line cap.
- No names outside headers, no fixed pronouns.
- No week lock, no new top-bar flag, no pop-up.
- Useless options cut.
- 21 menus wired, with honest NEW and CODE columns.

What fails:
- **The main screen is in an app that isn't built.** M1 lives in the office desktop's Staff app, which the pack says is AGREED, NOT BUILT. Its look needs an agreed mockup first (pack section 7). Club > People could carry the board in release 1.
- **The evening rule changes today's training.** "An evening with no coach free runs at 60%" applies the no-coach rule per evening. Today one hired assistant covers every evening at the coach factor. With the sessional assistant at 8 coach time, two boxers in a normal week (3 pad + 1 sparring each, about 9 coach time) are over budget every week, not only in bout weeks. COACHTIMEPROBE expects 30–60% of bout weeks; the sums suggest more. Re-check that one boxer plus the sessional assistant stays on budget in BASE.
- **"Mornings build nothing" for bond, but most fit parts apply to mornings.** Assigning a morning coach for Stranger fit (−4) makes a coached morning worse than an uncoached one until bond grows, and bond can't grow there. The map says "leave it uncoached" is a real answer. On day one it's the only answer.
- **The head coach at "the best assistant × 0.9"** means the head coach gets worse when there's no assistant, and better the moment one is hired, with no rating of their own. It's honest to the pack but odd to read. Hover must explain it.
- **Coach growth +1 per 15 sessions** with the full-time assistant at conditioning 90 already maxed. Growth only matters for the sessional assistant and the promoted club coach. Fine, but say so.
- **Colour:** fit words are written (TOP FIT, GOOD, MIXED, RISKY) and that's good. But "risks in red" on the Monday column, and the quarrel need in red, need words beside them.
- **CHECKs that change the sums:** whether both assistants can be hired together, which rating WeekPlan reads, and whether a shared night already counts per boxer.

**3. PLAY: 6/10**
There's a first-season arc: Working in about 2 weeks, Trusted around week 11 with a visible extra plan line, the first raise or quarrel inside 8 weeks, and Monday lines that name the point the fit won ("Accuracy 63 to 64, a week early"). The corner's word taken in shows on fight night. But the gains are small and spread out (+1.0 against +0.86), and most weeks the player confirms the coach's board. The moments that feel like something (a quarrel, a raise, a coach leaving) are rare by design.

## Options: missing, useless, and what each changes

**Missing**
- **A clear default line:** "Coach's board: n in 100 below your best last month", so the player knows when editing is worth it.
- **A cap on stacking:** fit, camp focus and PEAK CAMP together shouldn't pass a set gain (EXAMPLE ×1.6).
- **Bond from mornings at a low rate** (+0.5 for a Hard coached morning), so a morning coach isn't always a loss on day one.
- **A release-1 home for the board** on Club > People, until the Staff app is built.

**Useless or near-dominant**
- **Coaching a Normal morning with a Stranger pair:** fit 46, worse than uncoached and costs 0.5.
- **SHIELD mode:** twist morale costs −2 smaller, against LIFT's −12 to −8 and +3 a week. LIFT almost always wins.
- **The coach's request** ("Let me take the roadwork"): +3 fit, refuse costs nothing. It's free to grant, so always granted.

**What each option changes**
- **Assigning a coach to a cell:** that cell runs at fit (×0.60 to ×1.32 gain, ×1.10 to ×0.92 tiredness) and costs coach time.
- **Uncoached morning:** today's gain, no cost.
- **FOCUS:** +10 fit on that stat's area.
- **Mode:** LIFT (a loss −8 not −12, Flat and Low +3 morale, +0.5 time), SHIELD (twists −2), POLISH (Usable and Sharp ×1.15, New and Raw ×0.90), TEACH (the reverse), PUSH or EASE (release 2).
- **Shared pad night:** 1.5 coach time, 60/40 split you pick.
- **Rest this week:** no sessions, bond paused, +3 coach time next week.
- **Corner pick:** 3 coach time; word taken in from morale × coachability × bond, capped 1.10.
- **Swap this week:** −2 fit. **Swap for good:** new pair from its own bond, old pair decays.
- **Raise:** pay +$50 a week, or a held rating, −1 coach time, then −2 and "looking for work", then the coach leaves.
- **Promote the club coach:** +$170, 8 coach time, Steady hand; fitness classes and +40 members stop.
- **The boxer's ask:** hear +5 morale, overrule −5.
- **Quarrel:** EASE, move the area, or keep going (−6 bond, −5 morale).

## To reach 10/10

1. **Check the everyday budget.** Price an ordinary BASE week for one and for two boxers with each assistant. If the sessional assistant is over budget in a normal two-boxer week, raise it to 10 or make a pad night cost 0.75. Pass line: one boxer plus the sessional assistant is on budget in every BASE week.
2. **Prove the board is worth editing.** BOTSUITE's pass line becomes 5+ wins in 100 a season, or the Monday page prints "Coach's board: n in 100 below your best last month" so the player knows when to look.
3. **Cap stacking.** Fit × camp focus × PEAK CAMP stops at a probed ceiling. BALANCE runs on a TOP FIT camp as well as the average one.
4. **Fix the morning trap.** Hard coached mornings build +0.5 bond, or a Stranger's −4 doesn't apply to mornings.
5. **Price the free options.** SHIELD also halves a quarrel's bond loss. The coach's request costs −2 bond when refused and +3 fit when granted.
6. **Put the board on Club > People in release 1,** with an owner-agreed mockup. Move it to the Staff app when that app is built.
7. **Words beside every red:** "QUARREL" and "OVER BUDGET" print as text on the Monday column and Home.
8. **Settle the three CHECKs that change the sums:** both assistants at once, the rating WeekPlan reads, and whether a shared night counts per boxer.
9. **Run FITPROBE1, COACHTIMEPROBE, BONDPROBE1 and BALANCE,** and replace each ESTIMATE in 2.1, 3.3, 6.1 and 8.1.
10. **Make Trusted felt.** When a pair reaches Trusted, the Monday line lands last as the week's surprise, and the new plan line opens with "Write it" on the Game plan.

**My 10/10: Coaches this week, 1920×1080, Look B whiteboard (Club > People in release 1)**
- **Dark top bar:** the week, the next bout circled, coach time per coach as "7 of 8", and the big CONTINUE.
- **Left (440 px), COACH CARDS:** name in the card header, portrait, role, temper and mode as a word with its price, coach-time pips with "borrowed 1" in text, teaches-up-to per area, growth "next +1 in 6 sessions", school chips, wage, and a raise sticky with Pay and Say no. Buttons: mode switch, Rest this week, Let go, Promote.
- **Centre (1000 px), WHO RUNS WHAT:** one row per boxer with portrait, class in kg, record and a FOCUS pill. Five area columns, each cell with the coach magnet, fit word, "+1.0 Accuracy", bond pips and at most one tag in words. The Coach's pad nights row at the top when two boxers are in camp, showing the 60/40 pick and what the 40 side loses.
- **Right (400 px), ON MONDAY:** each boxer's FOCUS stat now and after the week, bonds crossing a step, next week's coach time, risks in words, and "Coach's board: 2 in 100 below yours", with one gold frame on the week's best gain.
- **Bottom strip, in a bout week:** corner magnets with word taken in, coach-time cost, bond step, and what moves to cover it.
