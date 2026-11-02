# TASK M2 — CAGE DESK: THE ASSET REPLACE (Maria)

Model: top tier, effort medium, Fast off.

Art delivery, not code. No `.gd`, no `.tscn`, no `HANDOFF.md` edit — Claude
writes Maria's block and lands the files.

## Why this exists

Maria has a Cage Desk pack (P1–P4 plus tight masks plus a runtime zip) built
to replace the older photoreal-leaning K2 set. It is not on `master`, it is
not claimed anywhere, and it cannot be pushed from her machine (no `gh`, no
cloud agent). This task is the route in.

## Three facts that change the shape of this task

Read these before deciding what to send.

1. **The K2 set has NO code consumers.** Only
   `Godot/scripts/TechniqueGlyphs.gd` and `Godot/tests/technique_glyphs_test.gd`
   read anything under `Godot/assets/ui/`, and what they read is
   `icons/moves/` — 273 move pictograms that K2 did not author and that this
   task does not touch. The K2 root set (body map, six region masks, belts,
   trophies, medal, eleven discipline glyphs, `plate_corner_stool.png`,
   `plate_locked_cage.png`) is referenced by nothing, because the legacy
   screens that drew it were deleted across R21–R28.

   So the replace is **safe and invisible**: nothing breaks, and nothing
   looks different, until a surface is written that reads the new files.
   That is not a reason to skip it — it is a reason to land the pack now,
   cleanly, so the next surface has the right art to reach for. But do not
   expect a visible diff, and do not pad the pack to chase one.

2. **`K2_HASH` was never a live defect.** The archived K2 block carries its
   real commit, `cff33a5`. Any local copy still showing the placeholder is
   stale.

3. **Tight masks are a genuine upgrade.** K2's own README flags its six
   region masks as "first-pass elliptical hit regions… tighten to painted
   silhouettes in a later art pass if needed". Maria's tight masks are that
   pass. Say so in the manifest; it is the one part of this pack with a
   documented invitation already in the repo.

## What to deliver

**A. The files.** Final PNG or JPG, at the sizes they should ship at. Keep
the K2 filenames wherever a file replaces a K2 file — a rename is a second
change and this task is a swap. New files that have no K2 counterpart get
new names in the same convention (`snake_case`, role first).

**B. A manifest**, `research/M2_CAGE_DESK_MANIFEST.md`:

- One row per file: filename, pixel size, what it replaces (or `new`), and
  one line on what it is for.
- Which K2 files this pack **supersedes**, and which it leaves standing. Be
  explicit — anything not named stays.
- The licence line, in the form `Godot/assets/ui/README.md` already uses:
  who authored it, with what tool, on what date, and the operator-cleared /
  nothing-ripped statement. Ripped art never ships; if any source is not
  clean, leave the file out and say why.
- The six-region mask mapping, by `BodyReadiness` key, so the tight masks
  can be verified against the map rather than eyeballed.

**C. One contact sheet** — a single PNG showing the whole pack laid out, for
the record under `DesignLibrary/screens/cage_desk/`.

## How it reaches master — OPERATOR RELAY (pinned, operator decision 2026-09-06)

Maria cannot push binaries from her machine, and this is the route. There is
no branch route and no direct push; do not look for one.

1. Maria hands the operator the pack **and** `M2_CAGE_DESK_MANIFEST.md`
   together, in one delivery.
2. The operator drops them into the checkout at the paths the manifest names.
3. Claude verifies against the manifest, runs the acceptance below, stages
   explicit paths, commits with the K2 supersede note, updates
   `Godot/assets/ui/README.md`'s licence table from the manifest, writes
   Maria's `HANDOFF.md` block, and pushes.

The manifest is what makes the pack landable. **A pack with no manifest is
sent back**, and a partial delivery — files without the manifest, or a
manifest naming files that did not arrive — is not landed until it is whole.
Send one complete delivery rather than a trickle.

## Owned files

- `Godot/assets/ui/*.png` (the K2 root set only — the files the manifest names)
- `research/M2_CAGE_DESK_MANIFEST.md` (new)
- `DesignLibrary/screens/cage_desk/` (new, the contact sheet)

## Do not touch

- `Godot/assets/ui/icons/moves/` and `icons/disciplines/` — 273 live move
  pictograms with a real code consumer. Out of scope entirely.
- `Godot/assets/ui/README.md` — Claude updates the licence table from the
  manifest when the pack lands, so the two can never disagree.
- Any `.gd`, any `.tscn`, `HANDOFF.md`.

## Acceptance

Claude runs, before the commit:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_glyphs_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Both exit 0 — which they will, since nothing reads the replaced files. The
real acceptance is the manifest: every shipped file named, sized, sourced and
licence-cleared, and every superseded K2 file listed.
