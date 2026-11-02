# TASK C92 — CODEX — THE CONTENT WINDOW OF EVERY STRIKING CLIP WE ARE ABOUT TO BIND

Model: gpt-5.6-luna, **medium effort — never high**. Owner: codex.
Test tier: **AUDIT — one throwaway tool, one report, no shipped `.gd` behaviour
changed.** Parse gate the tool, run it, and nothing else.
**Do NOT run the test suite.** Only one Godot may run at a time in this checkout.

## Owned files

- `Godot/tools/audit_striking_content.gd` — **NEW. Yours alone.**
- `research/C92_STRIKING_CONTENT.md` — **NEW. Yours alone.**

Nothing else. Do not edit `FightClipBinding.gd` — the binding that spends this
study is a separate job and an edit here would collide with it. Do not edit any
script in `Godot/scripts/`, any test, or `HANDOFF.md`.

## Why this exists

The operator wants as many animations on screen as possible. We own **160 clips
and play 19.** The catalogue holds 287 technique ids and exactly three resolve to
a clip. Widening that is a DATA edit in `FightClipBinding.BINDINGS` — and **every
row of that data needs a number nobody has measured yet.**

Look at what a bound bought clip actually requires
(`FightClipBinding.gd:81`, the R109 receiver bindings):

```gdscript
"react_head": {
    "path": "res://assets/anim/audition/ramsterz_h2h/H2H_HitReaction01.FBX",
    "retarget": true,
    "reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
    "length_s": 0.57,
    "start_s": 2.47,     # <- THE CONTENT WINDOW
    "end_s": 3.03,       # <- NOT THE FILE LENGTH
    "readable_s": 0.20,
},
```

`H2H_HitReaction01.FBX` **reports 3.03 s and keys only t=2.47..3.03.** Nine of
those eleven receiver files carried dead air — **32.20 s across 45.63 s of file.**
Bind the file length and the fighter stands still for two and a half seconds
before he moves.

**`Q47_INVENTORY.csv`'s `length_s` column is FILE length and is useless for
binding.** Every clip we are about to bind needs its window measured the same way.

## THE JOB

You already wrote the tool that does this. **`Godot/tools/audit_paired_content.gd`
is yours, it landed at `4b71b9b`, and it measured first-key/last-key windows over
the 32 paired files.** Copy it and point it at the striking clips.

### What to measure, per clip

| clip | file length | FIRST key t | LAST key t | CONTENT length | dead air | travelling? | bones moved |

Same definitions as C91: **CONTENT length is `last key t - first key t`**, dead
air is `file length - content length`, travelling means root translation > 0.1 m,
bones moved is how many of the 22 humanoid rows carry keys.

### Which clips

Everything in `Godot/assets/anim/audition/ramsterz_h2h/` that is a STRIKE, a
DEFENCE or a REACTION. Concretely, measure every file whose name matches any of:

```
Kick   Punch   Haymaker   Uppercut   Backfist   Elbow   Knee   Sweep
Block  LegBlock   Dodge   Slip   FadeBack
Stagger   HitReaction   KnockDown   GetUp
```

Skip locomotion (`Walk*`, `Run*`, `Sprint*`, `Turn*`, `Jump*`), skip `Equip` /
`Unequip`, and skip anything ending `_RootMotion` — the engine owns translation
(G42), so those are duplicates of a clip you have already measured. **Say how many
you skipped and why**, so the report accounts for the whole folder.

Expect roughly 60-70 files. **Count them yourself first and report the count** —
do not trust the estimate in this paragraph.

### Also: the ONE extra column that makes this bindable

**`readable_s` — the peak of the action inside the content window.** For a strike
that is contact; for a block or dodge it is the moment of maximum displacement.
You cannot measure "contact" without the engine, so measure the honest proxy and
SAY it is a proxy: **the time of maximum root-relative hand or foot travel**
inside the window, as a duration from `start_s`. If you cannot compute it
reliably for a given clip, write `NOT MEASURED` for that row rather than guessing
— a wrong `readable_s` cuts a clip at the wrong frame and that is worse than a
blank.

## The deliverable

`research/C92_STRIKING_CONTENT.md`:

1. **Method** — the exact invocation, how you read first/last key times, and
   exactly how `readable_s` was derived and why it is a proxy.
2. **The per-clip table**, every measured file.
3. **A ready-to-paste block** — for the fifteen clips with the LEAST dead air, a
   GDScript snippet in exactly the `BINDINGS` shape above, keyed by the clip's own
   short name (not by an engine technique id — choosing those is a separate job).
   **That block is what makes this study spendable in ten minutes instead of an
   hour.**
4. **Three counts stated plainly**: files measured, total dead air seconds, and
   the worst single offender by name.

## Definition of done

- Both files exist. The tool runs headless and prints a machine-readable summary
  line ending with the totals.
- `git add -- Godot/tools/audit_striking_content.gd research/C92_STRIKING_CONTENT.md`,
  commit, push.
- One line back:
  `python Tools/agent_comms.py send --from codex --to claude --subject C92-done --body "<sha> files=N content_s=X dead_air_s=Y worst=<name> readable_measured=M"`

## The traps specific to C92

1. **A bought clip's `length` is not its content length.** That is the entire
   reason this task exists. If your table's CONTENT column equals the file column
   on every row, you have measured `length` and measured nothing.
2. **In a headless run `get_bone_global_pose()` returns the REST pose, not the
   animated one** (`TRAPS.md` §1). You are reading key times off the `Animation`
   resource and you do not need a posed skeleton for the window columns. For
   `readable_s` you need sampled positions — sample the TRACK VALUES directly
   rather than asking the skeleton where a bone is.
3. **A clip with zero keys is a finding, not an error to swallow.** Q47 hit a file
   that was a mesh with no `AnimationPlayer`; report the row, do not drop it.
4. **Do not modify or commit anything from the pack.** It is gitignored and must
   stay that way — the report ships, the clips never do.
5. **Do not bind anything.** `FightClipBinding.gd` is not yours in this task.
