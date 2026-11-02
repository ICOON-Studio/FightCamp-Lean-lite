---
name: project_godot_audio_traps
description: "Godot's AudioStreamWAV FORMAT_8_BITS is SIGNED int8, and play_hit-style code returns early under headless so no test can hear anything"
metadata: 
  node_type: memory
  type: project
  originSessionId: e97a36ed-0204-4b68-b6cc-2695f3c89ac5
  modified: 2026-09-22T15:27:08.451Z
---

**Godot's `AudioStreamWAV.FORMAT_8_BITS` holds SIGNED int8, not unsigned
0..255.** Measured 2026-09-22 with `Godot/tools/probe_wav8.gd`, which
round-trips known bytes through `save_to_wav()`: bytes come back offset by 128,
which is the signed→RIFF conversion. **Run that probe rather than reasoning
about a sample format.**

**Why it matters:** encoding samples as `(f * 0.5 + 0.5) * 255` maps SILENCE
(f = 0) onto 127 — full-scale positive DC. An impact's exponential decay tail
then sits PINNED at full scale instead of fading, so every sound is a click.
Measured tail mean |s| was **127.0 of 127** on all four presets in
`FightAudio.gd` before the fix. The correct encode is
`int(roundf(clamped * 127.0)) & 255`, and silence is 0.

**How to apply:** when generating PCM, assert the tail decays to near zero and
the head has a real transient — `data.size() > 0` proves nothing. See
[[feedback_prove_contract_tests_with_mutants]].

**The second trap, same file:** `FightAudio.play_hit()` returns early when
`DisplayServer.get_name() == "headless"`, which is every test that will ever
run. **Nothing you can hear happens in a test**, so anything a test must
observe has to be recorded BEFORE that guard — that is why `last_played` is set
on the first line. A test that instead re-implements the routing rules agrees
only with itself: mutating the router to send every beat to `"miss"` left
Qwen's pass-1 gate at `total=43 fails=0`. See
[[feedback_gates_must_derive_not_copy]].

**Third, and it cost a red across two agents:** never write a bare autoload
identifier in a scene script. `FightNightScreen.gd` called
`FightAudio.on_beat(event)`; a scene script is compiled BEFORE the autoloads
are registered, so the moment another agent's test preloaded
`FightNight.tscn` that line was `Identifier not found: FightAudio`. Preload the
script (`const FIGHT_AUDIO := preload("res://scripts/FightAudio.gd")`) or use
`get_node_or_null("/root/<Name>")` plus `has_method`. See
[[feedback_defects_live_where_agents_meet]].
