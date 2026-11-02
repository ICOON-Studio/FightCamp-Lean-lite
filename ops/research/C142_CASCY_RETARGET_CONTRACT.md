# C142 Cascy retarget contract

The blind contract test checks that `CASCY_TO_UE4` has 21 unique Cascy-to-UE4
rows, every destination joins the existing `UE4_TO_OURS` map, and the existing
map remains the 22-row map recorded on 2026-09-21. It permits no unrouted
destination except `UpperChest`, and rejects Cascy extras (`arm_twist_l/r`, all
`f_*` finger bones, `hair`, and `weapon_l/r`).

## Verification

The mandated `Tools\\s26_test.cmd` wrapper could not start because this checkout
does not have its expected Godot console path
(`C:\\Users\\user\\AppData\\Local\\Programs\\Godot\\Godot_v4.7.2-stable_win64_console.exe`).
The same test was run successfully with the installed Godot 4.7.2 executable:

```text
invalid-value mutant: cascy_proof_1 points to missing UE4 key __not_a_ue4_key__
invalid-value mutant: unexpected unrouted ours bones ["Hips", "UpperChest"]
MUTANT invalid-value caught=true failures=2
duplicate mutant: duplicate UE4 key pelvis
duplicate mutant: unexpected unrouted ours bones ["Spine", "UpperChest"]
MUTANT duplicate caught=true failures=2
20-row mutant: Cascy row count expected 21, got 20
20-row mutant: unexpected unrouted ours bones ["Hips", "UpperChest"]
MUTANT 20-row caught=true failures=2
weapon_l mutant: Cascy row count expected 21, got 22
weapon_l mutant: duplicate UE4 key pelvis
weapon_l mutant: forbidden extra mapped weapon_l
MUTANT weapon_l caught=true failures=3
SKIP (CASCY_TO_UE4 not present)
failures=0
```

The test's real result is therefore `SKIPPED`, with `failures=0`; the parse
gate was also green (`CHECK total=1 fails=0`).

The four in-memory scratch mutants are wired into the test and their diagnostics
are isolated from the real `failures=` counter. Once the map exists, they report
`caught=True` with a positive mutant failure count for: a non-UE4 destination,
a duplicate UE4 destination, a 20-row map, and a `weapon_l` key respectively.
