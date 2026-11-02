# C134 — CONTINUATION 2 — CODEX

**THE USAGE LIMIT IS GONE. The operator upgraded the plan on 2026-09-20, in as many words:
"there is no limit".** Continuation 1 was bounded because a 5-hour cap had already cut run 1 off
mid-edit at 189k tokens. That bound no longer applies and this file replaces it. You still commit
after each step — an honest partial beats an uncommitted whole — but you are not to stop early to
save budget.

`codex exec` is one-shot and run 2's thread is gone, so this file is the context.

Launch (PowerShell, from anywhere):

```powershell
$env:CODEX_REPO   = "C:\Users\user\AppData\Local\Temp\FightCamp-C134"
$env:CODEX_MODEL  = "gpt-6-astra"
$env:CODEX_EFFORT = "medium"
& "C:\Users\user\OneDrive\Documents\ChatGPT\Game\Tools\codex_task.cmd" `
    "C:\Users\user\AppData\Local\Temp\FightCamp-C134\research\C134_CONTINUE_2.md" `
    "$env:TEMP\c134_cont2_last.txt"
```

---

## READ FIRST, IN THIS ORDER, AND NOTHING ELSE

1. `research/C134_BJJ_PRESENTATION.md` — **your own digest.** It is the handover.
2. `research/TASK_C134.md` — the original task: ownership, assets, licences, acceptance.

Runs 1 and 2 are committed and pushed on `codex/c134-bjj-presentation` (`1b82e7a1`). Your
workspace `C:/Users/user/AppData/Local/Temp/FightCamp-C134` is unchanged, with `.godotbin/` and
the warm import cache. **Do not redo stage 1. Do not re-audit the assets. Do not rebase.**

Fixture: **seed 77321** (810039 produces no grapple beats in 120 s on either route).

---

## WHAT RUN 2 SETTLED — ACCEPTED AS TRUE, DO NOT RE-DERIVE

**The mount fix WORKED and it is the template for this run.** Turning the top body 180° about its
posed hips and offsetting −0.12 m on the shared pair X axis fixed a large facing and thigh-contact
defect, preserved body scale, and restored pre-pair transforms so repeated holds cannot drift. That
is placement-and-offset work on films that already exist, it is verifiable in four rendered views,
and it landed.

**Hand-authoring a hold from nothing FAILED and is closed.** Four original Animation resources,
four iterations on torso inclination, bottom frames, crossface and posted arm, then a reversed-role
review — and forearm/head clearance, wrist contact and torso pressure were all unreliable. You were
right to reject it and right not to bind a placeholder. **Do not attempt another hand-authored hold
in this run.** Your own conclusion stands: a missing hold is a purchase or commission decision, and
that decision is the operator's.

---

## THIS RUN'S SCOPE — THE THREE THINGS THAT NEED NO NEW FILM

Everything here is the mount fix's technique applied to defects you have already located, plus one
red test you already diagnosed. Commit after each.

### 1. `fight_grapple_seam` — you found the cause, now fix it

`--only grapple` is **10/1**, and your digest names why: the test "expects every film to finish, but
seat departure cuts one (played=3 completed=2 cut=1)". Decide which side is wrong and say so in the
digest — either a film cut short by a legitimate seat departure is correct behaviour and the test's
expectation is too strong, or the seat is departing when it should not. **If it is the test, change
the test and say what the engine behaviour actually is.** This is a presentation-layer test, not an
engine edit.

### 2. The armbar and strangle contacts — same class as the mount

Your run-1 frame inspection found disconnected armbar contacts at 9.5–11.5 s and questionable
strangle contact at 13.5–18.5 s, and run 2 explicitly made "no correction to armbar/strangle/action
clips". These are bought films in a pair placement, which is exactly what you just fixed for the
mount. Use `c134_hold_review.gd`'s four-view method on each, iterate the offset, and **show the
before and after frames as evidence.** If one of them turns out not to be a placement problem —
the retarget itself is wrong, say — report that with the frames and move on rather than forcing it.

### 3. Tap and release

Unverified and unshown, and it needs no new film: a tap is a state and a release is the seat
ending. Verify the submission finish path drives it and show it on screen, or report precisely what
is missing.

### THEN, and only when 1–3 are committed

Fill in the digest's remaining gaps and **regenerate the two match recordings** so they are evidence
of THIS state rather than run one's. The commands are in your own digest's reproduction block.

**THE SCRATCH DIRECTORY IS NOT A BIN.** A recording pair is ~1.7 GB. Delete the previous `.avi` for
a route before re-recording it, or write to the same filename. **At most ONE recording per route.**
`.c134/` is never committed.

---

## WHAT IS NOT IN SCOPE

- **No engine edits.** The engine is not yours. That includes the two findings you already made and
  should keep reporting: BJJ bouts carrying unnamed head-contact IMPACT actions with wear, and
  grapple events losing presentation priority to action beats. **Claude owns those.**
- **No purchases.** Propose with SKU, id and price, and stop. The operator decides.
- **No new hand-authored holds** (see above).
- **No full suite.** That is Claude's at integration.

---

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only c134      (then --only grapple, --only pair, --only stage)
```

**Ceilings, not exact counts — if you land better, say so and push.**
- `--only c134`: **fails=0.**
- `--only grapple`: **fails=0** is the target of step 1; fails=1 with a written verdict on which
  side was wrong is an acceptable result, fails=1 with no verdict is not.
- `--only pair`: **fails=1 or better** — `fight_pair_live` is PARKED by the operator's 2026-09-15
  ruling and is not your failure.
- `--only stage`: **fails=2 or better** — the parked `fight_stage_presenter_contract`, plus
  `fight_stage_realism`, which was already red before you touched anything.

**A NOTE ON MASTER, BECAUSE IT MOVED UNDER YOU.** Claude landed S26 on master while you ran
(`e74bde2f`): the fight's attempt gate was a bare `0.35` and is now a named `THROW_GATE_BASE` at
`0.06`, which cut the significant-strike pace 6.3× to J20's anchor. **This changes what a bout
looks like** — far fewer strikes, longer fights, many more decisions — so seed 77321's beat
timeline is NOT what run 2 saw. Re-run your review harness before trusting any timestamp in your
own digest, and if the grapple coverage changed because of it, that is a finding worth writing
down rather than a defect you caused. Do NOT rebase; Claude merges.

## THE RULES THAT STILL BIND YOU

- **A wrong position is worse than no clip.** Unshown and reported is success; faked is failure.
- **Green tests do not finish this.** The deliverable is what the operator sees moving.
- **Open the output before trusting the gate** — you did this correctly twice and it is why run 2
  is worth having. Keep doing it.
- Stage explicit paths (`git add -- <paths>`, then `git show --stat HEAD`). The worktree carries
  ~1,000 `.import` files, ~700 extracted textures and a multi-GB `.c134/` scratch — **none of it is
  yours and none of it is ever committed.**
- Push `codex/c134-bjj-presentation`, update `research/C134_BJJ_PRESENTATION.md`, and send
  `python Tools/agent_comms.py send --from codex --to claude --subject "C134 ready"`.
  Do not edit `HANDOFF.md`.
