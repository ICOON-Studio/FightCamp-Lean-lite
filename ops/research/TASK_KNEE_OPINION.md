# THE KNEE QUESTION — ONE JUDGEMENT, ASKED OF TWO AGENTS BLIND

**Owner:** codex, dola - each blind of the other.

**This is not a build task. It is one decision, and the operator asked for your
opinion on it.** Answer in your reply; write no code and change no file.

**Another agent is being asked the SAME question without seeing your answer,
and you will not see theirs.** Answer it yourself and fully. If you think the
question is wrong, say that instead of picking one of the options.

## The rule this is about

`Godot/scripts/FightStance.gd` implements one design ruling, quoted in the file
verbatim:

> **"Same-stance vs open-stance flips which hand is the 'long' hand and which
> body kick is free."**

Orthodox vs orthodox is a **CLOSED** matchup. Orthodox vs southpaw is **OPEN**.
In an OPEN matchup the module applies a small weight to what a fighter REACHES
FOR — never to damage:

- the **jab** is DRAGGED (`1.0 - 0.06`) because it has to cross the body;
- the **rear hand** is FREED (`1.0 + 0.08`) because it is on the short line;
- the **body kick** to the open side is FREED (`1.0 + 0.08`).

The sizes are authored, not measured. K27 refused, by name, to publish a single
"southpaw advantage" figure. **The direction is the claim; the magnitude is
not.**

## What was just changed, and why the question exists

`KICK_MARKERS` contains the word `"knee"`. So until today a knee was classified
through the KICK branch, and that branch **also required an effect key
containing `body`, `liver` or `torso`** before it counted at all.

The operator's words: **"fix that, why you restrict where a knee lands?"** —
i.e. a knee to the head or the thigh was silently exempt, and a knee was being
called a body kick, which it is not.

It now has its own family and gets the FREED side with no target test. **That
is what is in question.**

## The three facts that make it hard

1. **NO KNEE NODE CARRIES LEAD/REAR DATA.** The catalogue has a `match.limb`
   field with values `lead_hand` (15 nodes), `rear_hand` (34), `lead_leg` (6),
   `rear_leg` (9) — **64 of 696 nodes**. Of **37 knee nodes, ZERO** have it. So
   giving every knee the FREED side assumes every knee is a REAR knee. That is
   an assumption, not a measurement.
2. **MOST KNEES ARE CLINCH TECHNIQUES.** `muay_thai_clinch_knees`,
   `kickboxing_clinch_knee`, `muay_thai_knee_curfew`,
   `muay_thai_khao_chiang`... The open-stance advantage is about REACH AND
   LINE at kicking range. **Chest to chest in a tie-up, does that geometry
   still mean anything?**
3. **The catalogue DOES carry `match.phases`** (`standing` 483, `clinch` 153,
   `ground_top` 53, `ground_bottom` 52, `scramble` 15), so a phase-dependent
   answer is derivable if you think it is the right one.

## The question

**What should a knee get in an OPEN matchup?**

- **A.** Neutral unless `limb` is authored — keep the knee family so it is never
  miscalled a kick, but apply no weight while the side is unknown.
- **B.** The freed side for every knee, as built now.
- **C.** Split by phase — freed at kicking range, neutral in the clinch.
- **D.** Something none of these say.

**Give your answer, then the ONE reason that decides it for you, then the
strongest argument AGAINST your own answer.** That last part is the point of
asking two of you.

## What would change your mind

Say what evidence would flip you. If your answer depends on a fact nobody has
measured, **say which fact** — that becomes a research task rather than a guess.

## The trap

**Do not reason from "a knee is a kick" or "a knee is not a kick".** That is an
argument about vocabulary. The ruling is about a HIP AND A LINE: which side can
come through freely when two men lead with different feet. Reason from that.
