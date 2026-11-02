# C12 — Save slots read

`get_save_summary()` now distinguishes an empty/invalid slot from a readable
but incompatible Career. `get_save_slots()` returns the three summaries in
slot order and marks the newest compatible save; Continue keeps ignoring an
incompatible newer file. No migration, write API or save schema changed.

`save_slots_api_test.gd` creates real isolated saves and hand-edits one saved
`save_version`. Parser: 2/2. Focused: 13/13. Smoke: green. The Git-Bash full
suite wrapper did not return a trustworthy summary because it detached and
continued spawning headless child tests.
