# Sound QA, S447/S448: the missing sounds, made in Ludo (UNHEARD)

Nothing here was heard. Claude and the agents cannot hear; every check below is a number. Every row in sounds.json is
`"heard": false` and nothing is wired into the game (THE EAR RULE, S385): the operator keeps, redoes or drops each take on the
sound board, and wiring is the next task.

## Status (S448)
MADE. Qwen's S447 run wrote the prompts below but generated nothing (it reported no Ludo access; the `ludo` CLI 0.2.6 on this PC
is signed in). The S448 session generated every take with the CLI on the operator's Pro plan and registered them with
`tools/audio_prep.py add` (which creates each event itself; Qwen's empty sounds.json entries were not taken).

- 26 events, 79 takes: 3 a sound, 4 for the glove block. None skipped, no job failed.
- Referee voice: Ludo preset **Daniel** (calm, firm adult male), the same voice for all 11 words; delivery note "boxing referee
  counting, firm and measured" ("Box!": "boxing referee command, sharp and firm"). Not used elsewhere in the cast (announcer
  Roger, corner Callum, female corner Sarah, guide Bill).
- Credits: 125 (46 sound-effect / 3 ambiance takes x 2 = 92 + 33 speech-preset x 1). Ludo account 1,054.51 before, 929.51 after.
- Tools: sound-effect for the one-shots; sound-effect with `--loop` for the speed bag and skipping rope (4 s); ambiance (4 s) for
  the between-rounds applause (over 3 s, so it is kind `loop`: stereo, levelled on integrated loudness).
- Ludo pads a short request to 0.5 s and the speech files carry a silent tail: the trailing silence (below -50 dB) was cut from
  each one-shot before audio_prep (which cuts the leading silence, levels, limits, 48 kHz Ogg, mono one-shots).
- Originals (Ludo downloads, real extensions) were kept outside the repo in the session scratch folder, not in assets/audio/raw/.
- Board: `docs/audio/board/sound_board.html` + `sound_board.txt` + `sound_reel.mp4` (round S448), numbers 1-79 in the order of
  this page (80-82 are the S440 between-rounds lines, still unheard); the reel is on the review board (8787/review, S448).

## How "play first" was picked (numbers only)
1. Voice: a single word should be one burst over -35 dB; one-burst takes first.
2. Length inside the wanted range (the brief's numbers).
3. Loudness nearest the kind's target (one-shot -14 momentary max, voice -16, loop -20 integrated).
A short transient that lands quieter than its target is not a fault of the take: audio_prep takes at most 3 dB off a peak, and
the event's volume_db makes it up when it is wired. `python tools/audio_prep.py check`: 30 of the 79 new takes sit more than 2 LU
from the target (loudness only; no peak, length, lead-silence or rate failures) - the same pattern as the kept punch files.

Not duplicated from ProductionCrate (S446, the operator downloads those himself): stadium crowds, the fighting punches, the
countdown. The camera shutter and menu clicks here are Ludo alternatives to his downloads; his ear picks.

## Menu (UI bus, one-shot)

### menu_click  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A soft wooden click for a menu button: short dry tick of a wooden mallet on a table edge, under 0.15 seconds, no reverb, no beep
Wanted length: 0-0.15 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 (first) | menu_click_1.ogg | 0.08 | -23.7 | too short | -1.4 | 1 | 0.08 |
| 2 | menu_click_2.ogg | 0.11 | -24.3 | too short | -1.4 | 1 | 0.11 |
| 3 | menu_click_3.ogg | 0.11 | -24.9 | too short | -1.5 | 1 | 0.11 |

Play first: take 1 - length 0.08 s against the wanted 0-0.15 s; momentary max -23.7 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): menu_click_1.ogg, menu_click_2.ogg, menu_click_3.ogg.
### menu_confirm  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A confirm click a little brighter than a soft wooden tick: a short wooden snap with a tiny high-frequency ping, under 0.15 seconds, no reverb
Wanted length: 0-0.15 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | menu_confirm_1.ogg | 0.48 | -23.9 | -25.9 | -1.3 | 2 | 0.16 |
| 2 | menu_confirm_2.ogg | 0.04 | -23.7 | too short | -1.5 | 1 | 0.04 |
| 3 (first) | menu_confirm_3.ogg | 0.12 | -23.5 | too short | -1.0 | 1 | 0.12 |

Play first: take 3 - length 0.12 s against the wanted 0-0.15 s; momentary max -23.5 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): menu_confirm_1.ogg, menu_confirm_2.ogg, menu_confirm_3.ogg.
### menu_back  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A lower back/cancel click: a short wooden thud with the high end rolled off, under 0.15 seconds, no reverb
Wanted length: 0-0.15 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | menu_back_1.ogg | 0.48 | -15.3 | -15.3 | -1.4 | 1 | 0.48 |
| 2 | menu_back_2.ogg | 0.18 | -19.9 | too short | -1.3 | 1 | 0.18 |
| 3 (first) | menu_back_3.ogg | 0.13 | -22.0 | too short | -1.3 | 1 | 0.13 |

Play first: take 3 - length 0.13 s against the wanted 0-0.15 s; momentary max -22.0 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): menu_back_2.ogg, menu_back_3.ogg.

## Fight (SFX bus, one-shot)

### punch_miss_whoosh  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A quiet air whoosh of a boxing glove passing past a head: soft cloth-and-leather swipe through air, no impact, no breath, no crowd
Wanted length: 0.2-0.35 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | punch_miss_whoosh_1.ogg | 0.48 | -16.2 | -16.2 | -1.3 | 2 | 0.25 |
| 2 (first) | punch_miss_whoosh_2.ogg | 0.26 | -23.6 | too short | -1.3 | 1 | 0.26 |
| 3 | punch_miss_whoosh_3.ogg | 0.48 | -16.9 | -16.9 | -1.2 | 2 | 0.21 |

Play first: take 2 - length 0.26 s against the wanted 0.2-0.35 s; momentary max -23.6 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): punch_miss_whoosh_2.ogg.
### punch_block  (4 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A boxing glove smacking into a glove guard: leather on leather, short padded pat with no body thud, close microphone, dry
Wanted length: 0.15-0.3 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | punch_block_1.ogg | 0.05 | -28.8 | too short | -1.5 | 1 | 0.05 |
| 2 | punch_block_2.ogg | 0.1 | -21.4 | too short | -1.3 | 1 | 0.1 |
| 3 | punch_block_3.ogg | 0.48 | -23.6 | -23.6 | -0.9 | 1 | 0.48 |
| 4 (first) | punch_block_4.ogg | 0.18 | -22.6 | too short | -1.4 | 1 | 0.18 |

Play first: take 4 - length 0.18 s against the wanted 0.15-0.3 s; momentary max -22.6 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): punch_block_1.ogg, punch_block_2.ogg, punch_block_3.ogg, punch_block_4.ogg.

## Small club crowd (Crowd bus)

### crowd_club_gasp  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A small boxing club crowd gasping after a big shot: 150 to 400 people drawing breath at once in an indoor hall, short intake, no stadium reverb
Wanted length: 1.0-2.0 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | crowd_club_gasp_1.ogg | 0.46 | -21.6 | -21.6 | -1.6 | 1 | 0.46 |
| 2 | crowd_club_gasp_2.ogg | 1.48 | -23.6 | -25.0 | -1.5 | 3 | 1.07 |
| 3 (first) | crowd_club_gasp_3.ogg | 1.36 | -17.9 | -20.8 | -6.9 | 1 | 1.36 |

Play first: take 3 - length 1.36 s against the wanted 1.0-2.0 s; momentary max -17.9 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): crowd_club_gasp_1.ogg, crowd_club_gasp_2.ogg, crowd_club_gasp_3.ogg.
### crowd_club_oooh  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: An "oooh" from a small club crowd after a near miss: 200 people murmuring "oooh" in a hall, warm and low, no stadium echo
Wanted length: 1.5-2.5 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | crowd_club_oooh_1.ogg | 1.96 | -15.7 | -17.9 | -3.3 | 1 | 1.96 |
| 2 (first) | crowd_club_oooh_2.ogg | 1.9 | -14.7 | -17.7 | -4.1 | 2 | 1.78 |
| 3 | crowd_club_oooh_3.ogg | 2.0 | -14.8 | -17.7 | -3.7 | 1 | 2.0 |

Play first: take 2 - length 1.9 s against the wanted 1.5-2.5 s; momentary max -14.7 against the -14.0 target.
### crowd_club_boos  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: Scattered boos from a small club crowd: a handful of voices booing in a 300-seat hall, not a stadium roar, disapproving but thin
Wanted length: 2.0-3.0 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | crowd_club_boos_1.ogg | 2.48 | -16.7 | -19.3 | -5.5 | 1 | 2.48 |
| 2 (first) | crowd_club_boos_2.ogg | 2.48 | -15.8 | -18.1 | -4.2 | 1 | 2.48 |
| 3 | crowd_club_boos_3.ogg | 2.48 | -17.1 | -20.0 | -5.7 | 1 | 2.48 |

Play first: take 2 - length 2.48 s against the wanted 2.0-3.0 s; momentary max -15.8 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): crowd_club_boos_3.ogg.
### crowd_club_applause  (3 takes, `ludo audio ambiance`, 2 credit(s) a take)
Prompt: Polite applause between rounds in a small boxing club: 200 people clapping in an indoor hall, moderate and even, not enthusiastic
Wanted length: 3.0-5.0 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | crowd_club_applause_1.ogg | 4.0 | -17.7 | -20.7 | -2.4 | 1 | 4.0 |
| 2 (first) | crowd_club_applause_2.ogg | 4.0 | -17.5 | -20.1 | -6.6 | 1 | 4.0 |
| 3 | crowd_club_applause_3.ogg | 4.0 | -18.2 | -21.0 | -2.3 | 1 | 4.0 |

Play first: take 2 - length 4.0 s against the wanted 3.0-5.0 s; integrated -20.1 against the -20.0 target.
### crowd_club_cheer  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A short cheer for the home fighter in a small club: 300 people cheering briefly in a hall, one burst, no stadium size
Wanted length: 2.0-3.0 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | crowd_club_cheer_1.ogg | 2.38 | -17.1 | -22.4 | -6.0 | 2 | 2.17 |
| 2 (first) | crowd_club_cheer_2.ogg | 2.48 | -14.2 | -16.5 | -1.9 | 1 | 2.48 |
| 3 | crowd_club_cheer_3.ogg | 2.48 | -15.8 | -18.9 | -6.1 | 2 | 2.19 |

Play first: take 2 - length 2.48 s against the wanted 2.0-3.0 s; momentary max -14.2 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): crowd_club_cheer_1.ogg.

## Fight (SFX bus, one-shot)

### camera_shutter_burst  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A press-photographer camera shutter burst: 3 to 5 rapid DSLR clicks in one burst, mechanical shutter, close microphone, indoor
Wanted length: 0.5-1.0 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 (first) | camera_shutter_burst_1.ogg | 0.86 | -14.3 | -14.4 | -2.7 | 1 | 0.86 |
| 2 | camera_shutter_burst_2.ogg | 0.75 | -14.5 | -15.4 | -0.7 | 1 | 0.75 |
| 3 | camera_shutter_burst_3.ogg | 0.92 | -15.5 | -16.2 | -0.6 | 1 | 0.92 |

Play first: take 1 - length 0.86 s against the wanted 0.5-1.0 s; momentary max -14.3 against the -14.0 target.
### camera_shutter_single  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A single camera shutter click: one DSLR photo click, mechanical shutter, close microphone, indoor
Wanted length: 0.1-0.25 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | camera_shutter_single_1.ogg | 0.24 | -19.7 | too short | -1.1 | 1 | 0.24 |
| 2 (first) | camera_shutter_single_2.ogg | 0.21 | -16.3 | too short | -1.4 | 1 | 0.21 |
| 3 | camera_shutter_single_3.ogg | 0.24 | -16.4 | too short | -1.0 | 1 | 0.24 |

Play first: take 2 - length 0.21 s against the wanted 0.1-0.25 s; momentary max -16.3 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): camera_shutter_single_1.ogg.

## Gym (SFX bus)

### gym_heavy_bag  (3 takes, `ludo audio sound-effect`, 2 credit(s) a take)
Prompt: A heavy bag thud: a body hook landing on a 45 kg hanging heavy bag in a gym, deep leather-on-canvas thud with bag chain rattle, no crowd
Wanted length: 0.3-0.8 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | gym_heavy_bag_1.ogg | 0.21 | -19.8 | too short | -1.3 | 1 | 0.21 |
| 2 (first) | gym_heavy_bag_2.ogg | 0.76 | -16.3 | -17.5 | -1.2 | 1 | 0.76 |
| 3 | gym_heavy_bag_3.ogg | 0.31 | -16.4 | too short | -1.3 | 1 | 0.31 |

Play first: take 2 - length 0.76 s against the wanted 0.3-0.8 s; momentary max -16.3 against the -14.0 target.
Lands quieter than the -14.0 target because audio_prep takes at most 3 dB off a transient peak (its event volume_db makes it up when wired): gym_heavy_bag_1.ogg.
### gym_speed_bag_loop  (3 takes, `ludo audio sound-effect --loop`, 2 credit(s) a take)
Prompt: A speed bag rattle loop: a leather speed bag being hit in a steady rhythm in a gym, rapid rhythmic tapping, seamless loop point
Wanted length: 4-4 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 (first) | gym_speed_bag_loop_1.ogg | 4.0 | -18.0 | -20.3 | -3.5 | 1 | 4.0 |
| 2 | gym_speed_bag_loop_2.ogg | 4.0 | -16.2 | -20.6 | -2.1 | 2 | 3.62 |
| 3 | gym_speed_bag_loop_3.ogg | 4.0 | -18.1 | -20.3 | -2.1 | 1 | 4.0 |

Play first: take 1 - length 4.0 s against the wanted 4-4 s; integrated -20.3 against the -20.0 target.
### gym_skip_rope_loop  (3 takes, `ludo audio sound-effect --loop`, 2 credit(s) a take)
Prompt: A skipping rope tapping loop: a jump rope hitting a gym floor in a steady rhythm, soft rubber-on-mat tapping, seamless loop point
Wanted length: 4-4 s.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | gym_skip_rope_loop_1.ogg | 4.0 | -20.8 | -23.0 | -1.9 | 2 | 3.88 |
| 2 | gym_skip_rope_loop_2.ogg | 4.0 | -19.8 | -23.2 | -2.3 | 10 | 2.11 |
| 3 (first) | gym_skip_rope_loop_3.ogg | 4.0 | -18.6 | -20.4 | -1.9 | 1 | 4.0 |

Play first: take 3 - length 4.0 s against the wanted 4-4 s; integrated -20.4 against the -20.0 target.

## Referee count (Voice bus, Ludo preset voice Daniel)

### ref_count_one  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'One.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_one_1.ogg | 2.57 | -16.1 | -18.1 | -1.4 | 3 | 1.41 |
| 2 (first) | ref_count_one_2.ogg | 1.71 | -16.0 | -17.8 | -1.4 | 2 | 1.1 |
| 3 | ref_count_one_3.ogg | 1.74 | -16.0 | -17.3 | -2.2 | 2 | 1.12 |

Play first: take 2 - 2 burst(s) over -35 dB (a single word should be 1); length 1.71 s; momentary max -16.0 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_one_1.ogg, ref_count_one_2.ogg, ref_count_one_3.ogg.
### ref_count_two  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Two.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_two_1.ogg | 0.6 | -16.3 | -18.4 | -1.5 | 2 | 0.44 |
| 2 | ref_count_two_2.ogg | 0.58 | -16.1 | -16.9 | -2.1 | 2 | 0.45 |
| 3 (first) | ref_count_two_3.ogg | 0.43 | -16.1 | -16.1 | -1.8 | 1 | 0.43 |

Play first: take 3 - 1 burst(s) over -35 dB (a single word should be 1); length 0.43 s; momentary max -16.1 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_two_1.ogg, ref_count_two_2.ogg.
### ref_count_three  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Three.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 (first) | ref_count_three_1.ogg | 0.68 | -16.0 | -16.4 | -1.6 | 1 | 0.68 |
| 2 | ref_count_three_2.ogg | 0.68 | -16.1 | -16.5 | -1.6 | 1 | 0.68 |
| 3 | ref_count_three_3.ogg | 1.77 | -16.1 | -17.6 | -1.3 | 2 | 1.02 |

Play first: take 1 - 1 burst(s) over -35 dB (a single word should be 1); length 0.68 s; momentary max -16.0 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_three_3.ogg.
### ref_count_four  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Four.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 (first) | ref_count_four_1.ogg | 1.76 | -16.0 | -17.2 | -1.5 | 2 | 1.09 |
| 2 | ref_count_four_2.ogg | 1.75 | -15.9 | -18.0 | -2.3 | 2 | 1.15 |
| 3 | ref_count_four_3.ogg | 2.74 | -15.9 | -17.5 | -1.5 | 3 | 1.76 |

Play first: take 1 - 2 burst(s) over -35 dB (a single word should be 1); length 1.76 s; momentary max -16.0 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_four_1.ogg, ref_count_four_2.ogg, ref_count_four_3.ogg.
### ref_count_five  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Five.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_five_1.ogg | 0.73 | -16.1 | -17.5 | -1.7 | 1 | 0.73 |
| 2 (first) | ref_count_five_2.ogg | 0.7 | -16.0 | -17.3 | -1.7 | 1 | 0.7 |
| 3 | ref_count_five_3.ogg | 0.72 | -16.0 | -17.1 | -1.6 | 1 | 0.72 |

Play first: take 2 - 1 burst(s) over -35 dB (a single word should be 1); length 0.7 s; momentary max -16.0 against the -16.0 target.
### ref_count_six  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Six.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 (first) | ref_count_six_1.ogg | 1.89 | -16.4 | -18.8 | -1.0 | 2 | 1.42 |
| 2 | ref_count_six_2.ogg | 3.02 | -16.4 | -19.0 | -1.5 | 3 | 2.08 |
| 3 | ref_count_six_3.ogg | 2.86 | -17.1 | -19.7 | -1.5 | 3 | 2.0 |

Play first: take 1 - 2 burst(s) over -35 dB (a single word should be 1); length 1.89 s; momentary max -16.4 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_six_1.ogg, ref_count_six_2.ogg, ref_count_six_3.ogg.
### ref_count_seven  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Seven.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_seven_1.ogg | 0.67 | -17.0 | -17.1 | -1.4 | 1 | 0.67 |
| 2 (first) | ref_count_seven_2.ogg | 0.69 | -16.6 | -16.7 | -1.4 | 1 | 0.69 |
| 3 | ref_count_seven_3.ogg | 1.58 | -16.3 | -18.1 | -1.4 | 2 | 1.07 |

Play first: take 2 - 1 burst(s) over -35 dB (a single word should be 1); length 0.69 s; momentary max -16.6 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_seven_3.ogg.
### ref_count_eight  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Eight.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_eight_1.ogg | 1.43 | -16.5 | -18.2 | -1.5 | 2 | 0.85 |
| 2 | ref_count_eight_2.ogg | 1.34 | -16.7 | -18.4 | -1.3 | 2 | 0.9 |
| 3 (first) | ref_count_eight_3.ogg | 0.47 | -16.3 | -16.3 | -1.6 | 1 | 0.47 |

Play first: take 3 - 1 burst(s) over -35 dB (a single word should be 1); length 0.47 s; momentary max -16.3 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_eight_1.ogg, ref_count_eight_2.ogg.
### ref_count_nine  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Nine.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_nine_1.ogg | 3.08 | -16.1 | -18.3 | -1.4 | 4 | 1.97 |
| 2 | ref_count_nine_2.ogg | 2.03 | -16.1 | -18.0 | -2.0 | 3 | 1.44 |
| 3 (first) | ref_count_nine_3.ogg | 1.93 | -16.0 | -18.4 | -1.4 | 2 | 1.48 |

Play first: take 3 - 2 burst(s) over -35 dB (a single word should be 1); length 1.93 s; momentary max -16.0 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_count_nine_1.ogg, ref_count_nine_2.ogg, ref_count_nine_3.ogg.
### ref_count_ten  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Ten.', voice Daniel, delivery: boxing referee counting, firm and measured
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_count_ten_1.ogg | 0.61 | -16.5 | -18.2 | -1.2 | 1 | 0.61 |
| 2 | ref_count_ten_2.ogg | 0.61 | -16.6 | -18.4 | -1.4 | 1 | 0.61 |
| 3 (first) | ref_count_ten_3.ogg | 0.61 | -16.4 | -18.1 | -1.6 | 1 | 0.61 |

Play first: take 3 - 1 burst(s) over -35 dB (a single word should be 1); length 0.61 s; momentary max -16.4 against the -16.0 target.
### ref_box  (3 takes, `ludo audio speech-preset`, 1 credit(s) a take)
Prompt: text 'Box!', voice Daniel, delivery: boxing referee command, sharp and firm
Wanted: one word, under 0.8 s, one burst.

| take | file | length s | loudness (momentary max) | integrated LUFS | true peak dB | bursts at -35 dB | sounding s |
|---|---|---|---|---|---|---|---|
| 1 | ref_box_1.ogg | 1.52 | -16.7 | -18.9 | -1.3 | 2 | 1.16 |
| 2 | ref_box_2.ogg | 2.41 | -16.3 | -19.0 | -1.3 | 3 | 1.7 |
| 3 (first) | ref_box_3.ogg | 2.35 | -16.1 | -18.5 | -1.4 | 3 | 1.73 |

Play first: take 3 - 3 burst(s) over -35 dB (a single word should be 1); length 2.35 s; momentary max -16.1 against the -16.0 target.
More than one burst (maybe a breath, a room tail or a second word - only the ear can say): ref_box_1.ogg, ref_box_2.ogg, ref_box_3.ogg.
