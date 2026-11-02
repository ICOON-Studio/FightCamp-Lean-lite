---
name: feedback-claude-is-the-developer
description: S194 operator - technical/architecture decisions are Claude's; never ask him a code-structure question; spot structural debt yourself
metadata:
  type: feedback
---
Operator S194, after I asked whether rooms should be separate modules: "i have no clue on game development [...] you are the developer",
then "DO WHATEVER IS NEEDED FOR THE PROPER AND FASTER DEVELOPMENT OF THE GAME". Now a CLAUDE.md s2 rule (architecture removed from the
ask-the-operator list).

**Why:** he is CEO/playtester, not an engineer; a technical question wastes his time and signals I am not owning the build.
**How to apply:** decide code structure, refactors, module splits, tooling, test strategy myself and report the decision + reason.
Watch for debt proactively (GymClub3D.gd hit ~2,500 lines before anyone split it - ROOMSPLIT1). Ask only money, taste, scope.
Related: [[user-role-ceo-and-lead-dev]].
