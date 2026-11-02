---
name: feedback-claude-lead-developer-role
description: "In the FightCamp project, Claude is the lead developer: assigns tasks to Codex and Grok, and must present a short summary plus alternative options for the next stage of work and get the user's go-ahead BEFORE proceeding, rather than autonomously deciding and starting."
metadata:
  type: feedback
  originSessionId: a097cbf7-f586-4498-8789-03364a500757
  modified: 2026-08-31T11:52:43.261Z
---

On 2026-08-31 the user said: **"you are now the lead designer, you assign
codex and grok tasks, i want you to give me a small summary each time of
what will be developed next and if there are other options before we
proceed, how we proceed?"** — then immediately corrected: **"i meant lead
developer not designer."**

**Why this matters:** up to this point in the project, task assignment for
each new stage (4A through 4E) was mostly either Codex writing the "Assign
Stage 4X work fifty-fifty" HANDOFF.md entry, or me doing it once
autonomously for Stage 4E per an earlier "assign tasks... and proceed"
instruction. This message changes the standing arrangement: I am now
explicitly the lead developer who plans and assigns stages across all three
agents (Codex, Grok, and myself) going forward - and critically, I must
check in with the user before committing to a direction, not just pick one
and go.

**How to apply:**
- Before writing a new "Assign Stage 4X" HANDOFF.md entry (or otherwise
  committing the team to a new stage of work), give the user a SHORT summary
  (a few sentences, not an exhaustive design doc) of what the proposed next
  stage would cover, plus 2-3 genuine alternative directions if they exist.
  Ask how they want to proceed - do not default to "pick the most obvious
  option and start."
- This applies to PLANNING/DIRECTION decisions (what stage comes next, how
  work should be split across the three agents). It does NOT mean stopping
  to ask permission for every individual implementation step, commit, or
  routine HANDOFF.md coordination update within a stage the user has already
  greenlit - normal execution autonomy still applies once a direction is
  chosen. See [[feedback-mirror-new-info-to-handoff]] for the standing rule
  about keeping HANDOFF.md in sync with chat decisions.
- If Codex or Grok proposes/starts a stage on their own initiative (as they
  have done before, e.g. Stage 4D's "assign claude 50-50 tasks and proceed"
  came from the user talking to Codex directly), that is still legitimate
  and I should follow it - this new role is about MY OWN planning
  initiative, not a veto over the other agents' own user-directed work.
- Refer to this role as "lead developer" in any user-facing text or
  HANDOFF.md notes, not "lead designer" - the user corrected this explicitly
  and immediately, so it's a real distinction to them, not a synonym.
