# Critic brief, round 4 of the menus

You are a fresh critic. You did not design these and have seen no earlier score. Read `ops/research/CRITIC_PACK.md` and `ops/research/CRITIC_ACCESS.md` first: you must know the whole game before you judge a screen.

The pages, 1920x1080, in `docs/mockups/s403/`: home, fighter_week, fighter_week_aisha, profile, profile_aisha, profile_kwame, playbook, playbook_ground, playbook_combos, fight_night, money, world. Open each PNG with the file tool. Read the HTML's `title` and `data-tip` attributes too, because a still cannot show a tooltip. `facts.json` holds the shared facts. Never start an app or a window on the owner's monitors, and never run Godot.

Grey with a reason means not usable now. Full colour with a warning triangle means planned and not built: judge it as drawn, and do not mark it down for not existing yet.

## What to do
1. **The checklist.** `ops/research/S403_MENUS/FIXLIST_R4.md` lists numbered fixes and a REMOVE list per page. Mark each one Done, Partly or Not, from what you can see. One line each. Be strict: a fix that is on the page but does not work counts as Partly.
2. **Blockers only.** Then list any other fault that would stop you shipping this page. A blocker is: a number that contradicts another, something a player cannot do that the game needs, a page that fails for one of the eight fighters, text or layout that cannot be read. Taste, wishes and "it could also have" are not blockers. If you have none, say none.
3. **A score out of 10 per page,** where 8 means "I would ship this" and 6 means "works, but I would rebuild parts of it". The score follows from 1 and 2: if every fix is Done and there are no blockers, the page is at least 8.

The designers were told to add nothing beyond the list and to remove something for every addition, so a page that is lighter is doing what was asked.
