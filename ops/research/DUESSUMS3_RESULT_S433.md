# DUESSUMS3 Result (S433)

## Cap-40 control rows (old and new)

rep 10: cheap=188560 std=202730 prem=217160 winner=premium
rep 40: cheap=188560 std=202730 prem=217160 winner=premium
rep 80: cheap=188560 std=202730 prem=238791 winner=premium

Rows at rep 10 and 40 are identical. Only rep 80 differs - the fee gate is reputation 60.

## WAITLIST rows (low_draw=0.65, cap 40)

rep 10: total=209130 kept=0 fee_extra=0
rep 40: total=217160 kept=0 fee_extra=0
rep 80: total=238791 kept=0 fee_extra=21632

Keep never acts - settle_week walks the count toward a target with no random churn, so a full club loses nobody. Fee extra is above 0 only at rep 80 (fee gate reputation 60).

## INERT axes

strength: pairs=5832 differing=0. All other levers differ in all pairs.
INERT axes: strength

## Counts

GOOD: 165 | NEAR: 213 | ROBUST: 2 | ROBUST (inert excluded): 0

## GOOD split for strength and uplift

strength: 0.0=55, 0.25=55, 0.50=55 (even - the inert lever)
uplift: 0.0=0, 0.1=45, 0.2=120 (premium needs the fee uplift)

## PICK

good_neighbors=4 of 10, wl_str=0.00, uplift=0.20, chance=0.20, vol=0.05, per_boxer=2000, low_draw=0.65, steady=1.05, cheap_share=1.00, wins: c=3 s=3 p=3

No ROBUST set when inert axes excluded. PICK is best GOOD by inert-excluded neighbor count.

## Collected S437 (Claude)
PR 216 taken by diff (the four owned files; main had not touched them since the base). Re-run on main: the same lines,
`DUES_LEVERS checks=53 failures=1`. The one failure IS the result, as the brief said it could be: once the lever that
does nothing (the waiting list's strength) is left out, no dues setting is ROBUST. The waiting list keeps nobody
because Membership.settle_week walks the count toward a target with no random loss: a full club never loses a member.
This test is measure-only and not in the daily list; nothing here is wired into the game. Next dues step is a design
call, not a fourth search: either members can leave a full club (then the waiting list means something) or the waiting
list goes.
