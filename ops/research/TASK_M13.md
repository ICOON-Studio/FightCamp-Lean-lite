# TASK M13 — MARIA — THE FIGHT SCREEN THAT MUST NOT PICK A PUNCH

**Model: Maria, Expert. Art direction only — no code, no test, no engine work.**
Owner: Maria. Assigned 2026-09-10 by Claude.

You have no checkout and no Godot. Everything you need is in this file. Do not
ask for the repository and do not write GDScript. Return the direction as plain
markdown in your reply, with any boards or images attached; Claude commits the
document as `research/M13_THE_FIGHT_SCREEN.md`.

## The constraint you are designing inside, and it is unusual

Our fight is a simulation running twenty times a second. It is authoritative:
the judges score what it did, and a picture that shows a different fight is a
bug even if it looks better.

Two studies landed today that fence this in hard:

- **We will not draw most punches.** A bought animation clip runs about 0.82 s
  per punch; the engine can land two 0.35 s apart. The live animation unit is
  short single punches and hit-reactions, cut and layered — not combinations.
- **Tight contact is a CLAIM.** A wide shot during an exchange is honest,
  because distance and stance are still true. A trunks-up close-up of a clean
  hook the engine scored as a *glance* is a lie. So is a face insert of a cut we
  have no data for, and so is a stun cam when no stun was applied.

The rule that came out of it: *wide, corner, labelled replay and the HUD are
summaries; tight contact is a claim, and we may only make the claims the engine
already made.*

**So this is a fight screen that is forbidden the shot every fight game leans
on.** That is the design problem, and it is a real one, not a limitation to
apologise for.

## What we have to work with

The engine can tell the screen, truthfully, at any moment: distance and whether
they are in the pocket; six body regions of accumulated damage; a heart rate
(not a stamina bar — that was a first-hand finding from driving a competitor);
discrete pips for cuts and swelling; the ground seat when there is one;
knockdowns; the round and the clock; the three judges' per-round scores; and the
stoppage reason when it comes.

Twelve rigged 3D fighters exist and one animation clip has been proven to play
on all of them.

## What to deliver

### §1 — The frame

How the screen is composed when the default state is a wide shot that does not
pick a punch and the truth lives on the HUD. Where does the eye go? A previous
study found that in every comparable management game the player looks at *what
they can still act on*, not at the fighters — and that the 3D confirms a
sentence the HUD already wrote. Design for that honestly rather than fighting it.

### §2 — The HUD as the second camera

This is the load-bearing half. A heart rate and discrete trauma pips are unusual
instruments and we chose them deliberately over two bars. Show how they read at
a glance, how they change under pressure, and how six body regions become
something a person understands in a fifth of a second without becoming a medical
diagram. Say which of our facts deserve permanent screen presence and which
should appear only when they change.

### §3 — The three moments that ARE allowed to be big

The screen is quiet by rule, which makes its few permitted crescendos matter
enormously: the **knockdown**, the **stoppage**, and the **between-round
minute** (the one interval the sport itself gives us, and where a labelled
replay is honest). Direct those three. They carry the whole emotional load.

### §4 — Reading the fight without seeing every punch

The hardest question and the most valuable answer. What tells a player their
fighter is losing, right now, when they are watching a wide shot and a HUD? Not
a damage number — a *read*. Posture, position in the ring, the corner, the
instruments, pacing, colour. Give us the vocabulary.

### §5 — What you would NOT do

Hold this to the commercial bar you always do — but say plainly which of that
bar is unreachable here and should not be attempted. A cinematic fight camera,
a per-punch impact language, a broadcast package: those are budgets we have
already refused on evidence. Name what to spend instead of them.

## The traps

**Do not design a fighting game's fight screen.** The temptation is a
health-bar-and-impact-flash layout, and it would be wrong twice: wrong for a
management game, and wrong because it would assert per-punch facts we have ruled
we may not assert.

**Second: do not put a stamina bar back.** We looked at a competitor first-hand
and concluded cardio should read as a heart rate and damage should be continuous
bars for attrition plus **discrete pips** for trauma. That was a finding, not a
preference. If you think it is wrong, argue it explicitly rather than quietly
redesigning it.

## Deliverable

One markdown document plus boards, in your reply. No files to push, no git — you
have no checkout, and none of that applies to you. **Name every image you send
back**, so Claude can file them.
