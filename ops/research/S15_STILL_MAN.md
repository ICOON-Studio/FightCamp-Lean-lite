# S15 — THE STILL MAN: nothing is owed, and here is the measurement that says so

S15's second half, and the honest answer is the one the task file said to say if
it was true: **the man who is not travelling is not frozen, and this stage owes
him no animation.** He is in the stance, and the stance moves.

Measurement tool: `Godot/tools/probe_stance_motion.gd`
(`godot --headless --path Godot --script tools/probe_stance_motion.gd`).
Raw output: `research/S15_stance_motion.json`.

## THE QUESTION, AND WHY IT WAS OPEN

S10 crossed the 30,599 `movement`-class degrades against the live walk overlay
over 400 bouts and split them: **60.1% visibly stepping**, **39.8% below
`FightStagePlayer.WALK_MIN_RATE`** — about 12,000 beats, 3.6% of all action
beats. On that second group `walk_at` drops the legs and returns the body to the
stance (`FightStagePlayer.gd:466-472`).

`S10_MOVEMENT_DEGRADES.md` then said both of these things about that group, on
its own page:

| where | what it says |
|---|---|
| its table, line 36 | "moving but BELOW the walk floor (**stance plays**)" |
| its prose, line 48 | "the 39.8% below the walk floor **ARE the frozen man**" |

They cannot both be true, and which one is decides whether S15 owes an
animation. So it was measured rather than argued.

## THE SEAM IS NOT THE ANSWER, AND IT IS THE FIGURE THAT WAS ON FILE

`FightClipBinding`'s `idle` row carries the only number anyone had: *"A REAL
LOOP, measured at 0.1 deg across 4.67 s."* That is a **seam** measurement — the
first pose against the last — and it says the clip loops without a jump. **A
0.1 deg seam is equally consistent with a body that breathes for 4.67 s and with
one that never moves at all.** It was never evidence either way, and it had been
sitting in the file looking like evidence.

## METHOD

Virtual FK, the C92 / Q61 approach: sample the Animation's own tracks and walk
the UE4 Mannequin parent chain to a global pose. `Skeleton3D` is never asked for
a global pose — headless it returns the rest pose, which is exactly the failure
this probe would otherwise be measuring. 60 Hz over the window the BINDING plays
(`start_s`..`end_s`), not the whole file.

**Units are metres, and that was checked rather than assumed.** The FBX files are
authored in UE4 centimetres; Godot's importer applies its own scale. The probe
reads `loc_advance`'s pelvis bounding box at 0.077, and `FightClipBinding`'s own
recorded figure for that clip is "0.167 m of root travel" — same order, so
metres.

**The walk is measured beside the stance ON PURPOSE.** A number for the stance
alone says nothing without a clip we already agree reads as movement to stand it
against. `loc_advance` and `loc_retreat` are that control.

## WHAT THE STANCE DOES

| role | window s | joint | travel m | box diag m | mean m/s | peak m/s |
|---|---:|---|---:|---:|---:|---:|
| `idle` | 4.67 | pelvis | 0.192 | 0.034 | 0.041 | 0.112 |
| `idle` | 4.67 | head | 0.238 | 0.046 | 0.051 | 0.112 |
| `idle` | 4.67 | hand_l | 0.272 | 0.048 | 0.058 | 0.113 |
| `idle` | 4.67 | hand_r | 0.237 | 0.040 | 0.051 | 0.111 |
| `idle` | 4.67 | foot_l | 0.022 | 0.002 | 0.005 | 0.018 |
| `idle` | 4.67 | foot_r | 0.020 | 0.001 | 0.004 | 0.016 |
| `loc_advance` | 1.00 | pelvis | 0.247 | 0.077 | 0.247 | 0.435 |
| `loc_advance` | 1.00 | head | 0.248 | 0.079 | 0.248 | 0.409 |
| `loc_advance` | 1.00 | hand_l | 0.346 | 0.116 | 0.346 | 0.761 |
| `loc_advance` | 1.00 | hand_r | 0.327 | 0.119 | 0.327 | 1.037 |
| `loc_advance` | 1.00 | foot_l | 1.690 | 0.818 | 1.690 | 3.888 |
| `loc_advance` | 1.00 | foot_r | 1.735 | 0.842 | 1.735 | 3.212 |
| `loc_retreat` | 1.00 | pelvis | 0.248 | 0.080 | 0.248 | 0.434 |
| `loc_retreat` | 1.00 | foot_l | 1.699 | 0.821 | 1.699 | 3.957 |

(`loc_retreat`'s remaining joints are within 0.01 of `loc_advance`'s and are in
the JSON.)

**THE STANCE IS A BREATHING GUARD WITH PLANTED FEET.** Read the three columns
together, because each alone is misleading:

- **It never stops.** Head and hands travel 0.24-0.27 m over the loop at a mean
  0.05 m/s, and the peak is 0.11 m/s — continuous motion, no held frames.
- **It goes nowhere.** Every bounding box is 3-5 cm. The body rides in place.
- **The feet are planted**, 2 cm of travel and a 1-2 mm box against the walk's
  1.7 m and 0.82 m. That is what makes it a stance rather than a slow walk, and
  it is the right picture for a man who is NOT travelling: feet down, weight
  moving.

Against the control, the stance's upper body runs at about **one sixth** of the
walk's rate (pelvis 0.041 m/s against 0.247) while its feet run at about **one
three-hundredth** (0.005 against 1.690). Those are two different numbers on
purpose: the walk's signature is its FEET, and the stance keeps everything else.

## THE VERDICT

**Nothing is owed, and the counter was the only defect.**

Under the operator's 2026-09-18 ruling — *"Footwork is purely scoring and rhythm,
and helps dodge, repositioning and in general is the catalyst in transitioning
defined by speed, never needed to move anybody"* — a man who is not travelling
is supposed to be showing RHYTHM, and a 4.67 s loop of continuous 3-5 cm
weight movement over planted feet **is** that rhythm. S10's line 36 was right
and its line 48 was wrong.

So S15 adds no clip, buys nothing, and authors nothing. What it changes is that
the room stops filing these beats under the same word it uses for a man who was
named as throwing a punch and showed nothing (`S15_ROUTE.md`).

## WHAT THIS DOES NOT SAY — three limits, stated because each could be mistaken
## for the finding

1. **This measures the CLIP, not the room.** It says the stance has motion in it;
   it does not, by itself, say the room is playing it on those beats. The room's
   side of that is code rather than measurement and is cited, not re-derived:
   `walk_at` calls `play_role(ROLE_IDLE)` explicitly on the below-floor path
   (`FightStagePlayer.gd:466-472`), `play_role` refuses to restart a loop that is
   already running so it continues rather than twitching, and Q85 found 0 frozen
   frames through the stance path. **A room-side count is what would close this
   properly**, and `presentation_counts().stanced` is now the counter to read it
   off — S15 added it, S15 did not spend a recording on it.
2. **It says nothing about VARIETY.** One 4.67 s loop under both men is a
   separate criticism from "frozen", it was not measured here, and R123 already
   puts the two bodies half a cycle apart for exactly that reason.
3. **It is `idle` as bound today.** `measure_stance_takes.gd` and the variant
   system mean a second stance take could change these numbers; the probe takes a
   role name on the command line so any future take can be measured the same way.

## THE ROW THIS LEAVES OPEN, AND ITS SIZE

The ~12,000 below-floor beats are not a defect, but they are a place where the
picture is thin: one stance loop, no weight shift toward the opponent, no stance
switch, no level change, however the engine scored the beat. **That is a
CONTENT question, not an accounting one**, it is not S15's, and it is not being
proposed here — it is written down with its number so a later session does not
have to rediscover it: **12,185 beats, 3.6% of all action beats** (S10's own
figures, 400 bouts).
