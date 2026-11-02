# LUDO ROUND 41 (S206) - the fighter profile's six missing tabs

Operator S206 (verbatim): "this session i want to  see a proper player profile card with its subtabs fully completed and showing
everything that they should show , ask ludo for previews of all  missing tabs".
Chat: Ask Ludo "Gym Management Screen" (FightCamp - title read before every send). Facts sheet (Tools/ludo_facts.py) pasted first.

## What was asked and what came back
1. IMAGE ask (LUDO_ROUND41_S206_prompt.txt + the r40 OVERVIEW mockup attached): six tab mockups. Ludo returns ONE image per answer;
   TECHNIQUES came back with the header, tab bar and 3D stage right but the tree column EMPTY -> docs/previews/s206_ludo_profile_tabs/
   r41_tab1_techniques.png. A redo with every row spelled out came back worse (column still empty, bars garbled) ->
   r41b_tab1_techniques.png. FINDING: Ludo's image model cannot draw dense data screens; stop spending credits on UI images.
2. TEXT build spec for all six tabs (rect / font / colour / data field / decision / populated value / empty state):
   reply1 (global shell, s1 TECHNIQUES, s2 MEDICAL to 2.3), reply2 (2.3, s3 TRAINING PLAN, s4 FIGHT RECORD part),
   reply3 (4.2 cont., s5 CONTRACT & MONEY, s6 CAMP), reply4 (CAMP end, s7 interactions, s8 under-3-clicks, s9 his follow-ups).

## Claude's verdict (build rules)
- Ludo's LAYOUT, tokens, row anatomy and EMPTY STATES are adopted.
- His VALUES are examples; many fields are invented (technique quality scores, coach names on rows, per-site facial scars,
  commission clearance, concussion counts, sleep efficiency, morning+afternoon sessions, daily fatigue deltas, punch stats per bout).
  Built tabs show a field only when a real read supplies it (TASK_PROFILE2C v2 / TASK_PROFILE2D list the reads and the omissions).
- Builders: PROFILE2C (local Cursor - tab host + TECHNIQUES / MEDICAL / TRAINING PLAN), PROFILE2D (cloud Cursor issue #120 - FIGHT
  RECORD / CONTRACT / CAMP), PROFILE3A (Arena - tree states), PROFILE3D (Antigravity - opponent compare, MERGED 26cb193c).

## LUDO_LIMITS (chars per reply)
image 1, image 2 (no text), reply1 20,236, reply2 20,385, reply3 21,635, reply4 25,250 = 87,506 chars of spec.
