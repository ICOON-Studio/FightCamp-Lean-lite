# S277 START ECONOMY - Claude's numbers vs Ludo's, and the verdict

Operator S277: "askludo and compare your numbers with it". Mine were written first: CLAUDE_START_ECONOMY_S277.md. Ludo's reply
verbatim: ludo_rx/LUDO_S277_BLANKSTART_raw.txt (30,609 chars, one message, complete; chat "Gym Management Screen" with the shell
still attached). Sources behind mine: TWOPOINT_ECONOMY_S277.md, MGT2_STUDY_S277.md, S277_GYM_EMPIRE_BENCHMARK.md.

## Side by side
| Topic | Claude | Ludo | Verdict |
|---|---|---|---|
| Start cash | 25,000 | 25,000 | 25,000 (agree) |
| Day-1 build | ~10,000 (40%) | 12,470 (50%) + 4,800 "buffer" + 1,000 permit | Ludo's build list (~50%); NO forced buffer or permit fee - a charge with no play is a chore |
| Ring on day 1 | no - rent ring time 150/session | no - a TAPED FLOOR RING 1,200 (ring IQ x0.75, slip risk x1.15); pro ring 18,000 = mid-game goal | Ludo (gives him something to build on day 1) |
| Early bouts | at venues | away bouts at civic halls; home shows need the pro ring (month 4-6) | Ludo |
| Room price | flat 1,250 + key item + 25/m2 | permit by type (300-2,500) + floor by type (15-80/m2) + key item | Ludo's per-type table (it is TPM + MGT2 combined) |
| Key items | desk 900, PC 1,200, locker 400, bed 1,800 | desk 800, PC 750, locker 620, table 1,400, bag 450 | Ludo |
| Refund | 100% same day, 65% used | 100% for 5 days, 70% after | Ludo |
| Open at minute 0 | training floor, reception, office, locker | the same + taped sparring pit | Ludo |
| Unlocks | one per goal | by boxing events (2 boxers -> physio, first pro win -> strength room, 15 members -> cardio, first 8-rounder -> film room...) | Ludo (ties building to the career) |
| First-hour goals | 12 x 1,500 + 2 x 3,500 = 25,000 | 16 goals = 21,500 (86% of start), from "place the front desk" to "close month 1 positive" | Ludo's chain |
| First income | walk-ins 15, fee 40/week, pad gigs 200, undercard 600-1,200 | pad sessions 120-220/day (max 3/wk), evening bag circuit 300-450/wk, sparring hire 350-600, banner sponsor 200/wk, short-notice undercard 1,500-2,800; members 45/month | Ludo (my weekly fee was far too high) |
| Rent | none (TPM and MGT2 have none) | 1,200/month for 2 months, then +350/month + 4.50 per built m2 (month 12 ~5,200) | LUDO - operator S277: "Yes - rent that grows during the year, as Ludo proposed." |
| Member expectations | rating 60% -> 80% over 12 months | gym score 20 -> 75, +4/month; churn = max(2%, (needed - actual)/100) | Ludo |
| Opponents | quality ~ t^2 | his stat average + 2.8 per win +-4; scouts exploit his weak spot | Ludo |
| Wear | upkeep x (1 + uses/200) | condition drops per hour used; <40% = 0.7x training + 3x injury; 0% breaks | Ludo |
| Repairs | a cleaner halves wear | maintenance CONTRACT 20 / 85 / 210 per week, auto-repair overnight, zero clicks | Ludo |
| Staff pay | one slider -25..+25% | four tiers: underpaid -15%, market, competitive +10%, elite +25% | Ludo (four icons read faster) |
| Loans | 25k / 50k / 90k at 1-5% a year | micro 5,000 (275/wk x 20), municipal 15,000 (420/wk x 40), promoter advance 30,000 against 3 purses | Ludo (fits a 25,000 gym) |
| Going broke | -8,750: bank takes the dearest station + income goal | -5,000: a promoter puts in 8,000, takes 50% of the gym's purse share for 3 fights + one station; win 2 in 60 days to get it back | Ludo, minus his "move to a basement venue" on failure (later - a whole relocation feature) |
| Grant while poor | 300/week | none | dropped (his early channels cover it) |

## The one real disagreement: RENT
Ludo makes rent the backbone of the "tightening" (1,200 -> ~5,200 a month over the year, rising with what you build). Two Point and
Mad Games charge no rent; there the squeeze comes from expectations, wages and tougher competition. With rent, the pressure is
readable on one ledger line and grows with every room you draw; without it, the early game is simpler and the squeeze comes only
from members, coach pay and opponents. DECIDED (operator S277, Q-S273-6): "Yes - rent that grows during the year, as Ludo proposed."

## What gets built from this (after his answers)
GYMBUILD B (room drawing) reads the per-type permit + floor + key-item table from data (assets/data/room_types.json); the taped
floor ring joins the catalogue; the 16-goal chain replaces today's first goals; income channels, policies, loans and the bail-out
are each one slice, in that order, each ending with the real-route loop probe and the .exe.
