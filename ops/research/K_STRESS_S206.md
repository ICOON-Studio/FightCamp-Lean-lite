<!-- Kalli (gbot thread), K_STRESS_S206 reply verbatim (2 parts), collected S207 2026-10-12 -->
PART 1 of 2

Stress is a hidden 0-100 meter on every fighter that fills from the hard parts of the job. At 100 the game rolls once, and the fighter either breaks into an affliction or, more rarely, steels into a virtue. Composure is the stat that tilts that roll. The manager reads it, manages it and cures it, and the game never takes the fighter's choices out of his hands. Every number below is a starting tune, NOT COMPUTED against the week loop.

**1. What moves stress**

Raises (per event):
- Hard training day: +3 (+5 if strain is already over 60%)
- Back-to-back hard days: +4 on top
- Weight cut week: +4 a week, +8 in the final 3 days, +15 for a failed weigh-in
- Loss by decision: +12. Loss by KO or stoppage: +20. Getting knocked down in a fight: +6 each
- An injury: +8. An injury that pulls him from a booked bout: +15
- Bout cancelled late (opponent drops or a promoter pulls it): +10
- A broken promise (pay rise, title shot, rest week): +18
- A contract request ignored past its deadline: +10
- A rival or gym-mate signed into his division: +6
- A teammate's bad KO watched from the corner: +5
- Weeks without a fight when he asked for one: +3 a week
- Public humiliation (a fall in the rankings, a media story): +5

Lowers:
- Rest day: -6. A full rest week: -20
- A win: -10. A KO win: -15. A title win: -30 (it can reset to 0)
- A promise kept: -10
- A talk in the office (one a week): -8, or +4 if the coach's people skill is low (NOT COMPUTED until coach skills exist)
- A physio session: -4
- A friend in the gym (two fighters with high mood together on the floor): -2 a day
- A good camp (scouting 3 and weight on the path all camp): -8 at the weigh-in

Composure sets the multiplier on every rise: 0.6x at composure 90 and 1.4x at composure 20. That way the stat already in the game does the work, and stress never feels like a second composure.

**2. Threshold and the roll**

- From 0 to 49 nothing shows.
- From 50 to 79 he is STRAINED. A yellow tick shows on his portrait, and his tooltip starts to read "Snapping at sparring partners".
- From 80 to 99 he is ON EDGE. The tick turns orange and gives a 10% chance a day of a small floor incident (missing a session, an argument).
- At 100 the roll happens once, then stress drops to 70 so he doesn't roll every day.
- The roll gives a virtue at 15% + composure/5 (so 15% to 35%). A virtue lasts 4 weeks. Otherwise it gives an affliction from the list below, weighted by what caused the stress: weight cut stress leans to Starving, losses lean to Gun-shy, broken promises lean to Mutinous.
- Afflictions don't stack. A second break while afflicted worsens the current one into its hard form (each state below has one).

Virtues (rare, short, earned):
- STEELED: stress rises at half speed and he never goes rattled in round 1.
- HUNGRY: technique practice runs 25% faster and he asks for a fight within 3 weeks.
- LEADER: every fighter on the floor loses 1 stress a day while he trains.

**3. The afflictions (8)**

*GUN-SHY* (after KO losses)
- Gym: he flinches at the bag and stands back from the ring ropes, with a little hesitation before each pad combo.
- Training: sparring gives half XP, and he refuses hard sparring (the station shows a cross).
- Fight: he starts every round pressured, power is -10 until he lands a clean shot, and his chance to throw first falls.
- Cure: 3 weeks with no sparring plus 2 office talks, or a soft-matched win (he picks up a confidence fight).
- Hard form, BROKEN: refuses to be booked at all until cured.

*STARVING* (weight cut)
- Gym: he looks thin and slow, sits on the bench between stations, and stares at the scale in the locker room.
- Training: stamina regenerates at 70%, and any hard day adds +5 strain.
- Fight: stamina -15 at the bell, and chin -5 in rounds 6 and up.
- Cure: move him up a division, or plan a slower cut path (the camp tab). It clears the week after weigh-in if he makes it.
- Hard form, PURGING: a 20% chance to miss weight by up to 2 lb, whatever the plan says.

*MUTINOUS* (broken promises, ignored requests)
- Gym: arms crossed at the office door, he trains alone in a corner, and the coach's lines get answered with a shrug.
- Training: he skips 1 station a day at random, and coach bonuses don't apply.
- Fight: he ignores one corner instruction per fight.
- Cure: keep a promise, grant a request, or give a pay rise. Talks only slow it.
- Hard form, WALKING: he lists himself for transfer and asks to leave at the end of his contract.

*RECKLESS* (losses by decision, long waits)
- Gym: heavy bag at full power, sparring partners limping off, too much shouting.
- Training: technique XP +10%, strain +50%, and a 5% chance a day of hurting a sparring partner.
- Fight: power +5, defence -10, and he swaps the game plan for a brawl in round 3+.
- Cure: book him a fight within 4 weeks, or a talk with a high-composure coach.
- Hard form, BERSERK: a 20% chance a fight of a deduction (a low blow or a hit after the bell).

*HAUNTED* (watched a bad KO, a career-ending injury in the gym)
- Gym: he stops at the ring where it happened and looks at the corner.
- Training: composure training gives nothing, and the morning slot is often missed.
- Fight: rattled at the first knockdown he suffers, wherever the score is.
- Cure: 2 weeks in the film room (studying it), or a full rest week.
- Hard form, NUMB: morale locked at its floor until cured.

*PARANOID* (rival signed, rankings fall)
- Gym: he watches the other fighters train, stops when they look, and pads up only with the coach.
- Training: he won't share stations with fighters in his division.
- Fight: ring IQ +5 (he reads too much), speed -5 (he's slow to commit).
- Cure: move the rival out of his schedule, or give him the gym's best slot (the 08:00 coach).
- Hard form, SHUT-IN: refuses gym-mates as sparring partners entirely.

*FRAGILE* (injuries, high wear)
- Gym: he favours the hurt side and sits a lot.
- Training: strain on that region counts double, and he refuses stations that hit it.
- Fight: the worn region takes +25% damage, and he guards it (a gap opens elsewhere).
- Cure: a physio block (2 sessions) plus that region under 30% wear.
- Hard form, BRITTLE: any hard day risks a new injury at 10%.

*GLORY-SICK* (after a run of wins, or a title, when composure is low)
- Gym: he poses for phones in the lobby, turns up late, and talks to walk-ins instead of training.
- Training: XP -20%, and he demands better slots.
- Fight: he underestimates; ring IQ -10 against lower-ranked opponents only.
- Cure: a loss, a step-up opponent, or a hard talk (+5 stress for a -40% chance to clear it per talk).
- Hard form, DIVA: his next contract request comes with a 2-week deadline.
PART 2 of 2

**4. The decisions it creates**

- **Rest him or push him.** A hard week buys stats and adds stress, so the 7-day plan becomes a real trade every week.
- **Book now or wait.** A long wait builds stress. A fight too soon after a KO loss risks GUN-SHY.
- **Which division.** A brutal cut is +stress every camp, and moving up is the cure with a real cost (bigger men).
- **Keep the promise or break it.** Promises are a currency now: a cheap cure today, a +18 bomb if broken.
- **Who trains with whom.** A LEADER or friends on the floor lowers stress, and a PARANOID fighter splits the schedule.
- **Which coach takes him.** Talks work better with the right coach (later, when coach skills exist).
- **Pull him or let him fight afflicted.** A RECKLESS fighter is dangerous but can win. That bet belongs to the manager.

What it must NOT take away:
- **Booking stays the manager's.** Except BROKEN (hard GUN-SHY), no state refuses a fight on its own. That hard state is the only one, with a warning a week ahead.
- **No random walkouts.** WALKING only comes after MUTINOUS, which only comes after a broken promise or an ignored request the manager could see.
- **The fight result is never scripted.** Afflictions move stats and phase odds. They never decide a round.
- **Every rise is shown.** Each stress event writes one line in the fighter's log ("+12, lost on points") so a break never feels unfair.
- **The weekly plan is never overridden.** States change outcomes (skipped stations, XP, strain). They never rewrite the plan.

**5. Where it shows (no new screen)**

- **HUD:** the fighter portrait strip gets a ring around it that fills with stress. Yellow at 50, orange at 80, and a cracked icon for an affliction (Lucide `brain`, tooltip "See what's weighing on him"). A virtue shows a gold ring with `sparkles` "See what's driving him". The mail button gets one notice the day he breaks.
- **Profile OVERVIEW:** a stress bar under morale, the state chip next to it (icon plus one word, tooltip with the effect and the cure), and the last 3 log lines that moved it.
- **Profile MEDICAL:** FRAGILE and STARVING appear here too, beside wear and weight.
- **Profile CONTRACT:** promises show stress at stake ("Break this: +18").
- **Profile CAMP:** the weight path shows the stress it will add week by week.
- **Training plan:** each day's station shows its stress cost as small pips next to its strain.
- **The floor:** the 3D animations above (flinch, sit, arms crossed, posing) are the real tell. A player who watches the floor reads stress before the ring fills.
- **Fight night:** the state chip sits on the corner card. Between rounds the corner has one line per state ("He's gun-shy, keep him busy behind the jab").

**6. Demo or later**

In the boxing demo:
- The stress meter, the threshold and the roll, with the full event list for training, weight cuts, losses, wins, rest and talks.
- 4 afflictions: GUN-SHY, STARVING, RECKLESS, FRAGILE. They hang off systems the demo already runs (losses, cuts, wear, booking).
- 1 virtue: STEELED.
- The HUD ring, the OVERVIEW chip and log, and the training stress pips.
- 2 floor animations: the flinch at the bag and sitting on the bench. The other two states show by icon only until they get animations.

Later:
- MUTINOUS and GLORY-SICK, once the promises and requests loop is deep enough to matter.
- PARANOID, once there's a multi-fighter roster with divisions that overlap.
- HAUNTED, once there's a gym-mate KO in the corner view.
- HUNGRY and LEADER, plus all the hard forms.
- Coach people skill on talks.
- Stress from media and rankings.
- The MMA and grappling version, where the same states map across (GUN-SHY can turn into fear of the takedown).

Arguing against my own strongest ruling (put the roll at 100): a Darkest Dungeon break works because a raid is short and the player can see it coming. Our seasons run for months, so a single roll at 100 can feel like a coin flip after 6 quiet weeks of slow build. The other option is a growing daily chance from 80. That feels more lifelike but hides the moment. I keep the single roll, because it gives a clear moment the player can plan around, while ON EDGE incidents at 80 make the warning felt first.

Two things aren't computed yet. One is whether 4 afflictions fit the demo's first 5 hours without every fighter breaking once. That needs a run of the week loop with these numbers. The other is how often the virtue roll lands at low composure.
