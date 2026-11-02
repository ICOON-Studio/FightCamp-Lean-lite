# TASK U175 - CURSOR - REAL RECORDED FIGHT SOUND: CROWD, BELL, GLOVES, CANVAS
Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S79, 2026-09-25. Presentation lane.

## Why
Operator, 2026-09-25, verbatim: "startt putting sound, not that stupid synthesized crap like the last time" and
"yes download the sound". `Godot/scripts/FightAudio.gd` (425 lines, read it whole) GENERATES every cue in code
(`_make_impact`, `_generate_crowd`, `_generate_bell`) and `SOUND_ENABLED := false`. Replace the synthesis with real
recorded audio. Replace - never layer the synth under it.

## What would a human do?
A game sound designer does not record a fight from scratch and does not rip broadcasts. They pull from licensed
libraries, pick several takes per cue so no two punches sound alike, trim the silence, match loudness across the
set, and play impacts as LAYERS keyed on what happened (a landed head shot = leather slap + thud; a blocked shot =
leather only). The crowd is a looping bed that swells on big moments. The bell is one clean recorded ring bell.
Every file's licence is kept beside it, because a publisher asks for the paper trail before release.

## Sources - APPROVED BY THE OPERATOR, and ONLY these
- **Freesound, CC0 only** (https://freesound.org, filter licence = Creative Commons 0). Never CC-BY-NC, never
  "Sampling+". Record the sound id, author, URL and licence for every file.
- **Sonniss GDC Game Audio Bundle** (https://sonniss.com/gameaudiogdc/, licence https://sonniss.com/gdc-bundle-license/):
  royalty-free, commercial OK, no attribution needed, **no AI/ML training**. Download ONLY the parts that hold the
  cues below - **never the whole multi-GB archive blindly**. If only a whole-archive torrent exists, stop and say so.
- NOT the ~$47 Gamemaster Pro pack (not approved). Nothing ripped from broadcasts or other games.
Research already done - read, do not redo: `research/J22_WHAT_A_FIGHT_SOUNDS_LIKE.md` (cue list section 1,
variants section 2, layering section 3, licences section 6) and `J22B_WHAT_A_FIGHT_SOUNDS_LIKE_PART_TWO.md`.

## Do
1. Find and download real recordings for FIVE cue families (J22 section 4's top five): **crowd bed** (a loop, 2-3
   takes: murmur and roar), **ring bell** (2 takes), **glove impacts** (at least 8 landed + 4 blocked; leather,
   thud), **canvas footwork** (at least 6 scuffs/steps), **body/head thud layer** (at least 6).
   Put them in `Godot/assets/audio/fight/<family>/`, converted to `.ogg` (or `.wav` 16-bit) with the silence
   trimmed and loudness matched (peak -1 dBFS, similar RMS inside a family). `ffmpeg` is available through
   imageio-ffmpeg (`python -c "import imageio_ffmpeg;print(imageio_ffmpeg.get_ffmpeg_exe())"`).
2. Write `Godot/assets/audio/fight/LICENCES.md`: one row per file - file, source URL, author, licence, date.
3. Rework `FightAudio.gd` to LOAD these files (random take per play, pitch jitter <= 5%), keeping its public API
   exactly (`play_hit`, `play_bell`, `start_crowd`, `stop_crowd`, `crowd_swell`, `on_beat`, `begin_round`,
   `end_round`, `get_sound_names`, `has_bus`). Delete the synthesis functions. Route a landed strike to
   leather + thud layers, a blocked one to leather only, footwork to canvas. Set `SOUND_ENABLED := true` only if
   the tests stay green.
4. Update `Godot/tests/fight_audio_test.gd` so it asserts files are loaded (non-null streams, > 0 length, every
   family has >= its variant count, LICENCES.md names every file) instead of the synth parameters.

## Owned files
`Godot/scripts/FightAudio.gd`, `Godot/tests/fight_audio_test.gd`, `Godot/assets/audio/fight/**` (new),
`research/U175_DIGEST.md` (new). All small enough to read whole. Do not touch `FightWorldLiveScreen.gd`
(4,400 lines, Claude's this session) - if a call site there must change, say so in the digest.

## Gate (tier: script edited)
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightAudio.gd Godot/tests/fight_audio_test.gd`.
Then `python Godot/tools/run_tests.py --only fight_audio --jobs 1` and, separately,
`python Godot/tools/run_tests.py --only fight_world_live --jobs 1`. Never the full suite (nightly).
Work in worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U171` on a new branch `cursor/u175-real-sound` from
origin/master. Commit explicit paths (the audio files too - check sizes; total under 60 MB), push the branch, then
`python Tools/agent_comms.py send --from cursor --to claude --topic U175 --body "<files per family, total MB, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
A Freesound page's licence badge is per SOUND, not per user or pack: one author's pack can mix CC0 and CC-BY-NC.
Check each file's own licence before downloading it, and never infer it from the pack.
