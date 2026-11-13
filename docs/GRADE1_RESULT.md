# GRADE1 Result

Centred PLUS table for LineGrade: the grade multipliers on a positive edge, chosen so the average boxer's plan is
worth neither more nor less than the ungraded baseline, while Good vs Poor on a line is worth 2+ wins in 100.

## Probe arms

```
GRADE_PROBE grade distribution over roster:
  good=16 ok=84 poor=0 total=100 (shares 0.160 / 0.840 / 0.000)
  value-weighted: total_value=377.6 base_total=415.0

ARM A wired=false good=1.00 ok=1.00 poor=1.00 mean_mult=1.000 right_plan_GOOD=384/540 win_share=0.509
ARM B wired=true good=1.20 ok=0.85 poor=0.35 mean_mult=0.910 right_plan_GOOD=161/540 win_share=0.461
ARM C wired=true good=1.20 ok=1.00 poor=0.80 mean_mult=1.034 right_plan_GOOD=384/540 win_share=0.509
ARM D wired=true good=1.30 ok=1.00 poor=0.70 mean_mult=1.051 right_plan_GOOD=384/540 win_share=0.509
ARM E wired=true good=1.40 ok=1.00 poor=0.60 mean_mult=1.068 right_plan_GOOD=384/540 win_share=0.509
ARM F wired=true good=1.15 ok=0.95 poor=0.85 mean_mult=0.984 right_plan_GOOD=329/540 win_share=0.496
ARM G wired=true good=1.20 ok=0.95 poor=0.80 mean_mult=0.993 right_plan_GOOD=329/540 win_share=0.496
ARM H wired=true good=1.15 ok=0.99 poor=0.90 mean_mult=1.017 right_plan_GOOD=375/540 win_share=0.509
ARM I wired=true good=1.20 ok=0.97 poor=0.80 mean_mult=1.009 right_plan_GOOD=355/540 win_share=0.506
```

## GOOD_VS_POOR (arm H)

```
GOOD_VS_POOR move=step_back attrs=(footwork, speed) good_grade=Good poor_grade=Poor
GOOD_VS_POOR wins_good=312 wins_poor=201 gap_per_100=22.2
```

## Chosen table

Arm H: `{Good: 1.15, OK: 0.99, Poor: 0.90}`

- mean_mult 1.017 (within 0.03 of 1.00)
- right_plan_GOOD 375/540 (within 10 of arm A's 384)
- Good vs Poor gap 22.2 per 100 (bar: 2+)

The roster has no Poor grades (all moves grade Good or OK for the five prospects), so the Poor multiplier only
matters for boxers with low attributes. The centred table keeps OK near 1.0 (0.99) so the 84% of moves that grade
OK are worth almost exactly their ungraded value, while Good (1.15) and Poor (0.90) spread enough to make the
difference between a good and a poor boxer show up in the results.
