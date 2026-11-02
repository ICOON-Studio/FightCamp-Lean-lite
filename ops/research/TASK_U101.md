# TASK U101 — CURSOR — "JERKY MOVES": RETIME A STRIKE WHOSE WHOLE EXTENSION SITS IN ONE KEY INTERVAL, SWEPT

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u101-retime` - Claude creates it from `master` before
launch. Push the BRANCH. Stage: S4a (operator, 2026-09-14, asked what looks MOST wrong: "Jerky moves").

**Test tier: A NEW PURE MODULE PLUS A PRODUCTION SCRIPT EDITED BEHIND A SWITCH WHOSE DEFAULT IS OFF.** Parse gate on
every touched `.gd`; the sweep below; then `python Godot/tools/run_tests.py --only clip,stage,fight_world,live_schedule,contact_solve --jobs 2`
must end with `fight_stage_realism_test.gd` as its ONLY failure (it is red by design). No full suite.
`python research/U101_check.py` must exit 0 before you commit - if it cannot, do not commit: send
`--topic "U101 BLOCKED"` with its FAIL lines. ONE Godot at a time in your worktree.

## Owned files

- `Godot/scripts/FightTakeRetime.gd` - NEW, the pure module. **Its contract is `research/S4A_SMOOTH/RETIME_CONTRACT.md`
  - read it whole and follow it to the letter** (Codex is writing a blind test against the same contract).
- `Godot/scripts/FightStagePlayer.gd` - EDIT (2,115 lines: never open it whole; `sed -n` windows at `:180-226` setup and
  the `_derive_contacts(skel_path)` call, `:1045-1078` `_derive_contacts`, `:1081` `HAND_STRIKE_ROLES`, `:2059-2100`
  `_bone_tracks` / `_sample_global`, `:1752-1765` `set_foot_lock_options` as the pattern for an options setter).
- `Godot/scripts/FightWorldLiveScreen.gd` - EDIT (944 lines: never open it whole; `:225-255` configure's options,
  `:335-352` the per-player option loop).
- `Godot/tools/probe_spikes.gd`, `Godot/tools/probe_clip_keys.gd` - EDIT (small, read whole): accept `retime_cap=<m/s>`
  and `retime_ratio=<r>`.
- `Godot/tests/fight_stage_realism_test.gd` - EDIT (1,774 lines: never open it whole; the switch parsing is `:115-150`):
  accept the same two.
- `research/U101_retime.json`, `research/U101_RETIME.md` (20 lines at most) - NEW.

## The integration (exact names)

`FightStagePlayer.set_retime_options(options: Dictionary) -> void`, keys `cap_mps` (default 0.0 = OFF, nothing
changes), `spike_ratio` (2.5), `hold_mps` (1.5), `min_scale` (0.5), `absorb_s` (0.30). When `cap_mps > 0.0`, ONCE per
player: for every non-looping take of every role in `HAND_STRIKE_ROLES` (base takes and `_variants`, the same take list
`_derive_contacts` builds): `key_times` = the key times of the take's `LeftHand` rotation track (the first rotation track
if it has none); `travel_m[k]` = the larger of LeftHand's and RightHand's distance, in WORLD METRES (skeleton-space
distance times the skeleton's world scale), between `_sample_global(hand, anim, tracks, key_times[k]).origin` and the same
at `key_times[k + 1]`; `new_times = FightTakeRetime.remap(key_times, travel_m, cap_mps, spike_ratio, hold_mps, min_scale, absorb_s)`;
when it differs, `FightTakeRetime.apply(anim, key_times, new_times)`. Then re-run `_derive_contacts` with the skeleton
path setup used (store it). `retime_report() -> Dictionary` returns, per take name, `{"old": [...], "new": [...], "travel": [...], "length_s": x}`.
`FightWorldLiveScreen.configure` reads `options["retime"]` (a Dictionary, default `{}`) and, in the per-player loop,
calls `set_retime_options` with it when it is not empty. `-- retime_cap=<m/s>` / `retime_ratio=<r>` set
`options["retime"] = {"cap_mps": x, "spike_ratio": r}` (ratio defaults to 2.5 when only the cap is given).

## The sweep

| name | cap_mps | spike_ratio |
|---|---|---|
| R0 | 0.0 | 2.5 |
| R1 | 7.0 | 2.5 |
| R2 | 5.0 | 2.5 |
| R3 | 3.5 | 2.5 |
| R4 | 5.0 | 0.0 |

`hold_mps` 1.5, `min_scale` 0.5, `absorb_s` 0.30 throughout. For each variant, through production:
- `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tools/probe_spikes.gd --timeout 600 -- seed=94301 top=5 retime_cap=5.0 retime_ratio=2.5`
  (~10 s): record `spikes` total and the `point_LeftHand`, `point_RightHand`, `take_jab`, `take_cross`, `take_hook_lead` counts;
- `probe_clip_keys.gd -- takes=jab,cross,hook_lead retime_cap=... retime_ratio=...` and `retime_report()` on fighter A
  (f01_m_box_welter): per take `length_s`, `contact_s` (the player's `contact_s(role)`), `old`, `new`, `travel`;
- `tests/fight_stage_realism_test.gd -- retime_cap=... retime_ratio=...` (--timeout 1500; red by design - read its `RULE`,
  `R7-SEED` and `measured:` lines): R4 pass/exits, R8 reached/landed, R7 violating frames per seed, R3 mean, every verdict.

`U101_retime.json`: `{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fighters": "f01_m_box_welter v f09_m_bare_welter", "spikes_seed": 94301},
"fixed": {"hold_mps": 1.5, "min_scale": 0.5, "absorb_s": 0.30},
"variants": [{"name": "R0", "cap_mps": 0.0, "spike_ratio": 2.5,
"spikes": {"total": n, "LeftHand": n, "RightHand": n, "take_jab": n, "take_cross": n, "take_hook_lead": n},
"takes_f01": {"jab": {"length_s": x, "contact_s": x, "old": [...], "new": [...], "travel": [...]}, "cross": {...}, "hook_lead": {...}},
"realism": {"R4_pass": n, "R4_exits": n, "R8_reached": n, "R8_landed": n, "R7_violating_frames": {"94301": n, "51227": n, "77003": n}, "R3_mean_mps": x, "verdicts": {"R1": "PASS|FAIL", ...}}}, ... R4],
"recommended": "<name>"}` - every number copied from the instruments' output. For R0 `new` equals `old`.

**The recommendation rule:** the variant with the fewest `spikes.total` among those whose R4 verdict is PASS and whose
`R8_reached` is at least 0.9 x R0's (ties: the earlier name). `U101_RETIME.md` opens with `## DECISIONS`: one row per
variant (spikes total, jab spikes, jab length and contact, R4, R8, R7 total, R3), the recommended variant and the number
that decided it.

## Commit and send

`git status -s` first. Commit ONLY the owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u101-retime`; `python Tools/agent_comms.py send --from cursor --to claude --topic U101-ready
--body <hash>`. Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`, `reset`,
`checkout .`, `clean`, `rebase` or `merge`.

## The trap

Contact frames are derived when the takes are GRAFTED, before the room hands a player any options - a retime that does
not re-run `_derive_contacts` leaves every thrower's lead and every receiver's reaction timed to the OLD keys. And
`travel_m` must be world metres: the skeleton is scaled, and a skeleton-unit distance turns the 5.0 m/s cap into some
other number. The check pins R0 to Claude's run on master (spikes 351 / LeftHand 256 / RightHand 48 / take_jab 158; R4
1008 of 1070; R8 123 of 551; R7 1693 / 1672 / 1359) and recomputes every variant's `new` from its own `old` and `travel`
by the contract.
