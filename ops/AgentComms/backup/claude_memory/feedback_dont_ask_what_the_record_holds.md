---
name: feedback-dont-ask-what-the-record-holds
description: "Never put a question to the operator that the record or a public page answers - S75 asked \"which Tripo plan made the fighters\" when Claude made them and memory said Free plan"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2cdfc054-a9df-45f0-9ad5-6dd1545d96c2
  modified: 2026-09-29T06:41:07.073Z
---

S75 (2026-09-25): the phase-0 legal inventory listed "Tripo: which plan made the twelve fighters, and do its terms
allow selling?" under "Your calls". The operator: *"it was you that made the trippo fighters, why are you awsking me
which plan was used ?"* The plan was already in memory ([[project_generator_credits]]: Free plan, 200 credits) and
the terms were one page away - tripo3d.ai/pricing says Free = "Public Models · Non-Commercial Use".

**Why:** a question to the operator costs their time and reads as not knowing our own work. The rule
[[feedback_check_research_record_first]] covers research; this extends it to licences, prices and anything I did.

**S123 (2026-09-29), the same failure with a machine's words:** Claude asked "Codex ran C161 at 06:01, so it isn't
locked until 10-03 as recorded. Did you top it up?" The operator: *"did i tell you codex is out of credits ?"* He never
had - the "locked until 10-03" note was CODEX'S OWN usage-limit error text, written down by S119. Claude put an agent's
output to him as if it were his statement, and asked him about live state Claude could read itself (the run's last
lines, the usage page). **Before putting any fact to the operator, name who said it** - the operator, an agent's
output, or a session's inference - and never attribute the last two to him. See [[project-codex-allowance-2026-09-26]].

**How to apply:** before any "your call" list, for each item ask: did I (or an agent) do this - then the record has it;
is it public (a pricing/terms page) - then read it in the browser pane. Only what exists solely in the operator's
head or accounts (their subscription prices, a file on their machine, a product ruling) goes on the list.
