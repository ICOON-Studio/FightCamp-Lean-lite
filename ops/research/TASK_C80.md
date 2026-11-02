# TASK C80 — CODEX — THE BLIND CONTRACT TEST FOR `FightStageDirector`

Model: gpt-5-codex, effort HIGH, Fast OFF.
Owner: codex. Task id: C80.

## THE SPLIT, AND WHY YOU MUST NOT PEEK

This is the tenth blind-contract test in this project and the split has paid
every single time — C79 even settled a policy the contract had left open.

**You write the test from THIS FILE ALONE.** `Godot/scripts/FightStageDirector.gd`
is being written by Claude in parallel and **may not exist on master when you
start**. That is deliberate and it is the strongest blindness this project has
ever had: you cannot read an implementation that has not been written.

**DO NOT open `Godot/scripts/FightStageDirector.gd`** at any point, even after it
lands. Write every assertion from the contract below, then run it.

**If your test and the module disagree, that is the POINT.** Report the
disagreement in your `agent_comms.py send` line. **Do NOT edit your test to agree
with the module** — a test rewritten to match an implementation only ever agrees
with it, which is the whole failure the split exists to prevent.

## Owned files

- `Godot/tests/fight_stage_director_test.gd` — **NEW, yours, the only file you create.**
- `research/C80_DIGEST.md` — your digest.

Do NOT edit `Godot/scripts/FightStageDirector.gd`, `FightBeatAdapter.gd`,
`FightRealtime.gd`, `HANDOFF.md`, `CURRENT_STATUS.md`, or any other test.

## Test tier (do not exceed it)

**A NEW TEST FILE ONLY.** Parse gate plus THAT ONE TEST. A new test file cannot
break another test, so a full-suite run here buys nothing and costs twenty
minutes. The full suite is Claude's once, at integration.

```
python Godot/tools/check_scripts.py Godot/tests/fight_stage_director_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stage_director_test.gd
```

## Sequencing

1. Write the whole test from the contract below. Do this FIRST, before fetching.
2. `git fetch origin && git rebase origin/master` until
   `Godot/scripts/FightStageDirector.gd` exists. It will land within the hour.
3. Run it. **Do NOT push a test that cannot run** — a red file on master is worse
   than a late one.
4. Push, digest, one line of mail.

---

# THE CONTRACT

## What the module is

`Godot/scripts/FightStageDirector.gd` — **pure static, ZERO preloads.** It is the
translator between a presented beat and what two 3D bodies do. It owns no engine,
no loop and **no RNG**; it draws no random numbers and never calls `randi`,
`randf` or `RandomNumberGenerator`. Two runs on one seed must produce identical
frames.

It is loaded with `load("res://scripts/FightStageDirector.gd")` and every entry
point is `static func`.

## Where its input comes from (context — do NOT test these, they are already tested)

`FightBeatAdapter.advance_beat(state)` returns a **beat**. A beat is one of:

- `{"type": "fight_already_over"}` — nothing else.
- `{"type": "no_action", "beat": int, "tick_from": int, "tick_to": int,
   "span": float, "round": int, "candidates": int, "dropped": int}`
- `{"type": "action", ...the same keys..., plus:}`
  `"actor_side"` (`"a"`/`"b"`), `"target_side"` (`"a"`/`"b"`),
  `"target_region"`, `"target_body_region"` (same value, both spellings),
  `"landed"` (bool), `"outcome"`, `"technique_name"`,
  `"animation_family"`, `"range_band"` (always `""`),
  and, when the underlying impact carried them: `"tick"`, `"t_s"`, `"force"`,
  `"contact"`, `"distance"`, `"wear"` (a **Dictionary** of region→amount),
  `"shock"`, `"shocked"`, `"knockdown"`, `"flash_knockdown"`,
  `"trauma_site"`, `"trauma_kind"`, `"trauma_pips"`.

`FightBeatAdapter.state_view(state)` returns a **view**:
`{"round", "phase", "tick", "t_s", "over", "resting", "separation", "fighters", "log"}`.

**The engine's six body regions**, and there are no others:
`head_neck`, `torso_core`, `left_leg`, `right_leg`, `left_arm`, `right_arm`.

**The engine's six contact values**, and there are no others:
`clean`, `glancing`, `absorbed` (these three are LANDED);
`blocked`, `slipped`, `missed` (these three are NOT).

## API — exact names, exact argument order, exact strings

### 1. Role constants

```
const ROLE_IDLE       := "idle"
const ROLE_STRIKE_HEAD := "strike_head"
const ROLE_STRIKE_BODY := "strike_body"
const ROLE_STRIKE_LEG  := "strike_leg"
const ROLE_REACT_HEAD  := "react_head"
const ROLE_REACT_BODY  := "react_body"
const ROLE_REACT_LEG   := "react_leg"
const ROLE_BLOCK       := "block"
const ROLE_SLIP        := "slip"
const ROLE_KNOCKDOWN   := "knockdown"
```

### 2. `static func required_roles() -> PackedStringArray`

**THE SHOPPING LIST.** Every role `frame()` can ever emit, in exactly this order:

```
["idle", "strike_head", "strike_body", "strike_leg",
 "react_head", "react_body", "react_leg",
 "block", "slip", "knockdown"]
```

Ten entries. No duplicates. **This is the list a clip purchase is sized against**,
so assert its exact contents and its exact order.

### 3. `static func role_for_strike(region: String) -> String`

What the ACTOR's body does.

| region | returns |
|---|---|
| `head_neck` | `strike_head` |
| `torso_core` | `strike_body` |
| `left_leg`, `right_leg` | `strike_leg` |
| `left_arm`, `right_arm` | `strike_body` |
| anything else, including `""` | `strike_body` |

The arm rows and the fallback both resolve to `strike_body` deliberately: R84
set the arm strike probability to 0.00 so an arm is never a target, and a body
shot is the least specific claim the stage can make. The function must still be
TOTAL — it never returns `""` and never pushes an error.

### 4. `static func role_for_react(region: String, contact: String) -> String`

What the TARGET's body does. **Contact is checked first, region second.**

| contact | returns |
|---|---|
| `missed` | `idle` |
| `blocked` | `block` |
| `slipped` | `slip` |
| `clean`, `glancing`, `absorbed` | by region, see below |
| anything else, including `""` | `idle` |

For the three landed contacts, by region:

| region | returns |
|---|---|
| `head_neck` | `react_head` |
| `torso_core` | `react_body` |
| `left_leg`, `right_leg` | `react_leg` |
| `left_arm`, `right_arm` | `react_body` |
| anything else | `react_body` |

**The unknown-contact row is G42 and it is the most important assertion in this
section:** a contact word the module does not recognise produces `idle`, never a
reaction. The stage does not claim a man was hurt by something the engine did not
score.

### 5. `static func hand_for(beat: Dictionary) -> String`

Returns `"lead"` or `"rear"`, and nothing else.

The engine **does not name a hand** — at 20 Hz an impact is a force arriving at a
region. So the stage picks one, and the pick must be a pure function of the beat
so that two runs on one seed present the same clips. The rule:

```
"rear" when int(beat.get("tick", 0)) is ODD
"lead" when it is EVEN
```

A beat with no `tick` key is even (0) and therefore `"lead"`.

### 6. `static func placement(separation_m: float, options: Dictionary = {}) -> Dictionary`

**The engine owns translation** (G42). This converts the engine's separation into
two marks. It never invents a distance.

Options, all optional:

| key | default | meaning |
|---|---|---|
| `centre` | `Vector3.ZERO` | midpoint between the two |
| `axis` | `Vector3(1, 0, 0)` | direction from A to B; normalized internally |
| `min_separation` | `0.35` | |
| `max_separation` | `4.0` | |

Returns:

```
{
  "separation": float,   # the CLAMPED value, so a caller can see it moved
  "a": {"position": Vector3, "facing_deg": float},
  "b": {"position": Vector3, "facing_deg": float},
}
```

- `a.position == centre - axis_normalized * (clamped / 2.0)`
- `b.position == centre + axis_normalized * (clamped / 2.0)`
- Each faces the other. `facing_deg` is the Y rotation in DEGREES such that the
  body's forward (Godot's `-Z`) points at the opponent:
  `rad_to_deg(atan2(-to_opponent.x, -to_opponent.z))` — note BOTH negations;
  `atan2(x, z)` without them is 180 degrees out and stands the two men back to
  back. With the default `+X` axis that is **`-90.0` for `a` and `90.0` for `b`**.
  (CORRECTED 2026-09-10: this contract originally said `90.0`/`-90.0` and was
  wrong. Verified against `Transform3D().looking_at()`, which returns -90.)
- A separation below `min_separation` clamps up; above `max_separation` clamps
  down. A negative or `NAN` separation clamps to `min_separation`.
- An `axis` of zero length falls back to `Vector3(1, 0, 0)` rather than dividing
  by zero.

### 7. `static func frame(beat: Dictionary, view: Dictionary = {}, options: Dictionary = {}) -> Dictionary`

**THE MAIN VERB.** Returns:

```
{
  "kind": String,        # "action" | "idle" | "over"
  "beat": int,           # beat["beat"], 0 when absent
  "round": int,          # beat["round"], else view["round"], else 0
  "span": float,         # beat["span"], else 0.0
  "separation": float,   # the clamped value placement() used
  "a": <side frame>,
  "b": <side frame>,
}
```

**Both `"a"` and `"b"` are ALWAYS present**, on every kind, without exception.

A **side frame** is:

```
{
  "role": String,        # one of required_roles()
  "hand": String,        # "lead" | "rear"
  "region": String,      # the engine's region word, or "" 
  "position": Vector3,
  "facing_deg": float,
  "rises": bool,
}
```

**The three kinds:**

**`"over"`** — when `str(beat.get("type", "")) == "fight_already_over"` **OR**
`bool(view.get("over", false))` is true. The over check wins over everything
else. Both sides: `role` `idle`, `hand` `"lead"`, `region` `""`, `rises` false.

**`"idle"`** — any other beat whose `type` is not `"action"` (in practice
`"no_action"`). Both sides: `role` `idle`, `hand` `"lead"`, `region` `""`,
`rises` false.

**`"action"`** — `type == "action"`. Let `actor = str(beat.get("actor_side",""))`,
`target = str(beat.get("target_side",""))`, `region = str(beat.get("target_region",""))`,
`contact = str(beat.get("contact",""))`.

- The **actor's** side frame: `role = role_for_strike(region)`,
  `hand = hand_for(beat)`, `region = region`, `rises = false`.
- The **target's** side frame:
  - `role = ROLE_KNOCKDOWN` when `bool(beat.get("knockdown", false))`,
    otherwise `role_for_react(region, contact)`.
  - `hand = "lead"` always — a man being hit is not throwing.
  - `region = region`.
  - `rises = bool(beat.get("flash_knockdown", false))` **when the role is
    `knockdown`**, and `false` in every other case. A flash knockdown is U20's
    own definition, a knockdown he got up from; there is no separate get-up beat
    in the stream, so the stage must not invent one.
- If `actor` or `target` is not `"a"` or `"b"`, the side that was not named gets
  the idle side frame (`role` `idle`, `hand` `"lead"`, `region` `""`,
  `rises` false). If `actor == target` the target assignment wins.

**Separation, for every kind:** `float(view["separation"])` when `view` has it;
otherwise `float(beat["distance"])` when the beat has it; otherwise `1.0`. Then
run it through `placement(sep, options)` and take `position` / `facing_deg` /
`separation` from the result. `options` is passed straight through.

### 8. `static func tally(frames: Array) -> Dictionary`

Counts roles across a run. Returns a Dictionary with **every one of the ten roles
as a key, ZERO-FILLED**, so a role that never occurred reads `0` rather than
being absent. For each frame in `frames`, increment the key named by `a["role"]`
and the key named by `b["role"]` — **two increments per frame**. A frame missing
`a` or `b`, or naming a role not in `required_roles()`, is skipped for that side
rather than throwing. An empty array returns the ten zeroes.

---

## What your test must assert

Cover every table above. Then, beyond the tables, these earn their place:

1. **`required_roles()` is exactly those ten, in that order.** It is a purchase
   list; a silent reorder or addition changes what gets bought.
2. **Totality.** `role_for_strike` and `role_for_react` over `""`, a junk word,
   and every one of the six real regions × six real contacts (36 pairs) — never
   `""`, never an error.
3. **Determinism.** Call `frame()` twice on the same beat and compare the whole
   returned dictionary. Identical. Then assert the module draws no RNG the only
   way a test can: run the 36-pair sweep twice and compare.
4. **`hand_for` parity**, including the missing-`tick` case.
5. **`placement` geometry**: the two positions are symmetric about `centre`,
   their distance apart equals the clamped separation, and the default axis gives
   `90.0` / `-90.0`. Test a non-default `centre` and a non-default `axis`, the
   zero-length axis fallback, and both clamps.
6. **G42, stated as assertions:** a `no_action` beat NEVER produces a strike or a
   react role; a `missed` contact never produces a react role; an unknown contact
   never produces a react role.
7. **`rises` is false unless the role is `knockdown`** — including the case where
   the beat carries `flash_knockdown: true` but `knockdown` is absent or false.
8. **THE ONE THAT MATTERS MOST — ASSERT THE FEATURE OCCURS, NOT THAT IT IS
   PERMITTED.** This area has shipped SIX pieces of correct, tested, unreachable
   code; R97 found the sixth only because a test demanded a non-zero count. So
   **drive a real bout**: `FightBeatAdapter.begin()` two fighters under the
   `boxing` ruleset on a fixed seed, loop `advance_beat` until `is_fight_over`,
   call `frame()` on every beat with `state_view()` as the view, collect the
   frames, and `tally()` them. Then assert:
   - `tally["idle"] > 0`
   - `tally["strike_head"] > 0`
   - `tally["react_head"] > 0`
   - the tally's values sum to exactly `2 * frames.size()`
   - **every role the run produced is in `required_roles()`** — iterate the
     frames, do not trust the tally to have filtered it.
   Report the whole tally in your digest as a table. **Roles that read 0 on a
   boxing bout are a FINDING to report, not a failure to fix** — `strike_leg`
   and `react_leg` are expected to be 0 under boxing, and `knockdown` may be.
   Say which were zero. That table is evidence the clip shopping list gets sized
   against, so it is worth more than a pass line.

Use `fight_beat_adapter_test.gd` for how to begin a seeded bout — copy its setup,
do not re-derive it.

## The trap specific to this task

**`wear` is a DICTIONARY**, not a number. If you build a synthetic beat by hand
and give `wear` a float, you are testing a beat the engine cannot emit. R97 hit
the mirror of this and got `Nonexistent 'float' constructor` rather than a wrong
number. Build your synthetic beats to the shapes listed above, and cross-check at
least one of them against a real beat pulled out of the seeded run.

## Close-out

Commit and push to **master** (`git rev-parse --abbrev-ref HEAD` first — a
previous agent left this shared checkout on its own branch and six commits went
there while `git push origin master` answered "Everything up-to-date"). Write
`research/C80_DIGEST.md`. Send one line:

```
python Tools/agent_comms.py send --from codex --to claude --subject C80-done --body "<sha> parse=... checks=N failures=M zero-roles=<list> disagreements=<none|what>"
```

Do NOT edit `HANDOFF.md`.
