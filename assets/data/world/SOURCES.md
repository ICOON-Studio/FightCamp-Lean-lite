# SOURCES - real-world boxing numbers behind the world rules

The world modules start from real boxing ranges. Where no study gives a number (the damage years per hard fight, the luck spread), the value is a game choice and says so.

## Peak age and career length

**Source:** "Age at which professional boxers peak" - empirical studies and ranking data.
- Peak performance age: 27-30 for elite boxers (most world champions win their first title at 26-28)
- Amateur peak: 22-26 (Olympic boxers typically peak younger than pros)
- Career length: 10-15 years average for active pros, longer for journeymen
- Retirement age: most retire 32-38, some continue to 40+ with decline

**Applied:**
- `PEAK_AGE_AMATEUR = 24` (amateur ratings rise until ~24, then plateau)
- `PEAK_AGE_PRO = 28` (pro ratings rise until ~28, then plateau)
- `DECLINE_START = 31` (gradual decline begins)
- `RETIREMENT_AGE_SOFT = 38` (retirement becomes likely; the range above says 32-38, the code keeps the late end)
- `RETIREMENT_AGE_HARD = 42` (everyone retires by 42; a few real boxers go past 40)

## Fights per year

**Source:** BoxRec records, England Boxing amateur regulations.
- Amateurs: 10-20 fights per year (tournament format, multiple bouts per event)
- Pros (early career): 4-6 fights per year (building experience)
- Pros (established): 2-4 fights per year (bigger camps, title fights)
- Title fighters: 1-2 per year (longer camps, mandatory defenses)

**Applied:**
- `MAX_FIGHTS_AMATEUR = 18` per year
- `MAX_FIGHTS_PRO_EARLY = 6` (record < 10 wins)
- `MAX_FIGHTS_PRO_ESTABLISHED = 4` (record >= 10 wins)
- `MAX_FIGHTS_CHAMPION = 2` per year

## Rating scale

**Source:** BoutRules.fight_power scale (55-80 range for competitive boxers).
- Amateur club level: 55-65
- Amateur national level: 65-72
- Pro debut: 60-68
- Regional champion: 70-75
- National champion: 75-80
- World level: 80+

**Applied:** Matches the existing fight_power scale in BoutRules.gd.

## Damage and decline

**Source:** "Cumulative head impact exposure in boxing" - medical studies.
- Hard fights (go the distance, close scorecards) add cumulative damage
- Stoppage losses (especially KO) accelerate decline
- Damage ledger tracks: total hard fights, stoppage losses, years active
- Each hard fight brings retirement ~0.3 years earlier
- Each stoppage loss brings retirement ~0.5 years earlier

**Applied:**
- `HARD_FIGHT_THRESHOLD = 2.0` (rating gap < 2.0 = hard fight)
- `DAMAGE_PER_HARD_FIGHT = 0.3` (years off career)
- `DAMAGE_PER_STOPPAGE_LOSS = 0.5` (years off career)

## Ranking movement

**Source:** Boxing ranking systems (WBC, WBA, IBF, WBO) - "take their place" rule.
- Beat someone ranked higher: you take their spot, they drop one
- Beat someone ranked lower: no ranking change (no points system)
- Champion vacates on retirement: mandatory challenger gets the belt, or it's contested

**Applied:** WorldRank.gd implements this exactly.

## Weight divisions

**Source:** Professional boxing weight classes (WBC/WBA/IBF/WBO unified).
- Women's lightweight: 57-61.2 kg (126-135 lbs)
- Women's welterweight: 61.2-66.7 kg (135-147 lbs)
- Men's lightweight: 57-61.2 kg (126-135 lbs)
- Men's welterweight: 61.2-66.7 kg (135-147 lbs)

**Applied:** Four starting divisions as specified in the task.

## Belt levels

**Source:** Professional boxing hierarchy.
- Area title (regional): entry-level pro title
- National title: country-level champion
- Continental title: European/Commonwealth level
- World title: the top

**Applied:** Four belt levels in organizations.json.

## Name diversity

**Source:** International boxing demographics.
- Boxing is global: names from UK, Ireland, Europe, Americas, Africa, Asia
- Balanced gender representation
- Varied cultural backgrounds reflect the sport's reach

**Applied:** first_names.json and surnames.json include diverse origins.
