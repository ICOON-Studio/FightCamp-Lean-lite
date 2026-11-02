# TASK C82 — CODEX — SHOULD A STRIKE NEED A BAND, NOT A CEILING?

Model: Codex, **high** effort, Fast OFF.
Owner: codex. Tier: **NEW TEST FILE ONLY** — parse gate plus your own test. Do
NOT run the full suite, and do NOT run `--only fight`: you are adding a
measurement, not changing behaviour.

## Why this exists — three measurements landed today and they point one way

- **Q34 (`1304342`)**: scored-strike separation runs continuously from **0.000 m
  to exactly 1.1000 m**, median 0.885, and the **MODE is the `[1.0, 1.1)` bucket
  at 27.5%** — 47.5% of all scored strikes are in the top two buckets.
- **U39 (`6feb41f`)**: the animation clip we own has a **measured hand travel of
  0.747 m**.
- **Q35 (`ded8650`)**: 4.16% of scored strikes happen below 0.30 m separation and
  9.96% below 0.45 m — and **100% of those are free-standing exchanges**, not
  clinch, not ground.

`FightRealtime.gd:171` is `const STRIKE_RANGE := 1.1` and the gate at `:1192` is
`if gap > STRIKE_RANGE: return` — a **ceiling only**. So the engine will score a
punch at 0.02 m (two men inside one another) and at 1.099 m (0.35 m past where
our clip's hand reaches) with equal willingness.

**A real arm covers a band.** You cannot land a meaningful punch from inside a
man's chest, and you cannot land one past full extension. The hypothesis is that
`STRIKE_RANGE` should be `[STRIKE_MIN, STRIKE_MAX]`.

**This task COSTS that change. It does not make it.**

## What is NOT being asked, and this matters

**Do not edit `FightRealtime.gd`. Do not edit `RingSpace.gd`.** A band changes
which attempts pass the gate, which changes every seeded fight, which moves
R85's pinned scorecards. R85's rule stands: nobody re-pins a red card to make it
green. Claude decides at integration whether that price is worth paying, and
needs your numbers to decide.

Q35 hit this same wall and handled it correctly: it delivered a **post-hoc
analysis of what the band would have caught**, and stated plainly that it could
not simulate the downstream trajectory change without editing the engine. **Do
the same, and make the same disclosure.** An honest post-hoc count is the
deliverable; a fabricated "here is the fight after the change" is not.

## Owned files

- `Godot/tests/fight_strike_band_test.gd` — NEW, yours.
- `research/C82_THE_STRIKE_BAND.md` — NEW, yours.

## Anchors — read these WINDOWS, never the whole file

`FightRealtime.gd` is ~2100 lines. **Never open it whole.**
- `sed -n '165,180p'` — `STRIKE_RANGE`, `GRAPPLE_RANGE`.
- `sed -n '1185,1200p'` — the attempt gate itself.
- `sed -n '515,525p'` — `separation`.
`Godot/scripts/RingSpace.gd` and `Godot/scripts/FightIntent.gd` are small: read
them whole. `Godot/tests/fight_metres_test.gd` (Qwen's, Q34) and
`Godot/tests/fight_collision_floor_test.gd` (Qwen's, Q35) are the harness
precedent — **read them and reuse the approach and the same seeds** so your
numbers are comparable with theirs. Do not edit either.

## What to measure

Over **200 seeded boxing bouts, seeds 200000–200199** (the same seeds Q34 and
Q35 used — comparability is the point):

1. **The cost of a floor, by candidate.** For `STRIKE_MIN` of 0.20, 0.30, 0.45:
   how many scored strikes fall below it. Q35 has these for 0.30/0.45; reproduce
   them as a cross-check and say whether you agree. **If your numbers differ from
   Q35's, say so loudly** — two independent measurements disagreeing is a
   finding, and the answer is settled in the data, never by deferring to whoever
   measured first.
2. **The cost of a ceiling, which nobody has measured.** For `STRIKE_MAX` of
   0.75, 0.85, 0.95 and 1.05: how many scored strikes fall ABOVE it. The 0.75
   row is the important one — it is the clip's own 0.747 m reach, so it answers
   *"if we demanded that every scored punch be one our animation can actually
   show, how much of the fight would we lose?"*
3. **The band, jointly.** For the plausible pairs — `[0.30, 0.95]`,
   `[0.30, 1.05]`, `[0.45, 0.95]`, `[0.20, 0.85]` — what share of currently
   scored strikes survives? Give a table. **This is the number Claude spends
   against.**
4. **Who loses.** Are the out-of-band strikes evenly spread, or concentrated —
   by round, by fighter (does the longer-reach man lose more?), by intent
   (`close`/`hold`/`retreat`/`circle`), by ring place (centre/ropes/corner)?
   **If a band would systematically punish one archetype, that is the finding
   that decides against it.**
5. **What would fill the gap.** If a band rejects an attempt that today scores,
   the engine does not simply stop — the men keep moving and another decision
   tick comes. Estimate, from the tick data, **how long until the pair would
   next be in-band**. If the answer is "a fraction of a second", the band costs
   presentation and not much fight; if it is "several seconds", it would visibly
   slow the fight, and that is a different decision.

## The gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_strike_band_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_strike_band_test.gd
```

**rc=0 is NOT a pass (R75)** — a runtime error leaves rc=0 and prints
`0 failure(s)` having never reached the counter. Read the output. **Never pass
`--godot` to `run_tests.py`.**

**Assert only that the measurement occurred and is sane** — sample counts
positive, every share in `[0,1]`, the band table's rows summing correctly.
**Never gate on an exact value and never on an exact zero.** Print the numbers.

## Finish

`git rev-parse --abbrev-ref HEAD` before believing anything landed. **Another
agent is editing `Godot/scripts/FightClipBinding.gd` and friends in this shared
checkout right now** — run `git status -s` first, `git add -- <explicit paths>`
only, never `git add -A`, and never a bare `git stash` / `reset --hard` /
`clean`. Push **master**. Then:

`python Tools/agent_comms.py send --from codex --to claude --subject C82-done --body "<sha> below-0.30=<n>% below-0.45=<n>% agrees-with-Q35=<yes/no> above-0.75=<n>% above-0.95=<n>% band[0.30,0.95]-survives=<n>% concentrated-by=<axis-or-none> refill-median=<s>s"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** the tempting shortcut is to count
strikes whose *recorded* separation falls outside the band and call that the
cost. That undercounts, and it undercounts in a direction that flatters the
change — because a rejected attempt does not merely vanish, it changes what both
men do next, and the strikes that WOULD have followed are not in your sample at
all. **Say explicitly in the findings that your number is a lower bound on the
disruption**, the same disclosure Q35 made. A measurement that overstates its own
authority is worse than one that reports a smaller true thing.
