# TASK R85NEWS1 - GROK BOT (xAI API) - the world's year end becomes news: who retired, who arrived, who was crowned (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing (the generated world's divisions). Model: grok (the Grok bot seat, xAI API).
Mechanic: R85 "A living world" (critics 9/8 and 8/6, average 7.75, ops/research/MECHANICS_BUILD_STATE_S440.md). The world already ages
every boxer once a year, retires some, brings in new ones and fills empty belts (scripts/world/WorldSim.gd year_end), but the caller
throws the result away (scripts/state/ProLadder.gd line 127), so nobody ever sees a boxer retire or arrive. THIS task turns that result
into news lines and a "new face" / "retired" mark. It only SHOWS what the built world already does: no new world rule.
You have no repo and no shell: everything you need is in this brief. Claude runs your test and wires the module (ProLadder, Career.add_news).

## Contract
OWNS: scripts/world/WorldNews.gd, tests/world_news_test.gd
RED_TEST: tests/world_news_test.gd -> WORLD_NEWS failures=0
REGRESSION: world_years_test, world_rules_test, file_limits_test
VISUAL: no
NOT YOURS: every other file. ZERO preloads in WorldNews.gd (it reads plain Dictionaries only).

## The data you get (exact shapes from the code)
A BOXER is a Dictionary: {id: int, name: "Ama Boateng", first, last, sex: "women"|"men", club: "Hull ABC", region, age: int,
div: "w_lw", rating: float (40-85), w: int, l: int, d: int, ko: int, retired: bool, rank: int (0 = unranked, 1 = top), belt: String
("" or "<org abbr>_<level>", level one of "area", "national", "continental", "world"; the level is the part after the LAST "_")}.
DIVISIONS is a Dictionary {div_id: {info: {id, name: "Women's Lightweight", sex, weight_class, ...}, boxers: [boxer, ...],
belt_orgs: {level: abbr}}}.
The YEAR-END RESULT (what WorldSim.year_end returns): {retired: [boxer, ...], arrived: [boxer, ...], crowned: [{level, name, id}, ...]}.
IMPORTANT: by the time year_end returns, a retired boxer's belt has been cleared and the ranks re-done, so the caller takes a SNAPSHOT
before calling year_end and passes it in. Your module provides that snapshot function.

## The job: scripts/world/WorldNews.gd (pure, static, extends RefCounted, under 220 lines)
1. `snapshot(divisions) -> Dictionary` {id: {name, div, rank, belt, rating, age, club, w, l}} of every boxer not retired.
2. `level_of(belt) -> String`: the part after the last "_" ("" for "").
3. `lines(before, result, divisions, follow := []) -> Array` of {t: String, kind: String, id: int, div: String}, most important first:
   - kind "crowned": every crowned entry: "<name> wins the vacant <level> title (<division name>)."
   - kind "retired_champ": a retiree who held a belt in `before`: "<name> retires at <age>, <w>-<l>, the <level> champion of
     <division name>."
   - kind "retired_ranked": a retiree ranked 1 to 10 in `before`: "<name> retires at <age> after <w>-<l>, ranked <rank> at <division
     name>." Lower-ranked and unranked retirees are not named: ONE line per division with any, "<N> more boxers retired in <division
     name>." (kind "retired_more").
   - kind "arrived": per division with arrivals, ONE line naming the highest-rated arrival: "New face in <division name>: <name>, <age>,
     from <club>." plus " (<N> new this year)" when there are two or more.
   - ORDER: divisions listed in `follow` (the player's divisions) first, each division's lines in the kind order above; then every other
     division's lines, of which at most MAX_OTHER = 6 are kept (crowned and retired champions before the rest).
   - Every line under 110 characters (shorten the division name to its weight class if needed), plain present tense, no pronoun
     ("she", "he", "her", "his", "they" never appear).
4. `marks(result, day) -> Dictionary` {id: {mark: "new face"|"retired", until: day}}: every arrival "new face" until day + 365; every
   retiree "retired" with until = -1 (for ever).
5. `mark_of(marks, id, day) -> String`: "new face" while day < until, "retired" when until is -1, else "".

## The test FIRST: tests/world_news_test.gd (extends SceneTree, prints `WORLD_NEWS failures=N`, quits with N)
RED ON MAIN: the file WorldNews.gd does not exist, so the test's preload fails to load (Claude runs it on main first and records it).
Build everything by hand: TWO divisions ("w_lw" "Women's Lightweight", "m_mw" "Men's Middleweight"), eight boxers each, every boxer
different (names, ages, ratings, records, clubs). Make a `before` with snapshot(), then change the dictionaries the way year_end does
(set retired true, clear the belt, append arrivals) and hand-build the result. Assert at least:
- snapshot holds every non-retired boxer with rank and belt as they were, and nothing retired;
- a crowned entry gives one "crowned" line naming the level and the division;
- a retiree who held "IBF_national" in `before` gives a "retired_champ" line with "national" in it, even though the belt is now "";
- a retiree ranked 3 gives a "retired_ranked" line; two unranked retirees give ONE "retired_more" line with 2 in it;
- three arrivals in one division give ONE "arrived" line naming the highest-rated of the three and "(3 new this year)";
- with follow = ["m_mw"], every m_mw line comes before every w_lw line; with 10 other-division lines possible, only 6 are kept and the
  crowned and champion lines are among them;
- every line is under 110 characters and contains none of the pronouns above (check whole words);
- marks: an arrival reads "new face" on day + 364 and "" on day + 365; a retiree reads "retired" for ever; an unknown id reads "";
- lines() does not change `before`, `result` or `divisions` (compare deep copies before and after);
- an empty result gives an empty Array.
Claude adds, at collect, one block that runs the real WorldGen.generate + WorldSim.year_end and checks every retiree, arrival and
crowned entry produced a line or a count.

## Traps
- GDScript 4: type every Dictionary read (`var age: int = int(b.get("age", 0))`); `:=` on a Variant is an error in this project.
  `%%` for a literal percent in a format string. No `class_name`.
- The one trap: the snapshot. A line that reads the belt or rank from the boxer AFTER year_end is always empty (the belt was cleared).
  Read them from `before`.
- A test that only your own function can pass is not a test: expected words come from the data you built, written in the test.
- Write the reply last: the two files in full, then `RESULT: tests/world_news_test.gd -> WORLD_NEWS failures=0` as you expect it.

## Prior research
`python ops/Tools/prior_research.py world news retire` -> topics/years_retirement.md (the world's ageing and retirement), TASK_K_WORLDNEWS1.md
and K_WORLDNEWS1_KALLI.md (Kalli's news-line tone: a club secretary's newsletter, one fact per line, under 110 characters),
CRITIC_WORLD_S408.md (the critic who asked to see boxers retire and arrive).

## What would a human do?
A boxing newsletter at the turn of the year: who hung up the gloves, who won the vacant belt, which new names to watch. Short, plain,
one fact a line, your own division first.

## Prefab check
None: string building over the world's own dictionaries.

Test command (Claude runs it): `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/world_news_test.gd`.
