# Q224 Digest - Fatigue You Can Read and a Body That Remembers

**Agent**: Qwen  
**Branch**: `qwen/q224-fatigue-body`  
**Date**: 2026-10-01  
**Task**: `research/TASK_Q224_FATIGUE_AND_BODY_CARRYOVER.md`

## Census Summary

### Fatigue System (GameState.gd)
- **FATIGUE_DELTA**: ring=16, bags=16, strength=14, cardio=12, recovery=-25, rest=-15
- **Cap**: 0-100 (clamped)
- **Thresholds**:
  - >= 80: morale penalty (-2), "tired" flag, "rising" injury risk label
  - >= 85: cannot compete (competition limit)
  - >= 95: 15% injury roll per week (`INJURY_FATIGUE = 95`, `INJURY_CHANCE = 0.15` in TrainingPreview.gd)
- **Recovery**: rest=-15/wk, recovery station=-25/wk (cumulative rounding over 7 days)

### BodyReadiness System (BodyReadiness.gd)
- **Regions**: head_neck, torso_core, left_arm, right_arm, left_leg, right_leg
- **Values**: 0-100, default 100
- **Bands**: green >= 80 (training threshold), amber >= 60, red < 60
- **Cage thresholds**: head=90, torso=85, limbs=80 (per-region)
- **Forecast**: `forecast_region_weeks()` returns weeks to gym/cage threshold per region
- **Fight penalty**: regions below cage threshold block the bout entirely; overall conditioning (derived from all regions) feeds the fighter's rating

### Existing UI
- **Fighter card** (UIKit.week_band): showed "COND X · FAT Y" as plain text
- **Training hub** (TrainingHubPanel): had per-day injury risk preview but no week-level warning
- **Body lab** (ProfileRevampPanel._build_body_lab): showed regions with bars, state chips (SOUND/SORE/HURT), cage ticks, but no weeks-to-clear or fight penalty info

## Deliverables

### 1. Fatigue Meter on Fighter Card (UIKit.gd)
**File**: `Godot/scripts/UIKit.gd` (lines ~3744-3800)

Replaced plain "COND X · FAT Y" text with:
- **Heart icon** (♥) colored by fatigue band:
  - Green (GOOD) when fatigue < 60
  - Amber when 60 <= fatigue < 80
  - Red (BAD) when fatigue >= 80
- **Fatigue gauge bar** using the heat ramp (green→amber→red)
- **Numeric readout** right-aligned
- **Tooltip** (hover over the meter) showing:
  - Current fatigue / 100
  - Per-session breakdown: "RING ×3 = +48 · RECOVERY ×1 = -25"
  - Week forecast: "WEEK: 10 → 96"
  - Warnings when applicable:
    - "⚠ INJURY RISK — 15% ROLL AT FATIGUE 95+"
    - "⚠ HIGH FATIGUE — MORALE PENALTY ACTIVE"
    - "ABOVE 85 COMPETITION LIMIT — CANNOT FIGHT"
  - Recovery rates: "RECOVERY: REST −15/WK · RECOVERY STATION −25/WK"

### 2. Fatigue Warning Banner (TrainingHubPanel.gd)
**File**: `Godot/scripts/TrainingHubPanel.gd` (lines ~293-298)

Added week-level warning banner in `_banner()` when any fighter's forecast ends at fatigue >= 95:
- **Text**: "⚠ INJURY RISK · [NAMES] WILL END THE WEEK AT FATIGUE 95+ · 15% INJURY ROLL · ADD RECOVERY OR REST"
- **Kind**: "bad" (red banner)
- **Priority**: after clearance check, before event night

### 3. Body Lab - Weeks-to-Clear (ProfileRevampPanel.gd)
**File**: `Godot/scripts/ProfileRevampPanel.gd` (lines ~2865-2868, ~2940-2956)

Added to `_fill_regions()`:
- **Forecast computation**: `BR.forecast_region_weeks(athlete, context, 26)` computed once per region set
- **Weeks-to-clear label** for damaged regions (band != "green"):
  - Shows "X WK TO CLEAR" when weeks_to_cage > 0
  - Shows "26+ WK TO CLEAR" (red) when weeks_to_cage < 0 (beyond horizon)
  - Positioned at y=60 in the region cell, below the state chip
  - Colored amber when <= 2 weeks, link blue otherwise

### 4. Body Lab - Enhanced Tooltip (ProfileRevampPanel.gd)
**File**: `Godot/scripts/ProfileRevampPanel.gd` (lines ~3782-3847)

Enhanced `_region_condition_tip()` to accept forecast data and show:
- **Forecast weeks** to gym/cage threshold:
  - "X WEEK(S) OF REST TO REACH TRAINING (80)."
  - "X WEEK(S) OF REST TO REACH CAGE (90)."
- **Fight penalty** (new section):
  - "NEXT FIGHT: BLOCKED UNTIL THIS REGION REACHES [threshold]." (when value < cage_need)
  - "NEXT FIGHT: OPEN, BUT TRAINING IS BLOCKED ON THIS REGION." (when value < train_need)
  - "NEXT FIGHT: THIS REGION DOES NOT BLOCK OR PENALISE." (otherwise)
- **SOUND regions** (value >= train_need):
  - "SOUND — ONLY A BOUT CAN LOWER THIS REGION."

### 5. Test Suite (fatigue_body_read_test.gd)
**File**: `Godot/tests/fatigue_body_read_test.gd`

**17 checks, 0 failures**:
1. **Fatigue schedule math**: 7 ring days from fatigue 10 ends at 26 (FATIGUE_DELTA=16 spread over 7 days with cumulative rounding)
2. **Fatigue warning threshold**: 7 ring days from fatigue 80 ends at 96 (>= 95), injury_risk reports 15% chance and "high (15%)" label
3. **Damaged region weeks-to-clear**: left_arm at 70 has > 0 weeks to cage threshold (got 1), right_leg at 100 has 0 weeks to cage

### 6. Stills Documentation
**File**: `previews/q224/README.md`

Documents what stills should be captured (requires display, not --headless):
- Fatigue meter on fighter card (training hub week view)
- Fatigue warning banner (high-fatigue schedule)
- Body lab damaged region with weeks-to-clear
- Body lab sound region tooltip

## Test Results

### Parse Gate
- `UIKit.gd`: MONO/BEBAS errors are pre-existing (autoload constants not resolved by static analysis)
- `TrainingHubPanel.gd`: PASS
- `ProfileRevampPanel.gd`: PASS
- `fatigue_body_read_test.gd`: PASS

### Test Suite
- **fatigue_body_read_test.gd**: 17/17 checks pass
- **Broader suite** (`--only fatigue,body,readiness,profile,program,smoke,ui_kit`):
  - 18/23 pass
  - 5 failures are pre-existing or environment issues:
    - 4 engine-errors from missing .godot/imported assets (incomplete import cache)
    - 1 fight_body_overlap_test.gd failure (pre-existing penetration detection issue, unrelated to fatigue/body UI)

## Constants Named (per task requirement)

- **INJURY_FATIGUE = 95** (TrainingPreview.gd line 29): fatigue threshold for 15% injury roll
- **INJURY_CHANCE = 0.15** (TrainingPreview.gd line 30): injury roll probability
- **FATIGUE_DELTA** (GameState.gd line 203): per-focus fatigue changes
- **Competition fatigue limit = 85** (GameState.gd line 4981): `fatigue_above_competition_limit` reason
- **Training threshold = 80** (BodyReadiness rules): green band minimum
- **Cage thresholds** (BodyReadiness rules): head=90, torso=85, limbs=80

## Files Modified

1. `Godot/scripts/UIKit.gd` - fatigue meter on fighter card
2. `Godot/scripts/TrainingHubPanel.gd` - fatigue warning banner
3. `Godot/scripts/ProfileRevampPanel.gd` - body lab weeks-to-clear + enhanced tooltip
4. `Godot/tests/fatigue_body_read_test.gd` - new test (17 checks)
5. `previews/q224/README.md` - stills documentation

## Files NOT Modified (per task)

- `HANDOFF.md` - never edited (task instruction)
- `GameState.gd` - no changes needed; existing fatigue/body systems already provide the data

## Notes

- The fatigue meter uses cumulative rounding (same as the actual week tick), so 7 ring days add exactly 16 fatigue (not 7×16=112)
- The forecast in the tooltip comes from `fighter.get("forecast")` which is computed by `forecast_training_week()` in GameState
- The weeks-to-clear uses `BodyReadiness.forecast_region_weeks()` with a 26-week horizon
- The fight penalty is binary: below cage threshold = blocked, otherwise open (the conditioning penalty is already applied through the overall rating)

## S138 (Claude) - merged as a diff; stills rendered on master (Qwen delivered none) and opened
- Q224's "N WK TO CLEAR" line sat 12 px under "CAGE 80" and overlapped it: the weeks now ride on the CAGE line
  ("CAGE 80 · 4 WK", amber at 2 weeks or less, red "26+ WK").
- "⚠" removed from the training banner and the fatigue tooltip (the banner is already red; the glyph is not a game icon).
- Older Body Lab defects seen in the same still, fixed now: the injury dates were a stand line + one line per date (15
  lines for 5 regions, running off the panel) - now ONE line per region, fighting date first, full words kept ("THE GYM
  ESTIMATES ..." - an estimate is attributed, U9); the recovery rows ran past the panel edge ("CONDITIONING N...") - 330 px
  each, label CONDITION as on the header ring.
- Tests: fatigue_body_read_test 17/0, profile_revamp_test 0 failures; stills docs/previews/q224/{week,body_lab,overview}.png.
