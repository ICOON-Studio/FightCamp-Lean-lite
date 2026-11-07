extends RefCounted
## S396 rank 3, the plan bites (docs/STRUCTURE_DESIGN_S395.md 5.3 change 1 and 5.3a rule 4). Measured before: good plan
## 59.0% of close bouts, no plan 45.8%, bad plan 42.8% (tools/plan_effect_probe.gd, 400 bouts) - 16 points; the target is
## 30. A plan's answer was worth its edge in that exchange only, so a good read never built and a wrong one never cost more.
##
## Two rules, pure:
## - READ: in a round, a planned answer that is the right one (PlanFight fit "best") and wins puts her one read up on the
##   opponent; a planned answer that is the wrong one and loses puts the opponent one up on her. Each read is worth
##   STACK_EDGE to every later exchange of the round, up to MAX_READS either way. The corner minute resets it.
## - ADJUST (rule 4, "opponents adjust"): an answer that keeps being the right one loses ADJUST of its edge per use after
##   the first FREE_USES in a round - leaning on one line stops paying, so the plan stays a puzzle. Per round, not per
##   fight: a template built for her opponent leans on its key answer, and a fight-long count left it behind the coach's
##   generic starter (plan_templates_test); the corner minute resets both sides' reads.
##   PlanRead.edge(reads) -> float   PlanRead.after(reads, fit, planned, won) -> int   PlanRead.adjust(uses) -> float

const STACK_EDGE := 3.5
const MAX_READS := 2
const FREE_USES := 2
const ADJUST := 0.7


static func edge(reads: int) -> float:
	return float(clampi(reads, -MAX_READS, MAX_READS)) * STACK_EDGE


static func after(reads: int, fit: String, planned: bool, won: bool) -> int:
	if not planned:
		return reads
	if fit == "best" and won:
		return mini(reads + 1, MAX_READS)
	if fit == "wrong" and not won:
		return maxi(reads - 1, -MAX_READS)
	return reads


## The share of a right answer's edge left after `uses` earlier right uses in this fight.
static func adjust(uses: int) -> float:
	return pow(ADJUST, float(maxi(0, uses - FREE_USES)))
