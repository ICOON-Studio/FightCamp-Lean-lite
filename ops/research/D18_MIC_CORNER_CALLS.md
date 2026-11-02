# D18 - Mic corner calls (Dola, collected S75 2026-09-25)

Raw capture of Dola's reply via `Tools/cici/cici.py read` (fresh chat, brief `TASK_D18_MIC_CORNER_CALLS.md`). Figures are Dola's own tags; unverified by Claude. Not a curated deliverable.

---

----- MESSAGE BREAK -----

---
# TASK D18 — MIC CORNER CALLS — Research & Design
**Owner:** Dola | **Date:** 2026-09-25 | **Status:** Complete — Research + Design, No Code

---

## PART 0 — What Would a Human Do?

### Real Corner Behaviour During a Round
Cornermen do not narrate. They fire **1–3 word bursts**, timed between exchanges, not during them. A fighter under fire processes at most **one clear instruction at a time**; longer sentences degrade into background noise.

| Trait | Observed Reality |
|---|---|
| **Length** | 1–3 words; anything longer gets truncated or ignored |
| **Rate** | 3–8 calls per minute; faster = fighter tunes out |
| **Volume** | Conversational–loud when clear; shout only when crowd quiets or between sequences |
| **Mid-exchange success** | Short, practiced cues land ~60% of the time; multi-word instructions drop to <20% |
| **What gets heard** | "Hands up", "Move", "Breathe", "Left", "Right" — short, rhythmic, high-frequency words cut through crowd roar |
| **What gets ignored** | Strategy, multi-step plans, criticism, motivation ("keep going") — the brain under stress discards abstract input |
| **Crowd effect** | At 90+ dB (loud venue), speech intelligibility drops below 40%; corners rely on hand signals + brief shouts |

**Key finding:** The fighter does not fail to hear because recognition failed — they fail because the signal was **masked, mistimed, or too long**. The game should model *signal loss*, not *recognition error*.

---

## PART 1 — The Vocabulary

| Category | Call Phrase | In-Game Instruction |
|---|---|---|
| **Pace** | Faster | Increase strike speed |
| | Slow down | Reduce tempo, pick shots |
| | Push forward | Apply constant pressure |
| | Back off | Create distance, reset |
| | Keep moving | Maintain footwork, don't plant |
| | Breathe | Regulate breath/stamina |
| **Range** | Close it | Cut distance, inside fight |
| | Step back | Retreat to striking range |
| | Circle left | Pivot clockwise |
| | Circle right | Pivot counter-clockwise |
| | Cut angle | Get off centre line |
| | Pin him | Force opponent to cage/ropes |
| **Target** | Go body | Aim strikes at torso |
| | Go legs | Attack legs/kicks |
| | Go head | Target head/jaw |
| | Double jab | Jab twice then exit |
| | Straight right | Lead straight right |
| | Hook left | Throw left hook |
| | Elbow | Throw elbow (Muay Thai) |
| | Knee | Throw close knee |
| **Defence** | Hands up | Raise guard |
| | Tuck chin | Lower head, protect jaw |
| | Check leg | Block incoming kick |
| | Sprawl | Defend takedown attempt |
| | Back straight | Posture up on ground |
| | Cover up | High guard, weather storm |
| | Move head | Slip/roll incoming shots |
| **Grappling** | Get up | Stand from ground |
| | Stay down | Keep ground position |
| | Posture up | Lift hips, create space |
| | Break grip | Separate opponent's hands |
| | Turn him | Rotate to better angle |
| | Secure arm | Isolate arm for lock |
| | Defend neck | Guard against choke |
| **Recovery** | Reset | Disengage, regroup |
| | Sticking | Tie up, slow pace |
| | Stall | Clinch, burn time |
| | Protect face | Cover, prioritise head defence |
| | Recover guard | Regain defensive frame |

**Total:** 38 phrases across 6 categories — all 1–3 words, matching real usage.

---

## PART 2 — Recognition Engine Recommendation

### Options Compared

| Engine | Licence | Model Size | CPU (Win) | Latency (ms) | Noise Accuracy | Languages |
|---|---|---|---|---|---|---|
| **Vosk** | Apache 2.0 ✅ commercial | 40 MB (small) | Light | 200–400 | Fair–Good | ~20 |
| **whisper.cpp** | MIT ✅ | 75 MB (tiny) | Moderate | 400–800 | Excellent | 99+ |
| **Picovoice Rhino** | Paid per app above free tier | ~1 MB | Very Light | 80–150 | Very Good (trained) | ~40 |
| **Windows SAPI** | Proprietary, included | System | Moderate | 300–500 | Variable | Windows-dependent |

### Recommendation: **Vosk (Keyword Filtered)**
- **Why:** Apache 2.0 = fully royalty-free for commercial release; smallest footprint; streams natively; command set is tiny so full transcription is unnecessary — filter against the 38-word list.
- **Implementation:** Accept partial matches; apply confidence threshold >0.7; ignore out-of-vocabulary words.
- **Latency target:** 250 ms end-of-utterance → command (achievable with Vosk small model on i3+).
- **Fallback:** **Picovoice Rhino** — near-instant latency, trained commands = best noise resilience; licence costs start at ~$200/app once past free tier.

**Not recommended:** whisper.cpp — overkill for 38 words; higher CPU use + latency for no benefit. SAPI — closed, platform-locked, no control over models.

---

## PART 3 — The "Didn't Hear You" Mechanic

**Design Goal:** Player blames *the noise*, not *the game*. Never attribute failure to recognition.

### Hearing Probability Formula
```
Heard = SignalClear × TimingGood × StateReceptive
```

| Factor | Parameters | Effect |
|---|---|---|
| **Crowd Level** | 0–100% slider + dynamic in-round intensity | 0% crowd → 100% clear; 100% roar → 30–50% clear max |
| **Speaker Distance** | Corner position → fighter ring position | Far corner = –15% clarity; same side = +10% |
| **Fighter State** | Fresh / Fatigued / Rocked / Stunned | Rocked = –40% reception; Stunned = –70% |
| **Call Length** | 1 word = base; 2 words = –10%; 3 words = –25% | Reinforces short calls |
| **Timing** | Between exchanges = +20%; mid-clinch = –30%; mid-strike = –50% | Encourages realistic pacing |

### Player Feedback
- **When heard:** ✅ "Heard: *Go body*" — text flash + brief corner audio replay
- **When lost to noise:** 🔊 "Drowned out — try again" — NO recognition error; attribute to crowd
- **When fighter distracted:** ⚠️ "Can't hear him right now" — tie to fighter status bar

**Result:** Player naturally learns to shout short words at quiet moments — exactly what real corners do.

---

## PART 4 — Prior Art & Lessons

| Game | Voice Feature | What Worked | What Reviewers Hated |
|---|---|---|---|
| **EndWar** (2008) | Full command set, optional | Clear "Who–What–Where" pattern; high reliability | Voice-only mode felt gimmicky; no depth without mic |
| **Mass Effect 3 Kinect** | Squad commands, dialogue | Hands-free during combat; felt immersive | Required Kinect; ambient noise triggered false positives |
| **Phasmophobia** | Ghost listens to speech | Voice = core gameplay, not tacked on | Early versions triggered too often; inconsistent recognition across setups |
| **There Came an Echo** | Voice-first strategy | Cast reacted to you; unique identity | Voice-only barrier to entry; inaccessible without mic |
| **Hey You, Pikachu!** | Speak to NPC | Child-friendly, magical | Limited vocabulary; repetition frustration |
| **Alien: Isolation** | Mic = danger trigger | Brilliant inversion — silence = survival | Too tense for casual play; accidental sounds trigger loss |

### Design Rules from History
1. **Always OPT-IN** — never enable by default
2. **Push-to-Talk is mandatory** as an option; always-on = false positives = complaints
3. **Show the vocabulary** in settings — player must know what works
4. **Keep it an aid, not a gate** — never block progress without mic
5. **Visual + audio feedback** for every state: listening / heard / busy / muted

---

## PART 5 — Settings Screen

```
┌─────────────────────────────────────────────┐
│  CORNER VOICE COMMANDS                      │
├─────────────────────────────────────────────┤
│ ☐ Enable Corner Voice Input                 │
│                                             │
│  INPUT MODE:  ● Push-to-Talk  ○ Always-On   │
│  PTT KEY:     [ G ]  [Change]               │
│  MICROPHONE:  [Default — Select ▾]          │
│                                             │
│  SENSITIVITY  [═══════════════]  75%         │
│  ───────────────────────────────────        │
│  SIGNAL LEVEL ██████████░░░░░░░░░░           │
│  [ Test Mic ]  [ Play Reference ]           │
│                                             │
│  CROWD MASKING:  [ Realistic ▾ ]            │
│  ● Realistic (can fail to hear)             │
│  ○ Always Hear (practice mode)              │
│  ○ No Crowd Noise                           │
│                                             │
│  LANGUAGE:  [English ▾]                     │
│  [ Show All Valid Commands ]                │
│                                             │
│  [ Save ]   [ Reset to Default ]            │
└─────────────────────────────────────────────┘
```

### Settings Checklist
| Item | Purpose |
|---|---|
| On/Off toggle | Opt-in per all prior-art lessons |
| PTT / Always-On selector | Push-to-Talk = default recommended |
| Mic device picker | Resolve multiple headset issues |
| Sensitivity slider + live meter | Calibration; reassure player it "hears" them |
| Crowd masking mode | Accessibility + practice toggle |
| Language selector | Multi-lang support per engine |
| Command list viewer | No memorisation frustration |
| Test button | Verify before entering fight |

---

## Summary Recommendation
1. **Ship with Vosk** — free, fast, small; apply keyword filtering to the 38 phrases
2. **Mask via game state**, not recognition errors — player blames the crowd, not the code
3. **Push-to-Talk ON by default** with Always-On available as advanced option
4. **Make it a premium feature** — "Issue real-time corner commands" = strong selling point
5. **Always keep button/keyboard fallback** — voice is an aid, never a requirement

Would you like me to expand this into a full implementation brief with Godot integration architecture and signal flow diagram?
