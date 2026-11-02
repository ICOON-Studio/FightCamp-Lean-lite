# S74 readiness audit - FightCamp against J49's gate table (Claude, 2026-09-25)

Promised to the operator in S73 ("do we have to question ourself if everything we need is in place"). Source of the
gates: `research/J49_MECHANICS_MEET_PRESENTATION.md` section 6 (John, SOURCED from UFC/FN/Undisputed/FM/SF6
developer talks). Each gate scored on the tree at S74, with the evidence a reader can open.

| # | Gate (J49 s6) | Verdict | Evidence |
|---|---|---|---|
| G1 | Engine runs headless; same result whatever watches | **PASS** | `FightRealtime.gd` runs in every headless test; the arena states "THIS SCREEN READS THE FIGHT. IT NEVER DRIVES IT" (`FightWorldLiveScreen.gd:23`) and pumps engine time, not frames; same-seed tripwires in `fight_beat_adapter_contract_test.gd`. Caveat below (G9). |
| G2 | A typed event log the 3D room, commentary, highlights and replay all read | **PARTIAL** | Beats come from `FightBeatAdapter.advance_beat` (`FightBeatAdapter.gd:633`) and `state_view` (`:1258`); the arena, `BroadcastRead.gd` and the result panel read them. No highlight picker or replay camera reads the log yet. |
| G3 | Hits resolved in data, physics only shows | **PASS** | `_run_impact` (`FightRealtime.gd:3028`) decides contact in data; C188 `hit_physics` is display-only and OFF (roots identical over 3,600 frames). |
| G4 | Knockdowns: authored falls, not pure ragdoll | **PASS** | `ROLE_KNOCKDOWN` is an authored clip role (`FightStageDirector.gd:52`). |
| G5 | Prove the mechanic with ugly, complete coverage before buying animation | **PASS (process)** | Operator ruling 2026-09-24: no clip purchases until our game shows the preview quality. |
| G6 | Lock skeleton/rig and naming before content | **FAIL** | Three conventions live side by side: UE4 (RamsterZ, `FightClipRetarget.gd:54 UE4_TO_OURS`), Cascadeur (`CASCY_TO_UE4`), Tripo meshes not in metres (memory: fighter rigs are not in metres). Every new source costs a retarget map. |
| G7 | Minimal HUD: state shown on the body and camera | **PARTIAL** | The arena now shows no dev readouts (S74) and has a hit cam (`FightHitCam.gd`), but fatigue/hurt are not shown on the body (posture, hurt zoom); the player has no in-fight state read at all. |
| G8 | Drama-weighted highlights + an overview between clips | **FAIL** | No highlight picker; the player watches the whole bout or leaves. |
| G9 | Always offer text-only / fast-sim | **FAIL - CAUSED IN S74** | Moving every career fight into the arena removed the 2D ring, which was also the only quick way through a bout. A player's own fight can now only be watched (4X max). Top follow-up. |
| G10 | Explain outcomes on screen | **PARTIAL** | The engine records why (clean/glancing/blocked/slipped contact words); the result panel shows THE READ and the cards, but nothing explains a blow during the fight. |
| G11 | Menus are the product: test the UI like gameplay | **PARTIAL** | `s64_career_walk.gd` walks the real UI by label, but S74's walk still found a dead end on a first booking that every test had passed. Walk the loop in the exported build every stage. |
| G12 | Readable wide default camera, close cinematics only for events | **PASS** | Broadcast/establishing default; hit cam on events. |
| G13 | Motion matching optional, not a v1 gate | **PASS** | Not used. |
| G14 | Reuse animation by style archetype | **PASS** | Clips bind per technique (`FightClipBinding.gd`), shared across fighters. |
| G15 | Physics secondary motion serves readability | **PASS** | Physics layers OFF by default where they do not read. |
| G16 | Fixed sim tick, render can differ | **PASS** | `DEFAULT_HZ := 20` (`FightRealtime.gd:114`), the arena interpolates. |
| G17 | Formal milestone doc | **N/A** | J49: NOT FOUND in the industry either. |

**Score: 9 PASS, 5 PARTIAL, 2 FAIL (+1 FAIL caused this session), 1 N/A.** The three J49 names as most expensive to
change later (G1 headless engine, G2 event log, G3 hits in data) are two PASS and one PARTIAL - the foundation holds.

## Every FAIL becomes a task

### T1 (G9) - SIM THE FIGHT, a fast result without watching - BUILT IN S74 (tape button beside BEGIN FIGHT)
**What would a human do?** A manager-sim player skips the bouts he does not care about: FM's "commentary only" and
instant result (J49 S32, S37). A fight manager with four fighters on a card will not watch four 3-round bouts.
Build: a SIM THE FIGHT button on the tale of the tape beside BEGIN FIGHT, running the same engine headless to the
result (the `run_to_completion_for_test` loop, made a product path), then the same result screen. No 2D picture.

### T2 (G8 + G7 + G10) - the broadcast layer: highlights, on-body state, the why - Claude (GUI lane) after T1
**What would a human do?** A TV director cuts to the knockdown, the replay and the stats between rounds; the viewer
reads a hurt fighter from his posture, not a bar (J49 S9b, S14, S36). Build from the event log (G2): per-round
highlight picks weighted by drama (knockdowns, big shots, momentum swings), a between-round stat card, and a one-line
"why" caption on the big moments (BLOCKED / GLANCING / HE SAW IT COMING).

### T3 (G6) - one rig, one naming convention - Codex (animation lane)
**What would a human do?** A studio locks the skeleton before content and retargets every source to it once, at
import (J49 S3, S4 - the UFC team's rig-retarget pain). Deliver: a written rig spec (bone names, rest pose, units in
metres) for the fighter meshes, an import-time converter each source passes through, and a test that fails when a
clip arrives in another convention or scale.
