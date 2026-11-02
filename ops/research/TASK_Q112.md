# TASK Q112 — QWEN — WHAT ROLE IS EVERY STRIKE THE ENGINE THROWS? THE JAB CENSUS

**Agent:** Qwen · **Model:** `qwen3-coder`, medium · `--yolo`, stdin, from its worktree
**Assigned:** 2026-09-20 by Claude
**Tier: RESEARCH BEHIND A CHECK SCRIPT. You write ONE new tool and ONE digest. No engine file is
edited, so NO parse gate on engine scripts and NO suite** — only the parse gate on your own new
`.gd` tool, then run it.
**Deliverable:** `Godot/tools/q112_role_census.gd`, `research/Q112_ROLE_CENSUS.md`, and it
must make `research/Q112_check.py` exit 0 — **that check script is written FIRST, by you,
before the census, and it is the thing I will run.**

---

## THE QUESTION, IN ONE PARAGRAPH

The engine has just been calibrated so that it throws the right NUMBER of significant strikes a
minute (7.04 against J20's 6.85). What it throws is now the open question, and one figure says it
is badly wrong: **83.2% of the engine's landed standing head strikes are in a POWER role.** J20's
own arithmetic implies about **26%** — a real fight's most-thrown punch is the jab, and this engine
barely throws one. **Nobody has ever counted what the engine throws, by role, across disciplines.**
That census is this task.

## WHAT TO COUNT

For each of `boxing`, `kickboxing`, `muay_thai`, `mma`, over a population of bouts:

1. **Every strike ATTEMPTED, bucketed by `role`** — the field is on each impact event in
   `state["log"]`. Report the share each role holds, and **report the empty-role share separately**:
   `technique`, `technique_name` and `role` are empty together on the fallback path, and a fighter
   on that path is invisible to a role count.
2. **The same split for LANDED strikes** (contact `clean` or `glancing`), because accuracy differs
   by role and the two distributions are not the same question.
3. **`FightMoves.POWER_ROLES` membership** — the share of attempts and of landed strikes that are
   in a power role, which is the 83.2% figure's definition.
4. **The jab specifically.** Whatever id or ids the catalogue uses for a jab in each discipline,
   count them by name as well as by role. A role bucket can hide a discipline that has no jab node
   at all.
5. **By POSITION** (`distance` / `clinch` / `ground`), because J20's significant-strike definition
   turns on position and the power/jab mix at distance is the one the anchor is about.

## THE ANCHOR, AND IT IS ARITHMETIC RATHER THAN A PUBLISHED TABLE

J20 section A gives 71.3 combined significant landed a fight and section B gives 63% head, so about
**44.9 landed head strikes a fight**. Section F's knockdown rate is **3.9% per landed DISTANCE
POWER HEAD strike** (Reed Kuhn / Fightnomics, verbatim, recovered by R151), and section F's own
knockdown count is 0.41–0.52 a fight — so the implied count of landed distance power-head strikes is
**10.5–13.3 a fight, about 26% of head strikes.** The engine's is 30.5 a fight, about 60%.

**J20 publishes no direct role table, so 26% is an INFERENCE and must be labelled one in your
digest.** Do not present it as DOCUMENTED. What is documented is the 3.9% and the 0.41–0.52.

## WRITE THE CHECK SCRIPT FIRST

`research/Q112_check.py` must, run on its own, exit 0 only if your census is actually present
and non-vacuous. At minimum it must refuse:

- a missing or empty census file;
- **any discipline whose total attempts are zero** — a census that counted nothing passes every
  "share" test ever written, because 0/0 is reported as 0.0%;
- **shares that do not sum to 100%** within a tolerance, which catches a bucket you forgot;
- an **absent empty-role row** — if the empty-role share is genuinely 0% it must SAY 0%, not be
  missing;
- a digest that names no population.

**Derive the allowed role names from `FightMoves` or the catalogue, not from a list you type into
the check.** A gate that learns its allowed values from the thing it is validating cannot fail, and
that exact defect has been found in this project three times.

## POPULATION — AND THIS IS A HARD RULE

**NEVER TEST IDENTICAL FIGHTERS.** Two fighters built from one stat block measure the fixture, not
the engine. Use pairings of genuinely different men, and **every man must be LEGAL for the ruleset
he is in** — differentiate by style and attributes INSIDE the discipline, never by removing
techniques the ruleset permits. A kickboxing bout is an outside kicker against a pressure puncher,
both able to kick. `tools/probe_balance_anchors.gd` has four such MMA pairings (`_pairings()`) you
may copy the shape of; you will need to build the equivalent for the other three disciplines.

**And name the catalogue in your output as well as the men** — a fixture is the fighters AND the
data they fight under.

**Watch for the empty stat block.** The key is `stats`, not `"attributes"`, and the weight key is
`competition_weight_kg`, not `weight_kg`. Get either wrong and every fighter silently falls to the
fallback path where `role` is empty — which would make this entire census read 100% empty-role and
look like a finding.

## HOW TO RUN IT

```
python Godot/tools/check_scripts.py Godot/tools/q112_role_census.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q112_role_census.gd -- 15
python research/Q112_check.py
```

`-- 15` is 15 bouts per pairing. Use enough bouts that the smallest role bucket has a real n, and
**report the n for every bucket** — a share with no denominator beside it is not a measurement.

**ON WINDOWS the console Godot exe deadlocks forever on a PowerShell redirect and produces zero
bytes.** Use `Tools/s26_tool.cmd <tool-name> <log-path> <args>`, which owns its own redirect.

## RULES

- **No engine edits.** You are counting, not changing. If the census reveals a defect, write it
  down — it is mine to fix.
- Read this file and the files it names. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md` or any
  digest, and do not explore to get oriented. `FightRealtime.gd` is ~4,100 lines — **never open it
  whole**; you need `state["log"]`'s event fields and nothing else, and
  `tools/probe_balance_anchors.gd` (about 420 lines, read it whole) already shows how to fold that
  stream.
- `var x := <call>` fails when the call returns Variant — write the type. `%` in a format string
  must be `%%`. A reused variable name in one function is a parse error even across separate
  `if`/`for` blocks.
- Stage explicit paths (`git add -- <paths>`), then `git show --stat HEAD`. **Unstage
  `AgentComms/messages` before committing.**
- Push, then send one line with
  `python Tools/agent_comms.py send --from qwen --to claude "Q112 ready"`. Do NOT edit
  `HANDOFF.md`.
