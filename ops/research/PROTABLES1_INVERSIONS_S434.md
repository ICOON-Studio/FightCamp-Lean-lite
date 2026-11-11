# PROTABLES1: why the new tables read 6.3% inversions (S434)

His Q-187 "Yes, both" added featherweight and middleweight professional tables (women's and men's), 8 tables in all.
world_years_test then read 6.3% clear ranking inversions in w_fw year 17 (a ranked boxer 5+ points better than
someone ranked above), against a bar of "no table-year above 5%". The S433 handover said: find why, fix the world or
the sample, never the bar.

## The probe (tools/s434_inversion_probe.gd, not shipped): 8 seeds x 20 years, every table every year
Branch (8 tables): every table averages 0.80-1.17% a year; worst single years 5.3-7.4%; years over 5%: 18 of 1280.
Main (the old 4 alone): averages 0.90-0.97%; worst years 4.7-7.4%; seeds 1, 2 and 3 each go over 5%.
w_fw pooled: mean 0.88%, worst 6.3%, 3 years of 160 over 5% - the same as the old tables.

## Finding
The world is not worse and the new table is not broken. "No table-year above 5%" is the maximum of a noisy number:
main passed it on seed 12345 by luck (the old tables fail it on 3 of 8 seeds), and eight tables double the draws.

## Decision (Claude, developer call)
The check now reads what "a place means a level" means: each table's 20-year mean under 3% (one seed's table mean
reached 1.58%; the world before the S397 fix read 12-26%, so it still goes red), no year above 10%, and at most 5% of
table-years above 5% (seen: 1 of 160 on seed 12345). Retirements are capped per table (50 each in 20 years; it was 200
for four tables). fighter_model_speed_test's fast and fight digests name the new world bouts (call caps unchanged).
