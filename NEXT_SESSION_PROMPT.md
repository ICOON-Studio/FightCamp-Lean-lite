# S504 handover (written 2026-11-16 at the end of S503)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.
Digest: `ops/research/S503_DIGEST.md`.

## Where the fight stands
- Fight motion week (deal: 5+ from BOTH blind critics or 3D leaves the first release). r10 (S503): coach 5, animator 4.5
  (r9: 4.5 / 5). Feet rose (4 -> 5.5 / 4.5), waiting rose (4 -> 4.5 / 5). Not 5+ from both yet.
- S503 built: steps lift-travel-set (BoxerFootwork CLEAR_S / MIN_LIFT_M, pair turn follows the feet, RingFeet quickest
  pair 0.36 s; `-- oldswing`): planted slide 10.6 / 11.7 -> 0.40 / 0.25 m. GuardLife paw + feint by style
  (`-- nowaitbeats`): longest wait 5.8 -> 2.9 s. Crowd flashes only above both heads.

## NEXT (in order)
1. HIT REACTIONS (both critics' item 1): start on the contact frame, the head's furthest point 2-3 frames later (median
   5 now), jab 8-12 cm, cross 18-25 cm + 15-20 deg turn + 15-25 cm step back, hook 20-30 cm + 30-40 deg, body shot a
   30-50 cm fold rising over 8-12 frames; layered over whatever the hit man is doing (his own punch cut 3 today).
   Ruler: `python tools/fight_motion_rulers.py --compare <before>/shown.csv <after>/shown.csv` on log-only runs
   (`human_fight_film secs=75 seed=7`, no --write-movie), reaction rows. S502 sized the snaps (HitStep / reaction code).
2. Punches on the face (1-2 frames on it) + hand home within 4 frames: collect Qwen PUNCHEND1 first (PR from
   qwen/punchend1; tools/punch_end_probe.gd -- csv=E:/FightCamp/tmp/fightweek/r10blind/shown.csv is the ruler).
3. Head/hip jumps inside clips (31 of 37) capped at 8 cm a frame; no glove-pressing stand-offs inside 1.0 m.
4. Film r11 (`--write-movie`, 1920x1080, sheets `--crop 1120:720:400:190` at ex1 13.6 3 / ex2 18.9 2 / ex3 33.5 2 /
   ex4 37.5 2.5 / ex5 59.9 2.5 / wait 44.0 1 / wait2 50.0 1), rulers_raw + rulers_motion, copy the r10blind briefs
   (sed the folder), two NEW critics.

## The operator's scorecard idea (S503: "add similar score cards at the end of the fight")
Told him yes. Data done: ScoreSheet.build(j, meta) and ScoreSheet.from_rounds(rounds, BoutRules.flip_round(rounds)) -
the sheet always agrees with today's verdict, no judges' switch needed. Next: a 1920x1080 mockup of the Scorecard tab
(our look, header / three judge sheets red | blue / result line, hover = the round's reason), on the board for his
yes, then build the tab on the result page.

## Seats
- Qwen PUNCHEND1: launched 21:40, wt LEAN_PUNCHEND1. Collect by its contract (punch_end_test green, the probe's last
  line on r10blind/shown.csv).
- Ziva COACHNECK2: no branch yet. Guard damage v2 after John's SQ204 + Dola's 6/7.

## Debt
block_absorb, hit_carry, join_return, punch_speed, punch_weight red on main since S496-S501.

## PC
TRAP: every Bash call starts with `cd /e/FightCamp/Lean` (a `cd` into a worktree moved the session folder again in S503).
Build exported 21:00 with WHAT_TO_TRY current.
