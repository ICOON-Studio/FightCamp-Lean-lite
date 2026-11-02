# S164 digest - STORY3 (NEXT UP promise, Inbox, New Career story question) + Actions-minutes triage (Claude, 2026-10-05)

## 1. What now works (evidence opened by me)
- **NEXT UP carries the story's promise** (`StoryCampaign.promise`, `story_beats.json` `promise` per card, `GameState._my_gym_next_up`): precedence = the game's own
  urgent rows (CAMP/DEADLINE/WEIGH-IN/MEDICAL/CONTRACT) > "sign a fighter" > a booked FIGHT > the story line > the generic nags. `next_up_priority_test` 11/0, mutant red
  (the mutant run also found the story line pre-empting a booked bout - fixed, FIGHT now wins).
- **New Career asks the story mode** (On / Beside / Off chips beside the gym name, tooltips, committed only by OPEN GYM): `CreationFlowPanel`,
  `new_career_story_mode_test` 11 headless / 16 `-- as_game`, mutant red. Still: `DesignLibrary/screens/creation/gym.png`. A defect in the same frame was fixed: the trail chip read "MARKE"
  (caption width 7.6 -> 9.0 px/char in `UIKit.committed_trail`).
- **THE PHONE INBOX** (`story_inbox` route, `StoryInboxPanel.gd`): one row per waiting card (cap 4) with its choice buttons, answers through `story_choose` (same path as the week-review card);
  Beside mode makes NEXT UP open it. `story_inbox_panel_test` 10/0, mutant red; stills opened in the real shell: `docs/previews/story3/story_inbox_beside.png`.
- **Trap found**: plain `tooltip_text` is cleared by `UserSettings._suppress_tooltips`; story UIs now use `UIKit.tip` (StoryCard fixed too - its tooltips were being wiped).
- Neighbours green: story_ (7), schedule_ (8), scene_router, smoke_test, creation (2). Workflow defects fixed (D36 reason cell, `last_working_commit`).

## 2. NOT done (said plainly)
- **The player-NAME question** of the three New Career questions (name, mode, gym name): mode + gym name exist, the name is not asked or used anywhere yet.
- **A fought bout walked in the exe** (and the .exe is NOT rebuilt with STORY3). Owed: extend `research/s162_chapter1_walk.plan` from scouting to a result screen.
- **KM3 A/B v2 INCONCLUSIVE**: base arm 4 rigs rc=-9 at 3601 s, rows=0 (`C223 no matched guard for anim_loc_advance - role loc_advance did not graft`); cut arm killed by PID at 52 min. PR #43 stays OPEN.
  Next: find why the production-gate rigs graft nothing before any A/B.
- STORY4-6 (the Wall + HOME pin, fight-night hooks, writers' cards) queued.
- Operator still owes: STAFF1c portrait, MetaHuman licence clause.

## 3. GitHub Actions minutes (operator: "github reached limit")
- The account's 2,000 free minutes are used up until 2026-11-01; Actions budget $5 (stop-usage on) so runs stop at the cap. Run records: FightCamp ~1,280 min, space-strategy ~115 (billing report credits space-strategy; both draw from the same pool).
- FightCamp: `ci.yml` push only on master (arena/* by its PR), timeout 60 -> 25; `goose.yml`/`cloud-agent.yml`/`opencode.yml` timeouts 340/330/300 -> 60/60/50. space-strategy: prompt given to its project; the repo was TRANSFERRED to the free organization `ICOON-Studio` (own 2,000 minutes). No Arena/cloud seat runs until Nov 1 beyond the $5 cap - heavy work stays local.
