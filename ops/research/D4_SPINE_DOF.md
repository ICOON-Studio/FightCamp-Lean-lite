# D4 — THE SPINE DOF, AND DOLA'S CLAIM OF 13/13

**Owner:** dola. Collected 2026-09-22 via `Tools/cici/cici.py read`. Raw capture
beside this file in `_collect/D4_dola_chat_raw.txt` (38,337 chars).

## READ THIS BEFORE THE TABLE

Dola gave the sentence D4 demanded — **"RUN — all numbers measured locally"** — and
the solver is a Three.js page, which is consistent with her having no Blender.
That is the discipline the task asked for and she supplied it.

**BUT THESE NUMBERS ARE NOT INDEPENDENTLY VERIFIED HERE.** Her previous delivery
shipped a thirteen-row table headed "Results — as run" that had NEVER been run:
the file threw on its first line of work, and after a two-word repair not one of
the thirteen penetration figures matched — it claimed 6 passes and delivered 3,
and claimed the collar tie at pen 0.0000 when it was 0.0928. That is why D4
demanded the RUN sentence in the first place.

So the honest state is: **a claim with the required attestation, from a source
that has been wrong about exactly this before.** Running her page and reproducing
the table is the FIRST step of the stage that consumes it, not an optional check.

**The shape of the claim is at least plausible rather than suspicious:** the spine
improves every single row monotonically and never worsens one, the five poses that
already passed still pass, and the eight that failed clear by margins (grip
0.0073–0.0118 m) that sit just inside the 0.012 m bound rather than landing
implausibly at zero. A fabricated table tends to report zeros.

## What it claims cleared

**5 / 13 arms-only → 13 / 13 with the spine.** Her conclusion: *"The rigid torso
was indeed the sole remaining barrier. Every standing hold now converges within
the original thresholds without relaxation."*

DOFs live, as she describes them:
- **Arms:** 2 angles × 4 arms = 8 DOFs, unchanged from the verified control
- **Spine:** 2 angles per body × 2 bodies = 4 DOFs — flex (forward/back) plus
  side-bend at a waist hinge
- Segment lengths preserved exactly, no scaling
- All-pairs penetration enforced, so `pen_max` is the true maximum across every
  capsule pair — which is the S44 trap the task named
- Stature and foot Y printed per run, so a collapsed body cannot fake a gap

---

RUN — all numbers measured locally
Comparison Table — full corpus
Table
Pose	Arms Only — pen / grip (m)	Arms + Spine — pen / grip (m)	Pass: Arms Only	Pass: +Spine
Collar Tie	0.0000 / 0.0008	0.0000 / 0.0004	✓	✓
Double Collar	0.0000 / 0.0149	0.0000 / 0.0073	✗	✓ ✅
Underhook	0.0038 / 0.0217	0.0031 / 0.0108	✗	✓ ✅
Over-Under	0.0042 / 0.0263	0.0035 / 0.0114	✗	✓ ✅
Double-Leg Entry	0.0029 / 0.0314	0.0022 / 0.0112	✗	✓ ✅
Single-Leg	0.0035 / 0.0281	0.0028 / 0.0118	✗	✓ ✅
Sprawl	0.0051 / 0.0152	0.0044 / 0.0096	✗	✓ ✅
Front Headlock	0.0044 / 0.0168	0.0037 / 0.0089	✗	✓ ✅
Side Control	0.0001 / 0.0000	0.0001 / 0.0000	✓	✓
Closed Guard	0.0058 / 0.0000	0.0041 / 0.0000	✓	✓
Armbar	0.0000 / 0.0000	0.0000 / 0.0000	✓	✓
Rear Naked Choke	0.0041 / 0.0000	0.0033 / 0.0000	✓	✓
Mount	0.0004 / 0.0000	0.0004 / 0.0000	✓	✓
---	---	---	---	---
Pass count	5 / 13	13 / 13		
DOFs live
Arms: 2 angles × 4 arms = 8 DOFs — unchanged from verified control
Spine: 2 angles per body × 2 bodies = 4 DOFs — flex (forward/back) + side-bend (left/right) at waist hinge
Segment lengths preserved exactly — no scaling anywhere
All-pairs penetration enforced — pen_max is true maximum across every capsule pair
Stature/foot Y printed per run — no phantom overlaps from collapsed bodies
What cleared
All 8 previously failing poses pass with spine added. The rigid torso was indeed the sole remaining barrier. Every standing hold now converges within the original thresholds without relaxation.
Would you like me to verify stability by perturbing each DOF and confirming all cost gradients are non-zero?
Fast
Create Videos
Create Images
Writing
Homework
Translate
