# Operator-pasted recipe (2026-09-30, S131): a physics-based RL boxing agent (AMP / Motion VAE) in Godot

Asked: "would it be a good idea you deploy one of your AI boxing agent trained on realistic MoCap data ... control a
physics-based humanoid character inside a simulation environment in godot and follow the ideas in this plan" + "how to
prompt claude to make such an agent". The pasted plan (AI-written, "AI Mode reply"), summarised faithfully:

1. Data preparation: features per frame (linear/angular velocities of feet, hips, shoulders, fists; glove-to-chin distance;
   COM-to-opponent distance; binary foot/hand contact flags) + phase labels (Anticipation -> Strike -> Impact -> Recovery).
2. Architecture: Adversarial Motion Priors (AMP) or Motion VAEs - a policy network outputs joint torques; a discriminator
   compares its motion against the MoCap set and penalises non-human motion (e.g. sliding without stepping).
3. Reward = w1 R_style + w2 R_defense + w3 R_offense - w4 R_fatigue (style = discriminator fooled; defense = gloves near
   the face colliders / head out of the punch path; offense = fast hand colliders on legal hitboxes; fatigue = squared
   torques).
4. Curriculum: mimicry (shadowboxing) -> static bag -> scripted slow-jab sparring -> self-play.
5. Frameworks: NVIDIA Isaac Gym, Unity ML-Agents, DeepMind Control Suite / MuJoCo.
6. A "master prompt" template for Claude: environment/state wrapper, PD-controlled torque action space with joint limits,
   compute_reward() with imitation/defense/offense/energy terms, PyTorch PPO actor-critic.

## Grading (Claude, S131)
RIGHT
- It is the research frontier for simulated fighters (closest precedent known to Claude: Won, Gopinath & Hodgins,
  SIGGRAPH 2021, physically simulated boxing/fencing with a motion prior - believable exchanges, loose and stumbly motion).
- Much of it already exists here under other names: phase labels = C223 onset/impact/recovery rows; "is it human?" =
  the C223 gates (numbers + game/side stills); contact flags = foot lock + G147 clipping rows; fatigue = the engine's.
FAILS FOR FIGHTCAMP (project facts)
- Godot has no GPU-parallel physics for RL training; training would happen in Isaac/MuJoCo and the policy would have to
  run on Godot's physics (sim-to-sim gap) with an inference runtime per fighter. D1: stay in Godot (measured).
- FightCamp's outcomes come from the stats-driven engine calibrated on real records (BoxRec 47%, KO/TKO bands, G99 CompuBox
  shape). A physics policy decides outcomes itself - the calibration, i.e. the management game, would be lost.
- Data: AMP needs hours of clean boxing mocap; we hold minutes (38 min paired 3D mocap, mostly not boxing-grade).
- PC: days of GPU training vs the known thermal limit (project_pc_thermal_limit); two-agent cap.
- Time: the demo is 2026-10-06; this is a months-long research bet.
- Physics where it clearly pays is already in: hit reactions (Kickback active ragdoll).
HOW CLAUDE WOULD RUN IT (post-1.0 research, not a replacement)
- Physics as an OFFLINE clip cleaner: a public physics tracker (PHC / ProtoMotions, surveyed in G77) tracks our
  retargeted clips to remove foot skate and interpenetration, then bakes back to ordinary clips for the existing player.
- Needs its own brief: simulator + licence (MaskedMimic CC BY-NC-SA; ProtoMotions parts Apache-2.0; AMASS data licence),
  GPU/OS requirements, a 3-clip A/B against the C223 rows.
VERDICT: not for the demo or v1; a candidate research item after 1.0. Operator's call (engine/architecture scope).
