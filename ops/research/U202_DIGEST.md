# U202 digest — GF1 part C: finance desk and floor station tooltips

## Shipped
- Finance desk: every `_money_line` hover names ledger `why`, provenance (`source`), and weekly vs bout cadence; cash, week net, runway (weeks-at-this-net copy), THIS MONTH accruals, and purse wallet figures tipped.
- Glossary: `weekly_net`, `runway`, `member_floor_load`; cash aliases include CASH NOW.
- Training floor: `StationRail` lists space used, member load, expand readout, and per-station tiles with training focus and this week’s users.

## Evidence
- `tests/gf1_finance_floor_tips_test.gd` green; `run_tests.py --only office_hub,gym_ledger,ledger_words,training_floor,menu_clarity,gf1_finance` green; stills under `previews/u202/`.

## Notes
- Runway tooltip only narrates `runway_weeks`, `net_weekly`, and `cash` already on the desk — no new maths.
- Expand copy states two columns / wing quote from `get_gym_hub()` floor read only.
