# S531 probe reads (Claude, read before trusting)

## GYMSURVIVE1 (Goose #414) - does a fresh gym survive two years?
Defect: the page said 30 careers x 2 seeds but ran the PILOT (2 per seed: 4 per arm, 12 in all). Fixed (`ran_n`), full
run on the PC (S531). Pilot reading, to be confirmed by the full run:
- PASSIVE (touch nothing): closes at week 64-68 every time; costs ~$1,450/week vs income ~$1,040.
- SENSIBLE (one class night + take the pro offer) and LEAN (+ half stipend): all survive 104 weeks, cash falling
  ~$3k a year ($13.9k -> $6.5k). A careful gym is slowly bleeding, not closing.
- The second walk-in was never signed in any career (the arm's condition, cash > 3 months of costs, is never true after
  week 1): the probe arm, not the game, but it means SENSIBLE ran with one boxer.

## TURNGAP1 (Goose #415) - the debut gap -> win curve
Defect in the probe: `day_offset = run_seed % 7` with `run_seed = ... + seed_j * 7` - every seed of a boxer landed on the
SAME day, so each boxer fought the same night 10 times (wins in steps of 10/200). The fight does have luck (LiveRound and
BoutNight seed from c.day). Fixed S531 (each seed a different day, 0-9); rerun queued on the PC after GYMSURVIVE1.
RERUN S531 (seed fix, 20 boxers x 10 nights a gap; each boxer's nights now differ): gap -4 35.5%, -2 41%, -1 67%,
0 78.5%, +1 79%, +2 79%, +4 83.5%, +8 96.5%. Monotonic; flat at ~79% from 0 to +2.
- Today's gaps (Bow Lane 1.0, Harrow & Finch 1.5) both give ~79%: the two houses' debuts are the same fight. The 65-80%
  target is gap -1..0. Turning pro v6 sets the gaps from this (a hard house near -1, a soft one near +4).
- CHECK NEXT (possible defect shown to the player): the page's BoutRead says "likely 50%" at gap 0; the 20 boxers win
  78.5%. The opponent IS the booked one (Roster.gd ~line 305: Boxer-puncher, Heavy right hand, Fades after round 3 -
  an earlier S531 note calling it invented was wrong). The fair caveats: the read is taken at signing, BEFORE the 4-6
  week camp the fight gets; the probe passes coach 0; it is one boxer, not the 20. v6's probe: per boxer, the read the
  offer shows (with its coach) vs that boxer's own nights. If it stays ~25 points low, the offer's "likely" must count
  the camp ahead (or say "before camp") - Dola's v5 ask "show ~72% beside each house" depends on it.
