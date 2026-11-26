# S561 digest (2026-11-26, Fable 5.2)

## His words this session (quoted)
- "finish with the headmoves pics , i wanna runarchage after that" -> done by the session itself (one job on the PC).
- "how are the kick balancing going ??" -> still measuring at Arena (E1's look-ahead table on a 2-core box).
- "can i have a jumpsuit for punchers chance on the board", then "i still dont see any link on the opsboard for punchers
  chance" -> he meant a JUMP BUTTON ON THE OPS BOARD. First reading (a switch on the game board) was built too: punch.html.
- "has the balancing with the head started or will be done after kicks ?" -> started, in parallel (HEADPULL1 at Arena).
- Board answers (10:32-10:38): Q-338 his limb "Show what it can do"; Q-339 head / torso / legs "Yes"; Q-340 a Sharp move
  "Yes, a choice"; Q-341 a fight plan "Try it"; Q-342 four attributes "Right amount"; Q-343 body view on the main page
  "Yes, replace the board".

## Done
- HEADPICS1: 22 frame runs on head.html (slip, roll, lean back, slip in; both corners; his camera), all pass the picture
  bars, played on the real page. `docs/HEADPICS1_RESULT.md` (what is still weak is listed there). `tools/pics2d_head.gd`.
  Lessons: stage a head move with the glove THROUGH the place the head was (the plain miss gives ground: it read as "he
  stood far away"); the slip is a lean from the Spine bone (a skeleton modifier), not the side-dodge takes; the roll takes
  pro_right_weave on both men (pro_left_weave leaves him standing: its head goes UP in clip_db).
- PUNCHCHANCE1 collected (d64b42a30): version C (open when 4+ health behind, once a round) lifts the comeback 10% -> 18%
  (bar 15-30%), 3% of beats; knockdowns 2.6 against a bar of 2.5 (7 of 9 bars).
- punch.html: the boxing page + version C + the switch beside the clinch, a gold "Puncher's chance open" tag beside the
  man's name. Built by `proto/twohands/tools/make_punch.py [tweak.json]` (order.html is never written). page_play_test
  takes a page name; beat_shot takes `hp` for a beat and lists the pictures a beat showed.
- Ops board: "Ring Switches - jump to" buttons in the Play box (Puncher's chance, Boxing, Head movement, Kickboxing, Body
  view), a gold Puncher's chance link in the top bar, a "Play the pages" frame on the map.
- PUNCHCHANCE2 launched at Arena (three versions to bring the knockdowns under 2.5).

## Running at the handover (all in the cloud, nothing on the PC)
| Run | Branch on FightCamp-Lean-lite | State when last read |
|---|---|---|
| KICKFIX2 | arena/bb25d26e-fightcamp-lean-lite | E1's look-ahead table computing (N=12 trials first) |
| HEADPULL1 | arena/397eb67a-fightcamp-lean-lite | its look-ahead table building (6 layers, 2 cores) |
| PROGP3 | arena/49993fd3-fightcamp-lean-lite | branch pushed, not read yet |
| PUNCHCHANCE2 | arena/403bd20a-fightcamp-lean-lite | started 11:20 |
| SQ337 John, SQ338 Kalli | chat seats | sent, no answer yet |

## Not done
- The uppercut that catches a man rolling (two tries crowded: not on the page).
- The never-still bounce, one-man-per-layer clips (renders: wait for his game to be closed).
- No export: no game code changed (pages, tools, pictures), and his game was open.
- `page_parse.mjs body.html` prints FAIL "Unexpected token '<'" - seen before any edit of this session; body.html was
  not touched. Look at it when the body view is built.
