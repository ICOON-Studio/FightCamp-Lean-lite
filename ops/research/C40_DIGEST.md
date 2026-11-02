# C40 — The channel a bout arrives through

Added the closed channel vocabulary to `EntityPathway` and a `channel` field
to every bout-offer producer in `GameState`. Existing offer values, key order,
RNG calls, purses and eligibility writes are unchanged.

- Amateur/federation and open-entry organization offers, plus ordinary event
  open slots: `open_card`.
- Signed fighters' `promo|` offers: `matchmaker`. The `org|` promotion path is
  a player-selected challenge, so it retains an explicitly unknown channel.
- Recorded event replacements: `short_notice`, overriding open-card entry.
  The short-notice desk row copies the producer's channel; the booking board
  already preserves it through its deep-copy read.
- Synthetic tiers, rivalry, Contender Series and Grand Prix offers, and
  champion superfights: `""` where this task cannot establish the channel.
- `gym_to_gym` is a constant only, with no production writer.

Validation: touched-script parse gates passed; the C40 mailbox gate passed.
All six required focused tests passed. New assertions cover amateur dispatch,
organization entry vs signed matchmaking, unknown synthetic offers, a real
withdrawal overriding open-card entry, read passthrough and copy isolation.

Full suite ran once: **163 scripts, 162 passed, 1 existing error (351s)**.
`fight_simulation_test.gd:631` accesses the removed
`FightSimulation.BOXING_MIN_ROUND_SCORE` constant. It prints 233 checks and
0 failures and exits 0, but emits a SCRIPT ERROR; the runner counts that as a
failure. Both files match pre-C40 HEAD `fea73dc`; `git grep` there confirms
the reference exists only in the test, not the simulation module. No scoring
file was changed. Other agents were editing the shared checkout during the run.

Godot 4.7.2 used the installed Chocolatey console binary. The initial sandboxed
tests could not write isolated `user://` careers; rerunning with writable test
saves resolved that restriction. One new event fixture needed its country
field so the existing board filter could include it; the corrected test passed.

Per TASK_C40's refusal, the general AGENTS.md HANDOFF-block rule is set aside:
no HANDOFF or panel edits. Claude owns the handoff and Cursor's U6 consumes
the field. Additional offer-producer windows were traced to cover every bout
row, including event replacement and specialized offer paths.
