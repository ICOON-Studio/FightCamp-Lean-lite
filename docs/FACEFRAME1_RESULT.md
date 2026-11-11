# FACEFRAME1 — one camera for every head

The menus cropped each portrait with their own numbers, then a covered stretch cropped that crop again to fit a square or a short slot. Hair and chin fell outside the frame. One helper now picks the window for every face slot.

The 3D corner-minute camera and the fighter's full-body figure on the Overview are not part of this change.

## Head boxes

Stored once in `scripts/ui/face_boxes.json`. One rect per picture, in picture pixels: left, top, width, height. A slot passes when that box, plus a margin of 6% of its height, lies inside the pixels the player can see. Where the picture has no pixels past its edge (a poster already cut at the hair), the margin stops at the file.

How they were made:

- Studio, style B, dark, and full-body: a pixel scan. The background is the colour of the top edge (alpha, on the full-body set). Hair top is the first foreground row in the middle of the frame. Chin is the narrow neck before the shoulders. Ear to ear is the widest span between those rows.
- Poster: the studio head mapped through the crop in `tools/poster_faces.py` (same 0.52 height and 0.23 above the eyes), then clamped to that poster file.
- Guide: the painting is a circle that meets the frame, so the box is the head inside that circle, `[48, 18, 304, 268]` on the 400×400 picture.

Counts: studio 23, style B 23, dark 23, poster 19, full-body 114 (every file, including the alt poses), guide 1. Typical sizes: studio and dark 720×900, style B 704×896, poster about 374×468, full-body 600×800, guide 400×400.

Examples (x, y, w, h):

| set | picture | box |
| --- | --- | --- |
| style B | mh_boxer_11 | 249, 125, 224, 285 |
| style B | mh_staff_coach | 223, 136, 282, 279 |
| studio | mh_boxer_11 | 259, 152, 203, 269 |
| dark | mh_staff_coach | 219, 136, 282, 283 |
| poster | mh_boxer_11 | 51, 62, 203, 269 |
| full-body | mh_boxer_11 | 138, 133, 215, 213 |
| guide | guide_trainer | 48, 18, 304, 268 |

## Call sites, before the change

These drew a face with their own crop, or with `PromoShot.shot` / `picture` which cropped on the eye marks (`CROP_H` 0.52, `ABOVE_EYES` 0.23) and then covered the slot:

| file | what it drew |
| --- | --- |
| `scripts/ui/PromoShot.gd` `picture` | the shared head-and-shoulders path: interview walk-in, fighter page, world ladder and compare, tape, staff cards, roster table, offer card, home rows / needs / first hour / match, fighter tile, create-screen coach cards, matchup cards, money panels, roster-card fallback |
| `scripts/ui/HomeBoard.gd` `portrait` | camp side and fighter card. Returned the cropped shot, and cropped a body render with `Rect2(0.25, 0.0, 0.5, 0.42)` |
| `scripts/ui/FighterCard.gd` `face` | 132×166, plus `HEAD_CROP` on a no-gi photo |
| `scripts/ui/CampSide.gd` `_face` | 298×300, a second crop to the slot |
| `scripts/ui/WeekStrip.gd` `_poster` | opponent, 44×50, atlas from y = 12% of the studio shot |
| `scripts/ui/DrillTray.gd` `_versus` | opponent, 44×44, the same 12% crop |
| `scripts/ui/WeekBoard.gd` `_bottom` | coach, 52×52, the dark photo, covered with no head box |
| `scripts/ui/FightPoster.gd` `_face` | poster file, covered into a tall slot, halftone on top |
| `scripts/ui/FirstWeekStrip.gd` `_portrait` | guide, 190×190, the whole square, centred |

`PromoShot.region`, `crop`, `whole`, `shot` and `live` are unchanged, so the promo test still sees the old mark crop. `picture` no longer uses it.

Left as they were, because the whole picture is already on screen (centred, clipped to the card): `RosterCards.body` and `VersusPanel.side`. The week-review screen has no face. Tape-room stills are film frames, not these portraits.

## The ruler on the real screens

`tests/face_frame_test.gd` builds the game through `Main.act` at 1920×1080, scrolls each slot into view, and reads the visible rect from the atlas region, the stretch, the control, and any ancestor that clips. It does not ask `FaceFrame` whether it passed. A square, a tall slot, a wide slot and a round slot are checked the same way.

Red, on the screens before any call site changed (the empty-rect pass before this one was a bad measurement: those slots sat below the fold):

```
FACE_FRAME failures=24
FAIL face_frame_test
```

Green, after every call site above uses `FaceFrame.fit`:

```
FACE_FRAME failures=0
PASS face_frame_test
```

## Census before

Visible rect and head box are picture pixels (x, y, w, h). Slot is the control at 1920×1080.

| screen | source | slot | stretch | visible | head | |
| --- | --- | --- | --- | --- | --- | --- |
| home | coach png 704×896 | 96×96 | covered | 203,141 366×365 | 223,136 282×279 | FAIL |
| home | boxer 11 png 704×896 | 76×76 | covered | 204,139 366×365 | 249,125 224×285 | FAIL |
| home | guide 400×400 | 190×190 | centred | 0,0 400×400 | 48,18 304×268 | ok |
| interview | boxer 11 png | 320×360 | covered | 204,117 366×411 | 249,125 224×285 | FAIL |
| signed | boxer 11 png | 84×84 | covered | 204,139 366×365 | 249,125 224×285 | FAIL |
| roster | full bodies 600×800 | 226×330 and the strip | centred | the whole file | inside it | ok |
| table | boxer 11 png | 48×60 | covered | 204,94 366×457 | 249,125 224×285 | ok |
| people | coach png | 84×96 | covered | 203,115 366×418 | 223,136 282×279 | ok |
| people | boxer 07 png | 160×210 | covered | 210,91 354×465 | 226,134 242×282 | FAIL |
| people | trainer png | 160×210 | covered | 208,83 354×465 | 236,92 236×272 | FAIL |
| ladder | 14 heads, 22×26 up to 40×46 | covered | the old 366-wide crop | tall hair cut on 10 of them | 10 FAIL |
| bout | two full bodies | centred | the whole file | inside it | ok |
| booked | four home heads, 84×84 and 128×128 | covered | 366×365 from y≈139 | hair above that line | FAIL |
| training | boxer 11 64×80, coach jpg 52×52 | covered | head still inside | ok |
| camp | opponent jpg 44×50 | covered | 180,108 359×409 | 251,152 227×284 | ok |
| camp | boxer 11 png 298×300 | covered | 204,138 366×368 | 249,125 224×285 | FAIL |
| poster | two poster jpgs, 186×223 | covered | almost the whole file | head inside | ok |
| shapes | studio boxer 11: 180 square, 120×220, 280×120, 200 round | covered | head inside | ok |

The shared crop started about 204 px across and 366 px wide. On a square slot the covered stretch then cut the top of that, so the 6% margin above the hair was gone. That is the 24 failures.

## Census after

Same slots. Every one shows the whole head.

| screen | source | slot | visible now |
| --- | --- | --- | --- |
| home | coach png | 96×96 | 178,119 372×372 |
| home | boxer 11 png | 76×76 | 171,107 380×380 |
| home | guide | 190×190 | 21,1 357×357 |
| interview | boxer 11 png | 320×360 | 192,108 337×379 |
| signed | boxer 11 png | 84×84 | 171,107 380×380 |
| roster / bout | full bodies | centred | the whole file, unchanged |
| table | boxer 11 png | 48×60 | 209,107 304×380 |
| people | coach / boxer 07 / trainer | 84×96, 160×210, 160×210 | 201,119 325×371 · 203,117 286×375 · 215,75 275×362 |
| ladder | boxer 11 | 36×42 | 198,108 325×379 |
| ladder | boxer 16 (tall hair) | 22×26 | 177,56 379×449 |
| ladder | the other ten rows and the two compare heads | 22×26 or 40×46 | each window contains that row's head |
| booked | boxer 11, 13, 17 | 128×128 or 84×84 | 171,107 380×380 · 194,104 370×370 · 171,81 410×410 |
| training / camp | boxer 11 header | 64×80 | 209,107 304×380 |
| training / camp | coach jpg | 52×52 | 171,119 377×377 |
| camp | opponent jpg | 44×50 | 198,134 332×378 |
| camp | boxer 11 side | 298×300 | 172,108 377×379 |
| poster | boxer 11 / boxer 13 | 186×223 | 3,45 298×358 · 0,34 315×377 |
| shapes | square, tall, wide, round | 180, 120×220, 280×120, 200 | 181,135 358×358 · 242,105 235×430 · 0,135 718×308 · 154,80 412×412 |

`FaceFrame.fit` stores the head box, cuts a window of the slot's own shape with the head a little above the middle (`HEAD_AT` 0.42), and clips the control to that window. A later resize cuts the window again for the real size. The breath shader still gets the window as its `region`. The poster halftone does not: it has no region, and the helper does not invent one.
