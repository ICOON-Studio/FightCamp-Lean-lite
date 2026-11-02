# Ludo S281 - the three open economy numbers (undercard rate, income yield, staff pay tier effects)

Asked by Claude S281 in Ask Ludo chat "Gym Management Screen" (the FightCamp chat), 2026-10-21. Reply 12,337 chars, one message,
complete. Transcribed from the page in slices (the extension filter blocks raw '&' / '=' runs, so those read " and " / " = "; LaTeX
kept as Ludo wrote it). Everything below is Ludo's content; Claude's verdict is the last section.

## 1. Short-notice undercard save after month 1
- Base 15% roll per active calendar week (~0.65 offers/month), hard cap max 1 ACCEPTED save per 28-day rolling window.
- Weekly chance = min(0.40, 0.15 + R_gym x 0.002 + N_pro_boxers x 0.03) (R_gym = reputation 0-100, N = active pro fighters).
- Reason: "a desperate promoter's distress flare, not a repeatable business model - ~1 per month protects the core matchmaker loop
  from devolving into an on-demand cash ATM."
- Balance: the 28-day cooldown stops players parking a fighter in semi-conditioned limbo to farm emergency purses. At reputation 40+
  the purse scales to $4,500-$7,500 but the opponent is a dangerous 8-0 prospect (the "bait" trade-off).
- Availability filter: the roll fires only if the gym has at least one active pro not booked within 14 days with acute fatigue < 60.

## 2. Early income yields - what sets the pay inside each range
Yield = min + t x (max - min), t in [0, 1]:
| Channel | Range | t |
|---|---|---|
| Morning pad sessions | $120-$220 / day | 0.60 x coach pad skill/100 + 0.40 x gym cleanliness/100 |
| White-collar bag circuit | $300-$450 / week | 0.50 x bag line average condition/100 + 0.50 x reputation/100 |
| Travelling sparring hire | $350-$600 / bout | 0.40 x min(1, rounds logged/50) + 0.30 x win rate + 0.30 x (guard + head movement)/200 |
| Short-notice save purse | $1,500-$2,800 | 0.50 x reputation/100 + 0.50 x clamp((boxer OVR - 40)/30, 0, 1) |
Balance notes (Ludo): a lone owner with 30 pad skill in a dusty basement earns the $120 floor; a 75-skill pad specialist + mats ->
$195-$210. Bag line below 40 condition collapses the circuit toward $300 and triggers bad word of mouth. A raw low-defence prospect
earns $350 sparring hire and comes back concussed; a 75-guard journeyman with 40 rounds earns $540-$600. Month 1: reputation 10 +
45 OVR novice -> about $1,650-$1,750 undercard purse.

## 3. Staff pay tier policy - one gym-wide dial on the office ledger
| Tier | Wage | Morale drift / week | Skill growth | Coaching gain mult (boxer training) | Poach risk / week | Quits at morale |
|---|---|---|---|---|---|---|
| Underpaid | -15% | -4.0 | 0.60x | 0.90x | 8.0% (when morale < 40) | < 20 (1 week notice) |
| Market | 0% | +0.5 toward 65 (-0.5 if above) | 1.00x | 1.00x (1.15x on specialty, per S266) | 1.5% (only specialty skill > 75) | < 10 |
| Competitive | +10% | +2.5, settles at 85 | 1.25x | 1.08x (1.24x specialty) | 0% | never |
| Elite | +25% | +5.0, settles at 100 | 1.60x | 1.15x (1.32x specialty) | 0% | never |
Coachless self-directed floor stays 0.40x. Reason: "pay under market to survive a cash crunch, or above market to turn your staff
into high-efficiency training multipliers."
Ludo's GDScript constants (verbatim names): UNDERCARD_SAVE_COOLDOWN_DAYS 28, UNDERCARD_SAVE_BASE_CHANCE_WEEKLY 0.15,
UNDERCARD_SAVE_MAX_CHANCE_WEEKLY 0.40, UNDERCARD_SAVE_REP_WEIGHT 0.002, UNDERCARD_SAVE_ROSTER_WEIGHT 0.03, purse 1500-2800,
WAGE_TIER_DATA {wage_mod, morale_drift_weekly, skill_growth_mult, coaching_gain_mult, poach_risk_weekly, quit_morale_threshold} as above.

## Claude's verdict (S281) - for the operator's approval
Take all three as Ludo gave them, with three fits to what the game has today:
1. Undercard: Ludo's formula and 28-day cap after month 1; month 1 keeps the approved "max 1". The $4,500-$7,500 reputation-40 bait
   tier waits (no reputation tiers wired yet).
2. Yields: Ludo's four t formulas. "Gym cleanliness" has no meter in the game today -> pads use 0.60 x pad skill + 0.40 x reputation
   until a cleanliness meter exists (stated, not hidden). The banner stays a flat $800.
3. Pay tiers: wage + coaching gain mult + morale drift + quit threshold now (the game has staff morale and coaching gains); skill
   growth mult and poach risk wait until staff skill growth / rival poaching exist (they do not today).
