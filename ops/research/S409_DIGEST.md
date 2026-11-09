# S409 digest (2026-11-09)

People in the gym: 19 boxers baked as isometric strips (tools/bake_hub_sprites.gd), drawn on Home by HubFigures and kept to GymPlan's floor rules by GymPeople. PR 114 had brought only the tool, because its run hit a RED PC, so the tool was corrected and the bake done here. PR 114 closed.
The building is chosen once at setup (Career.gym_plan) and its bonus runs in the rules (GymBonus): 5% more members, shows 5% more, power and technique +3%, days out -10%. The Layout button is gone. "Join 5% faster" did nothing measurable because the weekly step rounds up, so it became a higher target. The routine "new members joined" line no longer lights Mail.
Fighter model: PR 113 (4C) not merged. Its CI tests job ran to the 18-minute limit and was cancelled; two_boxers 313 s against main's 113, golden_path 72 against 33, plan_bots 2 red. FIGHTERMODEL4D running on Cursor.
Animation: HITREACT1 collected (PR 115 closed). Most reaction clips read about half the source's head travel, but the source column is the whole take and the game's clips may be trimmed, so the loss is not proved. HITREACT2 running on Qwen: same window, a body-height check, then the stage that loses it.
move_tip capped at 30 fps: it was red on CI with 22 or 26 of 30 frames against a bar of 27, green here. Main's next CI confirms or not.
Look: concepts for Fighters (full-body cards) and a versus screen, real renders against a Ludo paintover, on the board as Q-S294-134 (docs/mockups/s409/concepts/look_choice.png). Mock numbers, not scored by a critic. Nothing is built until he picks.
Evidence: gym_people, gym_hub, gym_bonus, membership, injuries, save_load, golden_path, cash_forecast, game_money, gym_spend, move_tip tests green. Film and stills on the review board. Not run: the full suite (05:00), balance harness (no hook for the bonuses), a critic on the new screens.

HANDOFF
Working commit: f7fa8c5b on main, pushed. Build exported to Builds/ before the move_tip test change; game code is the same.
Remaining: his answer on Q-S294-134, then build Fighters and versus and re-brief the held Cursor rows. Collect FIGHTERMODEL4D and HITREACT2. Read the first real 05:00 run on 11-10.
Exact next action: roadmap now.next_action; details in NEXT_SESSION_PROMPT.md, S409 block.
