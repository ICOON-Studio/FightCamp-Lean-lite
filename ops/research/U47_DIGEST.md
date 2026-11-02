# U47 DIGEST — blind presenter contract test

- New: `Godot/tests/fight_stage_presenter_contract_test.gd` only. No scripts edited.
- Gate: parse ok; focused test `TOTAL=39 fails=0`.
- Synthetic: owned `hook_lead` / `cross` play exact clips (report + AnimationPlayer);
  `boxing_overhand` degrades (`actor_clip=""`, `thrower_idle`); unnamed may play
  `strike_head`; knockdown keeps owned throw; non-action → idle.
- Seeded `94301+94302+94303` boxing 3r: action=177 named_plays=65 degrade=112
  substitutions=0 distinct=`jab,cross,hook_lead`.
- Contract vs code: **no disagreement**. Floors are at-least; suite not run (tier).
