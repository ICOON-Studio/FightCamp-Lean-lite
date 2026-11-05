# GAMETREE1-A (Stage 1) implementation plan - "The tree decides the opens"

Worktree E:/FightCamp/wt/LEAN_GAMETREE1, branch claude/gametree1 (HEAD fb3fe026; origin/main d2fe728d is 1 commit ahead and
touches only NEXT_SESSION_PROMPT.md, so the merge has no conflict). Spec: ops/research/GAMETREE1_DESIGN_S384.md r2, section 9
Stage 1. Operator-approved answers: IBJJF points; purple leg locks train but fire only at brown+ (the card says so);
match pace 1.5 s/beat with key beats at real speed and Sim to the end (that is stage 2 UI; stage 1 resolves the open on its day).

Facts checked while planning (read-only, no Godot run):
- Grapplers.day line 19 = `NoGi.week(f, c.day)` in the Sunday branch; line 34 = `NoGi.run_open(f, o, c.day, rng)`, the only
  run_open caller in scripts/. run_open returns {matches, wins, medal}; rows {d, open, win, opp, how}.
- Research graph: 49 nodes (47 + tap_win/tap_loss), 80 moves (42 syllabus, 28 tree, 10 base), 135 edges, 8 routes.
  Recomputed in Python from NoGi.athlete(): 9 owned moves / 22 owned edges, 23 felt / 33, 2 learning / 6, 28 holes of 47 -
  the design's golden numbers hold.
- **The graph FAILS no_pronoun_test as it stands**: `meta.ana_start.note` says "tree moves of her belt ..." (its own
  `meta.checks.pronoun_strings: []` missed it). Fixed in step 1.
- Edge film ids are GrappleMap sequence indices (graph.json transitions; ids = GrappleMapDB.load_db() order), so a clip plays
  as `db()[id]`; gm_pose/card_pose are position indices into the same db.
- 14 BJJ ink PNGs ship in assets/ui/moves (double_leg, arm_drag_back, wrestle_up, shrimp_bridge, posture_closed_guard,
  bullfighter_pass, knee_cut_pass, hip_bump_sweep, rear_naked_choke, de_la_riva, single_leg_x, leg_drag, toe_hold,
  north_south_choke); 28 BJJ rows in moves_rows.json are `pending`.
- Brown-only moves in the graph: k_guard, outside_heel_hook, kneebar, toe_hold, inside_heel_hook, saddle_entry, calf_slicer.
- Belt pools (non-BASE): white 34 (14 syllabus + 20 tree), blue 17 (11 + 6), purple 11 (9 + 2), brown 8 (syllabus).
- Routes legal at white (every move's belt <= white): only `wrestler` (Shot to the back) and `closed_guard_basics`.
- Main.gd builds modals from a literal type -> scene dict; GrapplerPage.act owns every grappler act (gdrill etc.).
- export_presets include_filter already ships `assets/data/*.json`.

---

## 0. Setup (no commit)

1. `git -C E:/FightCamp/wt/LEAN_GAMETREE1 merge origin/main` (expected clean; if tools/run_tests.sh ever conflicts, keep both
   TESTS lists, union of names).
2. The worktree has NO `.godot` folder: seed it first -
   `powershell -NoProfile -ExecutionPolicy Bypass -File E:/FightCamp/Lean/ops/Tools/seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\LEAN_GAMETREE1`,
   then ONE `--headless --import` (gated as below).
3. PC gate before EVERY Godot launch (bash, background-safe):
   ```
   gate() { for i in $(seq 1 30); do
     n=$(tasklist | grep -ci godot); w=$(python E:/FightCamp/Lean/ops/Tools/seat_dispatch.py status 2>&1 | grep watchdog | head -1)
     if [ "$n" -lt 2 ] && ! echo "$w" | grep -q ' RED '; then return 0; fi; sleep 90; done; return 1; }   # run via Monitor/until-loop, not a foreground sleep
   ```
   45 min without a slot -> stop, report
   UNTESTED. Long runs (sim test, balance runner) go `run_in_background`.
4. Godot command: `C:/Users/user/AppData/Local/Programs/Godot/Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path E:/FightCamp/wt/LEAN_GAMETREE1 --script res://tests/<t>.gd`.
5. Files that must end with an EMPTY diff vs origin/main (checked in step 11): scripts/rules/NoGi.gd, BeltRoad.gd, TheRead.gd,
   OppFile.gd, OwnCombos.gd, BjjSide.gd, BjjFilm.gd, GroundRules.gd, scripts/grapple/*, scripts/fight3d/* (never touched).

---

## 1. Data - `assets/data/bjj_tree.json`  (commit A1)

- Copy ops/research/GAMETREE1_POSITIONS_S384.json -> assets/data/bjj_tree.json (graph unchanged: node/move/edge/route ids and
  fields as in design 8; edge ids e001-e135 frozen).
- Fix `meta.ana_start.note` -> "tree moves of Ana's belt start at ...". Re-scan every key and string with the test's regex
  `(?i)\b(she|her|hers|herself)\b` in Python before commit; update `meta.checks.pronoun_strings` honestly.
- **IBJJF legality re-check** (design 4.4, the R gap): WebFetch the current IBJJF rule book / illegal-techniques table
  (ibjjf.com books-videos, rule book PDF; record the version/date). Compare per move: straight ankle all belts; kneebar,
  toe hold, calf slicer, heel hooks, reaping (saddle_entry) brown+ no-gi adult; check k_guard specifically (a guard is not an
  illegal technique - if the rule book only bans the reaping entry, k_guard goes to `white` and the reaping edges keep brown).
  The JSON follows the rule book as found (the operator's answer was "the real IBJJF rule"); every change and the source
  line go to `meta.ibjjf_check {read, source, version, changes[]}` and into the step report. No fetch possible -> keep the
  table, `meta.ibjjf_check.status = "not re-checked"`, report it.
- No per-move rate in the JSON (design 3.3 keeps them in code).
- Commit: `S384 GAMETREE1-A: bjj_tree.json from the research graph, IBJJF legality re-checked, pronoun-clean meta`.

---

## 2. `scripts/rules/BjjTree.gd` - data, mastery, FELT, legality, odds  (commit A2)

`extends RefCounted`, pure static; preloads BeltRoad, NoGi, TheRead (none of them preload BjjTree - no cycle).

### Constants
Research / existing code (not tuned): `PATH := "res://assets/data/bjj_tree.json"`; `KIND_BASE` = {odds: [white/blue, brown/black]}
takedown [0.33, 0.33] (UNVERIFIED row, see T), sweep [0.52, 0.35], back_take [0.60, 0.35 (T)], pass [0.23, 0.23],
submission [0.16, 0.16], entry/transition/escape (T), base 0.94; purple = midpoint of the two columns. `OVERRIDES` =
rear_naked_choke 0.35, kneebar 0.27, inside_heel_hook 0.25, darce 0.22, anaconda 0.21, guillotine 0.10, mat_return 0.71,
body_lock_pass 0.37, leg_drag 0.31 (all tiers); `OVERRIDES_AMATEUR` = scissor_sweep 0.55 (white/blue only).
`BASE_P := 0.94` (no clamp), `CLAMP := Vector2(0.03, 0.90)`, `P_BAD_AT := BeltRoad.OWNED_AT` (30), `SIGNATURE := NoGi.SIGNATURE`,
`LONG_AT := 4` (mirrors OwnCombos.LONG_AT; BjjTree does not preload OwnCombos), chip cut points `LIKELY_AT := 0.60`,
`LONG_SHOT_BELOW := 0.35` (display only), `IQ_ENDS` = TheRead.IQ_LOW 40 / IQ_HIGH 85.

**[T] tuning values** - held in `const T0 := {...}` and read through `static var T := T0.duplicate()` so the balance runner can
sweep them without editing code; `walk()` copies them into locals once per walk (no dict lookups in the beat loop). Tests call
`BjjTree.reset_tuning()` first. Final values are written back into T0 in the tuning commit.

| key | start | bar |
|---|---|---|
| TAP_VALUE | 10 | 4 |
| PLAN_PULL | 2 | 9 (stage 2 bar; kept at start value in stage 1) |
| EPS | 0.2 | 11b |
| STYLE_W | 2 | 11c |
| LATE_S | 60 | 7 |
| D_NONE | 0.7 | 10 (stage 2 bar; stage 1 keeps 0.7 unless bar 1 forces it, reported) |
| CHAIN | 1.15 | 9 (stage 2; kept) |
| READ_W | 0.6 | 9 (stage 2; kept) |
| MOOD_W | 5 | 1c |
| MF_CEIL | 1.8 (owned slope = MF_CEIL - 1 over 70) | 3, 6 |
| BASE_ENTRY / BASE_TRANSITION / BASE_ESCAPE | 0.50 / 0.40 / 0.30 | 3 / 5 / 6 |
| BASE_BACK_PRO | 0.35 | 5 |
| BASE_TAKEDOWN (UNVERIFIED 33 %) | 0.33 | 5 |
| BACK_FINISH_W (overrides nodes.back_top.finish_w, UNVERIFIED) | 0.36 | 6 |
| IQ_BLUE / IQ_PURPLE | 55 / 70 | 9 (kept) |
| OFF_BELT | 0.5 a belt | 13 |
| BEAT_S | 22 | 4 |
| FELT | 15 | 14 |
| ROLL_EVERY | 2 (weeks) | 14 |
| FILM_OPENS | 3 | 12 - declared, unused in stage 1 |

### Public functions (signatures)
```
static func data() -> Dictionary            # cached load: {nodes{id:}, moves{id:}, edges{id:}, routes{id:}, from{node:[eid]}, into{node:[eid]}, meta}
static func node(id: String) -> Dictionary
static func move(id: String) -> Dictionary
static func edge(id: String) -> Dictionary
static func route(id: String) -> Dictionary
static func move_name(id: String) -> String  # NoGi.move_name(id) for src "syllabus" (byte-identical labels), else the JSON name
static func mirror(node_id: String) -> String
static func edges_from(node_id: String) -> Array   # edge dicts, JSON order
static func edges_into(node_id: String) -> Array
static func is_base(move_id: String) -> bool
static func class_part(f: Dictionary, move_id: String) -> float   # 30 below her belt, 30 x min(1, mat_classes / CLASSES_TO_NEXT[belt]) at it, 0 above
static func mastery(f: Dictionary, move_id: String) -> float      # syllabus: f.bjj[id]; tree: min(100, class_part + f.tree[id]); base: 100
static func levels(f: Dictionary) -> Dictionary                   # every non-BASE move -> mastery (snapshots for the week report)
static func state(m: float) -> String                             # "learning" (< FELT) | "felt" (FELT..29.99) | "owned" (30..49.99) | "signature"
static func usable(m: float) -> bool                              # m >= FELT (learning edges never tried in an open)
static func rules_for(belt: String, roll: bool = false) -> Dictionary   # {belt, tier "amateur"|"mid"|"pro", minutes, roll}; roll => legality at white, 5 min
static func legal(move_id: String, rules: Dictionary) -> bool     # rank(rules.belt) >= rank(move.ibjjf_min) (roll: white)
static func holes(f: Dictionary, rules: Dictionary) -> Array      # nodes (no endings) where f owns no legal non-BASE out-edge
static func mf(m: float) -> float                                 # m < 30: m/30; else 1 + (MF_CEIL-1) x (m-30)/70
static func base_rate(e: Dictionary, rules: Dictionary) -> float  # OVERRIDES / OVERRIDES_AMATEUR / KIND_BASE[e.odds][tier]
static func answer_mastery(defender: Dictionary, e: Dictionary, rules: Dictionary) -> float   # best LEGAL answer's mastery, 0 if none
static func odds(e: Dictionary, m_att: float, m_ans: float, rules: Dictionary, chain: bool = false, read: float = 0.0, mood: float = 0.0) -> float
     # BASE edge -> BASE_P; else clamp(base x mf(m_att) x (CHAIN if chain) x (1 + MOOD_W x mood) / (max(D_NONE, mf(m_ans)) x (1 + READ_W x read)), CLAMP)
static func p_bad(m_ans: float) -> float                          # min(1, m_ans / P_BAD_AT)
static func mood_of(f: Dictionary) -> float                       # exactly win_chance's term: (morale - 60)/400 - (TOUGH if tough_next); 0 for a dict with no morale
static func chip_word(p: float) -> String                         # "LIKELY" >= 0.60, "EVEN" 0.35-0.5999, "LONG SHOT" < 0.35
static func reset_tuning() -> void
```
Decisions recorded (the design leaves them open):
- An answer counts toward D and P_bad only when legal under the bout's rules (an illegal heel hook cannot stop anything).
- `class_part` uses `mat_classes` exactly as the design writes it (not minus mat_debt).
- The FELT step (design stage-1 item 7) is built here, not later: odds, options and the golden counts all depend on it.

Tests (new):
- `tests/bjj_tree_test.gd` (structure part, written in this step; walk/rule parts added in steps 3-5):
  47 positions + 2 endings; mirror(mirror(x)) == x for all; every edge from/ok/bad exists; every node reachable from standing
  (BFS over all edges, both sides via mirror); no dead end (every position has an out-edge); all 42 BeltRoad syllabus ids on
  1+ edge; every non-BASE edge has 1+ answer and every answer is a move; every edge film transition id is a graph.json
  transition id (GrappleGraph.get_entry(id).has("frames") and "from" key) or null; every route passes route_ok (step 4);
  edge ids superset of the frozen list e001..e135; every string and key pronoun-clean (same regex as no_pronoun_test);
  every move has `ibjjf_min`; Ana's start golden: 9 owned moves / 22 owned edges, 23 felt / 33, 2 learning (rear_naked_choke,
  guillotine) / 6 edges, 28 holes; every white tree move at 19.5.
- `tests/bjj_tree_odds_test.gd`: 30 vs 30 = base_rate exactly; m 100 = x1.8; m 15 = x0.5; m 14.9 not `usable` and absent
  from options (step 3); no answer = x 1/0.7; clamp 0.90 (mat_return 0.71 at m 100 vs no answer = 1.83 -> 0.90) and 0.03 (guillotine 0.10 felt
  at 15 vs an answer at 100 = 0.028 -> 0.03);
  BASE 0.94 unclamped; CHAIN x1.15; READ 1 + 0.6 r; MOOD: morale 100 -> x(1 + 5 x 0.1) = x1.5, morale 20 -> x0.5;
  overrides (RNC 0.35 at every tier, scissor 0.55 white/blue and 0.435 at purple, sweep purple = (0.52+0.35)/2); the worked
  example of 3.3 (RNC felt 15.2 vs seatbelt 40 -> 0.16, owned 30 -> 0.31, 50 -> 0.38, to 2 decimals); chip_word 0.60 LIKELY,
  0.59 EVEN, 0.34 LONG SHOT; legal(kneebar, white) false, legal(straight_ankle_lock, white) true (per the step-1 table).
- Commit: `S384 GAMETREE1-A: BjjTree data, mastery with class time and FELT, legality and the one odds formula`.

---

## 3. The walk, the chooser and the open  (commit A3)

```
static func options(f: Dictionary, own_node: String, rules: Dictionary, in_hole: bool) -> Array
     # legal edges from own_node whose move is usable (>= FELT) or BASE; in a hole only BASE edges; HOLD always added by choose()
static func choose(st: Dictionary, side: int, rng: RandomNumberGenerator) -> String   # edge id or "hold"
static func walk(ana: Dictionary, opp: Dictionary, plans: Array, minutes: int, rules: Dictionary, rng: RandomNumberGenerator) -> Dictionary
     # plans = [ana_steps: Array[eid], opp_steps: Array[eid]]
     # -> {win: bool (side 0 won), how: String, score: [a, o], adv: [a, o], ref: bool, path: [[eid, actor 0|1, "hit"|"miss"|"reset", t_s]],
     #     end: node (Ana's view), finish: move id or "", t: seconds, notes: [{rule, beat, line}], visits: {node: [beats, pts_lost, taps]}}
static func how_of(w: Dictionary) -> String
static func run_open(f: Dictionary, o: Dictionary, today: int, rng: RandomNumberGenerator) -> Dictionary
     # SAME shape as NoGi.run_open {matches, wins, medal} + "leak" {node, move, lost_pts, taps} (extra key, ignored by old readers)
static func plan_of(f: Dictionary, rules: Dictionary) -> Array       # f.bjj_plan.steps if route_ok and every step legal, else the coach's default (step 9 fill)
static func note_stats(f: Dictionary, res: Dictionary) -> void       # f.mat_stats[eid] = [tried, landed] for Ana's edges
```
Walk state (one dict, side 0 = Ana, 1 = opponent): `at` (node, Ana's view; a side's own node = at or mirror(at)), `init`
(seeded 50/50), `t`, `score`, `adv`, `plan_i[2]`, `last_plan_hit[2]` (for CHAIN), `looks[2]` per route (the watcher's
looks at the other side's plan), cached `m` = levels() of both athletes and their answer masteries per edge (built once).
One beat (design 3.2, literally):
1. Actor = `init`. In a hole -> options are BASE + HOLD.
2. Late lead: actor leading (points, then advantages) with `t >= minutes*60 - LATE_S` and its own node side in top/neutral -> HOLD.
3. On plan: own node == from of the next plan step and that step is in options -> take it (no EPS).
4. Else score every option: `p x gain - (1-p) x p_bad(m_ans) x loss` (HOLD = 0); gain = points + V(ok), loss = bad_gives +
   V_def(bad); V(node) = finish_w x TAP_VALUE (back_top uses T.BACK_FINISH_W), V(tap_win) = TAP_VALUE, V(tap_loss) = -TAP_VALUE,
   +PLAN_PULL when `ok` is one step along a shortest usable path (reverse BFS over usable+BASE edges, cached per plan step) to the
   next plan step's from. Opponent: positive scores in its style's lanes x STYLE_W. With probability EPS take the 2nd best.
5. p = odds(...) with CHAIN when this plan step follows a landed plan step, READ = the defender's read r on this route for plan
   steps (r = min(1, looks / TheRead.looks_needed(iq, false)); looks += LOOKS_PER_EXCHANGE per non-BASE plan step shown;
   stage 1: no film, no head start, read resets each bout), MOOD for side 0 only.
6. Hit: move, actor scores e.points; ok = tap_win ends it. Miss: BASE -> bad, no points; else with p_bad -> bad and the
   defender scores bad_gives, otherwise reset (+1 advantage to the actor when e.points > 0 or e.odds == "submission").
   Initiative: hit keeps it; miss, reset and HOLD pass it.
7. `t += BEAT_S`; at time: points, advantages, then a seeded 50/50 referee decision (`ref: true`).
- how strings (Ana's numbers first, as NoGi): `submission (<move_name lower>) m:ss` (t of the beat + a seeded 0-21 s offset),
  `points 6-2`, `points 2-2, advantages 1-0`, `points 2-2, advantages 0-0, referee decision`. `Grapplers._open` keeps reading
  `begins_with("submission")`.
- `notes`: one per rule only when it moved that beat's p by >= 5 % or decided it (the roll fell between p with and without
  it): late HOLD, CHAIN, read, MOOD, EPS, STYLE_W, FELT - each with its design-7 line text (no film line in stage 1).
- run_open: the 3 round opponents = `f.field[today]` (step 4) else `BjjOpp.field(f, o, rng.randi())`; per round
  `walk(f, opp, [plan_of(f), opp.route steps], BeltRoad.match_minutes(belt), rules_for(belt), rng)`; rows
  `{d, open, win, opp: opp.name, how, path, end, opp_id, lines}` (lines = notes' text, at most 5); break on a loss; the medal
  rule copied from NoGi.run_open (gold = all rounds, silver = rounds-1, bronze = rounds-2). leak = Ana's hole node with the
  most points+TAP_VALUE x taps lost over her bouts, its best Drill move (step 6 rule).
- Perf target: one white walk < 2 ms, one 10-min walk < 4 ms (measured in the sim test and printed). Hot loop has no string
  formatting except the path entries.

Tests (added to bjj_tree_test): same seed -> identical walk (path, how); a non-BASE miss with the defender's answer at 0 never
leaves the node (1,000 seeded beats); every row matches `^(submission \([a-z' -]+\) \d+:\d\d|points \d+-\d+(, advantages \d+-\d+(, referee decision)?)?)$`;
no edge with ibjjf_min > white ever fires at a white open (2,000 walks, Ana given kneebar 60); a learning edge (14.9) never in
a path; HOLD-only side in a hole tries only BASE edges; rows keep d/open/win/opp/how; an old row without `path` reads with
`.get("path", [])` everywhere.
- Commit: `S384 GAMETREE1-A: the honest walk on the map - chooser, odds, read, late lead, IBJJF rows`.

---

## 4. `scripts/rules/BjjOpp.gd` - the field  (commit A4)

`extends RefCounted`, pure static; preloads BjjTree, BeltRoad, NoGi.
```
const STYLES := {"Wrestler": ["standing", "kimura_back"], "Guard player": ["closed_guard", "open_guard"],
	"Passer": ["passing", "top_control"], "Half-guard player": ["half_guard", "escapes"], "Leg locker": ["leg_lock", "open_guard"]}
const PARTNER_NAME := "Marta Kowal"     # on neither NoGi.OPP list (test checks)
const OWNED_BAND := {"white": [8, 12], "blue": [25, 36]}          # ESTIMATE (design 4.5); purple = blue + 1 system, brown/black + 2-3
const IQ := {"white": 40, "blue": 55, "purple": 70, "brown": 85, "black": 85}   # ends CODE, steps [T bar 9]
[T] OWNED_M := Vector2(30, 50) (bar 1)  CLASS_SHARE := Vector2(0.4, 0.9) (bar 1)  ROUTE_M := Vector2(50, 70) (bar 12, purple+)
[T, NEW - flagged] UNOWNED_M := Vector2(5, 28) (bar 1): an unowned syllabus move of the opponent's belt (the design does not say; mirrors Ana's 9-28)
[T, NEW - flagged] LEAN_W := 2.0 (bar 11c): weight on the style the open's lean group maps to
const LEAN_STYLE := ["Passer", "Guard player", "Wrestler"]   # white groups: escapes / passes-and-sweeps / takedowns-and-subs -> the game that tests that group

static func generate(belt: String, style: String, seed: int) -> Dictionary
     # {id, name, first, belt, style, mat_classes, bjj{}, tree{}, route (go-to route id), iq, seed}  - the same shape BjjTree.mastery reads
static func go_to(belt: String, style: String, rng: RandomNumberGenerator) -> String   # a route in the style's lanes legal at belt (every move.belt <= belt), else any legal route
static func pick_style(f: Dictionary, o: Dictionary, rng: RandomNumberGenerator) -> String   # NoGi.lean_group(f, o) index -> LEAN_STYLE weighted LEAN_W, others 1
static func field_seed(base_seed: int, o: Dictionary, slot: int) -> int   # hash("%d|%s|%d|%d" % [base_seed, o.name, o.d, slot])
static func field(f: Dictionary, o: Dictionary, base_seed: int) -> Array  # 3 opponents at f's belt
static func partner(f: Dictionary, base_seed: int) -> Dictionary          # generate(f.belt, "Passer", hash(base_seed|id|"partner")), name PARTNER_NAME
```
generate(): name from NoGi.OPP_FIRST/OPP_LAST; classes share -> mat_classes = share x CLASSES_TO_NEXT[belt]; lower belts'
syllabus all owned (OWNED_M), lower belts' tree moves via class_part (30); go-to route moves owned (ROUTE_M at purple+,
OWNED_M below); then owned moves drawn from the belt's pool weighted STYLE_W in the style's lanes until the band count;
the rest of the belt's syllabus at UNOWNED_M, the belt's tree moves at class_part only (f.tree empty).
**Band decision (flagged)**: a fresh blue already owns 14 white syllabus + 20 class-taught white tree moves = 34, so the band
cannot count class-taught lower-belt tree moves; the band counts owned syllabus moves of all belts + owned tree moves of the
opponent's own belt. bjj_opp_test prints both counts.
Purple: + one system = the go-to route's moves at ROUTE_M plus linked edges to 6-10 signature edges; brown/black: 2-3 systems.

Entry: `Grapplers.enter` gets one new line after a successful entry:
`(f.get_or_add("field", {}) as Dictionary)[d] = BjjOpp.field(f, o, c.seed)` (int key, store_var keeps it). `Grapplers._open`
erases `f.field[c.day]` after the open (save stays small).
GrapplerPage: under each entered `Open_<d>` row a new `Field_<d>` hbox of 3 picture chips (style glyph + "R1 Rosa Lund -
Guard player"); the Open_<d> row itself is untouched (drill_pick_test reads its text).

Tests: `tests/bjj_opp_test.gd` - same seed -> same opponent; white owned count 8-12 over 200 seeds (band rule above);
masteries in their ranges; go-to route legal at belt (white: wrestler or closed_guard_basics only); iq by belt; partner named
Marta Kowal and that name is on neither OPP list; partner regenerated at blue keeps its seed; field() returns 3 with distinct
names; a lean-0 open draws Passer more often than 1/5 (200 seeds); every opponent string pronoun-clean.
- Commit: `S384 GAMETREE1-A: BjjOpp - five styles, owned bands, go-to routes; the bracket path drawn at entry`.

---

## 5. Week and wiring  (commit A5)

`BjjTree` additions:
```
static func is_tree_plan(plan: String) -> bool                         # begins_with tree: / route: / ahead:
static func drill_target(f: Dictionary, plan: String) -> Dictionary    # {move, store "bjj"|"tree", n (belts above hers)} or {} (done: >= SIGNATURE, unknown id, or illegal prefix)
     # tree:<id> -> a tree move; ahead:<id> -> a syllabus move of a belt above hers (f.bjj); route:<id> -> the route's lowest-mastery non-BASE move < 50
static func gain(f: Dictionary, n: int) -> float                       # NoGi.gain_of(f) x (NoGi.HUNGRY if held > 0) x pow(OFF_BELT, n)
static func week(f: Dictionary, day: int) -> String                    # mat_classes += NoGi.classes_of(f); the target gains; f.drill_on = move; returns the move
static func week_mark(f: Dictionary, before_levels: Dictionary, move: String) -> Dictionary   # {move, move_name, before, after, levels_before}
```
`Grapplers.day` Sunday branch becomes (the old three lines stay byte-identical in the `else`):
```
var lv := BjjTree.levels(f)
var plan := str(f.get("drill", "coach"))
if BjjTree.is_tree_plan(plan) and not BjjTree.drill_target(f, plan).is_empty():
	var m := BjjTree.week(f, c.day)
	f["mat_week"] = BjjTree.week_mark(f, lv, m)
else:
	<old lines 18-20 unchanged>
	f["mat_week"]["levels_before"] = lv
BjjTree.roll_week(c, f)          # step 7; a no-op until then
```
(A finished tree plan falls through to NoGi.week, whose drilling_for falls back to the coach's pick - the design's
"until signature, then the coach" rule.) `Grapplers._open`: line 34 `NoGi.run_open` -> `BjjTree.run_open` (same args, same
keys) + `BjjTree.note_stats(f, res)` + `f["open_week"]["leak"] = res.get("leak", {})` + field erase. `Grapplers.promote`:
`if f.has("partner"): f["partner"] = BjjOpp.partner(f, int(f["partner"]["seed"]))` - no news line (bjj_side_test reads news[0]).
`GrapplerPage.act` "gdrill": the accept test gains `or BjjTree.is_tree_plan(kv[1])`.
`Grapplers.week_report` row + `move_name`, `events` [{move, name, kind felt|owned|signature, before, after, src drill|class}]
(from levels_before vs levels(f)), `class_line` (3+ class events of one kind folded: "Class time: 10 white basics now owned"),
`off_belt_line` (n > 0: "Kimura roll to the back +1.6 - a blue-belt move, half rate."), `paths` (one line per bout from
open rows), `leak`, `roll` (step 7). WeekReview: `_drill_row` and the headline use `gr.get("move_name", NoGi.move_name(...))`.
Tests (bjj_tree_test, dispatch part): `tree:sprawl` on a Sunday -> f.tree.sprawl +3.2, f.bjj unchanged (so drilling_for
never ran), mat_classes +3; `ahead:de_la_riva` at white +1.6 in f.bjj; `move:kimura` still goes to NoGi.week (bjj +3.2);
the gdrill act stores tree:/route:/ahead: and refuses "tree:" + junk; old saves (no tree/field/partner keys) run a day.
Bar 13 (exact): ahead one belt = 2x the weeks, two belts = 4x; BeltRoad.readiness at her belt is the same after 20 weeks of
ahead drilling as after 20 weeks with no drill at all (the ahead gains never count toward her belt's syllabus).
- Commit: `S384 GAMETREE1-A: tree/route/ahead drilling at the FLOW rate, the opens run on the tree`.

---

## 6. Headless balance runner and the calibration test  (commit A6, then A6b tuned values)

- `tools/bjj_tree_balance.gd` (extends SceneTree): `-- bars=1,2,3 seeds=400 set=TAP_VALUE:8,10,12` prints each bar's value,
  band and PASS/FAIL to stdout and E:/FightCamp/tmp/s384/gametree1_build/balance_<stamp>.txt; a `set=` list sweeps one [T] at a
  time (coordinate descent, documented order: MOOD_W, OWNED_M/CLASS_SHARE/UNOWNED_M, BASE_*, MF_CEIL, BACK_FINISH_W,
  TAP_VALUE, BEAT_S, LATE_S, EPS, STYLE_W, LEAN_W). Only [T] keys may move; a bar no [T] can reach is reported UNMET with its
  numbers - never fixed by moving a research or CODE value. Runs in the background.
- `tests/bjj_tree_sim_test.gd` (seeded) - bars 1-8, 11, 13 (+ 14 after step 7; bar 16 printed, not gated):
  1. Ana vs white field (400 seeds): (a) per-bout win 0.49-0.59; (b) open mean wins 0.7-1.4, golds 40-120 per 400;
     (c) morale 100 / 20 moves (a) by +-0.10 +-0.03; (d) |tree win - NoGi.win_chance| <= 0.05 at shares 0.25 / 0.5 / 0.64 / 1.0,
     2,000 seeds each. `_ana_at(s)`: mat_classes = ceil(200 s); the round(14 s) best syllabus moves raised to max(m, 30),
     the rest capped at 29.9; the reference is NoGi.win_chance of that same dict.
  2. Ana's leaks: top 3 include back_top or back_bottom; distinct holes visited in 200 walks: 6-14.
  3. Even brown field (opp vs opp, IBJJF brown): sub rate 45-60 %, chokes 40-55 / arms 24-36 / legs 19-31 %, RNC top finish;
     white field: sub rate 30-55 %, RNC top. (Needs a move -> chokes/arms/legs map: const FINISH_KIND in the test.)
  4. Sub attempts: brown 0.5-0.75 a minute; white 2-4 a bout.  5. Brown scoring events: back takes most frequent; mount and
     pass events 0.3-0.7 a bout.  6. Node finish conversion (brown): back 0.30-0.40, saddle and 50/50 0.14-0.21, mount
     0.07-0.12, side 0.02-0.07, knee on belly < 0.03.  7. Late lead: <= 15 % of points-decided bouts see the last-minute leader
     tapped.  8. Brown/black 10 min: mean leg-lock finish / mean choke finish 0.5-0.75; mean sub time 6-9 min.
  11. White field: (a) <= 25 % of misses land on a node worth 3+ to the opponent; (b) no edge > 50 % of one opponent's
     attempts; (c) Wrestler opens with a takedown attempt >= 60 % of bouts, Guard player pulls >= 50 %, overall pull share of
     openings 35-60 %, pulls land >= 0.90.  13. as step 5 (exact).
  16. Even blue field: first scorer wins - printed (80-87 % band shown), not gated (not on stage 1's list).
- Runtime: measured on the first run. If the whole test exceeds ~150 s on a GREEN PC, bar 1d's 4 x 2,000 seeds move to the
  balance runner and the test keeps 400 each - reported, not silent.
- Commits: `S384 GAMETREE1-A: headless balance runner and the calibration bars` then
  `S384 GAMETREE1-A: tuned [T] values (bars 1-8, 11, 13)` with the before/after table in the commit body.

---

## 7. Gym partner, roll line, rule lines  (commit A7)

```
static func roll_week(c: Career, f: Dictionary) -> Dictionary   # every ROLL_EVERY-th Sunday ((c.day / 7) % ROLL_EVERY == 0), not when f has "open_week" (the open ran this Saturday)
     # f.partner created lazily (BjjOpp.partner(f, c.seed)); partner.mat_classes += NoGi.CLASSES_PER_WEEK every Sunday (class time only)
     # walk(f, partner, [plan_of(f), partner.route], 5, rules_for("white", true), rng hash(c.seed|id|day|"roll"))
     # no MOOD (decision: the yardstick stays clean), no morale/records/medals/injuries/film; partner read starts at 0
     # try_once: moves that turned felt since the last roll (rolls[-1].felt vs now) - the chooser takes such an edge the first time it is an option
     # f.bjj_rolls keeps the last 6 {d, how, path, felt[], line}; f.roll_week = the entry for the report
static func roll_line(f: Dictionary, roll: Dictionary) -> String
     # "Rolling with Marta: Ana 4-2 on points (last roll: tapped 3:10). Kimura trap landed 1/2." + "Ana tried the seatbelt and hooks: landed 1/1"
static func rule_lines(w: Dictionary, max_lines: int = 5) -> Array   # notes -> design-7 lines, one per rule, most decisive first
```
week_report row `roll` = {line, how}; the open part shows per bout the path line + its single most decisive rule line (<= 3
lines), the full <= 5 lines stay in row.lines for stage 2's result card.
Bar 14 added to bjj_tree_sim_test: first 40 weeks, coach's pick = the move closest to its next step (felt or owned), opens
entered as they come, no injuries: new felt/owned arrow every 2-4 weeks on average, no gap > 5 weeks; 15-20 roll weeks.
Tests (bjj_tree_test, roll part): roll every 2nd Sunday, none in an open week; morale/w/l/opens untouched by a roll; partner
mat_classes grows, partner bjj/tree never drilled; a move that turned felt is tried once and named in the line; bjj_rolls
capped at 6; no film key written.
- Commit: `S384 GAMETREE1-A: Marta the gym partner, the roll line, one line per hidden rule`.

---

## 8. Week report screen  (commit A8)

`scripts/ui/modals/WeekReview.gd` `_grappler` gains one call after the open label: `t = _tree_lines(v, gr, t, step)` (new
function): per event a short row with a meter tweening from before to after via the existing `_grow` list and a band pulse at
15 (half-yellow, "Ana tried it in rolling"), 30 and 50 (animated meters rule); the folded class line; the off-belt line;
`PathLine_<id>_<n>` per bout; `Leak_<id>` with one `LeakDrill_<id>` button -> `main.act("gdrill", "<id>|<plan>")` (never
auto-set); `RollLine` (design node name). Words: "Ana", "the opponent", names - no pronouns.
Tests: `tests/bjj_tree_report_test.gd` - quick career, `tree:` drill: the review's Drill_ana shows the JSON name; a roll week
draws RollLine with "Marta"; a felt crossing draws its row and pulse; after an entered open: PathLine_ana_0 exists and
LeakDrill_ana sets f.drill only on press; stripe_call_test's week-1 armbar row still reads the same.
- Commit: `S384 GAMETREE1-A: week report - every moved bar tweens, path lines, the leak's Drill, the roll line`.

---

## 9. Playbook centre column (MatTree), Systems modal, edge hover  (commit A9, A9b)

`BjjTree` UI-side functions (pure, tested headless):
```
static func field_model(belt: String) -> Array                         # 12 seeded generate() opponents per belt, cached: "vs the field"
static func route_chance(f: Dictionary, steps: Array, rules: Dictionary, field: Array) -> float   # product of mean p per step (CHAIN from step 2)
static func route_ok(steps: Array) -> bool                              # each step's from == the last step's ok (BASE steps allowed)
static func best_route(f: Dictionary, goal: String, rules: Dictionary, field: Array) -> Dictionary   # {steps, chance, missing} - DFS from standing, owned+BASE edges, <= 5 non-BASE steps
     # goal back -> ends on back_top; mount -> mount_top; legs -> a legal leg-lock submission's tap (white: straight ankle only); points -> max expected points
     # missing = the first unowned move on the best route with that move felt/learning (the Drill chip) when no owned route exists
static func fill(f: Dictionary, goal: String, rules: Dictionary, file: Dictionary = {}) -> Array   # the coach's fill; with a non-empty file and field-best == file-best: the 2nd-best edge at the first fork (stage 2 data; unit-tested now with a hand-made file)
static func set_plan(f: Dictionary, goal: String, steps: Array) -> void   # f.bjj_plan {goal, steps, name}
static func swaps(f: Dictionary, steps: Array, i: int, rules: Dictionary) -> Array   # owned+felt alternatives at step i's fork (same from)
static func costly(f: Dictionary, e: Dictionary, rules: Dictionary, field: Array) -> bool   # mean p_bad >= 0.5 and (bad is an Ana hole or bad_gives >= 2)
static func tip_numbers(f, e, rules, field) -> Dictionary                # {chance, miss_node, answer_owned, points, read_pips}
static func leaks(f: Dictionary, field: Array, rules: Dictionary, n: int = 200, seed: int = 0) -> Array   # top 3 {node, move, plan, lost_pts, taps, visits}; cached per (id, day, levels hash)
static func leak_move(f, node, rules) -> String                          # Drill pick: the out-edge move closest to owned (highest mastery < 30), ties by points
static func reachable(f: Dictionary, rules: Dictionary) -> Array        # nodes reachable on usable+BASE edges from standing, plus one ring
static func links(f: Dictionary) -> Array                               # tree moves of her belt + moves above her belt on an out-edge of a reachable node
static func drill_plan_for(f: Dictionary, move_id: String) -> String    # "move:" (her-belt syllabus) / "tree:" / "ahead:"
```
Default plan (decision, flagged): with no saved plan, plan_of() uses the goal fill with the highest route_chance.

New `scripts/ui/MatTree.gd` (extends VBoxContainer; `static func make(main, c, f) -> Control`; `static var sel := "standing"`):
- `OppChip` - a label in stage 1 (R1 name - style word, from f.field of the next entered open; "No open entered"); becomes a
  button in stage 2 (no dead control now).
- Goal row: `Goal_back`, `Goal_mount`, `Goal_legs`, `Goal_points` (fixed order, ink tiles) -> `main.act("gplan", "ana|goal:<g>")`;
  a goal with no owned route shows its missing move as a Drill chip (`GoalDrill_<g>`); at white Legs reads
  "IBJJF: straight ankle only". `Systems` button -> `main.open_modal({"type": "bjjsystems", "fid": id})`.
- `Plan_route`: 5 slots `Plan_0..4`, node cards and `Edge_<eid>` cards alternating; each edge card: step number, picture,
  name, ONE chip word (LIKELY/EVEN/LONG SHOT), points, miss line ("miss: stays" / "miss: knee shield"), red dashed corner
  when `costly`, "felt" chip, swap glyph when `swaps` is non-empty; click -> `gplan` "ana|swap:<i>"; a learning edge cannot
  be in the plan (its card shows Drill instead). "long: gets read" chip for routes of LONG_AT+ non-BASE steps.
- Node view: `Tree_<sel>` large, ins left, outs right; arrow states owned yellow / felt half-yellow / learning grey (with the
  half-rate note when above her belt) / red dashed miss landing; HOLE stamp; click a node card -> sel = node, re-render; click
  an out-edge that continues from the strip's end -> `gplan` "ana|add:<eid>".
- `Leaks` with `Leak_0..2` tiles, each one Drill button -> gdrill with drill_plan_for().
- Cards: edge picture = assets/ui/moves/<move>.png when shipped; node picture = assets/ui/bjj_nodes/<node>.png when listed
  passed in assets/ui/bjj_nodes/nodes_rows.json; else the glyph path MoveTip._pic uses ("card pending"). No Ludo.
- Hover: every edge and move card -> `MoveTip.attach(card, "edge:<eid>", f)`.
`Playbook._mat_book`: one inserted line `h.add_child(MatTree.make(main, c, f))` between the scroll and the right column; after
the syllabus groups a "LINKS" caps + `_mat_row(main, f, id, BjjTree.mastery(f, id), id == drilling, BjjTree.drill_plan_for(f, id))`
for each links() id. `_mat_row` gets `plan: String = "move:"` (default keeps every existing call) used in the Drill_ act, the
label uses `BjjTree.move_name(id)` (identical for syllabus ids), the chip gains "felt" for 15-29. Width: scroll stretch 0.8,
centre 1.2, card width 104 px - checked on a 1920x1080 screenshot; the right column stays 400 px.
`GrapplerPage.act` new acts: "gplan" ("id|goal:<g>", "id|route:<rid>", "id|swap:<i>", "id|add:<eid>", "id|clear") -> BjjTree
set_plan; ends in main.render() like the others (the Playbook keeps `pick`, so the column never swaps).
Systems modal: `scenes/modals/BjjSystems.tscn` + `scripts/ui/modals/BjjSystems.gd` (build(main, modal)): 8 route picture
cards (one line each: "4 steps - 2 owned - long: gets read"), `Plan it` (gplan route:) and `Drill it` (gdrill route:);
Main.gd: `const BJJSYS := preload(...)` + `"bjjsystems": BJJSYS` in the scene dict. Opened only by the click.
MoveTip / MoveTipInfo / MatPlayer (new functions, existing paths untouched):
- `MatPlayer.play_seq(i: int) -> bool` (plays db()[i] like play_move).
- `MoveTipInfo.info`: `if id.begins_with("edge:"): return _edge(id, f, d)` first; `_edge` fills name (move_name), sport bjj,
  pic = move id, `seq` = film transition when fit == "exact" else -1, `poses` = [from card, ok card], lines = the four numbers in
  two lines ("34% vs the field - miss: knee shield (the field owns the answer)", "+4 points - read 0 of 3").
  `_bjj` reads the level through BjjTree.mastery (identical for syllabus ids) and may say "felt"; TIER_COLOR gains "felt".
- `MoveTip._has_clip` / `_play`: an edge plays `player.play_seq(seq)` only when seq >= 0; otherwise the compact card with a
  new `TipPoses` hbox (two node cards side by side, `_fill_poses(d)`); the lines box is named `EdgeTip` while it shows an edge.
  Never a wrong clip: partial / none / move-only fits never play in stage 1 (film_ok is stage 2).
- Optional board jump `gametree` in TestJump.JUMPS (Playbook, Ana) only if test_jump_test's generic loop accepts it.
Tests: `tests/bjj_tree_ui_test.gd` (1920x1080, quick career, Playbook.pick = "ana", go playbook:0): no TabContainer under the
Playbook; MatTree, Goal_back..points, Plan_route, Tree_standing, Leaks, MatBook, exactly one `MatPlayer` exist; main.modal empty
(nothing auto-opens); press every Button under MatTree in turn (re-finding by name after each render): MatBook and MatPlayer
still there each time, main.modal empty except after Systems (then close it); Goal_back sets f.bjj_plan.goal "back" and fills
>= 1 Edge_ card; hovering an exact-film Edge_ card shows the tip with a MatPlayer whose `_seq` == the film id; an unfilmed edge
shows TipPoses and a hidden clip box; Leak_0's Drill sets f.drill to tree:/move:/ahead:; a Links row Drill_<tree id> sets
tree:<id>; every Label/Button text under MatTree, the Systems modal and the tip matches no pronoun; route_ok/best_route/fill
unit checks (fill one step off with a hand-made file; unscouted = field-best).
- Commits: `S384 GAMETREE1-A: Ana's map on the Playbook - goals, plan strip, node view, leaks, links` and
  `S384 GAMETREE1-A: Systems modal and edge hover cards (exact clips only)`.

---

## 10. Node and edge pose cards (commit A10, only when the PC allows)

- New `bake_nodes(t)` in tools/move_pic_bjj.gd (+ `nodes=1` arg in tools/bake_move_pics.gd): each node's card_pose (scramble 347)
  as an ink card; Ana (red) = the body whose role matches the node's side (top = higher Core; attack/defend/neutral picked by
  the node's lane), the mirror node = the same pose with the other body red. Writes assets/ui/bjj_nodes/<node>.png +
  nodes_rows.json {node: {pose, ana_body, pending}} - a separate folder, so move_pics_test's scan of assets/ui/moves is untouched.
- Then edge cards for the 8 routes' edges without a shipped PNG: the exact film's mid keyframe; no film -> the two node cards.
- Run through `python tools/hidden_desktop.py run --timeout=1500 <godot> --path . --windowed --resolution 1280x720 --audio-driver Dummy --script res://tools/bake_move_pics.gd -- nodes=1 boxing=0 bjj=0`,
  one windowed render at a time, gated. Claude opens every PNG and checks top/bottom and which body is Ana; a wrong or
  unreadable card is `pending: true`, no PNG ships. Not done in this step = everything stays "card pending" (glyph) and the
  report says so.
- Commit: `S384 GAMETREE1-A: node pose cards from our own GrappleMap poses (eyes-checked; the rest pending)`.

---

## 11. Full test pass, exe gate, push  (commit A11)

- Add to tools/run_tests.sh TESTS: `bjj_tree_test bjj_tree_odds_test bjj_opp_test bjj_tree_sim_test bjj_tree_report_test bjj_tree_ui_test`.
- `JOBS=2 sh tools/run_tests.sh` in the background (gated; 2 Godot max) - all of 10.4 plus the new six green; the empty-diff
  check of step 0.5; `rg` the new scripts for `_ready`/`_set` helpers named by us (none) and for PowerShell-written files (none).
- Exe gate (design 9.8, in the built game, not only tests): export (tools/export.sh) and play through hidden_desktop with a
  probe, then live on the operator's screen when he is there: new career -> Ana's Playbook -> Goal_back -> drill the top leak
  -> sim to an open (entered) -> the week report's path follows the plan -> the meter moved on Sunday -> a felt arrow turned
  half-yellow -> a roll line with Marta -> re-plan; click every control; no tabs; screenshots of the page at 1920x1080 saved
  under E:/FightCamp/tmp/s384/gametree1_build/. Male boxer's Playbook opened once for regression. Anything not played is
  reported UNTESTED, never "passed".
- `git push origin claude/gametree1`.

---

## Risks to the 10.4 must-stay-green tests (and the mitigation)

| test | what it reads | risk | mitigation |
|---|---|---|---|
| no_gi_test | Grapplers.day through day 33: opens grew, w+l grew, mat_classes == 142, news names the open | the open now runs BjjTree; a roll must not add Ana's classes | rows keep the shape; add_news text untouched; rolls touch only the partner's classes; NoGi.run_open's own bands test stays on NoGi |
| stripe_call_test | morale moved exactly by the rows' win/how; tough_next erased; week-1 report = armbar via coach, owned | mood/TOUGH must reach the walk; the Sunday branch rewrite | `mood_of` uses the same term incl. TOUGH; `_open` still erases tough_next; the else-branch lines are byte-identical; `how` keeps the "submission" prefix |
| drill_pick_test | win_chance deltas exact; DrillPick buttons; Open_33 row text; Move_seatbelt_escape | GrapplerPage edits | NoGi untouched; Field_<d> is a new sibling, not inside Open_<d>; gdrill keeps accepting coach/open/fav/move: |
| bjj_side_test | promote -> news[0] contains "BJJ classes"; medal members | partner regen at promotion | regen writes no news; BjjSide untouched |
| bjj_mat_test | drilling_for refuses berimbolo; >= 25 filmed; two MatPlayers own worlds | none if MatPlayer only gains play_seq | no edit to play_move/_ready |
| move_tip_test | Mat_kimura's child carries move_tip; one Playbook "MatPlayer" with 2 skeletons; tip player is MatPlayer; TipName "Kimura" | MatTree adding a 3D player; name changes | MatTree has NO 3D player (hover uses the one MoveTip card); _mat_row structure kept; MoveTipInfo edge path is a new early branch only for "edge:" ids |
| playtest_s375_test | Mat_ana opens the mat | none | node names unchanged |
| no_pronoun_test | every script literal + assets/data/*.json | the research JSON's "her belt"; new UI strings | fixed in step 1; Python pre-scan before each commit; UI test scans captions |
| bjj_coach_test, ground_rules, belt_road, theatre, grapple_*, wrestle_chains, tie_clips | their own modules | none | files untouched (empty-diff check) |
| move_pics_test | assets/ui/moves PNGs and rows | node cards in that folder | node cards in assets/ui/bjj_nodes |
| test_jump_test | every TestJump.JUMPS entry runs | an added `gametree` jump | add it only if the generic loop passes |
| save_load_test, recruit_test, injuries_test | career round-trip | new grappler keys | plain dict/array/int/float/string values (store_var), old saves default to {} |
| golden_path_test (not 10.4) | long career runs | a roll walk every 2nd Sunday, leaks at Playbook renders | walks are ~ms; leaks cached per day |

Other risks:
- **Bar 1d** (tree win within 0.05 of win_chance at shares 0.25-1.0) is the hardest bar: win_chance's slope is 0.30 across the
  share, while Ana at share 1.0 owns 34 moves (tree moves at 30) vs a white field of 8-12. The levers are the field [T]
  (OWNED_M, CLASS_SHARE, UNOWNED_M), MF_CEIL and D_NONE. If no [T] combination inside sane ranges meets it, report UNMET with
  the four numbers; do not touch research rows or NoGi.
- Blue band vs class time (step 4 decision) and the two new [T] values (UNOWNED_M, LEAN_W) are design gaps filled by Claude -
  flagged in the report for the operator's board.
- IBJJF re-check may move k_guard (or others) - data change only, reported.
- GrappleMap body roles: an "exact" clip may still show Ana as the blue body; stage 1 plays exact fits only and the exe gate
  watches 3 edge hovers; a wrong one gets its fit downgraded in bjj_tree.json (never a wrong clip).
- Page width at 1920: LEFT + CENTRE + 400 px RIGHT is tight; verified by screenshot, stretch ratios are the lever.
- Sim test runtime; measured, split only with a report (step 6).
- Other live sessions: no file under scripts/fight3d is opened for writing; Main.gd gets two lines (modal registration) -
  conflict-prone only if another branch edits the same dict line; resolve by keeping both entries.
