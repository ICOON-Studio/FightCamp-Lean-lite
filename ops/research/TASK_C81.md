# TASK C81 — CODEX — ASK FOR THE STOPPAGE: THE FOLD THE VERB NEEDS

Model: Codex, **high** effort, Fast OFF.
Owner: codex. Tier: **A SCRIPT IS ADDED, NOT EDITED** — parse gate, your own
new test, then `python Godot/tools/run_tests.py --only fight`. Do NOT run the
full suite; that is Claude's once, at integration.

## Why this exists

G44 (`research/G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md:452`) ruled that
**"ask for the stoppage" is the one mid-round verb a real chief second may
actually use**, and that it should be built first. Q31
(`research/Q31_THE_STOPPAGE_READ.md`) then checked whether the engine can
support it and returned **yes-with-a-named-addition**.

Q31's finding, and it is the whole shape of this task:

> No head/torso/stamina threshold separates stopped fights from decision
> fights. The warning window against the engine's own KO/TKO is **zero
> seconds**, because that mechanism is an instantaneous event, not a threshold
> crossing. A corner verb firing on the same signal is decorative. **A verb
> firing on a CUMULATIVE signal is a genuinely new decision the engine does not
> make, and that is where its value lives.**

So the missing piece is an **accumulation** — a pure fold over the impact log
the engine already emits. **No new engine surface. No new state on the
fighter. No change to the seed. `FightRealtime.gd` is NOT yours and must not
be edited.**

## Owned files

- `Godot/scripts/FightStoppageRead.gd` — NEW, yours, the whole module.
- `Godot/tests/fight_stoppage_read_test.gd` — NEW, yours.
- `research/C81_DIGEST.md` — NEW, yours, max 40 lines.

## Anchors you will need — read these WINDOWS, not the files

`FightRealtime.gd` is ~2100 lines. **Never open it whole.** The windows:

- `sed -n '2030,2090p' Godot/scripts/FightRealtime.gd` — `state_view()`, which
  is what your module reads. Everything you need arrives through it.
- `sed -n '1420,1470p' Godot/scripts/FightRealtime.gd` — where an impact is
  built and appended, so you can see the exact keys on a log entry
  (`shock`, `knockdown`, `contact`, `region`, `force`, the trauma marks).
- `sed -n '160,180p' Godot/scripts/FightRealtime.gd` — the force constants, if
  you want to reason about magnitudes.
- `research/Q31_THE_STOPPAGE_READ.md` — read it whole; it is yours and it
  is the spec behind this.

`Godot/scripts/FightBeatAdapter.gd` is the existing precedent for "a pure
reader that folds the fight into something a screen can use" — read it for the
house style, do not edit it.

## The contract — exact names, exact argument order

This module will be called by a screen you will not see, and by a blind
contract test written from this section and never from your code. These names
are load-bearing.

```gdscript
class_name FightStoppageRead
```

- `static func fold(view: Dictionary, side: String, window_seconds: float) -> Dictionary`
  The core. `view` is `FightRealtime.state_view()`. `side` is `"a"` or `"b"`
  and names the man we are considering **pulling out** — i.e. the corner's own
  fighter, the one taking the punishment. Returns a dictionary with **exactly**
  these keys:
  - `"shocks_in_window"` (int) — shocked impacts landed on `side` inside the
    last `window_seconds` of fight time.
  - `"knockdowns_total"` (int) — knockdowns suffered by `side` in the whole
    bout, not the window.
  - `"knockdowns_in_window"` (int)
  - `"head_condition"` (float) — the live head/neck condition of `side`.
  - `"unanswered"` (int) — impacts landed ON `side` minus impacts landed BY
    `side`, inside the window, floored at 0.
  - `"severity"` (float, 0.0..1.0) — the fold's single number. Rises with
    shocks, knockdowns and unanswered work in the window, and with a falling
    head condition. **Label the weights AUTHORED in a comment**, the way
    `GRAPPLE_ATTEMPT_BASE` is labelled — no published figure exists for this
    and pretending otherwise is worse than authoring it.

- `static func may_ask(view: Dictionary, side: String) -> bool`
  True when `severity` for the default window is at or above
  `ASK_THRESHOLD`. This is the gate the corner dock will grey out against.

- `static func reason(view: Dictionary, side: String) -> String`
  A short, presentable clause naming the single largest contributor —
  `"three shocks in the last minute"`, `"two knockdowns"`,
  `"taking it unanswered"`, or `""` when `may_ask` is false. Plain text; no
  markup, no fighter name, no punctuation at the end.

- `const DEFAULT_WINDOW_SECONDS := 60.0`
- `const ASK_THRESHOLD := <your number, AUTHORED and commented>`

**Purity.** Zero preloads. No RNG. No `get_node`. No autoload identifiers. Two
calls with the same `view` return the same answer. The module must be testable
in a throwaway project holding only itself.

## What the test must prove — and this is the part that has bitten us five times

**Assert that the feature OCCURS, not that it is permitted.** Three separate
defects last week were code that was correct, tested, and could never run.

So: drive a REAL bout through `FightRealtime` in your test and assert that
over a run of seeded bouts, `may_ask` **actually becomes true at least once**,
and print in how many bouts and at what fight-second it first fires. If it
never fires, your threshold is unreachable and the module is dead code behind
a green test — **report that as the finding and fix the threshold**, do not
lower the assertion.

Equally: assert it is **not always true**. A verb permitted in every bout from
round one is the same defect wearing the other hat. Report the share.

**Never gate on an exact count and never on an exact zero.** Write ceilings and
floors — "fires in at least 10% and at most 90% of bouts" — so a later tuning
change reports honestly instead of going falsely red.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightStoppageRead.gd Godot/tests/fight_stoppage_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stoppage_read_test.gd
python Godot/tools/run_tests.py --only fight
```

**rc=0 is NOT a pass (R75).** Read the output. **Never pass `--godot` to
`run_tests.py`.**

## Finish

`git rev-parse --abbrev-ref HEAD` before believing anything landed — another
agent may have left this shared checkout on its branch. Commit explicit paths,
push **master**, write the digest, then:

`python Tools/agent_comms.py send --from codex --to claude --subject C81-done --body "<sha> parse=N/N own=<checks>/<fails> fight=<n>/<f> fires-in=<pct>% first-fire-median=<s>s always-true=no"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** the impact log is a list of events for
BOTH men. Q31 warns that the obvious read — "impacts in the log" — is not
"impacts landed on my fighter". Get the side attribution right, and assert it
with a case where the two men take visibly different punishment; a fold that
silently sums both fighters' shocks will still produce plausible numbers and
pass a careless test.
