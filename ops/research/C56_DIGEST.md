# C56 digest — The youth division

- Research-only deliverables: `C56_THE_YOUTH_DIVISION.md`; no code, JSON,
  scene, test, or `HANDOFF.md` changes.
- The six governing systems do not share one age clock: IJF/EJU, IBA, UWW and
  WT use calendar/year rules; WKF uses age on the first event day; IMMAF moved
  youth to birth-year eligibility from 2026 while its junior/senior text still
  uses first-day eligibility.
- Sourced international floors range from IMMAF Youth D at 10 to IJF official
  events at 15; UWW publishes a 13-in-year U15 tolerance. Karate is the clear
  contact/non-contact split: Kumite 18+, Kata 16+.
- Senior continuation differs: IBA Elite ends at 40; IMMAF, IJF, UWW, WT and
  WKF cited senior systems have no stated upper bound, with masters/veterans
  present for IMMAF, IJF and UWW and UNKNOWN for IBA, WT and WKF.
- Only judo supplies evidence of separate age ranking lists and an event-
  specific junior-to-senior selection route; automatic medal conversion for
  the other five is UNKNOWN.
- Repository seam confirmed: `EventResult.age_division` defaults to empty and
  is not production-written; `_turn_pro` has no age logic.
