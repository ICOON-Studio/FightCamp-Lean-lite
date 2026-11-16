# How Boxing Manager uses the fight camera (S501, owner: "check how boxing manager and ufc use the camera")

Sources: our own S426 recordings of the game played out of sight (`E:/FightCamp/tmp/bm_play/fight1_a.mp4`, `fight1_b.mp4`,
`fight2_smith.mp4`, 3-4 frames a second), overview sheets one frame every 2 s and every 10 s
(`E:/FightCamp/tmp/s501/bmcam/a_01.jpg`, `a_02.jpg`, `s_01.jpg`), full frames `f44.png` / `f54.png`, and a read-only string scan
of the installed game-logic library (BoxingManagerGDE.dll). Their camera code is in the encrypted Godot data pack, so no
numbers from code: everything below is SEEN on screen, distances INFERRED from the picture (ring ropes and bodies as rulers).
Nothing of theirs is copied into the repo. UFC: `UFC_CAMERA_S501.md`.

## 1. The live round: a cutting camera ("Cam: Auto" by default)
- It CUTS. About every 5-8 s (S426 counted 36 shots in a 4-minute clip; the sheets agree). Three shots repeat:
  1. LOW SIDE (the main shot, most of the time): the lens just outside the ropes at about chest height (~1.3 m), the bottom
     rope across the foreground, looking a little down (~5-10 deg). Side-on to the pair. The boxers fill about 60 % of the
     picture's height, the referee beside them. Names float over their heads (small tags).
  2. MEDIUM SIDE: the same side, further back and higher (~2-2.5 m), the whole ring floor and both corners visible.
  3. HIGH CORNER: from above a corner post, looking diagonally down (~35-40 deg) across the ring, the post in the
     foreground: a "how they stand in the ring" shot.
- The side shots stay side-on to the pair as they turn (the pair is never seen front-to-back in a side shot).
- After big moments a "Replay" button appears (top right); the library stores "replay moments" per bout and round
  (kind, the two names, a time span), so replays can be watched later too (SEEN in the strings: ReplayMoment table).
- Player controls on a rail at the left: Pause, Ring: 3D (there is a 2D ring view), Cam: Auto, Highlights, Skip, FF,
  Stats, Sound, View. Bottom right: + and - (zoom). A "Highlights" speed shows only the moments.
- One commentary line at the bottom centre; round clock + landed/thrown bottom left.

## 2. Between rounds and around the fight
- Round end: the round card (bars, verdict, stool stamina) over a DARK WIDE shot of the whole ring from high in the arena;
  then a TOP-DOWN close-up of the cornerman working over the stool.
- Before the bell: a tale-of-the-tape card, then a low side shot of both men in the ring with START FIGHT.
- Result: a low close two-shot of both boxers behind the judges' cards.

## 3. Ours today (FixedCam, S500 "camera is fixed always") vs theirs
| | Boxing Manager | FightCamp (Side, default) |
|---|---|---|
| Cuts in a round | yes, every 5-8 s, 3 shots | none (his S500 ruling); TV option cuts |
| Main lens height | ~1.3 m, just outside the ropes | 4.0 m up, 3.25 m outside the ropes |
| Looks down | ~5-10 deg | ~32 deg |
| Boxers' height in picture | ~60 % (low side shot) | ~45 % measured on a still (SEE_M aims 60 %) |
| Side-on | yes | yes (keep_square, S500) |
| Player camera choice | Cam: Auto + zoom +/- | Side / High / TV (C key), no zoom |
| Replays | button after big moments, saved | none |
| Names over heads | yes | no (names in the top bar) |

## 4. What this suggests for us (INFERRED; his call where it changes his S500 ruling)
1. Bring the Side lens DOWN and IN: about 1.5-2 m high, 1.5-2 m outside the ropes, looking ~10 deg down. The boxers get
   bigger and read as people, not figures on a mat; the punches and the guard read better. Keep it fixed and side-on (his
   ruling). Risk: a lower lens sees one boxer behind the other more easily: keep_square already prevents that.
2. Add + / - zoom (two buttons, or the mouse wheel) to the fixed camera: the player sets how close.
3. A Replay of the round's big moment (knockdown, the clean shot that won the round), from a second angle, on demand
   (a button), never forced: his "fixed always" stays the live view.
4. Between rounds: a wide of the ring behind the corner card is what they do; we already show the corner close-up.
