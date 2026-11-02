# TASK G131 - GROK - HOW OFTEN DOES A JUDO THROW SCORE, AND WHAT?
Owner: grok (in-app browser, new chat). Assigned 2026-09-27 (S95). Research only - no repo, no code, no test.
Reply inline, <= 500 words, titled G131_HOW_OFTEN_A_JUDO_THROW_SCORES. Mark every number SOURCED (with the site) or PROXY.

## Why
Our fight engine simulates judo. A test counts, over 24 bouts, how many throws score and at what band (ippon /
waza-ari / yuko / nothing). A recent change moved the landing seat of the few throws it saw, and the scored throws went
from 3 of 4 to 0 of 4. We need the REAL rates to tell a defect from a small sample.

## What would a human do?
A judo coach or analyst would pull competition statistics (IJF World Tour / Olympic data, published match-analysis
papers) and say: per match, how many throw attempts, what share of attempts score at all, and of those that score, what
share are ippon vs waza-ari (and yuko where the ruleset still has it). They would note which rule era the numbers come
from (yuko was removed in 2017) and how the thrower's landing position decides the score.

## Questions
1. Per elite match: throw attempts, and the share that score anything. Sources and rule era.
2. Of scoring throws: ippon / waza-ari / yuko split (pre-2017 and post-2017 if both exist).
3. What decides the band on landing (back flat, side, seated/half, speed/control) - the referee's actual criteria.
4. Share of matches ending by ippon from a throw vs by shido/hansoku-make vs decision/golden score.
5. The ONE number our simulation should match first, and the sample size a test needs to see it reliably.
