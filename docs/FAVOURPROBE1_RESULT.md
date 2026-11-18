# FAVOURPROBE1 result - where favours with the hosts sit after a year of real play

Probe run: 2026-11-18T04:03:01. 40 seeds x 2 clubs x 2 styles = 160 runs of 364 days (seeds 4421..4460). A measurement only: no rule or constant was changed.

The fight week map (AMATEURWEEK1 v6 s7-8) set the target: **an average club sits at 1-2 favours with a host, not 3**. Favours are EARNED only by a host's late ask (LateAskWire: yes = +1, cap FightWeekEvents.FAVOURS_MAX 3) and SPENT by an outside sparring partner (FightWeekPlan.lock via PartnerMatch.cost: a favour when held, else $160), the weigh-in's ASK FOR A KILO (one favour with the host), a missed weight the host cannot re-match (PullOutWire.weigh_miss) and a fall-through's next-month slot (PullOutWire.answer). Every host starts at FightWeekPlan.FAVOURS_START 1 - a club not in Career.favours counts as 1, so every read here goes through FightWeekPlan.favours(c, host), never the dictionary alone (the brief's trap).

## Population

- **QUICK**: a quick-start career, Lucy signed at reception (Sim.sign, the interview's three cards), Reid hired (sessional). One boxer.
- **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw, women's lightweight), Kira (wfw, women's featherweight), Josh (mww, men's welterweight) and Ana on the mats, Reid hired. Three boxers, three classes.
- Both past the first-week guide and the first hour (TestJump's classic calendar). Rivals' invented pasts re-seeded to the run seed (quick_start draws randi() before the probe sets its seed), so a replay agrees.
- 40 seeds a club a style, 364 days each through Sim.step_day - the real day loop: offers, pull-out rolls, late asks, injuries, the region's own shows. No fighter is synthesized or copied: the clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical.

## The two styles (decisions in code, every open need answered as TestJump._tidy answers them)

- **THRIFTY**: accepts every sheet offer; YES to every late ask; pays outside partners with a favour when it has one; asks the kilo whenever the fight week's scale offers it (weigh_ways[2].ok at the set); a fall-through answered with next month when a favour is left, else the replacement (else go home).
- **EAGER**: the same, but NO to every late ask - it earns nothing: the floor.
- Both: the fight week as FightWeekPlan.draft writes it, every night on the best-ranked free partner (ask_probe4's pick), locked when the FIGHT WEEK need appears; the bout fought by the game's own sim (Bouts.fight_step "sim"); the office goal five_round_engine; an injury past the bell pulled out; a rival club's approach answered with a keep (MATCH first). Pro offers declined (Roster.decline_pro: the year stays in the amateur club-show economy favours live in); the nationals never entered; the week review closed. Cash floored at $20000 as two_boxers_two_years_test does - money is not the measurement, and the floor never changes a favour payment (PartnerMatch.cost prefers a favour whenever one is held).
- A host is **touched** when the club booked a bout at its show, received its late ask (yes or no), or took a sparring partner from it (favour or cash). Final favours read at day 364 for every touched host in RegionShows.HOSTS.

## The table (style x club; means a run, % of touched hosts at each favour count)

| style | club | touched hosts | mean favours | at 0 % | at 1 % | at 2 % | at 3 % | asks a year | taken a year | partner spends | kilo spends | miss spends | next-month spends |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| THRIFTY | QUICK | 195 | 0.31 | 71.8 | 25.6 | 2.6 | 0.0 | 0.7 | 0.3 | 1.4 | 0.0 | 0.0 | 2.2 |
| THRIFTY | TEST | 240 | 0.18 | 82.1 | 17.5 | 0.4 | 0.0 | 0.8 | 0.3 | 2.5 | 0.0 | 0.0 | 2.6 |
| EAGER | QUICK | 205 | 0.26 | 73.7 | 26.3 | 0.0 | 0.0 | 0.4 | 0.0 | 1.1 | 0.0 | 0.0 | 2.7 |
| EAGER | TEST | 240 | 0.21 | 78.8 | 21.3 | 0.0 | 0.0 | 0.8 | 0.0 | 2.4 | 0.0 | 0.0 | 2.4 |

**THRIFTY pooled** (80 runs, 435 touched hosts): mean **0.24** favours per touched host; 0.7 asks a year, 0.3 taken; earns 0.3 a year; spends a year: partner 2.0, kilo 0.0, missed weight 0.0, next month 2.4. Bouts a year: 16.4 booked, 13.8 fought, 0.0 missed weight. Runs closed early: 0.

**EAGER pooled** (80 runs, 445 touched hosts): mean **0.24** favours per touched host; 0.6 asks a year, 0.0 taken; earns 0.0 a year; spends a year: partner 1.7, kilo 0.0, missed weight 0.0, next month 2.5. Bouts a year: 16.6 booked, 13.8 fought, 0.0 missed weight. Runs closed early: 0.

## The map's target

**THRIFTY average club: 0.24 favours per touched host - OUTSIDE the map's 1-2 target.**

(Per club: QUICK 0.31, TEST 0.18. EAGER, the floor that earns nothing: 0.24 pooled.)

Kilo and missed-weight spends are **zero in all 160 years** (13.8 bouts fought a run): the fight week cuts her toward the class limit and the host's boxer walks near the same limit, so the scale sits inside the 2.5/5.0 kg gap - the kilo is never offered and the weight is never missed. The favour economy that actually moves is the outside partner and the fall-through's next-month slot.

The earning channel is thin: 0.7 asks a year a club, 0.3 of them bookable, against 4.4 spends a year. THRIFTY and EAGER settle at the same 0.24 - saying YES to every late ask does not lift the population off the floor. A year of real play leaves the average club near 0, not at the map's 1-2.

Lock refused 0 weeks. **A late-ask yes the sheet could not book: 38.** The host's ask opens on the weight gap alone (LateAskWire.ready_for), but AskFlow.book refuses when the sheet's next name is past the novice rule for our boxer (AmateurBooking.experience_match_ok): Bouts.legal_index falls back to the next name when nobody in the division is a legal match, so a novice whose whole division has graduated gets asks it cannot take - and, late in the year, only mismatch sheet offers (no bout, the clock runs on). That is the shipped rule, measured here, not changed. Spends are read off the favours each action moved (a before/after snapshot per host), so a partner paid in cash is not counted and a kilo is never double-counted with a partner at the same host.

Reproduce: `python ops/Tools/godot_slot.py run --who favourprobe1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/favourprobe1.log --path . --script res://tools/favour_probe.gd -- seeds=40 seed=4421 days=364`
