# KNOWMISREAD2 result - the shared misread on a paired ruler (DEPTH_SCOPE_S534 change 4)

Status: MEASURED, NO VALUE CLEARS THE BAR, NOTHING CHANGED IN THE GAME. Discipline: boxing. S538, 2026-11-22.

## Verdict (one line)
Knowing the truth is worth about 12 to 14% more top-10 boxers at every share tried, but no share meets both bars, and the
share itself moves the result far less than the ruler's own spread: SHARED_MISREAD stays 0.5.

## The ruler
`tools/knowmisread2_probe.gd`: KNOWBOTS6's worlds, pool and loop, but the blind signer and the signer who knows the truth
play the SAME world and the per-world difference is kept. 360 worlds (seeds 7000.., 8000.., 9000.. x 120), 4 signings a
world, 6,113 prospects offered (every 18-22 unranked m_lw prospect, all different). Lever at 0. Interval = 95% percentile
bootstrap over worlds (4,000 resamples, the same resamples for every share).
Control arm: the probe's shown rating at the built share against the game's own (`Pool.shown_centre`): 0 mismatches of 6,113.

Bars, fixed before the run (printed by the probe before any world): worth in 9..14% AND the interval's low end >= 7%.

## The table (top-10 boxers is the measure the bars are on)

| Share | Mean abs(shown - true), no hype (with hype) | Flops blind / knows | Top-10 blind / knows | Worth | 95% interval | Clears? |
|---|---|---|---|---|---|---|
| 0.50 (today) | 1.667 (2.213) | 176 / 84 | 528 / 592 | +12.1% | +5.3 .. +19.6 | NO: low end under 7 |
| 0.65 | 2.127 (2.556) | 328 / 156 | 521 / 592 | +13.6% | +6.6 .. +21.2 | NO: low end under 7 |
| 0.80 | 2.601 (2.956) | 479 / 243 | 518 / 592 | +14.3% | +7.3 .. +21.5 | NO: worth over 14, and no room |

Per seed set (120 worlds each), worth at 0.50 / 0.65 / 0.80: set 7000 +24.0 / +24.0 / +21.1; set 8000 +4.0 / +4.0 / +7.1;
set 9000 +9.1 / +13.4 / +14.7.

Other measures (worth, 95% interval):
- cash: +3.7% (+2.2 .. +5.4) / +3.6% (+2.0 .. +5.2) / +4.3% (+2.7 .. +5.9) - real at every share, and flat.
- bout wins: +1.0% (-0.9 .. +3.0) / +1.0% (-0.9 .. +3.0) / +1.4% (-0.5 .. +3.4) - not told from zero.
- true rating of the boxers picked: +1.8% / +1.9% / +2.1% (all clear of zero).

## What it says
1. The misread is worth something real: at today's 0.5 the whole interval is above zero (+5.3 .. +19.6) and the middle,
   +12.1%, sits inside the 9..14 band. KNOWMISREAD1's +4.4 / +9.2 / +7.9% was the coarse ruler reading low: set 7000 alone
   reads +4.4% on its first 60 worlds and +24.0% on 120.
2. The SHARE is a weak lever. From 0.5 to 0.8 the mean misread grows 56% (1.67 to 2.60) and the blind signer's flops go
   from 176 to 479, yet he loses only 10 top-10 boxers in 528. Worth moves 2.2 points; the interval is 14 points wide.
   The flop count is also not a clean signal at high share: the knowing signer's picks "flop" more too (84 to 243),
   because the count only says the shown rating was 2+ high, whoever picked.
3. The low-end bar cannot be met by any share on this ruler with room. The interval's half-width is about 7 points at
   360 worlds; a +12% worth would need roughly 700 worlds (about 100 minutes of PC) to put its low end at 7, and a share
   that pushes the middle up enough instead (0.8) leaves the 9..14 band at the top.
4. Why the spread stays wide even paired: a world yields 1.5 top-10 boxers of 4 signings, and the two signers pick the
   same prospect in most years, so the difference is a handful of boxers whichever way it is counted.

## What was changed
Nothing in the game. `scripts/rules/Knowledge.gd` and `tests/know_misread_test.gd` are untouched (no bound moved). New
files: the probe and this page.

## What KNOW_STAKES1 v6 should now say
- Keep the shared misread at 0.5 and quote it as "worth about 12% more top-10 boxers (95%: 5 to 20), 4% more cash
  (2 to 5)": proven above zero, inside the band in the middle, not yet proven above 7.
- Do not look for depth in a bigger share: tripling the flops bought 2 points. The stake has to come from what a wrong
  signing COSTS and from more decisions resting on the read, not from a wider error: the opponent's file (KNOWMISREAD1
  Next 3, the $250 scout of row 19 / 36), the stipend and the roster slot a flop holds, and a read the player pays for
  before signing.
- Row 19 goes to critics as "real and sized, weak lever", with this table, not as "fixed".
- Any later change in this area is judged on this ruler (`tools/knowmisread2_probe.gd ... n=120 rows=<file>`; it resumes
  from the rows file), with cash as the second measure: its interval is the tightest (+/- 1.6 points).

## Tests
NOT RUN. The seven regression tests (know_misread, knowledge, know_reads, know_wire, knowledge_keep, knowledge_shared,
golden_path) waited 40 minutes in the Godot queue (six other jobs running, never served) and were stopped. No file they
read was changed by this task (Knowledge.gd and every test are untouched; the only new code is the probe, which parsed
and ran 360 worlds), so they would read what they read before. The probe's own control arm passed: 0 mismatches of 6,113.
