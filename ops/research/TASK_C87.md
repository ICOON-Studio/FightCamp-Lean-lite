# TASK C87 — CODEX — THE RETARGET LADDER: WHAT THE FIRST N CLIPS BUY

**Agent:** codex
**Model:** Sonnet tier, **medium effort. Never high.**
**Test tier:** **RESEARCH. NO `.gd` FILE IS TOUCHED.** No parse gate, no test, no
suite. `git status -s` before staging is the whole check.

---

## Why this exists

R103 measured that **95 of 148 action beats (64.2%) take an honest degrade** —
the presenter says "we do not own a clip for that" and plays a generic. We have
just bought 161 FBX. Nobody has worked out **which retarget to do second**, and
retargeting is not free: each clip costs a pass.

You are producing the **ladder**: retarget clips in demand order, and after each
one state what percentage of shown beats is now played by a clip that is
honestly named rather than degraded.

This decides the order of the next several stages. It is arithmetic over two
tables we already own. **It is a join, not a judgement call** — the rule for what
counts as a cover is given below and you apply it literally.

---

## Owned files

| file | you may |
|---|---|
| `research/C87_THE_RETARGET_LADDER.md` | **CREATE.** Yours alone. |

Nothing else. Do **not** create or edit any `.gd`. Do **not** edit `HANDOFF.md`.

---

## Read exactly these three things and nothing else

1. `research/Q46_THE_RECEIVERS_DEMAND.md` — the RECEIVER demand table
   (react_head / react_body / react_leg / knockdown / idle / slip / block),
   pooled and per ruleset, denominator 9,715 shown beats.
2. `research/Q45_WHAT_GETS_SHOWN.md` — the THROWER side: which named
   techniques actually reach a shown beat, and at what share.
3. The two filename lists below. **They are the complete contents of what we
   own.** Do not go looking for the FBX files on disk — they are gitignored and
   you do not need them; the filenames are the input.

**Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, or any
digest.** Do not explore to "get oriented". Everything you need is in this file
and those two research documents.

### Pack A — `Hand to Hand Set`, 124 files, solo (`ramsterz_h2h/`)

```
T_pose  Standing_Idle  H2H_Idle  H2H_JumpIdle
H2H_HitReaction01..04
H2H_StaggerSmall01..03  H2H_StaggerMedium01..04
H2H_StaggerLarge01..03  H2H_StaggerLarge04_LowHit
H2H_StaggerLarge_FromBehind01..03  H2H_StaggerFromBehind01..02
H2H_KnockDown01  H2H_KnockDown02  H2H_GetUp01
H2H_BlockStart  H2H_BlockLoop  H2H_BlockEnd  H2H_BlockIdle
H2H_LegBlockStart  H2H_LegBlockLoop  H2H_LegBlockEnd  H2H_LegBlockIdle
H2H_SlipLeft  H2H_SlipRight  H2H_FadeBack
H2H_Dodge_Back  H2H_Dodge_Forward  H2H_Dodge_Left  H2H_Dodge_Right
H2H_JabInPlace  H2H_JabForward
H2H_StraightPunchInPlace  H2H_StraightPunchForward
H2H_HookPunch_InPlace  H2H_LeadingUppercut_InPlace
H2H_Haymaker_InPlace  H2H_Haymaker_Forward  H2H_PowerHayMaker_Forward
H2H_PowerPunch01_Forward  H2H_SnappingBackfist_InPlace
H2H_JumpingUppercut_InPlace  H2H_JumpingUppercut_Forward
H2H_GroinPunch_InPlace  H2H_BackHandSwing_Forward
H2H_KneeStrike_Forward  H2H_SpinningElbow_Forward  H2H_LegSweep_InPlace
H2H_RoundhouseKick_InPlace  H2H_HighSideKick_InPlace  H2H_LowSideKick_InPlace
H2H_LeftCutKick_InPlace  H2H_LeftCutKick_Forward
H2H_RightCutKick_InPlace  H2H_RightCutKick_Forward
H2H_AxeKick_InPlace  H2H_FlipAxeKick_Forward  H2H_SpinningHookKick_InPlace
H2H_TornadoKick_Forward  H2H_BackflipKick_InPlace  H2H_FrontflipKick_Forward
H2H_BarrelRollKick_Forward  H2H_JumpSpinHookKick_Forward
H2H_TrippleSpinningHookKick_Forward
H2H_JumpingBackKick_InPlace  H2H_JumpingBackKick_Forward
H2H_PowerChargeStart/Loop/End  H2H_Equip  H2H_Unequip
H2H_Turn180  H2H_TurnLeft90  H2H_TurnRight90
H2H_JumpStart/Loop/Land
(plus ~44 locomotion files: Walk/Run/Sprint in 8 directions, each with a
 _RootMotion twin — treat the whole locomotion set as ONE row, "locomotion")
```

### Pack B — `Full Mount Attacks`, 37 files, PAIRED Att/Vic (`ramsterz/`)

```
Paired_FullMount_H2H_Punches          Paired_FullMount_H2H_ArmBar
Paired_FullMount_H2H_Strangle         Paired_FullMount_H2H_HeadSmash
Paired_FullMount_Reversal             Paired_FullMount_PushOff
Paired_FullMount_AttackBlock          Paired_FullMount_VictimAttack
Paired_FullMount_Takedown_DoubleLeg_Start
Paired_FullMount_Takedown_BodyLock_Start / _Loop / _End
(4 further pairs are ARMED — axe / knife / blunt / slash. Weapons. Count them,
 then exclude them from every coverage number and say so on the same line.)
```

---

## THE COVER RULE — apply it literally, do not improvise

A demanded role is **COVERED** by an owned clip when the clip is, without any
editing beyond retargeting, the thing that role names:

- `react_head` ← `H2H_HitReaction01..04`. **COVERED (4 variants).**
- `react_body` ← `H2H_StaggerSmall01..03` + `H2H_StaggerMedium01..04`.
  **COVERED (7 variants).** Justify in one line which set you assigned where and
  keep it consistent.
- `react_leg` ← `H2H_StaggerLarge04_LowHit`. **COVERED (1 variant).**
- `knockdown` ← `H2H_KnockDown01/02` (+ `H2H_GetUp01` as the exit).
  **COVERED (2 variants).**
- `idle` ← `H2H_Idle`. **COVERED (1).**
- `slip` ← `H2H_SlipLeft/Right` + `H2H_FadeBack`. **COVERED (3).**
- `block` ← `H2H_BlockStart/Loop/End/Idle` + the LegBlock four.
  **COVERED (2 sets).**

For the **thrower** side use Q45's named techniques and this rule: a technique is
covered only when a clip names **that technique**, not its category. `jab` ←
`H2H_JabInPlace` is a cover. `overhand` ← `H2H_Haymaker_InPlace` is a **NEAR**,
not a cover — flag it `NEAR` in its own column and never count a NEAR inside a
coverage percentage. **This is R103's lesson and it is the whole reason this
task is worded this way: a clip the fight never threw played 85 times because
something resolved a category to whatever punch was nearest.** Categories do not
cover techniques.

---

## What the document must contain

### 1. The receiver ladder

A table, one row per retarget step, in **descending demand order**:

| step | clip(s) retargeted | role filled | % of 9,715 shown beats | cumulative % |

Run it to the point where cumulative coverage stops moving. State plainly how
many retargets buy 50%, 90%, and 100% of receiver demand. **Name the
denominator (9,715 shown beats) in the same sentence as every percentage.**

### 2. The same ladder per ruleset

Boxing, MMA, kickboxing, muay thai — each with its own denominator, named. The
orders will differ (boxing has **zero** leg reactions; muay thai leads with
react_body). Say which ruleset is cheapest to finish and by how many clips.

### 3. The thrower ladder

Same shape, against Q45's named techniques and their shares. Separate the
`COVERED` rows from the `NEAR` rows completely — two tables, never one column
mixed. End with: **how many of Q45's named techniques do we own a true cover for,
out of how many appear on a shown beat at all?**

### 4. The gaps — the part that decides the next purchase

List every demanded role or technique with **no owned cover and no NEAR**,
ordered by share of shown beats. That list is the shopping list, and it is the
only place in this document where you are allowed one paragraph of opinion:
which single unowned clip would buy the most coverage.

### 5. One closing number

```
C87_LADDER receiver-100%-at=<N> clips / thrower-covered=<X>/<Y> / largest-gap=<name> <pct>%
```

---

## Then

1. `git status -s` — another agent may have staged work.
2. `git add -- research/C87_THE_RETARGET_LADDER.md`
3. Commit (ends `Co-Authored-By: Codex <noreply@openai.com>`), push `master`.
4. `python Tools/agent_comms.py send --from codex --to claude --subject C87-done
   --body "<hash> <the C87_LADDER line>"`
5. Do **not** edit `HANDOFF.md`.

---

## THE ONE TRAP

**A share is only meaningful against the right denominator.** Q46's 9,715 is
*shown beats*; Q45's tables have their own per-ruleset denominators; the 148
beats in R103 are a third, much smaller population from three seeded bouts.
**Never let a percentage from one appear in a sentence with a count from
another.** If you write a number, the denominator is in the same sentence. Every
time.
