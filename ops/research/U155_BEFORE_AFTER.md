# U155 before / after (seed 92012, MMA, default room options)

| | Before (take 1) | After (take 2) |
| --- | --- | --- |
| Video | `take1_seed92012.mp4` (C184) | `research/_captures/watch_loop/take2_u155_seed92012.mp4` |
| Contest drawn | 6.0 m gym octagon (`mma_cage_gym_6m`) | 9.144 m UFC octagon (`mma_cage_ufc_30ft` in live room) |
| Canvas flat-to-flat (mesh) | ~6.49 m (N-gon radius bug on 6 m spec) | 9.144 m |
| Cage : fighter height | ~4.3× (too small) | ~6.1× (9.14 m / ~1.49 m posed in-room) |
| Limbs outside at 52 s | red fighter kick past fence (operator) | 0.000 m max over 60 s (probe) |

Fixes: `ArenaRig` octagon circumradius; `FightWorldLiveScreen` UFC spec for MMA live room, `_contest_clamp_limbs` on octagon; engine bounds already tracked `contest` meta once spec corrected.
