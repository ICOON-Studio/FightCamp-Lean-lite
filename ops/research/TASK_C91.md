# TASK C91 — CODEX — WHAT THE THIRTY-TWO PAIRED CLIPS ACTUALLY CONTAIN

Model: gpt-5.6-luna, **medium effort — never high**. Owner: codex.
Test tier: **AUDIT — one throwaway tool, no shipped `.gd` behaviour changed.**
Parse gate on the tool you write, run it, and nothing else. Do NOT run the suite.

## Owned files

- `Godot/tools/audit_paired_content.gd` — **NEW. Yours alone.**
- `research/C91_PAIRED_CONTENT.md` — **NEW. Yours alone.**

Nothing else. Do not edit any script in `Godot/scripts/`, any test, or
`HANDOFF.md`.

## Why this exists

**We own THIRTY-TWO paired clip files — SIXTEEN pairs** (`Full Mount Attacks`,
RamsterZ), in exact `_Att` / `_Vic` halves, and
we are about to put the first one on screen. R106 audited whether their ALIGNMENT
survives into Godot — it does. **Nobody has audited what is inside them.**

That matters because of the single most expensive finding of the last two stages,
now recorded in `TRAPS.md` §1:

> **A bought clip's `length` is not its content length.** `H2H_HitReaction01.FBX`
> reports 3.03 s and keys only t=2.47..3.03. Nine of eleven receiver clips carried
> dead air — 32.20 s across 45.63 s of file. `StaggerLarge04_LowHit` is the worst
> we own: **11.53 s of file for 2.70 s of content.**

If we mount a paired clip on its file length, the two fighters will stand frozen
in a mount position for seconds before anything happens. Measure the content.

## Where the pack is

`Godot/assets/anim/audition/ramsterz/` (gitignored — the report ships, the pack
never does). `Godot/tools/audit_ramsterz_paired.gd` is R106's existing audit and
is the pattern to copy: read the clips, do not import the pack.

Its reproduce line, which works today:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/audit_ramsterz_paired.gd
```

## What to measure, per clip

| clip | role | file length | FIRST key t | LAST key t | CONTENT length | dead air | travelling? | bones moved |

- **CONTENT length** is `last key t - first key t`, not the clip's `length`.
- **dead air** is `file length - content length`. Report the total across all
  thirty-two as one figure — that number is the finding.
- **travelling** means the root translates more than 0.1 m over the clip
  (Q47 used that threshold; keep it so the two audits are comparable).
- **bones moved** is how many of the 22 humanoid rows actually carry keys.

Then group the thirty-two into PAIRS by name and state, per pair, whether the two
halves have **the same content length**. If one half runs longer than the other,
say so loudly — two halves of one performance that disagree on duration is a
defect we need to know about before we build on them, not after.

## The deliverable

`research/C91_PAIRED_CONTENT.md`:

1. **Method** — the exact tool invocation and how you read first/last key times.
2. **The per-clip table** above, **all thirty-two rows**.
3. **The pair table** — **sixteen pairs**, each with both halves' content lengths and
   whether they agree.
4. **Three counts stated plainly**: total file seconds, total content seconds,
   and the worst single dead-air offender by name.

## Definition of done

- Both files exist. The tool runs headless and prints a machine-readable summary
  line ending with the totals.
- `git add -- Godot/tools/audit_paired_content.gd research/C91_PAIRED_CONTENT.md`,
  commit, push.
- One line back:
  `python Tools/agent_comms.py send --from codex --to claude --subject C91-done --body "<sha> clips=32 pairs=16 file_s=X content_s=Y worst=<name> disagree=N"`

## The traps specific to C91

1. **An FBX clip's hierarchy is NOT the rig's rest pose**, and in a headless run
   `get_bone_global_pose()` returns the REST pose rather than the animated one
   (both already in `TRAPS.md` §1). You are reading ANIMATION TRACK KEY TIMES off
   the `Animation` resource — you do not need a posed skeleton at all, so do not
   go looking for one.
2. **If a clip reports zero keys, that is a finding, not an error to swallow.**
   Q47 hit one file that was a mesh with no `AnimationPlayer`; say so in the table
   rather than dropping the row.
3. **THE COUNT IN THIS FILE WAS WRONG ONCE AND IT IS THE TRAP.** An earlier draft
   said "eight clips, four pairs", from R106's audit line `paired=8` — which is the
   number of pairs R106 SAMPLED for root alignment, not the number owned. The truth
   is on disk: `ls Godot/assets/anim/audition/ramsterz/Paired_*.fbx` returns **32
   files**. **Count the files yourself before you measure them**, and if you get a
   number other than 32, say so rather than trusting this paragraph. The sixteen
   keys are:

```
Paired_FullMount_Takedown_DoubleLeg_Start   Paired_FullMount_H2H_Punches
Paired_FullMount_Takedown_BodyLock_Start    Paired_FullMount_H2H_ArmBar
Paired_FullMount_Takedown_BodyLock_Loop     Paired_FullMount_H2H_Strangle
Paired_FullMount_Takedown_BodyLock_End      Paired_FullMount_H2H_HeadSmash
Paired_FullMount_Reversal                   Paired_FullMount_VictimAttack
Paired_FullMount_AttackBlock                Paired_FullMount_PushOff
Paired_FullMount_1HM_AxeToFace              Paired_FullMount_1HM_BluntSmack
Paired_FullMount_1HM_KnifeStab              Paired_FullMount_1HM_SlashNeck
```

   The four `1HM_` pairs are weapon clips and will never ship in a gym game, but
   **measure them anyway** — they cost you nothing and a complete table is worth
   more than a filtered one.
4. Do not modify the pack, do not import it, and do not commit any binary from
   `Godot/assets/anim/audition/ramsterz/` — it is gitignored by U46's rule and it
   must stay that way.
