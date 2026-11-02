# TASK C130 — CODEX — THE PAIR IN THE LIVE ROOM: ONE SCHEDULE ENTRY FOR BOTH FIGHTERS, A CONTRACT TEST WRITTEN BLIND

Model: `gpt-5.6-luna`, MEDIUM (the only setting - `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (THE SCRIPTED JAB IN THE LIVE FIGHT).

**Test tier: A NEW TEST FILE ONLY.** You write the test BLIND from the contract below. The functions it names are being
added by Claude at the same time in another worktree and are NOT in the main checkout: do not open
`Godot/scripts/FightLiveSchedule.gd` or `Godot/scripts/FightMoveScript.gd` looking for them. Parse gate only:
`python Godot/tools/check_scripts.py Godot/tests/fight_pair_schedule_test.gd`. While the functions are missing it
reports them as not found (for example `Static function "add_pair()" not found`) - those lines, for exactly the names in
this contract, are expected; every other parse error is yours. Do not run Godot tests, do not commit (your sandbox
cannot write `.git`); Claude runs the test against the real functions and against deliberate breaks of them.

## Owned file

- `Godot/tests/fight_pair_schedule_test.gd` - NEW, `extends SceneTree`.

## Why this exists

The operator watched our 3D boxing room and chose, from a side-by-side video: "Right is clearly better" - the right was
ONE EXCHANGE (a jab landing on the head) authored in Blender for BOTH fighters on ONE clock. Next step, their words:
"Put this jab in the live fight". Today the room schedules every blow as TWO entries on two clocks (the thrower's
punch early, the receiver's reaction on the impact tick) and each body is presented on its own. A landed jab to the
head now becomes ONE schedule entry that starts BOTH fighters' takes of the authored pair at once - or, when the room
cannot play the pair at that moment (the men stand too far apart, one of them is busy), falls back to exactly the two
entries it would have had. These functions are pure arithmetic over dictionaries, so a blind test pins them exactly.

## The contract (both modules are `preload`ed; every function is `static`; both modules have ZERO preloads)

### `FightLiveSchedule` (`res://scripts/FightLiveSchedule.gd`) - EXISTING functions you rely on (they are unchanged)

- `create() -> Dictionary` - `{"entries": [], "seq": 0, "known_to_s": 0.0, "last_throw_s": {}}`.
- `add_action(schedule, beat, impact_s, lead_s, target_lead_s = 0.0)` - for a beat with `"type" == "action"` inserts up
  to two entries. The ACTOR entry (when `actor_side` is non-empty): `start = impact_s - max(0, lead_s)`; when
  `last_throw_s` HAS the actor and `start < last_throw_s[actor]`: `seek = min(max(0, lead_s), last_throw_s[actor] - start)`
  and `start += seek`; the entry is `{"side": actor, "part": "actor", "start_s": start, "seek_s": seek, "impact_s":
  impact_s, "beat": beat}`; then `last_throw_s[actor] = impact_s`. The TARGET entry (when `target_side` is non-empty):
  `start = impact_s - target_lead_s`, raised to at least the actor entry's (seeked) start when there is an actor; the
  entry is `{"side": target, "part": "target", "start_s": start, "impact_s": impact_s, "beat": beat}`. Inserted entries
  get `"seq"` (a counter) and stay sorted by `start_s`, equal starts in insertion order.
- `mark_known(schedule, seconds)` - `known_to_s = max(known_to_s, seconds)`.
- `take_due(schedule, now_s, lead_cap_s) -> Array` - removes and returns, in order, every entry with `start_s <= now_s`;
  each returned copy carries `"budget_s"` priced BEFORE it is removed (see `budget_for`).
- `budget_for(schedule, entry, lead_cap_s) -> float` - seconds from `entry.start_s` to the start of the first OTHER
  entry (different `seq`) still in the schedule ON THE SAME BODY with `start_s >= entry.start_s`; with none:
  `OPEN_BUDGET_S` (1.0e6) if `known_to_s >= OPEN_BUDGET_S`, else `max(0, known_to_s - max(0, lead_cap_s) - entry.start_s)`.
- `OPEN_BUDGET_S := 1.0e6`, `PART_ACTOR := "actor"`, `PART_TARGET := "target"`.

### `FightLiveSchedule` - NEW

1. `const PART_PAIR := "pair"`.
2. `last_throw(schedule: Dictionary, side: String) -> float` - `last_throw_s[side]` when the schedule has it, else `-1.0`.
3. `add_pair(schedule: Dictionary, beat: Dictionary, impact_s: float, lead_s: float, target_lead_s: float,
   pair_schedule: Dictionary) -> void`
   - When `beat.type != "action"`, or `actor_side` is empty, or `target_side` is empty: EXACTLY
     `add_action(schedule, beat, impact_s, lead_s, target_lead_s)` (a malformed beat is never lost, never paired).
   - Otherwise it computes the two entries `add_action` would insert - the same seek against `last_throw_s`, the same
     target clamp, the same dictionaries WITHOUT `"seq"` - and does NOT insert them. It inserts ONE entry:
     `{"side": actor, "sides": [actor, target], "part": "pair", "start_s": min(pair_schedule.start_s, the actor
     entry's start_s), "impact_s": impact_s, "beat": beat, "pair_schedule": pair_schedule, "last_throw_before_s":
     last_throw(schedule, actor) read BEFORE this call changes it, "fallback": [actor entry, target entry]}`
     (it gets a `"seq"` like any inserted entry), and sets `last_throw_s[actor] = impact_s` once.
   - `beat` and `pair_schedule` are stored as given (the same dictionaries, not copies) and never mutated.
4. `reinsert(schedule: Dictionary, entries: Array) -> void` - puts each entry back, in array order, as a
   `duplicate()` with the keys `"seq"`, `"budget_s"` and `"target_budget_s"` erased, inserted like any new entry (a
   fresh `seq`, sorted by `start_s`, equal starts after the ones already there). Never mutates the given entries and
   never touches `last_throw_s`.
5. ON A BODY, redefined for every function that asks it (`budget_for`, `take_due`, `starts_between`): an entry is on
   side `s` when `entry.side == s` OR its `"sides"` array (when it has one) contains `s`. So a pair entry is on both men.
6. `budget_for(schedule, entry, lead_cap_s, side: String = "") -> float` - as before, on body `side` when it is
   non-empty, else on `entry.side`.
7. `take_due` - as before; a returned entry whose `part` is `"pair"` ALSO carries `"target_budget_s"`: the budget on
   `sides[1]`, priced at the same moment as its `budget_s`.
8. `starts_between(entries: Array, sides: Array, from_s: float, until_s: float) -> bool` - true when any entry in
   `entries` is on any side in `sides` and has `from_s <= start_s <= until_s` (both ends inclusive); false for an empty
   array or empty `sides`. (The room calls it with `schedule["entries"]` and with the rest of a frame's due list.)

### `FightMoveScript` (`res://scripts/FightMoveScript.gd`) - EXISTING function you rely on (unchanged)

- `schedule_pair(pair, impact_s, last_impact_s) -> Dictionary` - `origin = impact_s - pair.contact_s`; `seek = 0`,
  or `min(pair.contact_s, last_impact_s - origin)` when `last_impact_s >= 0` and `origin < last_impact_s`;
  returns `{"origin_s": origin, "start_s": origin + seek, "seek_s": seek, "impact_s": impact_s, "end_s": origin +
  pair.length_s, "length_s": pair.length_s}`.

### `FightMoveScript` - NEW

9. `const EXCHANGES := {"BOX_JAB_HEAD_LAND": {"techniques": ["boxing_jab"], "contacts": ["clean", "glancing",
   "absorbed"], "regions": ["head_neck"]}}`
10. `exchange_for(beat: Dictionary) -> String` - the FIRST exchange id (in `EXCHANGES` order) whose rule holds, where
    the rule is: `beat.type == "action"`, `actor_side` and `target_side` both non-empty, `knockdown` not true,
    `technique` in `techniques`, `contact` in `contacts`, `target_region` in `regions`. `""` when none holds. Missing
    keys read as `""` (and `knockdown` as false).
11. `variants_for(library: Array, exchange: String, thrower_fighter: String, receiver_fighter: String) -> Array` -
    every element of `library` (a pair DOCUMENT: a Dictionary with `"exchange"`, `"pair"`, `"roles": {"thrower":
    {"fighter"}, "receiver": {"fighter"}}`) whose `exchange` equals `exchange` and whose two role fighters equal the two
    arguments, in library order, the documents themselves. A non-Dictionary element, a document missing `exchange`,
    `roles`, either role or either `fighter`, and an empty `exchange` argument never match.
12. `pair_take_name(move: String, pair_id: String) -> String` - `move + "#pair_" + pair_id`.
13. `is_pair_take(take: String) -> bool` - true exactly when `take` contains `"#pair_"`.

## Worked examples - each is a situation the live room meets; walk it before you encode it

Use this pair everywhere: `P = {"id": "P_JAB", "length_s": 1.8333, "contact_s": 0.7333, "entry_s": 0.5, "start_gap_m":
1.1377, "min_gap_m": 1.0177, "max_gap_m": 1.2577, "end_travel_m": {"thrower": 0.0, "receiver": 0.0}}`, the jab beat
`J = {"type": "action", "actor_side": "a", "target_side": "b", "technique": "boxing_jab", "contact": "clean",
"target_region": "head_neck"}`, and compare floats to 1e-4.

A. A LONE LANDED JAB. `s = create()`; `ps = FightMoveScript.schedule_pair(P, 14.10, last_throw(s, "a"))` (= -1.0, so
   `ps.start_s` = 13.3667, seek 0). `add_pair(s, J, 14.10, 0.40, 0.1667, ps)`: `s.entries` holds ONE entry - side "a",
   sides ["a", "b"], part "pair", start_s 13.3667, impact_s 14.10, `beat` IS `J`, `pair_schedule` IS `ps`,
   last_throw_before_s -1.0; fallback[0] = actor, side "a", start 13.70, seek 0.0, impact 14.10, beat J, no "seq";
   fallback[1] = target, side "b", start 13.9333, impact 14.10, no "seq". `last_throw(s, "a")` = 14.10,
   `last_throw(s, "b")` = -1.0.
B. THE JAB 0.30 s AFTER HIS OWN CROSS LANDED. `s = create()`; `add_action(s, C, 13.80, 0.40, 0.10)` with
   `C = {"type": "action", "actor_side": "a", "target_side": "b", "technique": "boxing_cross", "contact": "clean",
   "target_region": "head_neck"}` (entries: actor 13.40, target 13.70). `ps = schedule_pair(P, 14.10, last_throw(s,
   "a") = 13.80)` -> seek 0.4333, start 13.80. `add_pair(s, J, 14.10, 0.40, 0.1667, ps)`: the fallback actor would start
   13.70, before his cross landed, so it seeks 0.10 and starts 13.80; the fallback target starts 13.9333; the pair
   entry starts min(13.80, 13.80) = 13.80 with last_throw_before_s 13.80; `s.entries` is [cross actor 13.40, cross
   target 13.70, pair 13.80]; `last_throw(s, "a")` = 14.10.
C. A PAIR THAT WOULD START LATER THAN HIS PUNCH. `P2` = P with contact_s 0.20: `ps2 = schedule_pair(P2, 14.10, -1.0)`
   starts 13.90; `add_pair(create(), J, 14.10, 0.40, 0.0, ps2)` -> the entry starts 13.70 (the actor fallback's start).
D. BOTH MEN'S BUDGETS. `s = create()`; add_pair as in A; `add_action(s, {"type": "action", "actor_side": "b",
   "target_side": "a", "technique": "boxing_cross", "contact": "clean", "target_region": "head_neck"}, 14.60, 0.40,
   0.0)` (B's actor 14.20, A's target 14.60); `mark_known(s, 17.0)`. `take_due(s, 13.40, 0.73)` returns ONLY the pair
   entry, with budget_s 1.2333 (side a: A's target at 14.60) and target_budget_s 0.8333 (side b: B's actor at 14.20).
   Then `take_due(s, 14.30, 0.73)` returns B's actor entry with budget_s 2.07 (nothing left on b: 17.0 - 0.73 - 14.20).
E. A BLOW JUST BEFORE THE PAIR IS PRICED AGAINST THE PAIR. `s = create()`; add_pair as in A; `add_action(s, {"type":
   "action", "actor_side": "b", "target_side": "a", "technique": "boxing_jab", "contact": "clean", "target_region":
   "head_neck"}, 13.20, 0.30, 0.0)` (B's actor 12.90, A's target 13.20); `mark_known(s, 17.0)`. `take_due(s, 13.25,
   0.73)` returns [B's actor with budget_s 0.4667, A's target with budget_s 0.1667] - both end at the pair's start,
   because the pair entry is on both men - and the pair entry is still in the schedule.
F. THE ROOM CANNOT PLAY THE PAIR: PUT ITS TWO ENTRIES BACK. After A: `var due = take_due(s, 13.40, 0.73)`;
   `reinsert(s, due[0]["fallback"])` -> `s.entries` is [actor "a" 13.70, target "b" 13.9333], each with a "seq" not
   less than the schedule's seq before the call, neither with "budget_s"; `due[0]["fallback"][0]` still has no "seq";
   `last_throw(s, "a")` still 14.10. Reinserting `due[0]` itself into a fresh schedule gives an entry with no
   "budget_s" and no "target_budget_s", and with part "pair".
G. `starts_between`. `E = [{"side": "a", "start_s": 13.50}, {"side": "b", "start_s": 14.10}, {"side": "c", "start_s":
   13.60}, {"side": "x", "sides": ["a", "b"], "start_s": 14.20}]`: (E, ["a", "b"], 13.40, 14.10) true; (E, ["b"], 13.40,
   14.09) false; (E, ["b"], 13.40, 14.10) true; (E, ["b"], 14.15, 14.25) true (the "sides" entry); (E, ["c"], 13.61,
   20.0) false; ([], ["a"], 0.0, 100.0) false; (E, [], 0.0, 100.0) false.
H. `exchange_for`. J -> "BOX_JAB_HEAD_LAND"; J with contact "glancing" or "absorbed" -> the same; with contact
   "blocked", "missed" or "" -> ""; target_region "body" -> ""; technique "boxing_cross" or "boxing_one_two" -> "";
   `"knockdown": true` -> ""; type "idle" -> ""; actor_side "" -> ""; target_side "" -> ""; `{}` -> "".
I. `variants_for`. `F01 = "res://assets/models/fighters/f01_m_box_welter_rigged.glb"`, `F09 =
   "res://assets/models/fighters/f09_m_bare_welter_rigged.glb"`; a document is `{"exchange": X, "pair": {"id": ID},
   "roles": {"thrower": {"fighter": T}, "receiver": {"fighter": R}}}`. Library [D1 (BOX_JAB_HEAD_LAND, J1, F01, F09),
   D2 (BOX_JAB_HEAD_LAND, J2, F09, F01), D3 (BOX_CROSS_HEAD_LAND, C1, F01, F09), D4 (BOX_JAB_HEAD_LAND, J3, F01, F09),
   D5 (BOX_JAB_HEAD_LAND, J4, no "roles"), D6 (no "exchange", J5, F01, F09), 7 (an int)]:
   ("BOX_JAB_HEAD_LAND", F01, F09) -> [D1, D4] (ids J1, J3, in that order); ("BOX_JAB_HEAD_LAND", F09, F01) -> [D2];
   ("BOX_JAB_HEAD_LAND", F01, F01) -> []; ("BOX_CROSS_HEAD_LAND", F01, F09) -> [D3]; ("", F01, F09) -> []; an empty
   library -> [].
J. Take names. `pair_take_name("jab", "BOX_JAB_HEAD_LAND_F01_F09")` = `"jab#pair_BOX_JAB_HEAD_LAND_F01_F09"`, whose
   `get_slice("#", 0)` is `"jab"`; `is_pair_take` of it -> true; of `"react_head#1"`, `"jab"` and `""` -> false.

## The test

`Godot/tests/fight_pair_schedule_test.gd`, `extends SceneTree`, all work in `_initialize()`, `quit()` at the end.
Every check prints `PASS <label>` or `FAIL <label> got=<value> want=<value>`; the last line is
`FIGHT_PAIR_SCHEDULE TOTAL=<n> fails=<m>`; exit code 1 when fails > 0 (`quit(1)`). **Counters live in a Dictionary**
(a local int changed inside a lambda changes a copy - a previous blind test printed TOTAL=0 fails=0 while failing).
**Type every value you take from a `load()`ed or `preload`ed script's static call** (`var n: int = ...`,
`var e: Dictionary = ...`) - `var x := <static call>` does not parse. Cover every numbered function and every example
A-J, plus: `add_pair` with a non-action beat adds nothing; with an empty `target_side` it adds exactly what
`add_action` adds (one actor entry, part "actor"); `take_due` on a schedule holding only non-pair entries returns no
"target_budget_s"; `budget_for` with an explicit `side` on a pair entry.

## Send

`python Tools/agent_comms.py send --from codex --to claude --topic "C130 ready" --body "<checks count>, parse gate: <the
CHECK line>"`. Do not edit HANDOFF.md.

## The trap

Example E is the one a quick reading gets wrong: the pair entry is on BOTH men, so a blow that lands on A just before
the pair starts is priced against the pair even though the pair's `side` is "a" and that blow's actor is "b". And in B,
the fallback actor's seek is priced against the cross's impact (13.80), NOT against the jab's own impact - `add_pair`
reads `last_throw_s` before it writes it.
