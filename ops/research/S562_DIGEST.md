# S562 digest (2026-11-26, Opus 5.5) - DRAFT, completed at the handover

## His words this session (quoted)
- Board answers read at start: Q-338 "Show what it can do", Q-339 "Yes", Q-340 "Yes, a choice", Q-341 "Try it", Q-342
  "Right amount", Q-343 "Yes, replace the board".
- On the Inside range marker: "wtf is this ? what is th eplayer supposed to understadn from this ?"; then "i told you do
  not put text or anything near the fighters".
- On the ground squares: "also i do not undestand what is this".
- "switch the button places of step-in with back-off (back-off should be left and step-in right)".
- "the distance between fighters is not consistant when clips play, it gets reset when some clip animations play, can
  you check and fix all that"; "check my last round i select hold your ground yet the animation showed my fighter moving".
- "is there any point in holding both hands up or one hand up covers all attacks on the head?" (answered: lead high stops
  jab and cross, rear high stops hooks and the overhand; both high leaves uppercuts and the body open).
- "what is this ? how this - + works ?" ("Hold it high - +1 stamina") and the stamina bar "i can not understand how this
  works".
- "can i be able to select exactly on which part of a beat i move ? or it breaks balance ?" -> MOMENTGAP1 at Arena.
- "thats not the camera i approved" -> checked: the renders read tools/pics2d_camera.json (his S559 camera); the strip
  only looked flat shrunk on plain blue; cam_compare.png sent.
- "use console-code if you need more tasks done"; "can i run archeage ?" (yes; one render left running).

## Done (commits on main)
- 83af562e5 page fixes on all five Ring Switches pages: range badge in the ring's top-left corner ("MID lands: ..."; a
  hovered switch turns it green or red), no bar or words near the men; "Room to back off" bar in each panel (the ground
  squares); Back off left / Step in right; stamina "-2" a punch, "+1" a held hand, in green; the stamina label "Stamina 3 -
  1 this beat = 2 of 5 (body shots took 3 off the top)". page_play_test 4 passed on order, punch, head, kick.
- GLIDE1 (49f6ba017, 63ef865c9, 7bbc8a297): punch runs at every range they reach (Long 12, Mid 42, Inside 42 runs; 3 failed
  their gate by 1-30 mm and re-render with the other take); falls-short runs; the feint at every range; the push off on
  the page's spots. Measured: Mid hold -> cross -> hold, blue's back edge 370-371 px throughout (was a 21 px jump).
- 91b9438aa collected PUNCHCHANCE2 (Arena): version F (C + an all-in knockdown gets up and does not count toward the
  stoppage) holds 8 of 9 on both seeds, comeback pooled 15%. Not on punch.html yet (BODYUI2 owns make_punch.py today).

## Running at the end of the draft
- BODYUI2 console worker (body view on the main page), GLIDE2 console worker (head moves and kicks at every range).
- Arena: KICKFIX2, HEADPULL1, PROGP3 (7 of 9 runs), MOMENTGAP1, CLINCHFIX2. John SQ337, Kalli SQ338 still unanswered.
