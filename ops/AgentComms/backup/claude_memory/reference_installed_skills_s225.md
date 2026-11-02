---
name: reference_installed_skills_s225
description: "S225 operator \"check the skills and add them\" - Superpowers (15 skills), grill-me, handoff, frontend-design, webapp-testing installed at user scope via `npx skills add -g`; how they sit with CLAUDE.md"
metadata:
  node_type: memory
  type: reference
  originSessionId: 30a4cc5e-b22d-4889-b9ce-4f20748dfe7f
  modified: 2026-10-15T15:36:32.144Z
---

Installed 2026-10-15 (S225) with the skills CLI (`npx -y skills add <repo> [--skill x] -g -y`), symlinked from
`~/.claude/skills/<name>` to `~/.agents/skills/<name>`, also linked for Codex, Cline, Antigravity, Cursor (+6 agents):
- obra/superpowers: brainstorming, writing-plans, executing-plans, subagent-driven-development, test-driven-development,
  systematic-debugging, verification-before-completion, requesting/receiving-code-review, using-git-worktrees, finishing-a-development-
  branch, dispatching-parallel-agents, using-superpowers, writing-skills, diagnosing-superpowers.
- mattpocock/skills: grill-me (pressure-test a plan by questions), handoff (session -> markdown handoff doc).
- anthropics/skills: frontend-design (for the ops board / HTML mock-ups), webapp-testing (Playwright on a local web app).
Already present before, not re-added: docx/pdf/pptx/xlsx, skill-creator, mcp-builder, code-review, security-review, grunt (= caveman).
Skipped (need the interactive /plugin menu or an MCP): context7, planning-with-files, claude-mem, gstack, trailofbits.

**How to apply:** CLAUDE.md wins. brainstorming / grill-me / writing-plans interview style goes to Ludo, agents or research, NEVER to
the operator (he answers only money/taste/scope); the project's own gates (parse, --jobs 2|3, visual-gate, roadmap now) replace
superpowers' generic plan/TDD loop where they differ. `using-superpowers` "invoke a skill before any response" does not override
the session-start rules (start, queue, questions). Related: [[feedback_claude_is_the_developer]], [[feedback_usage_economy]].
