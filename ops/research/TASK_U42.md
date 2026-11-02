# TASK U42 — CURSOR — AUDIT A CLIP BEFORE WE PAY FOR IT

Model: Cursor, `-p --force --trust`, **medium** effort.
Owner: cursor. Tier: parse gate, your own new test, plus your U40/U41 tests, then
`run_tests.py --only world`. Do NOT run the full suite.

**DO NOT START UNTIL CLAUDE SAYS THE SUITE IS CLEAR.** A rebaseline of every
seeded fight is in flight and a second Godot process corrupts it.

## Why this exists — your own U41 finding, and it is a spending risk

You were asked to judge what `combo_jab_cross_hook.glb` actually contains rather
than trust its filename. Your answer:

> Three RightHand peaks with **no L/R alternation** → not jab-cross-hook for
> either stance; a **right-hand-only drill**, or a mislabelled file.

**The file is named for a combination it does not contain.** And we are about to
buy roughly thirteen more clips from that same library, selected by name, sight
unseen. If one name lies, names are not evidence.

The good news is that you have already built the measurement — `punch_windows`
finds the extension peaks and knows which hand threw each. **This task turns that
into a tool we run on every clip before it is bound**, so a mislabelled purchase
is caught in seconds instead of after it is on a fighter.

## Owned files

- `Godot/scripts/FightClipAudit.gd` — NEW, yours.
- `Godot/tests/fight_clip_audit_test.gd` — NEW, yours.
- `research/U42_DIGEST.md` — NEW, yours, max 40 lines.

Your `FightClipSlice.gd`, `FightClipMirror.gd` and `FightClipBinding.gd` are
readable and reusable; edit them only if you must, and say so. **Do not edit
`FightStageDirector.gd`** or Codex's `fight_clip_slice_contract_test.gd`.

## The contract

```gdscript
class_name FightClipAudit
```

- `static func audit(source: Animation) -> Dictionary`
  Everything we can learn about a clip **from the clip itself**, never from its
  filename. Returns at least:
  - `"length_s"` (float)
  - `"track_count"` (int)
  - `"bones"` (PackedStringArray) — the bones it actually addresses
  - `"unmatched_humanoid"` (PackedStringArray) — bones it names that are **not**
    in the standard humanoid profile. R94's whole finding was a clip that looked
    fine and moved 0 of 22 bones because the names did not line up; this is the
    field that catches that at purchase time.
  - `"windows"` (Array) — the punch windows, from `FightClipSlice`
  - `"hands"` (PackedStringArray) — which hand threw each window, in order
  - `"alternates"` (bool) — **does the hand actually alternate?** This is the
    single field that would have caught our current asset.
  - `"moves_bones"` (int) — how many bones actually change over the clip. A clip
    where this is 0 is worthless however good its name is.
- `static func summarise(result: Dictionary) -> String`
  One human-readable line per clip, for a purchase log. Something a person can
  scan down a list of thirteen and spot the wrong one.
- `static func disagrees_with_name(result: Dictionary, filename: String) -> PackedStringArray`
  The point of the whole file. Given what the clip claims to be, return the
  specific contradictions. `combo_jab_cross_hook` promises three punches and
  alternating hands; our asset delivers three punches and one hand. **Return
  that as a finding, in words.**
  Keep the name-parsing deliberately dumb and say in the digest what vocabulary
  you recognise — an audit tool that silently fails to parse a name has told you
  nothing, so an unrecognised name must report "cannot check", never "fine".

## What the test must prove

Run it against the real asset on disk.

1. **The audit reproduces U41's finding**: three windows, all one hand,
   `alternates == false`. That is a known-correct answer for a known file, which
   is the only way to trust the tool on an unknown one.
2. **`disagrees_with_name` actually returns a non-empty list** for
   `combo_jab_cross_hook.glb`. A checker that never objects is not a checker —
   this is the "assert the feature OCCURS" rule applied to a diagnostic.
3. `moves_bones` is 22 for our asset (post-graft), and `unmatched_humanoid` is
   empty.
4. `summarise` returns something non-empty and single-line.
5. Determinism: two audits of the same clip agree.

**Never gate on an exact count** where a ceiling or floor will do — except
`alternates == false` for this specific asset, which is a fact about a file on
disk and cannot drift.

## Traps

- **Headless Godot: `global_transform` / `global_position` are STALE.** Use local
  transforms or `force_update_transform()`. You solved this in U40 with virtual
  FK from `Hips` — reuse it, do not invent a second approach.
- `var x := <call>` fails when the call returns Variant. Write the type.
- `git status -s` first, `git add -- <explicit paths>` only. Never `git add -A`,
  never a bare `git stash` / `reset --hard` / `clean`.
- **Push to master, not a branch.** `git rev-parse --abbrev-ref HEAD` first.
- rc=0 is NOT a pass (R75). Never pass `--godot` to `run_tests.py`.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightClipAudit.gd Godot/tests/fight_clip_audit_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_audit_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_slice_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_mirror_test.gd
python Godot/tools/run_tests.py --only world
```

`python Tools/agent_comms.py send --from cursor --to claude --subject U42-done --body "<sha> windows=<n> hands=<list> alternates=<bool> moves_bones=<n>/22 unmatched=<n> disagreements=<n> own=<checks>/<fails> world=<n>/<f> name-vocab=<what-you-parse>"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** do not build this so it only works on a
jab-cross-hook. We are about to feed it reaction clips, knockdown clips and four
locomotion cycles — **none of which have punch windows at all**. A tool that
reports "0 windows, therefore broken" on a locomotion cycle would fail every clip
we buy for the largest part of the fight. **Say clearly in the audit what kind of
clip it thinks it is looking at, and make "no punches, and that is fine" an
expressible answer.**
