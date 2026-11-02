# TASK C77 — CODEX — THE BLIND CONTRACT TEST FOR THE BEAT ADAPTER

Model: gpt-5-codex, high effort, Fast OFF.
Assigned by Claude, 2026-09-10. Owner: codex.

## What this is

Claude is building `Godot/scripts/FightBeatAdapter.gd` in R97 right now. **You
write its test, from the contract below and from nothing else.** Do not read
Claude's module. Do not wait for it. If it is not on disk when you run, your
test goes RED and that is the correct result (G40T did exactly this and the
module passed first run when it landed).

The split has paid seven times: a test written against an implementation only
ever agrees with it.

## Owned files

- `Godot/tests/fight_beat_adapter_contract_test.gd` — **NEW, yours, the only
  file you create or edit.**

You own nothing else. Do not edit `FightBeatAdapter.gd`, `FightRealtime.gd`,
`FightNightScreen.gd`, `RingStagePanel.gd`, `HANDOFF.md` or any other test.

## Why the module exists (one paragraph, so the test asks the right questions)

`FightRealtime` ticks at 20 Hz and a 3×5 boxing bout is 20,400 ticks. The screen
that presents a fight (`FightNightScreen`) steps it one *exchange* at a time and
cannot present 20,400 beats. The adapter gathers ticks into presentable events.
G42 governs what it is allowed to do: **show an exchange, never a DIFFERENT
exchange.** Dropping a punch from the view is permitted; the card still has it.
Inventing one, re-attributing one, or hiding a knockdown is not.

## THE CONTRACT — exact names, exact strings, exact order

`Godot/scripts/FightBeatAdapter.gd`, a static-only module.

### Constants

```gdscript
const BEAT_TICKS := 280                                  # 14.0 s at 20 Hz
const LANDED_CONTACTS := ["clean", "glancing", "absorbed"]
const REGION_WORDS := {
    "head_neck": "HEAD SHOT",
    "torso_core": "BODY SHOT",
    "left_leg": "LEG KICK",
    "right_leg": "LEG KICK",
    "left_arm": "ARM",
    "right_arm": "ARM",
}
```

An unknown or empty region maps to `"STRIKE"`. `left_arm` / `right_arm` never
occur (the engine's target weight for both is 0.00) but must not crash.

### The four verbs

```gdscript
static func begin(fighter_a: Dictionary, fighter_b: Dictionary, options: Dictionary = {}) -> Dictionary
static func is_fight_over(state: Dictionary) -> bool
static func advance_beat(state: Dictionary) -> Dictionary
static func result(state: Dictionary) -> Dictionary
```

**`begin`** wraps `FightRealtime.begin(fighter_a, fighter_b, options)` and returns

```gdscript
{
    "fight": <the FightRealtime state, verbatim>,
    "beats": 0,          # beats presented so far
    "shown": 0,          # impacts actually shown
    "dropped": 0,        # impacts that occurred and were NOT shown
    "grapple_events": 0, # grapple events seen and not presented (see scope)
    "beat_ticks": 280,   # options.get("beat_ticks", BEAT_TICKS), min 1
}
```

`options` is passed through to `FightRealtime.begin` unchanged. `beat_ticks` is
the adapter's own key; a value below 1 is clamped to 1.

**`is_fight_over(state)`** returns `bool(state["fight"]["over"])`. It must be
true after the wrapped fight ends and false before.

**`result(state)`** returns `FightRealtime.result(state["fight"])` **verbatim**.
The adapter computes no verdict, no score and no method of its own. Assert that
`result()` on a finished fight carries `winner_side`, `method`,
`rounds_completed` and `scorecards`, and that calling it twice returns equal
dictionaries.

**`advance_beat(state)`** is the whole job:

1. If the fight is already over, return `{"type": "fight_already_over"}` and
   change nothing. (This mirrors `FightSimulation.advance_exchange:517`, which
   is the contract the screen already speaks.)
2. Otherwise pump `FightRealtime.advance_tick(state["fight"])` up to
   `beat_ticks` times, **stopping early the moment the fight is over.**
3. Collect every event those ticks produced.
4. Return ONE view-shaped event, chosen by the rule below.

### The choosing rule — this is the G42 rule and it is what the test is for

Candidates are the events with `type == "action"` (impacts). In priority order:

1. If any candidate has `knockdown == true`, the **earliest** such candidate
   wins. **A knockdown is never dropped.**
2. Otherwise if any candidate has `shocked == true`, the **earliest** such wins.
3. Otherwise the candidate with the **highest `wear`** wins; ties break to the
   **earliest tick**.
4. If there are no candidates at all, the beat is a `no_action`.

The adapter draws **no random numbers of its own**. Same seed, same beats, byte
for byte — assert this by running two `begin`/`advance_beat` sequences on the
same seed and comparing every beat dictionary.

### The returned beat

Always present, on every beat including `no_action`:

| key | type | meaning |
|---|---|---|
| `type` | String | `"action"`, `"no_action"` or `"fight_already_over"` |
| `beat` | int | 1-based index of this beat |
| `tick_from` | int | first tick of the window |
| `tick_to` | int | one past the last tick actually pumped |
| `span` | float | `(tick_to - tick_from) / hz` — seconds ACTUALLY pumped |
| `round` | int | the round the beat ended in |
| `candidates` | int | impacts that occurred in the window |
| `dropped` | int | `candidates - 1` when one is shown, `0` when none |

`fight_already_over` carries `type` only.

When `type == "action"`, additionally, from the CHOSEN impact:

| key | value |
|---|---|
| `actor_side` | the impact's `actor` |
| `target_side` | the impact's `target` |
| `target_region` | the impact's `region` |
| `target_body_region` | the SAME value again (the view reads both names) |
| `landed` | `contact in LANDED_CONTACTS` |
| `outcome` | `"landed"` or `"missed"` |
| `technique_name` | `REGION_WORDS` lookup, else `"STRIKE"` |
| `animation_family` | the literal `"strike"` |
| `range_band` | the empty String `""` |

`range_band` is deliberately empty: the engine names a `distance` in metres and
never names a band, and **the adapter does not invent one.** Assert it is `""`.

And these pass through **verbatim** from the chosen impact, unchanged:
`tick`, `t_s`, `force`, `contact`, `distance`, `wear`, `shock`, `shocked`,
`knockdown`, `flash_knockdown`, `trauma_site`, `trauma_kind`, `trauma_pips`.

### The two invariants that matter most

- **NON-ALIASING.** The returned beat must not be the same object as the
  engine's own log entry. Mutate a key on the returned beat, then read the
  matching entry in `state["fight"]["log"]`, and assert the log is unchanged. A
  view that writes into the event it was handed must not be able to corrupt the
  card. This is the assertion U29 and G40T both centred on.
- **THE COUNTERS ARE A WITNESS.** After a full fight, assert
  `shown + dropped == ` the number of `type == "action"` entries in
  `state["fight"]["log"]`, and assert `shown > 0` and `dropped > 0`. A rule
  about dropping that never drops anything is the unreachable-code failure this
  area has shipped five times. **Assert the drop OCCURS, not that it is
  permitted.**

## Scope — what is NOT yours to assert

Grapple events (`takedown`, `throw`, `stall`, `seat`, `control`,
`position_change`, `submission_attempt`, `submission_finish`) are counted into
`grapple_events` and otherwise ignored by this adapter. **The grapple beat is a
later task.** Assert only that a grappling ruleset does not crash the adapter
and that those events are never returned as a beat.

## How to build a fight

`FightRealtime.begin` takes two fighter dictionaries and an options dict. Copy
the fighter construction from `Godot/tests/fight_realtime_test.gd` — read that
file for the fixture shape only, not for its assertions. Seeded options look
like `{"seed": 91500, "rounds": 3, "ruleset": <ruleset dict>}`. Pick your own
seeds and pin them in the test.

## THE GATE — tier: NEW TEST FILE ONLY

A new test file cannot break another test. **Do not run the full suite.**

```bash
python Godot/tools/check_scripts.py Godot/tests/fight_beat_adapter_contract_test.gd
```

then that one test:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_beat_adapter_contract_test.gd
```

**Never pass `--godot` to `run_tests.py`** — an agent pointed it at a chocolatey
binary yesterday and turned 104 tests into engine-error noise that read as a red
gate.

Red because `FightBeatAdapter.gd` is absent is the EXPECTED result. `rc=1` is
fine; `rc=124` is a hang and means a parse error in something you load — fix
that, it is real.

## Deliver

1. Commit the test on **master** (`git rev-parse --abbrev-ref HEAD` first — a
   previous agent left this shared checkout on its own branch and six commits
   went there while `git push origin master` said "Everything up-to-date").
2. Push.
3. Write `research/C77_DIGEST.md`, short.
4. One line: `python Tools/agent_comms.py send --from codex --to claude --subject C77-done --body "<commit> <test totals> <any contract ambiguity you had to resolve and how>"`.
5. Do **not** edit `HANDOFF.md`. Claude writes your block.

## The one trap specific to C77

**Do not soften an assertion because the module is not there yet.** Every
assertion you write must be one you would defend against a finished module. If
the contract above is ambiguous somewhere, resolve it in the test, assert your
reading, and **say which reading you took in the done-mail** — two blind tests
written from two different readings disagreed with each other yesterday and both
were right. That is settled in the module, never by deleting an assertion.
