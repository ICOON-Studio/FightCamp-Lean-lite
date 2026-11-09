# The gym as the screen, and how it grows (S412, 2026-11-09): input for the main-screen decision

The owner sent two pictures from his ChatGPT chat "Gym Mockup Design" ("here is another idea", "with the expansions") and asked for that chat's text. Summary below in our own words; the chat stays on his account. The pictures are concepts for reference, nothing of them goes in the game.

## The pictures
1. The whole screen is one gym seen from high up, roof off, walls cut away: office, reception and lockers on one side, cage, ring, mat, bags, weights and cardio on an open dark floor, a car park and a welcome mat at the front. Small people training. A dark icon rail on the left, a dark top strip with money, fighters, rating and date, pause and speed at the right.
2. The same gym bigger, plus a right-hand panel of gym stats and an "Expansion Blueprint" strip under it: four stages, each a small picture of the plan, with what it adds and a price ($25,000, $50,000, $100,000 in the picture: made-up numbers).

## What the chat argues
- Start small and grow by building outward. Keep the old building visible, do not swap in a new one.
- Every upgrade has to unlock play, not just size.
- Four phases from a local gym to an international centre; five zones (combat, fitness, recovery, management, lifestyle), each growing on its own.
- Each room does a job. Five limits on growth: money, space, staff, reputation, demand.
- A second cage with no second coach adds no capacity.
- The gym itself should be the playable world, not a menu.

## Against what we already have
- ALREADY AGREED: the small unit that grows (S411), the places rule (FLOOR_PLACES_S411.md), stamina bars and place dots on the floor. His Miro comment asked whether the gym could become core play to avoid boring menus: same idea.
- ALREADY IN THE CODE: three premises sizes (GymUpgrades.PREMISES), plans drawn from data (GymPlan, IsoGym), people walking (GymPeople), the coach-or-room limit (GymSpend).
- WORTH TAKING: the Blueprint strip (see the next stage and what it gives, before you can afford it). The second-ring-needs-a-coach rule fits places plus the coach limit. Roof-off, high camera: exactly what GYM3D2 is measuring.
- NOT FOR US NOW: fifty-plus fighters, labs, accommodation, an event arena (scope: one gym, small roster, amateur to first pro). A cage waits for MMA.
- CONFLICT TO SETTLE: the left icon rail. S408 he moved to icons in the top bar. With the gym as the whole screen a rail costs little; his call when the screen is designed.

## Next
His answer on whether this replaces the four paintings (Q-S294-137). GYM3D2's stills decide if it can be real 3D or stays drawn. FLOOR2 and the premises prices follow.
