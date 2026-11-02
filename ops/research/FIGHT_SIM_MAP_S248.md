# FIGHT SIM MAP (S248) - how a boxing fight is decided today, and how training feeds it

Built for the operator's S248 question (verbatim): "should we focus on the training floor mechanics ( or let that just be animation
without player interference) or on mechanics and presentation (more meaningful actions for the player to focus ) that really simulate
the training and its results to a fight (without silly mobile mechanics of course) , give the player understand where the fighter lacks
how strong he is , i do not even know how damage is calculated,how the fighter chooses where to hit etc , how these can be regulated
through training? what players of boxing expect from such a game , and whats your opinion".
Source: a read-only code survey of the S248 tree (paths under Godot/). Line numbers drift; the function names hold.

## Engine
Boxing runs on FightRealtime.gd (20 Hz ticks) through FightBeatAdapter. Game switches on by default (defence_model, boxing_output,
training_strands, ludo_composure, reach_edge, recovery_rate).

## 1. Damage (FightRealtime._run_impact)
- Range gate 1.1 m. Who throws: volume weight 0.75 + 0.5*(conditioning+speed)/200 x pace (cautious 0.8 / aggressive 1.25).
- Miss ladder: clean_at = (0.20 + 0.30*technique) x range_fit, glance_at = (0.55 + 0.20*technique) x range_fit; boxing x0.58;
  wrong-distance punch range_fit 0.45; small lifts (feint, spar edge, plan, corner, rivalry, counter window); technique strand edge.
- Force: base = 0.18 + 0.42*power*(1 - 0.5*balance_break); force = base + (1-base)*rand^(2.2 - technique).
- Defence only DOWNGRADES a landed hit (clean -> absorbed/blocked/slipped), never makes it miss: read chance from speed + reading
  (0.6*fight_iq + 0.4*defense); block/evade weighted by defense and speed; angle, guard coverage, composure. Mid-punch = no defence.
- Fatigue at an empty tank: technique x0.55, power x0.80, defence x0.50, output x0.45.
- Wear: force x contact (clean 1.0 / glancing 0.4 / absorbed 0.25) x 3.0 off a 0-100 head/body condition.
- Shock (clean only): head 0.10*force^2*(1+head wear) cap 0.20; body only at force >= 0.8 -> delayed liver collapse 5-25 s.
- Knockdown: roll < 0.09 + 0.12*head wear; flash KD always rises; else beats the count with 0.05 + 0.40*(0.4 cond + 0.3 iq + 0.3 head).
- Stoppages: 3 KDs in a round TKO; head <= 15 or eye shut = doctor; referee standing TKO at severity >= 0.48 for 8 s.

## 2. What he throws and where
- Movement intent from preferred range (power, technique, reach), tolerance from fight_iq.
- Arsenal: tier <= 2 always, higher if learned; in game cut to 22 certified boxing strikes + 3 guards.
- Distance band POCKET/MID/LONG by gap/reach; low fight_iq throws the wrong band's punches (0.45 penalty).
- Two-stage pick: role (setup/damage/counter) by the plan's priority weights, then punch + head/body by region share x plan target
  bias x catalogue usage prior (jab 2.04, cross 1.24, lead hook 1.56, rear uppercut 0.26) x jab multiplier x range fit x stance.
- Plans: out-boxer, pressure, boxer-puncher, counter-puncher (role priority, pace curve, target bias - pressure body 1.3).

## 3. Attributes
power, technique, speed, defense, conditioning, fight_iq (+ grapple x3 for MMA), 0-100; potential 55-96. Chin is NOT a real stat
(only seeds composure); recovery_rate derived from conditioning/age.

## 4. Training -> stats -> fight
- Stations (gain per fresh hour): treadmill cond 6, bike cond 4.5, weights power 5, heavy bag power 6.5, speed bag speed 6, pads
  technique 5 + speed 2.5, sparring iq 5 + technique 3 + defence 2, defence drill defence 6 + iq 1.5.
- Per minute rate/60 x efficiency (1.0 full stamina -> 0.1 empty); under 15 stamina = injury risk. Floor multipliers: sloppy form
  x0.5, coached block x1.15, pad-man tag x1.15, station level.
- Commit: points = raw x 0.0066 x coach factor x headroom ((potential - stat)/20 clamped 0.15-1.0); ceiling potential + 10.
- The booked fight copies the raw saved athlete, so trained stats DO reach the fight.

## 5. What the player sees
Result screen: deciding moments, punch table, cards, connect %, jab share, range owned, knockdowns, "what the night changed". NOTHING
ties an outcome back to a stat or a training choice. Stat tooltips are stale (describe the old FightSimulation).

## 6. Gaps
- Chin does nothing to damage/KD/recovery; no station trains it.
- Fight IQ means two things (derived on the profile, raw in the bout).
- recovery_rate matters in the fight, no station trains it. Reach/height/stance fixed.
- Defence is trained but works as "landed hits count less", not "fewer land" (tooltip says the latter).
- Strands (technique/footwork/conditioning edges) fill only from technique sessions, not floor stations.
