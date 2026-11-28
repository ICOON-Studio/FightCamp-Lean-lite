# S575 digest (2026-11-28, Opus 5.5)

## What the owner decided
- **Rules: ours, v6.9** (Q-S294-351, chat: "ok go with 6.9"). Balance over cup r22 + r23, four ratings each: v6.9 6.25,
  LITE 4.5; his v2.7 as written lets Pressure win 65-70% on the bots. LITE and pure stay in the code, off the board.
- **His Pressure fighter** (four questions, chat): gets in by CUTTING OFF THE RING; inside, BODY WORK DRAINS the
  out-fighter; an ENGINE THAT NEVER STOPS; the out-fighter's answer is a TIMED COUNTER.
- **The fight page** in the Puncher's Chance look: hand under the ring, its own page first, a picture first (approved:
  docs/mockups/s575/cardfight_hud.png), then "ok look good build it".
- Board: "remove old versions fromboard" - the page buttons are the fight and What changed only.
- Balance only in reports (S574 rule kept): every cup verdict now asks BALANCE + the three styles (`balance=1`).

## Built (all in v6.9 unless said; bots n=200 x seeds 7/11/13, ops/research/octagon/s575/grid1-6.txt)
- r21 asks: roundKeep 2 (a round that ended at Close starts at Mid), holdTwice, ctrCtr; stanceHead and roundKeep 1 OFF.
- r22 asks: Walk Him Down (always there for Pressure at Long), pressWalk, heavyGap; r23: fakeFwd; tieStraight OFF (Truck 61-62%).
- His answers: walkFeint, walkCheck, walkCut, bodyDrain 2, pressEngine 2. Bots 43-56%; the bots never play Walk Him Down.
- proto/twohands/fight.html + fight_ui.js: the v6.9 card fight with our fighter pictures (img/anim runs, one man per
  picture via layers_ui.js), damage as big as speed, room to the ropes, the Lead, the tell, both flipped cards in the
  panels, the range sign says whose card moved you, one arrow per moving card (his last call: "just use a left arrow if
  backwards movement is involved or right arrow when moving forward"), knockdown at a stoppage.
- proto/twohands/status_fx.js: ONE table of status warnings (log line or state change -> title, one line, severity);
  each new style adds its effects there. 200 auto bouts: every v6.9 effect fires.
- Test hooks on fight.html: ?auto=N, ?pick=<card>, ?alerts=stay. Screenshots by headless Edge (the pane is too small).

## Cup (balance only)
| round | bout | version | result | BALANCE | OUT | PRESSURE | COUNTER |
|---|---|---|---|---|---|---|---|
| r22 | Claude v Maria | v6.9 | draw 29-29 | 7 / 6 | 5 / 7 | 6 / 4 | 5 / 6 |
| r22 | John v Kalli | LITE | Kalli 30-26 | 4 / 5 | 8 / 7 | 3 / 3 | 5 / 6 |
| r23 | John v Kalli | v6.9 | Kalli 29-28 | 6 / 6 | 7 / 6 | 4 / 4 | 5 / 5 |
| r23 | Claude v Maria | LITE | Claude 30-24 | 5 / 4 | 7 / 8 | 3 / 3 | 5 / 6 |
r24 (v6.9 with his Pressure rules): John (Truck) v Kalli (Snapshot) ran in the background at the handover; Claude v Maria
was stopped (folder r24_claude_v_maria_stopped) - replay it.

## Not done
- Cup r24 not collected; the owner's Pressure rules have no agent rating yet.
- Kickboxing on v6.9 (his next step after the cup check).
- No Godot code changed: no export. LAYERS1 item 2 (Animo hit reactions) still waits on a rig retarget.
