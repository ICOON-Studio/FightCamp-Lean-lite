# S506 handover (written 2026-11-17, end of S505)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S505_DIGEST.md`.

## Where the fight stands
- Fight motion week (deal: 5+ from BOTH blind critics or 3D leaves the first release). Last blind round r10 (S503):
  coach 5, animator 4.5. No round since; r11 briefs are ready in `E:/FightCamp/tmp/fightweek/r11blind` (sheet times
  still the r10 ones - set them from the r11 film).
- Base film now `E:/FightCamp/tmp/fightweek/s505b` (180 s, seed 7; log has Chest/UpperChest/Neck/shoulders). Against
  s504o: cross back 12.9 -> 14.2 cm, head jumps 80 -> 77, worst 27.6 -> 20.8 cm.
- s505c = the same with `leanrate=2.5`: jumps 63, but block_catch 4 -> 6 and hit_frame 6 -> 7 failures (red already).

## NEXT (in order)
1. Collect Qwen LEANRED1 (`docs/LEANRED1_RESULT.md`, branch qwen/leanred1; measure only). Fix what the slower lean
   moves in those two tests, then make 2.5 the default (`PunchReach.LEAN_RATE`).
2. Merge Ziva PR 341 (COACHNECK2) once the owner OKs the still pair on 127.0.0.1:8787/review. Check CornerIK stays
   under 500 lines at merge.
3. Film r11 (`--write-movie`, 1920x1080), sheets (`tools/film_sheets.py`, crop as r10), rulers, two NEW blind critics.
   ONLY when the owner is not playing a game (S505: my E: write froze his game).
4. Hands home: the hand comes back to ~15 cm of the pre-punch guard in 4-6 frames, then the guard itself sits elsewhere
   - judge on the r11 sheets; if it reads fine, PunchEnd's home = the guard after the punch.

## Waiting on the owner
- Q-266: where he saw "goose could not install godot".
- PR 341 look (coach neck before/after on /review).
- Unity + Unity Hub (~27 GB on C:) look unused - uninstall? (his call; he removes it in Settings > Apps or says yes.)
- Page file is 57 GB on C: - shrinking it is his Windows setting; told him how.

## PC lessons (S505)
- `C:\Users\user\.cache\eyes` is a JUNCTION to `E:\eyes_cache` - never "move it to E:" again.
- `C:\Users\user\iCloudPhotos` is iCloud's live sync folder of placeholders (~0 GB on disk). Its Length sum lies
  (191 GB). Never delete there: it deletes from iCloud.
- Size folders by allocated files: skip files with attributes 0x400000 / 0x1000 (cloud placeholders).
- Headless `push_input` clicks do NOT reach controls: test real clicks windowed on the hidden desktop.

## Debt
uppercut_tail, block_absorb, hit_carry, join_return, punch_speed, punch_weight red since S496-S504; block_catch,
hit_frame, punch_range red at 4.0 (LEANRED1 reads two of them).
