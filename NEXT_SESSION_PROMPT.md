# S438 handover (written 2026-11-12 after midnight, end of S437)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S438`
and redraw Miro. Read ops/research/S437_DIGEST.md first.

## USAGE FIRST
`get_usage`. S437 at 23:55: all models 60 %, Fable 80 % (reset Thu 2026-11-12 16:00), extra usage EUR 37.92 of 40.
Workflows ran on Opus (`model: 'opus'` on every agent) and cost about 3 % of the week for 12 agents: keep doing that.

## HIS WORDS (S437)
- Damage: "i want the ribs to take normally the damage and deepen/streghten/tighten the damage system/mechanic and hit
  system , have the current one judged and  improve it , same with the recovery mechanics when an area become injured
  options for player to act etc".
- On a rib sketch with two ovals on the chest: "do not make it like this , it looks like tits, use the hook line and the
  pointer out of the body".
- "do we have mechanic to show damage done during the fight on the faces ?" (answer given: only the small 2D close-up).
- Design reviews: keep the 7+ bar, fix found defects at once, send him the critics' verdict on today's game early: "ok".
- Clips: "whos verifying the boxing clips ? i still see only one on the board ?"; on rk_jab / rk_cross "the fists have no
  power , are the animationsbad ?"; to side films + the Gemini judge on the fight's punches: "go".
- Ludo: "sub is paid normally for a month, after that it is paused" (3 months); "credits still work 1083 right now".

## 1. WAITING ON HIM
- The Gemini judge is braked: the month's budget on the meter is used up (33.26 of 33.26). He raises the cap at
  ai.studio/spend, then `python ops/Tools/gemini_meter.py budget <n>`. Until then no clip can pass by the judge.
- His OK (or a named fault) on the seven guard clips and his look at the seven side films of the punches, the glove
  touch still and the rank stills (review board, S437).
- DAMAGE_MAP_S437.md: see section 2 for where round 3 ended. It carries three reopenings that need his yes (a seventh
  body place, "keep the date" replacing his settled "fight hurt", offers while out).
- Miro "P0 Where we are": old surplus cards need his yes to delete (the redraw is sent WITHOUT data-deleted lines).

## 2. THE DAMAGE DESIGN (his ask; the session's main thread)
- ops/research/DAMAGE_MAP_S437.md. v1 scored 6 / 6, v2 6.5 / 6 (clarity 6 / 5). ROUND 3 RESULT: see the line Claude
  appended at the bottom of this file. Under 7 from either critic = another round (change the mechanic, not the
  wording); at 7+ from both = `ask` on the board with the map attached and the two critics' 10/10 pictures
  (docs/mockups/s437/damage/critic_*_10.png).
- The critics' verdict on TODAY's game (3 and 3.5) and the readers' maps are in the journal of workflow wf_74a9d903-fa0
  (C:\Users\user\.claude\projects\E--FightCamp-Lean\fee9e229-87fa-421f-8e36-8a78c378b4b9\subagents\workflows\).
- Every body picture: tinted muscle + a hooked line out of the body to a label. Never blobs on the chest.

## 3. SEATS
- RIBS1 (Cursor): the ribs defect in today's rules (both sides hit, one RIB_HIT number tuned to bars, body hooks that
  no longer vanish in ExchangeBeats). Collect by diff; at collect re-check the rib INJURY rate (ribs at 35 or under
  triple the rib weight in InjuryRoll) and read the result page tile ("Nothing lasting" after 21 body shots is the
  bug he sees).
- PR 218 VOICEWIRE1 (Qwen): NOT collected. It touches scripts/fight3d/FightIntro.gd (changed in S437: loosen) and
  FightNight.gd (changed by RANKSHOWUI): by diff. Its tools/voice_make.py was never run: after the collect run it
  (42 lines, 42 Ludo credits, budget 140), convert, post each role to the sound board (heard=false until his ear).
  Ludo must do ALL approved audio and paintings before about 2026-12-11.
- PR 211 CALLSPREAD1: still held (after the foundation).
- Cursor after RIBS1: PAGES2, ROPEENTRY2, BJJLOOK1 have no brief; the damage map's build order will give screen tasks.

## 4. ANIMATION (every session)
D0 done so far: BEAT_TALLY, the two punch rulers (S436), the re-measured contact file and short_m deleted (S437,
ops/research/HIT_GAP_S437.md). NEXT in order: (3) human_feet on the default route; (4) a layer-order test; (5)
tests/fight_bout_test.gd, the frozen real-bout ruler, run several times with the spread reported; (6) the corner-face
scene and ruler. THEN CONTACT1 (bar: the rear hook 3.4 cm into the blocking glove, and pro_left_hook 0.21 m to the side /
pro_left_jab_a 0.15 to 0.26 m low at pelvis gap 0.84 to 0.95 m), POPS1, REACH1, KNEE1.
CLIPS: read the other seven side films (pro_left_jab, pro_left_jab_c, pro_right_cross_a, pro_right_cross_c,
pro_left_hook_v2, pro_left_uppercut, pro_kidney_shot: sheets by the recipe in the digest), film the rear hook from the
front three-quarter, then brief the fixes: cross B replaced or cut from the plain cross list, the lead hook's elbow,
the body shot's bow. Give clip verification one owner and print "clips verified N of 122" at session start.

## 5. THEN
The foundation branch's third round (ops/research/FOUNDATION_S434_RESULT.md), TURNPRO1, WRESTLE0, RESULTLOOK1 (the
damage map changes that page: design them together), the dues design call (no robust setting: let members leave a full
club, or drop the waiting list).

## Traps (S437)
- Read ops/AgentComms/seat_dispatch.log before touching a seat's worktree: `--act` returns before the launch is logged.
- Print less: an SVG, a price table and two journals took the session past 420k by midnight.
- hit_gap_probe: one bout, 32 punches, p90 moves 0.07 m on the same data.
- ffmpeg needs an even frame height (the hidden desktop gives 1920x1009).

SETTINGS: S437 ran on Fable 5.2 with workflow agents on Opus. Next: Opus 5.5 high (collects, the map's next round by
workflow on Opus); Fast off.

## ADDED AT THE END OF S437 (00:12)
- DAMAGE MAP ROUND 3 (workflow wf_1491fae8-ce6, same folder): v3 scored depth 6.5 (coach) and 6 (systems), clarity
  5.5 and 5. Three rounds at 6 to 6.5: do NOT run a fourth round of the same shape. The critics' common ground:
  (a) the arithmetic table (9.1) breaks the map's own 25-points-a-round cap: redo it with a small script, not by hand;
  (b) three choices are close to automatic (the free "pencil the next show", Aim Stomach beating Aim Body at the same
  price, the +4 on a hurt place); (c) the recovery half meets the player about twice in 26 weeks: it needs to come up
  more often (SORE places every bout) or carry more; (d) real boxing: a liver shot is a delayed drop, being winded is
  the solar plexus, a closed eye is a blind side, not a flat minus; (e) one word per thing (SORE / TENDER / hurt), the
  corner minute as ONE table, the physio's slots against today's "a session a week". My read: the map is too wide for
  one pass. Next: split it in two maps (the fight: places, Aims, cover, corner minute / after the fight: the knock,
  the check, care, the booked bout), give each its own critics, and write section 9's numbers from a script.
  Both critics' full lists: the two "depth" lines of that workflow's journal.jsonl.
- THE BUILD WAS NOT EXPORTED: the PC went RED on memory (he was playing a game: 8.9 GB), the export waited in the
  queue and was stopped. Builds/ still holds the S436 build. docs/WHAT_TO_TRY.txt already carries the S437 entry.
  FIRST THING when the watchdog is not RED: `sh tools/export.sh` (through godot_slot), smoke-run the exe 40 s on the
  hidden desktop, then tell him. Cursor's RIBS1 checks wait behind the same RED.
