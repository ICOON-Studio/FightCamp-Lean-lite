# World page, Rankings tab: blind critic, S408 (Claude Sonnet)

Score: 6/10, on the amateur table at week 6, before the empty columns were removed. Judged from the real screen, the s401 mockup and the critic pack; the critic did not open the Miro notes or the code.

## Its list to reach 10/10, most important first
1. A "since" arrow (places up or down) and a "Developing" note per rival: the plan's headline.
2. Trend and Finishes: delete or fill. Give the width to Gym and Last bout.
3. A reason on every disabled button, and one line under the win band: what a win here gives (place, fans).
4. Trim the Key to the icons the current table draws. Drop "Not built yet".
5. Make the red top row mean something, or remove it.
6. Keep News and Fixtures on screen.
7. Hide the MMA chip until the MMA table opens.

## What Claude did with it
- Point 2: done. A column no row fills is left out, so the amateur table loses Trend and Finishes and the pro table keeps them. Gym and Last bout were not added back.
- Point 4: not taken. Operator S408, asked directly: "Keep it full". The key stays complete on every table; tests/menu_world_test.gd holds it.
- Point 5: not a fault. The red row is the rival picked for Side by side (#1 by default); its name is red on that card too.
- Point 7: not taken. S403's rule is that parts not built yet show greyed or marked.
- Points 1, 3, 6: open. Point 1 needs amateur rank history, which the game does not store yet.
