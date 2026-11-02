# Q226 DIGEST — training strands, speed and technique effects reach the live fight

## Delivered

All three switches added to `FightRealtime.DEMO_SWITCHES` (all ON in the game, OFF byte-identical):

### E5 — speed_in_decision
- `FightIntent.gd:57-69` adds `speed_bias(speed_stat)` — a faster man closes up to +4% and circles up to +3% (bounded by `SPEED_CLOSE_MAX` 0.08 / `SPEED_CIRCLE_MAX` 0.06).
- `FightIntent.gd:174` extends `decide()` with an optional `speed_bias` parameter applied after identity_bias.
- `FightRealtime.gd:3658-3662` adds `_speed_bias_for()` — reads speed stat from fighter, returns {} when OFF.
- `FightRealtime.gd:3635` passes speed bias into `Intent.decide()`.

### E3 — training_strands
- `FightRealtime.gd:1943-1952` adds `_strand_edge(athlete, strand)` — computes a ±6% multiplier from the share of training time spent on one strand (balanced 1/3 = 1.0, pure specialist = ±`STRAND_EDGE_MAX` 0.06).
- `FightRealtime.gd:1822-1824` stores three edges on the fighter dict at `_build_fighter`: `strand_edge_footwork`, `strand_edge_conditioning`, `strand_edge_technique`.
- `FightRealtime.gd:1514-1518` applies footwork edge to `preferred_range` in `begin()` (settled once, like personality_range).
- `FightRealtime.gd:4228-4231` applies conditioning edge to movement_drain (specialist ÷ edge = less stamina burn).
- `FightRealtime.gd:4703-4706` applies technique edge to contact thresholds (specialist × edge = slightly cleaner lands).

### E4 — technique_effects
- New `Godot/scripts/TechniqueEffects.gd` (45 lines): one effect processor for 4 wired effect keys (`finish_chance`, `cut_chance`, `stop_hit`, `pushback`). Authored ceilings from the catalogue's 0-100 scale.
- `FightMoves.gd:1005` adds `"effects": effects` to `move_from_node` return dict (the catalogue's effect keys now reach the chosen technique).
- `FightRealtime.gd:4694-4698` computes effects pre-contact for `stop_hit` (bumps clean/glance thresholds).
- `FightRealtime.gd:4747` computes effects post-contact for `finish_chance` (bumps flash KD probability), `cut_chance` (bumps trauma threshold), and `pushback` (adds separation).
- `FightRealtime.gd:2250-2263` applies pushback by displacing both fighters along the line between them.

### Census (SEND-BACK 1, 2026-10-02)
120 bouts per arm, 40 weeks, `q212_booked_census.gd` with thrown/connect tracking added.

| Metric           | ON (as_game) | OFF (no_q226) | Band        |
|------------------|-------------|---------------|-------------|
| KO+TKO%          | 49.2%       | 43.3%         | 40–55% ✓    |
| Decision%        | 50.8%       | 55.8%         | —           |
| KD%              | 25.8%       | 27.5%         | —           |
| Thrown/man-round | 40.7        | 40.8          | 45–56 ✗     |
| Connect%         | 31.5%       | 31.3%         | 27–32% ✓    |

Thrown/man-round is below the G99 CompuBox band in both arms (engine baseline ~40.7,
known ceiling ~35–40; `boxing_output_test` relaxes to ≥33). Q226 switches do not
affect punch volume — the gap is pre-existing.

OFF KO+TKO 43.3% vs S138 OFF 46.7% (stochastic variation; both within 40–55% band).

No tuning needed — constants hold their bands.

## Evidence

Parse gate: `check_scripts.py FightRealtime.gd FightIntent.gd FightMoves.gd TechniqueEffects.gd` → 4/0.
Parse gate on tests: `check_scripts.py q226_speed_test.gd q226_strands_test.gd q226_effects_test.gd` → 3/0.
Parse gate on census: `check_scripts.py q212_booked_census.gd` → 1/0.

**q226_speed_test.gd** — 6/0: OFF replay byte-identical; ON moves a fast man closer (ON 1.151 m vs OFF 1.190 m, diff 0.039 m within 0.12 m bound).
**q226_strands_test.gd** — 5/0: OFF replay byte-identical; technique specialist lands 30.4% vs balanced 29.6% (+0.8pp, within 0.08 bound); conditioning edge shows small stamina effect.
**q226_effects_test.gd** — 4/0: OFF replay byte-identical; ON does not reduce knockdowns or trauma; OFF pushback is 0.

**boxing_output_test.gd** — 19/0: OFF hashes byte-identical; ON thrown/rd 39.9, connect 25.5%, jab share 47.2% all in band; feints do not eat punches.
**fight_realtime_test.gd** — 378 checks PASS.
**fight_strike_whole_test.gd** — timed out (known-heavy; C230 also times out; WARNING spam from FightClipRetarget FBX loads, not Q226).

Focused suite: `fight_identity` 1/0, `fight_intent` 1/0, `fight_pace` 1/0.