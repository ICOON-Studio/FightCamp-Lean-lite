# C97 — Counter Reconciliation

**Counts:** ROLE IS RIGHT **7** · TAG IS RIGHT **11** · BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM **14** · UNDECIDED **0** · TOTAL **32**

The largest finding is taxonomic: nine supposed “role-only” cases already have `counter_throw` or `counter_takedown`, but those plainly counter-specific tags are absent from the nine-name counter-tag set. More generally, the data uses `counter` for at least four different ideas: the action itself, reactive timing, readiness for a later action, and a multi-action response chain.

## ROLE IS RIGHT (7)

- **`boxing_shoulder_roll` — ROLE IS RIGHT:** A shoulder roll is a defensive evasion that creates a counter opportunity; `counter_ready` is a secondary consequence, not the action itself.
- **`judo_grip_break_counter` — ROLE IS RIGHT:** Breaking or changing an opponent's grip is an adaptive grip-fighting skill that prepares a later counter, so `counter_ready` does not make the break itself a counter.
- **`karate_gyakuzuki` — ROLE IS RIGHT:** Gyaku-zuki is a straight reverse punch that can attack or counter; its core identity here is damage and `counter_accuracy` describes one situational strength.
- **`karate_yokogeri` — ROLE IS RIGHT:** Yoko-geri is a damaging side kick that can serve as a stop-hit, but that application does not make every side kick a counter.
- **`sanda_leg_catch_read` — ROLE IS RIGHT:** Reading kick timing is an adaptive perceptual skill that enables a kick counter rather than being the countering action.
- **`capoeira_esquiva_read` — ROLE IS RIGHT:** Esquiva is evasive defense and the read creates counter readiness; the tag describes what may follow the defense.
- **`silat_pasang` — ROLE IS RIGHT:** Pasang is a guard posture whose readiness supports later counters, while the posture itself remains defense.

## TAG IS RIGHT (11)

These verdicts recommend a role change and therefore an expensive fight-behavior rebaseline.

- **`boxing_rear_uppercut` — TAG IS RIGHT:** A rear uppercut thrown without first answering an attack is an ordinary damaging punch, so the absent counter tag is correct and the role should change to `damage`.
- **`kickboxing_spinning_back` — TAG IS RIGHT:** A spinning back kick can be used proactively or reactively and is not intrinsically a counter, so the role should change to `damage`.
- **`karate_uramawashi` — TAG IS RIGHT:** Ura-mawashi-geri is a hook/reverse-round kick, not a counter by definition, so its angle and head-damage tags support changing the role to `damage`.
- **`tkd_dwichagi` — TAG IS RIGHT:** Dwi-chagi is often an effective counter but can also be initiated cold, so the technique itself is a damaging turning kick and the role should change to `damage`.
- **`tkd_spinning_hook` — TAG IS RIGHT:** A spinning hook kick is a high-damage finishing attack rather than inherently a response, so the role should change to `damage`.
- **`savate_revers_fouette` — TAG IS RIGHT:** Revers fouetté is an angled reverse kick whose sporting identity does not require an opponent's attack, so the role should change to `damage`.
- **`capoeira_bencao` — TAG IS RIGHT:** Benção is a direct pushing kick usable as an initiative attack, so pushback and body damage fit better than a mandatory counter role and the role should change to `damage`.
- **`capoeira_meialua` — TAG IS RIGHT:** Meia-lua de compasso is a powerful deceptive spinning kick, not necessarily a response, so the role should change to `damage`.
- **`arnis_punyo` — TAG IS RIGHT:** A punyo strike is a close-range butt-end strike that can be initiated outside a counter exchange, so the role should change to `damage`.
- **`arnis_disarm_chain` — TAG IS RIGHT:** A Block-Counter-Disarm Chain is explicitly a reactive counter sequence culminating in a disarm, so `counter_chain` is primary and the role should change from `adaptation` to `counter`.
- **`silat_complete_response` — TAG IS RIGHT:** A Pasang-Parry-Strike-Guntingan Response is explicitly triggered by an attack and delivers the answering chain, so the role should change from `adaptation` to `counter`.

## BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM (14)

- **`bjj_submission_chain` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Switching armbar to triangle to omoplata adapts to defensive reactions while punishing those reactions, so `adaptation` and `reaction_punish` describe different dimensions of the same chain.
- **`judo_uranage_counter` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Ura nage used against an opponent's throw is genuinely a counter and already has `counter_throw`; the mismatch exists only because that tag is excluded from the counter-tag set.
- **`tkd_cut_kick` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** The cut kick intercepts and disrupts an opponent while resetting distance to set up the next exchange, so reactive timing and setup function are both accurate.
- **`sanda_catch_dump` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Catching an incoming round kick and dumping the kicker is intrinsically a counter takedown, and `counter_takedown` already agrees with the role but is missing from the counter vocabulary.
- **`sanda_sweep_counter` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** A low sweep counter is a reactive takedown and already carries `counter_takedown`; the declared counter-tag set creates the disagreement.
- **`sambo_counter_throw` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** A counter-throw answers the opponent's throw or grip action and already carries `counter_takedown`, so the role and sporting meaning agree.
- **`sambo_counter_hip_toss` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** A counter hip toss is definitionally reactive and already has `counter_throw`, which the counter-tag vocabulary fails to recognize.
- **`capoeira_rasteira` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Rasteira's result is a takedown while its characteristic sporting use is a timed sweep under an attack, so `takedown` and `counter_timing` encode outcome and timing rather than competing labels.
- **`capoeira_flow_chain` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Flowing from ginga and esquiva through sweep and kick adapts across the exchange while forming a counter chain, so one flat role cannot express both sequence logic and reactive purpose.
- **`capoeira_negativa_sweep` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Dropping into negativa and answering with rasteira is a counter takedown, and its existing `counter_takedown` tag is simply outside the declared counter-tag set.
- **`silat_catch_dump` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Catching an incoming kick and completing jatuhan is inherently a counter takedown, already expressed by `counter_takedown` despite that tag's exclusion from the vocabulary.
- **`pencak_silat_catch_kick_takedown` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** The move cannot occur without first catching the opponent's kick and already carries `counter_takedown`, so role and tag semantics agree.
- **`mma_sprawl_fronthead` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Sprawl-to-front-headlock is simultaneously takedown defense, a counter to the shot, and a transition into control, exposing incompatible action/timing/outcome meanings in one role field.
- **`mma_kick_catch_slam` — BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM:** Catching an incoming kick and slamming is intrinsically a counter takedown and already has `counter_takedown`; only the narrow tag whitelist makes it appear role-only.

## Recommendation

Before changing roles, expand or rename the counter vocabulary so `counter_throw` and `counter_takedown` are classified, and separate counter **action**, **timing**, **readiness**, and **chain** semantics. Then rebaseline only the 11 TAG IS RIGHT rows; the 7 ROLE IS RIGHT rows need tag clarification/removal, and the 14 vocabulary rows should not be forced into a single-label correction.
