# CLUBWEEK1 v9 - Claude's CHECKs (map section 11), S483

Read from the code on main (1b061582+), 2026-11-15.

1. **The coach's pad hours in code: NONE.** Each boxer's evenings are her own (PadWeek.NIGHTS: between fights 2+1 / 3+1 /
   4+1 pad+sparring nights, in camp 2+1 / 2+2 / 3+2; a pad night = PAD_NIGHT_MINUTES 240 of drilling). Nothing shares the
   coach between boxers. The v9 pad-turn unit (3 turns an hour, sessional 2 hours, full-time 3) is NEW code -> owner
   question 2 is board Q-S294-242.
2. **A second class an evening: NONE.** One evening class: DuesLevers.CLASS_WEEKLY 350 / GameMoney.weekly_income
   "classes" (only with a coach). A full (+$117) and a short (+$78) second class, and the member target, are NEW.
3. **Stipend and sponsorship: one record per fighter, yes.** The stipend is per fighter (GymSpend.set_stipend, Club > Money
   act "stipend" on/off). Outside company sponsors are a DIFFERENT record (Career.deals, offered after wins, BoutFinish) and
   stay as they are; v9's "gym sponsorship" = the stipend, renamed and billed in 4-week blocks.
5. **Which abilities the fight reads:** power, speed, technique, defense, conditioning, fight_iq (BoutRules.fight_power;
   chin aside). WEAK SPOT reads these six (TASK_MORNINGS1).
8. **The Loyalty trait's range:** personality.loyalty, 0-100 float (Data: 60, 82); Loyalty.value reads it, else START 50.
   Loyalty.gd already has bands, dated causes, the talk words and leaves(); v9 adds the drift to 60 and the new causes.
9. **The pro camp's length:** AskBout.CAMP_WEEKS 3.
4, 6, 7, 10: not yet read (StepMastery night count, the later-date path, COACHFIT1's budget, the AMATEURPROBE1/MONEYFOUR1
files) - before ClubDeal v9 is briefed.

**Owner questions on the board (S483):** Q-S294-242 pad hours, Q-243 day job, Q-244 leaving, Q-245 loyalty on screen.
Q1 (the Club week tab) waits for the drawn page (map section 12).
**First seat task:** TASK_MORNINGS1 (Arena) - coached mornings + the weak spot, no owner answer needed.

## Owner answers (S484, asked again in chat - the board showed the 5k-word map, not the question)
- Q-242 pad hours: "No, never short" - every boxer always gets full pads; there is NO pad-turn sharing rule. ClubDeal v9's
  pad turns are dropped; selling a class / a 4th boxer / a twist never sends anyone to the bag.
- Q-243 day job: "2 mornings" - an unsponsored boxer loses 2 coached mornings a week.
- Q-244 leaving: "Yes, they can leave" - under 25 loyalty after 2 talks = leaves; turning pro under 50 = outside manager, club
  share 10% instead of 25%.
- Q-245 loyalty display: 0-100 bar (his pick), with its word beside it ("62 - Settled").
CHECKs 4, 6, 7, 10 can now close; the club week build brief needs no pad-turn module.

## CHECKs 4, 6, 7, 10 closed (S485, read from main 155771bb)
4. **StepMastery counts nights with a turn: moot.** Pads are never short (Q-242), so every pad night is a full night and the
   S463 study slot fills as today (about 6 a week). No change to StepMastery.
6. **A later-date path in code: NONE** (no reschedule/postpone anywhere in scripts/). With pads never short, a fight week on a
   class week costs nobody a pad night, so the collision line's SHORT cases are gone; only FILM over (3 of 2) is left.
   DECIDED: the Later date button and the collision line wait for v2; v1 shows the film line only ("Film: 3 boxers, 2 seats -
   one watches alone") on the bout page.
7. **COACHFIT1's budget: one budget, COACHFIT1's coach time.** COACHFIT1 v8 already charges mornings (Normal 0.5, Hard 1.0)
   and borrows past the budget at a FIT cost (-8 / -18), never a missed session. That matches "never short": a busy coach
   gives a worse session, not a missing one. The club week reads CoachedMornings.owned (You 4 + Coach 2 sessional / 3
   full-time, on main since MORNINGS1) for the morning count; a sold second class costs Coach 1 coach time that evening.
   ClubDeal.gd (R73DEAL1, pad places and shorts) is SUPERSEDED for pads; only class_cash / class_members_4w stay in use.
10. **AMATEURPROBE1 / MONEYFOUR1:** AMATEURPROBE1 (S430, amateur bouts 1-2 weeks out) still stands - the fight-week code
   since then kept its lead rule. MONEYFOUR1 (S430) is SUPERSEDED by FOURMONEY1 (S484, today's bills): four stipends on
   $17,200 last 9 weeks dues-only. Quote FOURMONEY1, not MONEYFOUR1; FOURSTART1 adds classes and ticket cuts.

All ten CHECKs closed. Build plan: ops/research/CLUBWEEK1_BUILD_S485.md.
