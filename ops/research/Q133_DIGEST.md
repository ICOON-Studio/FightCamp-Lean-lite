# Q133 DIGEST - Wire every clip we already own to a technique id

## The rule

**EXACT**: the clip's vendor noun IS the technique's English name.
`H2H_HookPunch_InPlace.FBX` for `boxing_lead_hook` — the clip says "hook punch",
the technique says "lead hook", same move.

**NEAR**: the clip depicts the same fundamental motion under another name.
`H2H_RoundhouseKick_InPlace.FBX` for `karate_mawashigeri` — the clip says
"roundhouse kick", the technique says "mawashi-geri", different language same
body mechanics. A NEAR binding carries `"provenance": "near"` in the entry
itself, so a later reader can tell a clip that IS the technique from one that
merely resembles it.

**NONE**: no clip on disk depicts this motion. A NONE stays unbound. The module
never invents a substitute.

Applied uniformly across all 534 motion techniques. The census tool
(`tools/q133_clip_coverage.gd`) re-runs this classification from the live
BINDINGS dict and TECHNIQUE_CLIP_ALIASES.

## The numbers

| Classification | Count | Notes |
|---|---|---|
| EXACT | 26 | 5 new direct + 21 legacy (pre-Q133 bindings) |
| NEAR | 132 | 111 new direct + 21 via TECHNIQUE_CLIP_ALIASES |
| NONE | 376 | No clip on disk |
| **Covered** | **158** | **29.6%**, up from 15 (2.8%) before Q133 |

## What was added

**121 new BINDINGS entries** in `FightClipBinding.gd`, every one carrying
`"provenance": "exact"` or `"provenance": "near"`. The 121 break down as:

- 5 EXACT: `boxing_cross`, `boxing_jab`, `boxing_lead_hook`, `muay_thai_spinning_elbow`, `muay_thai_mat_wiang_klap` — plus Motifect EXACT entries for TKD and wrestling
- 116 NEAR: cross-discipline synonyms (Thai names for punches, karate names for kicks, combination ids bound to what they open with)

**21 technique ids** are covered by the existing `TECHNIQUE_CLIP_ALIASES` in
`FightBeatAdapter.gd` and were NOT added as direct BINDINGS keys. The alias
contract (pinned by `fight_clip_alias_test.gd`) forbids a technique id from
being both an alias and a direct key. The census tool checks both tables.

## The 376 NONE, by discipline (top offenders)

| Branch | NONE | Why |
|---|---|---|
| submissions | 19 | Ground submissions, no clip |
| shime_waza | 12 | Judo chokes, no clip |
| leg_locks | 11 | BJJ+Sambo leg locks, no clip |
| osaekomi_waza | 10 | Judo pins, no clip |
| kansetsu_waza | 10 | Judo joint locks, no clip |
| koshi_waza | 10 | Judo hip throws, no clip |
| yoko_sutemi_waza | 16 | Judo side sacrifices, no clip |
| te_waza | 16 | Judo hand throws, no clip |
| ashi_waza | 21 | Judo foot sweeps, no clip |
| footwork_ring | 9 | Boxing footwork, no clip |
| spinning_kicks | 7 | Capoeira spinning kicks, no clip |
| fouette/chasse | 6 | Savate, no clip |

The Judo branches (85 techniques across 7 disciplines) own zero clips. The
Motifect pack has one `judo_hip_throw.glb` which covers `sambo_hip_throw` and
its counter, but the 85 judo-specific techniques are all NONE.

## Clip load verification

Five EXACT and five NEAR bindings were loaded through Godot's scene importer
and their track count and duration printed:

| Technique | Provenance | Clip | Tracks | Duration |
|---|---|---|---|---|
| `boxing_cross` | EXACT | H2H_StraightPunchInPlace.FBX | 46 | 0.833s |
| `boxing_jab` | EXACT | H2H_JabInPlace.FBX | 46 | 0.833s |
| `boxing_lead_hook` | EXACT | H2H_HookPunch_InPlace.FBX | 50 | 1.000s |
| `muay_thai_mat_wiang_klap` | EXACT | H2H_SnappingBackfist_InPlace.FBX | 52 | 1.000s |
| `muay_thai_spinning_elbow` | EXACT | H2H_SpinningElbow_Forward.FBX | 80 | 1.133s |
| `arnis_empty_hand_strike` | NEAR | H2H_StraightPunchInPlace.FBX | 46 | 0.833s |
| `boxing_body_hook` | NEAR | H2H_HookPunch_InPlace.FBX | 50 | 1.000s |
| `boxing_check_hook` | NEAR | H2H_HookPunch_InPlace.FBX | 50 | 1.000s |
| `boxing_check_hook_pivot` | NEAR | H2H_HookPunch_InPlace.FBX | 50 | 1.000s |
| `boxing_counter_combination` | NEAR | H2H_StraightPunchInPlace.FBX | 46 | 0.833s |

All 10 loaded, instantiated, and reported real animation data. The RamsterZ
FBX clips import as PackedScene with embedded AnimationPlayer; track counts
range 46-80 (bone count + control tracks), durations match the BINDINGS
`length_s` fields.

## Files touched

- `Godot/scripts/FightClipBinding.gd` — 121 new BINDINGS entries with
  provenance field, technique_roles() updated to 139 entries
- `Godot/tools/q133_clip_coverage.gd` — NEW, the census tool
- `research/Q133_DIGEST.md` — this file

## Test results

- Parse gate: 2 files, 0 fails
- `run_tests.py --only clip`: total=10, fails=0
- `run_tests.py --only playback`: total=2, fails=0

---

## CLAUDE'S INTEGRATION NOTE (S48, 2026-09-22) — Q133 AND U131 COLLIDED, AND THE COLLISION WAS A REAL DEFECT

Q133 and Cursor's U131 (the technique preview modal) landed within an hour of
each other and were merged in that order. The full suite then read **335 tests,
fails=9** where the ceiling was 8 — and the ninth was `ui_technique_preview_test`,
which had passed at `--only ui` 16/0 before this branch merged.

**It was not a flake and it was not a bad fixture. Both agents were right and
the integration was wrong.**

U131's resolver asked `FightClipBinding.has_clip(technique_id)` and, on a hit,
reported the state **PLAYING**. Q133 then bound `boxing_one_two` to
`H2H_JabInPlace.FBX` with `"provenance": "near"` — correctly, and marked as a
stand-in exactly as the task required. The resolver could not see that mark, so
the modal would have put the name **One-Two** over a **jab** clip with nothing
on the face to say so.

**111 of Q133's 121 bindings are NEAR**, so this was not an edge case — it was
the common path.

Fixed here, in two places:

- `FightClipBinding.provenance_for(role)` — a public accessor for the mark Q133
  writes, defaulting to `"exact"` for older entries that predate the field.
- `UIKit.technique_preview_resolve` reads it: a NEAR binding resolves to state
  `near`, and its `role` names **the clip** (via `NEAREST_CLIP`, falling back to
  the clip's own file name) rather than echoing the technique id back, which
  would have rendered `NEAR · BOXING ONE TWO FOR ONE-TWO`.

`ui_technique_preview_test` is green again at 0 failures, and it is green for
the right reason: the defect it caught is gone, not its assertion.

**THE LESSON, and it is the reason the integrator runs the full suite:** two
agents each shipped a correct piece, each gate passed on its own branch, and
the defect existed only where the two met. Neither `--only ui` before the merge
nor `--only clip` after it would have found it.
