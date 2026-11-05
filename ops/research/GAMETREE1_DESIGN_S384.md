# GAMETREE1 - Ana's game tree (S384, the one design)

Status: design for operator approval (S384 "Yes, design it"). Claude designs, the operator approves.
r2 (S384): the Kalli and John seat reviews are applied - every change and its source is listed in section 12.
Branch claude/gametree1 (main ec292868). No game code changed, no Godot run.
Graph: `ops/research/GAMETREE1_POSITIONS_S384.json` (49 nodes, 135 edges, 80 moves, 8 routes; all checks pass, see its `meta.checks`).
Built from the three S384 drafts (sim won 21.5, player 21, build 21) with the judges' "keep" ideas grafted and every named flaw fixed (appendix A).

How numbers are marked: **[R: source]** = S384 research; **[CODE: file]** = an existing game constant, reused as is;
**[T -> bar N]** = a tuning value, set by bar N in section 10. **UNVERIFIED** = a figure no source was found for (John, S384);
it is used as a tuning value and tuned by the bar named next to it. **(gi)** = a gi study, used for Ana's no-gi only until a
no-gi figure is found. No baseline is invented.

---

## 1. The pitch in 3 lines

1. Ana's game is a map: positions are free, the arrows between them are the moves Ana owns, and drilling turns a grey arrow half-yellow (felt, at 15) and then yellow (owned, at 30).
2. A match is an honest walk on that map: the coach's plan is a route of picture cards, the walk follows it, a miss slides down a bad arrow only when the opponent owns the answer.
3. Tape finds the opponent's holes, and the circuit films Ana's favourite route - the signature that wins her matches is also the one the field is waiting for.

---

## 2. The weekly loop (menus are the game)

| When | The coach does | What it changes |
|---|---|---|
| Any day | Opens Ana's ONE Playbook page. Clicks a goal tile (Back, Mount, Legs, Points); the strip fills with the coach's fill (Ana's best owned route vs the field, one step off once the opponent is scouted, 7); the coach swaps a step at any fork. | `f["bjj_plan"]` |
| Any day | Clicks Drill on a grey arrow, a leak tile or a route. One move a week, as today. | `f["drill"]` = `move:<id>` (unchanged) / `tree:<id>` / `route:<id>` / `ahead:<id>` |
| Sunday | Week report: every bar that moved this week tweens on screen - the drilled arrow +3.2 [CODE: NoGi.DRILL_GAIN], and each class-taught move of her belt +0.45 (3 classes x 30/200, 4.2). At **15 = FELT [T -> bar 14]** the arrow turns half-yellow with a pulse, "Ana tried it in rolling": from now on it is used in opens, at weaker odds. At 30 [CODE: BeltRoad.OWNED_AT] it turns yellow with a pulse (animated meters rule), at 50 [CODE: NoGi.SIGNATURE] it gets the stamp. | `f["bjj"]` / `f["tree"]` |
| Every 2nd Sunday, not in an open week | Rolling with the gym partner (5.5): a 5-minute walk on the current plan against the same club partner; one line and the tape in the week report. | `f["bjj_rolls"]` |
| Entry | Enters an open (unchanged GrapplerPage `enter`). The bracket path is drawn now: 3 named opponents, each with one free style word. | `f["field"]` |
| Every 2 days before the open (stage 2) | Tape: one file entry per session - first the go-to route, then the holes [CODE: OppFile.TAPE_EVERY 2, DEPTH_ALL 3]. Re-plans the strip at a found hole. | `f["bjj_scout"]` |
| Open day | Top bar badge "Open today". Nothing opens on its own. Click -> the Open modal: watch the tape or sim to the end (stage 2; stage 1 resolves on the day as today). | result rows as today, plus `path` |
| After | Week report: one path line per bout, the open's leak and one Drill button. That click is the next week. | - |

Season scale, re-checked in r2 (Kalli 3). From zero a move is FELT after 15 / 3.2 = 4.7 weeks (5 Sundays) and owned after
9.4 (felt to owned is another 4.7); signature 15.6. But almost nothing Ana drills starts at zero: class time teaches every
tree move of her belt (19.5 at the start, so already felt, owned after 3 Sundays of drilling), and her unowned syllabus
moves sit at 9-28 (armbar 28 owned in 1 week, seatbelt escape 22 in 3, knee cut 15 in 5, rear naked choke 12 felt in 1
and owned in 6, guillotine 9 felt in 2 and owned in 7). Paper run of her first 40 weeks with the coach's pick (the move
closest to its next step): 27 new arrows (felt or owned) in 19 different weeks, **one every 2.1 weeks on average**, gaps of
1-3 weeks until week 24 and 5 weeks after it (only fresh 15 -> 30 moves are left). Week 24 is the class-time burst: 200
classes own the last 10 class-taught basics at once, and the report folds them into one line ("Class time: 10 white basics
now owned"). Bar 14 holds the pace. A 4-move route to signature is still most of a year, which matches "an A-game takes most
of the blue-belt years" [R: Gracie Barra; Gold BJJ survey, 2.3-4.4 years a belt]. One new constant: FELT 15.

---

## 3. Match rules (the walk), with numbers

`BjjTree.walk(ana, opp, plans, minutes, rules, rng)` - a seeded paper walk. The same edge table serves both athletes: the
opponent's options at Ana's node X are the edges from `mirror(X)`, landing at `mirror(ok)` / `mirror(bad)`. There is no opponent
code, so the opponent cannot cheat.

### 3.1 Clock
- Match length: BeltRoad.match_minutes(belt) [CODE: white 5 ... black 10].
- **BEAT_S = 22 s [T -> bar 4]** of match time per resolution. r2: a tuning value, not a measured one - the
  "12-18 actions in 311-408 s" is not in the Dos Santos 2023 abstract (422 women's bouts) and the full text was not opened
  (John 6). The nearest measured figure is an effort-to-pause ratio of 6:1 to 9:1 [R: Andreato 2015]. White 5 min = 13-14
  beats; 10 min = 27.
- A 22-s beat covers the 3-s hold rule, so points score on landing [R: IBJJF/ADCC hold rule].

### 3.2 One beat
1. **Actor.** The side holding the initiative acts. Opening initiative: seeded 50/50. A success keeps the initiative (that is what chaining is), a miss or a HOLD passes it [CODE pattern: BjjMatch.resolve on claude/bjjmenu1]. A side standing in a hole has only BASE moves and HOLD, so it mostly gets attacked - the hole is felt, not drawn.
2. **Options.** Owned edges (mastery >= 30), FELT edges (15 <= mastery < 30, weaker odds), BASE edges, HOLD. Learning edges
   (mastery under 15) are not tried in an open - Ana has only drilled them, not tried them in rolling. Edges illegal under the
   open's rules (sec 4.4) are removed.
3. **Choice.**
   - On the plan (standing on the `from` of the next plan step, and the step is usable): take it.
   - Off the plan: the best `score = p x gain - (1 - p) x P_bad x loss`, where gain = edge points + `V(ok)`, loss = bad_gives + `V_other(bad)`, and `V(node) = finish_w x TAP_VALUE` (+ PLAN_PULL when the node lies on the shortest owned path back to the plan). With EPS the chooser takes the second best instead (variety, both athletes).
     - finish_w per node is a research prior [R: Grappling Conjecture 2024/25 position-to-finish conversion: saddle 0.18, 50/50 0.175, mount 0.09, side 0.045, knee on belly 0, others 0.02]; back **0.36 UNVERIFIED [T -> bar 6]** (no source found, John 4). Bar 6 checks they come back out.
     - **TAP_VALUE = 10 [T -> bar 4]**, **PLAN_PULL = 2 [T -> bar 9]**, **EPS = 0.2 [T -> bar 11b]**.
   - Late lead: leading in the last **LATE_S = 60 s [T -> bar 7]**, a side on top or neutral HOLDs. Both athletes, automatic.
   - The opponent weights edges in its style's lanes by **STYLE_W = 2 [T -> bar 11c]**.
4. **Odds** (3.3). Roll.
5. **Success:** move to `ok`, the actor scores `points` (IBJJF: takedown 2, sweep 2, pass 3, knee on belly 2, mount 4, back 4 [CODE: BeltRoad.POINTS]; re-taking a position re-scores). Landing on `tap_win`/`tap_loss` ends the match.
6. **Miss:** with probability **P_bad = min(1, m_ans / 30)** (m_ans = the defender's best mastery among the edge's `answers`) the walk goes to `bad` and the other side scores `bad_gives`. Otherwise it is a reset: the node stays. Either way the initiative passes, and a missed scoring or submission attempt that reset gives the actor +1 advantage (IBJJF near-completion).
   - Why: a failed armbar puts you on the bottom because the opponent stacked out of it - an owned escape. Against nobody's answer, a miss is a reset [R: Williams 2019 (gi); games lesson 5]. Class-taught basics at 19.5 already punish 65% of misses, so white belts are not toothless.
   - BASE edges: a miss lands on `bad`, no points (own movement, nobody to answer).
7. **Read** (3.4) and t += 22 s.
8. **Bell:** points, then advantages, then a seeded referee decision (IBJJF's last tie-break).

### 3.3 Edge odds - one formula
```
p = clamp( BASE[odds, tier] x A x CHAIN x MOOD / (D x READ), 0.03, 0.90 )      BASE edges: p = 0.94, no clamp
```
- **A = mf(m_att)**, the mastery factor: felt `m/30` (15 -> 0.5, 29 -> 0.97; under 15 the edge is not tried); owned `1 + 0.8 x (m - 30) / 70` (50 -> 1.23, 100 -> 1.8). An owned edge at 30 against an answer at 30 is exactly the base rate. The 1.8 ceiling is the measured spread between a kind's average and its best techniques [R: GC 2024/25 kneebar 27.2/15 = 1.8, RNC 1.7-2.1, bodylock takedown 1.67, sub-sweep 1.58] - **[T -> bars 3, 6]** around that.
- **D = max(D_NONE, mf(m_ans))**. **D_NONE = 0.7 [T -> bar 10]**: no owned answer gives the attacker up to x1.43, not the x1.67 a 0-mastery answer would. Direction [R: Williams 2019 (gi), least-used attacks scored most]; size tuned so scouting a hole helps but never decides a bout.
- **CHAIN = 1.15 [T -> bar 9]** on a plan step taken right after the previous plan step landed (any route of 2+). The EA "momentum transitions" idea [R: EA UFC 5 tips], as one multiplier - the defender is late, not absent.
- **READ = 1 + READ_W x r** on plan steps only; **READ_W = 0.6 [T -> bar 9]** (3.4).
- **MOOD** (Ana only) = `1 + MOOD_W x mood`, where mood is exactly NoGi.win_chance's term `(morale - 60) / 400 - TOUGH` [CODE]. **MOOD_W = 5 [T -> bar 1c]** so the morale extremes move her win rate by the same +-0.10 win_chance does.
- **Clamp 0.03-0.90**: every contested edge stays under the guard pull's 94% [R: Williams 2019 (gi)].

**BASE[odds, tier]** - amateur column only where measured; purple = midpoint; brown/black = pro.

| odds | white/blue | brown/black | source |
|---|---|---|---|
| takedown | 0.33 | 0.33 | women's ADCC 33% **UNVERIFIED [T -> bar 5]** (no source found, John 4); R: GC pro 31-37% (mixed) |
| sweep | 0.52 | 0.35 | R: Williams 2019 (gi) mean of scissor 55 / sit-up 38 / X-guard 63; GC 35-36% |
| back_take | 0.60 | 0.35 | R: Williams 2019 (gi) 60% (one study, n=140, thin); pro has no figure -> **[T -> bar 5]** |
| pass | 0.23 | 0.23 | R: GC 2024/25 23-24% (no amateur figure, so flat) |
| submission | 0.16 | 0.16 | R: GC 15-17% per attempt (no amateur figure, so flat - no blanket multiplier) |
| entry (guard entries, grips, ashi, underhook) | 0.50 | 0.50 | **[T -> bar 3]** |
| transition (mount step, knee pop, posture, flatten) | 0.40 | 0.40 | **[T -> bar 5]** |
| escape | 0.30 | 0.30 | **[T -> bar 6]** (the back's ~35% finish rate needs escapes to be hard) |
| base (incl. guard pull) | 0.94 | 0.94 | R: guard pull 94% (Williams 2019, gi) |

Per-move overrides (the move's even-field rate): rear_naked_choke **0.35 [R: ADCC 2022, 34.7%]** (one named year, the same
year as the guillotine and kneebar figures; 2023 was 41.8% and 2024 25.7% - the old 0.29 matched no year, John 4), kneebar 0.27
[R: ADCC 2022, 27.2%], inside_heel_hook 0.25, darce 0.22, anaconda 0.21, guillotine 0.10 [R: ADCC 2022, 9.3%] (most tried,
least finished: the bait edge), mat_return **0.71 [R: GC 2023, 70.8%]** (the old 0.47 had no year, John 4), body_lock_pass 0.37,
leg_drag 0.31 [R: GC 2024/25 best-edge tables]; scissor_sweep 0.55 at white/blue [R: Williams 2019 (gi)].

Worked example - the back leak: Ana reaches the back, RNC at 12, the opponent owns seatbelt_escape at 40 (mf 1.11).
At 12 the choke is still learning, so Ana does not even try it: she holds the back until she loses it, and the report says
"On the back 2:40 - rear naked choke not felt yet (12)". One Sunday of drilling -> 15.2, FELT:
p = 0.35 x 0.51 / 1.11 = **0.16**, and a miss lands her in bottom half guard (P_bad = 1). Owned at 30 (6 Sundays):
p = 0.35 x 1.00 / 1.11 = **0.31**. Signature 50: p = 0.35 x 1.23 / 1.11 = **0.38**. The report tells the coach why, and
what to drill.

### 3.4 The read (long routes get read - the S381 tradeoff on TheRead's curve)
- A plan step shown is one exchange: the watcher's read on that route rises by `TheRead.LOOKS_PER_EXCHANGE (3.0) / TheRead.looks_needed(iq, film)` [CODE; R: Milazzo 2016, 5 looks expert, 16 novice; film x0.8]. BASE steps show nothing.
- `r = min(1, head_start + looks / looks_needed)`; the head start is TheRead.FILM_HEAD_START 0.2 when the watcher has film of the route [CODE].
- Gradual, not a trigger: step k of a route faces the read from steps 1..k-1. A 2-step route is barely read and cashes little; a 5-step route reaches the back with points banked and meets its read at the last step.
- Watcher iq by belt: white 40, blue 55, purple 70, brown/black 85 [ends CODE: TheRead.IQ_LOW/IQ_HIGH; steps **[T -> bar 9]**]. Ana uses the same map; her boxing Ring IQ stays boxing.
- Inside one open, later rounds have watched her earlier rounds: head start on every route she walked that day.

### 3.5 The rows (nothing downstream moves)
`{d, open, win, opp, how}` exactly as today, now **true**: how = "submission (rear naked choke) 3:52" from the walk, or "points 6-2", or
"points 2-2, advantages 1-0". New keys: `path: [[edge_id, actor, hit|miss|reset, t]]`, `end: node`, `opp_id`. Grapplers._open,
morale (+4 / -3 / -6), records, BjjSide medals read the rows as they do now. Old saves without `path` load.

### 3.6 Cut from V1 (each would change nothing measurable, or adds a chore)
Gas/cardio (no stat on main - a978816e is unmerged - and no benchmark per edge); a per-edge minigame [R: Fight Night Champion reviews];
the player choosing whether a counter works [R: gem0303 README]; Stick/Mix and Finish/Points switches (the plan, the late-lead rule
and stage 2's three calls cover them).

---

## 4. Unlock and belt gating

### 4.1 Owning
- Positions are free. Moves are owned. **Owned = mastery >= 30** [CODE: BeltRoad.OWNED_AT]; owning a move owns every edge with its id (kimura alone owns 10 - the natural spine of a first system).
- **Learning (under 15)** edges are drilled but never tried in an open. **FELT (15-29)** edges - the half-yellow arrow,
  "Ana tried it in rolling" - are tried at mf = m/30 when nothing owned scores better. FELT is the second unlock event per
  move, so a move gives the player two arrows to watch (Kalli 3).
- **Signature = 50** [CODE: NoGi.SIGNATURE] - the BJJ scale the Playbook already shows; never MoveMastery's 85 or ComboWords.SIGNATURE_AT.
- **BASE moves** (10: guard pull, sit up, lie back, open the legs, hooks in, push down, walk to north-south, kick free, sit to guard, settle back to half) are everyone's at 100. A node never freezes.
- No filler prerequisites [R: Punch Club lesson]. The only gate is geometry: an edge is used from its own node.

### 4.2 Mastery of a tree move (classes teach the basics - no hand-set seeds)
`BjjTree.mastery(f, move)`:
- syllabus move: `f["bjj"][move]` (unchanged);
- tree move: `min(100, class_part + f["tree"][move])`, class_part = 30 for belts below hers, `30 x min(1, mat_classes / CLASSES_TO_NEXT[belt])` for her belt, 0 above [CODE: BeltRoad.CLASSES_TO_NEXT];
- BASE: 100.

Ana: 130 of 200 classes -> her white tree moves (sprawl, stand up, low single, seatbelt and hooks, dig the underhook ...) start at **19.5**.
A white belt with 130 classes knows the basics but owns none; by blue-ready class time has taught them to owned, drilling adds on top.
No save migration (f["tree"] is a new key, missing = {}), readiness and the syllabus tests are untouched.

Ana's start, computed from the graph: **9 owned moves = 22 owned edges** (inside the 8-12 white band [ESTIMATE, 4.5]),
**23 felt moves = 33 felt edges** (the 20 class-taught white tree moves at 19.5, seatbelt escape 22, knee cut 15, armbar 28),
2 learning (rear naked choke 12, guillotine 9; 6 edges). 28 of 47 nodes are holes for her: 17 with a felt edge she can use and
grow, 2 with only a learning one.

### 4.3 Drilling by belt - scale the cost, never lock (S384 FLOW rule)
- `move:<id>` stays NoGi.week / drilling_for exactly (bjj_mat_test still sees berimbolo refused at white).
- `tree:<id>`, `route:<id>`, `ahead:<id>` go to the new BjjTree.week (dispatched in Grapplers.day BEFORE NoGi.week, because drilling_for silently falls back on an unknown plan). It adds the week's mat classes the same way (`NoGi.classes_of`) and the gain `NoGi.gain_of(f) x HUNGRY (stripe held) x 0.5^n`, n = belts above hers.
- **OFF_BELT = 0.5 per belt [T -> bar 13]**: one belt ahead takes 2x the weeks, two belts 4x. Nothing is locked; the screen shows her reachable nodes plus one ring, never the full chart [R: PoE tree-size complaint, Slay the Spire curated pool, Hades keyed rows].
- Ahead syllabus moves sit in f["bjj"]; BeltRoad.readiness counts only her belt's syllabus, so promotion pace at her belt is unchanged (bar 13). After promotion the head start counts - it was paid for at half gain.
- `route:<id>` drills the route's lowest-mastery move below 50, one move a week, then moves on.
- No decay (as on main; adding it is a separate decision).

### 4.4 Rules legality (a real rule, not a stat floor)
`moves[].ibjjf_min` in the graph: straight ankle lock all belts; kneebar, toe hold, calf slicer, inside/outside heel hook, saddle entry
(reaping), K-guard: brown and up, no-gi adult. **Stage 1 re-checks this table against the current IBJJF rulebook** [R gap]. An illegal
edge never fires, but it trains and shows ("IBJJF: brown and up" on its card). At white and blue the leg-lock lane is the straight
ankle plus defence; leg_lock_escape is a white move, so defending a leg is never a hole.

### 4.5 Belt size bars (used to generate opponents, and as a career check)
White 8-12 owned for coverage; blue 25-36 - both **ESTIMATE**: no study measures how many techniques a belt uses, and
Gracie Combatives' 36 is a curriculum, not a usage count (John 7). Purple = blue + 1 system of 6-10 linked edges at
signature; brown = 2-3 systems [coach writing: Giles, Roger Gracie, Gracie Barra]. Belt time is measured: 2.3 / 3.3 / 3.4 /
4.4 years at white / blue / purple / brown, about 13.3 years to black [R: Gold BJJ survey, 1,948 people].

---

## 5. Holes and scouting

### 5.1 Holes and leaks
- A **hole** = a node where that side owns no non-BASE out-edge. Holes come out of owned sets; no hole is placed by hand.
- Ana has 28 - honest for a white belt, but 28 red tiles is a wall. The Playbook shows her **3 leaks**: the holes the field actually walks her into, ranked by the walk itself (visits x points or taps lost, over 200 seeded walks against her next field). The expected start leaks are the back (RNC 12: she reaches the back and cannot even try the choke), back taken (seatbelt escape 22: the Winter Open loss) and top half guard (her own double leg lands there, knee cut 15). The walk decides; bar 2 checks it.
- The map shows her reachable nodes plus one ring, and the 3 leaks. **V1 has no "full chart" button** (Kalli 6): 49 nodes and 28 holes on one screen is the spreadsheet the page exists to avoid.
- Each leak tile carries one Drill button (the move that would fill it best).

### 5.2 The opponent's game (`BjjOpp.generate(belt, style, rng)`, seeded hash(seed|open|day|slot))
- Name from NoGi.OPP_FIRST/OPP_LAST [CODE]. Style word, one of five lane archetypes: **Wrestler** (standing, kimura_back), **Guard player** (closed_guard, open_guard), **Passer** (passing, top_control), **Half-guard player** (half_guard, escapes), **Leg locker** (leg_lock, open_guard) [genre precedent R: Submission Saga's 6 archetypes]. The style also picks its go-to route among the routes legal at its belt (white: Closed guard sweep to mount or Shot to the back).
- Owned counts by the 4.5 bands; owned masteries uniform **30-50 [T -> bar 1]**, the go-to route at purple+ **50-70 [T -> bar 12]**; tree moves by class_part with a classes share drawn **0.4-0.9 [T -> bar 1]**; iq by belt (3.4).
- Opens can lean the field: NoGi.lean_group(f, o) biases the style draw [CODE], so lean_edge's idea becomes real holes.

### 5.3 The file (stage 2; OppFile pattern [CODE: tape / known / remember])
- Free at the draw: the style word.
- Tape 1: the go-to route. Ana then starts that bout with FILM_HEAD_START 0.2 on it and film looks x0.8 [CODE].
- Tapes 2-3: holes, one per session, in the order Ana's current game reaches them (the file is personal: the holes Ana can use).
- **Scouting makes the numbers true, not bigger.** The sim's truth never changes - a hole works whether known or not. What changes: the strip's chance chips switch from "vs the field" to "vs Rosa Lund" for the parts the file has found, and Ana gets the read on the go-to route. Worth: bar 10.
- `remember()` carries a file into a rematch (`career.bjj_opps`).
- Inside the open: "Watch the other semi" opens one entry on the next opponent.

### 5.4 Ana gets scouted too (one rule, all belts)
A route **has film** when 2+ consecutive plan steps of it landed at any of Ana's last **FILM_OPENS = 3 [T -> bar 12]** opens
(`f["bjj_film"]`). Field opponents arrive with the head start on it. A white field (iq 40, 16 looks) barely profits; a purple+ field
reads a filmed 4-step route by its third step. The most-used route is the most-filmed one [R: Football Manager familiarity;
ADCC leg-lock share swinging 28 -> 22 -> 16% with the defensive meta]. Dropping it for 3 opens (about 15 weeks) clears it.

### 5.5 The gym rolling partner (Kalli 8)
- One fixed club partner, **Marta Kowal** (a name on neither NoGi.OPP list), rolls with Ana every **ROLL_EVERY = 2 weeks
  [T -> bar 14]**, on the Sunday, except in an open week. `BjjOpp.generate(belt, "Passer", seed|"partner")` once, stored in
  `f["partner"]`, and regenerated with the same seed at Ana's belt when Ana is promoted. The partner gains by class time only
  (no drill), so the partner is a fixed yardstick: Ana getting better shows as Ana doing better against the same person.
- A roll is `BjjTree.walk` for 5 minutes on Ana's current plan: white-belt leg-lock rules at any belt (a club roll stays
  safe), no morale, no records, no medals, no injuries, **no film** (the field never sees gym rolls), and the partner's read
  starts at 0 each time. So it is the cheap test of a new route before a real bracket reads it.
- Output: one week-report line and its tape - "Rolling with Marta: Ana 4-2 on points (last roll: tapped 3:10). Kimura
  trap landed 1/2." `f["bjj_rolls"]` keeps the last 6 rolls for the comparison. When a move turned FELT since the last roll,
  the walk tries it once and the line names it ("Ana tried the seatbelt and hooks: landed 1/1").

---

## 6. Systems and the signature

- A **system** is a route: an ordered list of edge ids, each starting where the last one landed (`route_ok`, the TheatreChains.resolve rule at node level). BASE steps are allowed and do not count toward length or read.
- 8 preset systems (graph `routes`): Kimura trap to the back (4), Single-X to the saddle (4), Knee shield to the back (5), Butterfly hooks to single-X (3 + pull and open the legs), De la Riva to the back (3), Pass, pin, mount (4), Shot to the back (4), Closed guard sweep to mount (2). The coach saves his own into `f["bjj_book"]` [CODE precedent: OwnCombos f["book"]].
- **Signature route** = every non-BASE move on it >= 50; the card says "Ana's signature". Its upside is the masteries (A >= 1.23 per step) and the chain; its cost is film (5.4). Bar 12 asks for roughly break-even when filmed by a sharp field, and a clear plus when not.
- **Long routes get read** (3.4). Routes of 4+ steps carry a "long: gets read" chip [CODE: OwnCombos.LONG_AT 4, the boxing long-combo mark]. Bar 9: the best length for an even blue field with film is 3-4, never 1-2 or 5.
- **Swap-pairs**: two edges out of one fork towards the same goal; only one is in the plan [R: Hades Mirror]. Re-planning between bouts is free.

---

## 7. The screen - one Playbook page, picture cards

`Playbook._mat_book` already returns before the tab match for BJJ. LEFT and RIGHT stay; a CENTRE column is added.

```
+-- LEFT: MatBook (unchanged) ---+-------- CENTRE: MatTree (new) ------------------------+-- RIGHT (unchanged) ---+
| belt title, groups, Mat_<id>   | [OppChip] R1 Rosa Lund - Guard player   file o o . .   | MatPlayer 400x440      |
| rows: meter, chip, Watch_,     | GOAL  [Back] [Mount] [Legs] [Points]      [Systems]    |  hover = the edge clip |
| Drill_                         | PLAN  [node]>(edge)>[node]>(edge)>[node]>(edge)>[GOAL] |  or the node pose      |
| + group "Links" (tree moves    |       chip: 34% vs field - miss: [mini] - +4 - read oo  | CoachSteps             |
|   of her belt, ahead moves)    | NODE  [in][in] -> [ NODE ] -> [out][out][out]           | credit line            |
|                                | LEAKS [leak][leak][leak]  each with Drill               |                        |
+--------------------------------+---------------------------------------------------------+------------------------+
```

- **Goal row** - four fixed tiles that never move [R: EA keeps goal tiles in place]: Back, Mount, Legs, Points. A click fills the strip with the coach's fill: Ana's best owned route (highest chance product, at most 5 steps) **scored against the field, never against the file**. A goal with no owned route shows the first missing move as a Drill chip. At white the Legs tile reads "IBJJF: straight ankle only".
  - **The fill is one step off for a scouted opponent (Kalli 5)**, the boxing whiteboard trick. When the file holds anything on the next opponent (the go-to route or a hole), and the field-best route happens to be the best against what the file shows too, the coach takes the field's second-best edge at the route's first fork instead. So against a scouted opponent there is always one swap that beats the fill, and the file's chips (5.3) are where the player finds it; clicking Back every week is never the whole job. Unscouted, the fill is the honest field-best, and repeating it is what the film rule (5.4) punishes. Bar 15.
- **Systems** button -> a modal of the 8 route cards + saved routes (picture cards, one line each: "4 steps - 2 owned - long: gets read"). Clicked, never auto-opened. This keeps the centre lean (the judges flagged the busy centre).
- **Plan strip** - 5 slots, node and edge cards alternating. Each edge card shows its step number, the picture, the name, **one word** and its points, and a short miss line ("miss: stays", "miss: knee shield") (Kalli 4):
  - **LIKELY** (chance 60%+), **EVEN** (35-59%), **LONG SHOT** (under 35%). The bands are display cut points, not sim values.
  - A **red dashed corner** when a miss is costly: the opponent owns the answer (P_bad >= 0.5) and the miss lands in one of Ana's holes or hands over 2+ points.
  - The four numbers move to the **hover tooltip** [R: BJJ DOJO, S375 scan]: chance %, where a miss lands (and whether the opponent owns the answer), points, read pips. The hover also plays the clip (MOVETIP1).
  - A click on an edge cycles the owned and felt alternatives at that fork (swap-pair, marked with the swap glyph). A felt edge shows a "felt" chip; a learning edge cannot go in the plan and shows a Drill button instead.
- **Node view** - the selected node large, its ins left, outs right. Arrow states: yellow = owned (meter), **half-yellow = FELT** (15-29, used in opens at weaker odds), grey = learning (under 15, drillable, never tried in an open; the slower rate is shown when a belt ahead), red dashed = where a miss lands, HOLE stamp on holes. A click on an out-edge that continues from the strip's end appends it.
- **Leaks** - 3 red-dashed tiles (5.1), each with Drill.
- **OppChip** - next opponent; a click toggles the file overlay on node view and strip (stage 2).
- **Hover** on any edge or move card plays its clip in MatPlayer (MOVETIP1) - only when the clip is `exact` or eyes-passed (`film_ok`); otherwise the from and to poses side by side. Never a wrong clip.
- **Words**: one functional line per card, no flavour, never she/her ("Ana", "the opponent").
- **Art**: ink tiles (ink figure on a charcoal tile, yellow motion arrow, marker title, one italic line).
  - Node cards: the node's `card_pose` (GrappleMap position) through tools/move_pic_bjj.gd; the mirror node is the same pose with the other body inked. Eyes check every card for top/bottom and which body is Ana [R: Perchance labels that lied]. 46 of 47 positions have pose ids; scramble uses 347.
  - Edge cards: the 14 shipped BJJ ink PNGs; otherwise the film's mid-keyframe pose card; with no film, the two node poses.
  - **No Ludo** (0/28 BJJ cards passed, S383).
- **Match night (stage 2) - the Open modal**, opened from the top-bar badge:
  - Bracket card (8 slots, 3 rounds [CODE: NoGi.BRACKET]). "Watch R1" plays the **match tape**: the plan strip lights card by card, node cards slide onto a timeline with clock stamps, about 1.5 s a beat. At the 3-5 key beats (a plan step landing, a hole hit, the finish) MatPlayer plays the edge's clip at **real speed** - never sped up [R: Perchance 2.5x read as fast-forward]. "Sim to the end" skips.
  - **3 coach calls** [CODE: CALLS_PER_MATCH 3, bjjmenu1]: the tape pauses at a fork - Back to the plan (the default), Hold it (BASE edges, no risk while ahead), Go now (Ana's best owned submission from here). Calls choose, never buff [R: EA Hybrid lesson].
  - Reveal stamps: when the walk hits an opponent hole a red HOLE stamp drops - "scouted" if the tape had it, "found" (and into the file) if not. When Ana's own hole costs her, the loss card names it with its Drill button (never auto-sets the drill).
  - Between rounds: "Watch the other semi" (5.3). Result card: one line of why per key beat - "Kimura trap 2:10 - Rosa Lund owns no kimura defence (scouted)".
- **Every hidden rule shows up as one line (Kalli 7).** The player never reads the rules; the result card (or, for drilling, the week report) shows each one at most once, and only when it changed a beat's odds by 5% or more or decided it. A rule that cannot produce such a line is cut. All six pass:

  | rule | the one line it produces |
  |---|---|
  | late-lead HOLD (3.2, LATE_S) | "4-2 up with 0:48 left: Ana held the mount to the bell." |
  | CHAIN (3.3) | "Hip bump 1:10, straight off the guard pull: Rosa a step late." |
  | the read (3.4) | "Rosa had seen the kimura trap twice; it was read at step 3." |
  | film (5.4) | "The field had film of the kimura trap from 2 of the last 3 opens: R2 read it from step 1." |
  | MOOD (3.3) | "Morale 82: Ana's attempts sharper today (odds x1.3)." |
  | off-belt rate (4.3, week report) | "Kimura roll to the back +1.6 - a blue-belt move, half rate." |

  Also kept, because each names itself in a beat line: EPS variety ("Ana went for the scissor sweep, not the usual hip bump"), STYLE_W (the style word: "Wrestler: Rosa shot 3 times in 5 minutes") and FELT ("Seatbelt and hooks, felt, missed at 2:40 - owned at 30"). Nothing was cut in r2; the result card stays at 5 lines at most.
- **Node names (new)**: MatTree, Goal_back/Goal_mount/Goal_legs/Goal_points, Systems, Plan_route, Plan_<n>, Edge_<eid>, Tree_<node>, Leaks, Leak_<n>, OppChip, EdgeTip (the hover tooltip), OpenModal, Call_plan/Call_hold/Call_go, RollLine (week report). **Unchanged**: MatBook, Mat_<id>, Watch_, Drill_, MatPlayer, DrillPick, Drill_coach, Drill_open, Mat_ana.

---

## 8. Data model and where it hooks in

**Graph** - `ops/research/GAMETREE1_POSITIONS_S384.json` becomes `assets/data/bjj_tree.json` in stage 1 (no_pronoun_test scans assets/data).
After that the JSON is hand-kept; edge ids e001... are frozen (saved plans store them), new edges append.
- `nodes[]` {id, name, side, mirror, family, lanes, reach_points, finish_w, gm_pose[], card_pose}
- `moves[]` {id, name, lane, kind, belt, src syllabus|tree|base, syllabus, film[], film_fit, ibjjf_min}
- `edges[]` {id, move, owner, lane, odds, from, ok, bad, points, bad_gives, answers[], belt, film {transition, fit}}
- `routes[]` {id, name, lane, steps[edge ids], length}
- Draft fixes already applied (graph `meta.changes_from_draft`): guard pull = BASE landing in closed guard; butterfly sweep -> top half for 2; dogfight_roll white + BASE "settle back to half"; all 71 empty answer lists filled; pronoun-free names and keys; chart ids and chart-derived notes dropped (provenance stays in tmp/s384); legality per move.
- Three technique names match words on the source chart ("Leg drag", "Inside heel hook", "Pull guard") - standard BJJ names, not chart text.

**Save keys** (SaveGame passes dicts through; a missing key = the default):

| key | contents |
|---|---|
| `f["tree"]` | {tree move: drilled mastery} |
| `f["drill"]` | also `tree:<id>`, `route:<id>`, `ahead:<id>` |
| `f["bjj_plan"]` | {goal, steps: [edge ids], name}; re-checked on load (route_ok), falls back to the goal's best route |
| `f["bjj_book"]` | [{name, steps}] |
| `f["field"]` | {open day: [3 opponent dicts]} (regenerable from the seed; cached for tape) |
| `f["bjj_scout"]` | {opp_id: {depth, route, holes[]}} (stage 2) |
| `f["bjj_film"]` | {route id: [open days it fired]} (stage 2) |
| `f["mat_stats"]` | {edge: [tried, landed]} - "Kimura trap landed 2/3 at the Winter Open" |
| `f["partner"]` | the gym rolling partner's opponent dict (5.5), regenerated at a promotion |
| `f["bjj_rolls"]` | [{d, how, path}] the last 6 gym rolls (5.5) |
| open rows | + path, end, opp_id |
| `career.bjj_opps` | {opp_id: opp dict} rematch memory (stage 2) |

**Code**
- `scripts/rules/BjjTree.gd` (pure static; preloads BeltRoad, NoGi, TheRead): load (cached), node, mirror, edges_from, mastery, owned, holes, legal, odds, choose, walk, run_open (same return shape as NoGi.run_open), leaks, best_route, route_ok, week, film_routes.
- `scripts/rules/BjjOpp.gd`: generate, partner (stage 1); tape, known, remember, holes_found (stage 2).
- `Grapplers.day` (line 19): drill prefix tree:/route:/ahead: -> BjjTree.week, else NoGi.week (unchanged). `Grapplers._open` (line 34, the only run_open caller): NoGi.run_open -> BjjTree.run_open. Ships ON, no flag.
- `Grapplers.week_report`: + {path line, leak {node, move, lost_pts, taps}, felt / owned events, roll line (5.5)}.
- `Playbook._mat_book`: + the centre column; `_mat_row` reused for the Links group (Drill_ -> act gdrill `ana|tree:<id>`).
- `GrapplerPage`: Tape button (stage 2). MatPlayer / MoveTip: play an edge's film id.
- **Unchanged**: NoGi.run_open, win_chance, week, drilling_for (kept as calibration and fallback with their tests), GroundRules (9 positions), BeltRoad.SYLLABUS, BjjFilm (wrong-clip fixes are a separate row, BJJFILMFIX1, using the better ids found: 717, 720/701, 621, 1337, 1544/1022, 1237, 1297/1383, 1638, 1097/1168, 1695, 1831/775).
- **Later** (after claude/bjjmatch1 lineage merges): BjjMatch.classify + core height map GrappleMap poses onto tree families, TAG_SYLLABUS onto edges; BeltMatch calls BjjTree.odds (one formula, not a copy); a match path replays as a film chain checked by TheatreChains.resolve.

---

## 9. Stages - each one playable in the .exe

### Stage 1 - GAMETREE1-A "The tree decides the opens"
1. `assets/data/bjj_tree.json` from the research graph; IBJJF legality re-check.
2. `BjjTree.gd`: data, mastery (class_part), odds, legal, choose, walk, run_open, leaks, best_route, route_ok, week (tree:/route:/ahead:, FLOW scaling).
3. `BjjOpp.generate` (styles, owned counts, go-to route, iq) and the bracket path drawn at entry (style word shown).
4. Wiring: Grapplers.day dispatch, Grapplers._open swap, week report path line + leak + Drill.
5. Headless balance runner tunes every [T] against bars 1-8, 11, 13.
6. Playbook centre: goal row (coach fill one step off, 7), plan strip with the one-word chip and the costly corner (numbers in
   the hover tooltip), node view with owned / felt / learning arrows, leaks, Links group, Systems modal. Cards: shipped ink PNGs + node pose cards rendered by move_pic_bjj.gd when the PC is free (eyes-checked); "card pending" until then.
7. FELT step (15) in BjjTree.mastery / options; the gym partner and the roll line (5.5); the result-card rule lines (7).
8. Exe gate: new career -> Ana's Playbook -> Goal_back -> drill the top leak -> sim to an open -> the report's path follows the plan -> the meter moved on Sunday -> a felt arrow turned half-yellow -> a roll line with the partner -> re-plan. Click every control; no tabs; screenshots of the page.

### Stage 2 - GAMETREE1-B "Match night and the file"
1. `BjjOpp` tape / known / remember, Tape on GrapplerPage, OppChip overlay, chips switching to opponent odds for found parts.
2. The Open modal: match tape, real-speed clips at key beats, 3 calls, HOLE stamps, watch the other semi, result card.
3. Film of Ana (`f["bjj_film"]`), in-open head start, signature stamp, saved routes.
4. `film_ok`: eyes on every partial clip before hover plays it; hand BJJFILMFIX1 its id list.
5. Bars 9, 10, 12. Exe gate: play it live with Ana (tape, plan at a hole, watch R1, a call, the report) and the male boxer for regression.

Nothing is thrown away: stage 2 only adds keys, tiles, a modal and calls on top of stage 1's data, resolver and page.

---

## 10. Bars and tests

### 10.1 Structural - `tests/bjj_tree_test.gd`
- 47 positions + 2 endings; mirror is an involution; every edge's from/ok/bad exists; every node reachable from standing; 0 dead ends.
- All 42 syllabus ids on 1+ edge; every non-BASE edge has 1+ answer; every answer is a move; every film id exists in graph.json or is null; every route passes route_ok.
- Edge ids are a superset of the frozen list; every string and key is pronoun-clean; a legality row covers every move.
- Ana's start: 9 owned moves, 22 owned edges, 23 felt moves, 33 felt edges, 2 learning (golden); tree moves at 19.5.
- Odds exact (`bjj_tree_odds_test`): 30 vs 30 = BASE; m 100 = x1.8; m 15 = x0.5; m 14.9 = never an option in an open (learning); no answer = x1/0.7; clamps 0.03/0.90; BASE 0.94.
- Chip: p 0.60 = LIKELY, 0.59 = EVEN, 0.34 = LONG SHOT; costly corner only when P_bad >= 0.5 and the miss lands in a hole or gives 2+.
- Rules: same seed -> same walk; a miss with the defender's answer at 0 never leaves the node; rows match run_open's text format; no illegal edge fires at an IBJJF white open; dispatch: `tree:` never reaches drilling_for, and mat_classes still grows.

### 10.2 Calibration - `tests/bjj_tree_sim_test.gd` (seeded; 400 seeds unless noted)
1. Ana at start vs a white field: (a) per-bout win 0.49-0.59 (NoGi.win_chance(Ana) = 0.54 +- 0.05); (b) open mean wins 0.7-1.4, golds 40-120 (the no_gi_test bands); (c) morale 100 / 20 moves it by +-0.10 +- 0.03; (d) |tree win - win_chance| <= 0.05 at readiness shares 0.25, 0.5, 0.64, 1.0 (2,000 seeds).
2. Ana's start leaks: the top 3 include back_top or back_bottom; holes she actually visits in 200 walks: 6-14.
3. Even brown women's field, IBJJF: sub rate 45-60% [R: No-Gi Worlds 2022 women brown/black 54%]; chokes 40-55 / arms 24-36 / legs 19-31% [R: chokes 47 / arms 30 / legs 25 - 27 chokes, 17 arm locks, 14 leg locks (FloGrappling 2022); r2 fix, the r1 text had arms and legs swapped]; RNC the top single finish (if not, the tree is wrong). White field: sub rate 30-55%, RNC still top.
4. Submission attempts: brown 0.5-0.75 a minute [R: GC 2025, 3.1 per 5 min]; white 5 min: 2-4 a bout.
5. Scoring events (brown): back takes the most frequent [R: ADCC 2019, 27 events, ~40% of points]; mount / pass events 0.3-0.7 [R: 7 / 14].
6. Node finish conversion (brown): back 0.30-0.40 (UNVERIFIED: the 0.36 it brackets has no source found; this bar tunes it), saddle and 50/50 0.14-0.21, mount 0.07-0.12, side 0.02-0.07, knee on belly < 0.03 [R: GC 2024/25].
7. Late lead: a leader in the last minute gives up a tap in no more than 15% of points-decided bouts.
8. Timing (brown/black 10 min): **mean** leg-lock finish time / **mean** choke finish time 0.5-0.75 [R: WNO 2022 averages 5:17 / 8:38 (FloGrappling); 6:06 / 9:41 not re-checked]; mean sub time 6-9 min [R: WNO 7:39, read as an average too]. r2: these are averages, not medians (John 4), so the sim reports means.
9. Plan length (stage 2): even blue field with film, Stick to plan: best route length 3 or 4, never 1-2 or 5; vs an iq-40 field, 4-5 is best.
10. Scouting worth (stage 2): 2 tapes (route + 1 targeted hole) vs none: per-bout win +0.05 to +0.15.
11. Honesty and variety (white field): (a) of all misses, <= 25% land in a node worth 3+ to the opponent [R: Williams 2019 (gi), a miss is usually a reset]; (b) no single edge > 50% of one opponent's attempts; (c) a Wrestler opens with a takedown attempt >= 60% of bouts, a Guard player pulls >= 50%; overall guard-pull share of openings 35-60% [R: amateur study, ~50%], pulls land >= 0.90.
12. Two-sided signature (stage 2): a purple Ana with a signature route vs the same edges at 49 - with film: within +-0.03; without film: +0.04 to +0.10.
13. Ahead drilling: one belt ahead takes exactly 2x the weeks, two belts 4x; readiness at her belt unchanged by it.
14. Pace (Kalli 3): Ana's first 40 weeks, coach's pick (the move closest to its next step), no opens lost to injury: a new felt or owned arrow on average every 2-4 weeks, no gap over 5 weeks; a gym roll in 15-20 of the 40 weeks. Paper check S384 r2: 27 arrows in 19 weeks, mean gap 2.1, max 5. Levers: FELT, ROLL_EVERY.
15. Coach fill (Kalli 5, stage 2): against an opponent with a file, the best single swap beats the coach's fill by 0.03+ on the route's chance product in >= 90% of 200 seeded plans; unscouted, no single swap beats the fill against the field.
16. First scorer (John 7): in an even blue women's field the side that scores first wins 80-87% of bouts [R: Sports 2026, 87% in women's bouts].

### 10.3 UI - `tests/bjj_tree_ui_test.gd`
For sport bjj: no TabContainer; MatTree, Goal_back, Plan_route, Tree_standing, Leaks exist; clicking every control never swaps the column;
hovering an exact-film edge starts MatPlayer; an unfilmed edge shows two poses, never a clip; no she/her on any caption.

### 10.4 Must stay green, numbers untouched
ground_rules_test, belt_road_test, no_gi_test, drill_pick_test (win_chance deltas exact), stripe_call_test, bjj_side_test, bjj_mat_test
(berimbolo refused through drilling_for, >= 25 filmed), bjj_coach_test, move_tip_test (Mat_kimura, MatPlayer), playtest_s375_test
(Mat_ana), no_pronoun_test (scans bjj_tree.json), theatre_test, grapple_db/graph/pose/grip/timing/contact tests, wrestle_chains_test,
tie_clips_test, move_pics_test, test_jump_test, recruit_test, injuries_test. New behaviour comes from new functions only.

### 10.5 Tuning values (every one has its bar)
| value | start | bar |
|---|---|---|
| TAP_VALUE | 10 | 4 |
| PLAN_PULL | 2 | 9 |
| EPS | 0.2 | 11b |
| STYLE_W | 2 | 11c |
| LATE_S | 60 s | 7 |
| D_NONE | 0.7 | 10 |
| CHAIN | 1.15 | 9 |
| READ_W | 0.6 | 9 |
| MOOD_W | 5 | 1c |
| mf ceiling | 1.8 | 3, 6 |
| entry / transition / escape base | 0.50 / 0.40 / 0.30 | 3 / 5 / 6 |
| pro back_take base | 0.35 | 5 |
| field owned mastery / classes share | 30-50 / 0.4-0.9 | 1 |
| purple+ route mastery | 50-70 | 12 |
| iq steps blue / purple | 55 / 70 | 9 |
| OFF_BELT | 0.5 a belt | 13 |
| FILM_OPENS | 3 | 12 |
| BEAT_S (r2: not measured) | 22 s | 4 |
| FELT | 15 | 14 |
| ROLL_EVERY | 2 weeks | 14 |
| takedown base (UNVERIFIED 33%) | 0.33 | 5 |
| back finish_w (UNVERIFIED) | 0.36 | 6 |

Everything else is research or existing code: KIND_BASE (bar the UNVERIFIED takedown row), overrides, guard pull 0.94, finish_w, IBJJF points, OWNED_AT 30,
SIGNATURE 50, DRILL_GAIN 3.2, HUNGRY 1.15, TheRead constants, OppFile TAPE_EVERY/DEPTH_ALL, LONG_AT 4, CALLS_PER_MATCH 3.

---

## 11. Open taste questions for the operator (max 3)

1. **Which points do Ana's opens use?** IBJJF (back 4, mount 4, guard pull free, heel hooks brown+) or ADCC-style (back 3, mount 2, pulling costs 1 in the scoring half, leg locks open)?
   *Claude's answer: IBJJF for the opens now (BeltRoad.POINTS already is IBJJF, and Ana's belt road is IBJJF); an ADCC-style invitational comes later as its own event type.*
2. **Purple leg locks: keep the real friction?** Under IBJJF, Ana can train kneebar and toe hold at purple but cannot use them until brown.
   *Claude's answer: keep it real - the cards say "IBJJF: brown and up" - and add one sub-only open to the calendar later so a purple leg-locker has somewhere to cash in.*
3. **Match night pace.** The tape moves at about 1.5 s a beat (a 5-minute white bout is about 20 s), and the clips at the 3-5 key beats play at real speed, with "Sim to the end" always there.
   *Claude's answer: yes, ship that pace. The cards are a summary, and the film is never sped up. The operator rejected fast-forward-feeling animation, and that rule stays intact.*

---

## 12. S384 review: what changed (r2)

Two seat reviews: `ops/research/KALLI_GAMETREE1_S384.md` (game design) and `ops/research/JOHN_GAMETREE1_S384.md` (real-world
numbers). John's points are fact fixes and are all applied. Kalli's points are design opinions; Claude is the designer and
adopted points 3-8 as its own decisions (1-2 were praise, kept as they are).

| # | change | where | source |
|---|---|---|---|
| 1 | No-Gi Worlds 2022 women's brown/black finish split is chokes 47 / arms 30 / legs 25 (r1 had legs 29 / arms 24); bar 3 bands now chokes 40-55 / arms 24-36 / legs 19-31 | 10.2 bar 3 | John 3 |
| 2 | RNC per-attempt rate 0.29 -> **0.35, ADCC 2022 (34.7%)**, the same named year as the guillotine and kneebar figures; worked example recomputed | 3.3 | John 4 |
| 3 | mat_return 0.47 (no year) -> **0.71, GC 2023 (70.8%)** | 3.3 | John 4 |
| 4 | WNO 5:17 / 8:38 (and 7:39) are averages: bar 8 now compares means | 10.2 bar 8 | John 4 |
| 5 | Back conversion 0.36 and the women's ADCC 33% takedowns marked UNVERIFIED, each a tuning value with its bar (6 and 5) | 3.2, 3.3, 10.2, 10.5, graph meta | John 4 |
| 6 | Williams 2019 flagged as gi data wherever it is used (guard pull 94, sweeps, back take 60, scissor 0.55, miss = reset, clamp) | 3.2, 3.3, 10.2 | John 5 |
| 7 | BEAT_S 22 s relabelled a tuning value (bar 4); the 12-18 actions figure is not in the abstract | 3.1, 10.5 | John 6 |
| 8 | Technique-count bands (white 8-12, blue 25-36) marked ESTIMATE; belt years from the Gold BJJ survey added; first-scorer bar 16 (80-87%) | 4.2, 4.5, 10.2 | John 7 |
| 9 | How white/blue bouts end (sub / points / advantages / referee) has no amateur source; the one site found (42/38/12/8, IBJJF overall) has no stated method, so it is noted here and not used as a bar | - | John 8 |
| 10 | **FELT step at 15**: "Ana tried it in rolling", a half-yellow arrow used in opens at weaker odds; under 15 a move is learning and never tried in an open. Every moved bar tweens on Sunday | 2, 3.2, 3.3, 4.1, 7 | Kalli 3 |
| 11 | Pace re-checked: from zero felt 4.7 / owned 9.4 weeks, but Ana's real moves start partway; paper run of her first 40 weeks gives a new arrow every **2.1 weeks** (max gap 5); bar 14 holds it | 2, 10.2 bar 14 | Kalli 3 |
| 12 | Edge chip = **one word** (LIKELY / EVEN / LONG SHOT) + a red dashed corner when a miss is costly; chance, miss landing, points and read pips move to the hover tooltip | 7, mockup | Kalli 4 |
| 13 | Coach's goal fill is scored against the field and is **one step off for a scouted opponent**, so a swap at a fork is a real choice; bar 15 | 7, 10.2 bar 15 | Kalli 5 |
| 14 | 3 leaks + the reachable ring only; **no full-chart button in V1** | 5.1 | Kalli 6 |
| 15 | Every hidden rule (HOLD, chain, read, film, mood, off-belt rate) gets one result-card line, with an example each; nothing had to be cut | 7 | Kalli 7 |
| 16 | **Gym rolling partner** Marta Kowal: every 2nd Sunday, a 5-minute roll on the current plan, no film, no morale - a yardstick and a cheap route test | 2, 5.5, 8 | Kalli 8 |
| 17 | Mockup: one-word chips, the costly corner, a hover tooltip with the four numbers, the FELT state in the moves list and the map legend, a roll line, top bar "Gear" -> "Menu" (S381 rename) | docs/mockups/S384_gametree.png | Kalli 4, 3, 8; S381 |

Not changed: Kalli 1-2 (the one map is both match and unlock tree; a miss costs only against an owned answer) and John 1-2
(clock, points and leg-lock legality were right; stage 1 still reads the IBJJF illegal-techniques page itself).

---

## Appendix A - what came from where, and the flaws fixed

| From | Kept |
|---|---|
| sim (winner) | one mirrored edge table (no opponent code); [R]/[T]-tagged numbers with bars; multiplicative odds with an even 30-vs-30 base; class_part for tree moves (19.5 at start); 3 leaks, not 28 tiles; ahead drilling; IBJJF legality; calibration on win_chance |
| player | match night: tape, real-speed clips, 3 calls that choose, HOLE stamps scouted/found, watch the other semi, result card; grey -> yellow pulse; one style word; film of Ana's most-used route over the last 3 opens; amateur/pro split per kind; guard pull to closed guard; five lane styles |
| build | a miss is a disaster only when the defender owns the answer; all answer lists filled; early, playable stage 1 with an .exe gate; calibration at 4 readiness shares; film checked against node family and side |

| Flaw named by the judges | Fix |
|---|---|
| sim: no match night | Stage 2 Open modal (sec 7) |
| sim: LOOSE 1.5 applied to every kind | amateur column only where measured (sweep, back take, scissor); subs and passes flat |
| sim/player: every miss goes to the bad node | P_bad = min(1, m_ans / 30); otherwise a reset |
| sim: heavy scope, UI at stage 5 | 2 stages, both playable; UI in stage 1 |
| sim: Sa/(Sa+So) initiative, Stick/Mix, Points switch | initiative = success keeps / miss passes; switches cut; late-lead rule + 3 calls |
| sim: film of Ana only from purple | one film rule at all belts, scaled by watcher iq |
| player: hand-set seeds for 19 moves | class_part from mat_classes (no seeds, no migration) |
| player: busy centre column | systems in a modal; centre = goal row, strip, node view, leaks |
| player: wide hole rule, x1.67 swing | hole = no owned out-edge; D floor 0.7, bar 10 caps scouting worth |
| player: e004 change + save migration | e004 change kept (BASE pull to closed guard); no migration (f["tree"] is new) |
| build: m_ans = 0 on chained steps | CHAIN x1.15 |
| build: read as a binary trigger at 0.72 | gradual READ = 1 + 0.6 r |
| build: tree moves at 0, not taught | class_part |
| build: /200 term copied from an unmerged branch | own formula in BjjTree; BjjMatch calls it after the merge |
| build: off-belt drilling only in stage B | stage 1 (FLOW rule) |
| bjj: butterfly sweep to mount | top half guard, 2 points |
| drafts: one-belt-ahead only, two locked | 0.5 per belt, nothing locked |
