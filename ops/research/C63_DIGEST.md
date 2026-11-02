# C63 digest

- Added pure, stateless `ImpactModel`: strict six-region/contact impact records,
  conservation-split target wear, force-squared head shock, high-force clean
  torso shock for caller-delayed liver events, flash-knockdown classification,
  and duration-derived per-minute rates.
- U20-authored balance gaps are named constants with their reasoning beside
  them; the module contains no engine, autoload, persistence, or preload access.
- Unknown regions, contact words, and malformed impact records are refused.
- Gate: parse `2/2`; focused `IMPACT_MODEL_TEST PASS checks=33`; isolated
  writable-context full suite `SUITE total=199 fails=0`.
