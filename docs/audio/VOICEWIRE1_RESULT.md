# VOICEWIRE1 RESULT

The cast's voice lines are written, registered and wired into fight night. S438: 26 files made (announcer, the man coach's shouts, the between-round lines): 26 credits, balance 1083.51 -> 1057.51. All 26 are UNHEARD: none plays in the game until the owner keeps it on the sound board.
Every voice event has an empty files list, so nothing plays (and nothing errors) until a file is made and the operator
keeps it on the sound board (the EAR RULE).

## Lines per role

| Role | Voice | Lines | Status |
|------|-------|-------|--------|
| Announcer | Roger | 15 (opening, 3 red takes, 3 blue takes, seconds out, 6 results, draw) | Wired; file not made |
| Between rounds | Brian | 3 (long, body, calm) = CornerMinute.LINES word for word | Wired; file not made |
| Corner shout, male | Callum | 8, one per Exchanges.CALLS key = CALLS[k].shout word for word | Wired; file not made |
| Corner shout, female | Sarah | 8, the same words | In the table; not played yet (no coach carries a sex field, so the game plays Callum) |
| Guide | Bill | 8 first-week tips | NOT wired; left out of the first generation |

Total: 42 lines in `scripts/audio/VoiceLines.gd`; the first generation makes 34 of them (the guide's 8 are skipped).

## Credits

- Spent: 0. No generation has run.
- The first run costs 34 credits (1 a line), under the 140 budget. `python tools/voice_make.py --dry-run` (free) lists
  them; the real run is the lead's call because it spends paid credits.
- The real run prints the balance before and after (`credits.available` of `ludo account show`); write both here then.

## How tools/voice_make.py makes a line (when it is run)

1. `ludo audio speech-preset` with the cast's voice and delivery note, `--request-id voicewire1-<id>-<hash>` (the same
   words and voice return Ludo's existing job instead of charging again), `--max-credits 1`, `--name <id>`, into a temp
   folder outside the repo (deleted at the end).
2. ffmpeg makes it mono 48 kHz Ogg Vorbis.
3. It is stored as `assets/audio/voice/<role>/<id>.ogg`; its row (measured peak, loudness, true peak, length, lead
   silence, rate and channels from `ludo toolbox audio info`, `heard: false`) and its event entry go into
   `assets/audio/sounds.json` at once, line by line, so a crash never re-spends a line already made.
4. A line whose file is on disk is skipped. The guide lines are skipped unless `--with-guide` is passed.
5. It stops before passing 140 credits and prints every line left unmade.

## Wiring (what plays where)

- `scripts/fight3d/FightIntro.gd`: `cue_corners` plays the opening; `cue_name_red` / `cue_name_blue` play the corner
  call, one of the three takes picked by the bout's seed; `cue_seconds_out` plays "Seconds out!".
- `scripts/fight3d/CornerMinute.gd`: `_pick()` plays the between-rounds line for the call picked.
- `scripts/fight3d/ExchangeBeats.gd`: the corner's shout beat carries `shout_call` (the call's key).
- `scripts/fight3d/BeatFire.gd`: the "say" beat with `shout_call` plays `FightVoice.shout(call, false)`.
- `scripts/ui/modals/FightNight.gd`: `_result()` plays the result announcement ONCE per result (the `_announced` flag on
  the modal; the page redraws on every click).
- The guide (Bill) is not wired anywhere; it waits for its own task.

## Test

`tests/voice_lines_test.gd` (in `tools/run_tests.sh`): every key has its line; the between-round words equal
CornerMinute.LINES and the shout words equal Exchanges.CALLS[k].shout; no digit and no name from the game's name lists
(NationalField, NoGi, Data.gd people, whole words); every event in sounds.json on the Voice bus; FightVoice's literal
ids and VoiceLines agree; each wiring call above exists in its file.

## Files

- `scripts/audio/VoiceLines.gd` - the table of every spoken line (pure data)
- `scripts/audio/FightVoice.gd` - small wrapper for the Sfx.play calls
- `tests/voice_lines_test.gd` - the test
- `tools/voice_make.py` - the generation script (paid; not run)
- `assets/audio/sounds.json` - 42 events registered on bus "Voice", files empty

## S438 run (Claude)
26 lines made on 2026-11-12, 1 credit each (1083.51 -> 1057.51), 48 kHz mono Ogg, loudness -23.4 to -19.8 LUFS, length 1.9 to 6.5 s
(between_long is the longest at 6.5 s). Left out: the 8 guide lines (not wired) and the woman coach's 8 shouts (no coach has a sex yet).
The tool now finds `ludo.cmd` on Windows (the first try found no tool and spent nothing).
