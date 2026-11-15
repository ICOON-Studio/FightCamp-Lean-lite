# TASK FILMSEATS1 - film seats in a fight week: who watches with the coach, who watches alone (pure module + test)

Status: OPEN (S485, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
Club week v1 build plan (ops/research/CLUBWEEK1_BUILD_S485.md, item 4): with pads never short (owner's Q-242), the only
clash left when several boxers fight the same week is the film session. CLUBWEEK1 v9 map 3.4: "Film session: one coach
evening of tape and plan... Owned: You 2 a week, plus 1 with a full-time coach. Over the count, the boxer watches alone:
the session opens no tell." This module is that rule; Claude wires it to the bout page and the fight week. Pure rules only.

## What to build: scripts/rules/FilmSeats.gd (extends RefCounted; pure static; NO preload, NO class_name)
Constants:
- YOU_SEATS := 2
- FULL_TIME_EXTRA := 1
- COACHED := "coached", ALONE := "alone"

Functions:
1. `owned(coach_kind: String) -> int` - YOU_SEATS, + FULL_TIME_EXTRA when coach_kind == "full_time" (sessional/none/other: 2).
2. `deal(boxers: Array, coach_kind: String) -> Array` - boxers = [{"id": String, "fight_day": int}], any order. Sort a COPY
   by fight_day ascending (the nearest fight watches first); a tie keeps the input order (stable: sort by [fight_day, input
   index]). The first owned(coach_kind) get COACHED, the rest ALONE. Return [{"id", "fight_day", "seat"}] in that sorted
   order. Empty input -> [].
3. `alone_count(dealt: Array) -> int` - how many have seat ALONE.
4. `opens_tell(seat: String) -> bool` - true only for COACHED.
5. `line(dealt: Array, coach_kind: String) -> String` - "" when alone_count == 0; else
   "Film: %d boxers, %d seats - %s" with the boxer count, owned(coach_kind), and "one watches alone" when alone_count is 1,
   else "%d watch alone" % alone_count. Example: "Film: 3 boxers, 2 seats - one watches alone".
6. `seat_of(dealt: Array, id: String) -> String` - that boxer's seat, "" when not in the list.
Comment block at the top in the house style: what it is, the map quote above, the build plan path, one usage line per
function.

## Test: tests/film_seats_test.gd (extends SceneTree; preload the module by path; prints "ok   <what>" / "FAIL <what>",
ends with one line `FILM_SEATS PASS fails=0` or `FILM_SEATS FAIL fails=<n>`, quit(0) on pass, quit(1) on fail)
Cover at least: owned("sessional") == 2, owned("full_time") == 3, owned("none") == 2; deal([]) == []; three boxers
a(day 20), b(day 13), c(day 16) with "sessional" -> order b, c, a with seats coached, coached, alone; the same with
"full_time" -> all coached and line == ""; a tie b(13), x(13) keeps input order b then x; alone_count of the sessional
case == 1; line of the sessional case == "Film: 3 boxers, 2 seats - one watches alone"; four boxers sessional ->
"Film: 4 boxers, 2 seats - 2 watch alone"; opens_tell("coached") true, opens_tell("alone") false; seat_of(dealt, "a") ==
"alone", seat_of(dealt, "zz") == ""; deal does not reorder the caller's array.

GDSCRIPT TRAPS (both cost the last Arena PR a fix): never `var x := <an Array element>` (untyped Variant -> parse error:
write `var x: int = int(arr[i])`); Array has no join() - use `", ".join(PackedStringArray(list))`.

## Pass lines
RESULT: tests/film_seats_test.gd -> FILM_SEATS PASS fails=0
(Arena's runner has no Godot: write the code and test exactly to this brief; Claude runs the test on the PC.)

## Contract
OWNS: scripts/rules/FilmSeats.gd, tests/film_seats_test.gd
RED_TEST: tests/film_seats_test.gd -> FILM_SEATS PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/film_seats_test.gd (nothing else calls it yet; Claude wires the bout page after)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/film_seats_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge.

## Prior research
CLUBWEEK1 v9 map 3.4 (film owned 2 + 1 full-time; over the count no tell); FilmEdge.gd / FilmTruth.gd (what film opens
today); CLUBWEEK1_V9_CHECKS_S483.md CHECK 6 (the collision line cut to film only).

## What would a human do?
A club coach with three boxers fighting the same weekend sits down with the two whose fights come first; the third gets
the tape to watch at home.

## Prefab check
None needed: a sort and a count.
