# S499 digest (2026-11-16)

## Shipped
1. **Our own map replaces Miro** (owner: "miro subscription has been stop , is there any other tool that can do its job but
   free or can you create something like miro for our project"). `ops/Tools/opsboard/map_board.py` + `map.html`, routes
   `/map`, `/api/map`, `/map/img`, `/api/map/note` in the ops board server; data in `ops/AgentComms/map/` (`frames.json`,
   `notes.json`). Checked in the browser: 9 frames, 110 cards, 118 pictures, a note saved and deleted. Decided: build it
   on the board he already uses instead of another rented tool (free, no daily call limit, one command to update, no
   73k-character manual to load each time).
2. **Fight motion week day 4: the chest lean eases in.** Commit 1d0247db9. Evidence: the same bout filmed before and after
   (`E:/FightCamp/tmp/fightweek/r3d` vs `r4a`): head jumps over 12 cm 50 -> 27, a head inside a body 5 -> 3. Cost stated
   in the commit and the handover (glove ~2 cm short on the first hit frame; `hit_carry_test` 35 -> 51 failures).
3. Collected BODYSTEP1 (HitStep.gd, unwired). Queued FILMBAR1 (Qwen). PRESSFLASH1 re-sent (Grok Dev).

## Found
- The two reach solves of one pass can ask opposite chest turns (lean in to reach, then the shoulder back off the point),
  and the lean total reached 0.55 rad with LEAN_MAX 0.30. Any ease must work on the chest's real turn.
- In `hit_carry_test` the lean ramps over the whole jab; in the played bout it arrives at contact (the film's trace). The
  lead (`lead_q`) covers the bout; the test's 5 cm ON bar reads the first drawn hit frame.
- Miro's MCP has a daily call limit per organisation; nothing could be exported on the day the plan stopped.

## Not done
- HitStep wiring, arms home, the lean's glove cost, the Miro copy, an Arena task, COACHNECK1 round 2.
