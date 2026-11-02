# S74 playtest fix list (Claude's own walk of the exported build, 2026-09-25)
Walk: `Godot/tools/s64_career_walk.gd` with plans in `research/s74/`. Worst first. Status: FIXED / OPEN.

| # | Where | What a player hits | Status |
|---|---|---|---|
| 1 | Exported .exe | Fighters/clips loaded by OS path; inside a .pck they do not exist - no 3D bodies in the build | FIXED (RawAsset.gd, bytes not paths; raw models shipped beside exe) |
| 2 | Offers desk | First amateur bout for any Cyprus boxer/wrestler: ENTER THE CARD -> "OFFER NOT AVAILABLE" (open-circuit org id contains `\|`) | FIXED (offer ids parsed from the right) |
| 3 | Fight night | Career bout shown on the flat 2D ring with two cut-out pictures; the 3D arena was dev-only | FIXED (FightNightScreen mounts FightWorldLive; banned_2d_fight_picture_test) |
| 4 | Tale of the tape | Both corners show the SAME portrait photo | FIXED (blue avoids red's face) |
| 5 | Tale of the tape | Both men listed 83.9 kg right after a 72.6 kg weigh-in | FIXED (own sport's weight table; also the engine's mass) |
| 6 | Fight night | A 0-1 amateur debut billed MAIN EVENT and "#8 RANKED" | FIXED (AMATEUR BOUT, AMATEUR badge) |
| 7 | Booking | Amateur bout lands the SAME DAY it is entered - no camp possible; weigh-in reads MADE WEIGHT before anyone weighed | OPEN - next build (touches settlement) |
| 8 | Offers desk | 12 of 14 offers to a debutant are UNSAFE (pool includes pro world champions - Joshua, Usyk, Fury) | PART - stars removed from the pool; UNSAFE rows by design (U4 D4) still many |
| 9 | Offers desk | Header says "0 WORTH TAKING" with two EVEN bouts listed; "NONE FIGHTS TO TWO" reads broken | PART - header fixed (EVEN MATCHES); wording open |
| 10 | Fight night | Action buttons cut off under the footer | FIXED (the 2D screen is gone; arena has its own speed bar) |
| 11 | Weigh-in | Empty "FIGURE" placeholder panel; "SLOT WO D6" jargon | PART - FIGURE boxes gone; jargon open |
| 12 | Gym creation | Ring card is 14 identical buttons ("OLD CLUB BOXING RING" x14) | OPEN (cosmetic) |

| 13 | Result | A $143,270 gate printed for an unpaid amateur bout | FIXED (no gate on amateur cards) |
| 14 | Exported .exe | Real athlete names, histories and 12 real photos shipped | FIXED (names ruling; research/names_real, never exported) |
