# C76 — BJJ contest length

Added `ContestLength.gd`, a pure zero-preload table for `bjj` / `brazilian_jiu_jitsu`. Adult white/blue/purple/brown/black resolve to 300/360/420/480/600 seconds; Juvenile I/II, Master 1, and Master 2–7 follow G41. Other disciplines return their ruleset duration unchanged. Unknown grade, missing age, and the omitted under-16 kids table return `-1` (`UNKNOWN_SECONDS`) rather than guessing.

**AUTHORED mixed-grade rule:** resolve both competitors' published cells and use the duration only when they agree. If the cells differ, return unknown; neither the higher nor lower belt silently controls the contest.

Anti-inert finding: there is no production caller to wire. `FightRealtime` receives duration through `options`, but every direct load of it is in tests; the production fight screen still calls `FightSimulation.advance_exchange`. `Sanctioning` stamps only a ruleset ID and has no competitor grade/age inputs. A caller requires a production contest-terms builder, before simulation start, that owns both competitors plus the selected ruleset and passes `ContestLength.contest_seconds(...)` as `options.round_seconds`.

Data note: the BJJ ruleset now labels its existing 600 seconds as the IBJJF adult black-belt figure, not a universal duration.

Gates: `CHECK total=2 fails=0`; `contest_length` `SUITE total=1 fails=0`; `judge_panel` `SUITE total=1 fails=0`; `grade` `SUITE total=3 fails=0`.
