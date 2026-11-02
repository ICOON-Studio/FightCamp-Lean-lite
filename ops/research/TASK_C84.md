# TASK C84 — CODEX — COST THE OPTION NOBODY COSTED: PUSH THEM APART

Model: Codex, **high** effort, Fast OFF.
Owner: codex. Tier: **NEW TEST FILE ONLY** — parse gate plus your own test. Do
NOT run the full suite and do NOT run `--only fight`.

## Why this exists

The operator has an open decision and it is short one number.

**The problem.** `FightRealtime` has no minimum separation. Two fighters can
occupy the same point; 0.5% of scored strikes land inside 0.1 m. The simulation
does not care — it is scoring forces — but two rendered bodies interpenetrating
is visible, and G47's anatomy puts two adult torsos in contact at about
**0.49 m** centre-to-centre (chest depth 0.245 m each).

**What is already measured**, by Qwen (Q35) and by you (C82), independently and
agreeing to four decimal places — a floor that REJECTS the strike costs:

| floor | scored strikes rejected | where |
|---|---|---|
| 0.30 m | 4.16% | 100% free-standing |
| 0.45 m | 9.96% | 100% free-standing |
| 0.60 m | 19.90% | 100% free-standing |

**The option nobody has costed** is the one that does not reject anything:
**push the men apart so the geometry never gets there.** A soft minimum-distance
constraint applied when positions advance, rather than a gate on the strike. By
construction it costs **zero** scored strikes — the close-range situation simply
stops arising. Its cost is paid somewhere else, and finding out where is your
job.

## What this is NOT

**Do not edit `RingSpace.gd` or `FightRealtime.gd`.** This is a costing. Any
change to how positions advance moves every seeded fight and every pinned
scorecard, and that is a deliberate decision made at integration, never by an
agent mid-measurement. Q35 and C82 both hit this wall and both handled it right:
deliver the analysis you can and **state plainly what you could not simulate**.

## What to measure

Same 200 seeded boxing bouts, seeds **200000–200199** — comparability with Q34,
Q35, Q36 and C82 is the whole point.

For candidate minimum separations of **0.30, 0.45 and 0.50 m**:

1. **How often would the constraint engage?** Share of ticks where the pair are
   closer than the candidate and would need pushing apart. Give it against a
   named denominator.
2. **How far would each push be?** The distribution of the correction magnitude
   — median, P95, max. **This is the number that decides whether the idea is
   viable**: a constraint that nudges 2 cm is invisible, one that shoves 30 cm is
   the engine throwing men around and would be obvious in the picture.
3. **Who gets pushed, and does it favour anyone?** If the correction is split
   evenly both men move; if one is advancing and one retreating, pushing apart
   effectively cancels the aggressor's progress. **Does the constraint
   systematically punish the man who is pressing?** That is the finding that
   would decide against it — a fighter who cannot close is a broken fighter.
4. **Would it change who wins?** You cannot simulate the downstream trajectory
   without editing the engine, so do not pretend to. But you CAN bound it: how
   many ticks per bout would be affected, what share of total displacement the
   corrections represent, and how that compares to the displacement the men
   generate on their own. Give a magnitude, and label it a bound.
5. **Compare the three approaches on one table** so the operator can read it at a
   glance: reject-the-strike (Q35/C82's numbers, quote them), push-apart (yours),
   and do-nothing. Columns: strikes lost, ticks affected, movement disturbed,
   moves pins yes/no.
6. **Your recommendation**, one line, with the reason. If the honest answer is
   "push-apart costs no strikes but shoves men 20 cm and would look worse than
   the interpenetration it fixes", say exactly that.

## Owned files

- `Godot/tests/fight_pushapart_test.gd` — NEW, yours.
- `research/C84_THE_PUSH_APART.md` — NEW, yours.

## Anchors

`Godot/scripts/RingSpace.gd` is small — read it whole; `step` at `:17` is where
a position advances and is the only place such a constraint could live.
`Godot/scripts/FightIntent.gd` is small — read it whole. `FightRealtime.gd` is
~2100 lines: **never open it whole**; `sed -n '515,525p'` for `separation`.
`Godot/tests/fight_collision_floor_test.gd` (Qwen's) and
`Godot/tests/fight_strike_band_test.gd` (yours) are the harness — reuse the
approach, do not edit either.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_pushapart_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_pushapart_test.gd
```

**rc=0 is NOT a pass (R75)** — read the output. Never pass `--godot` to
`run_tests.py`. Never gate on an exact value or an exact zero.

`git rev-parse --abbrev-ref HEAD` first. Several agents have work in flight —
`git status -s`, then `git add -- <explicit paths>` only, never `git add -A`,
never a bare `git stash` / `reset --hard` / `clean`. Push **master**, then:

`python Tools/agent_comms.py send --from codex --to claude --subject C84-done --body "<sha> engage-share=A/B/C% push-median=<m> push-p95=<m> push-max=<m> favours-presser=<yes/no> ticks-affected=<n> recommend=<push/reject/nothing> reason=<short>"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** it is tempting to report the push
magnitudes as if they were what the fight would actually experience. They are
not — the moment you push two men apart, their next decisions change, and the
real correction sequence diverges from anything you can compute post hoc. **Say
so explicitly and call your figures a first-order estimate**, exactly as C82
labelled its band numbers a lower bound. A measurement that overstates its own
authority is worse than one that reports a smaller true thing.
