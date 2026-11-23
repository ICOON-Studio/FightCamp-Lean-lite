# MMAEMPIRE1 - MMA Empire's new update read and compared (S539)

Source: the installed game (E:\SteamLibrary\...\MMA Empire, Electron, updated 2026-11-23). Read-only: the two script
bundles were pulled out of resources/app.asar into Claude's scratchpad and read there (the asar itself was only opened
for reading); a short new career was played on the hidden desktop (new save slot 2 "Test Promo"; the owner's slot 1 not
touched). Everything below is our own summary of their rules and numbers. None of their code, text or art is in the repo;
the stills sit in ops/previews/s539_mmaempire/ (git-ignored, board only).

## Top 5 for the owner (what to take)

1. THE ROOM TRAINS THE FIGHTER. Their camp bonus is one passive number: gym stars x coach rating x training partners x
   style fit, capped at 7.5 points a year. The new idea is the PARTNERS part: the average level of your gym-mates adds up
   to 12%. Worth a probe for us: one good signing lifts the others' training (recruiting feeds training).
2. WEIGH-IN MISS = THE OTHER CORNER DECIDES. A miss turns on how hard the cut is (1% at an easy cut, 45% at an extreme
   one), the fighter's discipline and how tired he is. The opponent then answers from his personality: fight for 20% of
   the purse, ask for a substitute, or pull out. You can overrule him. Ours ends a miss on a dice roll (1 in 3 re-match,
   else off). Take: the three answers, for the pro and title bouts.
3. A NAMED BACKUP PER BOUT. One dropdown per bout. The backup weighs in too and steps in by himself if a fighter drops
   out and the backup made weight. Take it for the hosted club show: one reserve per bout is a clear, cheap choice.
4. "NEEDS A FIGHT" IS A LIST, NOT A SURPRISE. Roster > Activity counts who needs a booking (4 events missed or a
   quarter of a season idle). Fighters complain after 6 cards without a fight, then louder at +3 and +6. Champions get a
   yearly defence target (1-5). Take: the activity list (display only), then probe whether an idle cost changes bookings.
5. ROUND-BY-ROUND STATS. The fight screen has Total / R1 / R2 / R3 tabs: strikes landed/thrown, knockdowns, takedowns,
   control time, stamina. Our sim already settles each round; landed/thrown per round on our result page costs little.

We already do better: training is a choice each week (theirs is a passive bonus), the cut is planned before the scale
(three ways to make weight), and sparring partners are matched to the coming opponent. Their host-city suggestions
(five cities with forecast takings) do not apply until we run promotions.

## 1. Fight camps (coaches, specialties, prestige, partners, moves, retired coaches)

Theirs (numbers read from the rules; checked live: a 3.5-star Muay Thai camp with a coach rated 74 shows "up to 4.5/year"
on each matching skill, the formula gives exactly 4.5):
- Yearly gain per matching skill = min(7.5, 7.5 x stars/5 x (0.45 + 0.55 x coach/100) x partners x specialty weight).
  Paid out spread over the season (default 20-week seasons). A second specialty counts at 0.55.
- Partners = 1 + clamp((average overall of the camp's members - 50)/250, 0, 0.12): full +12% at an average of 80.
- Specialty weights: each style lists the skills it trains, at 0.25-1.0 (MMA trains every family at 0.4).
- Stars: a big "hub" camp 1.5-5, a local camp 0.5-3; stars = base + clamp(prestige x 0.05, -1.5, +1.5).
- Prestige: +0.22 per win by a member, +1.5 when a member becomes champion, -1.15 when a member rated 74+ leaves,
  -1.2 on a coach change; shrinks by 1.5% a season.
- Coaches: rating 26 + 12 x stars + a random 0-8 (30-96), +8 in the camp's specialty. Replaced at 70 or after 12 seasons;
  a retired member under 72 can take over (chance up to 50%, rising with time). A retired fighter's coach strengths
  come from his own fighting skills.
- Moves: each fighter is reviewed every half season (not in his first half season). Three reasons: losing streak (3
  losses in a row), "outgrown the room" (16+ above the room's average) and "rising" (local camp, 6+ wins or rated 58+).
  The chance depends on temper or ego, scaled hard by loyalty (very loyal: x0.035, capped at 1.5%). The new camp must
  score 0.75 higher: stars x 0.9 + style fit x 3 + closeness to home (same city 3, same country 2.2, under 900 km 1.6).
  A move makes a news story and a message from the fighter.
- Camps open, split (14+ members), close (3 or fewer members after 4 seasons, or at end of life); hubs hold 32.
- Screens: the roster shows each fighter's camp as a link; World Hub > Camps shows the camp, head coach, the training
  bonus written out in plain words, notable members and its roster (still s12_camp).

Ours today: the player IS the club; gains come from the week plan (scripts/rules/TrainingPreview.gd:28 headroom 0.10-1.25,
1.0 a focused week), the head coach card (scripts/rules/HeadCoach.gd:20-22, x1.10 engines / x0.90 craft), equipment
(scripts/rules/GymUpgrades.gd:92 gain_mult, e.g. x1.10) and sparring partners matched per bout
(scripts/rules/PartnerMatch.gd). No "room level" from gym-mates; no rival clubs that rise and fall; retired boxers leave.

Worth taking:
- ROOM LEVEL: training x (1 + small bonus from the average level of the club's boxers), capped near +10%. It ties
  recruiting to training. Probe first (S534 rule): 40 seeded seasons with and without one strong signing; it stays only if
  the other boxers' season gain moves by a visible amount (about 0.5 a stat a season or more) AND the signing choice
  changes in the probe. If it does not change a decision, it is a number, not a mechanic: drop it.
- RETIRED BOXER BECOMES A CLUB COACH: fits the small living world (after the week), not now. Cheap, emotional.
- Rival clubs whose prestige rises with wins and whose boxers move: also small-living-world material, parked.
We do better: their camp is a set-and-forget multiplier the player never touches (a promoter does not run the gym).
Ours is the core loop. Do not copy the passive part.

## 2. Official weigh-ins

Theirs:
- Weigh-ins open the week before the card; the home button turns into "Go to weigh-ins". A clean card is 2 clicks
  (open, Complete weigh-ins), still s29_weighin. All 10 of our test fighters made weight (easy cuts).
- Cut severity = weight to lose / walking weight: up to 6% easy, 10% moderate, 14% hard, above that extreme.
  Severity alone costs stamina (x1 / x0.97 / x0.92 / x0.84), chin and a little speed, even when weight is made.
- Miss chance rises with the cut: about 0.1% at an 8% cut, 0.6% at 12%, 5% at 15%, then +3% per extra point, capped at
  80%; multiplied by the fighter's cut-risk trait, discipline, cardio and composure, and up to +12% per point of energy
  below 6/10.
- A miss: 20% of his purse to the opponent, stamina x0.93, chin x0.97, -1 energy; the bout becomes a catchweight; in a
  title bout only the fighter who made weight can win the belt.
- The OPPONENT answers from personality: more than 4.5% over, or a "diva" (45%) -> pulls out; more than 0.9 kg over
  and not a tough personality (65%), or very disciplined and 1.4+ kg over -> wants a substitute; otherwise he fights.
  The player can overrule (fight / substitute / cancel). Substitute = pick from free fighters in the class.
  "Complete" is blocked until every missed-weight bout is settled: 1-3 extra clicks per miss.
- A fighter's missed-weight count is kept on his record.

Ours today: club shows match by a walking-weight gap with three ways to make it (scripts/rules/WeighGap.gd:44 eat less /
train off / ask the host for a kilo with a favour); a miss on the day = the host re-matches 1 in 3 when a spare is there,
else the bout is off, $300 and a favour (WeighGap.gd:17-20, :102; scripts/state/PullOutWire.gd:195; Bouts.gd:373-381);
the pro/title weigh-in is limit + tolerance (WeighGap.gd:109); the camp cut forecast books pro bouts the boxer can make
(Bouts.gd:159-168).

Worth taking: for pro and title bouts, replace "miss = off" with the other corner's answer (fight for a purse share /
want a substitute / pull out), with the player able to plead with a favour or cash. Probe: in 40 seasons with cuts set
hard, does the player's cut choice in camp change once a miss costs a purse share instead of the whole bout? If the cut
choice does not move, keep ours.
We do better: our player chooses HOW to make weight before the scale; theirs only sees a percentage.

## 3. Backup fighters

Theirs: one backup dropdown per bout in the card builder (still s23_autofill_menu). Eligible: same division, not
injured, energy above 0, contract fights left, not holding out, not booked or reserved anywhere else (other card, other
draft, tournament, World Cup). The backup weighs in with the card. If exactly one fighter drops out and the backup made
weight, he steps in automatically; a title bout loses its title if the champion is the one out. In the test card all four
bantamweights were already booked, so the dropdown stayed at None: the rule cost them a backup.

Ours today: the host's spare on club nights (PullOutWire.gd:192-195, 1 in 3), the short-notice swap only 2+ weeks out
(Bouts.gd:52, :282-295), otherwise a withdrawal (Bouts.gd:300).
Worth taking: on OUR hosted club show (HOSTPROBE2 next), a named reserve per bout the player picks: he costs a fee
whether used or not, and covers a pull-out or a missed weight. Probe inside HOSTPROBE2: does a show with reserves run
more bouts per night and does the player pay for them only on risky bouts (a choice), or always (no choice)?

## 4. Roster activity ("who needs a booking") and champions

Theirs:
- Roster > Activity (still s13_activity): counts Need booking / Booked / Injured / Awaiting debut; columns rank, record,
  streak, last fight, events since, weeks waiting, fights this year, a Book button per row; sorted by "events since".
- "Needs booking" = available and (4+ promotion events since his last fight, or a quarter of a season without one).
- Complaints: after 6 cards without an appearance (plus or minus 2 from trust) he asks for a fight; louder at +3 and +6
  ("I need a fight"); answers: promise a fight (a promise that can be broken) or open the schedule.
- Champions (still s14_champions): held titles, titles without a defence this season, defences booked, weeks left; an
  "Annual defense target" 1-5 (custom 1-20). Champions ask to defend after 6 cards since their last title fight, with
  the same 3-step ladder.

Ours today: the boxer can ask for a bout the day after one (scripts/rules/AskBout.gd:30-63); no idle cost (the "a month
without a fight costs 6 morale" line was false and removed this session, commit 9ebfb3342); the home list of needs
(scripts/state/Needs.gd:34).
Worth taking: a "needs a bout" line per boxer on the roster (weeks since the last bout), display only, no probe needed.
An idle cost (a boxer who waits too long asks, then sulks) goes with REPEATBITE1's question, probe first: does it change
which bouts the player accepts?

## 5. Round-by-round stats

Theirs (still s35_live): during and after a fight, tabs Total / R1 / R2 / R3 with strikes landed/thrown, knockdowns,
takedowns landed/attempted, submission attempts, control time and stamina, beside a body diagram with head / torso /
leg damage and live commentary. Each round's counts are the difference of running totals at the bell.
Ours today: each round stores won / down / stopped (scripts/state/BoutFinish.gd:41-60); the result page is the fight and
what it decided (owner S440).
Worth taking: punches landed / thrown per round on the result page, as a small table - it explains a split decision
better than a sentence. Low cost, no probe: each round already stores punches landed per side (scripts/state/LiveRound.gd:357) and
BoutNight.gd:305 writes them as a line; only "thrown" and a per-round table are missing.

## 6. Suggested host cities

Theirs (still s20_market_low): when booking, five suggested cities with a success word, takings after travel costs
and fans gained; "Compare all markets" ranks every city. Not for us until promotions; noted for the hosted show only as
"show the expected takings of each hall before booking".

## Method notes
- Bundles: dist/assets/leagueSimulation.worker (rules) and dist/assets/index (screens). Read in Claude's scratchpad.
- Play: tools/hidden_play.py on the hidden desktop, --mute-audio; nothing on the owner's monitors; game stopped by PID.
- Side effect: a second save "Test Promo" (slot 2) now exists in MMA Empire's save list, and the local "First Steps"
  achievement fired in it. The owner can delete slot 2 with its bin button; his own save was never opened.
