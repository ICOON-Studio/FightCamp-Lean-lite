# TASK U111 — CURSOR — THE TWO ROWS U109 AND U110 GOT WRONG, RE-MEASURED

**Agent:** Cursor · **Model:** `composer-2.5`, medium · `-p --force --trust --workspace <wt>`
**Assigned:** 2026-09-20 by Claude · **Tier: RESEARCH + TOOL. No `.gd` touched, so NO parse gate
and NO suite** — `git status -s` before staging is the whole check.
**Deliverable:** `research/U111_FOOTAGE_ROWS_REMEASURED.md` plus whatever changes to
`Tools/footage/*.py` the fix needs.

---

## WHY THIS EXISTS

U109 and U110 were collected and **NOT ACCEPTED**, and the reason is one bad row each. Everything
else in both is sound and stays — this task fixes exactly two numbers. Your own digests are honest
about their populations, which is why the defects were findable at all.

## ROW 1 — U110's KICK FIGURE IS AN ARTEFACT OF MEASURING KICKS IN BOXING FOOTAGE

U110 reports, as `away_s` at p50:

| limb | p50 (s) | n | population |
|---|---|---|---|
| lead hand (Q110) | 0.267 | 117 | 16 boxing, planted |
| rear hand | 0.267 | 263 | 10 boxing videos |
| **kick** | **0.067** | 413 | **10 boxing videos** |

**A kick is the LONGEST commitment a man makes, not a quarter of a lead hand's.** 0.067 s is four
frames at 60 fps. And the population says why: **ten BOXING videos.** Boxers do not kick, so
whatever those 413 events are, they are not kicks — most likely knee lifts, steps, or pose noise
picked up by a limb classifier that has no business firing on that footage.

**What to do:**
1. **Say what those 413 events actually are.** Sample them, look at the frames, and name the
   failure. A classifier that emits 413 kicks from boxing footage is a bug worth understanding
   before it is silenced.
2. **Re-measure the kick row on footage that contains kicks** — kickboxing, Muay Thai or MMA. The
   UFC round-1 track you already keep (`_mkFV2H2oCk_r1`, 126.8 s) has kicks; it is not enough on
   its own, so fetch more. `python -m yt_dlp` plus `imageio-ffmpeg` are on this machine and
   `reference_pc_footage_tools` records the traps (AV1 398 decodes; broadcast cuts halve tracking).
3. **If a discipline genuinely has too few clean kicks to measure, say NOT FOUND and give the n.**
   A labelled absence is a usable result; 0.067 s is not.

**Keep the rear-hand row.** 0.267 s over n=263 is the one figure from U110 that is already usable
and an engine constant will read it.

## ROW 2 — U109's TURN RATE IS NOT TRUSTWORTHY AND YOUR OWN DIGEST SAYS SO

U109 reports `turn_yaw_deg_s` **max 10577 deg/s** — twenty-nine full revolutions a second. Your
digest already flags it: "Hip-line normal with a shoulder-width collapse gate; monocular 2D facing
may still be unreliable on edge-on footage."

**Do not just clamp it.** A maximum that absurd means the estimator is inverting or flipping, and a
clamp hides that while leaving the p50 and p90 quietly wrong.

**What to do:**
1. Find what produces it — near-certainly a sign flip or a wrap when the shoulder/hip line is
   edge-on to the camera and the width collapses toward zero.
2. Fix the estimator or **exclude the frames it cannot resolve, and report what share was
   excluded.** An honest denominator beats a clamped extremum.
3. **Report p50 and p90, and DECLARE the max as artefact-dominated if it still is.** The standing
   rule is never to gate an extremum — bounding a max invites passing it by discarding samples — so
   the deliverable is the percentiles plus the excluded share, not a tidy maximum.

## WHY BOTH MATTER RIGHT NOW

`FightIntent.preferred_range` was just re-anchored to a real study (Schortgen, 1.23 ± 0.16 m) and
the engine's spacing now sits inside it. **The next constants in that family are the between-
exchange rates — how often a man resets, changes direction, changes level, and how long a kick
commits him — and those come from your two files.** A kick commitment of 0.067 s would be wired
into an engine constant and would be wrong by roughly a factor of five.

## RULES

- **Populations are named in the output**, as both your digests already do. Six of the sixteen
  boxing videos contain no two-man footage at all; keep saying so.
- **No `.gd` files.** This is measurement and tooling only, so no parse gate and no test run.
- **Do not re-derive what is already right.** U110's rear hand and U109's other rates stand.
- Stage explicit paths (`git add -- <paths>`), then `git show --stat HEAD`. **Unstage
  `AgentComms/messages` before committing** — an agent's own mail gets swept in by an
  un-path-limited commit, and it has happened twice.
- Push your branch and send one line with
  `python Tools/agent_comms.py send --from cursor --to claude "U111 ready"`. Do NOT edit
  `HANDOFF.md`.
