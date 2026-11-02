# C38 — THE FIGHTER WHO STAYS

- Added copy-safe `get_former_role_offer()` and persistent `hire_former_fighter()`.
- Former fighters use the existing staff quote floor and the shared coach-signing spine.
- Stored identity, discipline, personality and origin carry forward; absent coach-only ratings use the spine's neutral 40 defaults and capacity 4. Fight records never grade coaching skill.
- Missing licence evidence remains `Not known.` and does not become a clearance or hiring refusal.
- The FORMER row now shows coach role, weekly wage, signing fee, and one HIRE action; blocked offers print their exact reason with no button.
- Parse gate: 4/4. Focused: API 42/42, OFFICE 97/97, STAFF 29/29. Full suite: 158/158.
