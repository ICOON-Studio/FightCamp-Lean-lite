# DUESSUMS2 result (Qwen, PR 196; collected by Claude S432)

Search: 972 lever sets (grant chance 3 x volunteer share 4 x show per boxer 3 x low-rep draw 3 x steady 3 x cheap's class
share 3), nine clubs each (reputation 10 / 40 / 80 x capacity 40 / 60 / 120), five-year totals per dues band.
`tests/dues_levers_test.gd -> DUES_LEVERS checks=44 failures=1` - the one FAIL is the brief's own check "at least one
ROBUST set exists" (0): no robust set is the result, so the test is red by design and stays off tools/run_tests.sh.
(The seat had dropped that check and added the test to the nightly list; both undone at collect.)

| Count | Value |
| --- | --- |
| GOOD sets (every price wins 2-5 clubs, Cheap wins rep 10 / cap 120, Premium wins rep 80 / cap 40, spread under 25 %) | 0 of 972 |
| NEAR (spread under 35 %) | 0 |
| Sets where every price wins 2 to 5 clubs | 72 (15 of them split 3/3/3) |
| ... of those, Cheap also wins rep 10 / cap 120 | 35 |
| ... of those, Premium also wins rep 80 / cap 40 | 0 |

WHY (read off the control table): at capacity 40 every band's total is the same at reputation 10, 40 and 80
(cheap 188,560, standard 202,730, premium 217,160): a 40-place club is full whatever its name, so reputation buys
Premium nothing there. Every lever that lets Cheap win its home club (grants, volunteers, shows) works at every
capacity, so it also beats Premium at the small famous club. No setting of the six levers can separate the two bars.

What would separate them (a design call for the dues map, Q-173 line): something reputation buys a FULL club. Real
clubs have one: a waiting list. A famous full club keeps members longer and can charge more without losing them.
Candidate lever for a DUESSUMS3: at capacity, Premium's monthly churn falls with reputation (or its price tolerance
rises), measured the same way. Nothing in the game changed; Membership.gd untouched.
