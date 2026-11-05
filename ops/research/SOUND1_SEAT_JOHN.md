# John - SOUND1: write the Ludo prompts a top game sound designer would write (S385)

FightCamp is a boxing gym manager with a 3D fight you watch (Godot). The operator wants "top sound quality" - better than the
games praised for sound. All our sounds come from Ludo.ai's text-to-audio (sound effects up to 10 s, looping ambiance, music,
preset-voice speech). Our first single-prompt punches came out as thin clicks (a jab 0.16 s long, almost all transient, no
body), so round 1 builds every punch from LAYERS played together: a transient snap, a low body thud (head or torso), and a
short ring/room tail.

Please answer in two parts.

PART 1 - real-world reference, short: how does a real punch sound at ringside vs on a TV broadcast (HBO/Sky/DAZN mic
positions: ring-post mics, the canvas mic), and how did boxing games known for sound (Fight Night Round 3/Champion, Undisputed,
The Thrill of the Fight) build their punches - recordings of what (meat, leather, celery, wet towels...), how many layers and
variants? Name your sources (links).

PART 2 - the prompts. One line per prompt, in this exact form: `event_id | duration s | prompt text`. Each prompt names the
material, the distance to the mic, dry or with room, the length, and what to leave out (no music, no crowd, no voice). Write:
- punch_snap x4 (0.15-0.3 s), punch_thud_head x4 (0.3-0.6 s), punch_thud_body x4 (0.3-0.6 s), punch_tail x2 (0.5-1.0 s)
- punch_blocked x3, punch_miss x3 (glove + arm air whoosh with a sharp nasal exhale), footwork_canvas x3
- clinch_grab x2, breath_effort x3, grunt_hurt x2, knockdown_fall x2, crowd_roar x2, crowd_round_swell, crowd_finish
- corner_minute_bed (looping ambiance: stool, bottle, crew murmur), corner_water
- ui_click x2, ui_card_flip x2, ui_confirm, ui_meter_tick (each under 0.2 s, warm, not digital beeps)
- music_menu and music_fight_night (instrumental: genre, tempo BPM, instruments, mood, structure for a loop)
- the referee: the voice description for one gruff veteran referee, and the ten count words as he shouts them
Longest complete answer you can give.
