# COACHHIRE1 - is hiring a second / better coach a real choice? (S538, board row PROGBUILD1)

## Verdict: FAIL. Hiring is not a choice today; it is a way to close the gym sooner.

The probe's own four bars print PASS. That PASS is an artifact and is overruled here, with the reason in "Why the printed
PASS is wrong". Nothing under scripts/ was changed. Nothing was wired, nothing was deleted.

## What was measured
`tools/coachhire1_probe.gd`: the game's own loop (Sim.step_day, Bouts), one walk-in boxer per career, every boxer different
(stats +-4, potential 78-90, six styles, coachability 30-80), the same 60 boxers in every arm (paired), 104 weeks, seed 5381.
The hire rule is a local copy in the probe (a second coach works beside the first: each area is taught by the better of the
two, both wages paid, $1,000 signing fee once).

| Arm | What | Wage a week | Where the wage comes from |
|---|---|---|---|
| KEEP | Luke Reid as shipped (pads 74) | $450 | Data.COACHES, CLAUDE.md "first coach $450/week" |
| P58 | control: Reid with pads forced to 58 | $450 | - |
| HALE | Marcus Hale alone (pads 58, conditioning 90) | $1,090 | Data.COACHES |
| ADD1 | Reid + Rosa Mendez from week 1 | $450 + $520 | CoachMarket.NEW_COACHES |
| ADD26 | Reid + Mendez from week 26 | $450 + $520 | CoachMarket.NEW_COACHES |
| TOP1 | Reid + Hale from week 1 | $450 + $1,090 | Data.COACHES |

Cells: small = the "fresh" start (30 members, 3 months of costs); big = the "backed" start (40 members, 6 months, rent x1.5).

The task asked for "hire a pads-75 coach". There is none to hire: the best pads coach in the whole market is the one the
player already starts with (Reid 74; Price 60, Mendez 62, Hale 58). SIGPACE1's "today's coach, pads 58" was Reid's overall
rating, not his pads. So the SIGPACE1 lever (pads 58 -> 75) is already in the game for $450. The P58 arm confirms its size:
the Signature comes 3.5 weeks later with pads 58, nothing else moves.

## Result 1: the game's rule (the gym closes after 8 weeks below $0), 60 careers an arm
Raw output: `Builds/probe_out/coachhire1_game.txt`.

| Cell | Arm | Gym closed | Median closing week | Cash at the end | Signature | Wins | Members |
|---|---|---|---|---|---|---|---|
| small | KEEP | 100% | 64 | -2,619 | 78% | 9.50 | 68.2 |
| small | P58 | 100% | 64 | -2,649 | 68% | 9.40 | 68.1 |
| small | HALE | 100% | 28 | -5,963 | 0% | 4.00 | 68.0 |
| small | ADD1 | 100% | 32 | -5,913 | 0% | 4.60 | 69.0 |
| small | ADD26 | 100% | 48 | -5,627 | 38% | 6.43 | 68.2 |
| small | TOP1 | 100% | 24 | -10,740 | 0% | 3.02 | 65.9 |
| big | KEEP | 100% | 84 | -4,056 | 92% | 13.13 | 67.7 |
| big | P58 | 100% | 84 | -4,136 | 87% | 13.02 | 67.7 |
| big | HALE | 100% | 44 | -7,072 | 23% | 5.95 | 67.5 |
| big | ADD1 | 100% | 48 | -6,328 | 45% | 6.65 | 68.5 |
| big | ADD26 | 100% | 60 | -6,862 | 72% | 9.10 | 70.7 |
| big | TOP1 | 100% | 36 | -11,017 | 3% | 4.82 | 66.5 |

Paired, against KEEP (mean +- standard error): ADD1 costs 4.9 +- 0.13 wins (small) and 6.5 +- 0.11 (big); the Signature
share falls 78 and 47 points; cash falls $3,294 +- 116 and $2,271 +- 140. Every hire arm loses on cash, wins and Signature
in both cells. The hire does not make the boxer worse: it closes the gym 24 to 40 weeks sooner, so there are fewer weeks.

## Result 2: the same careers with the closing rule switched off (diagnostic: what the wage buys, money aside)
Raw rows: `Builds/probe_out/coachhire1_open.txt`. That run was stopped before its last 4 careers, so the big cell is 56
complete careers (not 60) and its tables were computed from the saved rows, not printed by the probe. Not re-run.

| Cell | Arm | Cash at week 104 | Signature | Median Signature week | Wins | Members | Technique |
|---|---|---|---|---|---|---|---|
| small | KEEP | -22,937 | 100% | 52 | 17.00 | 68.6 | 85.9 |
| small | P58 | -23,013 | 100% | 55.5 | 16.93 | 68.6 | 85.0 |
| small | HALE | -89,503 | 100% | 55 | 17.02 | 68.6 | 85.0 |
| small | ADD1 | -78,007 | 100% | 52 | 17.07 | 68.6 | 85.9 |
| small | ADD26 | -65,009 | 100% | 52 | 17.05 | 68.6 | 86.0 |
| small | TOP1 | -137,262 | 100% | 52 | 17.08 | 68.6 | 85.9 |
| big (56) | KEEP | -21,951 | 100% | 52 | 16.86 | 67.4 | 85.7 |
| big (56) | ADD1 | -76,987 | 100% | 51 | 16.95 | 67.4 | 85.7 |
| big (56) | ADD26 | -64,028 | 100% | 51.5 | 16.88 | 67.4 | 85.8 |
| big (56) | TOP1 | -136,231 | 100% | 52.5 | 16.93 | 67.4 | 85.6 |

Paired, ADD1 minus KEEP: cash -$55,070 +- 7; wins +0.07 +- 0.04 (inside the error); members 0.00 in every career;
Signature 0.7 weeks sooner. Two years of a second coach, $55,000, buy two thirds of a week on one move and nothing else.

## Why the printed PASS is wrong
The bars were fixed before the run and three of them passed on one number: members.
- B1 "the wage buys something" and B3 "no arm is best on everything" pass only because ADD1 / ADD26 end with 0.8 to 3.0
  more members than KEEP. Members were read on the day each gym closed, which is week 32-60 for the hire arms and week
  64-84 for KEEP: different weeks, not a like-for-like read. On the open ruler, where every career is read at week 104,
  the member difference is exactly 0 in all 116 careers. The bar should have required equal end weeks; that is my bar's
  fault, not a finding.
- B4 "timing matters" passes, but only one way: later is always better because the wage runs for fewer weeks. There is
  no week at which hiring pays, so there is no timing to judge.
- B2 "cash gap larger than its error" passes honestly: the hire costs $2,300-3,300 before the gym closes.
Read like for like, KEEP is best or level on every measure in both cells. One answer = not a choice.

## Two things the probe showed that are not about hiring
1. With this bot (one boxer, every legal bout accepted, no hosted nights, no extra class income) EVERY gym closes, also
   on KEEP: median week 64 small, week 84 big. That is a probe bot, not a player, but it agrees with the GYMSURVIVE work:
   the club has no spare $520 a week, so any standing wage is judged against survival, not against what it teaches.
2. The Signature is no longer out of reach: 78% (small) and 92% (big) of KEEP careers reach it before the gym closes,
   median week 52. SIGPACE1's "0 of 60" was measured with pads 58.

## Limits
One boxer per career. A second coach could matter when coaching time is short (three or four boxers sharing one coach's
evenings): that is DEPTH_SCOPE_S534 change 3, "the coach's hands as the club's currency", and it would be designed from
the code after LOYAL1, with its own probe. This probe does not test it and does not rule it out. Amateur only (pro offers
declined). No critic was queued and no design map was written, as the task says for a FAIL.

## Next step for Claude (not done here)
Delete the unwired hire modules, per owner S534 FREE HAND (a mechanic that cannot reach 8 is removed, then reported):
- `scripts/rules/CoachMarket.gd` + `tests/coach_market_test.gd`
- `scripts/rules/CoachFit.gd` + `tests/coach_fit_test.gd`, `tests/coach_fit_sheet_test.gd`
- their only other users, old probes: `tools/coachfit_probe2.gd`, `tools/coachfit_probe3.gd`, `tools/fit_probe.gd`,
  `tools/fit_probe2.gd`, and `tools/coachhire1_probe.gd` itself (it preloads CoachMarket for Mendez's row).
No game script calls either module (checked with a search of scripts/). Before deleting CoachFit, decide whether its
COACH_TIME table is wanted as the starting point of change 3; if so, keep that table in the change 3 map and delete the rest.
