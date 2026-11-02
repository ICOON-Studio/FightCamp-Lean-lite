# TASK_Q114 — QWEN — WHICH HOLDS DOES THE ENGINE ASK FOR AND NEVER GET? THE CENSUS

**Agent:** Qwen · **Model:** its CLI default · **Effort:** medium · **Fast:** off
**Launch:** `qwen --yolo` from the repo root — NEVER `--approval-mode auto`, which leaves it with
no shell tool at all.
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest, and do not explore to "get oriented".

**Test tier: a CENSUS plus its own check script. NO `.gd` is edited, so NO parse gate and NO
test run.** `git status -s` before staging is the whole check.

---

## WHY THIS EXISTS

The operator ruled on 2026-09-21 that we author the five held positions we own no paired film
for. We are about to spend a session each on four of them after the clinch, **and nobody has
counted which ones the engine actually asks for most.** Build them in the wrong order and the
first three sessions buy the least watchable seconds.

**This is a counting job with a ranking at the end.** Count first, rank second, and do not
propose what to build — that is a later decision and it will be made from your numbers.

## WHAT TO COUNT

**1. The demand side — what the engine emits.** `Godot/scripts/FightClipBinding.gd:956` says
`PAIRED_BINDINGS` is keyed by "the GRAPPLE ids `_log_grapple` produces". Find `_log_grapple`, and
from the engine's own code enumerate **every grapple/clinch/ground id it can emit**. That list is
the demand. Do not read it off `PAIRED_BINDINGS` — that is the supply, and deriving the demand
from the supply would make every gap invisible by construction.

**2. The supply side — what is bound.** `Godot/scripts/FightClipBinding.gd:882`,
`const PAIRED_BINDINGS`. For each entry record the id, the `pair_key`, and whether its `att` and
`vic` files actually exist on disk. Note that two ids may legitimately share one pair.

**3. The gap, with a share attached.** For every demanded id with no binding, or a binding whose
files are absent, report it — and attach **how often the engine emits it**, as a share of all
action beats, measured from a real run rather than assumed. The instrument for that already
exists: find how the repo already counts action beats per id (grep the `Tools/` and
`Godot/tools/` scripts for an existing beat or event counter and REUSE it; do not write a second
one). If after a genuine search no such counter exists, say so plainly and report the gap list
without shares rather than inventing a denominator.

**NAME YOUR POPULATION IN YOUR OWN OUTPUT.** If you run bouts to get the shares, the two fighters
must NOT be identical — not the same stats, not the same technique palette, not the same frame,
not the same plan — and both must be legal for the ruleset they fight under. State in the digest
which two fighters and which catalogue produced the numbers. A measurement that does not name its
population is a fixture, not a finding.

## THE GATE

Write `research/Q114_check.py`, and **it must exit 0 on a real run**. It re-derives the
demand list and the supply list from the source files and asserts:

- the demand count is greater than the supply count (if it is not, your demand list came from the
  supply and the census is circular — fail loudly and say so)
- every id in your reported gap list is in the demand list and not in the supply list
- at least one literal pinned number that a later reader can check by eye

Print one `Q114_CHECK ...` line per fact and `Q114_CHECK PASS` at the end.

## DELIVERABLES

- `research/Q114_HOLD_CENSUS.md` — the demand list, the supply list, the gap with shares,
  and a ranking of the gaps by share with the numbers beside each.
- `research/Q114_census.json` — the same thing as data.
- `research/Q114_check.py` — exits 0.

Commit with explicit paths (`git add -- <files>`), push your branch, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q114-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. Do NOT edit any `.gd`.

## THE TRAP SPECIFIC TO THIS TASK

**A count taken over the wrong denominator is worse than no count.** "Side control is 1.9% of
action beats" and "side control is 1.9% of GRAPPLE beats" differ by a factor of ten or more, and
the ranking flips. **State your denominator in the same sentence as every percentage**, every
time, and make `Q114_check.py` print it too.

Second: the engine's grapple ids are produced in code, not listed in a constant. A `grep` for a
literal like `"grapple_"` will find the strings but will also find them in tests, in comments and
in the binding table itself. Say how you separated the ones the ENGINE emits from the ones that
merely appear in the tree.
