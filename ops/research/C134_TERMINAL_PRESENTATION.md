# C134 terminal mount TAP and animated separation

The actual engine TAP event now drives a finite original hand gesture when its actor/target
agree with the displayed mount. It does not pretend the engine identified a choke or armbar.
The raw strangle and generic submission technique binding remain refused.

The existing licensed BodyLock_Loop continues underneath the gesture. No hold was authored.
The losing fighter reaches to the mat in 0.3 s, then makes three 0.4 s hand lifts/returns.
Lift is 0.15 m; the wrist clears the mat by 0.065 m and the glove is oriented palm down.
These are AUTHORED gesture parameters, recorded in `assets/anim/authored/C134_TAP_GESTURE.json`.
The gesture is limited to the inspected f05/f06 rigs; a different rig is not silently certified.

Then the owned BodyLock_End 2.333-4.833 s window plays on both bodies, with the measured horizontal
travel restoration and the mount's facing/offset. Both men rise and separate. A 0.3 s join brings
the tap arm back into that film, followed by a 0.3 s settle that preserves the film's world heading
and eases its horizontal hip displacement into the standing animation. The result prints at TAP;
the terminal presentation continues on its own finite clock without running the engine again.

## Opened evidence and limits

`C134_EVIDENCE/tap-release-a.jpg` and `tap-release-b.jpg`: fixture seconds
0.5, 2.3, 2.5, 2.7, 3.1, 3.5, 4.5, 5.5, 6.1, 6.6, both attacker assignments.
An additional HOME review verified the locked camera holds the entire release.
The close inspection camera crops standing heads at the end; it is deliberately an audition
camera and is not the live HOME shot.

Measured maximum wrist-target error: f06 loser 0.000000246 m; f05 loser 0.000000864 m.
Those are joint-centre solve errors, not mesh clearance measurements. The glove-to-mat placement
was inspected visually. The first release-to-idle trial jumped a joint 1.575569 m in one frame;
preserving the film heading removed it. Current maxima across hips/head/hands/feet are 0.222508 m
(top a) / 0.230533 m (top b), at fixture 5.266667 s, inside the bought rising motion.

These are SCRIPTED witnesses using `FightRealtime._finish_submission`, not natural seed finishes.
The pictures verify the tap cue and separation; they do not fill the missing submission mechanics,
side/guard/half/back films, or the continuous sporting sequence required for overall acceptance.
HOME makes the hand small; the close sheets establish what is moving, not broadcast readability.

The same review exposed coplanar red safety / blue contest slabs flickering across the BJJ mat.
The live room now cuts the inner square out of the outer band's material and raises seam display
by 1 mm. Deck height, colors, specs, MatRig and the engine remain unchanged.

## Reproduce

```powershell
$g = "$PWD/.godotbin/Godot_v4.7.2-stable_win64_console.exe"
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_finish_review.gd -- seed=77321 discipline=bjj
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_finish_review.gd -- seed=77321 discipline=bjj top=b close
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_tap_review.gd -- seed=77321 discipline=bjj
```

Outputs: `.c134/finish-a-*.jpg`, `finish-b-close-*.jpg`, `tap-a-*.jpg`.
Parse gate: 11 files / 0 failures. Focused `--only c134`: **5 tests / 0 failures**.
The terminal witness asserts both rig assignments, no early lookahead tap, actual hand movement,
actual bought release occurrence, finite completion, separated bodies and preserved result.
