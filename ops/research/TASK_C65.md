# TASK C65 — CODEX — WHAT WMMA5 KNOWS ABOUT A GAS TANK

Model: Sonnet, medium effort, Fast on. Owner: Codex. Deliverable: ONE new file,
`research/C65_WMMA5_TEARDOWN.md`, committed and pushed. **No engine code
in this task.** Nothing in `Godot/scripts/` or `Godot/tests/` is touched.

---

## Why

R84 landed stamina in the real-time fight and immediately exposed the gap: a
man at 5 stamina punches exactly as hard and defends exactly as well as one at
100, because nothing reads `fatigue_fraction()`. We are about to author a
fatigue→performance curve (G31). Before we tune numbers out of our heads, read
how the deepest shipped MMA management sim does it.

**World of Mixed Martial Arts 5** is installed on this machine and its whole
database is readable. It is the closest commercial relative FightCamp has.

## THE SOURCE — verified working before this task was written

```
D:/Databases/Default/WMMA5.mdb      (11.9 MB, 168 tables)
D:/WMMA5.exe                        (55.8 MB, the game itself)
```

The Access ODBC/ACE provider is **NOT** installed and you do not need it. A
pure-Python reader is already installed and confirmed working:

```python
from access_parser import AccessParser
db = AccessParser(r'D:/Databases/Default/WMMA5.mdb')
names = [t for t in db.catalog if not t.startswith('MSys')]   # 168 tables
rows = db.parse_table('tblFighterAttribute')                  # dict of column -> list
```

**Known caveat, so you do not chase it as a bug:** `access-parser` 0.0.6 is
imperfect. `db.parse_table('tblFighter')` returns a single bogus column
(`NumDays`) rather than the real schema. Some tables parse cleanly and some do
not. **Report which tables you could and could not read** rather than working
around it silently — a table you could not open is a finding, not a gap to
paper over. If a key table will not parse, fall back to `strings`-style
inspection of the raw file for its column names and say that is what you did.

Tables already located and worth starting from:

* `tblFighterAttribute` — **the important one.** Columns are
  `UID, WhichSide, ThisRound, KnockDown, HeavyStrike, MediumStrike,
  EasyStrike, Takedown, Wrestling, Pass, CloseSubmission, Slam, Stuff,
  CrazyStrike, GroundStall, PassFail, SweepFail, Separation, StrikeFail,
  AvoidContact, Smother, StrikeStalemate, DullGrapple`. This is a **per-round,
  per-side event counter table** — WMMA5's equivalent of our
  `RealtimeRoundStats`.
* `tblFighterSkills`, `tblFighterMax`, `tblSkillsHistory` — attributes and
  their ceilings/history.
* `tblFighterProRecord`, `tblFightFighter`, `tblCompanyRules` — records, bout
  rows, ruleset knobs.
* `tblFighterBio`, `tblFighterRetire`, `tblFighterPopChange` — career shape.

## The questions to answer, in this order

1. **Does WMMA5 carry a cardio / conditioning / gas-tank attribute at all, and
   what is it called?** Give the real column name and its observed range across
   the roster (min, max, mean, and the distribution shape).
2. **Does fatigue degrade a fighter's other attributes during a bout, or only
   his output?** This is the question G31 is authored against. If the schema
   cannot answer it, say so plainly and answer from observed play or from the
   game's own documentation instead — but label which you did.
3. **What does `tblFighterAttribute` actually count, and how does its list
   compare with our nine `RoundScoring.round_points` counters?** Name what
   WMMA5 counts that we do not, and what we count that it does not.
   `Godot/scripts/RoundScoring.gd:69` is our list — read that function only,
   not the whole file.
4. **How many attributes does a WMMA5 fighter have?** We have seven. If WMMA5
   has thirty, say what the extra ones buy and whether any of them is worth
   the cost — but do NOT propose adding attributes; U18 already refused an
   eighth and that ruling stands unless the operator reopens it.
5. **Anything about round scoring, stoppage or the judge model** worth stealing.
   We have just built ours (`R84_DIGEST.md` — read that, it is short) and we
   know our three-judge panel is currently incapable of disagreeing.

## The shape of the deliverable

Short. A table per question, a plain-English finding under each, and a final
section headed **"What FightCamp should take, and what it should refuse"** with
no more than five recommendations, each one sentence. Where a number is worth
copying, give the number. Where WMMA5 is worse than what we already have, say
so — this is a teardown, not an endorsement.

**Cite the table and column for every factual claim.** A claim with no column
behind it must be labelled as an impression.

## Owned files

| File | Note |
| --- | --- |
| `research/C65_WMMA5_TEARDOWN.md` | **Yours. New. The only file you create.** |

Read-only, and only these: `research/R84_DIGEST.md`,
`Godot/scripts/RoundScoring.gd:69` (that one function),
`Godot/scripts/FightStamina.gd` (125 lines, small enough to read whole).

**Do not read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any
other digest, or `GameState.gd` (12,900+ lines). Do not explore to get
oriented — this page is the brief.

## No parse gate, no test

You are writing one markdown file and touching no GDScript. Do not run the
suite. Do not edit `HANDOFF.md`.

## The trap specific to this task

**Do not dump the schema.** 168 tables of column names is not a teardown and
costs everyone who reads it. The deliverable is the five answers; the schema is
evidence you cite, not content you paste. If you find yourself pasting a table
with more than about twenty rows, you have stopped doing the task.

## When you are done

```
python Tools/agent_comms.py send --from codex --to claude --topic c65-done --body "<one line: the cardio attribute's real name, whether fatigue degrades attributes, and how many tables would not parse>"
```
