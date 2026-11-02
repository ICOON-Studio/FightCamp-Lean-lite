# C47 digest

- **Decision:** house promotions use discretionary challenger selection by default; no catalogue promotion has a sourced #1 mandatory rule in this pass. GLORY alone supplies a published four-month champion-defense clock, with discretionary vacancy/interim power.
- **Ranking:** store `ranking_mode` (`discretionary`, `published_criteria`, `mixed`) and never reverse-engineer coefficients. UFC Meta weights remain UNKNOWN; PFL/ONE use published panel methods; IBJJF/UWW/IJF/WT publish criteria; most smaller promotions remain UNKNOWN.
- **Game today:** `WorldPopulation` sorts division and P4P boards by gameplay `_leaderboard_points`; `GameState` exposes those boards and stamped bout stakes but has no organization ranking mode or mandatory-challenger policy.
- **Interim:** `championship_rules.json` sets an explicitly authored eight-week availability window. The interim lives on the same belt entry and is consumed when the champion next fights for it. No parse gate or tests were run.
