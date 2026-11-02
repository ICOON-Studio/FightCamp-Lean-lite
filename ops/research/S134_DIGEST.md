# S134 digest - cloud stage: the agents' tasks done by Claude, five watch-visible defects fixed (Claude, 2026-09-30/10-01)

Operator moved the stage to the cloud (weekly limit) and then: "do all their tasks yourself keep progressing the
project". Everything below is on master (last 7d694281). Cloud has Godot 4.7.2 at /opt/godot/godot, headless tests
run (`GODOT_EXE=/opt/godot/godot python3 Godot/tools/run_tests.py ...`), and RECORDING WORKS (xvfb, section 6).

## 1. What now works (each with its evidence)
| What | Evidence | Commit |
|---|---|---|
| Hook-chain 0/4 was the GATE playing a single-jab placeholder; gate scores N-part chains through the production splice | s134b_hook_generator_*.json: one_two 4/4, cross mid-chain passes; liver/six fail on body overlap (receiver spacing) | 9d4d11f |
| G152 judges disagree | split+majority 0 -> 23% of decisions, KO/draws unchanged | 78811a9 |
| Q221 pose realism (Qwen's task): slip 70->37 deg, cross_body 52->43 (re-cert 4/4), react_head HitReaction04 + react_body StaggerMedium01-04 out, StaggerSmall02/03 layered | tools/s134_pose_probe.gd TABLE, 5 seeds; s134b_slip_*, s134b_cross_body_*, s134b_slip_chains_* | 1e91b02, 77636915, 23f9fa04 |
| C228 angles + guard coverage (Codex's task), ON in DEMO_SWITCHES | c228 census: 10% of exchanges >= 20 deg, landed outside 32 vs inside 28, connect 30.9 | eeac95d, e3d4e2c, 3e149c7 |
| The boxer jabs: feints had swallowed the jab (12%) | jab share mean 42.3% (census 37.4 / output test 47.2), feints 4-6/min (G86) | e3d4e2c, c602d63 |
| Fatigue carries over (in-round recovery = fast share only) | bell stamina 97.6/96.5/92.6 (was 99/99/98), thrown >= OFF | bbe4a89 |
| Legs inside legs 5.0 mm -> 0 (leg-cross engage 8 deg/frame) | git bisect -> 2a662c55; foot pops held 69 -> 71 | 6ba56fd |
| U203 hand_contact_sync merged | chop hitches 46 -> 23 | 8a2a007 |
| Legs thrown up in idle while the pair slides (the S133 "lean-back"/"lunge") | record_room pose_log stage trace; foot pops 71 -> 24, hitches 23 -> 17, pops 132 -> 97 | 68b3d6e |
| Art direction: icons with tooltips instead of text (operator) | DesignLibrary/GLOSSARY.md | 7c83827 |

## 2. Agents
Codex C228 and Qwen Q221 are DONE by Claude - do not relaunch them (their task files stay as the spec record).
C226b collected and finished as ST1b. Q220 NOT merged (its own A/B: split_inlet KEEP 47% -> 5%). G152, U203 merged.
No agent run is in flight from this session.

## 3. Still red (all on the 2026-09-30 04:49 nightly red list; values unchanged by S134)
fight_body_overlap (2.7 mm hand>head @740), fight_strike_whole OFF baseline hash, fight_footwork_economy (MMA m/min),
fight_ring_position R16, fight_stage_realism, fight_stage_technique_fidelity.

## 4. Open
- Hook chains liver_combo / six_punch: parts certified at longer spacing (body hook 1.56 m, rear uppercut 1.315 m)
  step into a receiver fixed at the chain's shortest reach - needs a between-part footwork step (or in-place variants).
- Body share of landed 52-57%: G99 has NO sourced split - do not tune without a source.
- RC2 arm length from reach: HELD for the operator (re-opens all 19 certified moves).
- .exe rebuild + walk with all of the above: PC only.

## 5. Next (the decision)
Stage S135 = the hook chains: a between-part step in the production sequence splice (FightStagePlayer
sequence_plan/_advance_sequence) so liver_combo and six_punch_combo pass c223_sequence_gate on 4 rigs, then bind them.
In parallel on the PC when the operator is there: build_playable + walk.

## 6. Cloud recording (new capability)
    cd Godot && xvfb-run -a -s "-screen 0 1280x720x24" /opt/godot/godot --path . --rendering-driver opengl3 \
      --audio-driver Dummy --script tools/record_room.gd --write-movie /tmp/x.avi --fixed-fps 30 \
      --resolution 1280x720 --quit-after 900 -- discipline=boxing seed=92012 as_game [pose_log=1] [off=<switches>]
ffmpeg: `pip install imageio-ffmpeg` (python3 -c "import imageio_ffmpeg;print(imageio_ffmpeg.get_ffmpeg_exe())").
Latest take: docs/previews/anim/live_boxing_seed92012_s134b.mp4.
