# C77 digest

- Added the blind `FightBeatAdapter` contract test, including selection priority, exact view shape, deterministic replay, result passthrough, finished-fight immutability, grapple suppression, non-aliasing, and full-fight shown/dropped witnesses.
- Gate: `CHECK total=1 fails=0`; focused test: `checks=3661 failures=0`.
- Contract reading: an impact's dictionary-valued `wear` is ranked by the sum of its numeric region deltas; ties choose the earliest tick.
