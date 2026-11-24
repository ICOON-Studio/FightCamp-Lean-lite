# S551 digest (2026-11-24 to 25, Fable) - the fight game found its form: Ring Switches

## What now works
- RING SWITCHES, the owner's own idea, playable in a browser: every action is a switch (each hand punches or is held
  high or low, the feet step in / hold / back off, clinch), a hand that does not punch blocks, range from the feet, both
  men act at once, the beat plays out with our own ring pictures and sounds. `proto/twohands/switch.html`.
  His words after one turn: "this can become a beautiful game i played 1 turn and i love it".
- A second page where the ORDER you click is the order you throw (three moments a beat): `proto/twohands/order.html`.
- The page teaches itself: each hold names the punches it stops, "Last beat he did" is followed by how to stop it and
  what gets through, greyed switches say why, the stamina bar counts picked actions, the ring names each action.
- Opponents read a repeated habit and answer it; no single fixed setting beats all three.

## Evidence
- Bot measures (150 bouts a cell; `proto/twohands/tools/probe_switch_bots.js`, `probe_order_bots.js`,
  `probe_order_swing.js`): plain page - sensible player 95 / 77 / 77% wins, careless one beat in four 79 / 61 / 69%,
  random 2 / 5 / 8%, best fixed setting 3 / 60 / 2%. Ordered page - a different order changes the result in 82 / 90 / 69%
  of multi-action beats; sensible player 100 / 82 / 79%.
- Headless Edge screenshots at 1400 x 900 of every screen; scripted bouts in the browser pane with no script error.
- PLANIMPACT2 checked against the code line by line (`PLANIMPACT2_CHECK_S551.md`); COACHMAP2 landed FAIL (not checked).
- BODYCROSS4 collected: `tests/body_cross_play_test.gd` green.

## The road to it (all his calls, in order)
1. Version 2's "Take it" button: "ithink this is dumb" (measured: the only button 28% of the time, picked 1% with a
   choice). "i do not see health wtf is this ?" -> Health and Stamina bars.
2. "there are 1 million deckbuilding games ... i expect a proper innovative design" + his Ironbound slots idea.
   Interview: "Timing, like Expedition 33"; "you can use deck for each hand or even combine them".
3. Two Hands (a deck for each hand, timed defence), reworked four times on his notes (stamina, timed counter, clock,
   ring pictures, three opponents, pack your hands, a guard that wears). Then: "i dont like the timed mechanic fornow".
4. "what if put everything that the fighter can do in the fight as action toggable buttons" -> Ring Switches.
5. "maybe the order that you play your moves can play a crucial role ?" -> the ordered page.
6. "we need to work on the visuals ... 2d animations ... grapplemap animations from any angle" -> RINGANIM1 briefed.

## Decided by Claude this session (and why)
- Built his idea as a toy first and measured it after, instead of a design page: three earlier forms died on paper-first.
- The ordered rules live on their own page, generated from the base, so the version he loved was never at risk.
- Opponents answer a HABIT by trying every plan on a copy of the ring (a real reader), after a script-only version let
  one fixed setting beat each man 98-100% of the time.
- Servers for pages he plays run in terminal tabs; keys are read by position (his keyboard layout).
- STYLEPLACE scope: opponents that fight in different places, instead of a third plan-rule probe.

## Not done / not green
- No export since S547 (BODYCROSS4 changed game files). No tests in the repo for Ring Switches' rules.
- COACHMAP2 not checked, the keep-or-cut question not asked. STYLEPLACE1 not launched. MATCHBOTS2 not launched.
- Kalli's and John's idea answers unread; Ludo did not reply; Dola unreachable (debug port); Ziva not used.
- Ring Switches: the Jabber too easy, the Slugger beatable by one setting, phone layout and sounds unchecked by a person.
- Two slips of mine: a `//` comment on a one-line script broke the page for about a minute; reloading the preview reset
  a bout he was playing.

## Next action
`ops/research/TASK_RINGANIM1.md` (standing 2D animations), then collect COACHMAP2 and launch STYLEPLACE1.
