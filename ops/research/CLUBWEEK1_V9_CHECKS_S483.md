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
