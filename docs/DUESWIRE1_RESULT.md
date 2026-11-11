# DUESWIRE1

The dues price now shows on the screens where it lands. Numbers come from `Membership.intake_chance` (cheap 1 in 2, standard about 1 in 3, premium 1 in 5). No dues number was changed.

The needs board sits under the gym picture, below 1080, so the Home row is the first block on Home, above the picture, and only in the two weeks before an intake. With no youth section that row is absent.

## Rects at 1920x1080

Home, the preview week (day 224, standard dues):

| Control | x | y | w | h |
|---|---:|---:|---:|---:|
| JuniorTrial | 28 | 100 | 1864 | 61 |
| JuniorTrialLine | 40 | 117 | 1732 | 27 |
| JuniorDues | 1784 | 108 | 96 | 45 |

Dues boards, no youth section. The number is 0. The hover says "Buy the Youth section on Money, The books." (S434 collect: no screen is called Club spending.)

| Control | x | y | w | h |
|---|---:|---:|---:|---:|
| HomeGrown cheap | 161 | 812 | 18 | 39 |
| HomeGrown standard | 611 | 757 | 18 | 39 |
| HomeGrown premium | 1061 | 812 | 18 | 39 |

Dues boards, youth section open, day 0. Each boxers number carries "next trial: 5 January" (the same words on the hover).

| Control | x | y | w | h |
|---|---:|---:|---:|---:|
| NextTrial cheap | 86 | 822 | 369 | 29 |
| NextTrial standard | 535 | 822 | 370 | 29 |
| NextTrial premium | 985 | 822 | 370 | 29 |

Club > Money, the books, the month cheap takes effect. The line's picture is the cheap board's painting.

| Control | x | y | w | h |
|---|---:|---:|---:|---:|
| DuesLine | 58 | 473 | 347 | 72 |
| DuesMark | 58 | 493 | 32 | 32 |
| DuesMonth | 96 | 497 | 210 | 24 |
| DuesMembers | 96 | 521 | 210 | 24 |

Week review on the intake Monday. The card has the junior's face, "Came up through the youth section", the cheap picture, "1 in 2", and "asks for a trial" or "not this time" (S434 collect: the junior asks; the player still invites them).

| Control | x | y | w | h |
|---|---:|---:|---:|---:|
| YouthIntake | 476 | 214 | 940 | 104 |
| JuniorFace | 490 | 224 | 84 | 84 |
| IntakeMark | 588 | 257 | 40 | 40 |
| IntakeChance | 638 | 260 | 59 | 34 |
| IntakeResult | 707 | 263 | 122 | 27 |

None of these rects overlap their neighbours or leave the 1920x1080 screen.

## Runs

Red, before the screens were wired:

```
DUES_WIRE failures=17
```

Green:

```
DUES_WIRE failures=0
```

RESULT: tests/dues_wire_test.gd -> DUES_WIRE failures=0

## S434 collect (Claude, after a blind review + verifier)

- News: a pass reads "Came up through the youth section: <name> asks for a trial (Fighters > Find a fighter)" (the PR said
  "is on trial", which was false); a miss names the junior: "<first> from the juniors: not this time."
- The card shows the dues and the odds the roll used (stamped on the intake's news line). A January price change starts on
  the same Monday but after the roll; dues_wire_test now changes the price that Monday and checks the card keeps cheap.
- The odds are HomeJuniors.chance (a second club coach adds 0.10), on Home and on the card; the boards stay on intake_chance.
- Home's row counts the real days to the trial; the books say "about +N members" (an estimate at today's reputation);
  the card has no flat border (S427).
- The golden step moved to tests/golden_dues_step.gd and plays the game's own day step (Sim.step_day) to the month's turn and
  to an intake week; it checks the books' "from this month" line on screen. golden_path_test awaits _play() again.
