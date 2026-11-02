# TASK U69 - CURSOR - THE IPPON LINE STAYED WHERE IT WAS WHEN THE CATALOGUE MOVED

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE AT ALL.** **Do NOT start
Godot for any reason**: Claude is running S1d's tests in this checkout and only
one Godot may run here at a time. Every number comes from Python over JSON, from
`git show <rev>:<path>`, and from reading code.

## Owned files

- `research/U69_IPPON_LINE.md` - **NEW, yours alone.**

Nothing else. **Do NOT edit `technique_catalog.json`, `combat_rulesets.json`, any
script or test, `HANDOFF.md` or `AgentComms/roadmap.json`.** This task produces a
ruling-ready finding; Claude applies it, judo only, in its own commit.

## Why this exists

`fight_scoring_test.gd` is red on master: `"a clean uchi-mata carries enough
magnitude to be an ippon (19 >= 22)"`. **A perfectly executed uchi-mata cannot
end a judo bout in this engine.** In the sport it is one of the most common
ippon throws there is.

The threshold is `22` at `Godot/assets/data/combat_rulesets.json:187` (judo's
`scoring_profile.ippon_threshold`). The magnitude is
`FightSimulation._technique_magnitude` (`Godot/scripts/FightSimulation.gd:2649`,
read `sed -n '2649,2670p'`) - the summed absolute value of the node's effects.
S1 re-authored every judo node in the 696-node merge. **The line was set against
one catalogue and is now being applied to another.** That is the "a gate keeps
its own copy of the answer" defect this project has hit nine times, wearing a
number instead of a list.

## Scope

1. **Where 22 came from.** `git log -S '"ippon_threshold"' --oneline -- Godot/assets/data/combat_rulesets.json`,
   then the commit message and digest that set it. What catalogue was it
   calibrated against, and what did uchi-mata measure then?
2. **The two distributions.** For every judo node with role `takedown`, its
   `_technique_magnitude` on master NOW and at the commit that set 22 (read the
   old catalogue with `git show <rev>:Godot/assets/data/technique_catalog.json`).
   Report min / median / max and how many cross 22, before and after. Name both
   commit hashes.
3. **How ippon is priced.** `Godot/scripts/RoundScoring.gd` `sed -n '155,200p'`
   and the takedown arm of `_apply_landed_effect`
   (`FightSimulation.gd` `sed -n '2062,2150p'`). State exactly which quantity is
   compared to the threshold - raw magnitude, magnitude times execution quality,
   or something else - with the line.
4. **The options, and your recommendation.** At least these three, each with
   what it moves: (a) re-author judo throw magnitudes, (b) change the threshold,
   (c) DERIVE the threshold from the judo tree's own takedown distribution so a
   future re-authoring cannot strand it again. For (c), name the statistic and
   show what it yields on both catalogues. **Say which throws become ippon-capable
   under each option** - a line so low that a foot sweep of magnitude 8 can end a
   bout outright is as wrong as one no throw reaches.

## THE TRAP

**The test is not automatically right.** It asserts a PROPERTY (a clean
uchi-mata can be ippon), and that property is real judo. But do not "fix" it by
finding the number that turns this one assertion green: check what your line does
to the SMALLEST judo takedowns too. U68 was told the same thing about teeps.

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never**
  run `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`,
  `git clean`, `git add -A`, `git pull` or `git push`.
- `git status -s` first, then commit ONLY your file, path-limited:
  `git add -- research/U69_IPPON_LINE.md` then
  `git commit -m "U69: ..." -- research/U69_IPPON_LINE.md`, ending the
  message with `Co-Authored-By: Cursor <noreply@cursor.com>`. **Do not push** -
  Claude has uncommitted work in this tree and pushes your commit.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U69-done --body "<hash> threshold_origin=<hash> judo_takedowns=<n> cross22_then=<n> cross22_now=<n> recommend=<a|b|c>"`
- Do NOT edit `HANDOFF.md`.
