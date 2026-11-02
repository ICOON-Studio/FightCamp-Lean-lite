# U175 digest — real recorded fight sound

**Branch:** `cursor/u175-real-sound`  
**Scope:** Replace synthetic `FightAudio` with CC0 Freesound samples; enable `SOUND_ENABLED := true`.

## Assets (38 WAV, ~0.4 MB total)

| Family | Variants | Source IDs (CC0 verified per page) |
|--------|----------|----------------------------------|
| crowd murmur | 2 | 524567, 684516 |
| crowd roar | 2 | 486206 |
| bell | 2 | 438626, 520998 |
| glove landed | 8+ | 637246 (+ extras trimmed) |
| glove blocked | 6 | 483261 |
| thud | 8 | 369326 |
| canvas | 8 | 637246 |

`Godot/assets/audio/fight/LICENCES.md` lists every file. Samples are 44.1 kHz mono 16-bit PCM WAV, trimmed/limited in ffmpeg. Loaded at runtime via `_load_pcm_wav()` so headless tests do not depend on a warm `.godot/imported` cache for fight assets.

## Code

- `FightAudio.gd`: deleted synthesis; layered `play_hit` (landed = glove + thud, block = glove_blocked only, miss = canvas); `contact == "blocked"` routing; footwork → canvas; crowd murmur loop + roar one-shots on swell; pitch jitter capped at 5%.
- `fight_audio_test.gd`: asserts family counts, stream length, licence coverage, routing (incl. block), sync seam.

## Tests

- Parse: `CHECK total=2 fails=0`
- `run_tests.py --only fight_audio --jobs 1`: **SUITE total=161 fails=0**
- `run_tests.py --only fight_world_live --jobs 1`: **FAIL** — `Cannot open res://.godot/imported/unbreakable_noise_menu.mp3-…` (missing import cache in this worktree; pre-existing autoload `UserSettings`, not U175).

## Call sites

`FightWorldLiveScreen.gd` unchanged; still calls `FightAudio.on_beat` / `begin_round` / `end_round` with the same public API.

## Prep tool (not shipped)

`Tools/u175_prepare_fight_audio.py` and `Godot/.u175_cache/` were used locally to download Freesound HQ previews and slice variants; not required at runtime.
