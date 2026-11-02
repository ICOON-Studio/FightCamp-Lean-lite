# C134 — CONTINUATION 5 — CODEX — THE CONTACTS, WITH THE RETARGET FINALLY CORRECT

**No scope bound, no usage limit.** The operator is watching this run live.

```powershell
$env:CODEX_REPO   = "C:\Users\user\AppData\Local\Temp\FightCamp-C134"
$env:CODEX_MODEL  = "gpt-6-astra"
$env:CODEX_EFFORT = "medium"
& "C:\Users\user\OneDrive\Documents\ChatGPT\Game\Tools\codex_task.cmd" `
    "C:\Users\user\AppData\Local\Temp\FightCamp-C134\research\C134_CONTINUE_5.md" `
    "$env:TEMP\c134_cont5_last.txt"
```

## READ FIRST

`research/C134_BJJ_PRESENTATION.md` — your own digest, four runs deep. Then nothing else
unless this file names it. Fixture **seed 77321**.

---

## WHAT YOU JUST ESTABLISHED, AND WHY THIS RUN IS DIFFERENT

You proved the armbar defect was not placement at all: **retargeting discarded 1.020 m X and
0.844 m Z of the attacker's hip travel**, and you then **fixed it at the runtime retarget source**.
Every earlier attempt at those contacts was fighting a motion that had already been destroyed
upstream. **That is no longer true, and nothing since has re-examined the contacts with the
retarget correct.**

Your own report: "Reopened both submission auditions; contact defects remain, so neither was
enabled live." That is the work.

## THE WORK, IN ORDER

### 1. The armbar and the strangle, re-measured now that hip travel survives

For each, and **with numbers rather than an eye**: does the attacker's grip point and the victim's
wrist/neck now hold a fixed relationship **through the roll**, or do they still drift apart over the
clip? You built exactly this measurement to prove the hip-travel defect — run it again on the
repaired path and report the residual in metres, per frame, not as an impression.

**If a contact is now good enough to show, BIND IT AND SHOW IT.** If it is not, say what the
residual is and what is still eating it. A wrong position is worse than no clip; unshown and
reported is success.

### 2. Whatever else the repaired retarget unblocks

You refused clips before on defects that may have been this same root cause — the clinch break, the
sweep, the escape, the stand-up were all "available as raw asset auditions but refused in live
playback until their exact engine transition has verified matching film". **Re-test those refusals.**
Some of them may simply have been the hip travel too.

### 3. Report the coverage honestly, as you have every run

`beats / named clip played / honest degrade` for both routes, and a fresh recording of each. The BJJ
route's last two figures were 176 beats with 2 clips played and 174 honest degrades; the MMA route
76 beats with 50 played. **Those two numbers are the deliverable the operator actually reads.**

## HIGGSFIELD — TRY IT ONCE, THEN STOP

You reported it unreachable from your sandbox and spent zero credits, which was right. The operator
has now added it as an **MCP server** (`codex mcp add higgsfield --url mcp.higgsfield.ai/mcp`), which
runs outside the sandbox, so it may be reachable this run.

**Check once whether a Higgsfield MCP tool is available to you and say so in one line.** If it is
NOT, or if it needs a login you do not have, **say that and move on** — the login is the operator's
and they know it is outstanding.

**If it IS available, the limits are hard:** 0.1 credit per job, **ONE ACTION PER JOB** (24 of 30
multi-beat timelines froze), and **the grappling answer is already measured negative** — 8 of 8
two-fighter generations came back as ONE BODY, 0 of 4 armbar prompts reached the ground, and
composition scored 0 of 36. **Do not pay to re-run that.** The only untested question is whether a
HELD, static two-body pose behaves differently from a dynamic entry. **Three jobs maximum, and if
the first three come back as one body, stop and say so.**

## WHAT IS NOT YOURS

- **NO ENGINE EDITS.** Report them; they are mine. Two live ones you have already found and should
  keep reporting if they recur: BJJ bouts carrying unnamed head-contact IMPACT actions with wear,
  and grapple events losing presentation priority to action beats. **Your last run's BJJ recording
  ended by DECISION and the earlier KO did not reproduce — say so if that changes again.**
- **NO PURCHASES.** SKU, id, price, then stop. Still no verified SKU, and your hip-travel finding is
  why buying one would not have fixed this.
- **NO HAND-AUTHORED HOLDS.** Closed four runs ago and correctly so.
- **NO FULL SUITE**, and **NO REBASE** — I merge your branch.

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only c134   (then --only clip, --only grapple, --only pair, --only stage)
```

**Ceilings — land better and say so.** `--only c134` fails=0; `--only clip` fails=0; `--only grapple`
fails=1 or better (the one you have is engine drift, mine); `--only pair` fails=1 or better
(`fight_pair_live` is PARKED by the operator's 2026-09-15 ruling); `--only stage` fails=1 or better.

## THE RULES THAT STILL BIND YOU

- **Green tests do not finish this. The deliverable is what the operator sees moving.**
- **Open the output before trusting the gate.** You have done it on every run; it is why your work
  is trustworthy, and it is how you found the hip travel.
- **Commit after each step. An honest partial beats an uncommitted whole.**
- **`.c134/` is never committed. One recording per route, delete before re-recording.**
- Stage explicit paths (`git add -- <paths>`), then `git show --stat HEAD`. **Unstage
  `AgentComms/messages` before committing** — your own mail gets swept in otherwise.
- Push `codex/c134-bjj-presentation`, update `research/C134_BJJ_PRESENTATION.md`, and send
  `python Tools/agent_comms.py send --from codex --to claude "C134 ready"`. Do not edit
  `HANDOFF.md`.
