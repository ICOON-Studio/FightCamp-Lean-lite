# TASK APPROACH1 - another club approaches an unhappy fighter: when, what they offer, the talk, the five answers (pure + test)

Status: OPEN (S486, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
R58 "a fighter leaves" is approved (Dola 7/7, map ops/research/R58_MAP_S439.md; read sections 4 M3-M4 and 6). The
loyalty number (scripts/rules/Loyalty.gd) is live in the game since S485. This module decides the APPROACH: when a rival
club (Eastside ABC) comes for a fighter under 35 loyalty, what it offers, the optional talk, and the five answers the
player chooses between, each read on the window's end date 12 weeks on. Claude wires it into the week and the card after.
Pure rules only: the caller passes plain dictionaries ("views"); this module reads no game state.

## What to build: scripts/rules/Approach.gd (extends RefCounted; pure static; NO preload, NO class_name)
Constants (the map's ESTIMATES):
- `UNDER := 35` (approach only under this), `WORTH_POTENTIAL := 80`, `WORTH_RANK := 5`, `GAP_DAYS := 84` (12 weeks
  between approaches to one fighter), `WINDOW_DAYS := 84` (answers read on day + 84), `ANSWER_DAYS := 7`,
  `STIPEND := 250` (a week), `SHOW_COST := 3500`.
- `TALK_BASE := 0.30`, `TALK_PER := 0.60` (chance = 0.30 + 0.60 x coachability / 100), `TALK_LANDED := 0`
  (at an approach a landed talk is worth what it unlocks: HALF EACH at +9; map section 6 "Lands: HALF EACH = Danny 42"),
  `TALK_FAILED := -4`.
- `GAIN := {"match": 12, "half": 4, "half_landed": 9, "move": 12, "promise": 4, "promise_kept": 10}`,
  `HOLDER_MOVE := -8`, `HOLDER_HALF := -4`, `TICK := -3` (each grievance tick of the cause, every 28 days).
- `TRAIN := {"match": 1.0, "half": 0.925, "move": 1.0, "holder_move": 0.85, "holder_half": 0.925}`.
- `CAUSE_OFFER`: a loyalty-log reason -> the offer group. Groups and their offer line:
  `keep` "Full time: Eastside's backers pay the keep" <- "wants_sponsor", "sponsor_pulled", "short", "short_running", "day_job";
  `bout` "A bout on Eastside's show" <- "offer_passed", "no_bout", "target_missed";
  `debut` "Eastside's promoter signs the debut" <- "decline_pro";
  `manager` "A manager at 15%" <- "pro_unhappy".
  Any other reason (or a positive move) counts for no group.

Functions:
1. `due(v: Dictionary) -> bool` - v: {loyalty:int, potential:int, rank:int (0 = unranked), is_pro:bool,
   last_approach_day:int (-1 = never), day:int}. True when loyalty < UNDER AND (potential >= WORTH_POTENTIAL or
   1 <= rank <= WORTH_RANK or is_pro) AND (last_approach_day < 0 or day - last_approach_day >= GAP_DAYS).
2. `offer(log: Array, day: int) -> Dictionary` - log rows are {d:int, n:int, why:String} (Loyalty's loyalty_log). Sum
   the NEGATIVE n per group over rows with day - d < GAP_DAYS; return {group, line, loss} for the largest loss (ties: the
   order keep, bout, debut, manager). No negative row in any group -> {group:"keep", line:<keep line>, loss:0}.
3. `talk_chance(coachability: int) -> float` - TALK_BASE + TALK_PER x clamp(coachability, 0, 100) / 100.
4. `talk(coachability: int, roll: float) -> Dictionary` - landed when roll < talk_chance. Returns {landed:bool,
   delta: TALK_LANDED or TALK_FAILED}.
5. `answers(v: Dictionary) -> Array` - the five answer columns, ALWAYS in the order match, half, move, promise, let_go.
   v: {loyalty:int (after the talk, if any), talk:String ("" / "landed" / "failed"), group:String (from offer),
   holder: Dictionary ({} when no team-mate holds the stipend, else {loyalty:int}), can_book:bool, ticks:int (the
   cause's grievance ticks left in the window if nothing stops them), ticks_after_show:int (those dated after the show
   night), holder_ticks:int (ticks the holder takes in the window if the stipend is moved), day:int}.
   Each column: {id, available:bool, why_not:String, cash:int (negative = paid), loyalty_end:int,
   holder_end:int (-1 when no holder), train:float, holder_train:float (1.0 when no holder), locked_to:int (day, -1 none)}.
   - match: always available (group keep); cash = -STIPEND x 12; loyalty_end = loyalty + 12 (the cause stops);
     locked_to = day + WINDOW_DAYS; holder_end = holder loyalty unchanged.
     For group bout / debut / manager: match is available with cash 0 and the same +12 (the club books the bout itself);
     keep the column, Claude prices those causes later.
   - half: available only when group == "keep" AND holder is not empty AND talk != "failed" (why_not
     "the talk failed" / "nobody holds the stipend"). loyalty_end = loyalty + (talk == "landed" ? 9 : 4) + TICK x 0
     (nobody holds more, the cause stops); holder_end = holder.loyalty + HOLDER_HALF; train and holder_train 0.925;
     cash 0; locked_to = day + WINDOW_DAYS.
   - move: available only when holder is not empty (why_not "nobody holds the stipend"). loyalty_end = loyalty + 12;
     holder_end = holder.loyalty + HOLDER_MOVE + TICK x holder_ticks; holder_train 0.85; cash 0.
   - promise: available only when can_book (why_not "no show can be booked now"). cash = -SHOW_COST;
     loyalty_end = loyalty + 4 + 10 + TICK x ticks_after_show (the ticks wait for the night; kept assumed - the column
     says what follows if it is kept). locked_to -1.
   - let_go: always available; cash 0; loyalty_end -1 (gone); holder_end unchanged.
6. `card_line(col: Dictionary) -> String` - the column's button word, exactly: match "MATCH IT", half "HALF EACH", move "MOVE THE STIPEND", promise "PROMISE: OUR SHOW",
   let_go "LET THEM GO", followed by " - " and why_not when not available. (Names never appear in rows: the header holds
   them.)

## The test: tests/approach_test.gd (extends SceneTree; prints ok/FAIL per check; last line
`APPROACH PASS fails=0` or `APPROACH FAIL fails=<n>`; quit(0)/quit(1))
The map's section 6 week (Danny, day 91, loyalty 33, coachability 34, Lucy holds the stipend at 64):
- due({loyalty:33, potential:85, rank:0, is_pro:false, last_approach_day:-1, day:91}) == true; loyalty 35 -> false;
  potential 79 rank 0 -> false; rank 4 potential 70 -> true; last_approach_day 20 day 91 -> false (71 days), day 104 -> true.
- offer: log [{d:28,n:-3,why:"day_job"},{d:37,n:-3,why:"offer_passed"},{d:56,n:-3,why:"day_job"},
  {d:75,n:-4,why:"target_missed"},{d:84,n:-3,why:"day_job"},{d:86,n:-3,why:"offer_passed"},{d:26,n:2,why:"win"}], day 91
  -> group "keep", loss -9 (d 28 is 63 days back: inside), line "Full time: Eastside's backers pay the keep".
  The same log with day 120 drops d 28 and d 37 (>= 84 back): keep -6, bout -7 -> group "bout".
- talk_chance(34) == 0.504 (within 0.001); talk(34, 0.50).landed == true; talk(34, 0.51).landed == false.
- answers({loyalty:33, talk:"", group:"keep", holder:{loyalty:64}, can_book:true, ticks:3, ticks_after_show:2,
  holder_ticks:3, day:91}): match 45 cash -3000 locked_to 175; half 37 holder 60; move 45 holder 47 (64-8-9) holder_train
  0.85; promise 41 (33+4+10-6) cash -3500; let_go loyalty_end -1. Order of ids exactly match, half, move, promise, let_go.
- talk landed: loyalty 33 (+0), talk "landed" -> half 42 (33+9). Talk failed: loyalty 29, talk "failed" -> half
  available false, why_not "the talk failed"; promise 37 (29+4+10-6); match 41.
- holder {} -> half and move unavailable ("nobody holds the stipend"); can_book false -> promise unavailable.
- card_line of an unavailable half == "HALF EACH - the talk failed".

GDSCRIPT TRAPS (each cost an earlier Arena PR a fix): never `var x := <an Array or Dictionary element>` (untyped
Variant -> parse error: write `var x: int = int(d["k"])`); Array has no join(); no `sort_custom` with a static Callable
in a script without class_name; a ternary is `a if cond else b`.

## Contract
OWNS: scripts/rules/Approach.gd, tests/approach_test.gd
RED_TEST: tests/approach_test.gd -> APPROACH PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/approach_wire_test.gd, tests/approach_contract_test.gd (S490: the wiring that landed after)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/approach_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge. PR body: `RESULT: tests/approach_test.gd -> APPROACH PASS fails=0`.

## Prior research
ops/research/R58_MAP_S439.md sections 4 (M3 the talk, M4 the approach and the five answers) and 6 (the worked week the
test uses); scripts/rules/Loyalty.gd (the log rows {d, n, why} and the bands); the owner's Q-244 answer: the pro share
under 50 loyalty is 10% (not the map's 12%) - not used in this module.

## What would a human do?
A coach hears a rival club has been talking to his boxer. He works out what the boxer is unhappy about, decides whether
to have it out with him first, then picks what to give: money, a split, a promise, or the door.

## Prefab check
None: our own rules.
