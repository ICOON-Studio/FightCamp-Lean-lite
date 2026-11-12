# R85NEWS1 blind review (S443, 2026-11-12) - PR 239, branch qwen/r85news1

Verdict: **COLLECT WITH FIXES** - the module read the snapshot right (the brief's one trap); the cap, the shortening and a
lookup were wrong, and the test could not catch the cap or a wrong rank. Seat: the brief named the Grok bot; the dispatcher
gave it to Qwen (qwen3-coder). Both files rewritten at collect (module 193 -> 157 lines, test 277 -> 229 lines) and the
real-world block the brief reserved for Claude is added.

Read: ops/research/TASK_R85NEWS1.md, `gh pr diff 239`, and the code it reads: scripts/world/WorldSim.gd 219-281
(year_end, _fill_vacant_belts, _generate_arrivals), scripts/world/WorldAge.gd 23-34 (tick_year: retirees stay in the list
with retired true), scripts/world/WorldGen.gd 20, 50, 157-168 (RANKED_PER_DIVISION 20; boxer keys), assets/data/world/
divisions.json (8 divisions, `weight_class` lower case), scripts/state/ProLadder.gd 127 (the result thrown away).

## a. Brief items (as delivered)
| Item | Status | Where (delivered WorldNews.gd) |
|---|---|---|
| 1 snapshot | DONE | :10-30 |
| 2 level_of | DONE | :33-37 |
| 3 crowned / retired_champ / retired_ranked lines from `before` | DONE (the one trap avoided) | :81-119 |
| 3 retired_more | WRONG (words) | :134 "1 more boxers retired" for one |
| 3 arrived | DONE | :138-159 |
| 3 ORDER + MAX_OTHER 6 | WRONG | :62-75: every crowned and champion line of the other divisions was kept with NO cap, so a busy year gave more than 6 |
| 3 under 110, shorten to the weight class | WRONG | :91, 112, 117, 135: dropped the division entirely instead of using its weight class |
| division lookup | WRONG (edge) | :163: a crowned or retired boxer missing from `before` (a ranked arrival crowned in the same year_end: arrivals are ranked by refresh_ranks before _fill_vacant_belts) lost the line silently |
| 4 marks / 5 mark_of | DONE | :169-192 |

| Required assert | Status (delivered test) |
|---|---|
| snapshot every non-retired, rank + belt as they were, nothing retired | half: "nothing retired" MISSING |
| crowned line | DONE |
| retired_champ "national" though the belt is now "" | DONE |
| retired ranked 3 | WRONG: the retiree was ranked 5; the check `find("3")` passed on the age "35" |
| two unranked -> one retired_more with 2 | WEAK (`find("2")`) |
| three arrivals -> highest rated, "(3 new this year)" | DONE |
| follow first; 10 other lines -> 6 kept incl. crowned + champions | half: the cap was never tested |
| under 110, no pronoun (whole words) | DONE |
| marks | DONE |
| lines() changes nothing (deep) | DONE |
| empty result -> [] | DONE |

## c. Mutants
On the DELIVERED source with the delivered test: no MAX_OTHER cap - **NOT caught**; the ranked line printing the wrong rank
- **NOT caught**; arrival naming the first instead of the best - caught.
On the FIXED source with the new test, 7 of 7 caught: the whole delivered module (2 fails: "1 more boxers", no weight-class
fallback), no cap, the belt read from the boxer after year_end (exact lines + the real world's champions), the arrival naming
the first, rank 11+ named (the real world's "more" counts stop adding up), new face one day too long, no weight-class
fallback.

## d. Words
"Mia Chen retires at 34 after 9-2, ranked 3 at Women's Lightweight." / "2 more boxers retired in Women's Lightweight." /
"1 more boxer retired in Men's Middleweight." / "New face in Women's Lightweight: Aisha Okafor, 19, from Newcastle Gym. (3
new this year)" / "Sam Green wins the vacant national title (Men's Middleweight)." / "Dan Brown retires at 34, 22-6, the
national champion of Men's Middleweight." Long names fall back to "(Lightweight)". No pronoun.

## e. Files
Only the two OWNS files. No test deleted.

## Fixes made
scripts/world/WorldNews.gd: other divisions capped at MAX_OTHER with crowned and champion lines first (`(top + rest).slice`);
each line picks the first wording under 110 (full division name, then the capitalised weight class, then without the club),
cut with "..." only as a last resort; "1 more boxer"; `_div_of` reads the snapshot, else the world as it is now; lines within
a division in the brief's kind order (crowned, champion, ranked, more, arrived) with no unstable sort; level_of by rfind;
RANKED_NAMED 10 named.
tests/world_news_test.gd rewritten: the expected lines written out in full and in order (two divisions, 16 boxers, all
different; Mia ranked 3, Eva ranked 5, two unranked, Dan the national champion, Sam crowned, three arrivals), "nothing
retired" in the snapshot, "1 more boxer", the weight-class fallback, a four-division cap case (15 possible other lines -> 6,
all crowned/champion), var_to_str deep compare, and the real block: WorldGen.generate(4242) + ten WorldSim.year_end, each year
every champion and top-10 retiree has its line, the unnamed add up to the "more" counts, every crowned boxer has a line, one
arrival line a division, every line under 110 with no pronoun.

## Test runs (main checkout, through godot_slot --who qwencollect)
- `WORLD_NEWS real world over 10 years: { "retired": 56, "crowned": 21, "arrived": 105 }`, `WORLD_NEWS failures=0`.
- regression: `WORLD_YEARS checks=30 failures=0`, `WORLD_RULES checks=6 failures=0`, `FILE_LIMITS failures=0`
  (WorldNews.gd 157 lines).

## Left for the wiring (Claude, later)
ProLadder.day_events: `var before := WorldNews.snapshot(divs)` before `WS.year_end`, then `Career.add_news` for each line
(follow = the player's divisions) and the marks on the world's boxer cards.
