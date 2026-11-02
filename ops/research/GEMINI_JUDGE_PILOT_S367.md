# Gemini as the animation judge - pilot (S367, 2026-11-02)

Operator: "gemini 4 seems to be good, how can we best get advantage of it" -> "Free AI Studio" -> "i can pay for gemini 4".
Why Gemini: it watches video natively (Claude sees frames only); our costliest repeated failure is judging motion
(SMOOTH3 ran five rounds; the operator was the one who saw the defects).

## Access (read the live page before trusting this)
- AI Studio (aistudio.google.com, his Google account, his Chrome via Claude-in-Chrome). Free tier = Gemini 3.8 Flash.
  Gemini 4 Argon is marked "Paid" even in AI Studio ($2 / $10 per 1M tokens in/out to 2026-11-30, then $4 / $20).
- Upload: `find` the `input[type=file]` in the prompt bar, `file_upload` the mp4s (under 10 MB a call).
- VIDEO SETTINGS PER CLIP (the gear on each attachment): FPS DEFAULTS TO 1 - a 4 s clip is 4 frames and a snap is
  invisible. Set 24 (the maximum) on every clip: 6,817 tokens per 4 s clip instead of 285.
- Remove the Google Search grounding chip: it should watch, not search.
- It does NOT see file names: name the intended move per clip in the prompt ("Video 1 = the jab beat ...").

## The prompt that worked
Strict animation supervisor; turntable (camera circles, boxer in place); motion only; per video: what move + does it
read; defects with timestamps (snap/pop, foot slide, float/sink, glove through head/body, joints bent wrong/hyperextended,
jitter, wrong speed, weight transfer + rear hand at chin, balance), "none seen" when a check passes; SHIP / FIX / CUT
with a one-line reason; "if the turntable hides something, say so". (Full text: AI Studio history, "Boxing Animation
Motion Critique".)

## Pilot: Gemini 3.8 Flash, 3 IN GAME clips, 24 fps, checked against 12-frame contact sheets
| clip (game use) | Gemini | frames say |
|---|---|---|
| pro_right_hook_hard (the rear hook beat) | CUT: both hands drop to hip level before the punch 0:00.45-0.65; looping, telegraphed; rear foot drags 3.15-3.45 | CONFIRMED: frames 20-30 (0.7-1.0 s) both gloves at the waist; frame 90 arms swung wide |
| pro_left_jab_c (the jab beat) | FIX: reads as a 1-2; right elbow snaps to lockout 2.04-2.16; lead glove drops during the cross | consistent: a second straight punch fully extended at frame 60 (2.0 s) - the "jab" clip holds two punches |
| pro_hit_by_hook_v7_short (the knockback when hurt) | SHIP as a "bob and weave" (ducks 0.40-0.70 and 2.35-2.75) | it was not told the clip is a hit reaction; frames: head snaps back 0.7 s, deep crouch 2.7 s - the knockback READS AS A DUCK |

Verdict: Flash is a usable first-pass judge (caught a real in-game defect with the right timing); it must be told the
intended move. Next: the same three clips on Gemini 4 Argon once billing is on (does it see more?), then every clip of
the board's /animations page, then fight films; rear hook / knockback / jab replacements screened by it before the
operator's visual gate.

## Gemini 4 Argon on the fight film (API route, Tools/gemini_judge.py)
AI Studio's browser upload failed on every video once his paid key was linked (HTTP 500 'Token count failed'); the
API said why: HTTP 402, prepaid credit depleted (-EUR 0.68; EUR 5 added 4 Oct, auto-reload off). He bought credits.
30 s of a live round (review/S367_playtest/film/fight_round_clip_60-90s.mp4), 24 fps: 55,830 tokens in, 2,156 out,
$0.1332, 45 s. Verdict 2/10: clinches merge (0:18-0:21, 0:24-0:26), the referee's break crouches between them with an
arm through Blue's waist (0:21-0:22), a short jab still snaps Red's head (0:08), an inside punch passes through with no
reaction (0:24), feet slide, ~60-70% of real speed, a 180-degree orbit mid-exchange, the referee in the foreground.
CHECKED on full-resolution frames at 0:21.6 and 0:24.6: both true. Argon is a credible judge of motion.
