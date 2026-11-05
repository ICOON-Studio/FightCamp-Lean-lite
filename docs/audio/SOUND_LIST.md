# FightCamp sound list - ranked by what the player feels (S385, Claude)

Owner: the SOUND ENGINEER seat (Qwen, from S385 - see `ops/research/TASK_SOUND1.md`). Scope: the boxing demo + no-gi BJJ.
Tool: Ludo audio on the operator's Pro plan (`ludo audio sound-effect | ambiance | music | speech-preset`), no other
generator. Files live in `assets/audio/<group>/`, listed in `assets/audio/sounds.json` (the one source of truth).

EAR RULE: Claude and the seats cannot hear. A sound is "unheard" until the operator has played it on the sound board and
said keep. Operator S133 on CC0 samples nobody had listened to: "the sounds are so bad wtf ... did you approve those sounds
for a AAA title ?" No sound is called good, done or AAA by anyone but him.

THE BAR: `ops/research/SOUND_BENCHMARK_S385.md` (24 rules from the games praised for sound). Where its numbers differ from
this page - variant counts (R3: >= 8 per punch layer), per-event loudness classes (R12), formats (R13), tails (R14) - THE
BENCHMARK WINS; the variant column below is the round-0 floor only.

Built on J22 / J22B (cue lists, beat triggers) and J40 (shortlist). Ranking follows J22B: impacts first, then the big
moment (big shot, knockdown), then block/slip, then breath and voice, then crowd - plus the bell, which every round needs.

## Tier 1 - the fight cannot ship without these (round 1)
| # | Event id | When it plays (game event) | Variants wanted |
|---|---|---|---|
| 1 | `punch_jab_head` | a jab lands on the head | 4 |
| 2 | `punch_power_head` | a cross / hook / uppercut lands on the head | 4 |
| 3 | `punch_body` | any punch lands on the body (body hook, kidney) | 3 |
| 4 | `punch_big` | the round's big shot lands (the slow-motion close-up) | 2 |
| 5 | `punch_blocked` | a punch meets the gloves / forearms / elbow | 3 |
| 6 | `punch_miss` | a punch misses or is slipped (glove whoosh) | 3 |
| 7 | `bell_round_start` | the round starts | 1 |
| 8 | `bell_round_end` | the round ends (the 3 dings) | 1 |
| 9 | `crowd_arena_loop` | the bed under every fight round (loops) | 1 |
| 10 | `crowd_roar` | the big shot and the knockdown | 2 |
| 11 | `knockdown_fall` | the downed boxer hits the canvas | 2 |
| 12 | `ref_count` | the referee's count, one word per number (1..10), speech | 10 lines |

## Tier 2 - makes it feel real (round 1 if credits allow, else round 2)
| # | Event id | When it plays | Variants |
|---|---|---|---|
| 13 | `footwork_canvas` | step in / step out / side step on the canvas | 3 |
| 14 | `clinch_grab` | a clinch starts (bodies and gloves tie up) | 2 |
| 15 | `ref_break` | the referee breaks the clinch ("break!") | 1 |
| 16 | `breath_effort` | a power punch is thrown (short exhale) | 3 |
| 17 | `grunt_hurt` | a hurt / big shot is taken | 2 |
| 18 | `crowd_round_swell` | crowd lifts at the end of a round | 1 |
| 19 | `corner_minute_bed` | the corner minute: stool, water bottle, the crew's murmur (loop) | 1 |
| 20 | `corner_water` | the water bottle squirt in the corner | 1 |
| 21 | `seconds_out` | "seconds out" before the next round | 1 |
| 22 | `crowd_finish` | the stoppage / the decision is read | 1 |

## Tier 3 - the gym, BJJ and the menus
| # | Event id | When it plays | Variants |
|---|---|---|---|
| 23 | `ui_click` | any button press (UI.button) | 2 |
| 24 | `ui_card_flip` | a card turns over (FlipCard.flip) | 2 |
| 25 | `ui_meter_tick` | a meter grows / a band changes (Bar tween end) | 1 |
| 26 | `ui_confirm` | end the week / book the fight / confirm | 1 |
| 27 | `ui_cash` | money in at the week review | 1 |
| 28 | `gym_pads_pop` | a punch lands on the coach's mitt (pad work) | 3 |
| 29 | `gym_heavy_bag` | heavy bag thump | 3 |
| 30 | `gym_skip_rope` | skipping rope loop | 1 |
| 31 | `gym_room_loop` | the gym bed: bags, ropes, a timer, people training | 1 |
| 32 | `gym_round_timer` | the gym's round timer buzzer | 1 |
| 33 | `bjj_mat_scramble` | bodies moving on the mat (a BJJ transition) | 3 |
| 34 | `bjj_slap_bump` | the slap-and-bump at the start of a roll | 1 |
| 35 | `bjj_tap` | a tap on the mat / the body | 2 |
| 36 | `bjj_mat_loop` | the BJJ academy bed | 1 |

## Music
| # | Event id | Where | Length |
|---|---|---|---|
| 37 | `music_menu` | title + home menus (loop, low under the UI) | 90-120 s |
| 38 | `music_fight_night` | fight night: the walk-out and the card screen | 60-90 s |
| 39 | `music_week_review` | the week review / training week (calm, loop) | 90 s |

## Mix (the starting point, not a verdict)
Buses: Master > Music (-14 dB), SFX (-4 dB), Crowd (-12 dB), UI (-10 dB). Impacts dry and close; crowd and bells carry the room.
Every playing sound gets a small random pitch (+-4%) and volume (+-1.5 dB) so a repeat never sounds like a copy. The crowd bed
ducks 4 dB for 0.6 s under a big shot. Headless runs and agent worktrees stay silent (Dummy driver, `override.cfg`); the
shipped .exe plays sound.
