# U20 DIGEST — Damage in real time

Research only. Files: `research/U20_DAMAGE_IN_REAL_TIME.md`, this digest. No `.gd`, no `HANDOFF.md`. Branch: `cursor/u20-damage-in-real-time-c592`.

**One finding:** keep the six regions and the round panel; replace the 14 s **lump** with a stream of **impacts**. An impact is one attempt in fight-seconds (`t_s`, region, `force` 0–1, `contact` clean/glancing/absorbed/blocked/slipped/missed). Damage, animation and broadcast all consume that record.

**Two channels, not one HP.** Wear is the live `body_condition` dict (already written, already persisted by `apply_real_fight_damage`) — small, often, conservation-split so R80's ~1.8 lands do not 4× the bout. Shock is a rare per-impact roll on a clean head shot (and a delayed liver-class torso), scaled by `force^2` and remaining `head_neck` — flash knockdown = recovered shock. Cite Walilko/Viano/Meaney for rotational KO; Davis/CompuBox for 0.33 thrown/s, ~0.11 landed/s.

**Survives:** `_check_stoppage` as the only `_finish_fight`, three-KD, doctor look at `head_neck <= 15` between rounds, U3 BODY tab, ten-point-must as a **round** panel. **Dies:** `damage >= 18` / `>= 20` as exchange lumps; burst as non-causal texture. Hurt duration and the knockdown count are fight-seconds. U19's `× 14/60` becomes `count / fight_seconds * 60` when C62/G28 stop promising 14.

No healing. No eighth stat. No tick in the formula. C62/Q13/G28 own clock, space, spectator time.
