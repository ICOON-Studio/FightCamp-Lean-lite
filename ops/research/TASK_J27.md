# TASK J27 — JOHN — HOW OFTEN EACH STRIKE IS THROWN, AND WHAT REALLY DEFENDS A THROW

**Research only.** No checkout, no engine, no repo access — none is needed. Do not
propose code. Prose, numbers, sources. One pass, two parts.

Approved by the operator on 2026-09-13 as ONE outside query covering both parts.

---

## THE SITUATION

We are building a fighting-simulation game whose fights are resolved technique by
technique. Two gaps in our own data can only be filled from outside.

**Part A — frequencies.** Our engine picks which technique a fighter throws by its
role and its range, so every technique in a fighter's arsenal is thrown about as
often as every other: a spinning elbow as often as a jab. We measured it. To fix it
we need how often each technique is REALLY thrown, and that is not in any data we own.

**Part B — judo and sambo defence.** Today we found that the whole judo technique
tree has exactly ONE defensive technique: **ukemi**, the breakfall. Our engine was
counting it as a defence that stops a throw from landing. When we corrected how
defence adds up, judo throws started landing twice as often (ippon went from 40% of
bouts to 72%, against a real senior World Championships figure of 46.2% ippon). So
judo, as we have it, has no real way to stop a throw. We drafted twelve judo and
sambo escapes and defences from general knowledge. **Every one is unverified.** They
are listed below.

## PART A — THE QUESTIONS

1. **The jab's share of all punches THROWN in professional MMA** (not landed). We have
   35% for amateur boxing. Is there an MMA figure (UFC stats, FightMetric/UFCStats,
   academic studies of UFC bouts)?
2. **Per-technique frequency in MMA bouts.** How much more often is a jab thrown than
   a cross, a hook, an uppercut, an overhand, a spinning back fist, an elbow, a knee?
   Any published per-technique breakdown, even from a sample of bouts.
3. **Kicks by target in MMA/UFC.** Of all kicks THROWN, what share target the leg,
   the body and the head? (We have leg strikes as 14–18% of LANDED significant strikes;
   we need the split within kicks, and thrown versus landed if published.)
4. **Kickboxing and muay thai: a CompuBox-style breakdown per technique.** Jab, cross,
   hook, uppercut, teep, low kick, body kick, head kick, knee, elbow (muay thai),
   clinch knees. Thrown and landed if available. Glory, ONE, K-1, Lumpinee/Rajadamnern
   studies, sports-science papers.
5. **Is the distribution flat anywhere?** Any source showing that in some ruleset
   techniques ARE thrown roughly equally — or confirming that real output is always
   dominated by a few basic techniques.

## PART B — VERIFY THESE TWELVE DRAFTS

For each row: **(a)** is it a real, named technique in that art, and is the name
right (give the correct romaji or Russian term and a source); **(b)** for an escape,
which hold(s) it really escapes; for a defence, what it really stops — a throw
landing, a grip, or only the damage of the fall; **(c)** is it a beginner or an
intermediate technique (Kodokan / IJF grading syllabus for judo, FIAS or national
sambo syllabus for sambo); **(d)** would you replace or drop it, and what is missing
that every judoka or sambist is taught.

| id | name as drafted | art | kind | drafted to answer |
| --- | --- | --- | --- | --- |
| judo_esc_kesa_nuke | Kesa-gatame Escape (scarf hold break) | judo | escape | kesa-gatame |
| judo_esc_yoko_nuke | Yoko-shiho-gatame Escape (side control break) | judo | escape | yoko-shiho-gatame |
| judo_esc_kami_nuke | Kami-shiho-gatame Escape (north-south break) | judo | escape | kami-shiho-gatame |
| judo_esc_tate_nuke | Tate-shiho-gatame Escape (mount break) | judo | escape | tate-shiho-gatame |
| judo_taisabaki_defense | Taisabaki (body evasion from throws) | judo | defence | standing throws |
| judo_kumi_defense | Kumi-kata Defence (grip fighting) | judo | defence | throw set-ups, standing and clinch |
| sambo_esc_bridge | Bridge Escape from Pin | sambo | escape | hold-downs |
| sambo_esc_frame_roll | Frame and Roll from Pin | sambo | escape | hold-downs |
| sambo_esc_leglock | Leg Lock Entry Escape | sambo | escape | straight ankle lock, kneebar entries |
| sambo_esc_shrimp | Hip Escape (Shrimp) from Pin | sambo | escape | hold-downs |
| sambo_throw_defense | Throw Defence (anti-throw base) | sambo | defence | standing throws |
| sambo_grip_break_defense | Grip Break Defence | sambo | defence | throw set-ups, standing and clinch |

**And three direct questions, because today's finding turns on them:**

6. **Does ukemi stop a throw from landing, or only protect the man who falls?** And
   under current IJF rules, can the way a man lands (side instead of back, rolling
   through) change the SCORE of a throw that has already happened — and which escapes
   from a landing are penalised (for example head defence, bridging)?
7. **What actually stops a judo throw before it lands?** Name the real defences taught
   and used at elite level — for example blocking with the hips, stepping around,
   grip breaking, counter-throws (kaeshi-waza) — with sources, and say which are
   defences and which are counter-attacks.
8. **Sambo's rules for hold-downs and escapes**: how long a hold-down must be held to
   score in FIAS sport sambo, and whether escaping one has any rule of its own.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM: DOCUMENTED** (published source, named and linked),
**INFERENCE** (your reasoning, and from what), or **NOT FOUND** (you looked and it is
not published — a perfectly good answer and we want it explicitly).

**DO NOT INVENT A NUMBER.** Part A goes straight into a fight engine as weights. A
fabricated share is far worse than NOT FOUND, because it will be typed into a table
and defended for months as though it were measured. A study on this project once
concluded a whole category of animation did not exist anywhere, and a ten-euro
listing disproved it the same day — so search properly, then say what you searched.

**DISTINGUISH THROWN FROM LANDED** in every Part A figure. They are different
statistics and we have been burned by the difference.

**LEAD WITH A DECISIONS BLOCK:** one line per Part A question with its best figure
and label, then one line per Part B row: KEEP / RENAME to X / DROP / REPLACE with X.
Everything else underneath.

## DELIVERY

You have no checkout. **Reply in the chat; Claude collects it and writes
`research/J27_FREQUENCIES_AND_THROW_DEFENCE.md`.** No git command, no test
command, no repo path.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real regardless:
Claude collects the answer and writes the file below. Naming it here is what lets
`python Tools/agent_comms.py done --task J27` mean *"has this been collected yet?"*
rather than passing on nothing.

- `research/J27_FREQUENCIES_AND_THROW_DEFENCE.md`

**The agent is not asked to create it and must not be given a git command.**
