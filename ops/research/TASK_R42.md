# TASK R42 — THE BELT ON THE SCALE (Claude)

**Status: ASSIGNED 2026-09-06, awaiting the operator's go-ahead.** Depends on
R41 (`fae3fe8`) and C26 (`c320496`), both on `master`. J3 ranks this **3** and
called it "one rule on top of R41's flag" — hold it to that size.

Model: Opus, effort high, Fast off. One session; the stage ends at the push.

## Why this exists

R41 made a title bout a decision written at booking, and R41's own block
deferred exactly one thing: **belt-on-the-scale**. Today the scale and the belt
do not know about each other. `_resolve_weigh_ins` (`GameState.gd:1710`) runs
the cut through `WeightCut.weigh_in` (`WeightCut.gd:164`) and gets back a full
record — `made`, `over_by`, `catchweight`, `fine_fraction`, `bout_off`,
`withdrawn` — and a missed weight already costs a slice of the purse and turns
the bout into a catchweight. Then `apply_title_logic`
(`WorldPopulation.gd:1077`) hands over the belt on the strength of the booking
flag alone. **A champion can miss weight by three kilos, fight a catchweight,
win, and keep the belt as if nothing happened.**

That is the last obvious lie left in the title arc, and it is a rule every real
sanctioning body enforces in the same direction.

## The rule, in one sentence

**A contestant who misses the contracted limit cannot win or retain the belt;
the one who made weight still can.**

The three cases that fall out of it:

1. **Champion misses, challenger makes it, challenger wins** → the challenger
   takes the belt normally.
2. **Champion misses, challenger makes it, champion wins** → the champion wins
   the *fight*; the belt does **not** stay with them. The division becomes
   `vacant`. (Do not invent a stripping ceremony, a press cycle or a
   commission hearing — the belt's state changes, that is all.)
3. **Both miss** → nobody can win it. The bout goes ahead at a catchweight and
   the belt is untouched by the result. Decide and write down whether it
   vacates or simply does not move; the smaller rule is that it does not move,
   and the smaller rule is the one to ship unless the code argues otherwise.

An **interim** belt is bound by the same rule, and R41's unification path must
not launder a missed weight into a unified championship.

## What to build

- Carry the weigh-in outcome to the title decision. `apply_title_logic`
  already takes the booked flag; give it what it needs to know **which
  contestants made weight**, in the same shape the flag arrives in (a value
  that may be absent on an old save and falls back to today's behaviour
  exactly once — R41 set that precedent and it is why no old calendar was
  stripped).
- Both call sites must be fed: the player's settlement (`GameState.gd:10438`
  and `:10440`) and the world's own events (`WorldPopulation.gd:875`,
  `:1375`). A world bout whose contestants never touched `_resolve_weigh_ins`
  has no weigh-in record at all — that is the "absent, fall back once" case,
  not a missed weight. **Do not fabricate a weigh-in for the world.**
- Store the reason on the result so a screen can say it later. C26's
  `get_bout_title_stakes` already keeps `stamped` honest for a bout that has
  not been decided; a bout where the belt could not change hands because of
  the scale is the same class of fact and must not be flattened into "not a
  title bout".

## Out of scope

- No UI. The belt surface is K23's ruling and a later stage.
- No new fine, no new purse arithmetic — `fine_fraction` already exists and
  R43 already settled who the purse belongs to. Do not touch settlement money.
- No rehydration, no catchweight ladder, no day-of-weight rules, no
  championship-clause invention. J3 ranked this at one rule; ship one rule.
- No federation's name on the rule. `championship_rules.json` is where a GAME
  rule lives, labelled as one (R41's precedent with `interim_hold_weeks`).

## Files

- `Godot/scripts/WorldPopulation.gd` — `apply_title_logic` and its two world
  call sites.
- `Godot/scripts/GameState.gd` — **the settlement region only** (`:10329`,
  `:10435–10440`). Codex is in the read-API region for C27 this cycle: do not
  edit `get_*_read`, and do not touch `_settle_billing` or `:5100–5120`.
- `Godot/assets/data/championship_rules.json` — only if the rule needs a
  labelled knob.
- `Godot/tests/belt_scale_test.gd` (new).

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/WorldPopulation.gd Godot/scripts/GameState.gd Godot/tests/belt_scale_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/belt_scale_test.gd
```

Then the three frozen regressions that guard the title arc —
`title_flag_test.gd`, `titles_rankings_test.gd`, `championship_read_test.gd` —
and the full suite once before the commit. A regression that only passes after
you edit it means the old expectation encoded the defect; say so in the digest,
as R43 did for the nine tests that asserted the gym was paid.

## Done

Digest `research/R42_DIGEST.md`, the HANDOFF block, push `master`,
and end the session.
