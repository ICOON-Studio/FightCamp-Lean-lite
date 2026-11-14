# AMATEURWEEK1 map v8: Claude's CHECKs answered (S474, from the code)

1. WeekPhase amateur branch (map s1): DONE S474. scripts/rules/WeekPhase.gd: a bout with `fight_week: true` (not pro, not a
   championship) runs 2 weeks out as BUILD (was PEAK); its fight week follows bout["load"] (rest_up = today's taper,
   tick_over, train_through). Camp bouts unchanged. LOAD_DEFAULT stays rest_up until Q-S294-229 (Tick over = one rest day).
   Bouts.gd does not set `fight_week` yet: it lands with the fight week screen (Set camp leaves amateur bouts the same day).
2. Coach factor with only the head coach (map s4.1 COACH AWAY): the player IS the head coach (HeadCoach.gd, no rating).
   Training speed comes from the HIRED coach (Sim.coach_rating); with none, NO_COACH_RATING -> coach factor 0.6
   (Sim.gd:45 "Without a coach training runs at 60%"). So "assistant away a full week" = the other boxers train at 60%.
   The COACH AWAY card prints "at 60% (no coach with them)"; mockup v1 fixed (it said 0.85).
3. Bouts.weigh home-show branch (map s4.5): Bouts.weigh_in_today = day before (c.day == bout.day - 1); weigh() checks
   BoutRules.made_weight(weight, limit). The club-show branch needs: weigh on bout day (weigh_in_today: c.day == bout.day
   for a fight_week bout) and WeighGap.in_gap(own, opp walking kg, class limit) instead of the limit. Opponents carry no
   walking weight today: the rival needs one (class limit - 0..2 kg, from hash). Waits on Q-S294-229 item 6.
