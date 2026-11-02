# Undisputed study (S254) - numbers and rules only, nothing copied

Operator S254 (verbatim): "also you can rea on undisputed (animations logic etc) , assign maybe ziva to help with this. Will this help us?"
Same terms as the Two Point Museum study (S243, "we are not copying anything do it"): his own install, numbers/rules/structure only,
raw dumps stay in `E:\FightCamp\tmp\undisputed_study` (outside the repo), no asset, clip or code ever enters FightCamp.

## Tool decision
- Install: `E:\SteamLibrary\steamapps\common\Undisputed` = **Unity, IL2CPP** (GameAssembly.dll + global-metadata.dat), 15,223
  Addressable bundles, 16.3 GB (`StreamingAssets/aa/StandaloneWindows64`).
- REA (github.com/morluto/rea, MIT, Node MCP toolkit) is built for native binaries via Ghidra/IDA/Hopper (Windows Ghidra "experimental"),
  .NET, JS, APK. For an IL2CPP Unity game it would decompile GameAssembly.dll the slow way. The S243 TPM route reads the same thing
  directly: names from global-metadata.dat + UnityPy 1.25.3 (installed) on the bundles. Decided: TPM route; REA not installed.
- Ziva is a Godot playtest seat (MCP on wt/ZIVA, offline this session) - it cannot read a Unity game. Not assigned.

## Pass 1 (names, 2026-10-18) - `tmp/undisputed_study/names_pass.py`
162,162 identifiers. Hits: Punch 1141, Stance 1270, Block 939, Anim 821, Blend 758, Career 749, IK 346, Corner 337, Stamina 331,
Damage 305, Counter 299, Combo 253, Clinch 229, Hook 224, Recovery 222, Knockdown 217, Jab 179, Uppercut 158, Weave 149, Slip 137.
Systems they model that we should benchmark against (names only):
- Block as a depleting resource: `BlockHealthRecovery`, `CalculateBlockHealthRecovery`, `GuardingResistance`, `StackGuard`.
- Stamina-gated stun: `heavyPunchStunStaminaThreshold`, `StunReset`, `DazedRecovery`, `TakeAKnee`.
- Feints with timing: `feintDelay`, `FeintBlockDelay`, `OnOpponentPunchFeinted`, `ComboStep_Feint`.
- Windup contact poses: `WindupPoseContactOffsets`, `forcedWindupStartPoint` (punch reach solved per pose).
- Corner between rounds: `CornerRecoveryTimeout`, `CutmanRecoveryBonus`, `CORNERMEN_RECOVERY_EVENT_NAME`, `BruiseAndCutRecovery`.
- Career injury: `AttemptInjuryQuickRecovery`, `CPU_RECOVERY_WEEKS`.

## Will it help? (answer to the operator)
Yes, as a benchmark, not as a source: it gives real shipped numbers for punch timing (clip length, the hit-frame event time, recovery),
block/stamina/stun thresholds and corner recovery - exactly the values we otherwise ask Ludo/research to guess ("benchmark real-world
numbers" rule). It does not fix our clips: their animation is their mocap and never ships here.

## Pass 2 (done 2026-10-18) - punch timing from the clips' own events
`tmp/undisputed_study/clips_pass.py` (UnityPy, FALLBACK_UNITY_VERSION 2022.3.45f1 from the data.unity3d header): 15,220 bundles,
3,152 boxing-named AnimationClips, 0 errors, 216 s. Every punch clip carries events at 60 fps: `*_Arm_Attack_On` (hitbox live),
`ResetFeint` (last moment it can still become a feint), `ExpectedImpact`, `*_Arm_Attack_Off`, `PunchComplete` (control back to the
player/AI; the clip keeps playing and blends out), plus `VulnerabilityOn/Off` (the counter window), `EnablePunch`, `ResetStun`,
`SetFlinchBlendValue`, `RagdollOn` on KO clips. Clip names show MxM (Motion Matching) and per-boxer sets (named pro boxers).
Medians, seconds from clip start (`timing_table.md`):

| punch | target | clips | attack_on | impact (p10-p90) | attack_off | punch_complete | impact->complete |
|---|---|---|---|---|---|---|---|
| jab | head | 76 | 0.256 | 0.365 (0.21-0.68) | 0.419 | 0.491 | 0.116 |
| jab | body | 38 | 0.343 | 0.451 (0.18-0.93) | 0.515 | 0.596 | 0.125 |
| cross | head | 42 | 0.350 | 0.501 (0.18-0.93) | 0.562 | 0.636 | 0.174 |
| cross | body | 28 | 0.312 | 0.517 (0.24-0.78) | 0.553 | 0.596 | 0.113 |
| hook | head | 106 | 0.383 | 0.534 (0.27-1.10) | 0.585 | 0.723 | 0.151 |
| hook | body | 45 | 0.259 | 0.450 (0.27-0.81) | 0.502 | 0.581 | 0.124 |
| uppercut | head | 54 | 0.326 | 0.489 (0.21-0.96) | 0.572 | 0.690 | 0.167 |
| uppercut | body | 25 | 0.227 | 0.357 (0.24-0.55) | 0.456 | 0.524 | 0.165 |

### Against ours (`assets/data/clip_phases.json`, contact_s / recover_s)
- jab 0.25 / 0.667, cross 0.30 / 0.65, hook 0.417 / 0.983, jab_body 0.458 / 1.833, body_hook 0.70 / 2.08, rear_hook_body 0.58 / 1.70.
- IMPACT: our head punches land a little EARLIER than theirs (jab 0.25 vs 0.365) - inside their p10-p90, fine.
- RECOVERY is the big gap: they hand control back 0.11-0.17 s after impact (PunchComplete) and blend the clip's tail out under the
  next action; we hold the fighter until recover_s = 0.42 s (jab) to 1.4 s (body jab, body hook) after contact. That is 3-10x longer
  locked per punch - the likeliest cause of stiff, one-at-a-time exchanges.
- Body shots: ours are much slower to land (body hook 0.70 vs 0.45; jab body 0.46 vs 0.45 ok) and far slower to recover.
- A feint is decided by a cut-off inside the punch (ResetFeint ~0.05-0.1 s before impact), not a separate move.
Next: a verdict for Ludo (lead designer) - adopt "control returns at impact + ~0.13 s, tail blends out" for the boxing palette and
an Attack_On..Off hit window; then a brief with a red-on-master test on clip_phases recover gaps. No numbers change before his verdict.
UnityPy over the bundles: every AnimationClip named like a punch/block/slip/hit-react -> length, frame rate, `m_Events` (time + function
= the hit/impact frame), root-motion distance; config MonoBehaviours (raw if the type tree is stripped) for the names above.
Output: one table `punch -> windup / impact / recovery seconds` beside our C223 moves and FightRealtime numbers. Heavy read (16 GB): run
at idle priority on a GREEN watchdog, one process.
