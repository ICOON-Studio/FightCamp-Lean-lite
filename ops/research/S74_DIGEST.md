# S74 digest - A PLAYABLE BUILD (Claude, 2026-09-25)

The operator is the playtester ("make it fckin playable and i will play it"). Claude exported the game, walked the
career loop in the EXPORTED .exe, and fixed what a player hits. Fix list with status: `S74_PLAYTEST_FIXES.md`.

## The build
`python Tools/build_playable.py` -> `Builds/FightCamp_Godot/` (gitignored): FightCamp.exe (Godot 4.7.2 runtime, loads
the same-named .pck - no export templates needed), FightCamp_console.exe, FightCamp.pck (643 MB; research/docs/tests/
tools excluded by `Godot/export_presets.cfg`), `assets/` raw .glb/.fbx (333 MB), WHAT_TO_TRY.txt.
Walked IN THE EXE (`FIGHTCAMP_GODOT_EXE=... Tools/godot_hidden.ps1 --script <abs>/s64_career_walk.gd`, plan
`research/s74/exe_walk.plan`): 32 steps, 0 dead ends - new career, offers, enter card, fight week, weigh-in, tape,
the 3D fight, decision, result, back to the day, next day, offers again.

## Operator rulings this session (verbatim in roadmap `already_decided_do_not_reask`)
1. The 2D fight-night picture is deleted "fromeverywhere" and "impossibleto pop upin the game ever again".
2. Every fight is watched in the 3D arena. 3. Mic corner calls with crowd noise: a settings option, research first.
4. Defender: block / dodge / everything between, and anticipate + counter.

## Fixed (worst first)
- Export: fighters/clips loaded by OS path (none inside a .pck) -> `RawAsset.gd` reads bytes; raw models beside exe.
- DEAD END: every Cyprus boxer/wrestler's first amateur bout -> "OFFER NOT AVAILABLE" (U167 open-circuit org id holds
  `|`); ids parsed from the right. `amateur_offer_roundtrip_test` (mutant: 8 fails).
- Career fights in 3D: FightNightScreen hands the booked bout to FightWorldLive on BEGIN (arena owns the bout, one
  engine), corner panel between rounds, result recorded through the old path, 1X/2X/4X, dev readouts hidden, meshes
  legal for the ruleset/sex/weight, amateur = 3 rounds. Test helpers switch the arena off (`arena_enabled`).
- 2D picture deleted (venue plate + two cut-outs) + `banned_2d_fight_picture_test` (mutants: file back -> 2 fails,
  arena unhooked -> 1 fail).
- Names: 100 athletes + 18 orgs fictional in shipped data; real names, histories, sources, 12 photos and the 101-name
  WIP roster moved to `research/names_real/` (never exported); `GameState._apply_names_file` overlays
  `names_real.json` from user:// or beside the exe. `default_build_shows_no_real_name_test`: 0 default, 141 with the
  swap file installed. Five federation names in rules data renamed.
- Tape: a boxer's weight came from the MMA table (83.9 vs 72.6 kg - also the engine's body mass) -> own sport's table,
  saved athletes repaired; corners never share a portrait; AMATEUR badge; AMATEUR BOUT billing.
- World stars out of the amateur pool (NO world athlete carries `turned_pro` - a debutant was offered Joshua).
- SIM THE FIGHT (J49 G9, a FAIL this stage caused): the same engine to the bell, AI corners, same result screen; the
  tape is scaled into its 912 slot (its buttons sat under the footer) on an opaque ground.
- No gate on amateur cards; amateur desk header counts EVEN MATCHES; FIGURE placeholder boxes gone.

## Readiness audit
`S74_READINESS_AUDIT.md`, published https://claude.ai/artifact/NHbexMkLMiLA3p2YrD3wwE: 9 PASS, 5 PARTIAL, 3 FAIL
(G6 rig lock, G8 highlights, G9 fast-sim - G9 built this stage), 1 N/A. Tasks T2 broadcast layer, T3 one rig.

## Still open (next build)
Bout lands the day it is entered (no lead time / camp) - touches settlement, not rushed; UNSAFE mismatches still
dominate a debutant's desk; "NONE FIGHTS TO TWO" wording; the ring card as 14 buttons; the round box lags in rest.

## Agents
- Qwen Q172 pass 2 NOT merged: the doubled engage rate matched strike share (13.9% vs 13.4%) but clinch TIME stayed
  5.3% vs 13.36% - a fit. Q173 (clinch DURATION, rate back to 0.0020) assigned and running.
- Cursor U171 pass 2 NOT merged: all three A/B recording pairs byte-identical (switch never reached the recorder).
  U172 defender model slice 1 (from J50, behind `defence_model`) assigned.
- John J50 COLLECTED: 8 defence families, reading beats reaction (jab ~405 ms tell-to-contact), UFC Str.Def median 55.3%.
- Dola D17 COLLECTED (leg limits cited/relabelled); D18 mic corner calls assigned.
- Grok G95 COLLECTED (SMPL-X bans commercial artefacts; cheapest legal two-person route QuickMagic ~$12/mo) and
  G94B COLLECTED (promoters scale the house / paper / move price; club floors NOT FOUND - GATE_FILL_FLOOR unchanged).
- Codex C198 pass 3 (hand misses reach, overlap frequency regressed; md5s differ) NOT merged -> pass 4. C199 pass 3b: MMA
  guard fix good, but it LOADED the BUDDI prior against the licence bar - not merged, split first. C200 one rig assigned.
- Grok G96 (amateur booking) running. Qwen Q173 pass 1 (duration model: time share 1.7 -> 3.6%) -> pass 2 running.

## Gate
`SUITE total=406 fails=15` raw. Six were this stage's own (career_loop_walk, featured_real_athletes, real_organizations,
setpiece_panels, sponsorship, tale_of_tape_data), each retargeted to the rulings and green alone through the runner.
Real state: 9, the S73 nine (athlete_development, capsule_coverage_contract, fight_body_overlap, fight_metres = hang,
fight_pace_anchor, fight_pair_live PARKED, fight_scoring, fight_stage_realism, fighter_reachability_contract).
Fight-night subsets re-run after the late SIM/tape edits: all green.
