# FIGHTDISPLAY4 result

The two wooden side panels are gone. The ring from y 240 to y 890 has no slate, wood or frame over it. The figures stand free at the edges. The bars sit in the two empty strips beside the scoreboard. What the panels used to show is still on screen or in a tooltip.

`tests/side_panel_test.gd` on the live fight HUD at the real FightView: `SIDE_PANEL failures=0`.

## Was on the panel, where it is now

| Was on the panel | Where it is now |
|---|---|
| Boxer's name | Top strip, left of the scoreboard (ours) or right of it (opponent). 30 px. |
| Plan line ("Own game") and the tape's game ("Pressing") | The line under that name, 22 px. |
| Worst-place tag ("HEAD", "EYE x") | Same strip, right of the name. Turns red when the place is critical. |
| energy, legs, guard, each as a word, a number and a tank | Same strip. Three horizontal bars, 22 px tall, word and number on the same row. Opponent energy stays a range ("96-100" in the still; "91-97" when the tank is 94 and the tape is studied). Legs and guard stay "?" until the tape is studied. |
| "lasts to" plus the R1, R2, R3 chips | One line on the energy row: "lasts to R3". The old three colours are the tooltip ("R1 holding R2 holding R3 holding", or "runs out" on the round the tank empties). |
| fine / hurt / critical | Not drawn. The words are in the figure's tooltip ("Fine: fresh. Hurt: sore. Critical: badly hurt."). |
| "HEAD 89 - ..." drawn across the brain | Not drawn on the figure. The same line is in that spot's tooltip. The numbered hit marks stay on the figure. |
| Ear, three pips, "Heard 0 of 3" | Bottom bar, in the gap beside LAST CALL. The ear's tooltip is still "Takes the corner's word" or "Has stopped listening". |
| Habit card ("Pressing, 1 time") | Bottom bar, in the gap that used to hold the round board's NOW column. It still flashes when the count goes up. The round board itself has no NOW column. |
| Wooden slate and lip | Removed. The strips are plain controls with no background. |

The host still answers `stamina`. The bell reads the tank the strip just painted.

## Rects at 1920x1080

From the windowed fight (`tools/fight3d_play.gd` on the hidden desktop), round 1 open. The corner bar is on the bottom of a 1080-tall view.

| What | Rect |
|---|---|
| SidePanel0 | (20, 20) 600x180 |
| SidePanel1 | (1300, 20) 600x180 |
| BodyPanel0 | (20, 350) 320x540 |
| BodyPanel1 | (1580, 350) 320x540 |
| EnergyBar, ours | (210, 101) 210x22 |
| LegsBar, ours | (210, 135) 210x22 |
| GuardBar, ours | (210, 169) 210x22 |
| EnergyBar, opponent | (1490, 101) 380x22 |
| LegsBar, opponent | (1490, 135) 380x22 |
| GuardBar, opponent | (1490, 169) 380x22 |
| CornerBar | (16, 905) 1888x170 |
| Ear | (994, 917) 28x28 |
| HabitCard | (1154, 913) 180x72 |

## Stills

Three frames, both boxers head to feet, in `docs/mockups/s429/fightdisplay4/`:

- `guard.png`
- `mid_punch.png`
- `damage.png`

`tools/still_framing.gd` is not in this repo, and it is not a file this task may add. The play script gates each save the same way that helper would: `TvShot.in_view` on both boxers' feet and both heads. A frame that fails that check is not written. All three printed `STILL_FRAMING OK`. The same run printed `FIGHT3D_PLAY failures=0` and no script error.

## What this pass could not move

The corner card still draws "Your coach has seen it. Press to work on it next round" on the same row as "Leave it". That row is built in `scripts/ui/CallButtons.gd` (`fix_row`), which this task does not own. The side panels are already hidden during the corner minute, so taking them off the ring does not separate those two lines.
