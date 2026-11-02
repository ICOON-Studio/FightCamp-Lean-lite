# TASK U22 — CURSOR — THE REAL-TIME FIGHT MEETS THE JUDGES IT ALREADY HAS

**Model:** Claude Sonnet 5 (or Composer if the Other Models pool is still
empty) · high effort · Fast off.

## The point

R83 shipped a real-time fight that produces a log of ~950 impact records
(`e2bb15f`). R85 has to **pin ten new scorecards from that engine** and retire
the atomic engine's ten in the same commit. The gap between those two facts is
this task, and it is smaller than it looks.

**Do not write a scoring system.** The game already has one, it is
ruleset-driven, and it is good: `RoundScoring.gd` (R38) turns per-round
counters into points and points into a card, and `JudgePanel.gd` runs three
judges with biases over it. Neither knows or cares which engine produced the
counters.

What is missing is the **adapter**: something that folds a real-time impact log
into the exact per-round counter dictionaries `RoundScoring.round_points`
already reads. Build that and the real-time fight inherits the whole judging
stack for free.

## The contract — these key names are not negotiable

`RoundScoring.round_points(profile, fighter)` reads exactly these off the
`fighter` dictionary (`Godot/scripts/RoundScoring.gd:69-86`). Your output is
its input, so the spelling is a contract:

```
striking_score              float   damage, the primary ABC criterion
lands_round                 int     volume
knockdowns_round            int
control_score               float
takedowns_round             int
position_points_round       float
submission_attempts_round   int
throw_points_round          float
hits_round                  Dictionary  zone -> count
```

Zone keys (`DEFAULT_ZONES`, `:22`): `head_hand`, `head_foot`, `body_hand`,
`body_foot`, `legs`.

### The module

`Godot/scripts/RealtimeRoundStats.gd`, `class_name RealtimeRoundStats`,
statics only, **zero preloads**, no engine state:

```
RealtimeRoundStats.fold(log: Array, side: String, round_number: int) -> Dictionary
RealtimeRoundStats.rounds_in(log: Array) -> Array          # ascending round numbers
RealtimeRoundStats.fold_all(log: Array, side: String) -> Dictionary  # round -> stats
```

`fold` returns one fighter-counter dictionary carrying **every key above**,
for the impacts that `side` **threw** in that round.

### What the log gives you

Each R83 impact event (`FightRealtime._run_impact`) carries:

```
type "action" · tick · t_s · span · round · actor · target
region · force · contact · distance · place
wear (Dictionary) · shock (float) · shocked (bool) · flash_knockdown (bool)
```

`actor` and `target` are `"a"` / `"b"`. `region` is one of the six.
`contact` is one of U20's six: `clean`, `glancing`, `absorbed`, `blocked`,
`slipped`, `missed`.

Mapping rules:

- **`striking_score`** — sum of the `wear` the fighter's blows actually cost
  his opponent. The `wear` dictionary is already `ImpactModel`'s own
  arithmetic; **sum it, do not re-derive damage from `force`.** Two damage
  models that can disagree is the exact failure R83 was shaped to prevent.
- **`lands_round`** — count of impacts that actually connected. `clean`,
  `glancing` and `absorbed` land; `blocked`, `slipped` and `missed` do not.
  (`absorbed` connects and costs 0.25 — it is a land.)
- **`knockdowns_round`** — count of `flash_knockdown == true`.
- **`control_score`, `takedowns_round`, `position_points_round`,
  `submission_attempts_round`, `throw_points_round`** — **`0.0` / `0`**. The
  real-time core has no grappling yet. Emit them anyway: a missing key and a
  zero key are the same number to `round_points`, but only one of them tells
  the next reader the difference between "nothing happened" and "not modelled".
- **`hits_round`** — landed impacts by zone, see the gap below.

## THE ONE REAL GAP — read this before you code

**The log cannot tell a punch from a kick.** The zone vocabulary splits on
limb (`head_hand` vs `head_foot`), and the R83 impact record carries no
technique — `region` says *where it landed*, never *what threw it*.

Do **not** invent a technique field, and do **not** guess. The honest mapping
is by region alone:

```
head_neck  -> head_hand
torso_core -> body_hand
left_arm / right_arm / left_leg / right_leg -> legs
```

with a comment saying plainly that `head_foot` and `body_foot` are **not
producible from this log**, and why. This costs nothing today —
`DEFAULT_ZONES` weights every zone at `0.0`, so no default ruleset scores them
— but a ruleset that turns zone weights on would silently score every kick as
a punch, and the person who turns it on needs to find that written down rather
than discover it. Put it in the digest as a named limitation for whoever adds
techniques to the real-time core.

## The test

`Godot/tests/realtime_round_stats_test.gd`. You have a shell, so module and
test are **one task** — write both.

Assert at least:

1. Hand-built log, hand-computed expected values, exact match. Do not generate
   the fixture from the module.
2. Only the named `side`'s own blows count — an impact where he was the
   `target` must not raise his `lands_round`.
3. Only the named round counts.
4. Every one of the nine keys is present, including the five zeroed ones.
5. `blocked` / `slipped` / `missed` raise `lands_round` by nothing and
   `striking_score` by nothing.
6. `absorbed` **does** count as a land and **does** add its wear. This is the
   one everybody gets wrong: it is the defender's word, it connects, and R83
   only started producing it eight hours ago.
7. An empty log gives a full dictionary of zeroes, never `{}`.
8. **The composition check**: feed your output straight into
   `RoundScoring.round_points(RoundScoring.profile_for({}), stats)` and assert
   it returns a real number. This is the assertion that would have caught
   C63's dead flash knockdown, and it is the reason the module exists.

Then prove it end to end: run a real `FightRealtime` fight, fold every round,
and assert the totals are sane (lands > 0, striking_score > 0, and each
round's lands sum to the whole-fight count). Load `FightRealtime.gd` with
`load()` inside the test function, never a top-level `preload`.

## Owned files

- `Godot/scripts/RealtimeRoundStats.gd` — new
- `Godot/tests/realtime_round_stats_test.gd` — new
- `research/U22_DIGEST.md` — new

**Touch nothing else.** `FightRealtime.gd` is Claude's for R84,
`ImpactModel.gd` is Codex's for C64 (a live task), `RoundScoring.gd` and
`JudgePanel.gd` are shipped and stable — you read their contract, you do not
edit them. `FightSimulation.gd` stays untouched under the rebaseline ruling.

## Push where Claude will find it

You push to a branch, not master, and your mail rides the branch — which is
why the inbox has read `unread=0` while your work sat waiting. **Say the exact
branch name in your message** so it does not have to be hunted for.

## Parse gate, then tests

```
python Godot/tools/check_scripts.py Godot/scripts/RealtimeRoundStats.gd Godot/tests/realtime_round_stats_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/realtime_round_stats_test.gd
```

## Gate

`python Godot/tools/run_tests.py` → **`fails=0` or better** (it reads
`total=199 fails=0` at `e2bb15f`; yours adds one file, so expect `total=200`).
If it comes back red, check `tasklist | grep -ci godot` and re-run any failure
alone before believing it — Q16, the suite's concurrency defect, has not
landed.
