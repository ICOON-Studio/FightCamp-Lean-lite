---
name: campaign-story-d36
description: "The story campaign \"Anvil Street\" (D36): Chapter 1 'Keys' is IN the boxing demo; design of record = CAMPAIGN_PLAN.md; STORY2 core built, STORY3-6 queued"
metadata:
  node_type: memory
  type: project
  originSessionId: c8680409-62b0-495a-8631-8ca66a0536f8
  modified: 2026-10-05T09:36:05.471Z
---

Operator 2026-10-05: asked for a story/campaign that shapes the menus, UI and loop ("use the campaign to shape the menus/ui and the loop"), then "put chapter 1 in the demo".

- Design of record: `research/CAMPAIGN_PLAN.md`, merged from four pitches (Claude, John, Dola with a Part A survey, Maria partial; Kalli pending). Gym "Anvil Street", founder Dessa (stroke), Crown Ring Promotions / Victor Lasko (clause + loan), coach Holl, rival Jax Mireles, reporter Naomi. THE BOARD = NEXT UP banner + Gym/Money/People; Phone Inbox + The Wall are the two new screens.
- Rules that never change: never script a fight result; the week review is the only interrupt (plus the HOME welcome); every card defaults after 7 days; On/Beside/Off; the campaign never ends the game; results before the story began never fire a card (baseline).
- Built (S163): StoryCampaign.gd (pure), story_beats.json (9 cards), GameState hooks, StoryCard.gd in CareerRoot, tests 102/25/15. Queued: STORY3 (NEXT UP, Inbox, New Career questions), STORY4 (Wall), STORY5 (scorebug/corner/result hooks), STORY6 (writers' card text).
- Fighters are generated in the demo (empty-gym start, the player scouts the first boxer): cards use `{fighter}`, not "Kit".

**Why:** the playtest found the loop's weakest point was a reason to press Continue; the story gives each week a visible promise.
**How to apply:** build further story work from CAMPAIGN_PLAN.md and `StoryCampaign`; any new card is data in `story_beats.json` with a test; fights stay simulated. See [[feedback_headless_godot_use_noconsole_exe]].
