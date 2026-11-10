# Dues - design map (S423)

His question on the dues proposal (Q-S294-173): "so what the player decides exactly and where does that happening ? which
screens ? have you mapped the whole design for the mechanism ?". This is that map. Numbers and sources:
ops/research/DUES_CHOICE_S422.md. Picture: docs/mockups/s423/dues_choice.png.

## The fault today
Premium always earns the most and Cheap never wins: the three buttons are one right answer and two wrong ones.

## The decision
**What kind of club you run**: one choice of three, any time, on Club > Money.
- **Cheap $25 a month**: more members, more juniors, more boxers grown at home. Less money.
- **Standard $35**: the middle.
- **Premium $45**: more money from fewer adults who come for fitness. Few juniors, so you buy your boxers.
It is the same choice real clubs make: community amateur clubs charge almost nothing on purpose, to bring juniors in, and
premium gyms sell fitness to adults who rarely compete (DUES_CHOICE_S422 sources).

## Where it happens
1. **Club > Money, the DUES card** (picture): three tiles side by side, each with three numbers in colour: money a month,
   members, home-grown boxers in 5 years. The tile in force has the gold frame. A click asks once: "From next month?".
   Words only in the tooltip (his rule today: "tooltips with coloured numbers showing what each item does").
2. **The month's money report** (Club > Money): dues income and members in / out this month, with the band's mark.
3. **The youth section's intake** (the week review, when a junior turns 18): "Came up through the youth section (cheap dues:
   1 trial in 2 passes, standard 1 in 3)", so the player sees the choice pay.
4. **Club > People** shows nothing new.

## What it changes (40 members, youth section open)
| | Cheap $25 | Standard $35 | Premium $45 |
|---|---|---|---|
| Members drawn | +15% (46) | 40 | -15% (34), the gap closes as reputation rises |
| Dues a month | $1,150 | $1,400 | $1,530 |
| A junior (18) asks for a trial and passes, chance each January and September | 0.50 | 0.35 | 0.20 |
| Home-grown boxers in 5 years (expected) | 5.0 | 3.5 | 2.0 |
| What a home-grown boxer saves | half the stipend for a year (about $6,500) and a few points of potential | | |
So Premium wins about $1,560 a year over Standard and costs about one boxer every 3 years; Cheap costs $3,000 a year and
brings about one more boxer every 3 years (S422's sums said 6: they counted one intake a year, the code has two). Each band has a club that wants it. The test that proves it: a 5-year money sim
for each band, with the boxers' value counted, must show no band ahead in every case.

## Changing your mind
A change takes effect from the next month. Members leave over 4 weeks, not at once (monthly churn 3-6% in the industry,
DUES_CHOICE_S422). Raising dues loses some members; lowering them brings some back slowly.

## Build (after his OK)
One Qwen brief: Membership.intake_chance(band) read by HomeJuniors, the 4-week member change, the 5-year sim test; then the
DUES card on Club > Money (Cursor) from dues_choice.png.

## The question
The design as drawn: build it?
